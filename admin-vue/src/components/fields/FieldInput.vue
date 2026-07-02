<script setup>
import { computed, ref } from "vue";
import { supabase } from "@/lib/supabase";
import { useRefCache } from "@/stores/refCache";
import { PRACTICAL_INFO_PRESETS } from "@/schema/tables";
import RichText from "@/components/fields/RichText.vue";
import ObjectListEditor from "@/components/fields/ObjectListEditor.vue";
import MultiCheck from "@/components/fields/MultiCheck.vue";
import ImageUrlList from "@/components/fields/ImageUrlList.vue";
import PaymentMatch from "@/components/fields/PaymentMatch.vue";
import ItineraryBuilder from "@/components/fields/ItineraryBuilder.vue";
import MarkdownField from "@/components/fields/MarkdownField.vue";
import VoiceVariantsEditor from "@/components/fields/VoiceVariantsEditor.vue";
import {
  uploadCoverImage,
  uploadSubAreaAudioFile,
  uploadAudioGuideFile,
  uploadCityGuideAudioFile,
  uploadPhraseAudioFile,
  resolveCoverImageUrl,
} from "@/lib/storage";

const props = defineProps({
  field: { type: Object, required: true },
  record: { type: Object, required: true },
  tableKey: { type: String, required: true },
  entityId: { type: String, default: "" },
});

const refCache = useRefCache();
const uploading = ref(false);
const uploadErr = ref("");
const f = props.field;

const val = computed({
  get: () => props.record[f.key],
  set: (v) => { props.record[f.key] = v; },
});

const csv = computed({
  get: () => (Array.isArray(props.record[f.key]) ? props.record[f.key].join(", ") : ""),
  set: (v) => {
    props.record[f.key] = v.split(",").map((s) => s.trim()).filter(Boolean);
  },
});

const jsonText = computed({
  get: () => {
    const v = props.record[f.key];
    if (v == null) return "";
    return typeof v === "string" ? v : JSON.stringify(v, null, 2);
  },
  set: (v) => {
    try {
      props.record[f.key] = v.trim() ? JSON.parse(v) : null;
      jsonError.value = "";
    } catch (e) {
      jsonError.value = "JSON 格式错误";
    }
  },
});
const jsonError = ref("");

function isType(...types) {
  return types.includes(f.type);
}

// ---- object-list column specs ----
const LIST_COLUMNS = {
  link_list: [
    { key: "label", label: "按钮文案", placeholder: "如 Booking.com" },
    { key: "url", label: "链接 URL", type: "url", placeholder: "https://..." },
  ],
  place_list: [
    { key: "name", label: "名称" },
    { key: "distance", label: "距离" },
  ],
  contact_list: [
    { key: "label", label: "名称" },
    { key: "number", label: "号码" },
    { key: "note", label: "备注" },
  ],
  help_phrase_list: [
    { key: "chinese", label: "中文" },
    { key: "pinyin", label: "拼音" },
    { key: "english", label: "英文" },
  ],
  flight_platform_list: [
    { key: "id", label: "平台 ID", placeholder: "skyscanner" },
    { key: "label", label: "显示名", placeholder: "Skyscanner" },
    { key: "url_template", label: "链接", type: "url", placeholder: "https://..." },
  ],
  segment_list: [
    { key: "title", label: "标题", placeholder: "如 Intro / History" },
    { key: "start_seconds", label: "起始秒", type: "number" },
  ],
  visa_detail_list: [
    { key: "label", label: "标签" },
    { key: "value", label: "内容" },
  ],
  practical_info_list: [
    { key: "icon", label: "图标" },
    { key: "label", label: "标签" },
    { key: "value", label: "内容" },
  ],
};
const isObjectList = computed(() => Boolean(LIST_COLUMNS[f.type]));

const imagePreviewSrc = computed(() => {
  if (!isType("image_preview", "image_thumb", "image_url")) return "";
  return resolveCoverImageUrl(val.value);
});

