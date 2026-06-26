<script setup>
import { ref, onMounted, onBeforeUnmount, watch } from "vue";
import Quill from "quill";
import "quill/dist/quill.snow.css";
import { uploadStorageFile, COVER_BUCKET } from "@/lib/storage";

const props = defineProps({
  modelValue: { type: String, default: "" },
  // 图片直传时用于生成稳定路径(取记录 id);缺省也能传,只是路径前缀为 img。
  entityId: { type: String, default: "" },
});
const emit = defineEmits(["update:modelValue"]);

const el = ref(null);
const uploadErr = ref("");
const uploading = ref(false);
let quill = null;
let internal = false;

// 选文件 → 直传 cover-images → 在光标处插入 <img src=公网URL>
function imageHandler() {
  const input = document.createElement("input");
  input.type = "file";
  input.accept = "image/jpeg,image/png,image/webp";
  input.onchange = async () => {
    const file = input.files?.[0];
    if (!file) return;
    uploadErr.value = "";
    uploading.value = true;
    const range = quill.getSelection(true);
    const index = range ? range.index : quill.getLength();
    try {
      const ext = (file.name.split(".").pop() || "jpg").toLowerCase();
      const id = props.entityId || "img";
      const path = `richtext/${id}-${Date.now()}.${ext}`;
      const url = await uploadStorageFile(COVER_BUCKET, path, file, file.type || "image/jpeg");
      quill.insertEmbed(index, "image", url, "user");
      quill.setSelection(index + 1, 0, "silent");
    } catch (e) {
      uploadErr.value = e.message || String(e);
    } finally {
      uploading.value = false;
    }
  };
  input.click();
}

onMounted(() => {
  quill = new Quill(el.value, {
    theme: "snow",
    modules: {
      toolbar: {
        container: [
          [{ header: [2, 3, false] }],
          ["bold", "italic", "underline"],
          [{ list: "ordered" }, { list: "bullet" }],
          ["blockquote", "link", "image"],
          ["clean"],
        ],
        handlers: { image: imageHandler },
      },
    },
  });
  if (props.modelValue) quill.clipboard.dangerouslyPasteHTML(props.modelValue);
  quill.on("text-change", () => {
    internal = true;
    const html = quill.root.innerHTML;
    emit("update:modelValue", html === "<p><br></p>" ? "" : html);
    internal = false;
  });
});

watch(
  () => props.modelValue,
  (v) => {
    if (internal || !quill) return;
    if (v !== quill.root.innerHTML) {
      quill.clipboard.dangerouslyPasteHTML(v || "");
    }
  }
);

onBeforeUnmount(() => {
  quill = null;
});
</script>

<template>
  <div class="rt">
    <div ref="el"></div>
    <p v-if="uploading" class="rt-note">图片上传中…</p>
    <p v-if="uploadErr" class="rt-err">{{ uploadErr }}</p>
  </div>
</template>

<style scoped>
.rt :deep(.ql-toolbar) {
  border-color: var(--border);
  border-radius: var(--radius) var(--radius) 0 0;
}
.rt :deep(.ql-container) {
  border-color: var(--border);
  border-radius: 0 0 var(--radius) var(--radius);
  min-height: 180px;
  font-size: 14px;
}
.rt :deep(.ql-editor) {
  color: var(--text);
}
.rt :deep(.ql-editor img) {
  max-width: 100%;
  height: auto;
  border-radius: 8px;
}
.rt-note { font-size: 13px; color: var(--muted); margin: 6px 0 0; }
.rt-err { font-size: 13px; color: var(--danger, #c0392b); margin: 6px 0 0; }
</style>
