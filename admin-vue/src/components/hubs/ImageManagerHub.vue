<script setup>
import { ref, computed, onMounted, watch } from "vue";
import { useNav } from "@/stores/nav";
import { buildImageIndex } from "@/lib/imageRegistry";
import { deleteStorageFile, getStoragePreviewUrl, IMAGE_BUCKETS } from "@/lib/storage";

const nav = useNav();

const loading = ref(false);
const progress = ref("");
const error = ref("");
const toast = ref("");
const entries = ref([]);
const stats = ref({ total: 0, used: 0, unused: 0, orphan: 0 });

const filterBucket = ref("all");
const filterFolder = ref("all");
const filterStatus = ref("all");
const search = ref("");
const selected = ref(new Set());
const expanded = ref(new Set());
const previewUrls = ref({});

function showToast(m) {
  toast.value = m;
  setTimeout(() => (toast.value = ""), 2000);
}

async function load() {
  loading.value = true;
  error.value = "";
  selected.value = new Set();
  previewUrls.value = {};
  try {
    const result = await buildImageIndex({
      onProgress: (m) => { progress.value = m; },
    });
    entries.value = result.entries;
    stats.value = result.stats;
    await loadPreviews(result.entries);
  } catch (e) {
    error.value = e.message || String(e);
  } finally {
    loading.value = false;
    progress.value = "";
  }
}

async function loadPreviews(list) {
  const urls = {};
  const chat = list.filter((e) => e.bucket === "chat-images" && e.inStorage);
  await Promise.all(
    chat.slice(0, 80).map(async (e) => {
      try {
        urls[e.id] = await getStoragePreviewUrl(e.bucket, e.path);
      } catch {
        /* skip */
      }
    })
  );
  previewUrls.value = urls;
}

function previewSrc(entry) {
  if (entry.bucket === "chat-images") return previewUrls.value[entry.id] || "";
  return entry.publicUrl;
}

const folders = computed(() => {
  const set = new Set();
  for (const e of entries.value) {
    if (filterBucket.value !== "all" && e.bucket !== filterBucket.value) continue;
    set.add(e.folder);
  }
  return [...set].sort();
});

const filtered = computed(() => {
  const q = search.value.trim().toLowerCase();
  return entries.value.filter((e) => {
    if (filterBucket.value !== "all" && e.bucket !== filterBucket.value) return false;
    if (filterFolder.value !== "all" && e.folder !== filterFolder.value) return false;
    if (filterStatus.value !== "all" && e.status !== filterStatus.value) return false;
    if (q && !e.path.toLowerCase().includes(q) && !e.bucket.toLowerCase().includes(q)) return false;
    return true;
  });
});

const selectableFiltered = computed(() => filtered.value.filter((e) => e.inStorage));

const selectedEntries = computed(() =>
  entries.value.filter((e) => selected.value.has(e.id) && e.inStorage)
);

const allSelected = computed(() =>
  selectableFiltered.value.length > 0 &&
  selectableFiltered.value.every((e) => selected.value.has(e.id))
);

const someSelected = computed(() => selected.value.size > 0);

const hasUnusedSelectable = computed(() =>
  selectableFiltered.value.some((e) => e.status === "unused")
);

function statusLabel(s) {
  return { used: "已使用", unused: "未使用", orphan: "孤立引用" }[s] || s;
}

function toggleSelect(id) {
  const next = new Set(selected.value);
  if (next.has(id)) next.delete(id);
  else next.add(id);
  selected.value = next;
}

function selectAllFiltered() {
  selected.value = new Set(selectableFiltered.value.map((e) => e.id));
}

function invertSelection() {
  const next = new Set(selected.value);
  for (const e of selectableFiltered.value) {
    if (next.has(e.id)) next.delete(e.id);
    else next.add(e.id);
  }
  selected.value = next;
}

function selectUnusedOnly() {
  selected.value = new Set(
    selectableFiltered.value.filter((e) => e.status === "unused").map((e) => e.id)
  );
}

function clearSelection() {
  selected.value = new Set();
}

function pruneSelection() {
  const visible = new Set(filtered.value.map((e) => e.id));
  const next = new Set([...selected.value].filter((id) => visible.has(id)));
  if (next.size !== selected.value.size) selected.value = next;
}

