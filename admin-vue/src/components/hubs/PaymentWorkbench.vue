<script setup>
import { ref, computed, watch, onMounted } from "vue";
import { supabase } from "@/lib/supabase";
import { TABLES } from "@/schema/tables";
import RecordForm from "@/components/RecordForm.vue";

const mainTab = ref("content");
const position = ref("questions");

const POSITIONS = [
  { id: "questions", label: "入口与三问", nodes: [], tables: ["payment_countries", "payment_card_networks", "payment_cash_rules"] },
  { id: "plan", label: "方案页", nodes: ["plan"], tables: ["payment_checklist_items", "payment_helper_links"] },
  { id: "install", label: "安装", nodes: ["install"] },
  { id: "register", label: "注册", nodes: ["register"] },
  { id: "bind", label: "绑卡", nodes: ["bind"] },
  { id: "verify", label: "验证", nodes: ["verify"] },
  { id: "use", label: "如何付款", nodes: ["use"] },
  { id: "china", label: "已落地", nodes: ["china"] },
  { id: "rescue", label: "救援", nodes: ["rescue"] },
  { id: "merchant", label: "商家话术", nodes: ["merchant"] },
];

const TABLE_ORDER = {
  payment_node_texts: "ord",
  payment_flow_steps: "step_order",
  payment_articles: "display_order",
  payment_rescue_rungs: "rung_order",
  payment_merchant_phrases: "sort_order",
  payment_checklist_items: "item_order",
  payment_helper_links: "sort_order",
  payment_countries: "opt_order",
  payment_cash_rules: "opt_order",
  payment_card_networks: "sort_order",
};

const SMS_TONE_LABEL = { ok: "正常", info: "延迟", warn: "收不到" };

const rowsByTable = ref({});
const loading = ref(false);
const error = ref("");
const toast = ref("");
const editing = ref(null);

function showToast(m) { toast.value = m; setTimeout(() => (toast.value = ""), 1600); }

const currentPos = computed(() => POSITIONS.find((p) => p.id === position.value) || POSITIONS[0]);

async function loadTable(tableKey, nodeKey = null) {
  let q = supabase.from(tableKey).select("*");
  if (nodeKey && ["payment_node_texts", "payment_flow_steps", "payment_articles"].includes(tableKey)) {
    q = q.eq("node_key", nodeKey);
  }
  const orderCol = TABLE_ORDER[tableKey] || "id";
  q = q.order(orderCol);
  const { data, error: e } = await q;
  if (e) throw e;
  return data || [];
}

async function loadAll() {
  loading.value = true;
  error.value = "";
  try {
    const pos = currentPos.value;
    const tables = new Set(pos.tables || []);
    if (pos.id === "rescue") tables.add("payment_rescue_rungs");
    if (pos.id === "merchant") tables.add("payment_merchant_phrases");
    const next = { ...rowsByTable.value };
    for (const tbl of tables) {
      next[tbl] = await loadTable(tbl);
    }
    for (const node of pos.nodes || []) {
      next[`payment_node_texts:${node}`] = await loadTable("payment_node_texts", node);
      if (!["rescue", "merchant"].includes(node)) {
        next[`payment_flow_steps:${node}`] = await loadTable("payment_flow_steps", node);
      }
      if (["plan", "bind", "use", "home"].includes(node)) {
        next[`payment_articles:${node}`] = await loadTable("payment_articles", node);
      }
    }
    rowsByTable.value = next;
  } catch (e) {
    error.value = e.message || String(e);
  } finally {
    loading.value = false;
  }
}

const preview = ref(null);

