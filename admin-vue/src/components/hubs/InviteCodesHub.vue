<script setup>
import { ref, computed, onMounted } from "vue";
import { supabase } from "@/lib/supabase";

const tab = ref("codes");
const toast = ref("");
const error = ref("");
function showToast(m) { toast.value = m; setTimeout(() => (toast.value = ""), 1800); }

const CHARSET = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";

const DURATION_PRESETS = [
  { id: "1_month", label: "1 个月" },
  { id: "2_months", label: "2 个月" },
  { id: "6_months", label: "半年" },
  { id: "lifetime", label: "终身" },
  { id: "custom", label: "自定义天数" },
];

const MODE_LABELS = {
  single_use: "一次性（全平台 1 次）",
  multi_use: "限量",
  unlimited: "不限量（每人每码 1 次）",
};

function randomCode(len = 8) {
  const arr = new Uint32Array(len);
  crypto.getRandomValues(arr);
  return Array.from(arr, (n) => CHARSET[n % CHARSET.length]).join("");
}

function benefitLabel(row) {
  const p = DURATION_PRESETS.find((x) => x.id === row.duration_preset);
  if (row.duration_preset === "custom") return `${row.duration_days || "?"} 天`;
  return p?.label || row.duration_preset;
}

function codeStatus(row) {
  if (!row.is_active) return row.redeemed_count > 0 ? "exhausted" : "disabled";
  if (row.valid_until && new Date(row.valid_until) < new Date()) return "expired";
  if (row.valid_from && new Date(row.valid_from) > new Date()) return "scheduled";
  if (row.max_redemptions != null && row.redeemed_count >= row.max_redemptions) return "exhausted";
  return "active";
}

// ── data ──
const codes = ref([]);
const batches = ref([]);
const redemptions = ref([]);
const plans = ref([]);
const search = ref("");
const filterBatch = ref("");

async function loadPlans() {
  const { data } = await supabase.from("membership_plans").select("id,name_zh,name_en").eq("is_active", true).order("display_order");
  plans.value = data || [];
}

async function loadCodes() {
  error.value = "";
  const { data, error: e } = await supabase.from("invite_codes").select("*").order("created_at", { ascending: false }).limit(500);
  if (e) error.value = e.message;
  codes.value = data || [];
}

async function loadBatches() {
  const { data } = await supabase.from("invite_code_batches").select("*").order("created_at", { ascending: false }).limit(100);
  batches.value = data || [];
}

async function loadRedemptions() {
  const { data, error: e } = await supabase
    .from("invite_code_redemptions")
    .select("*, profiles(email)")
    .order("redeemed_at", { ascending: false })
    .limit(200);
  if (e) error.value = e.message;
  redemptions.value = (data || []).map((r) => ({
    ...r,
    email: r.profiles?.email || r.user_id,
  }));
}

const filteredCodes = computed(() => {
  let rows = codes.value;
  if (filterBatch.value) rows = rows.filter((c) => c.batch_id === filterBatch.value);
  const q = search.value.trim().toUpperCase();
  if (q) rows = rows.filter((c) => (c.code || "").includes(q) || (c.label || "").includes(q));
  return rows;
});

// ── single edit ──
const editing = ref(null);

const BLANK = {
  id: "",
  code: "",
  label: "",
  batch_id: null,
  plan_id: "annual",
  duration_preset: "1_month",
  duration_days: null,
  redemption_mode: "single_use",
  max_redemptions: 1,
  auto_deactivate_on_exhaust: true,
  one_per_account: false,
  new_users_only: false,
  valid_from: null,
  valid_until: null,
  is_active: true,
};

function newCode() {
  editing.value = { ...BLANK, _new: true, code: randomCode() };
}

function editCode(row) {
  editing.value = { ...row };
}

function onModeChange() {
  const m = editing.value.redemption_mode;
  if (m === "single_use") {
    editing.value.max_redemptions = 1;
    editing.value.auto_deactivate_on_exhaust = true;
  } else if (m === "unlimited") {
    editing.value.max_redemptions = null;
  } else if (m === "multi_use" && !editing.value.max_redemptions) {
    editing.value.max_redemptions = 10;
  }
}