async function resolveUrl(entry) {
  const url = previewSrc(entry) || entry.publicUrl;
  if (url) return url;
  return getStoragePreviewUrl(entry.bucket, entry.path);
}

function toggleExpand(id) {
  const next = new Set(expanded.value);
  if (next.has(id)) next.delete(id);
  else next.add(id);
  expanded.value = next;
}

function goEdit(ref) {
  if (ref.tableKey === "attractions") {
    nav.select({ kind: "record", tableKey: "attractions", id: ref.recordId });
    return;
  }
  nav.select({ kind: "record", tableKey: ref.tableKey, id: ref.recordId });
}

function pickEdit(entry) {
  if (!entry.refs?.length) return;
  if (entry.refs.length === 1) {
    goEdit(entry.refs[0]);
    return;
  }
  const label = entry.refs.map((r, i) => `${i + 1}. ${r.recordLabel} · ${r.fieldLabel}`).join("\n");
  const pick = prompt(`选择要编辑的引用（输入序号 1-${entry.refs.length}）：\n${label}`);
  const idx = Number(pick) - 1;
  if (entry.refs[idx]) goEdit(entry.refs[idx]);
}

async function copyUrl(entry) {
  try {
    const url = await resolveUrl(entry);
    await navigator.clipboard.writeText(url);
    showToast("已复制 URL");
  } catch {
    showToast("无法复制 URL");
  }
}

async function copySelectedUrls() {
  const list = selectedEntries.value;
  if (!list.length) return;
  try {
    const urls = await Promise.all(list.map((e) => resolveUrl(e)));
    await navigator.clipboard.writeText(urls.join("\n"));
    showToast(`已复制 ${urls.length} 条 URL`);
  } catch {
    showToast("无法复制 URL");
  }
}

async function deleteEntry(entry, force = false) {
  if (!entry.inStorage) {
    showToast("Storage 中无此文件");
    return;
  }
  if (entry.status === "used" && !force) {
    const refs = entry.refs.map((r) => `· ${r.tableKey} / ${r.recordLabel} / ${r.fieldLabel}`).join("\n");
    if (!confirm(`该图片仍被引用：\n${refs}\n\n确定仍要删除 Storage 文件？（不会自动改数据库字段）`)) return;
  } else if (!confirm(`删除 ${entry.bucket}/${entry.path}？`)) return;

  try {
    await deleteStorageFile(entry.bucket, entry.path);
    showToast("已删除");
    await load();
  } catch (e) {
    error.value = e.message || String(e);
  }
}

async function deleteSelected() {
  const toDelete = selectedEntries.value;
  if (!toDelete.length) return;

  const usedCount = toDelete.filter((e) => e.status === "used").length;
  const orphanCount = toDelete.filter((e) => e.status === "orphan").length;
  let msg = `删除 ${toDelete.length} 个 Storage 文件？`;
  if (usedCount) msg += `\n其中 ${usedCount} 张仍被数据库引用（不会自动改字段）。`;
  if (orphanCount) msg += `\n其中 ${orphanCount} 张为孤立引用。`;
  if (!confirm(msg)) return;

  try {
    for (const bucket of IMAGE_BUCKETS) {
      const paths = toDelete.filter((e) => e.bucket === bucket).map((e) => e.path);
      if (paths.length) await deleteStorageFile(bucket, paths);
    }
    showToast(`已删除 ${toDelete.length} 个文件`);
    await load();
  } catch (e) {
    error.value = e.message || String(e);
  }
}

watch(filterBucket, () => { filterFolder.value = "all"; });

watch([filterBucket, filterFolder, filterStatus, search, filtered], pruneSelection);

watch(() => nav.reloadTick, () => {
  if (!loading.value) load();
});

onMounted(load);
</script>

