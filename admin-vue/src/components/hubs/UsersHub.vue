<script setup>
import { ref, computed, onMounted } from "vue";
import { supabase } from "@/lib/supabase";
import { useRefCache } from "@/stores/refCache";
import MultiCheck from "@/components/fields/MultiCheck.vue";
import DateTimePicker from "@/components/fields/DateTimePicker.vue";

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
function effectiveExpiry(p) {
  if (!p) return null;
  if (p.membership_override === "grant") return p.membership_override_expires_at;
  return p.subscription_expires_at;
}
function isExpiredMembership(p) {
  if (p.membership_override === "ban") return false;
  const exp = effectiveExpiry(p);
  if (!exp) return false;
  return (p.subscription_plan_id || p.membership_override === "grant")
    && new Date(exp) <= new Date();
}
function fmtDate(d) { return d ? new Date(d).toLocaleDateString("zh-CN") : "—"; }
function fmtDateTime(d) { return d ? new Date(d).toLocaleString("zh-CN") : "—"; }

const stats = computed(() => {
  const r = profiles.value;
  return {
    total: r.length,
    members: r.filter(isActiveMember).length,
    expired: r.filter(isExpiredMembership).length,
    single: r.filter((p) => (p.purchased_attraction_ids || []).length > 0).length,
  };
});

