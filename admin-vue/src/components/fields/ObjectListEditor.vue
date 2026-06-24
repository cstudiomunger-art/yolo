<script setup>
import { computed } from "vue";

/**
 * Generic array-of-objects editor driven by a column spec.
 * columns: [{ key, label, placeholder?, type? ('text'|'number'|'url') }]
 */
const props = defineProps({
  modelValue: { type: Array, default: () => [] },
  columns: { type: Array, required: true },
  addLabel: { type: String, default: "+ 添加一项" },
  // optional quick-add presets, e.g. [{ icon:'🎫', label:'Ticket' }]
  presets: { type: Array, default: () => [] },
});
const emit = defineEmits(["update:modelValue"]);

const rows = computed(() => (Array.isArray(props.modelValue) ? props.modelValue : []));

function update(i, key, value, type) {
  const next = rows.value.map((r) => ({ ...r }));
  next[i][key] = type === "number" ? (value === "" ? null : Number(value)) : value;
  emit("update:modelValue", next);
}
function add() {
  const blank = {};
  props.columns.forEach((c) => (blank[c.key] = c.type === "number" ? null : ""));
  emit("update:modelValue", [...rows.value, blank]);
}
function addPreset(p) {
  const row = {};
  props.columns.forEach((c) => (row[c.key] = c.type === "number" ? null : ""));
  emit("update:modelValue", [...rows.value, { ...row, icon: p.icon, label: p.label }]);
}
function remove(i) {
  emit("update:modelValue", rows.value.filter((_, idx) => idx !== i));
}
function move(i, dir) {
  const j = i + dir;
  if (j < 0 || j >= rows.value.length) return;
  const next = rows.value.slice();
  [next[i], next[j]] = [next[j], next[i]];
  emit("update:modelValue", next);
}
</script>

<template>
  <div class="ole">
    <div class="ole-head">
      <span v-for="c in columns" :key="c.key">{{ c.label }}</span>
      <span class="ops"></span>
    </div>
    <div v-for="(row, i) in rows" :key="i" class="ole-row">
      <input
        v-for="c in columns"
        :key="c.key"
        :type="c.type === 'number' ? 'number' : c.type === 'url' ? 'url' : 'text'"
        :placeholder="c.placeholder || ''"
        :value="row[c.key] ?? ''"
        @input="update(i, c.key, $event.target.value, c.type)"
      />
      <span class="ops">
        <button type="button" class="btn btn-secondary btn-sm" @click="move(i, -1)">↑</button>
        <button type="button" class="btn btn-secondary btn-sm" @click="move(i, 1)">↓</button>
        <button type="button" class="btn btn-secondary btn-sm" @click="remove(i)">删</button>
      </span>
    </div>
    <div v-if="presets.length" class="presets">
      <button
        v-for="p in presets"
        :key="p.label"
        type="button"
        class="btn btn-secondary btn-sm"
        @click="addPreset(p)"
      >
        + {{ p.icon }} {{ p.label }}
      </button>
    </div>
    <button type="button" class="btn btn-secondary btn-sm add" @click="add">{{ addLabel }}</button>
  </div>
</template>

<style scoped>
.ole {
  border: 1px solid var(--border);
  border-radius: var(--radius);
  padding: 10px;
}
.ole-head,
.ole-row {
  display: grid;
  grid-template-columns: repeat(v-bind("columns.length"), 1fr) auto;
  gap: 8px;
  align-items: center;
}
.ole-head {
  font-size: 12px;
  color: var(--muted);
  margin-bottom: 6px;
}
.ole-row {
  margin-bottom: 6px;
}
.ops {
  display: flex;
  gap: 4px;
  white-space: nowrap;
}
.presets {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
  margin: 6px 0;
}
.add {
  margin-top: 6px;
}
</style>
