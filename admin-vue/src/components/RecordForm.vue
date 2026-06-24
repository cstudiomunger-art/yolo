<script setup>
import { reactive, computed, ref } from "vue";
import FieldInput from "@/components/fields/FieldInput.vue";
import { upsertRow } from "@/lib/crud";
import { slugify } from "@/lib/storage";

const props = defineProps({
  tableKey: { type: String, required: true },
  schema: { type: Object, required: true },
  initial: { type: Object, default: null },
  presets: { type: Object, default: null }, // seed values for a new record
});
const emit = defineEmits(["saved", "cancel"]);

const isNew = !props.initial;

// build initial form: clone existing row, or defaults for a new one
function buildInitial() {
  const base = {};
  for (const f of props.schema.fields) {
    if (f.type === "section" || f.type === "image_upload" || f.type === "audio_upload") continue;
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
  props.schema.fields.filter((f) => showAdvanced.value || !f.advanced)
);

function buildPayload() {
  const payload = {};
  for (const f of props.schema.fields) {
    if (f.key.startsWith("_")) continue; // transient upload controls
    if (["section", "image_upload", "audio_upload"].includes(f.type)) continue;
    let v = form[f.key];
    if (f.type === "slug" && (v == null || v === "")) {
      v = slugify(f.slugSource ? form[f.slugSource] : "", f.slugPrefix);
    }
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
  return payload;
}

function validate(payload) {
  for (const f of props.schema.fields) {
    if (f.required && (payload[f.key] == null || payload[f.key] === "")) {
      return `「${f.label || f.key}」为必填`;
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

const hasAdvanced = props.schema.fields.some((f) => f.advanced);
</script>

<template>
  <div class="record-form">
    <div class="form-head">
      <h2>{{ isNew ? "新建" : "编辑" }} · {{ schema.label }}</h2>
      <div class="actions">
        <button class="btn btn-secondary btn-sm" @click="emit('cancel')">取消</button>
        <button class="btn btn-sm" :disabled="saving" @click="save">
          {{ saving ? "保存中…" : "保存" }}
        </button>
      </div>
    </div>

    <div v-if="error" class="status-bar error">{{ error }}</div>

    <FieldInput
      v-for="f in visibleFields"
      :key="f.key"
      :field="f"
      :record="form"
      :table-key="tableKey"
      :entity-id="entityId"
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
</style>
