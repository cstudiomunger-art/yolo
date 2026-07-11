<script setup>
import { reactive, computed, ref, watch } from "vue";
import FieldInput from "@/components/fields/FieldInput.vue";
import { upsertRow, deleteRow } from "@/lib/crud";
import { slugify } from "@/lib/storage";
import { containsHtmlTags } from "@/lib/markdown";

const props = defineProps({
  tableKey: { type: String, required: true },
  schema: { type: Object, required: true },
  initial: { type: Object, default: null },
  presets: { type: Object, default: null }, // seed values for a new record
  deletable: { type: Boolean, default: true }, // show 删除 when editing an existing row
  initialSection: { type: String, default: "" }, // app_settings section key, e.g. legal_section
});
const emit = defineEmits(["saved", "cancel", "deleted"]);

const isNew = !props.initial;
const deleting = ref(false);

// build initial form: clone existing row, or defaults for a new one
function buildInitial() {
  const base = {};
  for (const f of props.schema.fields) {
    if (f.type === "section" || f.type === "image_upload" || f.type === "audio_upload" || f.type === "voice_variants") continue;
    if (props.initial && f.key in props.initial) {
      base[f.key] = props.initial[f.key];
    } else if (f.type === "bool") {
      base[f.key] = f.defaultTrue === true;
    } else if (f.type === "tags" || f.type === "string_list") {
      base[f.key] = [];
    } else {
      base[f.key] = null;
    }
  }
  // keep any extra columns from the existing row verbatim
  if (props.initial) Object.assign(base, { ...props.initial });
  // seed presets for new records (e.g. city_id / attraction_id from the tree)
  if (!props.initial && props.presets) {
    for (const [k, v] of Object.entries(props.presets)) {
      if (k.startsWith("_")) continue;
      base[k] = v;
    }
  }
  return base;
}

const form = reactive(buildInitial());
const saving = ref(false);
const error = ref("");
const showAdvanced = ref(false);

const pk = props.schema.pk || "id";

// slug field that seeds the entity id (for uploads + pk)
const slugField = props.schema.fields.find((f) => f.type === "slug");

const entityId = computed(() => {
  if (form[pk]) return String(form[pk]);
  if (slugField && slugField.slugSource && form[slugField.slugSource]) {
    return slugify(form[slugField.slugSource], slugField.slugPrefix);
  }
  return "";
});

const visibleFields = computed(() =>
  props.schema.fields.filter((f) => {
    if (!showAdvanced.value && f.advanced) return false;
    // conditional visibility: only show when another field has one of the listed values
    if (f.showWhen && !f.showWhen.values.includes(form[f.showWhen.field])) return false;
    return true;
  })
);

function fieldVisible(f) {
  if (!showAdvanced.value && f.advanced) return false;
  if (!showAdvanced.value && f.type === "slug") return false;
  if (f.showWhen && !f.showWhen.values.includes(form[f.showWhen.field])) return false;
  return true;
}

const groupedSections = computed(() => {
  if (!props.schema.groupedSections) return null;
  const sections = [{ key: "_general", label: "基础开关", hint: "", fields: [] }];
  let cur = sections[0];
  for (const f of props.schema.fields) {
    if (f.type === "section") {
      cur = { key: f.key, label: f.label || f.key, hint: f.hint || "", fields: [] };
      sections.push(cur);
      continue;
    }
    if (fieldVisible(f)) cur.fields.push(f);
  }
  return sections.filter((s) => s.fields.length > 0 || s.key !== "_general");
});

const activeSection = ref(props.initialSection || "_general");

watch(
  () => props.initialSection,
  (section) => {
    if (!section || !groupedSections.value) return;
    if (groupedSections.value.some((s) => s.key === section)) activeSection.value = section;
  },
  { immediate: true }
);

const activeSectionMeta = computed(() =>
  groupedSections.value?.find((s) => s.key === activeSection.value) || null
);

const fieldsToRender = computed(() => {
  if (!groupedSections.value) return visibleFields.value;
  return activeSectionMeta.value?.fields || [];
});

function buildPayload() {
  const payload = {};
  for (const f of props.schema.fields) {
    if (f.key.startsWith("_")) continue; // transient upload controls
    if (["section", "image_upload", "audio_upload", "voice_variants"].includes(f.type)) continue;
    let v = form[f.key];
    if (f.type === "slug" && (v == null || v === "")) {
      v = slugify(f.slugSource ? form[f.slugSource] : "", f.slugPrefix);
    }
    // On INSERT, omit null/undefined so NOT-NULL columns with a DB default
    // (e.g. attractions.category → 'sight', priority → 'P1') aren't forced to null.
    if (isNew && (v === null || v === undefined)) continue;
    payload[f.key] = v;
  }
  // carry over columns present on the original row but absent from schema
  if (props.initial) {
    for (const k of Object.keys(props.initial)) {
      if (!(k in payload) && !k.startsWith("_")) payload[k] = form[k];
    }
  }
  // carry preset columns that aren't schema fields (e.g. attraction_id fixed by parent)
  if (!props.initial && props.presets) {
    for (const k of Object.keys(props.presets)) {
      if (!(k in payload) && !k.startsWith("_")) payload[k] = form[k];
    }
  }
  return normalizePayloadForTable(props.tableKey, payload);
}

function normalizePayloadForTable(tableKey, payload) {
  if (tableKey !== "attractions") return payload;
  return normalizeAttractionPayload(payload);
}

