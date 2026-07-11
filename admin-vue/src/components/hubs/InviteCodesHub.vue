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
  single_use: "一次性",
  multi_use: "限量",
  unlimited: "不限量",
};

const MODE_HINTS = {
  single_use: "全平台仅可兑换 1 次，用尽后自动停用",
  multi_use: "可设置总兑换次数上限",
  unlimited: "不限总次数，但每位用户每码仅可兑 1 次",
};

const STATUS_META = {
  active: { text: "生效中", cls: "green" },
  scheduled: { text: "未开始", cls: "yellow" },
  expired: { text: "已过期", cls: "red" },
  exhausted: { text: "已用尽", cls: "gray" },
  disabled: { text: "已停用", cls: "gray" },
};

const STRATEGY_TEMPLATES = [
  {
    id: "single_card",
    label: "单次卡密",
    hint: "印卡、私信发码，全平台仅可兑 1 次",
    redemption_mode: "single_use",
    max_redemptions: 1,
    one_per_account: false,
    new_users_only: false,
    auto_deactivate_on_exhaust: true,
  },
  {
    id: "batch_one_per_user",
    label: "批次一人一码",
    hint: "同活动每用户只能领 1 张（batch 约束）",
    redemption_mode: "single_use",
    max_redemptions: 1,
    one_per_account: false,
    new_users_only: false,
    auto_deactivate_on_exhaust: true,
  },
  {
    id: "account_once",
    label: "账号终身一次",
    hint: "该用户成功兑换任意码后不可再兑",
    redemption_mode: "single_use",
    max_redemptions: 1,
    one_per_account: true,
    new_users_only: false,
    auto_deactivate_on_exhaust: true,
  },
  {
    id: "channel_unlimited",
    label: "渠道通码",
    hint: "如 WELCOME2026，不限总次数",
    redemption_mode: "unlimited",
    max_redemptions: null,
    one_per_account: false,
    new_users_only: false,
    auto_deactivate_on_exhaust: false,
  },
  {
    id: "limited_stock",
    label: "限量抢购",
    hint: "前 N 名可兑，用尽自动停用",
    redemption_mode: "multi_use",
    max_redemptions: 100,
    one_per_account: false,
    new_users_only: false,
    auto_deactivate_on_exhaust: true,
  },
];

function applyStrategyTemplate(target, templateId) {
  const t = STRATEGY_TEMPLATES.find((x) => x.id === templateId);
  if (!t || !target) return;
  target.redemption_mode = t.redemption_mode;
  target.max_redemptions = t.max_redemptions;
  target.one_per_account = t.one_per_account;
  target.new_users_only = t.new_users_only;
  if ("auto_deactivate_on_exhaust" in target) {
    target.auto_deactivate_on_exhaust = t.auto_deactivate_on_exhaust;
  }
}

function randomCode(len = 8) {
  const arr = new Uint32Array(len);
  crypto.getRandomValues(arr);
  return Array.from(arr, (n) => CHARSET[n % CHARSET.length]).join("");
}

function benefitLabel(row) {
  const p = DURATION_PRESETS.find((x) => x.id === row.duration_preset);
  if (row.duration_preset === "custom") return `${row.duration_days || "?"} 天`;
  return p?.label || row.duration_preset || "—";
}

function planName(id) {
  if (!id) return "—";
  const p = plans.value.find((x) => x.id === id);
  return p ? (p.name_zh || p.name_en || id) : id;
}

function codeStatus(row) {
  if (!row.is_active) return row.redeemed_count > 0 ? "exhausted" : "disabled";
  if (row.valid_until && new Date(row.valid_until) < new Date()) return "expired";
  if (row.valid_from && new Date(row.valid_from) > new Date()) return "scheduled";
  if (row.max_redemptions != null && row.redeemed_count >= row.max_redemptions) return "exhausted";
  return "active";
}

function fmtDateTime(iso) {
  if (!iso) return "—";
  const d = new Date(iso);
  if (Number.isNaN(d.getTime())) return "—";
  return d.toLocaleString("zh-CN", {
    year: "numeric", month: "2-digit", day: "2-digit",
    hour: "2-digit", minute: "2-digit",
  });
}

