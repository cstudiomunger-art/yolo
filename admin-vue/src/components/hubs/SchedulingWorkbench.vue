<script setup>
import { ref, computed, onMounted } from "vue";
import { supabase } from "@/lib/supabase";
import { useRefCache } from "@/stores/refCache";
import { useNav } from "@/stores/nav";

const refCache = useRefCache();
const nav = useNav();

const tab = ref("attractions");
const cityId = ref("");
const search = ref("");
const filterIncomplete = ref(false);
const loading = ref(false);
const error = ref("");
const toast = ref("");

const attractions = ref([]);
const cities = ref([]);

const DURATION_PRESETS = [
  { value: 0.5, label: "0.5 半日" },
  { value: 1, label: "1 标准" },
  { value: 2, label: "2 全日" },
  { value: 3, label: "3+ 远郊" },
];

const VISIT_PERIOD_OPTIONS = [
  { value: "flexible", label: "灵活" },
  { value: "morning", label: "上午" },
  { value: "afternoon", label: "下午" },
  { value: "evening", label: "晚间" },
];

function showToast(m) {
  toast.value = m;
  setTimeout(() => (toast.value = ""), 1600);
}

function cityCenter(cityId) {
  return cities.value.find((c) => c.id === cityId);
}

function schedulingIssues(a) {
  const issues = [];
  if (a.latitude == null || a.longitude == null) issues.push("坐标");
  if (a.duration_slots_min == null) issues.push("时长");
  const cc = cityCenter(a.city_id);
  if (cc && (cc.center_lat == null || cc.center_lng == null)) issues.push("城市中心");
  if (a.is_day_trip && a.duration_slots_min == null) issues.push("远郊缺时长");
  return issues;
}

function completenessLabel(a) {
  const issues = schedulingIssues(a);
  if (!issues.length) return { text: "完整", ok: true };
  return { text: issues.join(" · "), ok: false };
}

async function loadCities() {
  const { data, error: e } = await supabase
    .from("cities")
    .select("id,name,chinese_name,emoji,center_lat,center_lng,display_order")
    .order("display_order");
  if (e) throw e;
  cities.value = data || [];
}

async function loadAttractions() {
  let q = supabase
    .from("attractions")
    .select(
      "id,name,chinese_name,city_id,priority,latitude,longitude,is_day_trip,distance_from_center_km,duration_slots_min,duration_slots_max,recommended_visit_period,planning_zone,is_published,display_order"
    )
    .order("display_order");
  if (cityId.value) q = q.eq("city_id", cityId.value);
  const { data, error: e } = await q;
  if (e) throw e;
  attractions.value = data || [];
}

async function load() {
  loading.value = true;
  error.value = "";
  try {
    await refCache.load();
    await Promise.all([loadCities(), loadAttractions()]);
  } catch (e) {
    error.value = e.message || String(e);
  } finally {
    loading.value = false;
  }
}

const filteredAttractions = computed(() => {
  const q = search.value.trim().toLowerCase();
  let list = attractions.value;
  if (q) {
    list = list.filter(
      (a) =>
        (a.chinese_name || "").toLowerCase().includes(q) ||
        (a.name || "").toLowerCase().includes(q) ||
        (a.planning_zone || "").toLowerCase().includes(q)
    );
  }
  if (filterIncomplete.value) {
    list = list.filter((a) => schedulingIssues(a).length > 0);
  }
  return list;
});

const stats = computed(() => {
  const list = filteredAttractions.value;
  const incomplete = list.filter((a) => schedulingIssues(a).length > 0).length;
  const dayTrips = list.filter((a) => a.is_day_trip).length;
  const noCoords = list.filter((a) => a.latitude == null || a.longitude == null).length;
  return { total: list.length, incomplete, dayTrips, noCoords };
});

const citiesMissingCenter = computed(() =>
  cities.value.filter((c) => c.center_lat == null || c.center_lng == null)
);

async function saveAttraction(row, patch) {
  Object.assign(row, patch);
  const { error: e } = await supabase.from("attractions").update(patch).eq("id", row.id);
  if (e) {
    showToast("失败：" + e.message);
    loadAttractions();
    return;
  }
  showToast("已保存");
  nav.requestReload();
}

async function saveCity(row, patch) {
  Object.assign(row, patch);
  const { error: e } = await supabase.from("cities").update(patch).eq("id", row.id);
  if (e) {
    showToast("失败：" + e.message);
    loadCities();
    return;
  }
  showToast("已保存");
  nav.requestReload();
}

function numOrNull(v) {
  if (v === "" || v == null) return null;
  const n = Number(v);
  return Number.isFinite(n) ? n : null;
}

async function applyBatch(patch) {
  const ids = filteredAttractions.value.map((a) => a.id);
  if (!ids.length) return;
  if (!confirm(`将对当前 ${ids.length} 个景点应用此设置？`)) return;
  const { error: e } = await supabase.from("attractions").update(patch).in("id", ids);
  if (e) {
    showToast("失败：" + e.message);
    return;
  }
  showToast("批量已应用");
  loadAttractions();
  nav.requestReload();
}

