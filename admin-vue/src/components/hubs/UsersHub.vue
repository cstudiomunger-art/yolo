<script setup>
import { ref, computed, onMounted } from "vue";
import { supabase, isAdmin, addExistingUserAsAdmin, removeAdmin, createAdminUser } from "@/lib/supabase";
import { uploadUserAvatar } from "@/lib/storage";
import { compressImage } from "@/lib/imageUtils";
import { useRefCache } from "@/stores/refCache";
import MultiCheck from "@/components/fields/MultiCheck.vue";
import DateTimePicker from "@/components/fields/DateTimePicker.vue";

const refCache = useRefCache();

const profiles = ref([]);
const plans = ref([]); // active plans for selectors
const adminUsers = ref([]);
const adminUserIds = ref(new Set()); // for quick lookup
const search = ref("");
const statusFilter = ref("");
const error = ref("");
const toast = ref("");
function showToast(m) { toast.value = m; setTimeout(() => (toast.value = ""), 1800); }

// ═══════════════════════════════════════════════════════════════
// Admin Management State
// ═══════════════════════════════════════════════════════════════
const showCreateAdminDialog = ref(false);
const newAdminEmail = ref("");
const newAdminPassword = ref("");
const creatingAdmin = ref(false);

// ═══════════════════════════════════════════════════════════════
// Support Agent Management State
// ═══════════════════════════════════════════════════════════════
const supportAgents = ref([]);
const showCreateAgentDialog = ref(false);
const newAgentName = ref("");
const newAgentRole = ref("");
const newAgentStatus = ref("offline");
const newAgentLanguages = ref([]);
const creatingAgent = ref(false);
const uploadingAvatar = ref(false);
const avatarInput = ref(null);

// ═══════════════════════════════════════════════════════════════
// Avatar Upload State
// ═══════════════════════════════════════════════════════════════
const showAvatarUploadDialog = ref(false);
const avatarFile = ref(null);
const compressedAvatarFile = ref(null);
const compressingAvatar = ref(false);
const originalImageInfo = ref(null);
const compressedImageInfo = ref(null);

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
  const [pr, pl, au, sa] = await Promise.all([
    supabase.from("profiles").select(PROFILE_COLS).order("updated_at", { ascending: false }),
    supabase.from("membership_plans").select("id,name_zh,name_en,plan_type,access_flags,price_label,is_active").order("display_order"),
    supabase.from("admin_users").select("user_id,email,created_at").order("created_at", { ascending: false }),
    supabase.from("support_agents").select("id,user_id,name,role,status,languages,avatar_url,display_order,is_active").order("display_order"),
  ]);
  if (pr.error) error.value = pr.error.message;
  profiles.value = pr.data || [];
  plans.value = (pl.data || []).filter((p) => p.is_active);
  adminUsers.value = au.error ? [] : (au.data || []);
  supportAgents.value = sa.error ? [] : (sa.data || []);
  // Update admin user IDs Set for quick lookup
  adminUserIds.value = new Set(adminUsers.value.map((a) => a.user_id));
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
function formatFileSize(bytes) {
  if (!bytes) return "—";
  if (bytes < 1024) return bytes + " B";
  if (bytes < 1024 * 1024) return (bytes / 1024).toFixed(1) + " KB";
  return (bytes / (1024 * 1024)).toFixed(2) + " MB";
}
function formatCompressionDiff(original, compressed) {
  const diff = original - compressed;
  const ratio = (diff / original) * 100;
  if (ratio > 0) return `节省 ${ratio.toFixed(0)}%`;
  if (ratio < 0) return `增加 ${Math.abs(ratio).toFixed(0)}%`;
  return "0%";
}

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

// Support agent computed
const isSupportAgent = computed(() => {
  return detail.value ? supportAgents.value.some((a) => a.user_id === detail.value.id) : false;
});

const agentDetail = computed(() => {
  return detail.value ? supportAgents.value.find((a) => a.user_id === detail.value.id) : null;
});