// ---- multi-check options ----
const multiOptions = computed(() => {
  switch (f.type) {
    case "ref_cities_multi":
      return refCache.cities.map((c) => ({ value: c.id, label: `${c.emoji || ""} ${c.chinese_name || c.name}`.trim() }));
    case "ref_attractions_multi":
      return refCache.attractions.map((a) => ({ value: a.id, label: a.chinese_name || a.name }));
    case "ref_countries_multi":
      return refCache.countries.map((c) => ({ value: c.code, label: `${c.flag || ""} ${c.name}`.trim() }));
    case "ref_ports_multi":
      return refCache.ports.map((p) => ({ value: p.code, label: p.name_zh || p.code }));
    case "enum_multi":
    case "weekday_multiselect":
      return (f.options || []).map((o) => (typeof o === "string" ? { value: o, label: o } : o));
    default:
      return [];
  }
});
const isMulti = computed(() =>
  ["ref_cities_multi", "ref_attractions_multi", "ref_countries_multi", "ref_ports_multi", "enum_multi", "weekday_multiselect"].includes(f.type)
);

const multiVal = computed({
  get: () => (Array.isArray(props.record[f.key]) ? props.record[f.key] : []),
  set: (v) => { props.record[f.key] = v; },
});

// ---- single-select ref options ----
const singleRefOptions = computed(() => {
  switch (f.type) {
    case "ref_scenario":
      return refCache.scenarios.map((s) => ({ value: s.id, label: s.label || s.id }));
    case "ref_country":
      return refCache.countries.map((c) => ({ value: c.code, label: `${c.flag || ""} ${c.name}`.trim() }));
    case "ref_visa_country":
      return refCache.countriesV2.map((c) => ({ value: c.country_code, label: `${c.flag_emoji || ""} ${c.name_zh || ""} · ${c.country_code}`.trim() }));
    case "ref_user":
      return refCache.users.map((u) => ({ value: u.id, label: u.email || u.display_name || u.id }));
    case "ref_visa_policy_v2":
      return refCache.visaPoliciesV2.map((p) => ({ value: p.id, label: `${p.id} · ${p.official_name_zh || ""}`.trim() }));
    default:
      return [];
  }
});
const isSingleRef = computed(() =>
  ["ref_scenario", "ref_country", "ref_visa_country", "ref_user", "ref_visa_policy_v2"].includes(f.type)
);

const attractionOptions = computed(() => {
  const cityId = f.filterByCityField ? props.record[f.filterByCityField] : null;
  return cityId ? refCache.attractionsForCity(cityId) : refCache.attractions;
});

const enumOptions = computed(() =>
  (f.options || []).map((o) => (typeof o === "string" ? { value: o, label: o } : o))
);

const JSON_TYPES = new Set(["json"]);

async function clearImage() {
  if (!confirm("确定移除该图片？保存后 App 将不再显示。")) return;
  const url = props.record[f.key];
  // best-effort: remove the underlying file from the cover-images bucket
  try {
    const marker = "/cover-images/";
    if (typeof url === "string" && url.includes(marker)) {
      const path = decodeURIComponent(url.split(marker)[1].split("?")[0]);
      await supabase.storage.from("cover-images").remove([path]);
    }
  } catch (e) {
    /* ignore — clearing the field reference is what matters */
  }
  props.record[f.key] = null;
}

async function onImageFile(e) {
  const file = e.target.files?.[0];
  if (!file) return;
  uploadErr.value = "";
  if (!props.entityId) {
    uploadErr.value = "请先填写名称/英文名以生成 ID，再上传";
    e.target.value = "";
    return;
  }
  uploading.value = true;
  try {
    const url = await uploadCoverImage(file, f.uploadFolder || "misc", props.entityId);
    if (f.uploadTarget) props.record[f.uploadTarget] = url;
  } catch (err) {
    uploadErr.value = err.message || String(err);
  } finally {
    uploading.value = false;
    e.target.value = "";
  }
}

