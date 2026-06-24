<script setup>
import { ref, onMounted } from "vue";
import { supabase } from "@/lib/supabase";

const tab = ref("plans");
const toast = ref("");
const error = ref("");
function showToast(m) { toast.value = m; setTimeout(() => (toast.value = ""), 1600); }

// ── plans ──
const plans = ref([]);
const editing = ref(null); // plan form or null

async function loadPlans() {
  error.value = "";
  const { data, error: e } = await supabase.from("membership_plans").select("*").order("display_order");
  if (e) error.value = e.message;
  plans.value = data || [];
}

const BLANK = {
  id: "", name_zh: "", name_en: "", price_label: "", plan_type: "subscription",
  duration_days: null, free_trial_days: null, apple_product_id: "", rc_package_id: "",
  display_order: 0, is_best_value: false, is_active: true, feature_lines: [], access_flags: [],
};

function newPlan() { editing.value = { ...BLANK, _new: true }; }
function editPlan(p) { editing.value = { ...p, feature_lines: p.feature_lines || [], access_flags: p.access_flags || [] }; }

// arrays edited as newline text
function linesGet(arr) { return Array.isArray(arr) ? arr.join("\n") : ""; }
function linesSet(key, v) { editing.value[key] = v.split("\n").map((s) => s.trim()).filter(Boolean); }

async function savePlan() {
  const p = editing.value;
  if (!p.id) { showToast("请填写计划 ID"); return; }
  const payload = { ...p };
  delete payload._new;
  const { error: e } = await supabase.from("membership_plans").upsert(payload);
  if (e) { showToast("失败：" + e.message); return; }
  editing.value = null;
  await loadPlans();
  showToast("已保存");
}
async function removePlan(p) {
  if (!confirm(`删除计划「${p.name_zh || p.id}」？`)) return;
  const { error: e } = await supabase.from("membership_plans").delete().eq("id", p.id);
  if (e) { showToast("失败：" + e.message); return; }
  await loadPlans();
}

// ── transactions ──
const txns = ref([]);
async function loadTxns() {
  const { data, error: e } = await supabase
    .from("user_iap_transactions").select("*").order("created_at", { ascending: false }).limit(200);
  if (e) error.value = e.message;
  txns.value = data || [];
}

// ── refunds ──
const refunds = ref([]);
async function loadRefunds() {
  const { data, error: e } = await supabase
    .from("user_refund_requests").select("*").order("created_at", { ascending: false }).limit(200);
  if (e) error.value = e.message;
  refunds.value = data || [];
}
async function setRefundStatus(r, status) {
  const { error: e } = await supabase.from("user_refund_requests").update({ status }).eq("id", r.id);
  if (e) { showToast("失败：" + e.message); return; }
  await loadRefunds();
  showToast("已更新");
}

function switchTab(t) {
  tab.value = t;
  if (t === "plans") loadPlans();
  else if (t === "txns") loadTxns();
  else loadRefunds();
}

onMounted(loadPlans);
</script>