function openAttraction(a) {
  nav.select({ kind: "record", tableKey: "attractions", id: a.id });
}

onMounted(load);
</script>

<template>
  <div class="sw">
    <h1>🗺️ 行程调度</h1>
    <p class="lead">
      维护景点地理坐标、时长槽位、远郊标记与城市中心，供 App 行程算法使用。
    </p>
    <div v-if="error" class="status-bar error">{{ error }}</div>

    <div class="tabs">
      <button :class="{ on: tab === 'attractions' }" @click="tab = 'attractions'">景点调度</button>
      <button :class="{ on: tab === 'cities' }" @click="tab = 'cities'">
        城市中心
        <span v-if="citiesMissingCenter.length" class="pill warn">{{ citiesMissingCenter.length }} 缺坐标</span>
      </button>
    </div>

    <!-- 景点 -->
    <template v-if="tab === 'attractions'">
      <div class="bar">
        <select v-model="cityId" @change="loadAttractions">
          <option value="">全部城市</option>
          <option v-for="c in refCache.cities" :key="c.id" :value="c.id">
            {{ (c.emoji || "") + " " + (c.chinese_name || c.name) }}
          </option>
        </select>
        <input v-model="search" class="search" placeholder="搜景点 / planning_zone…" />
        <label class="chk">
          <input v-model="filterIncomplete" type="checkbox" />
          仅看不完整
        </label>
        <span class="spacer"></span>
        <span class="stat">共 {{ stats.total }} · 不完整 {{ stats.incomplete }} · 远郊 {{ stats.dayTrips }} · 缺坐标 {{ stats.noCoords }}</span>
      </div>

      <div class="bar batch">
        <span class="batch-label">批量（当前筛选）：</span>
        <button class="btn btn-sm btn-secondary" @click="applyBatch({ is_day_trip: true, duration_slots_min: 3, duration_slots_max: 3 })">设远郊 3 slot</button>
        <button class="btn btn-sm btn-secondary" @click="applyBatch({ is_day_trip: false })">取消远郊</button>
        <button class="btn btn-sm btn-secondary" @click="applyBatch({ duration_slots_min: 1, duration_slots_max: 1 })">时长 1 slot</button>
        <button class="btn btn-sm btn-secondary" @click="applyBatch({ duration_slots_min: 2, duration_slots_max: 2 })">时长 2 slot</button>
        <button class="btn btn-sm btn-secondary" @click="load">刷新</button>
      </div>

      <div v-if="loading" class="muted">加载中…</div>
      <div v-else class="table-wrap">
        <table class="data-table">
          <thead>
            <tr>
              <th>名称</th>
              <th>完整度</th>
              <th>远郊</th>
              <th>时长 min</th>
              <th>距中心 km</th>
              <th>时段</th>
              <th>纬度</th>
              <th>经度</th>
              <th>分区</th>
              <th></th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="a in filteredAttractions" :key="a.id">
              <td class="name">
                <strong>{{ a.chinese_name || a.name }}</strong>
                <span class="sub">{{ refCache.cityLabel(a.city_id) }}</span>
              </td>
              <td>
                <span class="badge" :class="completenessLabel(a).ok ? 'ok' : 'warn'">
                  {{ completenessLabel(a).text }}
                </span>
              </td>
              <td>
                <input
                  type="checkbox"
                  :checked="a.is_day_trip"
                  @change="saveAttraction(a, { is_day_trip: $event.target.checked })"
                />
              </td>
              <td>
                <select
                  :value="a.duration_slots_min ?? ''"
                  @change="saveAttraction(a, {
                    duration_slots_min: numOrNull($event.target.value),
                    duration_slots_max: numOrNull($event.target.value),
                  })"
                >
                  <option value="">—</option>
                  <option v-for="p in DURATION_PRESETS" :key="p.value" :value="p.value">{{ p.label }}</option>
                </select>
              </td>
              <td>
                <input
                  type="number"
                  step="0.1"
                  class="num"
                  :value="a.distance_from_center_km ?? ''"
                  @change="saveAttraction(a, { distance_from_center_km: numOrNull($event.target.value) })"
                />
              </td>
              <td>
                <select
                  :value="a.recommended_visit_period || 'flexible'"
                  @change="saveAttraction(a, { recommended_visit_period: $event.target.value })"
                >
                  <option v-for="o in VISIT_PERIOD_OPTIONS" :key="o.value" :value="o.value">{{ o.label }}</option>
                </select>
              </td>
              <td>
                <input
                  type="number"
                  step="0.000001"
                  class="num wide"
                  :value="a.latitude ?? ''"
                  @change="saveAttraction(a, { latitude: numOrNull($event.target.value) })"
                />
              </td>
              <td>
                <input
                  type="number"
                  step="0.000001"
                  class="num wide"
                  :value="a.longitude ?? ''"
                  @change="saveAttraction(a, { longitude: numOrNull($event.target.value) })"
                />
              </td>
              <td>
                <input
                  type="text"
                  class="zone"
                  :value="a.planning_zone || ''"
                  placeholder="palace_core…"
                  @change="saveAttraction(a, { planning_zone: $event.target.value || null })"
                />
              </td>
              <td>
                <button class="btn btn-sm btn-link" @click="openAttraction(a)">编辑</button>
              </td>
            </tr>
            <tr v-if="!filteredAttractions.length">
              <td colspan="10" class="muted center">暂无景点</td>
            </tr>
          </tbody>
        </table>
      </div>
    </template>

    <!-- 城市中心 -->
    <template v-else>
      <div class="bar">
        <span class="stat">共 {{ cities.length }} 城 · {{ citiesMissingCenter.length }} 缺中心坐标</span>
        <span class="spacer"></span>
        <button class="btn btn-sm btn-secondary" @click="load">刷新</button>
      </div>
      <div v-if="loading" class="muted">加载中…</div>
      <table v-else class="data-table">
        <thead>
          <tr>
            <th>城市</th>
            <th>中心纬度</th>
            <th>中心经度</th>
            <th>状态</th>
            <th></th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="c in cities" :key="c.id">
            <td><strong>{{ (c.emoji || "") + " " + (c.chinese_name || c.name) }}</strong></td>
            <td>
              <input
                type="number"
                step="0.000001"
                class="num wide"
                :value="c.center_lat ?? ''"
                @change="saveCity(c, { center_lat: numOrNull($event.target.value) })"
              />
            </td>
            <td>
              <input
                type="number"
                step="0.000001"
                class="num wide"
                :value="c.center_lng ?? ''"
                @change="saveCity(c, { center_lng: numOrNull($event.target.value) })"
              />
            </td>
            <td>
              <span
                class="badge"
                :class="c.center_lat != null && c.center_lng != null ? 'ok' : 'warn'"
              >
                {{ c.center_lat != null && c.center_lng != null ? "已设置" : "缺坐标" }}
              </span>
            </td>
            <td>
              <button
                class="btn btn-sm btn-link"
                @click="nav.select({ kind: 'record', tableKey: 'cities', id: c.id })"
              >编辑</button>
            </td>
          </tr>
        </tbody>
      </table>
    </template>

    <div class="toast" :class="{ on: toast }">{{ toast }}</div>
  </div>