async function onAudioFile(e) {
  const file = e.target.files?.[0];
  if (!file) return;
  uploadErr.value = "";
  uploading.value = true;
  try {
    let url;
    if (f.subAreaDirect) url = await uploadSubAreaAudioFile(file, props.entityId);
    else if (props.tableKey === "city_guides") url = await uploadCityGuideAudioFile(file, props.entityId);
    else if (props.tableKey === "common_phrases" || props.tableKey === "dialect_phrases")
      url = await uploadPhraseAudioFile(file, props.entityId);
    else url = await uploadAudioGuideFile(file, props.entityId);
    if ("audio_url" in props.record) props.record.audio_url = url;
  } catch (err) {
    uploadErr.value = err.message || String(err);
  } finally {
    uploading.value = false;
    e.target.value = "";
  }
}
</script>

<template>
  <div v-if="isType('section')" class="field-section">
    <h3>{{ f.label }}</h3>
    <p v-if="f.hint" class="hint">{{ f.hint }}</p>
  </div>

  <div v-else class="field">
    <label v-if="f.type !== 'bool'">
      {{ f.label || f.key }}<span v-if="f.required" class="req">*</span>
    </label>

    <input v-if="isType('text', 'slug')" v-model="val" type="text" :readonly="f.readonly"
      :placeholder="f.type === 'slug' ? '留空则自动生成' : ''" />

    <input v-else-if="isType('number')" v-model.number="val" type="number" step="any" />

    <input v-else-if="isType('time')" v-model="val" type="time" />

    <textarea v-else-if="isType('textarea')" v-model="val" rows="4"></textarea>

    <!-- features_list: newline-joined string -->
    <textarea v-else-if="isType('features_list')" v-model="val" rows="4" placeholder="每行一条权益"></textarea>

    <label v-else-if="isType('bool')" class="bool">
      <input type="checkbox" v-model="val" />
      <span>{{ f.label || f.key }}</span>
    </label>

    <select v-else-if="isType('enum')" v-model="val">
      <option v-if="f.allowEmpty" :value="null">— 不设置 —</option>
      <option v-for="o in enumOptions" :key="o.value" :value="o.value">{{ o.label }}</option>
    </select>

    <RichText v-else-if="isType('richtext')" v-model="val" :entity-id="entityId" />

    <input v-else-if="isType('tags', 'string_list')" v-model="csv" type="text" placeholder="逗号分隔" />

    <select v-else-if="isType('ref_city')" v-model="val">
      <option v-if="f.allowEmpty" :value="null">— 不设置 —</option>
      <option v-for="c in refCache.cities" :key="c.id" :value="c.id">
        {{ (c.emoji || "") + " " + (c.chinese_name || c.name) }}
      </option>
    </select>

    <select v-else-if="isType('ref_attraction')" v-model="val">
      <option v-if="f.allowEmpty" :value="null">— 不设置 —</option>
      <option v-for="a in attractionOptions" :key="a.id" :value="a.id">{{ a.chinese_name || a.name }}</option>
    </select>

    <!-- single-select ref family -->
    <select v-else-if="isSingleRef" v-model="val">
      <option :value="null">— 不设置 —</option>
      <option v-for="o in singleRefOptions" :key="o.value" :value="o.value">{{ o.label }}</option>
    </select>

    <!-- multi-check family -->
    <MultiCheck v-else-if="isMulti" v-model="multiVal" :options="multiOptions" />

    <!-- object-list family -->
    <ObjectListEditor
      v-else-if="isObjectList"
      v-model="val"
      :columns="LIST_COLUMNS[f.type]"
      :presets="f.type === 'practical_info_list' ? PRACTICAL_INFO_PRESETS : []"
    />

    <!-- image url list (with gallery upload) -->
    <ImageUrlList v-else-if="isType('image_url_list')" v-model="val"
      :folder="f.uploadFolder || 'misc'" :entity-id="entityId" />

    <!-- payment match object -->
    <PaymentMatch v-else-if="isType('payment_match')" v-model="val" />

    <!-- markdown editor with inline image upload -->
    <MarkdownField v-else-if="isType('markdown')" v-model="val"
      :entity-id="entityId" :folder="f.uploadFolder || 'payment-articles'" />

    <!-- itinerary builder -->
    <ItineraryBuilder v-else-if="isType('itinerary_builder')" v-model="val" />

    <!-- image preview / url -->
    <div v-else-if="isType('image_preview', 'image_thumb', 'image_url')" class="preview">
      <img v-if="imagePreviewSrc" :src="imagePreviewSrc" alt="" class="img" />
      <span v-else-if="!val" class="muted">（无图）</span>
      <span v-else class="muted">（无法预览，请检查 cover_image_path）</span>
      <input v-if="isType('image_url')" v-model="val" type="text" placeholder="图片 URL" />
      <button v-if="val" type="button" class="btn btn-danger btn-sm" @click="clearImage">移除图片</button>
    </div>

    <div v-else-if="isType('image_upload')" class="upload">
      <input type="file" accept="image/jpeg,image/png,image/webp" @change="onImageFile" :disabled="uploading" />
      <span v-if="uploading" class="muted">上传中…</span>
    </div>

    <div v-else-if="isType('audio_preview')" class="preview">
      <audio v-if="val" :src="val" controls class="audio"></audio>
      <span v-else class="muted">（无音频）</span>
    </div>

    <div v-else-if="isType('audio_upload')" class="upload">
      <input type="file" accept="audio/*" @change="onAudioFile" :disabled="uploading" />
      <span v-if="uploading" class="muted">上传中…</span>
    </div>

    <VoiceVariantsEditor
      v-else-if="isType('voice_variants')"
      :owner-type="f.ownerType"
      :owner-id="entityId"
      :hint="f.hint"
      :can-edit="!!entityId"
    />

    <!-- advance reminder days: presets + custom -->
    <div v-else-if="isType('reminder_days')" class="rdays">
      <div class="chips">
        <button type="button" class="chip" :class="{ on: val == null }" @click="val = null">不提醒</button>
        <button
          v-for="p in [3, 5, 7, 10, 15, 30, 45]"
          :key="p"
          type="button"
          class="chip"
          :class="{ on: Number(val) === p }"
          @click="val = p"
        >{{ p }} 天</button>
      </div>
      <input
        class="custom"
        type="number"
        min="1"
        :value="val ?? ''"
        @input="val = $event.target.value === '' ? null : Number($event.target.value)"
        placeholder="自定义天数"
      />
    </div>

    <!-- JSON fallback (json type + any unhandled) -->
    <template v-else-if="JSON_TYPES.has(f.type) || true">
      <textarea v-model="jsonText" rows="6" class="mono" spellcheck="false"></textarea>
      <span v-if="jsonError" class="err">{{ jsonError }}</span>
    </template>

    <p v-if="f.hint && f.type !== 'bool' && f.type !== 'section'" class="hint">{{ f.hint }}</p>
    <p v-if="uploadErr" class="err">{{ uploadErr }}</p>
  </div>
