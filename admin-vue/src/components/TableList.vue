<script setup>
import { computed } from "vue";
import { useRefCache } from "@/stores/refCache";

const props = defineProps({
  schema: { type: Object, required: true },
  rows: { type: Array, required: true },
});
const emit = defineEmits(["edit", "remove"]);

const refCache = useRefCache();
const pk = props.schema.pk || "id";

const columns = computed(
  () => props.schema.listColumns || [{ key: pk, label: pk }]
);

function cell(row, col) {
  const v = row[col.key];
  if (col.ref === "attraction") return refCache.attractionLabel(v);
  if (col.ref === "city") return refCache.cityLabel(v);
  if (typeof v === "boolean") return v ? "✓" : "—";
  if (v == null || v === "") return "—";
  if (Array.isArray(v)) return v.join(", ");
  return String(v);
}
</script>

<template>
  <table class="list">
    <thead>
      <tr>
        <th v-for="c in columns" :key="c.key">{{ c.label }}</th>
        <th class="ops"></th>
      </tr>
    </thead>
    <tbody>
      <tr v-for="row in rows" :key="row[pk]" @click="emit('edit', row)">
        <td v-for="c in columns" :key="c.key">{{ cell(row, c) }}</td>
        <td class="ops" @click.stop>
          <button
            v-if="!schema.noDelete"
            class="btn btn-secondary btn-sm"
            @click="emit('remove', row)"
          >
            删
          </button>
        </td>
      </tr>
      <tr v-if="!rows.length">
        <td :colspan="columns.length + 1" class="empty">暂无数据</td>
      </tr>
    </tbody>
  </table>
</template>

<style scoped>
.list {
  width: 100%;
  border-collapse: collapse;
  font-size: 14px;
}
.list th,
.list td {
  text-align: left;
  padding: 10px 12px;
  border-bottom: 1px solid var(--border);
}
.list th {
  color: var(--muted);
  font-weight: 600;
  font-size: 13px;
}
.list tbody tr {
  cursor: pointer;
}
.list tbody tr:hover {
  background: var(--surface2);
}
.ops {
  width: 1%;
  white-space: nowrap;
}
.empty {
  color: var(--muted);
  text-align: center;
  padding: 28px;
}
</style>