<template>
  <div class="im">
    <header class="im-head">
      <div>
        <h2>图片管理</h2>
        <p class="muted">
          共 {{ stats.total }} 张 · 已使用 {{ stats.used }} · 未使用 {{ stats.unused }}
          <span v-if="stats.orphan"> · 孤立引用 {{ stats.orphan }}</span>
        </p>
      </div>
      <div class="im-head-actions">
        <button type="button" class="btn btn-secondary btn-sm" :disabled="loading" @click="load">
          {{ loading ? "索引中…" : "刷新索引" }}
        </button>
        <button
          type="button"
          class="btn btn-secondary btn-sm"
          :disabled="!someSelected || loading"
          @click="copySelectedUrls"
        >
          复制选中 URL ({{ selected.size }})
        </button>
        <button
          type="button"
          class="btn btn-danger btn-sm"
          :disabled="!someSelected || loading"
          @click="deleteSelected"
        >
          删除选中 ({{ selected.size }})
        </button>
      </div>
    </header>

    <p v-if="progress" class="progress">{{ progress }}</p>
    <p v-if="error" class="err">{{ error }}</p>
    <p v-if="toast" class="toast">{{ toast }}</p>

    <div class="filters">
      <label>
        桶
        <select v-model="filterBucket">
          <option value="all">全部</option>
          <option v-for="b in IMAGE_BUCKETS" :key="b" :value="b">{{ b }}</option>
        </select>
      </label>
      <label>
        类型
        <select v-model="filterFolder">
          <option value="all">全部</option>
          <option v-for="f in folders" :key="f" :value="f">{{ f }}</option>
        </select>
      </label>
      <label>
        状态
        <select v-model="filterStatus">
          <option value="all">全部</option>
          <option value="used">已使用</option>
          <option value="unused">未使用</option>
          <option value="orphan">孤立引用</option>
        </select>
      </label>
      <label class="search">
        搜索
        <input v-model="search" type="search" placeholder="路径关键字" />
      </label>
    </div>

    <div v-if="!loading && entries.length" class="batch-bar">
      <span class="batch-count">已选 {{ selected.size }} / 当前 {{ selectableFiltered.length }} 张可选</span>
      <div class="batch-actions">
        <button
          type="button"
          class="btn btn-secondary btn-sm"
          :disabled="!selectableFiltered.length"
          @click="allSelected ? clearSelection() : selectAllFiltered()"
        >
          {{ allSelected ? "取消全选" : "全选当前结果" }}
        </button>
        <button
          type="button"
          class="btn btn-secondary btn-sm"
          :disabled="!selectableFiltered.length"
          @click="invertSelection"
        >
          反选
        </button>
        <button
          type="button"
          class="btn btn-secondary btn-sm"
          :disabled="!hasUnusedSelectable"
          @click="selectUnusedOnly"
        >
          仅选未使用
        </button>
        <button
          type="button"
          class="btn btn-secondary btn-sm"
          :disabled="!someSelected"
          @click="clearSelection"
        >
          清空选择
        </button>
      </div>
    </div>

    <div v-if="loading && !entries.length" class="muted pad">正在构建图片索引…</div>

    <div v-else class="grid">
      <article
        v-for="entry in filtered"
        :key="entry.id"
        class="card"
        :class="[entry.status, { selected: selected.has(entry.id) }]"
      >
        <div class="card-top">
          <label v-if="entry.inStorage" class="chk" @click.stop>
            <input
              type="checkbox"
              :checked="selected.has(entry.id)"
              @change="toggleSelect(entry.id)"
            />
          </label>
          <span v-else class="chk-spacer" />
          <span class="badge" :class="entry.status">{{ statusLabel(entry.status) }}</span>
        </div>
        <div
          class="thumb"
          :class="{ selectable: entry.inStorage }"
          @click="entry.inStorage && toggleSelect(entry.id)"
        >
          <img v-if="previewSrc(entry)" :src="previewSrc(entry)" :alt="entry.path" loading="lazy" />
          <span v-else class="no-thumb">无预览</span>
        </div>
        <p class="path" :title="entry.path">{{ entry.path }}</p>
        <p class="meta muted">{{ entry.bucket }} · {{ entry.folder }} · 引用 {{ entry.refs.length }}</p>

        <div v-if="entry.refs.length" class="refs">
          <button type="button" class="link-btn" @click="toggleExpand(entry.id)">
            {{ expanded.has(entry.id) ? "收起引用" : "查看引用" }}
          </button>
          <ul v-if="expanded.has(entry.id)">
            <li v-for="(r, i) in entry.refs" :key="i">
              {{ r.tableKey }} / {{ r.recordLabel }} / {{ r.fieldLabel }}
            </li>
          </ul>
        </div>

        <div class="actions">
          <button
            v-if="entry.refs.length"
            type="button"
            class="btn btn-secondary btn-sm"
            @click="pickEdit(entry)"
          >编辑</button>
          <button type="button" class="btn btn-secondary btn-sm" @click="copyUrl(entry)">复制 URL</button>
          <button
            v-if="entry.inStorage"
            type="button"
            class="btn btn-danger btn-sm"
            @click="deleteEntry(entry)"
          >删除</button>
        </div>
      </article>
    </div>

    <p v-if="!loading && !filtered.length" class="muted pad">无匹配图片</p>
  </div>