function normalizeAttractionPayload(payload) {
  const weekdays = Array.isArray(payload.closed_weekdays)
    ? payload.closed_weekdays.map((v) => String(v).trim().toLowerCase()).filter(Boolean)
    : [];
  payload.closed_weekdays = weekdays;

  const open = typeof payload.open_time === "string" ? payload.open_time.trim() : "";
  const close = typeof payload.close_time === "string" ? payload.close_time.trim() : "";
  const lastEntry = typeof payload.last_entry_time === "string" ? payload.last_entry_time.trim() : "";

  if ((!payload.opening_hours || !String(payload.opening_hours).trim()) && (open || close)) {
    payload.opening_hours = [open, close].filter(Boolean).join(" - ");
    if (lastEntry) payload.opening_hours += ` (Last entry ${lastEntry})`;
  }
  if ((!payload.closed_days || !String(payload.closed_days).trim()) && weekdays.length) {
    payload.closed_days = weekdays.map((w) => w.charAt(0).toUpperCase() + w.slice(1)).join(", ");
  }

  payload.practical_info = upsertPracticalInfo(payload.practical_info, [
    { icon: "🕘", label: "Opening Hours", value: payload.opening_hours || "" },
    { icon: "❌", label: "Closed", value: payload.closed_days || "" },
  ]);
  return payload;
}

function upsertPracticalInfo(existing, entries) {
  const list = Array.isArray(existing) ? [...existing] : [];
  for (const entry of entries) {
    const idx = list.findIndex((item) => {
      const label = String(item?.label ?? "").toLowerCase();
      return label === entry.label.toLowerCase();
    });
    if (!entry.value) continue;
    const normalized = { icon: entry.icon, label: entry.label, value: entry.value };
    if (idx >= 0) list[idx] = normalized;
    else list.push(normalized);
  }
  return list;
}

function validate(payload) {
  for (const f of props.schema.fields) {
    if (f.required && (payload[f.key] == null || payload[f.key] === "")) {
      return `「${f.label || f.key}」为必填`;
    }
    if (f.type === "markdown") {
      const v = payload[f.key];
      if (v != null && v !== "" && containsHtmlTags(v)) {
        return `「${f.label || f.key}」含 HTML 标签，请改为 Markdown`;
      }
    }
  }
  return "";
}

async function save() {
  error.value = "";
  const payload = buildPayload();
  const msg = validate(payload);
  if (msg) {
    error.value = msg;
    return;
  }
  saving.value = true;
  try {
    const row = await upsertRow(props.tableKey, payload);
    emit("saved", row || payload);
  } catch (e) {
    error.value = e.message || String(e);
  } finally {
    saving.value = false;
  }
}

async function remove() {
  if (isNew) return;
  if (!confirm(`确定删除该「${props.schema.label}」？此操作不可撤销，且会级联删除其下属内容。`)) return;
  deleting.value = true;
  error.value = "";
  try {
    await deleteRow(props.tableKey, pk, props.initial[pk]);
    emit("deleted");
  } catch (e) {
    error.value = e.message || String(e);
  } finally {
    deleting.value = false;
  }
}

const hasAdvanced = props.schema.fields.some((f) => f.advanced);
</script>

<template>
  <div class="record-form">
    <div class="form-head">
      <h2>{{ isNew ? "新建" : "编辑" }} · {{ schema.label }}</h2>
      <div class="actions">
        <button
          v-if="!isNew && deletable"
          class="btn btn-danger btn-sm"
          :disabled="deleting"
          @click="remove"
        >
          {{ deleting ? "删除中…" : "删除" }}
        </button>
        <button class="btn btn-secondary btn-sm" @click="emit('cancel')">取消</button>
        <button class="btn btn-sm" :disabled="saving" @click="save">
          {{ saving ? "保存中…" : "保存" }}
        </button>
      </div>
    </div>

    <div v-if="error" class="status-bar error">{{ error }}</div>

    <div v-if="groupedSections" class="settings-nav">
      <button
        v-for="s in groupedSections"
        :key="s.key"
        type="button"
        class="settings-chip"
        :class="{ active: activeSection === s.key }"
        @click="activeSection = s.key"
      >
        {{ s.label }}
      </button>
    </div>

    <div v-if="activeSectionMeta?.hint" class="section-hint">{{ activeSectionMeta.hint }}</div>

    <FieldInput
      v-for="f in fieldsToRender"
      :key="f.key"
      :field="f"
      :record="form"
      :table-key="tableKey"
      :entity-id="entityId"
      :record-pk="pk"
      :record-id="isNew ? null : form[pk]"
    />

    <button v-if="hasAdvanced" class="btn btn-secondary btn-sm adv" @click="showAdvanced = !showAdvanced">
      {{ showAdvanced ? "隐藏高级字段" : "显示高级字段" }}
    </button>
  </div>
</template>

<style scoped>
.form-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 16px;
}
.form-head h2 {
  margin: 0;
  font-size: 18px;
}
.actions {
  display: flex;
  gap: 8px;
}
.status-bar.error {
  margin-bottom: 14px;
}
.adv {
  margin-top: 8px;
}
.settings-nav {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  margin-bottom: 16px;
}
.settings-chip {
  border: 1px solid var(--border);
  background: var(--surface2);
  color: var(--text);
  border-radius: 999px;
  padding: 6px 12px;
  font-size: 13px;
  cursor: pointer;
}
.settings-chip:hover {
  border-color: var(--accent);
}
.settings-chip.active {
  background: var(--accent);
  border-color: var(--accent);
  color: #fff;
}
.section-hint {
  color: var(--muted);
  font-size: 13px;
  margin: -6px 0 14px;
}
</style>
