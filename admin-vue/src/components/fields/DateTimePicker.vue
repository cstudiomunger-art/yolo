<script setup>
import { computed, ref, watch, onMounted, onBeforeUnmount } from "vue";

const props = defineProps({
  modelValue: { type: String, default: null },
  allowPermanent: { type: Boolean, default: false },
  label: { type: String, default: "" },
  minDate: { type: Date, default: null },
  inline: { type: Boolean, default: false },
  compact: { type: Boolean, default: false },
  /** 父组件告知当前为永久会员（modelValue 为 null 时展示「永久」勾选） */
  permanentActive: { type: Boolean, default: false },
});

const emit = defineEmits(["update:modelValue"]);

const open = ref(false);
const root = ref(null);
const isPermanent = ref(false);

const view = ref({ year: 0, month: 0 });
const hour = ref(23);
const minute = ref(59);

const WEEKDAYS = ["日", "一", "二", "三", "四", "五", "六"];

function fmtDisplay(iso) {
  if (!iso) return "永久";
  const d = new Date(iso);
  if (Number.isNaN(d.getTime())) return "—";
  return d.toLocaleString("zh-CN", {
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
    hour: "2-digit",
    minute: "2-digit",
  });
}

function syncFromValue(v) {
  if (v == null || v === "") {
    if (props.permanentActive) isPermanent.value = true;
    else if (!props.allowPermanent) isPermanent.value = false;
    // allowPermanent 且用户刚勾选「永久」时保留 isPermanent，勿被 watch 冲掉
    const now = new Date();
    view.value = { year: now.getFullYear(), month: now.getMonth() };
    hour.value = 23;
    minute.value = 59;
    return;
  }
  isPermanent.value = false;
  const d = new Date(v);
  if (Number.isNaN(d.getTime())) return;
  view.value = { year: d.getFullYear(), month: d.getMonth() };
  hour.value = d.getHours();
  minute.value = d.getMinutes();
}

watch(
  () => props.modelValue,
  (v) => syncFromValue(v),
  { immediate: true }
);

watch(
  () => props.permanentActive,
  (on) => {
    if (on && props.allowPermanent && (props.modelValue == null || props.modelValue === "")) {
      isPermanent.value = true;
    } else if (!on && props.modelValue) {
      isPermanent.value = false;
    }
  },
  { immediate: true }
);

function emitValue(date) {
  if (isPermanent.value) {
    emit("update:modelValue", null);
    return;
  }
  if (!date) return;
  const d = new Date(
    date.getFullYear(),
    date.getMonth(),
    date.getDate(),
    hour.value,
    minute.value,
    0,
    0
  );
  emit("update:modelValue", d.toISOString());
}

function selectDay(day) {
  isPermanent.value = false;
  const d = new Date(view.value.year, view.value.month, day);
  if (props.minDate && d < startOfDay(props.minDate)) return;
  emitValue(d);
}

function onTimeChange() {
  if (isPermanent.value || !props.modelValue) return;
  hour.value = Math.min(23, Math.max(0, Number(hour.value) || 0));
  minute.value = Math.min(59, Math.max(0, Number(minute.value) || 0));
  const cur = new Date(props.modelValue);
  if (Number.isNaN(cur.getTime())) return;
  emitValue(cur);
}

function setPermanent(on) {
  isPermanent.value = on;
  if (on) emit("update:modelValue", null);
  else addDays(365);
}

function addDays(n) {
  const now = new Date();
  let base = props.modelValue ? new Date(props.modelValue) : new Date(now);
  if (base < now) base = new Date(now);
  base.setDate(base.getDate() + n);
  base.setHours(23, 59, 0, 0);
  view.value = { year: base.getFullYear(), month: base.getMonth() };
  hour.value = base.getHours();
  minute.value = base.getMinutes();
  isPermanent.value = false;
  emit("update:modelValue", base.toISOString());
}

function startOfDay(d) {
  return new Date(d.getFullYear(), d.getMonth(), d.getDate());
}

function prevMonth() {
  let { year, month } = view.value;
  month -= 1;
  if (month < 0) { month = 11; year -= 1; }
  view.value = { year, month };
}