async function saveCode() {
  const p = editing.value;
  if (!p.code?.trim()) return showToast("请填写邀请码");
  if (!p.id) p.id = `ic_${Date.now().toString(36)}`;
  p.code = p.code.trim().toUpperCase();
  const payload = { ...p };
  delete payload._new;
  const { error: e } = await supabase.from("invite_codes").upsert(payload);
  if (e) return showToast("失败：" + e.message);
  editing.value = null;
  await loadCodes();
  showToast("已保存");
}

async function deactivateCode(row) {
  if (!confirm(`停用邀请码 ${row.code}？`)) return;
  const { error: e } = await supabase.from("invite_codes").update({ is_active: false, updated_at: new Date().toISOString() }).eq("id", row.id);
  if (e) return showToast("失败：" + e.message);
  await loadCodes();
  showToast("已停用");
}

// ── batch generate ──
const batchForm = ref({
  label: "",
  count: 20,
  plan_id: "annual",
  duration_preset: "1_month",
  duration_days: null,
  redemption_mode: "single_use",
  max_redemptions: 1,
  one_per_account: false,
  new_users_only: false,
});

async function generateBatch() {
  const f = batchForm.value;
  const n = Math.min(Math.max(Number(f.count) || 1, 1), 500);
  if (f.duration_preset === "custom" && !(f.duration_days > 0)) {
    return showToast("请填写自定义天数");
  }
  if (!confirm(`生成 ${n} 个一次性邀请码？`)) return;

  const batchId = `camp_${Date.now().toString(36)}`;
  const { error: be } = await supabase.from("invite_code_batches").insert({
    id: batchId,
    label: f.label || batchId,
    redemption_mode: f.redemption_mode,
    duration_preset: f.duration_preset,
    duration_days: f.duration_preset === "custom" ? f.duration_days : null,
    plan_id: f.plan_id,
    one_per_account: f.one_per_account,
    codes_generated: n,
  });
  if (be) return showToast("批次创建失败：" + be.message);

  const rows = [];
  const seen = new Set();
  for (let i = 0; i < n; i++) {
    let code;
    do { code = randomCode(8); } while (seen.has(code));
    seen.add(code);
    rows.push({
      id: `ic_${batchId}_${i}`,
      code,
      label: f.label || batchId,
      batch_id: batchId,
      plan_id: f.plan_id,
      duration_preset: f.duration_preset,
      duration_days: f.duration_preset === "custom" ? f.duration_days : null,
      redemption_mode: "single_use",
      max_redemptions: 1,
      auto_deactivate_on_exhaust: true,
      one_per_account: f.one_per_account,
      new_users_only: f.new_users_only,
      is_active: true,
    });
  }

  const { error: ce } = await supabase.from("invite_codes").insert(rows);
  if (ce) return showToast("写入码失败：" + ce.message);

  const csv = ["code,batch_id,benefit", ...rows.map((r) => `${r.code},${batchId},${benefitLabel(r)}`)].join("\n");
  const blob = new Blob([csv], { type: "text/csv" });
  const a = document.createElement("a");
  a.href = URL.createObjectURL(blob);
  a.download = `invite_codes_${batchId}.csv`;
  a.click();

  await loadCodes();
  await loadBatches();
  showToast(`已生成 ${n} 个码`);
}

function switchTab(t) {
  tab.value = t;
  if (t === "codes") { loadCodes(); loadBatches(); }
  else if (t === "redemptions") loadRedemptions();
  else if (t === "batches") loadBatches();
}

onMounted(async () => {
  await loadPlans();
  await loadCodes();
  await loadBatches();
});
</script>

