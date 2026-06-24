<script setup>
import { ref, watch } from "vue";
import { TABLES } from "@/schema/tables";
import { fetchOne } from "@/lib/crud";
import { supabase } from "@/lib/supabase";
import { uploadAudioGuideFile } from "@/lib/storage";
import { useNav } from "@/stores/nav";
import RecordForm from "@/components/RecordForm.vue";

const nav = useNav();

/**
 * 解说与详情 = attraction main info + a single audio upload for THIS attraction.
 * Audio metadata (title / id / main-guide flag) is handled automatically — the
 * editor only exposes "upload one audio file".
 */
const props = defineProps({ attractionId: { type: String, required: true } });

const attraction = ref(null);
const audioGuide = ref(null); // existing main guide row, or null
const loading = ref(false);
const error = ref("");
const uploading = ref(false);
const audioErr = ref("");
const toast = ref("");

function showToast(m) { toast.value = m; setTimeout(() => (toast.value = ""), 1800); }

async function load() {
  loading.value = true;
  error.value = "";
  try {
    attraction.value = await fetchOne("attractions", "id", props.attractionId);
    const { data } = await supabase
      .from("audio_guides")
      .select("*")
      .eq("attraction_id", props.attractionId)
      .order("is_main_guide", { ascending: false })
      .order("sort_order", { ascending: true })
      .limit(1);
    audioGuide.value = (data && data[0]) || null;
  } catch (e) {
    error.value = e.message || String(e);
  } finally {
    loading.value = false;
  }
}
watch(() => props.attractionId, load, { immediate: true });

// read duration from the file locally so {duration} paywall template stays correct
function readDuration(file) {
  return new Promise((resolve) => {
    const a = document.createElement("audio");
    a.preload = "metadata";
    a.onloadedmetadata = () => { resolve(Math.round(a.duration) || 0); URL.revokeObjectURL(a.src); };
    a.onerror = () => resolve(0);
    a.src = URL.createObjectURL(file);
  });
}

async function onFile(e) {
  const file = e.target.files?.[0];
  if (!file) return;
  audioErr.value = "";
  uploading.value = true;
  try {
    const guideId = audioGuide.value?.id || `ag_${props.attractionId}`;
    const url = await uploadAudioGuideFile(file, guideId);
    const duration = (await readDuration(file)) || audioGuide.value?.duration_seconds || 0;
    const payload = {
      id: guideId,
      attraction_id: props.attractionId,
      title_en: audioGuide.value?.title_en || "Literary Audio Tour",
      audio_url: url,
      duration_seconds: duration,
      is_main_guide: true,
      is_active: true,
      sort_order: 0,
    };
    const { error: e2 } = await supabase.from("audio_guides").upsert(payload);
    if (e2) throw e2;
    await load();
    showToast("音频已上传并保存");
  } catch (err) {
    audioErr.value = err.message || String(err);
  } finally {
    uploading.value = false;
    e.target.value = "";
  }
}

async function removeAudio() {
  if (!audioGuide.value) return;
  if (!confirm("确定移除该景点的音频？")) return;
  const { error: e } = await supabase.from("audio_guides").delete().eq("id", audioGuide.value.id);
  if (e) { audioErr.value = e.message; return; }
  await load();
  showToast("已移除");
}
</script>

<template>
  <div v-if="loading">加载中…</div>
  <div v-else-if="error" class="status-bar error">{{ error }}</div>
  <div v-else>
    <RecordForm
      v-if="attraction"
      :key="'attr-' + attractionId"
      table-key="attractions"
      :schema="TABLES.attractions"
      :initial="attraction"
      @saved="() => nav.requestReload()"
      @cancel="() => {}"
    />

    <div class="audio-sec">
      <h2>🎧 音频导览</h2>
      <p class="hint">该景点的音频。选择文件即上传并保存（标题等自动处理）。</p>

      <div v-if="audioGuide?.audio_url" class="current">
        <audio :src="audioGuide.audio_url" controls></audio>
        <button class="btn btn-secondary btn-sm" @click="removeAudio">移除音频</button>
      </div>
      <p v-else class="muted">（尚未上传音频）</p>

      <label class="uploader">
        <span class="btn btn-sm">{{ uploading ? "上传中…" : audioGuide?.audio_url ? "替换音频" : "上传音频" }}</span>
        <input type="file" accept="audio/*" hidden @change="onFile" :disabled="uploading" />
      </label>
      <p v-if="audioErr" class="err">{{ audioErr }}</p>
    </div>

    <div class="toast" :class="{ on: toast }">{{ toast }}</div>
  </div>
</template>

<style scoped>
.audio-sec {
  margin-top: 28px;
  padding-top: 20px;
  border-top: 2px solid var(--border);
}
.audio-sec h2 { margin: 0 0 4px; font-size: 18px; }
.hint { font-size: 13px; color: var(--muted); margin: 0 0 16px; }
.current { display: flex; align-items: center; gap: 12px; margin-bottom: 14px; }
.current audio { flex: 1; max-width: 480px; }
.muted { color: var(--muted); font-size: 13px; margin: 0 0 14px; }
.uploader { display: inline-block; cursor: pointer; }
.err { color: var(--accent); font-size: 13px; margin-top: 10px; }
.toast { position: fixed; bottom: 26px; left: 50%; transform: translateX(-50%); background: var(--text); color: var(--bg); padding: 10px 18px; border-radius: 8px; font-size: 13px; opacity: 0; pointer-events: none; transition: opacity 0.2s; z-index: 1100; }
.toast.on { opacity: 1; }
</style>