// ── detail ──
const detail = ref(null); // full profile row
const detailTxns = ref([]);
const detailRefunds = ref([]);
const detailInviteRedemptions = ref([]);
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
/** 后台订阅镜像已过期、未设 ban/grant 时提示：App 仍可能按 RC 显示会员 */
const needsBanWarning = computed(() => {
  if (!detail.value) return false;
  const d = detail.value;
  if (d.membership_override === "ban" || d.membership_override === "grant") return false;
  if (isActiveMember(d)) return false;
  if (!d.subscription_plan_id) return false;
  if (!d.subscription_expires_at) return false;
  return new Date(d.subscription_expires_at) <= new Date();
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
  const [tx, rf, ir] = await Promise.all([
    supabase.from("user_iap_transactions").select("id,event_type,product_id,price_usd,purchased_at").eq("user_id", p.id).order("purchased_at", { ascending: false }).limit(20),
    supabase.from("user_refund_requests").select("id,reason,status,created_at").eq("user_id", p.id).order("created_at", { ascending: false }),
    supabase.from("invite_code_redemptions").select("id,code_snapshot,granted_plan_id,granted_expires_at,duration_days_applied,redeemed_at,redemption_mode_snapshot").eq("user_id", p.id).order("redeemed_at", { ascending: false }),
  ]);
  detailTxns.value = tx.data || [];
  detailRefunds.value = rf.data || [];
  detailInviteRedemptions.value = ir.data || [];
}
function closeDetail() { detail.value = null; }

async function applyMemberPatch(patch, successMsg) {
  const { error: e } = await supabase.from("profiles").update({ ...patch, updated_at: new Date().toISOString() }).eq("id", detail.value.id);
  if (e) { showToast("失败：" + e.message); return; }
  Object.assign(detail.value, patch);
  syncExpiryDraftFromDetail();
  showToast(successMsg || "会员状态已更新");
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
  }, "已恢复自动判定，App 端以 RevenueCat 为准");
}

async function setRefundStatus(r, status) {
  if (!confirm(`将退款申请标记为「${status === "approved" ? "通过" : "拒绝"}」？`)) return;
  const { error: e } = await supabase.from("user_refund_requests").update({ status }).eq("id", r.id);
  if (e) { showToast("失败：" + e.message); return; }
  r.status = status;
  showToast("已更新");
}

// ═══════════════════════════════════════════════════════════════
// Admin Management Functions
// ═══════════════════════════════════════════════════════════════
const isAdminUser = computed(() => {
  return detail.value ? adminUserIds.value.has(detail.value.id) : false;
});

async function addAsAdmin() {
  if (!detail.value) return;
  const email = detail.value.email;
  const userId = detail.value.id;
  if (!confirm(`确认将「${email}」添加为管理员？`)) return;
  try {
    await addExistingUserAsAdmin(userId, email);
    showToast("已添加为管理员");
    await loadList();
  } catch (e) {
    showToast("失败：" + (e.message || e));
  }
}

async function removeAdminAccess() {
  if (!detail.value) return;
  const email = detail.value.email;
  const userId = detail.value.id;
  if (!confirm(`确认移除「${email}」的管理员权限？`)) return;
  try {
    await removeAdmin(userId);
    showToast("已移除管理员权限");
    await loadList();
  } catch (e) {
    showToast("失败：" + (e.message || e));
  }
}

async function deleteAdminFromList(admin) {
  if (!confirm(`确认移除「${admin.email}」的管理员权限？`)) return;
  try {
    await removeAdmin(admin.user_id);
    showToast("已移除管理员权限");
    await loadList();
  } catch (e) {
    showToast("失败：" + (e.message || e));
  }
}

async function createNewAdminUser() {
  const email = newAdminEmail.value.trim();
  const password = newAdminPassword.value;
  if (!email || !password) {
    showToast("请填写邮箱和密码");
    return;
  }
  creatingAdmin.value = true;
  try {
    await createAdminUser(email, password);
    showToast(`管理员「${email}」创建成功`);
    newAdminEmail.value = "";
    newAdminPassword.value = "";
    showCreateAdminDialog.value = false;
    await loadList();
  } catch (e) {
    showToast("失败：" + (e.message || e));
  } finally {
    creatingAdmin.value = false;
  }
}