<template>
  <div class="ih">
    <h1>🎟 邀请码</h1>
    <p class="hint">兑换后写入用户 <code>membership_override=grant</code>，与后台手动赠送会员相同。</p>
    <div v-if="error" class="status-bar error">{{ error }}</div>

    <div class="tabs">
      <button :class="{ on: tab === 'codes' }" @click="switchTab('codes')">邀请码</button>
      <button :class="{ on: tab === 'batch' }" @click="switchTab('batch')">批量生成</button>
      <button :class="{ on: tab === 'batches' }" @click="switchTab('batches')">批次</button>
      <button :class="{ on: tab === 'redemptions' }" @click="switchTab('redemptions')">兑换记录</button>
    </div>

  <!-- codes tab -->
  <section v-if="tab === 'codes'">
    <template v-if="editing">
      <div class="form-head">
        <h2>{{ editing._new ? "新建邀请码" : "编辑" }}</h2>
        <div>
          <button class="btn btn-secondary btn-sm" @click="editing = null">取消</button>
          <button class="btn btn-sm" @click="saveCode">保存</button>
        </div>
      </div>
      <div class="fgrid">
        <label class="f">邀请码<input v-model="editing.code" /></label>
        <label class="f">备注<input v-model="editing.label" /></label>
        <label class="f">兑换模式
          <select v-model="editing.redemption_mode" @change="onModeChange">
            <option value="single_use">一次性（全平台 1 次）</option>
            <option value="multi_use">限量</option>
            <option value="unlimited">不限量</option>
          </select>
        </label>
        <label v-if="editing.redemption_mode === 'multi_use'" class="f">总次数上限<input type="number" v-model.number="editing.max_redemptions" min="1" /></label>
        <label class="f">权益时长
          <select v-model="editing.duration_preset">
            <option v-for="p in DURATION_PRESETS" :key="p.id" :value="p.id">{{ p.label }}</option>
          </select>
        </label>
        <label v-if="editing.duration_preset === 'custom'" class="f">自定义天数<input type="number" v-model.number="editing.duration_days" min="1" /></label>
        <label class="f">会员计划
          <select v-model="editing.plan_id">
            <option v-for="p in plans" :key="p.id" :value="p.id">{{ p.name_zh || p.name_en }} ({{ p.id }})</option>
          </select>
        </label>
        <label class="f">生效自<input type="datetime-local" v-model="editing.valid_from" /></label>
        <label class="f">失效于<input type="datetime-local" v-model="editing.valid_until" /></label>
        <label class="cond"><input type="checkbox" v-model="editing.one_per_account" /> 每账号终身仅可兑 1 次</label>
        <label class="cond"><input type="checkbox" v-model="editing.new_users_only" /> 仅新用户</label>
        <label class="cond"><input type="checkbox" v-model="editing.auto_deactivate_on_exhaust" :disabled="editing.redemption_mode === 'single_use'" /> 用尽后自动停用</label>
        <label class="cond"><input type="checkbox" v-model="editing.is_active" /> 启用</label>
      </div>
    </template>
    <template v-else>
      <div class="bar">
        <button class="btn" @click="newCode">+ 新建</button>
        <input v-model="search" class="search" placeholder="搜索码…" />
        <select v-model="filterBatch">
          <option value="">全部批次</option>
          <option v-for="b in batches" :key="b.id" :value="b.id">{{ b.label || b.id }}</option>
        </select>
      </div>
      <table class="data-table">
        <thead><tr><th>码</th><th>权益</th><th>模式</th><th>已兑/上限</th><th>状态</th><th></th></tr></thead>
        <tbody>
          <tr v-for="c in filteredCodes" :key="c.id">
            <td><code>{{ c.code }}</code> <span class="muted">{{ c.label }}</span></td>
            <td>{{ benefitLabel(c) }}</td>
            <td>{{ MODE_LABELS[c.redemption_mode] || c.redemption_mode }}</td>
            <td>{{ c.redeemed_count }}/{{ c.max_redemptions ?? "∞" }}</td>
            <td>{{ codeStatus(c) }}</td>
            <td>
              <button class="btn btn-secondary btn-sm" @click="editCode(c)">编辑</button>
              <button v-if="c.is_active" class="btn btn-secondary btn-sm" @click="deactivateCode(c)">停用</button>
            </td>
          </tr>
          <tr v-if="!filteredCodes.length"><td colspan="6" class="center muted">暂无</td></tr>
        </tbody>
      </table>
    </template>
  </section>

  <!-- batch generate -->
  <section v-else-if="tab === 'batch'">
    <h2>批量生成一次性卡密</h2>
    <div class="fgrid">
      <label class="f full">活动名称<input v-model="batchForm.label" placeholder="如：七月小红书福利" /></label>
      <label class="f">数量<input type="number" v-model.number="batchForm.count" min="1" max="500" /></label>
      <label class="f">权益
        <select v-model="batchForm.duration_preset">
          <option v-for="p in DURATION_PRESETS" :key="p.id" :value="p.id">{{ p.label }}</option>
        </select>
      </label>
      <label v-if="batchForm.duration_preset === 'custom'" class="f">天数<input type="number" v-model.number="batchForm.duration_days" min="1" /></label>
      <label class="f">会员计划
        <select v-model="batchForm.plan_id">
          <option v-for="p in plans" :key="p.id" :value="p.id">{{ p.name_zh || p.name_en }}</option>
        </select>
      </label>
      <label class="cond"><input type="checkbox" v-model="batchForm.one_per_account" /> 每账号终身仅 1 次</label>
      <label class="cond"><input type="checkbox" v-model="batchForm.new_users_only" /> 仅新用户</label>
    </div>
    <button class="btn" style="margin-top:14px" @click="generateBatch">生成并导出 CSV</button>
    <p class="hint">同一批次内每用户只能兑换 1 张码（batch 唯一约束）。</p>
  </section>

  <!-- batches list -->
  <section v-else-if="tab === 'batches'">
    <table class="data-table">
      <thead><tr><th>批次</th><th>权益</th><th>生成/兑换</th><th>时间</th></tr></thead>
      <tbody>
        <tr v-for="b in batches" :key="b.id">
          <td><strong>{{ b.label || b.id }}</strong><br /><code class="muted">{{ b.id }}</code></td>
          <td>{{ benefitLabel(b) }}</td>
          <td>{{ b.codes_redeemed || 0 }} / {{ b.codes_generated || 0 }}</td>
          <td class="muted">{{ (b.created_at || "").slice(0, 10) }}</td>
        </tr>
      </tbody>
    </table>
  </section>

  <!-- redemptions -->
  <section v-else>
    <table class="data-table">
      <thead><tr><th>时间</th><th>用户</th><th>码</th><th>批次</th><th>到期</th></tr></thead>
      <tbody>
        <tr v-for="r in redemptions" :key="r.id">
          <td>{{ (r.redeemed_at || "").slice(0, 19).replace("T", " ") }}</td>
          <td class="muted">{{ r.email }}</td>
          <td><code>{{ r.code_snapshot }}</code></td>
          <td class="muted">{{ r.batch_id || "—" }}</td>
          <td>{{ r.granted_expires_at ? r.granted_expires_at.slice(0, 10) : "终身" }}</td>
        </tr>
        <tr v-if="!redemptions.length"><td colspan="5" class="center muted">暂无兑换</td></tr>
      </tbody>
    </table>
  </section>

    <div class="toast" :class="{ on: toast }">{{ toast }}</div>
  </div>
