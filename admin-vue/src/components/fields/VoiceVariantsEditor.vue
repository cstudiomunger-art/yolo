<script setup>
import { ref, watch } from "vue";
import { supabase } from "@/lib/supabase";
import { uploadVoiceVariantFile } from "@/lib/storage";
import {
  ensureLegacyVoiceVariants,
  syncParentAudioFromDefault,
  setDefaultVariant,
  newVariantId,
  readAudioDuration,
  hasDuplicateVoiceLabel,
  duplicateVoiceLabelMessage,
} from "@/lib/voiceVariants";

const props = defineProps({
  ownerType: { type: String, required: true },
  ownerId: { type: String, default: "" },
  canEdit: { type: Boolean, default: true },
  hint: { type: String, default: "" },
});

const emit = defineEmits(["changed"]);

const variants = ref([]);
const loading = ref(false);
const err = ref("");
const uploadingId = ref("");
const newLabel = ref("");

async function load() {
  if (!props.ownerId) {
    variants.value = [];
    return;
  }
  loading.value = true;
  err.value = "";
  try {
    variants.value = await ensureLegacyVoiceVariants(props.ownerType, props.ownerId);
  } catch (e) {
    err.value = e.message || String(e);
  } finally {
    loading.value = false;
  }
}

watch(() => [props.ownerType, props.ownerId], load, { immediate: true });

function formatDuration(sec) {
  const s = Number(sec) || 0;
  if (s <= 0) return "—";
  const m = Math.floor(s / 60);
  const r = s % 60;
  return `${m}:${String(r).padStart(2, "0")}`;
}

async function addVariant() {
  const label = newLabel.value.trim();
  if (!label) {
    err.value = "请填写音色名称";
    return;
  }
  if (!props.ownerId) {
    err.value = "请先保存记录（需要 ID）";
    return;
  }
  err.value = "";
  try {
    // Refresh so we don't treat an imported/migrated default row as "first".
    variants.value = await ensureLegacyVoiceVariants(props.ownerType, props.ownerId);
    if (hasDuplicateVoiceLabel(variants.value, label)) {
      err.value = duplicateVoiceLabelMessage(label);
      return;
    }
    const id = newVariantId(props.ownerType, props.ownerId, label);
    const isFirst = variants.value.length === 0;
    const payload = {
      id,
      owner_type: props.ownerType,
      owner_id: props.ownerId,
      voice_label: label,
      audio_url: "",
      duration_seconds: 0,
      segments: [],
      sort_order: variants.value.length,
      is_default: isFirst,
      is_active: true,
    };
    const { error: e } = await supabase.from("audio_voice_variants").insert(payload);
    if (e) {
      if (e.code === "23505") {
        await load();
        err.value = duplicateVoiceLabelMessage(label);
        return;
      }
      throw e;
    }
    newLabel.value = "";
    await load();
    if (isFirst) await syncParentAudioFromDefault(props.ownerType, props.ownerId);
    emit("changed");
  } catch (e) {
    err.value = e.message || String(e);
  }
}

async function onUpload(variant, e) {
  const file = e.target.files?.[0];
  if (!file) return;
  uploadingId.value = variant.id;
  err.value = "";
  try {
    const url = await uploadVoiceVariantFile(file, props.ownerType, props.ownerId, variant.id);
    const duration = (await readAudioDuration(file)) || variant.duration_seconds || 0;
    const { error: e2 } = await supabase
      .from("audio_voice_variants")
      .update({
        audio_url: url,
        duration_seconds: duration,
        updated_at: new Date().toISOString(),
      })
      .eq("id", variant.id);
    if (e2) throw e2;
    await load();
    if (variant.is_default) await syncParentAudioFromDefault(props.ownerType, props.ownerId);
    emit("changed");
  } catch (ex) {
    err.value = ex.message || String(ex);
  } finally {
    uploadingId.value = "";
    e.target.value = "";
  }
}

async function saveLabel(variant) {
  const label = variant.voice_label?.trim();
  if (!label) {
    err.value = "音色名称不能为空";
    return;
  }
  if (hasDuplicateVoiceLabel(variants.value, label, variant.id)) {
    err.value = duplicateVoiceLabelMessage(label);
    await load();
    return;
  }
  const { error: e } = await supabase
    .from("audio_voice_variants")
    .update({ voice_label: label, updated_at: new Date().toISOString() })
    .eq("id", variant.id);
  if (e) {
    if (e.code === "23505") {
      err.value = duplicateVoiceLabelMessage(label);
      await load();
      return;
    }
    err.value = e.message;
    return;
  }
  await load();
  emit("changed");
}

