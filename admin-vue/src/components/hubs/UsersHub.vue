<script setup>
import { ref, computed, onMounted } from "vue";
import { supabase } from "@/lib/supabase";
import { useRefCache } from "@/stores/refCache";
import MultiCheck from "@/components/fields/MultiCheck.vue";

const refCache = useRefCache();

const profiles = ref([]);
const plans = ref([]); // active plans for selectors
const search = ref("");
const statusFilter = ref("");
const error = ref("");
const toast = ref("");
function showToast(m) { toast.value = m; setTimeout(() => (toast.value = ""), 1800); }

const PROFILE_COLS =
  "id,email,display_name,avatar_url,avatar_status,country_code," +
  "has_completed_onboarding,departure_date,purchased_attraction_ids," +
  "subscription_plan_id,subscription_expires_at,rc_customer_id," +
  "membership_override,membership_override_expires_at,membership_override_note," +
  "active_itinerary_id,created_at,updated_at";

const EVENT_LABELS = {
  INITIAL_PURCHASE: "首次购买", RENEWAL: "续费", REFUND: "退款",
  CANCELLATION: "取消", EXPIRATION: "到期", NON_RENEWING_PURCHASE: "单次购买",
};

async function loadList() {
  error.value = "";
  const [pr, pl] = await Promise.all([
    supabase.from("profiles").select(PROFILE_COLS).order("updated_at", { ascending: false }),
    supabase.from("membership_plans").select("id,name_zh,name_en,plan_type,access_flags,price_label,is_active").order("display_order"),
  ]);
  if (pr.error) error.value = pr.error.message;
  profiles.value = pr.data || [];
  plans.value = (pl.data || []).filter((p) => p.is_active);
}

// ── helpers ──
function planName(id) { const p = plans.value.find((x) => x.id === id); return p ? (p.name_zh || p.name_en) : (id || "—"); }
// RevenueCat / 订阅本身的有效性（不含后台覆盖）
function subActive(p) {
  if (!p.subscription_plan_id) return false;
  if (!p.subscription_expires_at) return true;
  return new Date(p.subscription_expires_at) > new Date();
}
// 实际生效的会员状态：后台 override 优先，否则看订阅。与 App 判定一致。
function isActiveMember(p) {
  if (p.membership_override === "ban") return false;
  if (p.membership_override === "grant") {
    if (!p.membership_override_expires_at) return true;
    return new Date(p.membership_override_expires_at) > new Date();
  }
  return subActive(p);
}
function daysUntil(d) { return d ? Math.ceil((new Date(d).getTime() - Date.now()) / 86400000) : null; }
function fmtDate(d) { return d ? new Date(d).toLocaleDateString("zh-CN") : "—"; }
function fmtDateTime(d) { return d ? new Date(d).toLocaleString("zh-CN") : "—"; }

const stats = computed(() => {
  const now = new Date();
  const r = profiles.value;
  return {
    total: r.length,
    members: r.filter(isActiveMember).length,
    expired: r.filter((p) => p.subscription_plan_id && p.subscription_expires_at && new Date(p.subscription_expires_at) <= now).length,
    single: r.filter((p) => (p.purchased_attraction_ids || []).length > 0).length,
  };
});

const filtered = computed(() => {
  let list = profiles.value;
  const now = new Date();
  const q = search.value.trim().toLowerCase();
  if (q) list = list.filter((p) => [p.email, p.display_name, p.id, p.country_code].filter(Boolean).join(" ").toLowerCase().includes(q));
  const f = statusFilter.value;
  if (f === "active_member") list = list.filter(isActiveMember);
  else if (f === "expired") list = list.filter((p) => p.subscription_plan_id && p.subscription_expires_at && new Date(p.subscription_expires_at) <= now);
  else if (f === "purchased") list = list.filter((p) => (p.purchased_attraction_ids || []).length > 0);
  else if (f === "onboarded") list = list.filter((p) => p.has_completed_onboarding);
  return list;
});

const attractionOptions = computed(() => refCache.attractions.map((a) => ({ value: a.id, label: a.chinese_name || a.name })));

const AVATAR_STATUS = {
  pending: { cls: "yellow", label: "待审核" },
  approved: { cls: "green", label: "已通过" },
  rejected: { cls: "red", label: "已拒绝" },
};

// ── detail ──
const detail = ref(null); // full profile row
const detailTxns = ref([]);
const detailRefunds = ref([]);
const savingDetail = ref(false);
const giftPlan = ref("");
const giftDays = ref("365");