</template>

<style scoped>
.ih h1 { margin: 0 0 6px; font-size: 20px; }
.hint { color: var(--muted); font-size: 13px; margin: 0 0 12px; }
.tabs { display: flex; gap: 4px; border-bottom: 1px solid var(--border); margin-bottom: 14px; flex-wrap: wrap; }
.tabs button { background: transparent; border: none; padding: 9px 14px; cursor: pointer; color: var(--muted); font-weight: 600; border-bottom: 2px solid transparent; }
.tabs button.on { color: var(--text); border-bottom-color: var(--accent); }
.bar { display: flex; gap: 10px; align-items: center; margin-bottom: 12px; flex-wrap: wrap; }
.bar .search { width: 180px; }
.data-table { width: 100%; border-collapse: collapse; font-size: 14px; }
.data-table th, .data-table td { text-align: left; padding: 8px 12px; border-bottom: 1px solid var(--border); vertical-align: top; }
.data-table th { color: var(--muted); font-size: 13px; }
.muted { color: var(--muted); font-size: 12px; }
.center { text-align: center; padding: 24px; }
.form-head { display: flex; justify-content: space-between; align-items: center; margin-bottom: 14px; }
.form-head h2 { margin: 0; font-size: 18px; }
.fgrid { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; max-width: 760px; }
.f { display: block; font-size: 12px; color: var(--muted); }
.f.full { grid-column: 1 / -1; }
.f input, .f select { margin-top: 4px; width: 100%; }
.cond { display: flex; align-items: center; gap: 6px; font-size: 14px; }
.toast { position: fixed; bottom: 26px; left: 50%; transform: translateX(-50%); background: var(--text); color: var(--bg); padding: 10px 18px; border-radius: 8px; font-size: 13px; opacity: 0; pointer-events: none; transition: opacity 0.2s; z-index: 1100; }
.toast.on { opacity: 1; }
</style>
