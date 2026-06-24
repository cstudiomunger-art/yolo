<script setup>
import { ref, computed, watch, onMounted } from "vue";
import { TABLES } from "@/schema/tables";
import { useRefCache } from "@/stores/refCache";
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
const schema = computed(() => TABLES[props.tableKey]);

const rows = ref([]);
const loading = ref(false);
const error = ref("");
const cityFilter = ref("");
const search = ref("");
const editing = ref(null); // row, or { _new:true }

const isSingle = computed(() => schema.value?.single === true);

async function load() {
  error.value = "";
  loading.value = true;
  editing.value = null;
  cityFilter.value = props.fixedCityId || "";
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
  if (search.value) r = filterRowsBySearch(r, search.value);
  return r;
});

const showCityFilter = computed(() => !props.fixedCityId && hasCityFilter(props.tableKey));

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
        {{ schema.label }}
        <span v-if="fixedCityId" class="scope">· {{ refCache.cityLabel(fixedCityId) }}</span>
      </h1>
      <button v-if="!isSingle && !editing && !schema.noCreate" class="btn" @click="onCreate">+ 新建</button>
    </div>

    <div v-if="error" class="status-bar error">{{ error }}</div>
    <div v-if="loading">加载中…</div>

    <RecordForm
      v-else-if="editing"
      :key="editing[schema.pk] || '_new_'"
      :table-key="tableKey"
      :schema="schema"
      :initial="editing._new ? null : editing"
      :presets="editing._new ? editing : null"
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
        <input v-model="search" type="search" placeholder="搜索…" />
        <span class="count">{{ filteredRows.length }} 条</span>
      </div>
      <TableList :schema="schema" :rows="filteredRows" @edit="onEdit" @remove="onRemove" />
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
</style>
