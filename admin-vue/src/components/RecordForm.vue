<script setup>
import { reactive, computed, ref } from "vue";
import FieldInput from "@/components/fields/FieldInput.vue";
import { upsertRow, deleteRow } from "@/lib/crud";
import { slugify } from "@/lib/storage";

const props = defineProps({
  tableKey: { type: String, required: true },
  schema: { type: Object, required: true },
  initial: { type: Object, default: null },
  presets: { type: Object, default: null }, // seed values for a new record
  deletable: { type: Boolean, default: true }, // show 删除 when editing an existing row
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