const subPlans = computed(() => plans.value.filter((p) => p.plan_type === "subscription"));
const detailActive = computed(() => (detail.value ? isActiveMember(detail.value) : false));
const detailDaysLeft = computed(() => {
  if (!detail.value) return null;
  const exp = detail.value.membership_override === "grant"
    ? detail.value.membership_override_expires_at
    : detail.value.subscription_expires_at;
  return daysUntil(exp);
});
const detailStatusBadge = computed(() => {
  if (!detail.value) return { cls: "gray", text: "—" };
  const d = detail.value;
  if (d.membership_override === "ban") return { cls: "red", text: "● 已封禁" };
  if (d.membership_override === "grant") {
    return detailActive.value
      ? { cls: "green", text: "● 强制会员（赠送）" }
      : { cls: "red", text: "● 赠送已过期" };
  }
  if (detailActive.value) return { cls: "green", text: "● 有效会员（App Store）" };
  if (d.subscription_plan_id) return { cls: "red", text: "● 订阅已过期" };
  return { cls: "gray", text: "○ 免费用户" };
});
/** 后台订阅已失效但未设 ban —— App 仍可能因 RevenueCat 显示会员 */
const needsBanWarning = computed(() => {
  if (!detail.value) return false;
  const d = detail.value;
  return d.membership_override !== "ban"
    && d.membership_override !== "grant"
    && !isActiveMember(d)
    && (!!d.rc_customer_id || !!d.subscription_plan_id);
});

const expiresLocal = computed({
  get() { const v = detail.value?.subscription_expires_at; return v ? new Date(v).toISOString().slice(0, 16) : ""; },
  set(v) { if (detail.value) detail.value.subscription_expires_at = v ? new Date(v).toISOString() : null; },
});

async function openDetail(p) {
  error.value = "";
  await refCache.load();
  const { data, error: e } = await supabase.from("profiles").select("*").eq("id", p.id).single();
  if (e) { showToast("加载失败：" + e.message); return; }
  data.purchased_attraction_ids = data.purchased_attraction_ids || [];
  detail.value = data;
  giftPlan.value = ""; giftDays.value = "365";
  const [tx, rf] = await Promise.all([
    supabase.from("user_iap_transactions").select("id,event_type,product_id,price_usd,purchased_at").eq("user_id", p.id).order("purchased_at", { ascending: false }).limit(20),
    supabase.from("user_refund_requests").select("id,reason,status,created_at").eq("user_id", p.id).order("created_at", { ascending: false }),
  ]);
  detailTxns.value = tx.data || [];
  detailRefunds.value = rf.data || [];
}
function closeDetail() { detail.value = null; }

async function applyMemberPatch(patch) {
  const { error: e } = await supabase.from("profiles").update({ ...patch, updated_at: new Date().toISOString() }).eq("id", detail.value.id);
  if (e) { showToast("失败：" + e.message); return; }
  Object.assign(detail.value, patch);
  showToast("会员状态已更新");
  await loadList();
}
function giftApply() {
  if (!giftPlan.value) return showToast("请先选择订阅计划");
  const days = parseInt(giftDays.value || "0", 10);
  const expires = days > 0 ? new Date(Date.now() + days * 86400000).toISOString() : null;
  if (!confirm(`设为「${planName(giftPlan.value)}」会员，有效期：${days > 0 ? days + " 天" : "永久"}？\nApp 端将强制开通（优先于 App Store 订阅）。`)) return;
  applyMemberPatch({
    membership_override: "grant",
    membership_override_expires_at: expires,
    subscription_plan_id: giftPlan.value,
    subscription_expires_at: expires,
    membership_override_note: detail.value.membership_override_note?.trim() || null,
  });
}
function extendDays(days) {
  if (!detail.value.subscription_plan_id && detail.value.membership_override !== "grant") {
    return showToast("该用户暂无订阅计划，请先赠送/设置会员");
  }
  const cur = detail.value.membership_override === "grant"
    ? detail.value.membership_override_expires_at
    : detail.value.subscription_expires_at;
  const base = cur && new Date(cur) > new Date() ? new Date(cur) : new Date();
  const expires = new Date(base.getTime() + days * 86400000).toISOString();
  const planId = detail.value.subscription_plan_id || giftPlan.value || subPlans.value[0]?.id || "annual";
  applyMemberPatch({
    subscription_plan_id: planId,
    subscription_expires_at: expires,
    membership_override: "grant",
    membership_override_expires_at: expires,
  });
}
function cancelSub() {
  if (!confirm("确认取消该用户会员？\n将封禁 App 内全部付费内容（即使 App Store 仍有有效订阅）。")) return;
  applyMemberPatch({
    subscription_plan_id: null,
    subscription_expires_at: null,
    membership_override: "ban",
    membership_override_expires_at: null,
  });
}

