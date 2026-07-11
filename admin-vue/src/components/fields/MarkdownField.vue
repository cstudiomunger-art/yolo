<script setup>
import { ref, computed, watch, onUnmounted } from "vue";
import { uploadStorageFile, COVER_BUCKET } from "@/lib/storage";
import { renderMarkdownHtml, containsHtmlTags, plainTextFromMarkdown } from "@/lib/markdown";
import "../../../../scripts/lib/markdown-prose.css";

const props = defineProps({
  modelValue: { type: String, default: "" },
  entityId: { type: String, default: "" },
  folder: { type: String, default: "misc" },
  label: { type: String, default: "Markdown" },
});
const emit = defineEmits(["update:modelValue"]);

const text = computed({
  get: () => props.modelValue || "",
  set: (v) => emit("update:modelValue", v),
});

const taRef = ref(null);
const overlayRef = ref(null);
const uploading = ref(false);
const err = ref("");
const splitPreview = ref(true);
const fullscreen = ref(false);

const htmlWarning = computed(() =>
  containsHtmlTags(props.modelValue) ? "检测到 HTML 标签，请改为 Markdown 语法（##、**、-、![](url)）" : ""
);

const previewHtml = computed(() => renderMarkdownHtml(props.modelValue));

const previewSnippet = computed(() => {
  const plain = plainTextFromMarkdown(props.modelValue).trim();
  if (!plain) return "";
  const limit = 120;
  if (plain.length <= limit) return plain;
  let end = plain.slice(0, limit).lastIndexOf(" ");
  if (end < 40) end = limit;
  return plain.slice(0, end).trim() + "…";
});

const charCount = computed(() => (props.modelValue || "").length);

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

function openFullscreen() {
  fullscreen.value = true;
  splitPreview.value = true;
  requestAnimationFrame(() => {
    overlayRef.value?.focus();
    taRef.value?.focus();
  });
}

function closeFullscreen() {
  fullscreen.value = false;
}

function onOverlayKeydown(e) {
  if (e.key === "Escape") {
    e.preventDefault();
    closeFullscreen();
  }
}

watch(fullscreen, (open) => {
  document.body.style.overflow = open ? "hidden" : "";
});

onUnmounted(() => {
  document.body.style.overflow = "";
});
</script>

<template>
  <div class="md">
    <button type="button" class="md-card" @click="openFullscreen">
      <p v-if="previewSnippet" class="md-card-preview">{{ previewSnippet }}</p>
      <p v-else class="md-card-empty">点击编辑 Markdown</p>
      <div class="md-card-footer">
        <span v-if="charCount" class="muted">{{ charCount }} 字</span>
        <span class="md-card-action">全屏编辑</span>
      </div>
    </button>
    <p v-if="htmlWarning" class="warn">{{ htmlWarning }}</p>

    <Teleport to="body">
      <div
        v-if="fullscreen"
        ref="overlayRef"
        class="md-fs-overlay"
        tabindex="-1"
        @keydown="onOverlayKeydown"
      >
        <header class="md-fs-header">
          <h2 class="md-fs-title">{{ label }}</h2>
          <div class="md-fs-actions">
            <button type="button" class="md-btn md-btn-primary" @click="closeFullscreen">完成</button>
            <button type="button" class="md-btn md-btn-icon" aria-label="关闭" @click="closeFullscreen">×</button>
          </div>
        </header>

        <div class="md-fs-main">
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

          <div class="md-body md-body-fs" :class="{ split: splitPreview }">
            <textarea ref="taRef" v-model="text" class="md-area md-area-fs" spellcheck="false" />
            <div v-if="splitPreview" class="md-render md-render-fs prose-preview" v-html="previewHtml" />
          </div>

          <p v-if="err" class="err">{{ err }}</p>
        </div>
      </div>
    </Teleport>
  </div>
</template>

<style scoped>
.md-card {
  display: block;
  width: 100%;
  text-align: left;
  padding: 12px 14px;
  border: 1px solid var(--border);
  border-radius: 8px;
  background: var(--surface-warm, var(--surface));
  cursor: pointer;
  transition: border-color 0.15s;
}
.md-card:hover { border-color: var(--accent); }
.md-card-preview {
  margin: 0;
  font-size: 13px;
  line-height: 1.55;
  color: var(--text);
  white-space: pre-wrap;
  word-break: break-word;
}
.md-card-empty {
  margin: 0;
  font-size: 13px;
  color: var(--muted);
}
.md-card-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 8px;
  font-size: 12px;
}
.md-card-action { color: var(--accent); font-weight: 500; }

.md-fs-overlay {
  position: fixed;
  inset: 0;
  z-index: 1100;
  display: flex;
  flex-direction: column;
  background: var(--surface);
  outline: none;
}
.md-fs-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  padding: 12px 20px;
  border-bottom: 1px solid var(--border);
  flex-shrink: 0;
}
.md-fs-title {
  margin: 0;
  font-size: 16px;
  font-weight: 600;
  color: var(--text);
}
.md-fs-actions { display: flex; align-items: center; gap: 8px; }
.md-fs-main {
  flex: 1;
  min-height: 0;
  display: flex;
  flex-direction: column;
  padding: 12px 20px 20px;
  overflow: hidden;
}

.md-toolbar { display: flex; flex-wrap: wrap; align-items: center; gap: 8px; margin-bottom: 8px; flex-shrink: 0; }
.md-btn {
  cursor: pointer;
  font-size: 13px;
  padding: 4px 10px;
  border: 1px solid var(--border);
  border-radius: 8px;
  background: transparent;
  color: var(--text);
}
.md-btn-primary {
  background: var(--accent);
  border-color: var(--accent);
  color: #fff;
  padding: 6px 16px;
  font-weight: 500;
}
.md-btn-icon {
  font-size: 22px;
  line-height: 1;
  padding: 2px 10px;
}

.md-body { display: block; }
.md-body-fs {
  flex: 1;
  min-height: 0;
  overflow: hidden;
}
.md-body.split { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
@media (max-width: 900px) { .md-body.split { grid-template-columns: 1fr; } }

.md-area {
  width: 100%;
  font-family: ui-monospace, monospace;
  font-size: 13px;
  line-height: 1.5;
  border: 1px solid var(--border);
  border-radius: 8px;
  padding: 12px;
  resize: none;
  color: var(--text);
  background: var(--surface);
}
.md-area-fs {
  min-height: 0;
  height: 100%;
}
.md-body:not(.split) .md-area-fs { min-height: 100%; }

.md-render {
  border: 1px solid var(--border);
  border-radius: 8px;
  padding: 12px;
  font-size: 14px;
  line-height: 1.6;
  overflow: auto;
  color: var(--text);
}
.md-render-fs { min-height: 0; height: 100%; }

.muted { color: var(--muted); font-size: 13px; }
.warn { color: #b8860b; font-size: 13px; margin: 0 0 6px; flex-shrink: 0; }
.err { color: var(--danger, #c0392b); font-size: 13px; flex-shrink: 0; }
</style>