function nextMonth() {
  let { year, month } = view.value;
  month += 1;
  if (month > 11) { month = 0; year += 1; }
  view.value = { year, month };
}

const monthLabel = computed(() => {
  const d = new Date(view.value.year, view.value.month, 1);
  return d.toLocaleDateString("zh-CN", { year: "numeric", month: "long" });
});

const selectedParts = computed(() => {
  if (!props.modelValue) return null;
  const d = new Date(props.modelValue);
  if (Number.isNaN(d.getTime())) return null;
  return { year: d.getFullYear(), month: d.getMonth(), day: d.getDate() };
});

const calendarCells = computed(() => {
  const { year, month } = view.value;
  const first = new Date(year, month, 1);
  const startPad = first.getDay();
  const daysInMonth = new Date(year, month + 1, 0).getDate();
  const cells = [];
  for (let i = 0; i < startPad; i++) cells.push({ day: null, key: `p${i}` });
  for (let d = 1; d <= daysInMonth; d++) {
    const date = new Date(year, month, d);
    const disabled = props.minDate && date < startOfDay(props.minDate);
    const sel = selectedParts.value;
    const selected = sel && sel.year === year && sel.month === month && sel.day === d;
    const today = (() => {
      const t = new Date();
      return t.getFullYear() === year && t.getMonth() === month && t.getDate() === d;
    })();
    cells.push({ day: d, key: `d${d}`, disabled, selected, today });
  }
  return cells;
});

function toggleOpen() {
  open.value = !open.value;
  if (open.value) syncFromValue(props.modelValue);
}

function onDocClick(e) {
  if (!open.value || props.inline) return;
  if (root.value && !root.value.contains(e.target)) open.value = false;
}

onMounted(() => document.addEventListener("click", onDocClick));
onBeforeUnmount(() => document.removeEventListener("click", onDocClick));
</script>

<template>
  <div ref="root" class="dtp" :class="{ inline, compact }">
    <span v-if="label" class="dtp-label">{{ label }}</span>

    <div v-if="!inline" class="dtp-trigger-row">
      <button type="button" class="dtp-trigger" @click.stop="toggleOpen">
        <span class="dtp-trigger-text">{{ fmtDisplay(modelValue) }}</span>
        <span class="dtp-trigger-icon" aria-hidden="true">▾</span>
      </button>
    </div>

    <div v-if="inline || open" class="dtp-panel" @click.stop>
      <div class="dtp-presets">
        <button type="button" class="chip" @click="addDays(30)">+30 天</button>
        <button type="button" class="chip" @click="addDays(90)">+90 天</button>
        <button type="button" class="chip" @click="addDays(365)">+1 年</button>
        <label v-if="allowPermanent" class="chip perm">
          <input type="checkbox" :checked="isPermanent" @change="setPermanent($event.target.checked)" />
          永久
        </label>
      </div>

      <div v-if="!isPermanent" class="dtp-cal">
        <div class="dtp-cal-head">
          <button type="button" class="nav" @click="prevMonth">‹</button>
          <span class="month">{{ monthLabel }}</span>
          <button type="button" class="nav" @click="nextMonth">›</button>
        </div>
        <div class="dtp-weekdays">
          <span v-for="w in WEEKDAYS" :key="w">{{ w }}</span>
        </div>
        <div class="dtp-grid">
          <button
            v-for="c in calendarCells"
            :key="c.key"
            type="button"
            class="day"
            :class="{ off: !c.day, disabled: c.disabled, selected: c.selected, today: c.today }"
            :disabled="!c.day || c.disabled"
            @click="c.day && selectDay(c.day)"
          >
            {{ c.day || "" }}
          </button>
        </div>
        <div class="dtp-time">
          <span class="muted small">时刻</span>
          <input type="number" min="0" max="23" v-model.number="hour" @input="onTimeChange" />
          <span>:</span>
          <input type="number" min="0" max="59" v-model.number="minute" @input="onTimeChange" />
        </div>
      </div>
      <p v-else class="dtp-perm-hint muted small">不设置到期时间，会员永久有效</p>

      <div v-if="!inline" class="dtp-foot">
        <span class="muted small">{{ fmtDisplay(modelValue) }}</span>
        <button type="button" class="btn btn-sm" @click="open = false">确定</button>
      </div>
    </div>
  </div>