// ── 后台会员覆盖（override，优先于 App Store / RevenueCat）──
const overrideDays = ref("365");
function grantOverride() {
  const days = parseInt(overrideDays.value || "0", 10);
  const expires = days > 0 ? new Date(Date.now() + days * 86400000).toISOString() : null;
  const planId = giftPlan.value || subPlans.value[0]?.id || "annual";
  if (!confirm(`强制开通会员，有效期：${days > 0 ? days + " 天" : "永久"}？\nApp 端将立即生效（优先于 App Store 订阅）。`)) return;
  applyMemberPatch({
    membership_override: "grant",
    membership_override_expires_at: expires,
    subscription_plan_id: planId,
    subscription_expires_at: expires,
    membership_override_note: detail.value.membership_override_note?.trim() || null,
  });
}
function banUser() {
  if (!confirm("封禁该用户会员？\n即使其在 App Store 拥有有效订阅，App 内也将锁定全部付费内容。")) return;
  applyMemberPatch({
    membership_override: "ban",
    membership_override_expires_at: null,
    membership_override_note: detail.value.membership_override_note?.trim() || null,
  });
}
function clearOverride() {
  if (!confirm("清除后台覆盖？将回到按 App Store / RevenueCat 订阅自动判定。")) return;
  applyMemberPatch({
    membership_override: null,
    membership_override_expires_at: null,
    membership_override_note: null,
  });
}

async function setRefundStatus(r, status) {
  if (!confirm(`将退款申请标记为「${status === "approved" ? "通过" : "拒绝"}」？`)) return;
  const { error: e } = await supabase.from("user_refund_requests").update({ status }).eq("id", r.id);
  if (e) { showToast("失败：" + e.message); return; }
  r.status = status;
  showToast("已更新");
}

async function saveDetail() {
  savingDetail.value = true;
  const d = detail.value;
  const patch = {
    display_name: d.display_name?.trim() || null,
    country_code: d.country_code?.trim() || "GB",
    subscription_plan_id: d.subscription_plan_id || null,
    subscription_expires_at: d.subscription_expires_at || null,
    rc_customer_id: d.rc_customer_id?.trim() || null,
    membership_override_note: d.membership_override_note?.trim() || null,
    has_completed_onboarding: !!d.has_completed_onboarding,
    departure_date: d.departure_date || null,
    active_itinerary_id: d.active_itinerary_id?.trim() || null,
    purchased_attraction_ids: d.purchased_attraction_ids || [],
    updated_at: new Date().toISOString(),
  };
  const now = new Date();
  const subExpired = patch.subscription_expires_at && new Date(patch.subscription_expires_at) <= now;
  const subCancelled = !patch.subscription_plan_id;
  const subActive = patch.subscription_plan_id && (!patch.subscription_expires_at || new Date(patch.subscription_expires_at) > now);
  if (subActive) {
    patch.membership_override = null;
    patch.membership_override_expires_at = null;
  } else if ((subExpired || subCancelled) && d.membership_override !== "grant") {
    patch.membership_override = "ban";
    patch.membership_override_expires_at = null;
  }
  const { error: e } = await supabase.from("profiles").update(patch).eq("id", d.id);
  savingDetail.value = false;
  if (e) { showToast("失败：" + e.message); return; }
  Object.assign(detail.value, patch);
  showToast("用户资料已保存");
  await loadList();
}

onMounted(async () => { await refCache.load(); await loadList(); });
</script>

