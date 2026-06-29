<script setup>
import { ref, computed, watch, onMounted } from "vue";
import { supabase } from "@/lib/supabase";
import { TABLES } from "@/schema/tables";
import RecordForm from "@/components/RecordForm.vue";

const mainTab = ref("content");
const position = ref("questions");

const POSITIONS = [
  { id: "questions", label: "入口与三问", nodes: [], tables: ["payment_countries", "payment_card_networks", "payment_cash_rules"] },
  { id: "plan", label: "方案页", nodes: ["plan"] },
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
  payment_countries: "opt_order",
  payment_cash_rules: "opt_order",
  payment_card_networks: "sort_order",
};

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
    ]);
    const [countries, cashRules, cardNetworks, flowSteps, rescueRungs, merchantPhrases, nodeTexts, articles] = queries.map((q) => q.data || []);
    const stepsByNode = {};
    flowSteps.forEach((s) => { (stepsByNode[s.node_key] = stepsByNode[s.node_key] || []).push(s); });
    const nodeTextsMap = {};
    nodeTexts.forEach((t) => { (nodeTextsMap[t.node_key] = nodeTextsMap[t.node_key] || []).push(t); });
    const articlesByNode = {};
    articles.forEach((a) => { (articlesByNode[a.node_key] = articlesByNode[a.node_key] || []).push(a); });
    preview.value = {
      articles,
      articles_by_node: articlesByNode,
      flow: { steps_by_node: stepsByNode, countries, card_networks: cardNetworks, cash_rules: cashRules, rescue_rungs: rescueRungs, merchant_phrases: merchantPhrases, node_texts: nodeTextsMap },
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

function rowLabel(tableKey, row) {
  const schema = TABLES[tableKey];
  const col = schema?.listColumns?.[0]?.key;
  if (col && row[col]) return String(row[col]).slice(0, 60);
  return row[schema?.pk || "id"] || "—";
}

watch(position, loadAll);
watch(mainTab, (t) => { if (t === "preview") loadPreview(); });
onMounted(loadAll);
</script>

<template>
  <div class="pw">
    <h1>💳 支付助手工作台</h1>
    <p class="muted">按用户旅程位置管理内容。保存即生效，App 下次刷新即更新。</p>

    <div class="tabs">
      <button :class="{ active: mainTab === 'content' }" @click="mainTab = 'content'">① 内容（按流程）</button>
      <button :class="{ active: mainTab === 'preview' }" @click="mainTab = 'preview'">② 预览 App 数据</button>
    </div>

    <div v-if="toast" class="toast">{{ toast }}</div>
    <div v-if="error" class="status-bar error">{{ error }}</div>

    <div v-if="editing" class="edit-panel">
      <h3>{{ TABLES[editing.tableKey]?.label }} · 编辑</h3>
      <RecordForm
        :table-key="editing.tableKey"
        :schema="TABLES[editing.tableKey]"
        :initial="editing.row._new ? null : editing.row"
        :presets="editing.row._new ? editing.row : null"
        @saved="onSaved"
        @deleted="onDeleted"
        @cancel="editing = null"
      />
    </div>

    <template v-else-if="mainTab === 'content'">
      <div class="pos-tabs">
        <button v-for="p in POSITIONS" :key="p.id" :class="{ active: position === p.id }" @click="position = p.id">{{ p.label }}</button>
      </div>
      <div v-if="loading" class="muted">加载中…</div>

      <template v-else>
        <section v-for="tbl in (currentPos.tables || [])" :key="tbl" class="section">
          <div class="section-head">
            <h3>{{ TABLES[tbl]?.label }}</h3>
            <button class="btn btn-sm" @click="startEdit(tbl, null)">+ 新增</button>
          </div>
          <ul class="row-list">
            <li v-for="row in (rowsByTable[tbl] || [])" :key="row[TABLES[tbl]?.pk || 'id']" @click="startEdit(tbl, row)">
              {{ rowLabel(tbl, row) }}
            </li>
            <li v-if="!(rowsByTable[tbl] || []).length" class="empty">暂无内容</li>
          </ul>
        </section>

        <template v-for="node in (currentPos.nodes || [])" :key="node">
          <section class="section">
            <div class="section-head">
              <h3>📝 屏幕文案 · {{ node }}</h3>
              <button class="btn btn-sm" @click="startEdit('payment_node_texts', null, { node_key: node })">+ 加文案</button>
            </div>
            <ul class="row-list">
              <li v-for="row in (rowsByTable[`payment_node_texts:${node}`] || [])" :key="row.id" @click="startEdit('payment_node_texts', row)">
                [{{ row.slot }}] {{ row.text_zh?.slice(0, 50) }}
              </li>
            </ul>
          </section>

          <section v-if="!['rescue','merchant'].includes(node)" class="section">
            <div class="section-head">
              <h3>🪜 操作步骤 · {{ node }}</h3>
              <button class="btn btn-sm" @click="startEdit('payment_flow_steps', null, { node_key: node })">+ 加一步</button>
            </div>
            <ul class="row-list">
              <li v-for="row in (rowsByTable[`payment_flow_steps:${node}`] || [])" :key="row.id" @click="startEdit('payment_flow_steps', row)">
                {{ row.tool ? `[${row.tool}] ` : "" }}{{ row.title_zh }}
              </li>
            </ul>
          </section>

          <section v-if="['plan','bind','use','home'].includes(node)" class="section">
            <div class="section-head">
              <h3>📄 详细图文 · {{ node }}</h3>
              <button class="btn btn-sm" @click="startEdit('payment_articles', null, { node_key: node })">+ 加文章</button>
            </div>
            <ul class="row-list">
              <li v-for="row in (rowsByTable[`payment_articles:${node}`] || [])" :key="row.id" @click="startEdit('payment_articles', row)">
                {{ row.title_zh }}
              </li>
            </ul>
          </section>
        </template>

        <section v-if="currentPos.id === 'rescue'" class="section">
          <div class="section-head">
            <h3>🆘 救援阶梯</h3>
            <button class="btn btn-sm" @click="startEdit('payment_rescue_rungs', null)">+ 加一级</button>
          </div>
          <ul class="row-list">
            <li v-for="row in (rowsByTable.payment_rescue_rungs || [])" :key="row.id" @click="startEdit('payment_rescue_rungs', row)">
              {{ row.rung_order }}. {{ row.title_zh }}
            </li>
          </ul>
        </section>

        <section v-if="currentPos.id === 'merchant'" class="section">
          <div class="section-head">
            <h3>🗣️ 商家话术</h3>
            <button class="btn btn-sm" @click="startEdit('payment_merchant_phrases', null)">+ 加一句</button>
          </div>
          <ul class="row-list">
            <li v-for="row in (rowsByTable.payment_merchant_phrases || [])" :key="row.id" @click="startEdit('payment_merchant_phrases', row)">
              {{ row.cn }}
            </li>
          </ul>
        </section>
      </template>
    </template>

    <template v-else>
      <div class="preview-bar">
        <button class="btn" @click="loadPreview">↻ 查看 App 实时数据</button>
      </div>
      <pre v-if="preview" class="preview-json">{{ JSON.stringify(preview, null, 2) }}</pre>
      <p v-else-if="!loading" class="muted">点击上方按钮加载预览</p>
    </template>
  </div>
</template>

<style scoped>
.pw { padding: 0 4px; max-width: 900px; }
.pw h1 { font-size: 1.35rem; margin-bottom: 4px; }
.muted { color: var(--muted, #888); font-size: 0.9rem; }
.tabs, .pos-tabs { display: flex; flex-wrap: wrap; gap: 6px; margin-bottom: 16px; }
.tabs button, .pos-tabs button {
  padding: 8px 14px; border: 1px solid var(--border, #ddd); border-radius: 8px;
  background: var(--bg, #fff); cursor: pointer; font-size: 0.85rem;
}
.tabs button.active, .pos-tabs button.active { background: #333; color: #fff; border-color: #333; }
.section { margin-bottom: 24px; padding-bottom: 16px; border-bottom: 1px solid #eee; }
.section-head { display: flex; align-items: center; gap: 12px; margin-bottom: 8px; }
.section h3 { font-size: 1rem; margin: 0; flex: 1; }
.row-list { list-style: none; padding: 0; margin: 0; }
.row-list li { padding: 8px 12px; border: 1px solid #eee; border-radius: 6px; margin-bottom: 4px; cursor: pointer; font-size: 0.9rem; }
.row-list li:hover { background: #f5f5f5; }
.row-list li.empty { cursor: default; color: #999; }
.edit-panel { background: #f9f9f9; padding: 16px; border-radius: 12px; margin-bottom: 16px; }
.preview-bar { margin-bottom: 12px; }
.preview-json { background: #1e1e1e; color: #d4d4d4; padding: 16px; border-radius: 8px; font-size: 11px; max-height: 70vh; overflow: auto; white-space: pre-wrap; }
.toast { background: #e8f5e9; padding: 8px 12px; border-radius: 6px; margin-bottom: 8px; }
.status-bar.error { background: #ffebee; color: #c62828; padding: 8px 12px; border-radius: 6px; margin-bottom: 8px; }
.btn { padding: 6px 12px; border-radius: 6px; border: 1px solid #ccc; cursor: pointer; background: #fff; }
.btn-sm { font-size: 0.8rem; padding: 4px 10px; }
</style>