async function loadPreview() {
  loading.value = true;
  error.value = "";
  try {
    const queries = await Promise.all([
      supabase.from("payment_countries").select("*").eq("is_active", true).order("opt_order"),
      supabase.from("payment_cash_rules").select("*").eq("is_active", true).order("opt_order"),
      supabase.from("payment_card_networks").select("*").eq("is_active", true).order("sort_order"),
      supabase.from("payment_flow_steps").select("*").eq("is_active", true).order("step_order"),
      supabase.from("payment_rescue_rungs").select("*").eq("is_active", true).order("rung_order"),
      supabase.from("payment_merchant_phrases").select("*").eq("is_active", true).order("sort_order"),
      supabase.from("payment_node_texts").select("*").eq("is_active", true).order("ord"),
      supabase.from("payment_articles").select("*").eq("is_active", true).eq("is_published", true).order("display_order"),
      supabase.from("payment_checklist_items").select("*").eq("is_active", true).order("item_order"),
      supabase.from("payment_helper_links").select("*").eq("is_active", true).order("sort_order"),
    ]);
    const [countries, cashRules, cardNetworks, flowSteps, rescueRungs, merchantPhrases, nodeTexts, articles, checklistItems, helperLinks] = queries.map((q) => q.data || []);
    const stepsByNode = {};
    flowSteps.forEach((s) => { (stepsByNode[s.node_key] = stepsByNode[s.node_key] || []).push(s); });
    const nodeTextsMap = {};
    nodeTexts.forEach((t) => { (nodeTextsMap[t.node_key] = nodeTextsMap[t.node_key] || []).push(t); });
    const articlesByNode = {};
    articles.forEach((a) => { (articlesByNode[a.node_key] = articlesByNode[a.node_key] || []).push(a); });
    preview.value = {
      articles,
      articles_by_node: articlesByNode,
      flow: { steps_by_node: stepsByNode, countries, card_networks: cardNetworks, cash_rules: cashRules, rescue_rungs: rescueRungs, merchant_phrases: merchantPhrases, node_texts: nodeTextsMap, checklist_items: checklistItems, helper_links: helperLinks },
    };
  } catch (e) {
    error.value = e.message || String(e);
  } finally {
    loading.value = false;
  }
}

function startEdit(tableKey, row, presets = {}) {
  editing.value = { tableKey, row: row ? { ...row } : { _new: true, ...presets } };
}

function onSaved() {
  editing.value = null;
  loadAll();
  showToast("已保存");
}

function onDeleted() {
  editing.value = null;
  loadAll();
  showToast("已删除");
}

function schemaFor(tableKey) {
  return TABLES[tableKey] || { pk: "id", listColumns: [] };
}

function cellValue(tableKey, row, key) {
  const v = row[key];
  if (key === "sms_tone") return SMS_TONE_LABEL[v] || v || "—";
  if (key === "alipay_ok" || key === "wechat_ok" || key === "enabled" || key === "is_active" || key === "is_published" || key === "speakable") {
    return v ? "✓" : "—";
  }
  if (key === "amount_md_zh" || key === "text_zh" || key === "instruction_md_zh") {
    return String(v || "—").replace(/\*\*/g, "").slice(0, 48) + (String(v || "").length > 48 ? "…" : "");
  }
  if (v == null || v === "") return "—";
  if (Array.isArray(v)) return v.join(", ");
  return String(v);
}

function columnsFor(tableKey) {
  const cols = schemaFor(tableKey).listColumns;
  if (cols?.length) return cols;
  return [{ key: schemaFor(tableKey).pk || "id", label: "ID" }];
}

function rowsFor(key) {
  return rowsByTable.value[key] || [];
}

watch(position, loadAll);
watch(mainTab, (t) => { if (t === "preview") loadPreview(); });
onMounted(loadAll);
</script>