<template>
  <div class="uh">
    <div v-if="error" class="status-bar error">{{ error }}</div>

    <!-- ───────── detail ───────── -->
    <template v-if="detail">
      <div class="bar">
        <button class="btn btn-secondary btn-sm" @click="closeDetail">← 用户列表</button>
        <button class="btn btn-sm" :disabled="savingDetail" @click="saveDetail">{{ savingDetail ? "保存中…" : "保存用户资料" }}</button>
      </div>

      <section class="card">
        <h3>账号信息</h3>
        <div class="fgrid">
          <label class="f">用户 UUID<input :value="detail.id" readonly /></label>
          <label class="f">邮箱<input :value="detail.email || ''" readonly /></label>
          <label class="f">显示名<input v-model="detail.display_name" type="text" /></label>
          <label class="f">国籍代码<input v-model="detail.country_code" type="text" placeholder="如 GB、US" /></label>
        </div>
        <div class="avatar-row">
          <img v-if="detail.avatar_url" :src="detail.avatar_url" class="avatar-lg" alt="" />
          <span v-else class="muted">未上传头像</span>
          <span class="muted small">注册 {{ fmtDateTime(detail.created_at) }} · 更新 {{ fmtDateTime(detail.updated_at) }}</span>
        </div>
      </section>

      <section class="card">
        <h3>会员与订阅</h3>
        <div v-if="needsBanWarning" class="warn-banner">
          ⚠️ 后台订阅已失效，但 App 仍可能按 App Store / RevenueCat 判定为会员。
          请点 <strong>封禁会员</strong> 或 <strong>取消会员</strong>，不要只改「订阅到期」。
        </div>
        <div class="status-card">
          <div class="status-head">
            <span class="badge" :class="detailStatusBadge.cls">{{ detailStatusBadge.text }}</span>
            <strong v-if="detail.subscription_plan_id || detail.membership_override === 'grant'">
              {{ planName(detail.subscription_plan_id || subPlans[0]?.id || "annual") }}
            </strong>
          </div>
          <div class="status-row"><span class="lbl">App 实际</span>
            <span class="badge" :class="detailActive ? 'green' : 'red'">{{ detailActive ? "有效会员" : "非会员" }}</span>
            <span class="muted small">（与 App 判定一致）</span>
          </div>
          <div class="status-row"><span class="lbl">到期</span>
            <template v-if="detail.membership_override === 'grant' && detail.membership_override_expires_at">
              {{ fmtDateTime(detail.membership_override_expires_at) }}
              <span class="badge" :class="detailActive ? (detailDaysLeft <= 7 ? 'yellow' : 'blue') : 'red'">
                {{ detailActive ? `剩 ${detailDaysLeft} 天` : "已过期" }}
              </span>
            </template>
            <template v-else-if="detail.subscription_expires_at">
              {{ fmtDateTime(detail.subscription_expires_at) }}
              <span class="badge" :class="detailActive ? (detailDaysLeft <= 7 ? 'yellow' : 'blue') : 'red'">
                {{ detailActive ? `剩 ${detailDaysLeft} 天` : "已过期" }}
              </span>
            </template>
            <span v-else-if="detail.subscription_plan_id" class="badge blue">永久 / 终身</span>
            <template v-else>—</template>
          </div>
          <div class="status-row"><span class="lbl">App Store</span>
            <template v-if="subActive(detail)">
              <span class="badge green">{{ planName(detail.subscription_plan_id) }}</span>
              <span v-if="detail.subscription_expires_at" class="muted small">至 {{ fmtDateTime(detail.subscription_expires_at) }}</span>
            </template>
            <span v-else class="muted">无有效订阅记录</span>
          </div>
          <div class="status-row"><span class="lbl">单购景点</span>{{ (detail.purchased_attraction_ids || []).length }} 个</div>
          <div class="status-row"><span class="lbl">后台覆盖</span>
            <template v-if="detail.membership_override === 'ban'">
              <span class="badge red">● 已封禁</span>
              <span class="muted small">即使有订阅也锁定全部付费内容</span>
            </template>
            <template v-else-if="detail.membership_override === 'grant'">
              <span class="badge green">● 强制开通</span>
              <span v-if="detail.membership_override_expires_at">至 {{ fmtDateTime(detail.membership_override_expires_at) }}</span>
              <span v-else class="badge blue">永久</span>
            </template>
            <span v-else class="muted">无（按 App Store 订阅自动判定）</span>
          </div>
          <div v-if="detail.membership_override_note" class="status-row">
            <span class="lbl">覆盖备注</span>{{ detail.membership_override_note }}
          </div>
        </div>

        <div class="quick">
          <select v-model="giftPlan">
            <option value="">选订阅计划…</option>
            <option v-for="p in subPlans" :key="p.id" :value="p.id">{{ p.name_zh || p.name_en }}</option>
          </select>
          <select v-model="giftDays">
            <option value="30">+30 天</option>
            <option value="90">+90 天</option>
            <option value="365">+365 天</option>
            <option value="0">永久</option>
          </select>
          <button class="btn btn-sm" @click="giftApply">赠送/设置会员</button>
          <button class="btn btn-secondary btn-sm" @click="extendDays(30)">续 30 天</button>
          <button class="btn btn-secondary btn-sm" @click="extendDays(365)">续 1 年</button>
          <button class="btn btn-danger btn-sm" @click="cancelSub">取消会员</button>
        </div>

        <div class="override-box">
          <div class="override-head">后台覆盖（优先于 App Store / RevenueCat）</div>
          <p class="muted small">订阅真相在 Apple，直接改上面的「订阅到期」会被 App 下次同步覆盖。要强制开通或封禁，请用这里 —— App 端会优先采用，且用户无法改。</p>
          <div class="quick">
            <select v-model="overrideDays">
              <option value="30">+30 天</option>
              <option value="90">+90 天</option>
              <option value="365">+365 天</option>
              <option value="0">永久</option>
            </select>
            <button class="btn btn-sm" @click="grantOverride">强制开通（赠送）</button>
            <button class="btn btn-danger btn-sm" @click="banUser">封禁会员</button>
            <button class="btn btn-secondary btn-sm" @click="clearOverride">清除覆盖</button>
          </div>
          <label class="f full mt">覆盖备注（仅后台可见）
            <input v-model="detail.membership_override_note" type="text" placeholder="封禁 / 赠送原因" />
          </label>
        </div>

        <p class="muted small mt">手动调整（高级）：编辑下列字段后点「保存用户资料」。修改后 App 下次拉取 profile 或重新登录时生效。</p>
        <div class="fgrid">
          <label class="f">订阅计划
            <select v-model="detail.subscription_plan_id">
              <option :value="null">— 无订阅 —</option>
              <option v-for="p in plans" :key="p.id" :value="p.id">{{ p.name_zh || p.name_en }} ({{ p.plan_type === "subscription" ? "订阅" : "单次" }})</option>
            </select>
          </label>
          <label class="f">订阅到期时间<input v-model="expiresLocal" type="datetime-local" /></label>
          <label class="f full">RevenueCat Customer ID<input v-model="detail.rc_customer_id" type="text" placeholder="通常与 Supabase UUID 相同" /></label>
        </div>
        <div class="block">
          <label class="lbl2">已购景点（单购解锁）</label>
          <MultiCheck v-model="detail.purchased_attraction_ids" :options="attractionOptions" />
        </div>
      </section>

      <section class="card">
        <h3>行程偏好</h3>
        <label class="chk"><input type="checkbox" v-model="detail.has_completed_onboarding" /> 已完成引导</label>
        <div class="fgrid">
          <label class="f">出发日期<input v-model="detail.departure_date" type="date" /></label>
          <label class="f">当前行程 ID<input v-model="detail.active_itinerary_id" type="text" placeholder="user_itineraries.id" /></label>
        </div>
      </section>

      <section class="card">
        <h3>交易记录 <span class="muted small">（最近 20 条）</span></h3>
        <table class="data-table">
          <thead><tr><th>时间</th><th>类型</th><th>商品</th><th>金额</th></tr></thead>
          <tbody>
            <tr v-for="t in detailTxns" :key="t.id">
              <td>{{ fmtDateTime(t.purchased_at) }}</td>
              <td><span class="badge" :class="t.event_type === 'REFUND' ? 'red' : t.event_type === 'INITIAL_PURCHASE' ? 'green' : 'gray'">{{ EVENT_LABELS[t.event_type] || t.event_type }}</span></td>
              <td><code>{{ t.product_id }}</code></td>
              <td>{{ t.price_usd != null ? "$" + Number(t.price_usd).toFixed(2) : "—" }}</td>
            </tr>
            <tr v-if="!detailTxns.length"><td colspan="4" class="center muted">暂无交易记录</td></tr>
          </tbody>
        </table>
      </section>

      <section class="card">
        <h3>退款申请</h3>
        <table class="data-table">
          <thead><tr><th>时间</th><th>原因</th><th>状态</th><th>操作</th></tr></thead>
          <tbody>
            <tr v-for="r in detailRefunds" :key="r.id">
              <td>{{ fmtDateTime(r.created_at) }}</td>
              <td>{{ r.reason || "—" }}</td>
              <td><span class="badge" :class="{ yellow: r.status === 'pending', green: r.status === 'approved', red: r.status === 'rejected' }">{{ r.status }}</span></td>
              <td>
                <template v-if="r.status === 'pending'">
                  <button class="btn btn-sm" @click="setRefundStatus(r, 'approved')">通过</button>
                  <button class="btn btn-danger btn-sm" @click="setRefundStatus(r, 'rejected')">拒绝</button>
                </template>
              </td>
            </tr>
            <tr v-if="!detailRefunds.length"><td colspan="4" class="center muted">暂无退款申请</td></tr>
          </tbody>
        </table>
      </section>
    </template>

    <!-- ───────── list ───────── -->
    <template v-else>
      <h1>用户管理</h1>
      <div class="stats">
        <div class="stat"><div class="num">{{ stats.total }}</div><div class="lab">总用户</div></div>
        <div class="stat green"><div class="num">{{ stats.members }}</div><div class="lab">有效会员</div></div>
        <div class="stat red"><div class="num">{{ stats.expired }}</div><div class="lab">会员已过期</div></div>
        <div class="stat blue"><div class="num">{{ stats.single }}</div><div class="lab">单购用户</div></div>
      </div>

      <div class="bar">
        <input v-model="search" class="search" type="search" placeholder="搜索邮箱、昵称、UUID…" />
        <select v-model="statusFilter">
          <option value="">全部用户</option>
          <option value="active_member">有效会员</option>
          <option value="expired">会员已过期</option>
          <option value="purchased">已单购景点</option>
          <option value="onboarded">已完成引导</option>
        </select>
        <button class="btn btn-secondary btn-sm" @click="loadList">刷新</button>
        <span class="muted">{{ filtered.length }} 人</span>
      </div>

      <table class="data-table">
        <thead><tr><th>头像</th><th>邮箱 / 昵称</th><th>国籍</th><th>会员</th><th>到期</th><th>已购</th><th>头像审核</th><th>更新</th></tr></thead>
        <tbody>
          <tr v-for="p in filtered" :key="p.id" class="click" @click="openDetail(p)">
            <td class="center">
              <img v-if="p.avatar_url" :src="p.avatar_url" class="avatar" alt="" />
              <span v-else class="avatar-init">{{ (p.display_name || p.email || "?")[0].toUpperCase() }}</span>
            </td>
            <td>
              <div>{{ p.email || "—" }}</div>
              <div v-if="p.display_name" class="muted small">{{ p.display_name }}</div>
            </td>
            <td>{{ p.country_code || "—" }}</td>
            <td>
              <span v-if="p.membership_override === 'ban'" class="badge red">封禁</span>
              <span v-else-if="p.membership_override === 'grant'" class="badge green">赠送{{ isActiveMember(p) ? "" : " · 失效" }}</span>
              <span v-else-if="p.subscription_plan_id" class="badge" :class="isActiveMember(p) ? 'green' : 'gray'">{{ planName(p.subscription_plan_id) }}{{ isActiveMember(p) ? "" : " · 失效" }}</span>
              <span v-else class="badge gray">免费</span>
            </td>
            <td>
              <span v-if="p.subscription_expires_at && new Date(p.subscription_expires_at) < new Date()" class="badge red">已到期 {{ fmtDate(p.subscription_expires_at) }}</span>
              <template v-else>{{ fmtDate(p.subscription_expires_at) }}</template>
            </td>
            <td><span v-if="(p.purchased_attraction_ids || []).length" class="badge blue">{{ p.purchased_attraction_ids.length }} 个</span><span v-else class="muted">0</span></td>
            <td><span v-if="AVATAR_STATUS[p.avatar_status]" class="badge" :class="AVATAR_STATUS[p.avatar_status].cls">{{ AVATAR_STATUS[p.avatar_status].label }}</span><span v-else class="muted">—</span></td>
            <td class="muted small">{{ fmtDateTime(p.updated_at) }}</td>
          </tr>
          <tr v-if="!filtered.length"><td colspan="8" class="center muted">暂无用户</td></tr>
        </tbody>
      </table>
    </template>

    <div class="toast" :class="{ on: toast }">{{ toast }}</div>
  </div>
