<script setup>
import { ref, computed, onMounted } from "vue";
import { supabase } from "@/lib/supabase";
import { useRefCache } from "@/stores/refCache";
import { TABLES } from "@/schema/tables";
import RecordForm from "@/components/RecordForm.vue";

const refCache = useRefCache();
const schema = TABLES.checklist_items;

const items = ref([]);
const loading = ref(false);
const error = ref("");
const toast = ref("");
const search = ref("");
function showToast(m) { toast.value = m; setTimeout(() => (toast.value = ""), 1600); }

// full-content editor state
const editing = ref(null); // a row, { _new:true, presets } , or null

const PRIORITY = [
  { v: "required", l: "必做" },
  { v: "recommended", l: "推荐" },
  { v: "optional", l: "可选" },
];
const REMINDER_PRESETS = [3, 5, 7, 10, 15, 30, 45];

async function load() {
  loading.value = true;
  error.value = "";
  editing.value = null;
  await refCache.load();
  const { data, error: e } = await supabase
    .from("checklist_items")
    .select("id,type,title_en,group_title,priority,reminder_days_before,target_cities,city_id,sort_order,is_active")
    .order("sort_order", { ascending: true });
  if (e) error.value = e.message;
  items.value = data || [];
  loading.value = false;
}

const q = computed(() => search.value.trim().toLowerCase());
function matchSearch(it) {
  if (!q.value) return true;
  return [it.title_en, it.id, it.group_title].filter(Boolean).join(" ").toLowerCase().includes(q.value);
}

const sorted = computed(() =>
  [...items.value].filter(matchSearch).sort((a, b) => (a.sort_order ?? 0) - (b.sort_order ?? 0))
);

function primaryCity(it) {
  return (Array.isArray(it.target_cities) && it.target_cities[0]) || it.city_id || "other";
}

// grouped: entry, universal, then one group per city
const groups = computed(() => {
  const entry = sorted.value.filter((i) => i.type === "entry");
  const universal = sorted.value.filter((i) => i.type === "universal");
  const cityItems = sorted.value.filter((i) => i.type === "city");

  const out = [
    { key: "entry", label: "入境与签证 · Entry Requirements", type: "entry", items: entry },
    { key: "universal", label: "通用准备 · Essential Prep", type: "universal", items: universal },
  ];

  const byCity = {};
  cityItems.forEach((it) => {
    const cid = primaryCity(it);
    (byCity[cid] = byCity[cid] || []).push(it);
  });
  Object.entries(byCity).forEach(([cid, list]) => {
    out.push({
      key: "city:" + cid,
      label: "城市 · " + (cid === "other" ? "未指定城市" : refCache.cityLabel(cid)),
      type: "city",
      cityId: cid === "other" ? null : cid,
      items: list,
    });
  });
  return out;
});

const totalActive = computed(() => items.value.filter((i) => i.is_active).length);

// ── inline quick-save ──
async function patch(item, p) {
  Object.assign(item, p);
  const { error: e } = await supabase.from("checklist_items").update({ ...p, updated_at: new Date().toISOString() }).eq("id", item.id);
  if (e) { showToast("失败：" + e.message); load(); return; }
  showToast("已保存");
}
function reminderOptions(item) {
  const cur = item.reminder_days_before;
  const base = [...REMINDER_PRESETS];
  if (cur != null && !base.includes(cur)) base.push(cur);
  return base.sort((a, b) => a - b);
}

// ── full editor (reuse generic RecordForm) ──
function openFull(item) { editing.value = item; }
function newItem(group) {
  const presets = { type: group.type, phase: "before_departure" };
  if (group.type === "entry") presets.group_title = "Entry Requirements";
  else if (group.type === "universal") presets.group_title = "Essential Prep";
  else if (group.type === "city") {
    presets.group_title = group.cityId ? refCache.cityLabel(group.cityId) : "City";
    if (group.cityId) { presets.target_cities = [group.cityId]; presets.city_id = group.cityId; }
  }
  editing.value = { _new: true, presets };
}
async function onSaved() { await load(); }
function onCancel() { editing.value = null; }
async function onDeleted() { await load(); }

onMounted(load);
</script>