// ═══════════════════════════════════════════════════════════════
// Support Agent Management Functions
// ═══════════════════════════════════════════════════════════════
async function addAsSupportAgent() {
  if (!detail.value) return;
  const name = detail.value.display_name || detail.value.email || "客服";
  const userId = detail.value.id;
  if (!confirm(`确认将「${name}」添加为客服？`)) return;
  try {
    const { error: e } = await supabase.from("support_agents").insert({
      user_id: userId,
      name: name,
      role: "",
      status: "offline",
      languages: [],
      display_order: supportAgents.value.length,
      is_active: true,
    });
    if (e) throw e;
    showToast("已添加为客服");
    await loadList();
  } catch (e) {
    showToast("失败：" + (e.message || e));
  }
}

async function removeSupportAgentAccess() {
  if (!detail.value) return;
  const agent = agentDetail.value;
  if (!agent) return;
  if (!confirm(`确认移除该用户的客服权限？`)) return;
  try {
    const { error: e } = await supabase.from("support_agents").delete().eq("id", agent.id);
    if (e) throw e;
    showToast("已移除客服权限");
    await loadList();
  } catch (e) {
    showToast("失败：" + (e.message || e));
  }
}

async function deleteAgentFromList(agent) {
  if (!confirm(`确认删除客服「${agent.name}」？`)) return;
  try {
    const { error: e } = await supabase.from("support_agents").delete().eq("id", agent.id);
    if (e) throw e;
    showToast("已删除客服");
    await loadList();
  } catch (e) {
    showToast("失败：" + (e.message || e));
  }
}

// ═══════════════════════════════════════════════════════════════
// Avatar Upload Functions
// ═══════════════════════════════════════════════════════════════
function triggerAvatarUpload() {
  avatarInput.value?.click();
}

function onAvatarFileChange(e) {
  const file = e.target.files?.[0];
  if (!file) return;
  if (!file.type.startsWith("image/")) {
    showToast("请选择图片文件");
    return;
  }
  if (file.size > 10 * 1024 * 1024) {
    showToast("图片大小不能超过 10MB");
    return;
  }

  // Show original image info
  originalImageInfo.value = {
    size: file.size,
    type: file.type,
    name: file.name,
  };

  avatarFile.value = file;
  compressedAvatarFile.value = null;
  compressedImageInfo.value = null;
  showAvatarUploadDialog.value = true;

  // Auto compress if image is large
  if (file.size > 500 * 1024) {
    compressAvatarImage();
  }
}

async function compressAvatarImage() {
  if (!avatarFile.value) return;
  compressingAvatar.value = true;
  try {
    const compressed = await compressImage(avatarFile.value, 800, 800, 0.8);
    compressedAvatarFile.value = new File([compressed], `compressed_${avatarFile.value.name}`, {
      type: "image/jpeg",
    });
    compressedImageInfo.value = {
      size: compressed.size,
      type: "image/jpeg",
    };
    showToast(`图片已压缩`);
  } catch (e) {
    showToast("压缩失败：" + (e.message || e));
  } finally {
    compressingAvatar.value = false;
  }
}

async function uploadAvatar() {
  if (!compressedAvatarFile.value || !detail.value) return;
  uploadingAvatar.value = true;
  try {
    const url = await uploadUserAvatar(compressedAvatarFile.value, detail.value.id);
    const { error: e } = await supabase.from("profiles").update({
      avatar_url: url,
      avatar_status: "approved",
      updated_at: new Date().toISOString(),
    }).eq("id", detail.value.id);
    if (e) throw e;
    detail.value.avatar_url = url;
    detail.value.avatar_status = "approved";
    showToast("头像上传成功");
    showAvatarUploadDialog.value = false;
    avatarFile.value = null;
    compressedAvatarFile.value = null;
    await loadList();
  } catch (e) {
    showToast("失败：" + (e.message || e));
  } finally {
    uploadingAvatar.value = false;
  }
}

