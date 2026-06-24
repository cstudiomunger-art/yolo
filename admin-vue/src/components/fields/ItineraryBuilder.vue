<script setup>
import { computed } from "vue";
import { useRefCache } from "@/stores/refCache";

/** days: [{ id, date_label, city_id, cost_estimate, activities:[
 *           { name, attraction_id, time_slot, detail, has_audio } ] }] */
const props = defineProps({ modelValue: { type: Array, default: () => [] } });
const emit = defineEmits(["update:modelValue"]);

const refCache = useRefCache();
const TIME_SLOTS = ["AM", "PM", "EVE"];

const days = computed(() => (Array.isArray(props.modelValue) ? props.modelValue : []));

function commit(next) {
  emit("update:modelValue", next);
}
function clone() {
  return days.value.map((d) => ({ ...d, activities: (d.activities || []).map((a) => ({ ...a })) }));
}
function addDay() {
  const next = clone();
  next.push({ id: `day_${next.length + 1}`, date_label: "", city_id: "", cost_estimate: "", activities: [] });
  commit(next);
}
function removeDay(di) {
  commit(clone().filter((_, i) => i !== di));
}
function moveDay(di, dir) {
  const j = di + dir;
  if (j < 0 || j >= days.value.length) return;
  const next = clone();
  [next[di], next[j]] = [next[j], next[di]];
  commit(next);
}
function setDay(di, key, value) {
  const next = clone();
  next[di][key] = value;
  commit(next);
}
function addActivity(di) {
  const next = clone();
  next[di].activities.push({ name: "", attraction_id: "", time_slot: "AM", detail: "", has_audio: false });
  commit(next);
}
function removeActivity(di, ai) {
  const next = clone();
  next[di].activities.splice(ai, 1);
  commit(next);
}
function setActivity(di, ai, key, value) {
  const next = clone();
  next[di].activities[ai][key] = value;
  commit(next);
}
function attractionsForDay(di) {
  const cityId = days.value[di].city_id;
  return cityId ? refCache.attractionsForCity(cityId) : refCache.attractions;
}
</script>

<template>
  <div class="itin">
    <div v-for="(day, di) in days" :key="di" class="day">
      <div class="day-head">
        <strong>第 {{ di + 1 }} 天</strong>
        <span class="moves">
          <button type="button" class="btn btn-secondary btn-sm" @click="moveDay(di, -1)">↑</button>
          <button type="button" class="btn btn-secondary btn-sm" @click="moveDay(di, 1)">↓</button>
          <button type="button" class="btn btn-secondary btn-sm" @click="removeDay(di)">删除天</button>
        </span>
      </div>
      <div class="day-fields">
        <label>日期标签
          <input type="text" :value="day.date_label" @input="setDay(di, 'date_label', $event.target.value)" />
        </label>
        <label>城市
          <select :value="day.city_id" @change="setDay(di, 'city_id', $event.target.value)">
            <option value="">— 选择城市 —</option>
            <option v-for="c in refCache.cities" :key="c.id" :value="c.id">
              {{ (c.emoji || "") + " " + (c.chinese_name || c.name) }}
            </option>
          </select>
        </label>
        <label>费用估算
          <input type="text" :value="day.cost_estimate" @input="setDay(di, 'cost_estimate', $event.target.value)" />
        </label>
      </div>

      <div class="acts">
        <div v-for="(act, ai) in day.activities" :key="ai" class="act">
          <input class="a-name" type="text" placeholder="活动名称" :value="act.name" @input="setActivity(di, ai, 'name', $event.target.value)" />
          <select :value="act.time_slot" @change="setActivity(di, ai, 'time_slot', $event.target.value)">
            <option v-for="t in TIME_SLOTS" :key="t" :value="t">{{ t }}</option>
          </select>
          <select :value="act.attraction_id" @change="setActivity(di, ai, 'attraction_id', $event.target.value)">
            <option value="">— 关联景点（可选）—</option>
            <option v-for="a in attractionsForDay(di)" :key="a.id" :value="a.id">{{ a.chinese_name || a.name }}</option>
          </select>
          <input class="a-detail" type="text" placeholder="说明" :value="act.detail" @input="setActivity(di, ai, 'detail', $event.target.value)" />
          <label class="a-audio"><input type="checkbox" :checked="act.has_audio" @change="setActivity(di, ai, 'has_audio', $event.target.checked)" /> 语音</label>
          <button type="button" class="btn btn-secondary btn-sm" @click="removeActivity(di, ai)">删</button>
        </div>
        <button type="button" class="btn btn-secondary btn-sm" @click="addActivity(di)">+ 添加活动</button>
      </div>
    </div>
    <button type="button" class="btn btn-secondary btn-sm add-day" @click="addDay">+ 添加一天</button>
  </div>
</template>

<style scoped>
.itin {
  border: 1px solid var(--border);
  border-radius: var(--radius);
  padding: 10px;
}
.day {
  border: 1px solid var(--border);
  border-radius: var(--radius);
  padding: 10px;
  margin-bottom: 10px;
  background: var(--surface);
}
.day-head {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 8px;
}
.moves {
  display: flex;
  gap: 4px;
}
.day-fields {
  display: grid;
  grid-template-columns: 1fr 1fr 1fr;
  gap: 8px;
  margin-bottom: 10px;
}
.day-fields label {
  font-size: 12px;
  color: var(--muted);
}
.acts {
  border-top: 1px dashed var(--border);
  padding-top: 8px;
}
.act {
  display: grid;
  grid-template-columns: 1.4fr 70px 1.4fr 1.6fr auto auto;
  gap: 6px;
  align-items: center;
  margin-bottom: 6px;
}
.a-audio {
  display: flex;
  align-items: center;
  gap: 4px;
  font-size: 12px;
  white-space: nowrap;
}
.a-audio input {
  width: auto;
}
.add-day {
  margin-top: 4px;
}
</style>
