<script setup>
import { computed } from "vue";

/** One string per row — avoids comma-splitting issues in string_list fields. */
const props = defineProps({
  modelValue: { type: Array, default: () => [] },
  addLabel: { type: String, default: "+ 添加一条" },
  placeholder: { type: String, default: "" },
});
const emit = defineEmits(["update:modelValue"]);

const rows = computed(() => (Array.isArray(props.modelValue) ? props.modelValue : []));

function update(i, value) {
  const next = rows.value.slice();
  next[i] = value;
  emit("update:modelValue", next);
}
function add() {
  emit("update:modelValue", [...rows.value, ""]);
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
  <div class="sle">
    <div v-for="(row, i) in rows" :key="i" class="sle-row">
      <input
        type="text"
        :placeholder="placeholder"
        :value="row"
        @input="update(i, $event.target.value)"
      />
      <span class="ops">
        <button type="button" class="btn btn-secondary btn-sm" @click="move(i, -1)">↑</button>
        <button type="button" class="btn btn-secondary btn-sm" @click="move(i, 1)">↓</button>
        <button type="button" class="btn btn-secondary btn-sm" @click="remove(i)">删</button>
      </span>
    </div>
    <button type="button" class="btn btn-secondary btn-sm add" @click="add">{{ addLabel }}</button>
  </div>
</template>

<style scoped>
.sle {
  border: 1px solid var(--border);
  border-radius: var(--radius);
  padding: 10px;
}
.sle-row {
  display: grid;
  grid-template-columns: 1fr auto;
  gap: 8px;
  align-items: center;
  margin-bottom: 6px;
}
.ops {
  display: flex;
  gap: 4px;
  white-space: nowrap;
}
.add {
  margin-top: 6px;
}
</style>
