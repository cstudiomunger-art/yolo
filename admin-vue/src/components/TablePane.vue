<script setup>
import { ref, computed, watch, onMounted } from "vue";
import { storeToRefs } from "pinia";
import { TABLES } from "@/schema/tables";
import { useRefCache } from "@/stores/refCache";
import { useNav } from "@/stores/nav";
import TableList from "@/components/TableList.vue";
import RecordForm from "@/components/RecordForm.vue";
import {
  fetchList, fetchSingle, deleteRow,
  hasCityFilter, filterRowsByCity, filterRowsBySearch,
} from "@/lib/crud";

const props = defineProps({
  tableKey: { type: String, required: true },
  fixedCityId: { type: String, default: "" }, // lock list + create to a city
});

const refCache = useRefCache();
const nav = useNav();
const { selection } = storeToRefs(nav);
const schema = computed(() => TABLES[props.tableKey]);

const rows = ref([]);
const loading = ref(false);
const error = ref("");
const cityFilter = ref("");
const search = ref("");
const typeFilter = ref(""); // checklist_items: entry / universal / city
const page = ref(1);
const editing = ref(null); // row, or { _new:true }

const PAGE_SIZE = 50;
const CHECKLIST_TYPES = [
  { value: "entry", label: "入境/签证" },
  { value: "universal", label: "通用" },
  { value: "city", label: "城市" },
];

const isSingle = computed(() => schema.value?.single === true);
const isChecklist = computed(() => props.tableKey === "checklist_items");
const pageTitle = computed(() => {
  if (props.tableKey === "app_settings" && selection.value.settingsSection === "legal_section") {
    return "法律与合规文档";
  }
  return schema.value?.label || props.tableKey;
});

// persisted (non-fixed) filters per table, mirroring the legacy admin
const cityStoreKey = computed(() => `cms_city_filter_${props.tableKey}`);
const typeStoreKey = computed(() => `cms_type_filter_${props.tableKey}`);

async function load() {
  error.value = "";
  loading.value = true;
  editing.value = null;
  page.value = 1;
  // city-locked panels force the city; otherwise restore the persisted filter
  cityFilter.value = props.fixedCityId || (showCityFilter.value ? localStorage.getItem(cityStoreKey.value) || "" : "");
  typeFilter.value = isChecklist.value ? localStorage.getItem(typeStoreKey.value) || "" : "";
  try {
    await refCache.load();
    if (isSingle.value) {
      const row = await fetchSingle(props.tableKey);
      editing.value = row || {};
      rows.value = row ? [row] : [];
    } else {
      rows.value = await fetchList(props.tableKey, schema.value);
    }
  } catch (e) {
    error.value = e.message || String(e);
  } finally {
    loading.value = false;
  }
}

const attractionCity = (attractionId) => {
  const a = refCache.attractions.find((x) => x.id === attractionId);
  return a ? a.city_id : null;
};

// reading_list filters by city_ids[] array rather than a scalar column
function readingListMatch(row, cityId) {
  const ids = Array.isArray(row.city_ids) ? row.city_ids : [];
  return !ids.length || ids.includes(cityId);
}

const filteredRows = computed(() => {
  let r = rows.value;
  const city = cityFilter.value;
  if (city) {
    if (props.tableKey === "reading_list") r = r.filter((row) => readingListMatch(row, city));
    else if (hasCityFilter(props.tableKey)) r = filterRowsByCity(props.tableKey, r, city, attractionCity);
  }
  if (isChecklist.value && typeFilter.value) {
    r = r.filter((row) => (row.type || "city") === typeFilter.value);
  }
  if (search.value) r = filterRowsBySearch(r, search.value);
  return r;
});

const showCityFilter = computed(() => !props.fixedCityId && hasCityFilter(props.tableKey));

// ── pagination (client-side; rows are already fully loaded) ──
const pageCount = computed(() => Math.max(1, Math.ceil(filteredRows.value.length / PAGE_SIZE)));
const pagedRows = computed(() =>
  filteredRows.value.slice((page.value - 1) * PAGE_SIZE, page.value * PAGE_SIZE)
);