<template>
  <div class="cw">
    <!-- full-content editor -->
    <template v-if="editing">
      <div class="bar">
        <button class="btn btn-secondary btn-sm" @click="editing = null">← 返回清单</button>
      </div>
      <RecordForm
        :key="editing._new ? '_new_' : editing.id"
        table-key="checklist_items"
        :schema="schema"
        :initial="editing._new ? null : editing"
        :presets="editing._new ? editing.presets : null"
        @saved="onSaved"
        @deleted="onDeleted"
        @cancel="onCancel"
      />
    </template>

    <!-- grouped overview -->
    <template v-else>
      <div class="head">
        <h1>🧳 行前清单工作台</h1>
        <span class="muted">{{ totalActive }} 条启用 / 共 {{ items.length }} 条</span>
      </div>
      <div class="bar">
        <input v-model="search" class="search" type="search" placeholder="搜标题 / ID…" />
        <button class="btn btn-secondary btn-sm" @click="load">刷新</button>
      </div>

      <div v-if="error" class="status-bar error">{{ error }}</div>
      <div v-if="loading" class="muted">加载中…</div>

      <section v-for="g in groups" :key="g.key" class="group" v-show="!loading">
        <div class="ghead">
          <h2>{{ g.label }} <span class="muted">({{ g.items.length }})</span></h2>
          <button class="btn btn-sm" @click="newItem(g)">+ 新建</button>
        </div>
        <table class="data-table">
          <thead>
            <tr><th>标题</th><th>优先级</th><th>提前提醒</th><th class="num">排序</th><th class="num">启用</th><th></th></tr>
          </thead>
          <tbody>
            <tr v-for="it in g.items" :key="it.id" :class="{ off: !it.is_active }">
              <td>
                <button class="link" @click="openFull(it)">{{ it.title_en || it.id }}</button>
                <div class="muted small">{{ it.id }}</div>
              </td>
              <td>
                <select :value="it.priority" @change="patch(it, { priority: $event.target.value })">
                  <option v-for="p in PRIORITY" :key="p.v" :value="p.v">{{ p.l }}</option>
                </select>
              </td>
              <td>
                <select :value="it.reminder_days_before ?? ''" @change="patch(it, { reminder_days_before: $event.target.value === '' ? null : Number($event.target.value) })">
                  <option value="">不提醒</option>
                  <option v-for="p in reminderOptions(it)" :key="p" :value="p">{{ p }} 天</option>
                </select>
              </td>
              <td class="num">
                <input class="sort" type="number" :value="it.sort_order"
                  @change="patch(it, { sort_order: Number($event.target.value) })" />
              </td>
              <td class="num">
                <input type="checkbox" :checked="it.is_active" @change="patch(it, { is_active: $event.target.checked })" />
              </td>
              <td><button class="btn btn-secondary btn-sm" @click="openFull(it)">编辑全文</button></td>
            </tr>
            <tr v-if="!g.items.length"><td colspan="6" class="muted center">暂无条目</td></tr>
          </tbody>
        </table>
      </section>
    </template>

    <div class="toast" :class="{ on: toast }">{{ toast }}</div>
  </div>
</template>

<style scoped>
.cw .head { display: flex; align-items: baseline; gap: 12px; margin-bottom: 12px; }
.cw h1 { margin: 0; font-size: 20px; }
.bar { display: flex; gap: 10px; align-items: center; margin-bottom: 16px; }
.bar .search { width: auto; min-width: 240px; }

.group { margin-bottom: 26px; }
.ghead { display: flex; align-items: center; justify-content: space-between; margin-bottom: 8px; }
.ghead h2 { margin: 0; font-size: 15px; }

.data-table { width: 100%; border-collapse: collapse; font-size: 14px; }
.data-table th, .data-table td { text-align: left; padding: 7px 10px; border-bottom: 1px solid var(--border); vertical-align: middle; }
.data-table th { color: var(--muted); font-size: 13px; }
.data-table th.num, .data-table td.num { text-align: center; width: 1%; white-space: nowrap; }
.data-table tr.off { opacity: 0.5; }
.data-table select { width: auto; min-width: 92px; }
.data-table .sort { width: 64px; text-align: center; }
.data-table input[type="checkbox"] { width: auto; }
.link { background: none; border: none; color: var(--accent); cursor: pointer; font-size: 14px; padding: 0; text-align: left; }
.link:hover { text-decoration: underline; }

.muted { color: var(--muted); }
.small { font-size: 11px; }
.center { text-align: center; padding: 18px; }
.toast { position: fixed; bottom: 26px; left: 50%; transform: translateX(-50%); background: var(--text); color: var(--bg); padding: 10px 18px; border-radius: 8px; font-size: 13px; opacity: 0; pointer-events: none; transition: opacity 0.2s; z-index: 1100; }
.toast.on { opacity: 1; }
</style>
