<script setup>
import { ref, computed, onMounted } from "vue";
import { supabase } from "@/lib/supabase";
import { useRefCache } from "@/stores/refCache";

const refCache = useRefCache();
const tiers = ref([]);
const attractions = ref([]);
const subAreasByAttraction = ref({});
const cityId = ref("");
const search = ref("");
const loading = ref(false);
const error = ref("");
const toast = ref("");

function showToast(m) { toast.value = m; setTimeout(() => (toast.value = ""), 1600); }

const tierLabel = (id) => {
  const t = tiers.value.find((x) => x.id === id);
  return t ? `${t.name_zh || t.name_en} · ${t.price_label}` : "默认档";
};

async function load() {
  loading.value = true;
  error.value = "";
  try {
    await refCache.load();
    const { data: t } = await supabase
      .from("membership_plans")
      .select("id,name_zh,name_en,price_label,is_active")
      .eq("plan_type", "one_time_attraction")
      .order("display_order");
    tiers.value = t || [];

    let q = supabase.from("attractions").select("id,name,chinese_name,city_id,requires_purchase,price_tier_id").order("display_order");
    if (cityId.value) q = q.eq("city_id", cityId.value);
    const { data: a, error: ae } = await q;
    if (ae) throw ae;
    attractions.value = a || [];

    const ids = attractions.value.map((x) => x.id);
    if (ids.length) {
      const { data: s } = await supabase
        .from("sub_areas")
        .select("id,name_en,name_zh,attraction_id,requires_purchase,price_tier_id")
        .in("attraction_id", ids)
        .order("sort_order");
      const grouped = {};
      (s || []).forEach((row) => {
        (grouped[row.attraction_id] = grouped[row.attraction_id] || []).push(row);
      });
      subAreasByAttraction.value = grouped;
    } else {
      subAreasByAttraction.value = {};
    }
  } catch (e) {
    error.value = e.message || String(e);
  } finally {
    loading.value = false;
  }
}

const filteredAttractions = computed(() => {
  const q = search.value.trim().toLowerCase();
  if (!q) return attractions.value;
  return attractions.value.filter((a) =>
    (a.chinese_name || "").toLowerCase().includes(q) || (a.name || "").toLowerCase().includes(q)
  );
});

async function saveRow(kind, row, patch) {
  const table = kind === "attraction" ? "attractions" : "sub_areas";
  Object.assign(row, patch);
  const { error: e } = await supabase.from(table).update(patch).eq("id", row.id);
  if (e) { showToast("失败：" + e.message); load(); return; }
  showToast("已保存");
}

async function applyBatch(patch) {
  const ids = filteredAttractions.value.map((a) => a.id);
  if (!ids.length) return;
  if (!confirm(`将对当前 ${ids.length} 个景点应用此设置？`)) return;
  const { error: e } = await supabase.from("attractions").update(patch).in("id", ids);
  if (e) { showToast("失败：" + e.message); return; }
  showToast("批量已应用");
  load();
}

onMounted(load);
</script>

<template>
  <div class="ph">
    <h1>🏷️ 景点定价</h1>
    <div v-if="error" class="status-bar error">{{ error }}</div>

    <div class="bar">
      <select v-model="cityId" @change="load">
        <option value="">全部城市</option>
        <option v-for="c in refCache.cities" :key="c.id" :value="c.id">{{ (c.emoji || "") + " " + (c.chinese_name || c.name) }}</option>
      </select>
      <input v-model="search" class="search" placeholder="搜景点…" />
      <span class="spacer"></span>
      <button class="btn btn-sm btn-secondary" @click="applyBatch({ requires_purchase: false })">当前全设免费</button>
      <button class="btn btn-sm btn-secondary" @click="applyBatch({ requires_purchase: true })">当前全设付费</button>
    </div>

    <div v-if="loading" class="muted">加载中…</div>
    <table v-else class="data-table">
      <thead><tr><th>名称</th><th>付费</th><th>价格档</th></tr></thead>
      <tbody>
        <template v-for="a in filteredAttractions" :key="a.id">
          <tr>
            <td><strong>{{ a.chinese_name || a.name }}</strong></td>
            <td><input type="checkbox" :checked="a.requires_purchase" @change="saveRow('attraction', a, { requires_purchase: $event.target.checked })" /></td>
            <td>
              <select :value="a.price_tier_id || ''" :disabled="!a.requires_purchase"
                @change="saveRow('attraction', a, { price_tier_id: $event.target.value || null })">
                <option value="">默认档</option>
                <option v-for="t in tiers" :key="t.id" :value="t.id">{{ t.name_zh || t.name_en }} · {{ t.price_label }}</option>
              </select>
            </td>
          </tr>
          <tr v-for="s in subAreasByAttraction[a.id] || []" :key="s.id" class="sub">
            <td class="indent">↳ {{ s.name_zh || s.name_en }}</td>
            <td><input type="checkbox" :checked="s.requires_purchase" @change="saveRow('sub_area', s, { requires_purchase: $event.target.checked })" /></td>
            <td>
              <select :value="s.price_tier_id || ''" :disabled="!s.requires_purchase"
                @change="saveRow('sub_area', s, { price_tier_id: $event.target.value || null })">
                <option value="">默认档</option>
                <option v-for="t in tiers" :key="t.id" :value="t.id">{{ t.name_zh || t.name_en }} · {{ t.price_label }}</option>
              </select>
            </td>
          </tr>
        </template>
        <tr v-if="!filteredAttractions.length"><td colspan="3" class="muted center">暂无景点</td></tr>
      </tbody>
    </table>
    <div class="toast" :class="{ on: toast }">{{ toast }}</div>
  </div>
</template>

<style scoped>
.ph h1 { margin: 0 0 14px; font-size: 20px; }
.bar { display: flex; gap: 10px; align-items: center; margin-bottom: 14px; }
.bar select, .bar .search { width: auto; min-width: 180px; }
.spacer { flex: 1; }
.data-table { width: 100%; border-collapse: collapse; font-size: 14px; }
.data-table th, .data-table td { text-align: left; padding: 8px 12px; border-bottom: 1px solid var(--border); }
.data-table th { color: var(--muted); font-size: 13px; }
.data-table td input[type="checkbox"] { width: auto; }
.data-table select { width: auto; min-width: 160px; }
.sub td { background: var(--surface); }
.indent { padding-left: 28px !important; color: var(--muted); }
.muted { color: var(--muted); }
.center { text-align: center; padding: 24px; }
.toast { position: fixed; bottom: 26px; left: 50%; transform: translateX(-50%); background: var(--text); color: var(--bg); padding: 10px 18px; border-radius: 8px; font-size: 13px; opacity: 0; pointer-events: none; transition: opacity 0.2s; z-index: 1100; }
.toast.on { opacity: 1; }
</style>