function toLocalInput(iso) {
  if (!iso) return "";
  const d = new Date(iso);
  if (Number.isNaN(d.getTime())) return "";
  const pad = (n) => String(n).padStart(2, "0");
  return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())}T${pad(d.getHours())}:${pad(d.getMinutes())}`;
}

function fromLocalInput(local) {
  if (!local) return null;
  const d = new Date(local);
  return Number.isNaN(d.getTime()) ? null : d.toISOString();
}

async function copyText(text) {
  try {
    await navigator.clipboard.writeText(text);
    showToast("已复制");
  } catch {
    showToast("复制失败");
  }
}

// ── data ──
const codes = ref([]);
const batches = ref([]);
const redemptions = ref([]);
const plans = ref([]);
const search = ref("");
const filterBatch = ref("");
const filterStatus = ref("");

async function loadPlans() {
  const { data } = await supabase
    .from("membership_plans")
    .select("id,name_zh,name_en")
    .eq("is_active", true)
    .order("display_order");
  plans.value = data || [];
  const first = plans.value[0]?.id;
  if (first) {
    if (!plans.value.some((p) => p.id === batchForm.value.plan_id)) {
      batchForm.value.plan_id = first;
    }
  }
}

async function loadCodes() {
  error.value = "";
  const { data, error: e } = await supabase
    .from("invite_codes")
    .select("*")
    .order("created_at", { ascending: false })
    .limit(500);
  if (e) error.value = e.message;
  codes.value = data || [];
}

async function loadBatches() {
  const { data } = await supabase
    .from("invite_code_batches")
    .select("*")
    .order("created_at", { ascending: false })
    .limit(100);
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

const stats = computed(() => {
  const rows = codes.value;
  const active = rows.filter((c) => codeStatus(c) === "active").length;
  const redeemed = rows.reduce((n, c) => n + (c.redeemed_count || 0), 0);
  return {
    total: rows.length,
    active,
    redeemed,
    batches: batches.value.length,
  };
});

const filteredCodes = computed(() => {
  let rows = codes.value;
  if (filterBatch.value) rows = rows.filter((c) => c.batch_id === filterBatch.value);
  if (filterStatus.value) rows = rows.filter((c) => codeStatus(c) === filterStatus.value);
  const q = search.value.trim().toUpperCase();
  if (q) {
    rows = rows.filter((c) =>
      (c.code || "").includes(q)
      || (c.label || "").toUpperCase().includes(q)
      || (c.batch_id || "").toUpperCase().includes(q)
    );
  }
  return rows;
});

const redemptionSearch = ref("");
const filteredRedemptions = computed(() => {
  const q = redemptionSearch.value.trim().toLowerCase();
  if (!q) return redemptions.value;
  return redemptions.value.filter((r) =>
    (r.email || "").toLowerCase().includes(q)
    || (r.code_snapshot || "").toLowerCase().includes(q)
    || (r.batch_id || "").toLowerCase().includes(q)
  );
});

// ── single edit ──
const editing = ref(null);
const editTemplate = ref("single_card");
const batchTemplate = ref("batch_one_per_user");

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
  note_internal: "",
};

const editingPreview = computed(() => {
  if (!editing.value) return "";
  const e = editing.value;
  const parts = [
    benefitLabel(e),
    planName(e.plan_id),
    MODE_LABELS[e.redemption_mode] || e.redemption_mode,
  ];
  if (e.one_per_account) parts.push("账号终身 1 次");
  if (e.new_users_only) parts.push("仅新用户");
  return parts.join(" · ");
});

function newCode() {
  const defaultPlan = plans.value[0]?.id || "annual";
  editTemplate.value = "single_card";
  editing.value = {
    ...BLANK,
    plan_id: defaultPlan,
    _new: true,
    code: randomCode(),
    _valid_from_local: "",
    _valid_until_local: "",
  };
  applyStrategyTemplate(editing.value, editTemplate.value);
}

const editingLocked = computed(() => editing.value && (editing.value.redeemed_count || 0) > 0);

function editCode(row) {
  editing.value = {
    ...row,
    _valid_from_local: toLocalInput(row.valid_from),
    _valid_until_local: toLocalInput(row.valid_until),
  };
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
  if (p.duration_preset === "custom" && !(p.duration_days > 0)) {
    return showToast("请填写自定义天数");
  }
  if (!p.id) p.id = `ic_${Date.now().toString(36)}`;
  p.code = p.code.trim().toUpperCase();

  const dup = codes.value.find((c) => c.code === p.code && c.id !== p.id);
  if (dup) return showToast("邀请码已存在");

  if (p.duration_preset === "lifetime" && p._new && !confirm("确认为终身会员邀请码？兑换后用户将永久解锁。")) {
    return;
  }
  const payload = {
    ...p,
    valid_from: fromLocalInput(p._valid_from_local),
    valid_until: fromLocalInput(p._valid_until_local),
    duration_days: p.duration_preset === "custom" ? p.duration_days : null,
    updated_at: new Date().toISOString(),
  };
  delete payload._new;
  delete payload._valid_from_local;
  delete payload._valid_until_local;

  const { error: e } = await supabase.from("invite_codes").upsert(payload);
  if (e) return showToast("失败：" + e.message);
  editing.value = null;
  await loadCodes();
  showToast("已保存");
}

async function setCodeActive(row, active) {
  const label = active ? "重新启用" : "停用";
  if (!confirm(`${label}邀请码 ${row.code}？`)) return;
  const { error: e } = await supabase
    .from("invite_codes")
    .update({ is_active: active, updated_at: new Date().toISOString() })
    .eq("id", row.id);
  if (e) return showToast("失败：" + e.message);
  await loadCodes();
  showToast(active ? "已启用" : "已停用");
}

function exportCodesCsv(rows, filename) {
  const header = "code,batch_id,label,benefit,plan,status,redeemed,max";
  const lines = rows.map((r) => [
    r.code,
    r.batch_id || "",
    (r.label || "").replace(/,/g, " "),
    benefitLabel(r),
    r.plan_id,
    codeStatus(r),
    r.redeemed_count,
    r.max_redemptions ?? "",
  ].join(","));
  const blob = new Blob([[header, ...lines].join("\n")], { type: "text/csv" });
  const a = document.createElement("a");
  a.href = URL.createObjectURL(blob);
  a.download = filename;
  a.click();
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

const batchPreview = computed(() => {
  const f = batchForm.value;
  return `${f.count} 个码 · ${benefitLabel(f)} · ${planName(f.plan_id)} · ${MODE_LABELS[f.redemption_mode]}`;
});

function onBatchModeChange() {
  if (batchForm.value.redemption_mode === "single_use") {
    batchForm.value.max_redemptions = 1;
  } else if (batchForm.value.redemption_mode === "unlimited") {
    batchForm.value.max_redemptions = null;
  } else if (!batchForm.value.max_redemptions) {
    batchForm.value.max_redemptions = 10;
  }
}

async function generateBatch() {
  const f = batchForm.value;
  const n = Math.min(Math.max(Number(f.count) || 1, 1), 500);
  if (f.duration_preset === "custom" && !(f.duration_days > 0)) {
    return showToast("请填写自定义天数");
  }
  if (!confirm(`生成 ${n} 个邀请码？\n${batchPreview.value}`)) return;

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

  const mode = f.redemption_mode;
  const maxRed = mode === "single_use" ? 1 : mode === "unlimited" ? null : f.max_redemptions;
  const rows = [];
  const seen = new Set(codes.value.map((c) => c.code));
  for (let i = 0; i < n; i++) {
    let code;
    let tries = 0;
    do {
      code = randomCode(8);
      tries += 1;
    } while (seen.has(code) && tries < 50);
    if (seen.has(code)) return showToast("生成唯一码失败，请重试");
    seen.add(code);
    rows.push({
      id: `ic_${batchId}_${i}`,
      code,
      label: f.label || batchId,
      batch_id: batchId,
      plan_id: f.plan_id,
      duration_preset: f.duration_preset,
      duration_days: f.duration_preset === "custom" ? f.duration_days : null,
      redemption_mode: mode,
      max_redemptions: maxRed,
      auto_deactivate_on_exhaust: mode !== "unlimited",
      one_per_account: f.one_per_account,
      new_users_only: f.new_users_only,
      is_active: true,
    });
  }

  const { error: ce } = await supabase.from("invite_codes").insert(rows);
  if (ce) return showToast("写入码失败：" + ce.message);

  exportCodesCsv(rows, `invite_codes_${batchId}.csv`);

  await loadCodes();
  await loadBatches();
  showToast(`已生成 ${n} 个码`);
}

async function deactivateBatch(batch) {
  if (!confirm(`停用批次「${batch.label || batch.id}」下所有仍生效的邀请码？`)) return;
  const { error: e } = await supabase
    .from("invite_codes")
    .update({ is_active: false, updated_at: new Date().toISOString() })
    .eq("batch_id", batch.id)
    .eq("is_active", true);
  if (e) return showToast("失败：" + e.message);
  await loadCodes();
  showToast("批次已停用");
}

function onEditTemplateChange() {
  if (editing.value && !editingLocked.value) {
    applyStrategyTemplate(editing.value, editTemplate.value);
  }
}

function onBatchTemplateChange() {
  applyStrategyTemplate(batchForm.value, batchTemplate.value);
}

function openBatchCodes(batchId) {
  filterBatch.value = batchId;
  filterStatus.value = "";
  tab.value = "codes";
}

async function exportBatchCsv(batch) {
  const { data } = await supabase
    .from("invite_codes")
    .select("*")
    .eq("batch_id", batch.id)
    .order("code");
  if (!data?.length) return showToast("该批次暂无码");
  exportCodesCsv(data, `batch_${batch.id}.csv`);
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
    <header class="page-head">
      <div>
        <h1>🎟 邀请码</h1>
        <p class="hint">
          兑换后写入用户 <code>membership_override=grant</code>，与后台手动赠送会员相同。
          App 入口：Profile / 付费墙页脚 · 深链 <code>yoloapp://redeem?code=</code>
        </p>
      </div>
    </header>

    <div class="stats">
      <div class="stat"><div class="num">{{ stats.total }}</div><div class="lab">邀请码总数</div></div>
      <div class="stat green"><div class="num">{{ stats.active }}</div><div class="lab">生效中</div></div>
      <div class="stat blue"><div class="num">{{ stats.redeemed }}</div><div class="lab">累计兑换</div></div>
      <div class="stat"><div class="num">{{ stats.batches }}</div><div class="lab">批次</div></div>
    </div>

    <div v-if="error" class="status-bar error">{{ error }}</div>

    <div class="tabs">
      <button :class="{ on: tab === 'codes' }" @click="switchTab('codes')">邀请码</button>
      <button :class="{ on: tab === 'batch' }" @click="switchTab('batch')">批量生成</button>
      <button :class="{ on: tab === 'batches' }" @click="switchTab('batches')">批次</button>
      <button :class="{ on: tab === 'redemptions' }" @click="switchTab('redemptions')">兑换记录</button>
    </div>

    <!-- codes tab -->
    <section v-if="tab === 'codes'" class="panel">
      <template v-if="editing">
        <div class="card form-card">
          <div class="form-head">
            <div>
              <h2>{{ editing._new ? "新建邀请码" : "编辑邀请码" }}</h2>
              <p v-if="editingPreview" class="preview-line">{{ editingPreview }}</p>
            </div>
            <div class="form-head-actions">
              <button class="btn btn-secondary btn-sm" @click="editing = null">取消</button>
              <button class="btn btn-sm" @click="saveCode">保存</button>
            </div>
          </div>

          <div v-if="editingLocked" class="warn-banner">
            该码已有兑换记录，权益与兑换规则不可修改；可调整备注、有效期与启用状态。
          </div>

          <div class="form-section">
            <h3>策略模板</h3>
            <div class="fgrid">
              <label class="f full">
                <span>快速套用</span>
                <select v-model="editTemplate" :disabled="editingLocked" @change="onEditTemplateChange">
                  <option v-for="t in STRATEGY_TEMPLATES" :key="t.id" :value="t.id">{{ t.label }} — {{ t.hint }}</option>
                </select>
              </label>
            </div>
          </div>

          <div class="form-section">
            <h3>基本信息</h3>
            <div class="fgrid">
              <label class="f">
                <span>邀请码</span>
                <div class="input-row">
                  <input v-model="editing.code" class="mono" placeholder="8 位字母数字" :disabled="editingLocked" />
                  <button type="button" class="btn btn-secondary btn-sm" title="重新生成" :disabled="editingLocked" @click="editing.code = randomCode()">↻</button>
                  <button type="button" class="btn btn-secondary btn-sm" title="复制" @click="copyText(editing.code)">复制</button>
                </div>
              </label>
              <label class="f">
                <span>备注 / 活动名</span>
                <input v-model="editing.label" placeholder="如：七月小红书福利" />
              </label>
              <label class="f full">
                <span>内部备注 <span class="muted">（仅后台可见）</span></span>
                <input v-model="editing.note_internal" placeholder="运营备注、渠道来源等" />
              </label>
            </div>
          </div>

          <div class="form-section">
            <h3>权益设置</h3>
            <div class="fgrid">
              <label class="f">
                <span>权益时长</span>
                <select v-model="editing.duration_preset" :disabled="editingLocked">
                  <option v-for="p in DURATION_PRESETS" :key="p.id" :value="p.id">{{ p.label }}</option>
                </select>
              </label>
              <label v-if="editing.duration_preset === 'custom'" class="f">
                <span>自定义天数</span>
                <input type="number" v-model.number="editing.duration_days" min="1" :disabled="editingLocked" />
              </label>
              <label class="f" :class="{ full: editing.duration_preset !== 'custom' }">
                <span>会员计划</span>
                <select v-model="editing.plan_id" :disabled="editingLocked">
                  <option v-for="p in plans" :key="p.id" :value="p.id">
                    {{ p.name_zh || p.name_en }} ({{ p.id }})
                  </option>
                </select>
              </label>
            </div>
          </div>

          <div class="form-section">
            <h3>兑换规则</h3>
            <div class="fgrid">
              <label class="f">
                <span>兑换模式</span>
                <select v-model="editing.redemption_mode" :disabled="editingLocked" @change="onModeChange">
                  <option value="single_use">一次性（全平台 1 次）</option>
                  <option value="multi_use">限量（可设总次数）</option>
                  <option value="unlimited">不限量（每人每码 1 次）</option>
                </select>
                <span class="field-hint">{{ MODE_HINTS[editing.redemption_mode] }}</span>
              </label>
              <label v-if="editing.redemption_mode === 'multi_use'" class="f">
                <span>总兑换次数上限</span>
                <input type="number" v-model.number="editing.max_redemptions" min="1" :disabled="editingLocked" />
              </label>
            </div>
          </div>

          <div class="form-section">
            <h3>有效期 <span class="muted small">留空表示不限制</span></h3>
            <div class="fgrid">
              <label class="f">
                <span>生效自</span>
                <input type="datetime-local" v-model="editing._valid_from_local" />
              </label>
              <label class="f">
                <span>失效于</span>
                <input type="datetime-local" v-model="editing._valid_until_local" />
              </label>
            </div>
          </div>

          <div class="form-section">
            <h3>限制与状态</h3>
            <div class="opts-grid">
              <label class="opt">
                <input type="checkbox" v-model="editing.one_per_account" />
                <span class="opt-text">
                  <strong>每账号终身仅可兑 1 次</strong>
                  <small>该用户成功兑换任意邀请码后，不可再兑其他码</small>
                </span>
              </label>
              <label class="opt">
                <input type="checkbox" v-model="editing.new_users_only" />
                <span class="opt-text">
                  <strong>仅新用户</strong>
                  <small>无有效会员且无历史兑换记录才可兑</small>
                </span>
              </label>
              <label class="opt">
                <input
                  type="checkbox"
                  v-model="editing.auto_deactivate_on_exhaust"
                  :disabled="editing.redemption_mode === 'single_use'"
                />
                <span class="opt-text">
                  <strong>用尽后自动停用</strong>
                  <small>达到兑换上限后关闭该码</small>
                </span>
              </label>
              <label class="opt">
                <input type="checkbox" v-model="editing.is_active" />
                <span class="opt-text">
                  <strong>启用</strong>
                  <small>关闭后用户无法兑换</small>
                </span>
              </label>
            </div>
          </div>

          <div class="form-foot">
            <button class="btn btn-secondary" @click="editing = null">取消</button>
            <button class="btn" @click="saveCode">保存邀请码</button>
          </div>
        </div>
      </template>

      <template v-else>
        <div class="toolbar">
          <button class="btn" @click="newCode">+ 新建邀请码</button>
          <input v-model="search" class="search" type="search" placeholder="搜索码 / 备注 / 批次…" />
          <select v-model="filterBatch">
            <option value="">全部批次</option>
            <option v-for="b in batches" :key="b.id" :value="b.id">{{ b.label || b.id }}</option>
          </select>
          <select v-model="filterStatus">
            <option value="">全部状态</option>
            <option v-for="(meta, key) in STATUS_META" :key="key" :value="key">{{ meta.text }}</option>
          </select>
          <span class="muted count">{{ filteredCodes.length }} 条</span>
          <button
            v-if="filterBatch || filterStatus || search"
            class="btn btn-secondary btn-sm"
            @click="filterBatch = ''; filterStatus = ''; search = ''"
          >清除筛选</button>
        </div>

        <div class="table-wrap">
          <table class="data-table">
            <thead>
              <tr>
                <th>邀请码</th>
                <th>权益</th>
                <th>计划</th>
                <th>模式</th>
                <th>已兑 / 上限</th>
                <th>首次兑换</th>
                <th>状态</th>
                <th class="col-actions">操作</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="c in filteredCodes" :key="c.id">
                <td>
                  <div class="code-cell">
                    <code>{{ c.code }}</code>
                    <button class="icon-btn" title="复制" @click="copyText(c.code)">⎘</button>
                  </div>
                  <div v-if="c.label" class="muted row-sub">{{ c.label }}</div>
                  <div v-if="c.batch_id" class="muted row-sub">
                    <button class="link-btn" @click="filterBatch = c.batch_id">{{ c.batch_id }}</button>
                  </div>
                </td>
                <td>{{ benefitLabel(c) }}</td>
                <td>{{ planName(c.plan_id) }}</td>
                <td>
                  <span class="badge gray">{{ MODE_LABELS[c.redemption_mode] || c.redemption_mode }}</span>
                </td>
                <td>{{ c.redeemed_count }} / {{ c.max_redemptions ?? "∞" }}</td>
                <td class="muted">{{ c.first_redeemed_at ? fmtDateTime(c.first_redeemed_at) : "—" }}</td>
                <td>
                  <span class="badge" :class="STATUS_META[codeStatus(c)]?.cls">
                    {{ STATUS_META[codeStatus(c)]?.text || codeStatus(c) }}
                  </span>
                </td>
                <td class="col-actions">
                  <button class="btn btn-secondary btn-sm" @click="editCode(c)">编辑</button>
                  <button
                    v-if="c.is_active"
                    class="btn btn-danger btn-sm"
                    @click="setCodeActive(c, false)"
                  >停用</button>
                  <button
                    v-else
                    class="btn btn-secondary btn-sm"
                    @click="setCodeActive(c, true)"
                  >启用</button>
                </td>
              </tr>
              <tr v-if="!filteredCodes.length">
                <td colspan="8" class="center muted">暂无邀请码</td>
              </tr>
            </tbody>
          </table>
        </div>
      </template>
    </section>

    <!-- batch generate -->
    <section v-else-if="tab === 'batch'" class="panel">
      <div class="card form-card">
        <h2>批量生成邀请码</h2>
        <p class="hint block-hint">适合活动发码：一次生成多张一次性或限量码，自动创建批次并导出 CSV。</p>

        <div class="form-section">
          <h3>策略模板</h3>
          <label class="f full">
            <span>快速套用</span>
            <select v-model="batchTemplate" @change="onBatchTemplateChange">
              <option v-for="t in STRATEGY_TEMPLATES" :key="t.id" :value="t.id">{{ t.label }} — {{ t.hint }}</option>
            </select>
          </label>
        </div>

        <div class="form-section">
          <div class="fgrid">
            <label class="f full">
              <span>活动名称</span>
              <input v-model="batchForm.label" placeholder="如：七月小红书福利" />
            </label>
            <label class="f">
              <span>生成数量</span>
              <input type="number" v-model.number="batchForm.count" min="1" max="500" />
            </label>
            <label class="f">
              <span>兑换模式</span>
              <select v-model="batchForm.redemption_mode" @change="onBatchModeChange">
                <option value="single_use">一次性</option>
                <option value="multi_use">限量</option>
                <option value="unlimited">不限量</option>
              </select>
            </label>
            <label v-if="batchForm.redemption_mode === 'multi_use'" class="f">
              <span>每码总次数</span>
              <input type="number" v-model.number="batchForm.max_redemptions" min="1" />
            </label>
            <label class="f">
              <span>权益时长</span>
              <select v-model="batchForm.duration_preset">
                <option v-for="p in DURATION_PRESETS" :key="p.id" :value="p.id">{{ p.label }}</option>
              </select>
            </label>
            <label v-if="batchForm.duration_preset === 'custom'" class="f">
              <span>自定义天数</span>
              <input type="number" v-model.number="batchForm.duration_days" min="1" />
            </label>
            <label class="f" :class="{ full: batchForm.duration_preset === 'custom' && batchForm.redemption_mode !== 'multi_use' }">
              <span>会员计划</span>
              <select v-model="batchForm.plan_id">
                <option v-for="p in plans" :key="p.id" :value="p.id">{{ p.name_zh || p.name_en }}</option>
              </select>
            </label>
          </div>
        </div>

        <div class="form-section">
          <h3>限制选项</h3>
          <div class="opts-grid">
            <label class="opt">
              <input type="checkbox" v-model="batchForm.one_per_account" />
              <span class="opt-text">
                <strong>每账号终身仅可兑 1 次</strong>
                <small>跨所有邀请码生效</small>
              </span>
            </label>
            <label class="opt">
              <input type="checkbox" v-model="batchForm.new_users_only" />
              <span class="opt-text">
                <strong>仅新用户</strong>
                <small>无会员且无兑换记录</small>
              </span>
            </label>
          </div>
        </div>

        <div class="batch-preview">
          <span class="muted">预览：</span>{{ batchPreview }}
        </div>

        <div class="form-foot">
          <button class="btn" @click="generateBatch">生成并导出 CSV</button>
        </div>
        <p class="hint foot-hint">同一批次内每用户只能兑换 1 张码（batch 唯一约束）。</p>
      </div>
    </section>

    <!-- batches list -->
    <section v-else-if="tab === 'batches'" class="panel">
      <div class="table-wrap">
        <table class="data-table">
          <thead>
            <tr>
              <th>批次</th>
              <th>权益</th>
              <th>计划</th>
              <th>已兑 / 生成</th>
              <th>创建时间</th>
              <th class="col-actions">操作</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="b in batches" :key="b.id">
              <td>
                <strong>{{ b.label || b.id }}</strong>
                <div class="muted row-sub"><code>{{ b.id }}</code></div>
              </td>
              <td>{{ benefitLabel(b) }}</td>
              <td>{{ planName(b.plan_id) }}</td>
              <td>{{ b.codes_redeemed || 0 }} / {{ b.codes_generated || 0 }}</td>
              <td class="muted">{{ fmtDateTime(b.created_at) }}</td>
              <td class="col-actions">
                <button class="btn btn-secondary btn-sm" @click="openBatchCodes(b.id)">查看码</button>
                <button class="btn btn-secondary btn-sm" @click="exportBatchCsv(b)">导出</button>
                <button class="btn btn-danger btn-sm" @click="deactivateBatch(b)">停用批次</button>
              </td>
            </tr>
            <tr v-if="!batches.length">
              <td colspan="6" class="center muted">暂无批次</td>
            </tr>
          </tbody>
        </table>
      </div>
    </section>

    <!-- redemptions -->
    <section v-else class="panel">
      <div class="toolbar">
        <input v-model="redemptionSearch" class="search" type="search" placeholder="搜索用户邮箱 / 邀请码 / 批次…" />
        <span class="muted count">{{ filteredRedemptions.length }} 条</span>
        <button class="btn btn-secondary btn-sm" @click="loadRedemptions">刷新</button>
      </div>
      <div class="table-wrap">
        <table class="data-table">
          <thead>
            <tr>
              <th>兑换时间</th>
              <th>用户</th>
              <th>邀请码</th>
              <th>批次</th>
              <th>计划</th>
              <th>权益到期</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="r in filteredRedemptions" :key="r.id">
              <td>{{ fmtDateTime(r.redeemed_at) }}</td>
              <td class="muted">{{ r.email }}</td>
              <td><code>{{ r.code_snapshot }}</code></td>
              <td>
                <button v-if="r.batch_id" class="link-btn muted" @click="openBatchCodes(r.batch_id)">{{ r.batch_id }}</button>
                <span v-else class="muted">—</span>
              </td>
              <td>{{ planName(r.granted_plan_id) }}</td>
              <td>{{ r.granted_expires_at ? fmtDateTime(r.granted_expires_at) : "终身" }}</td>
            </tr>
            <tr v-if="!filteredRedemptions.length">
              <td colspan="6" class="center muted">暂无兑换记录</td>
            </tr>
          </tbody>
        </table>
      </div>
    </section>

    <div class="toast" :class="{ on: toast }">{{ toast }}</div>
  </div>
</template>

<style scoped>
.ih { max-width: 1080px; }
.page-head h1 { margin: 0 0 6px; font-size: 20px; }
.hint { color: var(--muted); font-size: 13px; margin: 0; line-height: 1.5; }
.hint code { font-size: 12px; }

.stats {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 10px;
  margin: 16px 0;
}
.stat {
  background: var(--surface);
  border: 1px solid var(--border);
  border-radius: var(--radius);
  padding: 12px 14px;
  text-align: center;
}
.stat .num { font-size: 22px; font-weight: 700; line-height: 1.2; }
.stat .lab { font-size: 12px; color: var(--muted); margin-top: 4px; }
.stat.green .num { color: #5cb85c; }
.stat.blue .num { color: #5bc0de; }

.tabs {
  display: flex;
  gap: 4px;
  border-bottom: 1px solid var(--border);
  margin-bottom: 16px;
  flex-wrap: wrap;
}
.tabs button {
  background: transparent;
  border: none;
  padding: 9px 14px;
  cursor: pointer;
  color: var(--muted);
  font-weight: 600;
  border-bottom: 2px solid transparent;
  margin-bottom: -1px;
}
.tabs button.on { color: var(--text); border-bottom-color: var(--accent); }

.panel { margin-bottom: 24px; }
.card {
  background: var(--surface);
  border: 1px solid var(--border);
  border-radius: var(--radius);
  padding: 18px 20px;
}
.form-card h2 { margin: 0 0 8px; font-size: 18px; }
.block-hint { margin-bottom: 16px; }
.foot-hint { margin-top: 12px; }

.form-head {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  gap: 16px;
  margin-bottom: 20px;
  padding-bottom: 14px;
  border-bottom: 1px solid var(--border);
}
.form-head h2 { margin: 0; font-size: 18px; }
.preview-line { margin: 6px 0 0; font-size: 13px; color: var(--accent); }
.form-head-actions { display: flex; gap: 8px; flex-shrink: 0; }

.warn-banner {
  padding: 10px 12px;
  margin-bottom: 14px;
  border-radius: var(--radius);
  background: rgba(240, 173, 78, 0.12);
  border: 1px solid rgba(240, 173, 78, 0.35);
  font-size: 13px;
  color: #f0ad4e;
}

.form-section {
  margin-bottom: 20px;
  padding-bottom: 18px;
  border-bottom: 1px solid var(--border);
}
.form-section:last-of-type { border-bottom: none; padding-bottom: 0; }
.form-section h3 {
  margin: 0 0 12px;
  font-size: 13px;
  font-weight: 700;
  color: var(--muted);
  text-transform: uppercase;
  letter-spacing: 0.04em;
}
.small { font-size: 12px; font-weight: 400; }

.fgrid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 14px 16px;
}
.f { display: flex; flex-direction: column; gap: 6px; }
.f span { font-size: 12px; color: var(--muted); font-weight: 600; }
.f.full { grid-column: 1 / -1; }
.f input, .f select { margin: 0; }
.field-hint { font-size: 12px; color: var(--muted); line-height: 1.4; }

.input-row { display: flex; gap: 6px; align-items: center; }
.input-row input { flex: 1; }
.input-row .btn { flex-shrink: 0; }
.mono { font-family: ui-monospace, SFMono-Regular, Menlo, monospace; letter-spacing: 0.06em; }

.opts-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 10px;
}
.opt {
  display: flex;
  align-items: flex-start;
  gap: 10px;
  padding: 12px 14px;
  background: var(--surface2);
  border: 1px solid var(--border);
  border-radius: var(--radius);
  cursor: pointer;
  margin: 0;
}
.opt input { width: auto; margin-top: 2px; flex-shrink: 0; }
.opt-text { display: flex; flex-direction: column; gap: 2px; }
.opt-text strong { font-size: 14px; font-weight: 600; color: var(--text); }
.opt-text small { font-size: 12px; color: var(--muted); line-height: 1.35; }

.form-foot {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  margin-top: 20px;
  padding-top: 16px;
  border-top: 1px solid var(--border);
}

.toolbar {
  display: flex;
  gap: 10px;
  align-items: center;
  margin-bottom: 12px;
  flex-wrap: wrap;
}
.toolbar .search { width: 220px; min-width: 160px; }
.toolbar select { width: auto; min-width: 130px; }
.count { font-size: 13px; margin-left: auto; }

.table-wrap {
  overflow-x: auto;
  border: 1px solid var(--border);
  border-radius: var(--radius);
  background: var(--surface);
}
.data-table { width: 100%; border-collapse: collapse; font-size: 14px; }
.data-table th, .data-table td {
  text-align: left;
  padding: 10px 12px;
  border-bottom: 1px solid var(--border);
  vertical-align: top;
}
.data-table th {
  color: var(--muted);
  font-size: 12px;
  font-weight: 700;
  background: var(--surface2);
}
.data-table tr:last-child td { border-bottom: none; }
.col-actions { white-space: nowrap; width: 1%; }
.data-table .btn { margin-right: 4px; margin-bottom: 2px; }

.code-cell { display: flex; align-items: center; gap: 6px; }
.code-cell code { font-size: 13px; font-weight: 600; }
.icon-btn {
  border: none;
  background: transparent;
  color: var(--muted);
  cursor: pointer;
  padding: 2px 4px;
  font-size: 14px;
  border-radius: 4px;
}
.icon-btn:hover { color: var(--accent); background: var(--surface2); }
.link-btn {
  border: none;
  background: none;
  color: var(--accent);
  cursor: pointer;
  font-size: 12px;
  padding: 0;
  text-decoration: underline;
}
.row-sub { margin-top: 4px; font-size: 12px; }

.badge {
  display: inline-block;
  padding: 2px 8px;
  border-radius: 999px;
  font-size: 12px;
  font-weight: 600;
  background: var(--surface2);
  color: var(--muted);
}
.badge.green { background: rgba(92, 184, 92, 0.15); color: #5cb85c; }
.badge.yellow { background: rgba(240, 173, 78, 0.15); color: #f0ad4e; }
.badge.red { background: rgba(217, 83, 79, 0.15); color: #d9534f; }
.badge.blue { background: rgba(91, 192, 222, 0.15); color: #5bc0de; }
.badge.gray { background: var(--surface2); color: var(--muted); }

.batch-preview {
  padding: 12px 14px;
  background: var(--surface2);
  border-radius: var(--radius);
  font-size: 14px;
  margin-bottom: 4px;
}

.muted { color: var(--muted); }
.center { text-align: center; padding: 28px; }

.toast {
  position: fixed;
  bottom: 26px;
  left: 50%;
  transform: translateX(-50%);
  background: var(--text);
  color: var(--bg);
  padding: 10px 18px;
  border-radius: 8px;
  font-size: 13px;
  opacity: 0;
  pointer-events: none;
  transition: opacity 0.2s;
  z-index: 1100;
}
.toast.on { opacity: 1; }

@media (max-width: 720px) {
  .stats { grid-template-columns: repeat(2, 1fr); }
  .fgrid, .opts-grid { grid-template-columns: 1fr; }
  .form-head { flex-direction: column; }
  .count { margin-left: 0; }
}
</style>