function cancelAvatarUpload() {
  showAvatarUploadDialog.value = false;
  avatarFile.value = null;
  compressedAvatarFile.value = null;
  originalImageInfo.value = null;
  compressedImageInfo.value = null;
}

function clearAvatar() {
  if (!detail.value) return;
  if (!confirm("确认清除该用户头像？")) return;
  supabase.from("profiles").update({
    avatar_url: null,
    avatar_status: null,
    updated_at: new Date().toISOString(),
  }).eq("id", detail.value.id).then(({ error: e }) => {
    if (e) {
      showToast("失败：" + e.message);
      return;
    }
    detail.value.avatar_url = null;
    detail.value.avatar_status = null;
    showToast("头像已清除");
    loadList();
  });
}

async function saveDetail() {
  savingDetail.value = true;
  const d = detail.value;
  const patch = {
    display_name: d.display_name?.trim() || null,
    country_code: d.country_code?.trim() || "GB",
    subscription_plan_id: d.subscription_plan_id || null,
    subscription_expires_at: d.membership_override === "grant"
      ? expiryDraft.value
      : (d.subscription_expires_at || null),
    rc_customer_id: d.rc_customer_id?.trim() || null,
    membership_override_note: d.membership_override_note?.trim() || null,
    has_completed_onboarding: !!d.has_completed_onboarding,
    departure_date: d.departure_date || null,
    active_itinerary_id: d.active_itinerary_id?.trim() || null,
    purchased_attraction_ids: d.purchased_attraction_ids || [],
    updated_at: new Date().toISOString(),
  };
  // 会员覆盖仅由「开通 / 保存到期 / 取消 / 恢复自动判定」写入，保存资料不得改写。
  if (d.membership_override === "grant") {
    patch.membership_override = "grant";
    patch.membership_override_expires_at = expiryDraft.value;
    patch.subscription_plan_id = patch.subscription_plan_id || giftPlan.value || subPlans.value[0]?.id || null;
    patch.subscription_expires_at = expiryDraft.value;
  } else if (d.membership_override === "ban") {
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
          <div class="avatar-actions">
            <input ref="avatarInput" type="file" accept="image/*" hidden @change="onAvatarFileChange" />
            <button class="btn btn-secondary btn-sm" @click="triggerAvatarUpload">更换头像</button>
            <button v-if="detail.avatar_url" class="btn btn-secondary btn-sm" @click="clearAvatar">清除</button>
          </div>
        </div>
        <div class="muted small avatar-meta">注册 {{ fmtDateTime(detail.created_at) }} · 更新 {{ fmtDateTime(detail.updated_at) }}</div>

        <!-- Admin Status -->
        <div class="admin-status-row">
          <span class="admin-status-label">CMS 管理员权限：</span>
          <span v-if="isAdminUser" class="badge green">已授权</span>
          <span v-else class="badge gray">无权限</span>
          <button
            v-if="isAdminUser"
            class="btn btn-danger btn-sm"
            @click="removeAdminAccess"
          >移除管理员权限</button>
          <button
            v-else
            class="btn btn-sm"
            @click="addAsAdmin"
          >添加为管理员</button>
        </div>

        <!-- Support Agent Status -->
        <div class="admin-status-row">
          <span class="admin-status-label">客服权限：</span>
          <span v-if="isSupportAgent" class="badge green">已添加</span>
          <span v-else class="badge gray">无权限</span>
          <button
            v-if="isSupportAgent"
            class="btn btn-danger btn-sm"
            @click="removeSupportAgentAccess"
          >移除客服权限</button>
          <button
            v-else
            class="btn btn-sm"
            @click="addAsSupportAgent"
          >添加为客服</button>
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
        <h3>邀请码兑换</h3>
        <table class="data-table">
          <thead><tr><th>时间</th><th>邀请码</th><th>计划</th><th>权益到期</th><th>模式</th></tr></thead>
          <tbody>
            <tr v-for="r in detailInviteRedemptions" :key="r.id">
              <td>{{ fmtDateTime(r.redeemed_at) }}</td>
              <td><code>{{ r.code_snapshot }}</code></td>
              <td>{{ planName(r.granted_plan_id) }}</td>
              <td>{{ r.granted_expires_at ? fmtDateTime(r.granted_expires_at) : "永久" }}</td>
              <td><span class="badge gray">{{ r.redemption_mode_snapshot }}</span></td>
            </tr>
            <tr v-if="!detailInviteRedemptions.length"><td colspan="5" class="center muted">暂无邀请码兑换记录</td></tr>
          </tbody>
        </table>
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

      <section class="card mt">
        <h3>CMS 管理员</h3>
        <div class="admin-controls">
          <button class="btn btn-sm" @click="showCreateAdminDialog = true">+ 创建新管理员</button>
          <button class="btn btn-secondary btn-sm" @click="loadList">刷新列表</button>
        </div>
        <p class="muted small">
          也可以在用户详情中直接添加/移除管理员权限。
        </p>
        <table class="data-table">
          <thead><tr><th>邮箱</th><th>用户 UUID</th><th>添加时间</th><th>操作</th></tr></thead>
          <tbody>
            <tr v-for="a in adminUsers" :key="a.user_id">
              <td>{{ a.email || "—" }}</td>
              <td><code>{{ a.user_id }}</code></td>
              <td class="muted small">{{ fmtDateTime(a.created_at) }}</td>
              <td>
                <button
                  class="btn btn-danger btn-sm"
                  @click="deleteAdminFromList(a)"
                >移除</button>
              </td>
            </tr>
            <tr v-if="!adminUsers.length"><td colspan="4" class="center muted">暂无管理员记录</td></tr>
          </tbody>
        </table>
      </section>

      <section class="card mt">
        <h3>客服坐席</h3>
        <div class="admin-controls">
          <button class="btn btn-secondary btn-sm" @click="loadList">刷新列表</button>
        </div>
        <p class="muted small">
          客服可以在用户详情中添加，也可在此管理。
        </p>
        <table class="data-table">
          <thead><tr><th>头像</th><th>姓名</th><th>线路/专长</th><th>状态</th><th>操作</th></tr></thead>
          <tbody>
            <tr v-for="a in supportAgents" :key="a.id">
              <td class="center">
                <img v-if="a.avatar_url" :src="a.avatar_url" class="avatar" alt="" />
                <span v-else class="avatar-init">{{ (a.name || "?")[0].toUpperCase() }}</span>
              </td>
              <td>{{ a.name || "—" }}</td>
              <td>{{ a.role || "—" }}</td>
              <td>
                <span class="badge" :class="{
                  green: a.status === 'online',
                  yellow: a.status === 'busy',
                  gray: a.status === 'offline'
                }">{{ a.status }}</span>
                <span v-if="!a.is_active" class="badge red">已停用</span>
              </td>
              <td>
                <button class="btn btn-danger btn-sm" @click="deleteAgentFromList(a)">删除</button>
              </td>
            </tr>
            <tr v-if="!supportAgents.length"><td colspan="5" class="center muted">暂无客服坐席</td></tr>
          </tbody>
        </table>
      </section>

      <!-- Create Admin Dialog -->
      <div v-if="showCreateAdminDialog" class="modal-overlay" @click.self="showCreateAdminDialog = false">
        <div class="modal-card">
          <h3>创建新管理员</h3>
          <div class="modal-body">
            <label class="f">
              <span>邮箱</span>
              <input v-model="newAdminEmail" type="email" placeholder="admin@example.com" />
            </label>
            <label class="f">
              <span>密码</span>
              <input v-model="newAdminPassword" type="password" placeholder="至少 6 位" />
            </label>
          </div>
          <div class="modal-actions">
            <button class="btn btn-secondary" @click="showCreateAdminDialog = false">取消</button>
            <button class="btn" :disabled="creatingAdmin" @click="createNewAdminUser">
              {{ creatingAdmin ? "创建中..." : "创建" }}
            </button>
          </div>
        </div>
      </div>

      <!-- Avatar Upload Dialog -->
      <div v-if="showAvatarUploadDialog" class="modal-overlay" @click.self="cancelAvatarUpload">
        <div class="modal-card">
          <h3>上传头像</h3>
          <div class="modal-body">
            <div class="avatar-preview-wrapper">
              <img
                v-if="compressedAvatarFile || avatarFile"
                :src="URL.createObjectURL(compressedAvatarFile || avatarFile)"
                class="avatar-preview-lg"
                alt="预览"
              />
              <span v-else class="muted">请选择图片</span>
            </div>

            <!-- Image Info -->
            <div v-if="originalImageInfo" class="image-info">
              <div class="info-row">
                <span class="info-label">原始:</span>
                <span class="info-value">{{ formatFileSize(originalImageInfo.size) }}</span>
              </div>
              <div v-if="compressedImageInfo" class="info-row">
                <span class="info-label">压缩后:</span>
                <span class="info-value">{{ formatFileSize(compressedImageInfo.size) }}</span>
                <span class="info-badge green">
                  {{ formatCompressionDiff(originalImageInfo.size, compressedImageInfo.size) }}
                </span>
              </div>
            </div>

            <p class="muted small">支持 JPG、PNG 格式，最大 10MB，大图片会自动压缩</p>
          </div>
          <div class="modal-actions">
            <button
              v-if="!compressedAvatarFile && avatarFile"
              class="btn btn-secondary"
              :disabled="compressingAvatar"
              @click="compressAvatarImage"
            >
              {{ compressingAvatar ? "压缩中..." : "手动压缩" }}
            </button>
            <button class="btn btn-secondary" @click="cancelAvatarUpload">取消</button>
            <button
              class="btn"
              :disabled="uploadingAvatar || !compressedAvatarFile"
              @click="uploadAvatar"
            >
              {{ uploadingAvatar ? "上传中..." : "确认上传" }}
            </button>
          </div>
        </div>
      </div>
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
.avatar-preview-lg { width: 120px; height: 120px; border-radius: 50%; object-fit: cover; border: 1px solid var(--border); }
.avatar-row { display: flex; align-items: center; gap: 14px; margin-top: 12px; }
.avatar-actions { display: flex; gap: 8px; }
.avatar-meta { margin-top: 4px; }

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

/* Admin status */
.admin-status-row {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-top: 14px;
  padding-top: 14px;
  border-top: 1px solid var(--border);
}
.admin-status-label { font-size: 14px; font-weight: 600; }

/* Admin controls */
.admin-controls {
  display: flex;
  gap: 8px;
  margin-bottom: 12px;
}

/* Modal */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 2000;
}
.modal-card {
  background: var(--surface);
  border: 1px solid var(--border);
  border-radius: 12px;
  padding: 20px;
  min-width: 400px;
  max-width: 500px;
}
.modal-card h3 { margin: 0 0 16px; font-size: 18px; }
.modal-body { display: flex; flex-direction: column; gap: 14px; margin-bottom: 16px; }
.modal-actions { display: flex; justify-content: flex-end; gap: 8px; }

/* Avatar preview */
.avatar-preview-wrapper {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 120px;
  height: 120px;
  border-radius: 50%;
  background: var(--surface2);
  overflow: hidden;
  margin: 0 auto;
}

/* Image Info */
.image-info {
  background: var(--surface2);
  border-radius: 8px;
  padding: 12px;
  margin-top: 12px;
}
.info-row {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 6px;
  font-size: 13px;
}
.info-label {
  color: var(--muted);
  min-width: 50px;
}
.info-value {
  font-weight: 600;
}
.info-badge {
  padding: 2px 8px;
  border-radius: 12px;
  font-size: 11px;
  margin-left: auto;
}
.info-badge.green {
  background: rgba(46, 158, 91, 0.15);
  color: #2e9e5b;
}
</style>