const filtered = computed(() => {
  let list = profiles.value;
  const q = search.value.trim().toLowerCase();
  if (q) list = list.filter((p) => [p.email, p.display_name, p.id, p.country_code].filter(Boolean).join(" ").toLowerCase().includes(q));
  const f = statusFilter.value;
  if (f === "active_member") list = list.filter(isActiveMember);
  else if (f === "expired") list = list.filter(isExpiredMembership);
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
function defaultGiftExpiry() {
  const d = new Date();
  d.setFullYear(d.getFullYear() + 1);
  d.setHours(23, 59, 0, 0);
  return d.toISOString();
}

const savingDetail = ref(false);
const giftPlan = ref("");
/** 开通 / 调整到期共用的日历值（ISO 或 null=永久） */
const expiryDraft = ref(null);
const minExpiryDate = computed(() => {
  const d = new Date();
  d.setHours(0, 0, 0, 0);
  return d;
});

const subPlans = computed(() => plans.value.filter((p) => p.plan_type === "subscription"));
const detailActive = computed(() => (detail.value ? isActiveMember(detail.value) : false));
const detailDaysLeft = computed(() => daysUntil(detailExpiry.value));
const detailStatusBadge = computed(() => {
  if (!detail.value) return { cls: "gray", text: "—" };
  const d = detail.value;
  if (d.membership_override === "ban") return { cls: "red", text: "已取消" };
  if (d.membership_override === "grant") {
    return detailActive.value
      ? { cls: "green", text: "后台赠送" }
      : { cls: "red", text: "赠送已过期" };
  }
  if (detailActive.value) return { cls: "green", text: "App Store 订阅" };
  if (d.subscription_plan_id) return { cls: "red", text: "订阅已过期" };
  return { cls: "gray", text: "免费用户" };
});
const detailExpiry = computed(() => effectiveExpiry(detail.value));
const hasOverride = computed(() => {
  const o = detail.value?.membership_override;
  return o === "ban" || o === "grant";
});
const canEditExpiry = computed(() => {
  if (!detail.value) return false;
  if (detail.value.membership_override === "ban") return false;
  return detail.value.membership_override === "grant"
    || !!detail.value.subscription_plan_id;
});
const serverPermanentGrant = computed(() => {
  if (!detail.value) return false;
  return detail.value.membership_override === "grant"
    && detail.value.membership_override_expires_at == null
    && detail.value.subscription_expires_at == null;
});

function syncExpiryDraftFromDetail() {
  if (!detail.value) return;
  if (serverPermanentGrant.value) {
    expiryDraft.value = null;
    return;
  }
  const cur = effectiveExpiry(detail.value);
  expiryDraft.value = cur ?? defaultGiftExpiry();
}

function validateFutureExpiry(iso) {
  if (iso == null) return true;
  if (new Date(iso) <= new Date()) {
    showToast("到期时间须在未来");
    return false;
  }
  return true;
}
/** 后台订阅已失效但未设 ban —— App 仍可能因 RevenueCat 显示会员 */
const needsBanWarning = computed(() => {
  if (!detail.value) return false;
  const d = detail.value;
  return d.membership_override !== "ban"
    && d.membership_override !== "grant"
    && !isActiveMember(d)
    && (!!d.rc_customer_id || !!d.subscription_plan_id);
});


async function openDetail(p) {
  error.value = "";
  await refCache.load();
  const { data, error: e } = await supabase.from("profiles").select("*").eq("id", p.id).single();
  if (e) { showToast("加载失败：" + e.message); return; }
  data.purchased_attraction_ids = data.purchased_attraction_ids || [];
  detail.value = data;
  giftPlan.value = data.subscription_plan_id || subPlans.value[0]?.id || "";
  syncExpiryDraftFromDetail();
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
  syncExpiryDraftFromDetail();
  showToast("会员状态已更新");
  await loadList();
}
function grantMembership() {
  if (!subPlans.value.length) return showToast("暂无可用订阅计划");
  const planId = giftPlan.value || subPlans.value[0]?.id || "annual";
  const expires = expiryDraft.value;
  const label = planName(planId);
  const dur = expires ? fmtDateTime(expires) : "永久";
  if (!validateFutureExpiry(expires)) return;
  if (expires == null && !confirm("设为永久会员？到期后不会自动失效。")) return;
  if (!confirm(`为「${label}」开通会员，到期：${dur}？\nApp 将立即解锁付费内容。`)) return;
  applyMemberPatch({
    membership_override: "grant",
    membership_override_expires_at: expires,
    subscription_plan_id: planId,
    subscription_expires_at: expires,
    membership_override_note: detail.value.membership_override_note?.trim() || null,
  });
}
function saveMembershipExpiry() {
  if (!canEditExpiry.value) return showToast("请先开通会员");
  const expires = expiryDraft.value;
  const planId = detail.value.subscription_plan_id || giftPlan.value || subPlans.value[0]?.id || "annual";
  const dur = expires ? fmtDateTime(expires) : "永久";
  if (!validateFutureExpiry(expires)) return;
  if (expires == null && !confirm("设为永久会员？到期后不会自动失效。")) return;
  if (!confirm(`将会员到期更新为：${dur}？`)) return;
  applyMemberPatch({
    subscription_plan_id: planId,
    subscription_expires_at: expires,
    membership_override: "grant",
    membership_override_expires_at: expires,
  });
}
function cancelMembership() {
  if (!confirm("取消该用户会员？\nApp 内将全部锁定付费内容（即使 App Store 仍有订阅）。")) return;
  applyMemberPatch({
    subscription_plan_id: null,
    subscription_expires_at: null,
    membership_override: "ban",
    membership_override_expires_at: null,
    membership_override_note: detail.value.membership_override_note?.trim() || null,
  });
}
function clearOverride() {
  if (!confirm("清除后台覆盖？\n将删除赠送/封禁标记及后台订阅记录，改由 App Store / RevenueCat 自动判定。")) return;
  applyMemberPatch({
    membership_override: null,
    membership_override_expires_at: null,
    membership_override_note: null,
    subscription_plan_id: null,
    subscription_expires_at: null,
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
    subscription_expires_at: d.membership_override === "ban"
      ? (d.subscription_expires_at || null)
      : (d.subscription_plan_id || d.membership_override === "grant"
        ? expiryDraft.value
        : (d.subscription_expires_at || null)),
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
  // App 在 RevenueCat 已配置时只认 membership_override=grant，不认 subscription_* 列。
  if (subActive && d.membership_override !== "ban") {
    patch.membership_override = "grant";
    patch.membership_override_expires_at = patch.subscription_expires_at || null;
  } else if ((subExpired || subCancelled) && d.membership_override !== "grant") {
    patch.membership_override = "ban";
    patch.membership_override_expires_at = null;
  }
  const { error: e } = await supabase.from("profiles").update(patch).eq("id", d.id);
  savingDetail.value = false;
  if (e) { showToast("失败：" + e.message); return; }
  Object.assign(detail.value, patch);
  syncExpiryDraftFromDetail();
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

      <section class="card member-card">
        <h3>会员与订阅</h3>

        <div v-if="needsBanWarning" class="warn-banner">
          后台记录已过期，但 App 可能仍按 App Store 判定为会员。请点 <strong>取消会员</strong> 强制锁定。
        </div>

        <div class="member-hero">
          <div class="member-hero-top">
            <span class="badge member-badge" :class="detailStatusBadge.cls">{{ detailStatusBadge.text }}</span>
            <span class="member-app" :class="detailActive ? 'on' : 'off'">
              App {{ detailActive ? "已解锁" : "未解锁" }}
            </span>
          </div>
          <div class="member-plan" v-if="detail.subscription_plan_id || detail.membership_override === 'grant'">
            {{ planName(detail.subscription_plan_id || subPlans[0]?.id || "annual") }}
          </div>
          <div class="member-expiry">
            <template v-if="detailExpiry">
              到期 {{ fmtDateTime(detailExpiry) }}
              <span v-if="detailDaysLeft != null" class="badge" :class="detailActive ? (detailDaysLeft <= 7 ? 'yellow' : 'blue') : 'red'">
                {{ detailActive ? `剩 ${detailDaysLeft} 天` : "已过期" }}
              </span>
            </template>
            <span v-else-if="detail.subscription_plan_id || detail.membership_override === 'grant'" class="badge blue">永久</span>
            <span v-else class="muted">—</span>
          </div>
          <div v-if="subActive(detail)" class="member-mirror muted small">
            App Store 镜像：{{ planName(detail.subscription_plan_id) }}
            <template v-if="detail.subscription_expires_at"> · {{ fmtDateTime(detail.subscription_expires_at) }}</template>
          </div>
          <div v-if="(detail.purchased_attraction_ids || []).length" class="member-mirror muted small">
            单购景点 {{ detail.purchased_attraction_ids.length }} 个
          </div>
        </div>

        <div class="member-schedule">
          <div class="member-toolbar">
            <label class="member-field">
              <span>订阅计划</span>
              <select v-model="giftPlan">
                <option v-for="p in subPlans" :key="p.id" :value="p.id">{{ p.name_zh || p.name_en }}</option>
              </select>
            </label>
            <DateTimePicker
              v-model="expiryDraft"
              allow-permanent
              compact
              label="到期时间"
              :permanent-active="serverPermanentGrant"
              :min-date="minExpiryDate"
            />
            <div class="member-toolbar-actions">
              <button class="btn btn-sm" @click="grantMembership">开通会员</button>
              <button
                v-if="canEditExpiry"
                class="btn btn-secondary btn-sm"
                @click="saveMembershipExpiry"
              >保存到期</button>
              <button class="btn btn-danger btn-sm" @click="cancelMembership">取消会员</button>
              <button v-if="hasOverride" class="btn btn-secondary btn-sm" @click="clearOverride">恢复自动判定</button>
            </div>
          </div>
        </div>

        <label class="member-note">
          <span>备注</span>
          <input v-model="detail.membership_override_note" type="text" placeholder="赠送 / 取消原因（仅后台可见）" />
        </label>

        <details class="member-advanced">
          <summary>高级设置 <span class="muted small">（手动改字段后点顶部「保存用户资料」）</span></summary>
          <div class="fgrid mt">
            <label class="f">订阅计划
              <select v-model="detail.subscription_plan_id">
                <option :value="null">— 无 —</option>
                <option v-for="p in plans" :key="p.id" :value="p.id">{{ p.name_zh || p.name_en }}</option>
              </select>
            </label>
            <label class="f full">RevenueCat ID<input v-model="detail.rc_customer_id" type="text" placeholder="通常与用户 UUID 相同" /></label>
          </div>
          <div class="block">
            <label class="lbl2">单购景点解锁</label>
            <MultiCheck v-model="detail.purchased_attraction_ids" :options="attractionOptions" />
          </div>
        </details>
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
              <span v-if="p.membership_override === 'ban'" class="badge red">已取消</span>
              <span v-else-if="p.membership_override === 'grant'" class="badge green">赠送{{ isActiveMember(p) ? "" : " · 失效" }}</span>
              <span v-else-if="p.subscription_plan_id" class="badge" :class="isActiveMember(p) ? 'green' : 'gray'">{{ planName(p.subscription_plan_id) }}{{ isActiveMember(p) ? "" : " · 失效" }}</span>
              <span v-else class="badge gray">免费</span>
            </td>
            <td>
              <template v-if="effectiveExpiry(p)">
                <span
                  v-if="new Date(effectiveExpiry(p)) <= new Date()"
                  class="badge red"
                >已到期 {{ fmtDate(effectiveExpiry(p)) }}</span>
                <template v-else>{{ fmtDate(effectiveExpiry(p)) }}</template>
              </template>
              <span v-else-if="p.membership_override === 'grant' || p.subscription_plan_id" class="badge blue">永久</span>
              <span v-else class="muted">—</span>
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

/* membership (simplified) */
.member-hero {
  background: var(--surface2); border-radius: 10px; padding: 14px 16px; margin-bottom: 14px;
}
.member-hero-top { display: flex; align-items: center; gap: 10px; flex-wrap: wrap; margin-bottom: 6px; }
.member-badge { font-size: 13px; font-weight: 600; padding: 4px 10px; }
.member-app { font-size: 13px; font-weight: 600; }
.member-app.on { color: #2e9e5b; }
.member-app.off { color: #c0392b; }
.member-plan { font-size: 15px; font-weight: 600; margin-bottom: 4px; }
.member-expiry { font-size: 14px; display: flex; align-items: center; gap: 8px; flex-wrap: wrap; }
.member-mirror { margin-top: 8px; }
.member-schedule { margin-bottom: 14px; }
.member-toolbar {
  display: flex;
  flex-wrap: wrap;
  gap: 12px 16px;
  align-items: flex-end;
  padding: 12px 14px;
  background: var(--surface2);
  border-radius: 10px;
}
.member-toolbar-actions {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  align-items: center;
  margin-left: auto;
}
.member-field { display: flex; flex-direction: column; gap: 4px; font-size: 12px; color: var(--muted); min-width: 140px; }
.member-field select { margin-top: 0; }
.member-note {
  display: flex; align-items: center; gap: 10px; font-size: 12px; color: var(--muted); margin-bottom: 12px;
}
.member-note span { white-space: nowrap; }
.member-note input { flex: 1; min-width: 0; margin-top: 0; }
.member-advanced {
  border-top: 1px solid var(--border); padding-top: 12px; font-size: 14px;
}
.member-advanced summary {
  cursor: pointer; color: var(--muted); font-size: 13px; user-select: none;
}
.member-advanced summary .small { font-weight: 400; }
.member-advanced[open] summary { margin-bottom: 12px; }

.warn-banner {
  margin-bottom: 12px; padding: 10px 12px; border-radius: 8px;
  background: rgba(212, 154, 22, 0.12); border: 1px solid rgba(212, 154, 22, 0.35);
  font-size: 13px; line-height: 1.5;
}

.toast { position: fixed; bottom: 26px; left: 50%; transform: translateX(-50%); background: var(--text); color: var(--bg); padding: 10px 18px; border-radius: 8px; font-size: 13px; opacity: 0; pointer-events: none; transition: opacity 0.2s; z-index: 1100; }
.toast.on { opacity: 1; }
</style>