<template>
  <div class="pw">
    <header class="pw-head">
      <div>
        <h1>💳 支付助手工作台</h1>
        <p class="muted">按用户旅程位置管理内容。保存后 App 下次打开支付助手时会拉取最新 CMS 数据。</p>
      </div>
    </header>

    <div class="main-tabs">
      <button type="button" :class="{ active: mainTab === 'content' }" @click="mainTab = 'content'">① 内容（按流程）</button>
      <button type="button" :class="{ active: mainTab === 'preview' }" @click="mainTab = 'preview'">② 预览 App 数据</button>
    </div>

    <div v-if="toast" class="toast">{{ toast }}</div>
    <div v-if="error" class="status-bar error">{{ error }}</div>

    <div v-if="editing" class="edit-panel">
      <div class="edit-panel-head">
        <h3>{{ schemaFor(editing.tableKey).label }} · 编辑</h3>
        <button type="button" class="btn btn-secondary btn-sm" @click="editing = null">← 返回列表</button>
      </div>
      <RecordForm
        :table-key="editing.tableKey"
        :schema="schemaFor(editing.tableKey)"
        :initial="editing.row._new ? null : editing.row"
        :presets="editing.row._new ? editing.row : null"
        @saved="onSaved"
        @deleted="onDeleted"
        @cancel="editing = null"
      />
    </div>

    <template v-else-if="mainTab === 'content'">
      <div class="pos-tabs-wrap">
        <div class="pos-tabs">
          <button
            v-for="p in POSITIONS"
            :key="p.id"
            type="button"
            :class="{ active: position === p.id }"
            @click="position = p.id"
          >{{ p.label }}</button>
        </div>
      </div>

      <div v-if="loading" class="loading-box">加载中…</div>

      <div v-else class="sections">
        <!-- 裁决三表 -->
        <section
          v-for="tbl in (currentPos.tables || [])"
          :key="tbl"
          class="card"
        >
          <div class="card-head">
            <div>
              <h3>{{ schemaFor(tbl).label }}</h3>
              <span class="count">{{ rowsFor(tbl).length }} 条 · 点击行编辑</span>
            </div>
            <button type="button" class="btn btn-sm" @click="startEdit(tbl, null)">+ 新增</button>
          </div>
          <div class="table-wrap">
            <table class="data-table">
              <thead>
                <tr>
                  <th v-for="c in columnsFor(tbl)" :key="c.key">{{ c.label }}</th>
                  <th class="ops-col"></th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="row in rowsFor(tbl)" :key="row[schemaFor(tbl).pk || 'id']" @click="startEdit(tbl, row)">
                  <td v-for="c in columnsFor(tbl)" :key="c.key">{{ cellValue(tbl, row, c.key) }}</td>
                  <td class="ops-col"><span class="edit-hint">编辑</span></td>
                </tr>
                <tr v-if="!rowsFor(tbl).length">
                  <td :colspan="columnsFor(tbl).length + 1" class="empty-cell">暂无内容，点「+ 新增」添加</td>
                </tr>
              </tbody>
            </table>
          </div>
        </section>

        <!-- 按 node 的三块 -->
        <template v-for="node in (currentPos.nodes || [])" :key="node">
          <section class="card">
            <div class="card-head">
              <div>
                <h3>📝 屏幕文案 · {{ node }}</h3>
                <span class="count">{{ rowsFor(`payment_node_texts:${node}`).length }} 条</span>
              </div>
              <button type="button" class="btn btn-sm" @click="startEdit('payment_node_texts', null, { node_key: node })">+ 加文案</button>
            </div>
            <div class="table-wrap">
              <table class="data-table">
                <thead><tr><th>槽位</th><th>文案</th><th class="ops-col"></th></tr></thead>
                <tbody>
                  <tr v-for="row in rowsFor(`payment_node_texts:${node}`)" :key="row.id" @click="startEdit('payment_node_texts', row)">
                    <td><code>{{ row.slot }}</code></td>
                    <td class="text-cell">{{ row.text_zh }}</td>
                    <td class="ops-col"><span class="edit-hint">编辑</span></td>
                  </tr>
                  <tr v-if="!rowsFor(`payment_node_texts:${node}`).length">
                    <td colspan="3" class="empty-cell">暂无文案</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </section>

          <section v-if="!['rescue','merchant'].includes(node)" class="card">
            <div class="card-head">
              <div>
                <h3>🪜 操作步骤 · {{ node }}</h3>
                <span class="count">{{ rowsFor(`payment_flow_steps:${node}`).length }} 步</span>
              </div>
              <button type="button" class="btn btn-sm" @click="startEdit('payment_flow_steps', null, { node_key: node })">+ 加一步</button>
            </div>
            <div class="table-wrap">
              <table class="data-table">
                <thead><tr><th>App</th><th>标题</th><th>稳定性</th><th class="ops-col"></th></tr></thead>
                <tbody>
                  <tr v-for="row in rowsFor(`payment_flow_steps:${node}`)" :key="row.id" @click="startEdit('payment_flow_steps', row)">
                    <td>{{ row.tool || "通用" }}</td>
                    <td class="text-cell">{{ row.title_zh }}</td>
                    <td>
                      <span :class="row.stability_tier === 'volatile' ? 'badge-warn' : 'badge-ok'">
                        {{ row.stability_tier === 'volatile' ? '易失效' : '稳定' }}
                      </span>
                    </td>
                    <td class="ops-col"><span class="edit-hint">编辑</span></td>
                  </tr>
                  <tr v-if="!rowsFor(`payment_flow_steps:${node}`).length">
                    <td colspan="4" class="empty-cell">暂无步骤</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </section>

          <section v-if="['plan','bind','use','home'].includes(node)" class="card">
            <div class="card-head">
              <div>
                <h3>📄 详细图文 · {{ node }}</h3>
                <span class="count">{{ rowsFor(`payment_articles:${node}`).length }} 篇</span>
              </div>
              <button type="button" class="btn btn-sm" @click="startEdit('payment_articles', null, { node_key: node })">+ 加文章</button>
            </div>
            <div class="table-wrap">
              <table class="data-table">
                <thead><tr><th>标题</th><th>已发布</th><th class="ops-col"></th></tr></thead>
                <tbody>
                  <tr v-for="row in rowsFor(`payment_articles:${node}`)" :key="row.id" @click="startEdit('payment_articles', row)">
                    <td class="text-cell">{{ row.title_zh }}</td>
                    <td>{{ row.is_published ? '✓' : '—' }}</td>
                    <td class="ops-col"><span class="edit-hint">编辑</span></td>
                  </tr>
                  <tr v-if="!rowsFor(`payment_articles:${node}`).length">
                    <td colspan="3" class="empty-cell">暂无文章</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </section>
        </template>

        <section v-if="currentPos.id === 'rescue'" class="card">
          <div class="card-head">
            <div>
              <h3>🆘 救援阶梯</h3>
              <span class="count">{{ rowsFor('payment_rescue_rungs').length }} 级</span>
            </div>
            <button type="button" class="btn btn-sm" @click="startEdit('payment_rescue_rungs', null)">+ 加一级</button>
          </div>
          <div class="table-wrap">
            <table class="data-table">
              <thead><tr><th>级</th><th>标题</th><th>副标题</th><th>适用</th><th class="ops-col"></th></tr></thead>
              <tbody>
                <tr v-for="row in rowsFor('payment_rescue_rungs')" :key="row.id" @click="startEdit('payment_rescue_rungs', row)">
                  <td>{{ row.rung_order }}</td>
                  <td>{{ row.title_zh }}</td>
                  <td class="text-cell">{{ row.subtitle_zh }}</td>
                  <td>{{ row.applies === 'wx_only' ? '仅微信可绑' : '始终' }}</td>
                  <td class="ops-col"><span class="edit-hint">编辑</span></td>
                </tr>
              </tbody>
            </table>
          </div>
        </section>

        <section v-if="currentPos.id === 'merchant'" class="card">
          <div class="card-head">
            <div>
              <h3>🗣️ 商家话术</h3>
              <span class="count">{{ rowsFor('payment_merchant_phrases').length }} 句</span>
            </div>
            <button type="button" class="btn btn-sm" @click="startEdit('payment_merchant_phrases', null)">+ 加一句</button>
          </div>
          <div class="table-wrap">
            <table class="data-table">
              <thead><tr><th>中文</th><th>EN</th><th>TTS</th><th>音频</th><th class="ops-col"></th></tr></thead>
              <tbody>
                <tr v-for="row in rowsFor('payment_merchant_phrases')" :key="row.id" @click="startEdit('payment_merchant_phrases', row)">
                  <td class="text-cell">{{ row.cn }}</td>
                  <td class="text-cell muted-cell">{{ row.en || '—' }}</td>
                  <td>{{ row.speakable !== false ? '✓' : '—' }}</td>
                  <td>{{ row.audio_url ? '🎵' : '—' }}</td>
                  <td class="ops-col"><span class="edit-hint">编辑</span></td>
                </tr>
              </tbody>
            </table>
          </div>
        </section>
      </div>
    </template>

    <template v-else>
      <div class="preview-bar">
        <button type="button" class="btn" @click="loadPreview">↻ 查看 App 实时数据</button>
        <span v-if="loading" class="muted">加载中…</span>
      </div>
      <pre v-if="preview" class="preview-json">{{ JSON.stringify(preview, null, 2) }}</pre>
      <p v-else-if="!loading" class="empty-hint">点击上方按钮加载 App 当前会收到的 JSON 结构</p>
    </template>
  </div>
