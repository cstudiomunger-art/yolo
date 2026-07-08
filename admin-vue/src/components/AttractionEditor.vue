<script setup>
import { ref, watch, computed } from "vue";
import { TABLES } from "@/schema/tables";
import { fetchOne } from "@/lib/crud";
import { supabase } from "@/lib/supabase";
import { useNav } from "@/stores/nav";
import { slugify } from "@/lib/storage";
import RecordForm from "@/components/RecordForm.vue";
import VoiceVariantsEditor from "@/components/fields/VoiceVariantsEditor.vue";

const nav = useNav();

const props = defineProps({ attractionId: { type: String, required: true } });

const attraction = ref(null);
const audioGuides = ref([]);
const selectedGuideId = ref("");
const newGuideTitle = ref("");
const loading = ref(false);
const savingGuide = ref(false);
const error = ref("");
const toast = ref("");

const selectedGuide = computed(() =>
  audioGuides.value.find((g) => g.id === selectedGuideId.value) || null
);
const guideOwnerId = computed(() => selectedGuide.value?.id || "");

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
      .order("sort_order", { ascending: true });
    audioGuides.value = data || [];
    if (!audioGuides.value.some((g) => g.id === selectedGuideId.value)) {
      selectedGuideId.value = audioGuides.value[0]?.id || "";
    }
  } catch (e) {
    error.value = e.message || String(e);
  } finally {
    loading.value = false;
  }
}
watch(() => props.attractionId, load, { immediate: true });

async function createGuide() {
  const title = newGuideTitle.value.trim() || `Audio Tour ${audioGuides.value.length + 1}`;
  const baseId = slugify(title, "ag");
  let id = baseId;
  let n = 2;
  while (audioGuides.value.some((g) => g.id === id)) {
    id = `${baseId}_${n++}`;
  }
  const payload = {
    id,
    attraction_id: props.attractionId,
    title_en: title,
    audio_url: "",
    duration_seconds: 0,
    is_main_guide: audioGuides.value.length === 0,
    is_active: true,
    sort_order: audioGuides.value.length,
    segments: [],
  };
  savingGuide.value = true;
  try {
    const { error: e } = await supabase.from("audio_guides").upsert(payload);
    if (e) throw e;
    newGuideTitle.value = "";
    await load();
    selectedGuideId.value = id;
    nav.requestReload();
    showToast("已新建线路");
  } catch (e) {
    error.value = e.message || String(e);
  } finally {
    savingGuide.value = false;
  }
}

async function setMainGuide(guideId) {
  if (!guideId) return;
  savingGuide.value = true;
  try {
    const { error: clearErr } = await supabase
      .from("audio_guides")
      .update({ is_main_guide: false })
      .eq("attraction_id", props.attractionId);
    if (clearErr) throw clearErr;
    const { error: setErr } = await supabase
      .from("audio_guides")
      .update({ is_main_guide: true })
      .eq("id", guideId);
    if (setErr) throw setErr;
    await load();
    nav.requestReload();
    showToast("已设为主线路");
  } catch (e) {
    error.value = e.message || String(e);
  } finally {
    savingGuide.value = false;
  }
}

async function onVoiceChanged() {
  showToast("音频已更新");
  nav.requestReload();
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
      <p class="hint">可为该景点维护多条导览线路；每条线路可上传多个音色。请标记一条「主线路」供 App 默认播放。</p>

      <div class="guide-toolbar">
        <label class="pick">
          <span>当前线路</span>
          <select v-model="selectedGuideId" :disabled="!audioGuides.length">
            <option v-if="!audioGuides.length" value="">— 暂无线路 —</option>
            <option v-for="g in audioGuides" :key="g.id" :value="g.id">
              {{ g.title_en || g.id }}{{ g.is_main_guide ? " · 主线路" : "" }}
            </option>
          </select>
        </label>
        <button
          v-if="selectedGuide && !selectedGuide.is_main_guide"
          type="button"
          class="btn btn-secondary btn-sm"
          :disabled="savingGuide"
          @click="setMainGuide(selectedGuide.id)"
        >
          设为主线路
        </button>
        <span v-else-if="selectedGuide?.is_main_guide" class="main-badge">主线路</span>
      </div>

      <div class="new-guide">
        <input v-model="newGuideTitle" type="text" placeholder="新线路标题（英文）" />
        <button type="button" class="btn btn-sm" :disabled="savingGuide" @click="createGuide">
          + 新建线路
        </button>
      </div>

      <VoiceVariantsEditor
        v-if="guideOwnerId"
        owner-type="audio_guide"
        :owner-id="guideOwnerId"
        @changed="onVoiceChanged"
      />
      <p v-else class="muted">暂无线路 — 点击「新建线路」开始。</p>
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
.guide-toolbar {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
  align-items: flex-end;
  margin-bottom: 12px;
}
.pick {
  display: flex;
  flex-direction: column;
  gap: 4px;
  font-size: 12px;
  color: var(--muted);
}
.pick select { min-width: 240px; }
.main-badge {
  font-size: 12px;
  padding: 4px 10px;
  border-radius: 12px;
  background: rgba(46, 158, 91, 0.15);
  color: #2e9e5b;
}
.new-guide {
  display: flex;
  gap: 8px;
  align-items: center;
  margin-bottom: 16px;
}
.new-guide input { flex: 1; max-width: 360px; }
.muted { color: var(--muted); font-size: 13px; }
.toast {
  position: fixed;
  bottom: 26px;
  left: 50%;
  transform: translateX(-50%);
  background: var(--text);
  color: var(--bg);
  padding: 10px 18px;
  border-radius: 8px;
  font-size: 13px;
  opacity: 0;
  pointer-events: none;
  transition: opacity 0.2s;
  z-index: 1100;
}
.toast.on { opacity: 1; }
</style>