</template>

<style scoped>
.uh h1 { margin: 0 0 14px; font-size: 20px; }
.bar { display: flex; gap: 12px; align-items: center; margin-bottom: 14px; }
.bar .search { width: auto; min-width: 240px; }
.bar select { width: auto; min-width: 150px; }

/* stat cards */
.stats { display: grid; grid-template-columns: repeat(4, 1fr); gap: 12px; margin-bottom: 16px; max-width: 720px; }
.stat { background: var(--surface); border: 1px solid var(--border); border-radius: 10px; padding: 14px 16px; }
.stat .num { font-size: 26px; font-weight: 700; }
.stat .lab { color: var(--muted); font-size: 13px; margin-top: 2px; }
.stat.green .num { color: #2e9e5b; }
.stat.red .num { color: #c0392b; }
.stat.blue .num { color: #3a78c2; }

/* table */
.data-table { width: 100%; border-collapse: collapse; font-size: 14px; }
.data-table th, .data-table td { text-align: left; padding: 8px 12px; border-bottom: 1px solid var(--border); vertical-align: middle; }
.data-table th { color: var(--muted); font-size: 13px; }
.data-table code { font-size: 12px; }
.data-table .btn { margin-right: 6px; }
.click { cursor: pointer; }
.click:hover { background: var(--surface2); }
.center { text-align: center; }
.muted { color: var(--muted); }
.small { font-size: 11px; }
.mt { margin-top: 14px; }

.avatar { width: 32px; height: 32px; border-radius: 50%; object-fit: cover; }
.avatar-init { display: inline-flex; width: 32px; height: 32px; border-radius: 50%; background: var(--surface2); align-items: center; justify-content: center; font-weight: 600; }
.avatar-lg { width: 64px; height: 64px; border-radius: 50%; object-fit: cover; border: 1px solid var(--border); }
.avatar-row { display: flex; align-items: center; gap: 14px; margin-top: 12px; }

/* badges */
.badge { display: inline-block; padding: 2px 8px; border-radius: 12px; font-size: 12px; background: var(--surface2); color: var(--muted); white-space: nowrap; }
.badge.green { background: rgba(46, 158, 91, 0.15); color: #2e9e5b; }
.badge.red { background: rgba(192, 57, 43, 0.15); color: #c0392b; }
.badge.yellow { background: rgba(212, 154, 22, 0.18); color: #b5810a; }
.badge.blue { background: rgba(58, 120, 194, 0.15); color: #3a78c2; }
.badge.gray { background: var(--surface2); color: var(--muted); }

/* detail */
.card { background: var(--surface); border: 1px solid var(--border); border-radius: 12px; padding: 18px 20px; margin-bottom: 16px; }
.card h3 { margin: 0 0 14px; font-size: 16px; }
.fgrid { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; max-width: 720px; }
.f { display: block; font-size: 12px; color: var(--muted); }
.f.full { grid-column: 1 / -1; }
.f input, .f select { margin-top: 4px; }
.block { margin-top: 14px; }
.lbl2 { display: block; font-size: 12px; color: var(--muted); margin-bottom: 6px; }
.chk { display: inline-flex; align-items: center; gap: 6px; font-size: 14px; margin-bottom: 12px; }
.chk input { width: auto; }

.status-card { background: var(--surface2); border-radius: 10px; padding: 14px 16px; margin-bottom: 12px; }
.status-head { display: flex; align-items: center; gap: 10px; margin-bottom: 8px; }
.status-row { display: flex; align-items: center; gap: 8px; font-size: 14px; padding: 3px 0; }
.status-row .lbl { color: var(--muted); width: 72px; display: inline-block; }
.quick { display: flex; flex-wrap: wrap; gap: 8px; align-items: center; }
.quick select { width: auto; min-width: 140px; }

.override-box { margin-top: 14px; padding: 12px 14px; border: 1px dashed var(--border); border-radius: 10px; background: var(--surface2); }
.override-head { font-size: 13px; font-weight: 600; margin-bottom: 4px; }
.override-box .quick { margin-top: 10px; }
.warn-banner {
  margin-bottom: 12px; padding: 10px 12px; border-radius: 8px;
  background: rgba(212, 154, 22, 0.12); border: 1px solid rgba(212, 154, 22, 0.35);
  font-size: 13px; line-height: 1.5;
}

.toast { position: fixed; bottom: 26px; left: 50%; transform: translateX(-50%); background: var(--text); color: var(--bg); padding: 10px 18px; border-radius: 8px; font-size: 13px; opacity: 0; pointer-events: none; transition: opacity 0.2s; z-index: 1100; }
.toast.on { opacity: 1; }
</style>