async function makeDefault(variant) {
  try {
    await setDefaultVariant(variant.id, props.ownerType, props.ownerId);
    await load();
    emit("changed");
  } catch (e) {
    err.value = e.message || String(e);
  }
}

async function removeVariant(variant) {
  if (!confirm(`确定删除音色「${variant.voice_label}」？`)) return;
  const { error: e } = await supabase.from("audio_voice_variants").delete().eq("id", variant.id);
  if (e) {
    err.value = e.message;
    return;
  }
  const remaining = variants.value.filter((v) => v.id !== variant.id);
  if (remaining.length && !remaining.some((v) => v.is_default)) {
    await setDefaultVariant(remaining[0].id, props.ownerType, props.ownerId);
  } else {
    await syncParentAudioFromDefault(props.ownerType, props.ownerId);
  }
  await load();
  emit("changed");
}
</script>

<template>
  <div class="voice-variants">
    <p v-if="hint" class="hint">{{ hint }}</p>
    <p v-else-if="ownerId && !loading && variants.length" class="hint">
      修改音色名称：直接编辑每行左侧输入框，点击框外或按 Enter 保存。「默认播放」表示 App 优先使用此条，与名称无关。
    </p>
    <p v-if="!ownerId" class="muted">请先保存记录后再管理音色。</p>
    <p v-else-if="loading" class="muted">加载音色…</p>

    <div v-else-if="variants.length === 0" class="legacy-hint">
      <p class="muted">尚无音频。请添加音色名称并上传文件；若父记录已有旧版音频，打开本页时会自动导入为「默认」音色。</p>
    </div>

    <div v-else class="list">
      <div v-for="v in variants" :key="v.id" class="row">
        <input
          v-model="v.voice_label"
          type="text"
          class="label-input"
          placeholder="音色名称"
          :disabled="!canEdit"
          @blur="saveLabel(v)"
          @keyup.enter="saveLabel(v)"
        />
        <span class="dur">{{ formatDuration(v.duration_seconds) }}</span>
        <span v-if="v.is_default" class="badge" title="App 未选音色时优先播放此条">默认播放</span>
        <audio v-if="v.audio_url" :src="v.audio_url" controls class="preview"></audio>
        <span v-else class="muted">未上传</span>
        <label v-if="canEdit" class="uploader">
          <span class="btn btn-sm">{{ uploadingId === v.id ? "上传中…" : v.audio_url ? "替换" : "上传" }}</span>
          <input type="file" accept="audio/*" hidden :disabled="!!uploadingId" @change="onUpload(v, $event)" />
        </label>
        <button
          v-if="canEdit && !v.is_default"
          type="button"
          class="btn btn-secondary btn-sm"
          @click="makeDefault(v)"
        >设默认</button>
        <button
          v-if="canEdit"
          type="button"
          class="btn btn-danger btn-sm"
          @click="removeVariant(v)"
        >删除</button>
      </div>
    </div>

    <div v-if="canEdit && ownerId" class="add-row">
      <input v-model="newLabel" type="text" placeholder="新音色名称（不可与已有重复），如 男声 · 沉稳" />
      <button type="button" class="btn btn-sm" @click="addVariant">添加音色</button>
    </div>

    <p v-if="err" class="err">{{ err }}</p>
  </div>
</template>

<style scoped>
.voice-variants { margin-top: 8px; }
.hint { font-size: 13px; color: var(--muted); margin: 0 0 12px; }
.muted { color: var(--muted); font-size: 13px; }
.list { display: flex; flex-direction: column; gap: 12px; }
.row {
  display: flex; flex-wrap: wrap; align-items: center; gap: 8px;
  padding: 10px 12px; border: 1px solid var(--border); border-radius: var(--radius);
}
.label-input { flex: 1; min-width: 140px; }
.dur { font-size: 12px; color: var(--muted); font-variant-numeric: tabular-nums; }
.badge {
  font-size: 11px; color: var(--accent);
  border: 1px solid var(--accent); border-radius: 4px; padding: 1px 6px;
}
.preview { flex: 1; min-width: 180px; max-width: 320px; height: 32px; }
.uploader { cursor: pointer; }
.add-row { display: flex; gap: 8px; margin-top: 14px; align-items: center; }
.add-row input { flex: 1; }
.err { color: var(--accent); font-size: 13px; margin-top: 10px; }
</style>