</template>

<style scoped>
.im { max-width: 1200px; }
.im-head { display: flex; justify-content: space-between; align-items: flex-start; gap: 16px; margin-bottom: 16px; }
.im-head h2 { margin: 0 0 4px; font-size: 20px; }
.im-head-actions { display: flex; gap: 8px; flex-shrink: 0; }
.muted { color: var(--muted); font-size: 13px; }
.progress { font-size: 13px; color: var(--muted); margin: 0 0 8px; }
.err { color: var(--accent); font-size: 13px; margin: 0 0 8px; }
.toast { color: #2d7a3a; font-size: 13px; margin: 0 0 8px; }
.filters {
  display: flex; flex-wrap: wrap; gap: 12px; margin-bottom: 16px; align-items: flex-end;
}
.filters label { display: flex; flex-direction: column; gap: 4px; font-size: 12px; color: var(--muted); }
.filters select, .filters input {
  font-size: 13px; padding: 6px 10px; border: 1px solid var(--border); border-radius: 8px;
  background: var(--surface); color: var(--text); min-width: 120px;
}
.filters .search input { min-width: 200px; }
.batch-bar {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  justify-content: space-between;
  gap: 10px;
  margin-bottom: 14px;
  padding: 10px 12px;
  border: 1px solid var(--border);
  border-radius: 10px;
  background: var(--surface);
}
.batch-count { font-size: 13px; color: var(--muted); }
.batch-actions { display: flex; flex-wrap: wrap; gap: 8px; }
.pad { padding: 24px 0; }
.grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
  gap: 14px;
}
.card {
  border: 1px solid var(--border);
  border-radius: 10px;
  padding: 10px;
  background: var(--surface);
  display: flex;
  flex-direction: column;
  gap: 8px;
}
.card.orphan { border-color: #c0392b; }
.card.selected {
  border-color: var(--accent);
  box-shadow: 0 0 0 1px var(--accent);
}
.card-top { display: flex; justify-content: space-between; align-items: center; min-height: 22px; gap: 8px; }
.chk { display: flex; align-items: center; cursor: pointer; flex-shrink: 0; }
.chk input { width: 16px; height: 16px; cursor: pointer; }
.chk-spacer { width: 16px; flex-shrink: 0; }
.badge {
  font-size: 11px; padding: 2px 8px; border-radius: 10px; font-weight: 500;
}
.badge.used { background: rgba(45, 122, 58, 0.15); color: #2d7a3a; }
.badge.unused { background: rgba(128, 128, 128, 0.15); color: var(--muted); }
.badge.orphan { background: rgba(192, 57, 43, 0.12); color: #c0392b; }
.thumb {
  aspect-ratio: 4/3;
  border-radius: 8px;
  overflow: hidden;
  background: var(--surface-warm, #f6f4f0);
  display: flex;
  align-items: center;
  justify-content: center;
}
.thumb.selectable { cursor: pointer; }
.thumb.selectable:hover { opacity: 0.92; }
.thumb img { width: 100%; height: 100%; object-fit: cover; }
.no-thumb { font-size: 12px; color: var(--muted); }
.path {
  margin: 0;
  font-size: 11px;
  line-height: 1.35;
  word-break: break-all;
  font-family: ui-monospace, monospace;
}
.meta { margin: 0; font-size: 11px; }
.refs ul { margin: 6px 0 0; padding-left: 16px; font-size: 11px; color: var(--muted); }
.link-btn {
  background: none; border: none; padding: 0; color: var(--accent);
  font-size: 12px; cursor: pointer; text-decoration: underline;
}
.actions { display: flex; flex-wrap: wrap; gap: 6px; margin-top: auto; }
</style>