// reset to page 1 whenever a filter narrows the result
watch([search, cityFilter, typeFilter], () => { page.value = 1; });

// persist non-fixed filters
watch(cityFilter, (v) => {
  if (showCityFilter.value) localStorage.setItem(cityStoreKey.value, v || "");
});
watch(typeFilter, (v) => {
  if (isChecklist.value) localStorage.setItem(typeStoreKey.value, v || "");
});

function createPresets() {
  const p = {};
  if (props.fixedCityId) {
    // seed the city-scoping column so a city-locked create lands in this city
    if (props.tableKey === "reading_list") p.city_ids = [props.fixedCityId];
    else p.city_id = props.fixedCityId;
  }
  return p;
}

function onCreate() {
  editing.value = { _new: true, ...createPresets() };
}
function onEdit(row) {
  editing.value = row;
}
function onCancel() {
  if (!isSingle.value) editing.value = null;
}
async function onSaved() {
  await load();
}
async function onRemove(row) {
  if (!confirm("确定删除该条？")) return;
  try {
    await deleteRow(props.tableKey, schema.value.pk || "id", row[schema.value.pk || "id"]);
    await load();
  } catch (e) {
    error.value = e.message || String(e);
  }
}

onMounted(load);
watch(() => [props.tableKey, props.fixedCityId], load);
</script>

<template>
  <div v-if="!schema" class="status-bar error">未知表：{{ tableKey }}</div>
  <div v-else>
    <div class="page-head">
      <h1>
        {{ pageTitle }}
        <span v-if="fixedCityId" class="scope">· {{ refCache.cityLabel(fixedCityId) }}</span>
      </h1>
      <button v-if="!isSingle && !editing && !schema.noCreate" class="btn" @click="onCreate">+ 新建</button>
    </div>

    <div v-if="error" class="status-bar error">{{ error }}</div>
    <div v-if="loading">加载中…</div>

    <RecordForm
      v-else-if="editing"
      :key="(editing[schema.pk] || '_new_') + '|' + (selection.settingsSection || '')"
      :table-key="tableKey"
      :schema="schema"
      :initial="editing._new ? null : editing"
      :presets="editing._new ? editing : null"
      :initial-section="selection.settingsSection || ''"
      @saved="onSaved"
      @deleted="onSaved"
      @cancel="onCancel"
    />

    <template v-else>
      <div class="filters">
        <select v-if="showCityFilter" v-model="cityFilter">
          <option value="">全部城市</option>
          <option v-for="c in refCache.cities" :key="c.id" :value="c.id">
            {{ (c.emoji || "") + " " + (c.chinese_name || c.name) }}
          </option>
        </select>
        <select v-if="isChecklist" v-model="typeFilter">
          <option value="">全部类型</option>
          <option v-for="t in CHECKLIST_TYPES" :key="t.value" :value="t.value">{{ t.label }}</option>
        </select>
        <input v-model="search" type="search" placeholder="搜索…" />
        <span class="count">{{ filteredRows.length }} 条</span>
      </div>
      <TableList :schema="schema" :rows="pagedRows" @edit="onEdit" @remove="onRemove" />
      <div v-if="pageCount > 1" class="pager">
        <button class="btn btn-secondary btn-sm" :disabled="page <= 1" @click="page--">← 上一页</button>
        <span class="muted">第 {{ page }} / {{ pageCount }} 页</span>
        <button class="btn btn-secondary btn-sm" :disabled="page >= pageCount" @click="page++">下一页 →</button>
      </div>
    </template>
  </div>
</template>

<style scoped>
.page-head { display: flex; align-items: center; justify-content: space-between; margin-bottom: 18px; }
.page-head h1 { margin: 0; font-size: 20px; }
.scope { color: var(--muted); font-size: 15px; font-weight: 400; }
.filters { display: flex; gap: 10px; align-items: center; margin-bottom: 14px; }
.filters select, .filters input { width: auto; min-width: 180px; }
.count { color: var(--muted); font-size: 13px; }
.pager { display: flex; gap: 12px; align-items: center; justify-content: center; margin-top: 16px; }
.pager .muted { color: var(--muted); font-size: 13px; }
</style>