<template>
  <div class="mh">
    <h1>👑 会员与购买</h1>
    <div v-if="error" class="status-bar error">{{ error }}</div>
    <div class="tabs">
      <button :class="{ on: tab === 'plans' }" @click="switchTab('plans')">会员计划</button>
      <button :class="{ on: tab === 'txns' }" @click="switchTab('txns')">交易记录</button>
      <button :class="{ on: tab === 'refunds' }" @click="switchTab('refunds')">退款申请</button>
    </div>

    <!-- plans -->
    <section v-if="tab === 'plans'">
      <template v-if="editing">
        <div class="form-head">
          <h2>{{ editing._new ? "新建计划" : "编辑计划" }}</h2>
          <div>
            <button class="btn btn-secondary btn-sm" @click="editing = null">取消</button>
            <button class="btn btn-sm" @click="savePlan">保存</button>
          </div>
        </div>
        <div class="fgrid">
          <label class="f">计划 ID<input v-model="editing.id" :readonly="!editing._new" /></label>
          <label class="f">类型
            <select v-model="editing.plan_type">
              <option value="subscription">订阅</option>
              <option value="one_time_attraction">单次景点</option>
            </select>
          </label>
          <label class="f">中文名<input v-model="editing.name_zh" /></label>
          <label class="f">英文名<input v-model="editing.name_en" /></label>
          <label class="f">价格文案<input v-model="editing.price_label" /></label>
          <label class="f">时长（天）<input type="number" v-model.number="editing.duration_days" /></label>
          <label class="f">免费试用（天）<input type="number" v-model.number="editing.free_trial_days" /></label>
          <label class="f">Apple 产品 ID<input v-model="editing.apple_product_id" /></label>
          <label class="f">RC Package ID<input v-model="editing.rc_package_id" /></label>
          <label class="f">排序<input type="number" v-model.number="editing.display_order" /></label>
          <label class="f full">权益文案（每行一条）<textarea rows="4" :value="linesGet(editing.feature_lines)" @input="linesSet('feature_lines', $event.target.value)"></textarea></label>
          <label class="f full">access_flags（每行一条）<textarea rows="2" :value="linesGet(editing.access_flags)" @input="linesSet('access_flags', $event.target.value)"></textarea></label>
          <label class="cond"><input type="checkbox" v-model="editing.is_best_value" /> 最佳价值</label>
          <label class="cond"><input type="checkbox" v-model="editing.is_active" /> 启用</label>
        </div>
      </template>

      <template v-else>
        <div class="bar"><button class="btn" @click="newPlan">+ 新建计划</button></div>
        <table class="data-table">
          <thead><tr><th>名称</th><th>类型</th><th>价格</th><th>启用</th><th></th></tr></thead>
          <tbody>
            <tr v-for="p in plans" :key="p.id" @click="editPlan(p)" class="click">
              <td><strong>{{ p.name_zh || p.name_en }}</strong> <span class="muted">{{ p.id }}</span></td>
              <td>{{ p.plan_type }}</td>
              <td>{{ p.price_label }}</td>
              <td>{{ p.is_active ? "✓" : "—" }}</td>
              <td @click.stop><button class="btn btn-secondary btn-sm" @click="removePlan(p)">删</button></td>
            </tr>
          </tbody>
        </table>
      </template>
    </section>

    <!-- transactions -->
    <section v-else-if="tab === 'txns'">
      <table class="data-table">
        <thead><tr><th>时间</th><th>用户</th><th>产品</th><th>类型</th><th>金额</th><th>状态</th></tr></thead>
        <tbody>
          <tr v-for="t in txns" :key="t.id">
            <td>{{ (t.created_at || "").slice(0, 19).replace("T", " ") }}</td>
            <td class="muted">{{ t.user_id }}</td>
            <td>{{ t.product_id || t.plan_id }}</td>
            <td>{{ t.transaction_type || t.type }}</td>
            <td>{{ t.price || t.amount || "" }}</td>
            <td>{{ t.status }}</td>
          </tr>
          <tr v-if="!txns.length"><td colspan="6" class="center muted">暂无交易</td></tr>
        </tbody>
      </table>
    </section>

    <!-- refunds -->
    <section v-else>
      <table class="data-table">
        <thead><tr><th>时间</th><th>用户</th><th>原因</th><th>状态</th><th>操作</th></tr></thead>
        <tbody>
          <tr v-for="r in refunds" :key="r.id">
            <td>{{ (r.created_at || "").slice(0, 19).replace("T", " ") }}</td>
            <td class="muted">{{ r.user_id }}</td>
            <td>{{ r.reason || "" }}</td>
            <td>{{ r.status }}</td>
            <td @click.stop>
              <button class="btn btn-sm" @click="setRefundStatus(r, 'approved')">通过</button>
              <button class="btn btn-secondary btn-sm" @click="setRefundStatus(r, 'rejected')">驳回</button>
            </td>
          </tr>
          <tr v-if="!refunds.length"><td colspan="5" class="center muted">暂无退款申请</td></tr>
        </tbody>
      </table>
    </section>

    <div class="toast" :class="{ on: toast }">{{ toast }}</div>
  </div>
</template>

<style scoped>
.mh h1 { margin: 0 0 12px; font-size: 20px; }
.tabs { display: flex; gap: 4px; border-bottom: 1px solid var(--border); margin-bottom: 14px; }
.tabs button { background: transparent; border: none; padding: 9px 16px; cursor: pointer; color: var(--muted); font-weight: 600; border-bottom: 2px solid transparent; }
.tabs button.on { color: var(--text); border-bottom-color: var(--accent); }
.bar { margin-bottom: 12px; }
.form-head { display: flex; justify-content: space-between; align-items: center; margin-bottom: 14px; }
.form-head h2 { margin: 0; font-size: 18px; }
.form-head .btn { margin-left: 8px; }
.fgrid { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; max-width: 760px; }
.f { display: block; font-size: 12px; color: var(--muted); }
.f.full { grid-column: 1 / -1; }
.f input, .f select, .f textarea { margin-top: 4px; }
.cond { display: inline-flex; align-items: center; gap: 6px; font-size: 14px; }
.cond input { width: auto; }
.data-table { width: 100%; border-collapse: collapse; font-size: 14px; }
.data-table th, .data-table td { text-align: left; padding: 8px 12px; border-bottom: 1px solid var(--border); }
.data-table th { color: var(--muted); font-size: 13px; }
.click { cursor: pointer; }
.click:hover { background: var(--surface2); }
.data-table .btn { margin-right: 6px; }
.muted { color: var(--muted); }
.center { text-align: center; padding: 24px; }
.toast { position: fixed; bottom: 26px; left: 50%; transform: translateX(-50%); background: var(--text); color: var(--bg); padding: 10px 18px; border-radius: 8px; font-size: 13px; opacity: 0; pointer-events: none; transition: opacity 0.2s; z-index: 1100; }
.toast.on { opacity: 1; }
</style>
