<script setup>
import { computed } from "vue";
import { useRefCache } from "@/stores/refCache";
import { formatListCell } from "@/lib/listFormat";

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
  return formatListCell(col, row, refCache);
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
        <td v-for="c in columns" :key="c.key">
          <img
            v-if="cell(row, c).kind === 'img'"
            class="list-thumb"
            :src="cell(row, c).src"
            alt=""
            loading="lazy"
          />
          <span
            v-else-if="cell(row, c).kind === 'tag'"
            class="tag"
            :class="cell(row, c).on ? 'on' : 'off'"
          >{{ cell(row, c).text }}</span>
          <span v-else :class="{ muted: cell(row, c).muted }">{{ cell(row, c).text }}</span>
        </td>
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
  vertical-align: middle;
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
.muted {
  color: var(--muted);
}
.list-thumb {
  width: 40px;
  height: 40px;
  object-fit: cover;
  border-radius: 6px;
  border: 1px solid var(--border);
}
.tag {
  display: inline-block;
  padding: 2px 8px;
  border-radius: 12px;
  font-size: 12px;
  background: var(--surface2);
  color: var(--muted);
}
.tag.on {
  background: rgba(46, 158, 91, 0.15);
  color: #2e9e5b;
}
.tag.off {
  background: var(--surface2);
  color: var(--muted);
}
</style>
