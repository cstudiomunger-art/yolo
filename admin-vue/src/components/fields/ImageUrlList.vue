<script setup>
import { computed, ref } from "vue";
import { uploadGalleryImage } from "@/lib/storage";

/** Array-of-strings (image URLs) with local gallery upload. */
const props = defineProps({
  modelValue: { type: Array, default: () => [] },
  folder: { type: String, default: "misc" },
  entityId: { type: String, default: "" },
});
const emit = defineEmits(["update:modelValue"]);

const urls = computed(() => (Array.isArray(props.modelValue) ? props.modelValue : []));
const uploading = ref(false);
const err = ref("");

function setUrl(i, v) {
  const next = urls.value.slice();
  next[i] = v;
  emit("update:modelValue", next);
}
function remove(i) {
  emit("update:modelValue", urls.value.filter((_, idx) => idx !== i));
}
function addBlank() {
  emit("update:modelValue", [...urls.value, ""]);
}
async function onFiles(e) {
  const files = Array.from(e.target.files || []);
  if (!files.length) return;
  err.value = "";
  if (!props.entityId) {
    err.value = "请先填写名称/英文名以生成 ID，再上传图片";
    e.target.value = "";
    return;
  }
  uploading.value = true;
  try {
    const added = [];
    for (let i = 0; i < files.length; i++) {
      const url = await uploadGalleryImage(files[i], props.folder, props.entityId, `img_${Date.now()}_${i}`);
      added.push(url);
    }
    emit("update:modelValue", [...urls.value, ...added]);
  } catch (e2) {
    err.value = e2.message || String(e2);
  } finally {
    uploading.value = false;
    e.target.value = "";
  }
}
</script>

<template>
  <div class="iul">
    <div v-for="(u, i) in urls" :key="i" class="row">
      <div class="thumb"><img v-if="u" :src="u" alt="" /><span v-else>预览</span></div>
      <input type="text" :value="u" placeholder="图片 URL" @input="setUrl(i, $event.target.value)" />
      <button type="button" class="btn btn-secondary btn-sm" @click="remove(i)">删</button>
    </div>
    <div class="toolbar">
      <label class="btn btn-secondary btn-sm">
        + 本地上传
        <input type="file" accept="image/jpeg,image/png,image/webp" multiple hidden @change="onFiles" :disabled="uploading" />
      </label>
      <button type="button" class="btn btn-secondary btn-sm" @click="addBlank">+ 粘贴 URL</button>
      <span v-if="uploading" class="muted">上传中…</span>
    </div>
    <p v-if="err" class="err">{{ err }}</p>
  </div>
</template>

<style scoped>
.iul {
  border: 1px solid var(--border);
  border-radius: var(--radius);
  padding: 10px;
}
.row {
  display: flex;
  gap: 8px;
  align-items: center;
  margin-bottom: 8px;
}
.thumb {
  width: 56px;
  height: 42px;
  flex-shrink: 0;
  border: 1px solid var(--border);
  border-radius: 6px;
  overflow: hidden;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 11px;
  color: var(--muted);
}
.thumb img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}
.toolbar {
  display: flex;
  gap: 8px;
  align-items: center;
}
.muted {
  color: var(--muted);
  font-size: 13px;
}
.err {
  color: var(--accent);
  font-size: 12px;
  margin: 6px 0 0;
}
</style>
