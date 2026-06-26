<script setup>
// Markdown editor with inline image upload (满足运营说明书:文章正文「🖼 插入图片」直插光标处)
// 输出纯 Markdown(非 Quill HTML),与 App 的 PaymentMarkdownView 渲染同构。
import { ref, computed } from "vue";
import { uploadStorageFile, COVER_BUCKET } from "@/lib/storage";

const props = defineProps({
  modelValue: { type: String, default: "" },
  entityId: { type: String, default: "" },
  folder: { type: String, default: "payment-articles" },
});
const emit = defineEmits(["update:modelValue"]);

const text = computed({
  get: () => props.modelValue || "",
  set: (v) => emit("update:modelValue", v),
});

const taRef = ref(null);
const uploading = ref(false);
const err = ref("");
const showPreview = ref(false);

function insertAtCursor(snippet) {
  const ta = taRef.value;
  const cur = props.modelValue || "";
  if (!ta) { emit("update:modelValue", cur + snippet); return; }
  const start = ta.selectionStart ?? cur.length;
  const end = ta.selectionEnd ?? cur.length;
  emit("update:modelValue", cur.slice(0, start) + snippet + cur.slice(end));
}

async function onImage(e) {
  const file = e.target.files?.[0];
  e.target.value = "";
  if (!file) return;
  err.value = "";
  if (!props.entityId) { err.value = "请先填写标题/英文名以生成 ID,再插图"; return; }
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

// 轻量 Markdown→HTML 预览(与 App 渲染对齐:标题/列表/引用/加粗/图片/段落)
const previewHtml = computed(() => {
  const esc = (s) => s.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
  const inline = (s) =>
    esc(s)
      .replace(/!\[[^\]]*\]\(([^)]+)\)/g, '<img src="$1" />')
      .replace(/\*\*(.+?)\*\*/g, "<strong>$1</strong>");
  return (props.modelValue || "")
    .split("\n")
    .map((raw) => {
      const line = raw.trim();
      if (!line) return "";
      if (line.startsWith("### ")) return `<h4>${inline(line.slice(4))}</h4>`;
      if (line.startsWith("## ")) return `<h3>${inline(line.slice(3))}</h3>`;
      if (line.startsWith("# ")) return `<h2>${inline(line.slice(2))}</h2>`;
      if (line.startsWith("> ")) return `<blockquote>${inline(line.slice(2))}</blockquote>`;
      if (line.startsWith("- ") || line.startsWith("* ")) return `<li>${inline(line.slice(2))}</li>`;
      if (/^!\[[^\]]*\]\([^)]+\)$/.test(line)) return inline(line);
      return `<p>${inline(line)}</p>`;
    })
    .join("");
});
</script>

<template>
  <div class="md">
    <div class="md-toolbar">
      <label class="md-btn">
        🖼 插入图片
        <input type="file" accept="image/jpeg,image/png,image/webp" @change="onImage" :disabled="uploading" hidden />
      </label>
      <span v-if="uploading" class="muted">上传中…</span>
      <button type="button" class="md-btn" @click="showPreview = !showPreview">
        {{ showPreview ? "✏️ 编辑" : "👁 预览" }}
      </button>
    </div>
    <textarea v-if="!showPreview" ref="taRef" v-model="text" rows="10" class="md-area" spellcheck="false"></textarea>
    <div v-else class="md-render" v-html="previewHtml"></div>
    <p v-if="err" class="err">{{ err }}</p>
  </div>
</template>

<style scoped>
.md-toolbar { display: flex; align-items: center; gap: 10px; margin-bottom: 6px; }
.md-btn { cursor: pointer; font-size: 13px; padding: 4px 10px; border: 1px solid var(--border); border-radius: 8px; background: transparent; color: var(--text); }
.md-area { width: 100%; font-family: ui-monospace, monospace; font-size: 13px; line-height: 1.5; }
.md-render { border: 1px solid var(--border); border-radius: 8px; padding: 12px; font-size: 14px; line-height: 1.6; }
.md-render :deep(img) { max-width: 100%; border-radius: 8px; }
.muted { color: var(--muted); font-size: 13px; }
.err { color: var(--danger, #c0392b); font-size: 13px; }
</style>