</template>

<style scoped>
.pw {
  width: 100%;
  max-width: none;
}

.pw-head {
  margin-bottom: 20px;
}

.pw-head h1 {
  margin: 0 0 6px;
  font-size: 22px;
  font-weight: 700;
}

.muted {
  color: var(--muted);
  font-size: 14px;
  margin: 0;
}

/* 主 Tab */
.main-tabs {
  display: flex;
  gap: 8px;
  margin-bottom: 20px;
  padding-bottom: 16px;
  border-bottom: 1px solid var(--border);
}

.main-tabs button {
  appearance: none;
  padding: 10px 18px;
  border: 1px solid var(--border);
  border-radius: var(--radius);
  background: var(--surface);
  color: var(--text);
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: background 0.15s, border-color 0.15s;
}

.main-tabs button:hover {
  background: var(--surface2);
}

.main-tabs button.active {
  background: var(--accent);
  border-color: var(--accent);
  color: #fff;
}

/* 位置 Tab — 横向滚动 */
.pos-tabs-wrap {
  margin-bottom: 20px;
  overflow-x: auto;
  -webkit-overflow-scrolling: touch;
}

.pos-tabs {
  display: flex;
  flex-wrap: nowrap;
  gap: 8px;
  min-width: min-content;
  padding-bottom: 4px;
}

