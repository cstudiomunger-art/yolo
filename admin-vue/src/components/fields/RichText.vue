<script setup>
import { ref, onMounted, onBeforeUnmount, watch } from "vue";
import Quill from "quill";
import "quill/dist/quill.snow.css";

const props = defineProps({
  modelValue: { type: String, default: "" },
});
const emit = defineEmits(["update:modelValue"]);

const el = ref(null);
let quill = null;
let internal = false;

onMounted(() => {
  quill = new Quill(el.value, {
    theme: "snow",
    modules: {
      toolbar: [
        [{ header: [2, 3, false] }],
        ["bold", "italic", "underline"],
        [{ list: "ordered" }, { list: "bullet" }],
        ["blockquote", "link"],
        ["clean"],
      ],
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
  <div class="rt"><div ref="el"></div></div>
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
</style>