</template>

<style scoped>
.sw h1 { margin: 0 0 6px; font-size: 20px; }
.lead { margin: 0 0 14px; color: var(--muted); font-size: 13px; }
.tabs { display: flex; gap: 8px; margin-bottom: 14px; }
.tabs button {
  padding: 8px 14px;
  border: 1px solid var(--border);
  border-radius: 8px;
  background: var(--surface);
  cursor: pointer;
  font-size: 13px;
}
.tabs button.on { background: var(--accent-soft, #eef4ff); border-color: var(--accent, #3b6cff); font-weight: 600; }
.pill { margin-left: 6px; font-size: 11px; padding: 1px 6px; border-radius: 999px; background: #fff3cd; color: #856404; }
.bar { display: flex; gap: 10px; align-items: center; margin-bottom: 10px; flex-wrap: wrap; }
.bar.batch { margin-bottom: 14px; }
.batch-label { font-size: 13px; color: var(--muted); }
.bar select, .bar .search { width: auto; min-width: 160px; }
.chk { font-size: 13px; display: flex; align-items: center; gap: 6px; white-space: nowrap; }
.chk input { width: auto; }
.spacer { flex: 1; }
.stat { font-size: 12px; color: var(--muted); }
.table-wrap { overflow-x: auto; }
.data-table { width: 100%; border-collapse: collapse; font-size: 13px; min-width: 960px; }
.data-table th, .data-table td { text-align: left; padding: 7px 10px; border-bottom: 1px solid var(--border); vertical-align: middle; }
.data-table th { color: var(--muted); font-size: 12px; white-space: nowrap; }
.data-table td input[type="checkbox"] { width: auto; }
.data-table select { width: auto; min-width: 88px; font-size: 12px; }
.num { width: 72px; font-size: 12px; }
.num.wide { width: 108px; }
.zone { width: 100px; font-size: 12px; }
.name .sub { display: block; font-size: 11px; color: var(--muted); margin-top: 2px; }
.badge { display: inline-block; padding: 2px 8px; border-radius: 999px; font-size: 11px; white-space: nowrap; }
.badge.ok { background: #e6f4ea; color: #1e7e34; }
.badge.warn { background: #fff3cd; color: #856404; }
.muted { color: var(--muted); }
.center { text-align: center; padding: 24px; }
.btn-link { background: none; border: none; color: var(--accent, #3b6cff); cursor: pointer; padding: 0; font-size: 12px; }
.toast { position: fixed; bottom: 26px; left: 50%; transform: translateX(-50%); background: var(--text); color: var(--bg); padding: 10px 18px; border-radius: 8px; font-size: 13px; opacity: 0; pointer-events: none; transition: opacity 0.2s; z-index: 1100; }
.toast.on { opacity: 1; }
</style>