.pos-tabs button {
  appearance: none;
  flex-shrink: 0;
  padding: 8px 14px;
  border: 1px solid var(--border);
  border-radius: 999px;
  background: var(--surface);
  color: var(--muted);
  font-size: 13px;
  font-weight: 500;
  cursor: pointer;
  white-space: nowrap;
  transition: all 0.15s;
}

.pos-tabs button:hover {
  color: var(--text);
  border-color: var(--accent);
}

.pos-tabs button.active {
  background: var(--surface2);
  border-color: var(--accent);
  color: var(--text);
  font-weight: 600;
  box-shadow: inset 0 0 0 1px rgba(196, 92, 38, 0.25);
}

/* 内容区 */
.sections {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.card {
  background: var(--surface);
  border: 1px solid var(--border);
  border-radius: 12px;
  overflow: hidden;
}

.card-head {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 16px;
  padding: 16px 18px;
  border-bottom: 1px solid var(--border);
  background: var(--surface2);
}

.card-head h3 {
  margin: 0 0 4px;
  font-size: 15px;
  font-weight: 700;
}

.count {
  font-size: 12px;
  color: var(--muted);
}

.table-wrap {
  overflow-x: auto;
}

.data-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 14px;
}

.data-table th,
.data-table td {
  text-align: left;
  padding: 12px 16px;
  border-bottom: 1px solid var(--border);
  vertical-align: middle;
}

.data-table th {
  color: var(--muted);
  font-weight: 600;
  font-size: 12px;
  text-transform: none;
  background: var(--surface);
}

.data-table tbody tr {
  cursor: pointer;
  transition: background 0.12s;
}

.data-table tbody tr:hover {
  background: var(--surface2);
}

.data-table tbody tr:last-child td {
  border-bottom: none;
}

.text-cell {
  max-width: 420px;
  line-height: 1.45;
}

.muted-cell {
  color: var(--muted);
}

.ops-col {
  width: 64px;
  text-align: right;
  white-space: nowrap;
}

.edit-hint {
  font-size: 12px;
  color: var(--accent);
  opacity: 0;
  transition: opacity 0.12s;
}

.data-table tbody tr:hover .edit-hint {
  opacity: 1;
}

.empty-cell {
  text-align: center;
  color: var(--muted);
  padding: 28px 16px !important;
  cursor: default;
}

.empty-hint {
  color: var(--muted);
  text-align: center;
  padding: 40px 0;
}

.loading-box {
  padding: 48px;
  text-align: center;
  color: var(--muted);
}

.edit-panel {
  background: var(--surface);
  border: 1px solid var(--border);
  border-radius: 12px;
  padding: 20px;
  margin-bottom: 20px;
}

.edit-panel-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  margin-bottom: 16px;
  padding-bottom: 12px;
  border-bottom: 1px solid var(--border);
}

.edit-panel-head h3 {
  margin: 0;
  font-size: 16px;
}

.badge-ok,
.badge-warn {
  display: inline-block;
  padding: 2px 8px;
  border-radius: 999px;
  font-size: 11px;
  font-weight: 600;
}

.badge-ok {
  background: rgba(46, 125, 50, 0.15);
  color: #2e7d32;
}

.badge-warn {
  background: rgba(196, 92, 38, 0.15);
  color: var(--accent);
}

[data-theme="dark"] .badge-ok { color: #81c784; }
[data-theme="dark"] .badge-warn { color: #ffb74d; }

code {
  font-size: 12px;
  padding: 2px 6px;
  border-radius: 4px;
  background: var(--bg);
  border: 1px solid var(--border);
}

.preview-bar {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 16px;
}

.preview-json {
  background: #0d1117;
  color: #c9d1d9;
  padding: 18px;
  border-radius: 12px;
  border: 1px solid var(--border);
  font-size: 12px;
  line-height: 1.5;
  max-height: 72vh;
  overflow: auto;
  white-space: pre-wrap;
  word-break: break-word;
}

.toast {
  background: rgba(46, 125, 50, 0.12);
  color: #2e7d32;
  border: 1px solid rgba(46, 125, 50, 0.3);
  padding: 10px 14px;
  border-radius: var(--radius);
  margin-bottom: 12px;
  font-size: 13px;
}

[data-theme="dark"] .toast {
  color: #81c784;
}
</style>