</template>

<style scoped>
.field { margin-bottom: 16px; }
.field > label { display: block; font-size: 13px; color: var(--muted); margin-bottom: 6px; }
.req { color: var(--accent); margin-left: 2px; }
.bool { display: flex; align-items: center; gap: 8px; font-size: 14px; cursor: pointer; }
.bool input { width: auto; }
.field-section { margin: 24px 0 12px; padding-top: 12px; border-top: 1px solid var(--border); }
.field-section h3 { margin: 0; font-size: 15px; }
.hint { font-size: 12px; color: var(--muted); margin: 6px 0 0; }
.err { font-size: 12px; color: var(--accent); margin: 6px 0 0; }
.preview .img { max-width: 200px; max-height: 140px; border-radius: var(--radius); border: 1px solid var(--border); display: block; }
.preview .audio { width: 100%; }
.muted { color: var(--muted); font-size: 13px; }
.mono { font-family: ui-monospace, Menlo, monospace; font-size: 12px; }
.rdays .chips { display: flex; flex-wrap: wrap; gap: 6px; margin-bottom: 8px; }
.rdays .chip { padding: 5px 12px; border: 1px solid var(--border); border-radius: 16px; background: transparent; color: var(--text); font-size: 13px; cursor: pointer; }
.rdays .chip.on { border-color: var(--accent); background: rgba(196, 92, 38, 0.12); color: var(--accent); }
.rdays .custom { width: auto; min-width: 140px; }
</style>
