<script setup>
import { computed } from "vue";

/** Multi-select as a checkbox grid. options: [{ value, label }]. */
const props = defineProps({
  modelValue: { type: Array, default: () => [] },
  options: { type: Array, required: true },
});
const emit = defineEmits(["update:modelValue"]);

const selected = computed(() => (Array.isArray(props.modelValue) ? props.modelValue : []));

function toggle(value) {
  const set = new Set(selected.value);
  if (set.has(value)) set.delete(value);
  else set.add(value);
  emit("update:modelValue", [...set]);
}
</script>

<template>
  <div class="grid">
    <label v-for="o in options" :key="o.value" class="chip" :class="{ on: selected.includes(o.value) }">
      <input
        type="checkbox"
        :checked="selected.includes(o.value)"
        @change="toggle(o.value)"
      />
      <span>{{ o.label }}</span>
    </label>
    <p v-if="!options.length" class="muted">暂无可选项</p>
  </div>
</template>

<style scoped>
.grid {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
}
.chip {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 5px 10px;
  border: 1px solid var(--border);
  border-radius: 16px;
  font-size: 13px;
  cursor: pointer;
}
.chip.on {
  border-color: var(--accent);
  background: rgba(196, 92, 38, 0.12);
}
.chip input {
  width: auto;
}
.muted {
  color: var(--muted);
  font-size: 13px;
}
</style>
