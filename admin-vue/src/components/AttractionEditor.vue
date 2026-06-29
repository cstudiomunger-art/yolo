<script setup>
import { ref, watch, computed } from "vue";
import { TABLES } from "@/schema/tables";
import { fetchOne } from "@/lib/crud";
import { supabase } from "@/lib/supabase";
import { useNav } from "@/stores/nav";
import RecordForm from "@/components/RecordForm.vue";
import VoiceVariantsEditor from "@/components/fields/VoiceVariantsEditor.vue";

const nav = useNav();

const props = defineProps({ attractionId: { type: String, required: true } });

const attraction = ref(null);
const audioGuide = ref(null);
const loading = ref(false);
const error = ref("");
const toast = ref("");

const guideOwnerId = computed(() => audioGuide.value?.id || "");

function showToast(m) { toast.value = m; setTimeout(() => (toast.value = ""), 1800); }

async function ensureAudioGuideRow() {
  if (audioGuide.value?.id) return audioGuide.value.id;
  const guideId = `ag_${props.attractionId}`;
  const payload = {
    id: guideId,
    attraction_id: props.attractionId,
    title_en: "Literary Audio Tour",
    audio_url: "",
    duration_seconds: 0,
    is_main_guide: true,
    is_active: true,
    sort_order: 0,
    segments: [],
  };
  const { error: e } = await supabase.from("audio_guides").upsert(payload);
  if (e) throw e;
  await load();
  return guideId;
}

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

async function onVoiceChanged() {
  try {
    await ensureAudioGuideRow();
    showToast("音频已更新");
  } catch (e) {
    error.value = e.message || String(e);
  }
}

async function prepareVoiceEditor() {
  try {
    await ensureAudioGuideRow();
  } catch (e) {
    error.value = e.message || String(e);
  }
}

function onAttractionDeleted() {
  nav.requestReload();
  nav.select({ kind: "placeholder", label: "景点已删除 · ← 从左侧选择内容" });
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
      @deleted="onAttractionDeleted"
      @cancel="() => {}"
    />

    <div class="audio-sec">
      <h2>🎧 音频导览</h2>
      <p class="hint">可为该景点上传多个音色解说。选择文件即上传并保存；请标记一个默认音色（同步至 App 旧版）。</p>
      <button v-if="!guideOwnerId" type="button" class="btn btn-sm" @click="prepareVoiceEditor">初始化音频导览</button>
      <VoiceVariantsEditor
        v-else
        owner-type="audio_guide"
        :owner-id="guideOwnerId"
        @changed="onVoiceChanged"
      />
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
.toast { position: fixed; bottom: 26px; left: 50%; transform: translateX(-50%); background: var(--text); color: var(--bg); padding: 10px 18px; border-radius: 8px; font-size: 13px; opacity: 0; pointer-events: none; transition: opacity 0.2s; z-index: 1100; }
.toast.on { opacity: 1; }
</style>
