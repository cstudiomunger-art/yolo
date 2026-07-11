<script setup>
import { ref, computed } from "vue";
import { uploadStorageFile, COVER_BUCKET } from "@/lib/storage";
import { renderMarkdownHtml, containsHtmlTags } from "@/lib/markdown";
import "../../../../scripts/lib/markdown-prose.css";

const props = defineProps({
  modelValue: { type: String, default: "" },
  entityId: { type: String, default: "" },
  folder: { type: String, default: "misc" },
});
const emit = defineEmits(["update:modelValue"]);

const text = computed({
  get: () => props.modelValue || "",
  set: (v) => emit("update:modelValue", v),
});

const taRef = ref(null);
const uploading = ref(false);
const err = ref("");
const splitPreview = ref(true);

const htmlWarning = computed(() =>
  containsHtmlTags(props.modelValue) ? "检测到 HTML 标签，请改为 Markdown 语法（##、**、-、![](url)）" : ""
);

function insertAtCursor(snippet) {
  const ta = taRef.value;
  const cur = props.modelValue || "";
  if (!ta) {
    emit("update:modelValue", cur + snippet);
    return;
  }
  const start = ta.selectionStart ?? cur.length;
  const end = ta.selectionEnd ?? cur.length;
  emit("update:modelValue", cur.slice(0, start) + snippet + cur.slice(end));
  requestAnimationFrame(() => {
    const pos = start + snippet.length;
    ta.focus();
    ta.setSelectionRange(pos, pos);
  });
}

function wrapSelection(before, after = before) {
  const ta = taRef.value;
  const cur = props.modelValue || "";
  if (!ta) return;
  const start = ta.selectionStart ?? 0;
  const end = ta.selectionEnd ?? 0;
  const selected = cur.slice(start, end) || "text";
  emit("update:modelValue", cur.slice(0, start) + before + selected + after + cur.slice(end));
}

function insertTable() {
  insertAtCursor("\n| 列1 | 列2 |\n| --- | --- |\n| 内容 | 内容 |\n");
}

async function onImage(e) {
  const file = e.target.files?.[0];
  e.target.value = "";
  if (!file) return;
  err.value = "";
  if (!props.entityId) {
    err.value = "请先填写名称/英文名以生成 ID，再插图";
    return;
  }
  uploading.value = true;
  try {
    const ext = (file.name.split(".").pop() || "jpg").toLowerCase();
    const path = `${props.folder}/${props.entityId}-${Date.now()}.${ext}`;
    const url = await uploadStorageFile(COVER_BUCKET, path, file, file.type || "image/jpeg");
    insertAtCursor(`\n\n![](${url})\n\n`);
  } catch (e2) {
    err.value = e2.message || String(e2);
  } finally {
    uploading.value = false;
  }
}

const previewHtml = computed(() => renderMarkdownHtml(props.modelValue));
</script>

<template>
  <div class="md">
    <div class="md-toolbar">
      <button type="button" class="md-btn" @click="insertAtCursor('\n## ')">##</button>
      <button type="button" class="md-btn" @click="insertAtCursor('\n### ')">###</button>
      <button type="button" class="md-btn" @click="wrapSelection('**')">**B**</button>
      <button type="button" class="md-btn" @click="wrapSelection('*')">*I*</button>
      <button type="button" class="md-btn" @click="insertAtCursor('\n- ')">- 列表</button>
      <button type="button" class="md-btn" @click="insertAtCursor('\n1. ')">1. 列表</button>
      <button type="button" class="md-btn" @click="insertAtCursor('\n> ')">引用</button>
      <button type="button" class="md-btn" @click="wrapSelection('`')">`code`</button>
      <button type="button" class="md-btn" @click="insertAtCursor('\n```\n\n```\n')">```</button>
      <button type="button" class="md-btn" @click="wrapSelection('~~')">~~</button>
      <button type="button" class="md-btn" @click="insertAtCursor('\n\n---\n\n')">---</button>
      <button type="button" class="md-btn" @click="insertAtCursor('[链接文字](https://)')">链接</button>
      <button type="button" class="md-btn" @click="insertTable">表格</button>
      <label class="md-btn">
        🖼 图片
        <input type="file" accept="image/jpeg,image/png,image/webp" @change="onImage" :disabled="uploading" hidden />
      </label>
      <span v-if="uploading" class="muted">上传中…</span>
      <button type="button" class="md-btn" @click="splitPreview = !splitPreview">
        {{ splitPreview ? "单栏编辑" : "分屏预览" }}
      </button>
    </div>
    <p v-if="htmlWarning" class="warn">{{ htmlWarning }}</p>
    <div class="md-body" :class="{ split: splitPreview }">
      <textarea ref="taRef" v-model="text" rows="12" class="md-area" spellcheck="false" />
      <div v-if="splitPreview" class="md-render prose-preview" v-html="previewHtml" />
    </div>
    <p v-if="err" class="err">{{ err }}</p>
  </div>
</template>

<style scoped>
.md-toolbar { display: flex; flex-wrap: wrap; align-items: center; gap: 8px; margin-bottom: 6px; }
.md-btn { cursor: pointer; font-size: 13px; padding: 4px 10px; border: 1px solid var(--border); border-radius: 8px; background: transparent; color: var(--text); }
.md-body { display: block; }
.md-body.split { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
@media (max-width: 900px) { .md-body.split { grid-template-columns: 1fr; } }
.md-area { width: 100%; font-family: ui-monospace, monospace; font-size: 13px; line-height: 1.5; min-height: 200px; }
.md-render { border: 1px solid var(--border); border-radius: 8px; padding: 12px; font-size: 14px; line-height: 1.6; min-height: 200px; overflow: auto; color: var(--text); }
.muted { color: var(--muted); font-size: 13px; }
.warn { color: #b8860b; font-size: 13px; margin: 0 0 6px; }
.err { color: var(--danger, #c0392b); font-size: 13px; }
</style>