</template>

<style scoped>
.dtp { position: relative; }
.dtp.inline { width: auto; }
.dtp.compact .dtp-trigger {
  min-width: 200px;
  max-width: 260px;
}
.dtp-label {
  display: block;
  font-size: 12px;
  color: var(--muted);
  margin-bottom: 4px;
}
.dtp-trigger-row { display: flex; }
.dtp-trigger {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 8px;
  width: 100%;
  min-width: 220px;
  padding: 8px 12px;
  border: 1px solid var(--border);
  border-radius: var(--radius);
  background: var(--bg);
  color: var(--text);
  font-size: 13px;
  cursor: pointer;
  text-align: left;
}
.dtp-trigger:hover { border-color: var(--accent); }
.dtp-trigger-text { flex: 1; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
.dtp-trigger-icon { opacity: 0.55; font-size: 13px; flex-shrink: 0; }

.dtp-panel {
  padding: 12px;
  border: 1px solid var(--border);
  border-radius: 10px;
  background: var(--surface);
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
  z-index: 30;
  width: 268px;
}
.dtp:not(.inline) .dtp-panel {
  position: absolute;
  left: 0;
  top: calc(100% + 4px);
}
.dtp.inline .dtp-panel {
  margin-top: 6px;
  box-shadow: none;
  background: var(--surface2);
}

.dtp-presets {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
  margin-bottom: 10px;
}
.chip {
  border: 1px solid var(--border);
  background: var(--surface2);
  color: var(--text);
  border-radius: 14px;
  padding: 3px 9px;
  font-size: 11px;
  cursor: pointer;
  line-height: 1.4;
}
.chip:hover { border-color: var(--accent); color: var(--accent); }
.chip.perm {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  cursor: pointer;
  font-size: 11px;
}
.chip.perm input { width: auto; margin: 0; }

.dtp-cal-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 6px;
}
.dtp-cal-head .month { font-weight: 600; font-size: 13px; }
.nav {
  width: 26px;
  height: 26px;
  border: 1px solid var(--border);
  border-radius: 6px;
  background: var(--surface2);
  color: var(--text);
  cursor: pointer;
  font-size: 15px;
  line-height: 1;
  padding: 0;
}
.nav:hover { border-color: var(--accent); }

.dtp-weekdays,
.dtp-grid {
  display: grid;
  grid-template-columns: repeat(7, 32px);
  gap: 2px;
  justify-content: center;
}
.dtp-weekdays {
  margin-bottom: 4px;
  text-align: center;
  font-size: 11px;
  color: var(--muted);
}
.dtp-weekdays span { line-height: 24px; }

.day {
  width: 32px;
  height: 32px;
  padding: 0;
  border: none;
  border-radius: 8px;
  background: transparent;
  color: var(--text);
  font-size: 12px;
  line-height: 32px;
  text-align: center;
  cursor: pointer;
}
.day.off { visibility: hidden; pointer-events: none; }
.day:hover:not(.disabled):not(.off) { background: var(--surface2); }
.day.today { font-weight: 600; color: var(--accent); }
.day.selected {
  background: var(--accent);
  color: #fff;
  font-weight: 600;
}
.day.disabled { opacity: 0.3; cursor: not-allowed; }

.dtp-time {
  display: flex;
  align-items: center;
  gap: 6px;
  margin-top: 8px;
  padding-top: 8px;
  border-top: 1px solid var(--border);
  font-size: 12px;
}
.dtp-time input {
  width: 44px;
  padding: 4px 6px;
  text-align: center;
  margin-top: 0;
  font-size: 12px;
}
.dtp-perm-hint { margin: 2px 0 0; font-size: 12px; }
.dtp-foot {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-top: 8px;
  padding-top: 8px;
  border-top: 1px solid var(--border);
}
</style>
