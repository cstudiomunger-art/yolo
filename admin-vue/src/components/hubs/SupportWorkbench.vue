<script setup>
import { ref, computed, onMounted } from "vue";
import { supabase } from "@/lib/supabase";
import { uploadAgentAvatar } from "@/lib/storage";
import { useRefCache } from "@/stores/refCache";

const refCache = useRefCache();

const agents = ref([]);
const conversations = ref([]);
const error = ref("");
const toast = ref("");
function showToast(m) { toast.value = m; setTimeout(() => (toast.value = ""), 1800); }

// filters
const statusFilter = ref("open"); // open / closed / ""(all)
const emergencyOnly = ref(false);
const search = ref("");
const openAgents = ref({}); // agentId|"_none" → expanded

// selected conversation thread
const activeId = ref("");
const messages = ref([]);
const loadingThread = ref(false);

// Agent editing
const showAgentDialog = ref(false);
const editingAgent = ref(null);
const agentAvatarFile = ref(null);
const agentAvatarInput = ref(null);
const savingAgent = ref(false);
const uploadingAgentAvatar = ref(false);

const STATUS_LABEL = { open: "进行中", closed: "已关闭" };
const AGENT_STATUS = {
  online: { cls: "green", label: "在线" },
  busy: { cls: "yellow", label: "忙碌" },
  offline: { cls: "gray", label: "离线" },
};

async function loadAll() {
  error.value = "";
  await refCache.load();
  const [ag, cv] = await Promise.all([
    supabase.from("support_agents").select("id,name,role,status,avatar_url,is_active,display_order").order("display_order"),
    supabase.from("support_conversations").select("id,user_id,agent_id,priority,status,context_json,created_at,updated_at").order("updated_at", { ascending: false }),
  ]);
  if (ag.error) error.value = ag.error.message;
  if (cv.error) error.value = cv.error.message;
  agents.value = ag.data || [];
  conversations.value = cv.data || [];
  // default-expand every agent group on first load
  if (!Object.keys(openAgents.value).length) {
    agents.value.forEach((a) => (openAgents.value[a.id] = true));
    openAgents.value._none = true;
  }
}

function userEmail(id) { return refCache.userLabel(id); }
function fmtTime(d) { return d ? new Date(d).toLocaleString("zh-CN") : ""; }

// conversations after filters
const filteredConvos = computed(() => {
  let r = conversations.value;
  if (statusFilter.value) r = r.filter((c) => c.status === statusFilter.value);
  if (emergencyOnly.value) r = r.filter((c) => c.priority === "emergency");
  const q = search.value.trim().toLowerCase();
  if (q) r = r.filter((c) => userEmail(c.user_id).toLowerCase().includes(q) || (c.id || "").toLowerCase().includes(q));
  return r;
});

// group by agent → { agent, convos } plus an unassigned bucket
const groups = computed(() => {
  const byAgent = {};
  filteredConvos.value.forEach((c) => {
    const key = c.agent_id || "_none";
    (byAgent[key] = byAgent[key] || []).push(c);
  });
  const out = agents.value
    .map((a) => ({ key: a.id, agent: a, convos: byAgent[a.id] || [] }))
    .filter((g) => g.convos.length || g.agent.is_active);
  if (byAgent._none?.length) out.push({ key: "_none", agent: null, convos: byAgent._none });
  return out;
});

const activeConvo = computed(() => conversations.value.find((c) => c.id === activeId.value) || null);
const activeContext = computed(() => {
  const cj = activeConvo.value?.context_json;
  if (!cj) return "";
  try { return typeof cj === "string" ? cj : JSON.stringify(cj, null, 2); } catch { return String(cj); }
});

const activeAgentId = computed({
  get: () => activeConvo.value?.agent_id || "",
  set: (v) => reassign(v || null),
});

async function selectConvo(c) {
  activeId.value = c.id;
  loadingThread.value = true;
  messages.value = [];
  const { data, error: e } = await supabase
    .from("support_messages")
    .select("id,sender_type,body_original,body_translated,image_url,created_at")
    .eq("conversation_id", c.id)
    .order("created_at", { ascending: true });
  if (e) { error.value = e.message; loadingThread.value = false; return; }
  const rows = data || [];
  // resolve private chat-image paths → signed URLs for preview
  await Promise.all(rows.map(async (m) => {
    if (m.image_url && !/^https?:\/\//.test(m.image_url)) {
      const { data: signed } = await supabase.storage.from("chat-images").createSignedUrl(m.image_url, 3600);
      m._img = signed?.signedUrl || "";
    } else {
      m._img = m.image_url || "";
    }
  }));
  messages.value = rows;
  loadingThread.value = false;
}

async function reassign(agentId) {
  if (!activeConvo.value) return;
  const { error: e } = await supabase.from("support_conversations").update({ agent_id: agentId }).eq("id", activeConvo.value.id);
  if (e) { showToast("改派失败：" + e.message); return; }
  activeConvo.value.agent_id = agentId;
  showToast(agentId ? "已改派坐席" : "已取消指派");
}

async function toggleStatus() {
  const c = activeConvo.value;
  if (!c) return;
  const next = c.status === "open" ? "closed" : "open";
  if (!confirm(next === "closed" ? "关闭该会话？" : "重新开启该会话？")) return;
  const { error: e } = await supabase.from("support_conversations")
    .update({ status: next, updated_at: new Date().toISOString() }).eq("id", c.id);
  if (e) { showToast("失败：" + e.message); return; }
  c.status = next;
  showToast(next === "closed" ? "会话已关闭" : "会话已重开");
}

function toggleAgent(key) { openAgents.value[key] = !openAgents.value[key]; }

// ═══════════════════════════════════════════════════════════════
// Agent Management Functions
// ═══════════════════════════════════════════════════════════════
function openAgentDialog(agent = null) {
  if (agent) {
    editingAgent.value = { ...agent, languages: [...(agent.languages || [])] };
  } else {
    editingAgent.value = {
      id: null,
      name: "",
      role: "",
      status: "offline",
      languages: [],
      display_order: agents.value.length,
      is_active: true,
    };
  }
  showAgentDialog.value = true;
}

function closeAgentDialog() {
  showAgentDialog.value = false;
  editingAgent.value = null;
  agentAvatarFile.value = null;
}

function triggerAgentAvatarUpload() {
  agentAvatarInput.value?.click();
}

function onAgentAvatarFileChange(e) {
  const file = e.target.files?.[0];
  if (!file) return;
  if (!file.type.startsWith("image/")) {
    showToast("请选择图片文件");
    return;
  }
  if (file.size > 5 * 1024 * 1024) {
    showToast("图片大小不能超过 5MB");
    return;
  }
  agentAvatarFile.value = file;
}

async function uploadAgentAvatarToServer() {
  if (!agentAvatarFile.value || !editingAgent.value?.id) return null;
  uploadingAgentAvatar.value = true;
  try {
    const url = await uploadAgentAvatar(agentAvatarFile.value, editingAgent.value.id);
    return url;
  } catch (e) {
    showToast("头像上传失败：" + (e.message || e));
    return null;
  } finally {
    uploadingAgentAvatar.value = false;
  }
}

async function saveAgent() {
  const a = editingAgent.value;
  if (!a) return;
  if (!a.name.trim()) {
    showToast("请填写姓名");
    return;
  }

  savingAgent.value = true;
  try {
    // Upload avatar if new file selected
    let avatarUrl = a.avatar_url;
    if (agentAvatarFile.value && a.id) {
      const uploaded = await uploadAgentAvatarToServer();
      if (uploaded) avatarUrl = uploaded;
    }

    const data = {
      name: a.name.trim(),
      role: a.role?.trim() || "",
      status: a.status || "offline",
      languages: a.languages || [],
      avatar_url: avatarUrl || "",
      display_order: a.display_order || 0,
      is_active: a.is_active !== false,
    };

    let result;
    if (a.id) {
      // Update existing agent
      result = await supabase.from("support_agents").update(data).eq("id", a.id);
    } else {
      // Create new agent - requires user_id
      showToast("新客服需先在用户详情中添加");
      closeAgentDialog();
      return;
    }

    if (result.error) throw result.error;
    showToast("保存成功");
    closeAgentDialog();
    await loadAll();
  } catch (e) {
    showToast("失败：" + (e.message || e));
  } finally {
    savingAgent.value = false;
  }
}

async function deleteAgent(agent) {
  if (!confirm(`确认删除客服「${agent.name}」？`)) return;
  try {
    const { error: e } = await supabase.from("support_agents").delete().eq("id", agent.id);
    if (e) throw e;
    showToast("已删除");
    await loadAll();
  } catch (e) {
    showToast("失败：" + (e.message || e));
  }
}

onMounted(loadAll);
</script>

<template>
  <div class="sw">
    <div v-if="error" class="status-bar error">{{ error }}</div>

    <div class="split">
      <!-- ── left: agent tree ── -->
      <aside class="tree">
        <div class="filters">
          <select v-model="statusFilter">
            <option value="open">进行中</option>
            <option value="closed">已关闭</option>
            <option value="">全部状态</option>
          </select>
          <label class="chk"><input type="checkbox" v-model="emergencyOnly" /> 仅紧急</label>
          <button class="btn btn-secondary btn-sm" @click="loadAll">刷新</button>
        </div>
        <input v-model="search" class="search" type="search" placeholder="搜用户邮箱…" />

        <div v-for="g in groups" :key="g.key" class="agroup">
          <button class="ahead" @click="toggleAgent(g.key)">
            <span class="caret" :class="{ open: openAgents[g.key] }">▶</span>
            <template v-if="g.agent">
              <span class="dot" :class="(AGENT_STATUS[g.agent.status] || {}).cls"></span>
              <span class="aname">{{ g.agent.name || "(未命名坐席)" }}</span>
              <span class="muted role" v-if="g.agent.role">· {{ g.agent.role }}</span>
            </template>
            <span v-else class="aname">未分配</span>
            <span class="cnt">{{ g.convos.length }}</span>
          </button>

          <div v-show="openAgents[g.key]" class="convos">
            <button
              v-for="c in g.convos"
              :key="c.id"
              class="crow"
              :class="{ active: c.id === activeId }"
              @click="selectConvo(c)"
            >
              <div class="cmain">
                <span v-if="c.priority === 'emergency'" class="badge red sos">SOS</span>
                <span class="cuser">{{ userEmail(c.user_id) }}</span>
              </div>
              <div class="cmeta">
                <span class="badge" :class="c.status === 'open' ? 'blue' : 'gray'">{{ STATUS_LABEL[c.status] || c.status }}</span>
                <span class="muted small">{{ fmtTime(c.updated_at) }}</span>
              </div>
            </button>
            <p v-if="!g.convos.length" class="muted small empty">无会话</p>
          </div>
        </div>
        <p v-if="!groups.length" class="muted">无匹配会话</p>
      </aside>

      <!-- ── right: thread ── -->
      <section class="thread">
        <template v-if="activeConvo">
          <header class="thead">
            <div class="tinfo">
              <strong>{{ userEmail(activeConvo.user_id) }}</strong>
              <span v-if="activeConvo.priority === 'emergency'" class="badge red">紧急 SOS</span>
              <span class="badge" :class="activeConvo.status === 'open' ? 'blue' : 'gray'">{{ STATUS_LABEL[activeConvo.status] }}</span>
            </div>
            <div class="tactions">
              <select v-model="activeAgentId" title="改派坐席">
                <option value="">未分配</option>
                <option v-for="a in agents" :key="a.id" :value="a.id">{{ a.name || a.id }}</option>
              </select>
              <button class="btn btn-sm" :class="{ 'btn-secondary': activeConvo.status === 'open', 'btn-danger': false }" @click="toggleStatus">
                {{ activeConvo.status === "open" ? "关闭会话" : "重开会话" }}
              </button>
            </div>
          </header>

          <details v-if="activeContext" class="ctx">
            <summary>会话上下文 context_json</summary>
            <pre>{{ activeContext }}</pre>
          </details>

          <div class="msgs">
            <div v-if="loadingThread" class="muted">加载消息…</div>
            <template v-else>
              <div v-for="m in messages" :key="m.id" class="msg" :class="m.sender_type === 'agent' ? 'me' : 'them'">
                <div class="bubble">
                  <div v-if="m.body_original" class="orig">{{ m.body_original }}</div>
                  <div v-if="m.body_translated" class="trans">译：{{ m.body_translated }}</div>
                  <a v-if="m._img" :href="m._img" target="_blank" rel="noopener"><img :src="m._img" class="cimg" alt="" /></a>
                </div>
                <div class="ts muted small">{{ m.sender_type === "agent" ? "客服" : "用户" }} · {{ fmtTime(m.created_at) }}</div>
              </div>
              <p v-if="!messages.length" class="muted">该会话暂无消息</p>
            </template>
          </div>
        </template>
        <div v-else class="placeholder muted">← 从左侧选择一个会话查看聊天记录</div>
      </section>
    </div>

    <!-- Agent Edit Dialog -->
    <div v-if="showAgentDialog" class="modal-overlay" @click.self="closeAgentDialog">
      <div class="modal-card">
        <h3>{{ editingAgent?.id ? "编辑客服" : "新客服" }}</h3>
        <div class="modal-body">
          <div class="avatar-upload-wrapper">
            <img v-if="editingAgent?.avatar_url || agentAvatarFile"
                 :src="agentAvatarFile ? URL.createObjectURL(agentAvatarFile) : editingAgent.avatar_url"
                 class="avatar-preview-lg" alt="头像" />
            <span v-else class="avatar-placeholder">头像</span>
            <input ref="agentAvatarInput" type="file" accept="image/*" hidden @change="onAgentAvatarFileChange" />
            <button class="btn btn-secondary btn-sm" @click="triggerAgentAvatarUpload">
              {{ uploadingAgentAvatar ? "上传中..." : "更换" }}
            </button>
          </div>
          <div class="fgrid">
            <label class="f">
              <span>姓名</span>
              <input v-model="editingAgent.name" type="text" />
            </label>
            <label class="f">
              <span>线路/专长</span>
              <input v-model="editingAgent.role" type="text" placeholder="如 北京 · 签证" />
            </label>
            <label class="f">
              <span>状态</span>
              <select v-model="editingAgent.status">
                <option value="online">在线</option>
                <option value="busy">忙碌</option>
                <option value="offline">离线</option>
              </select>
            </label>
            <label class="f">
              <span>排序</span>
              <input v-model.number="editingAgent.display_order" type="number" />
            </label>
          </div>
          <label class="chk">
            <input type="checkbox" v-model="editingAgent.is_active" />
            启用
          </label>
        </div>
        <div class="modal-actions">
          <button v-if="editingAgent?.id" class="btn btn-danger" @click="deleteAgent(editingAgent)">删除</button>
          <button class="btn btn-secondary" @click="closeAgentDialog">取消</button>
          <button class="btn" :disabled="savingAgent" @click="saveAgent">
            {{ savingAgent ? "保存中..." : "保存" }}
          </button>
        </div>
      </div>
    </div>

    <div class="toast" :class="{ on: toast }">{{ toast }}</div>
  </div>
</template>

<style scoped>
.sw h1 { margin: 0 0 12px; font-size: 20px; }
.split { display: flex; gap: 16px; align-items: flex-start; }

/* left tree */
.tree { width: 320px; flex: none; border: 1px solid var(--border); border-radius: 12px; padding: 12px; background: var(--surface); max-height: calc(100vh - 140px); overflow: auto; }
.filters { display: flex; gap: 8px; align-items: center; margin-bottom: 8px; }
.filters select { width: auto; flex: 1; }
.tree .search { width: 100%; margin-bottom: 10px; }
.chk { display: inline-flex; align-items: center; gap: 4px; font-size: 13px; color: var(--muted); white-space: nowrap; }
.chk input { width: auto; }

.agroup { margin-bottom: 2px; }
.ahead { width: 100%; display: flex; align-items: center; gap: 6px; background: transparent; border: none; color: var(--text); font-weight: 600; padding: 7px 6px; cursor: pointer; font-size: 14px; }
.ahead .role { font-weight: 400; font-size: 12px; }
.ahead .cnt { margin-left: auto; color: var(--muted); font-size: 12px; }
.caret { font-size: 9px; color: var(--muted); transition: transform 0.12s; width: 10px; }
.caret.open { transform: rotate(90deg); }
.dot { width: 8px; height: 8px; border-radius: 50%; background: var(--muted); flex: none; }
.dot.green { background: #2e9e5b; }
.dot.yellow { background: #d49a16; }
.dot.gray { background: #9aa7b6; }

.convos { padding-left: 8px; }
.crow { width: 100%; text-align: left; background: transparent; border: none; border-radius: 8px; padding: 7px 8px; cursor: pointer; display: block; }
.crow:hover { background: var(--surface2); }
.crow.active { background: var(--surface2); border-left: 3px solid var(--accent); }
.cmain { display: flex; align-items: center; gap: 6px; }
.cuser { font-size: 13px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
.cmeta { display: flex; align-items: center; gap: 6px; margin-top: 3px; }
.empty { padding: 4px 8px; }

/* right thread */
.thread { flex: 1; border: 1px solid var(--border); border-radius: 12px; background: var(--surface); min-height: 420px; display: flex; flex-direction: column; max-height: calc(100vh - 140px); }
.thead { display: flex; align-items: center; justify-content: space-between; gap: 12px; padding: 14px 16px; border-bottom: 1px solid var(--border); flex-wrap: wrap; }
.tinfo { display: flex; align-items: center; gap: 8px; }
.tactions { display: flex; align-items: center; gap: 8px; }
.tactions select { width: auto; min-width: 130px; }
.ctx { margin: 10px 16px 0; font-size: 12px; }
.ctx pre { background: var(--surface2); padding: 10px; border-radius: 8px; overflow: auto; max-height: 160px; }
.msgs { padding: 16px; overflow: auto; flex: 1; }
.msg { margin-bottom: 14px; display: flex; flex-direction: column; max-width: 72%; }
.msg.them { align-items: flex-start; margin-right: auto; }
.msg.me { align-items: flex-end; margin-left: auto; }
.bubble { padding: 9px 12px; border-radius: 12px; background: var(--surface2); font-size: 14px; white-space: pre-wrap; word-break: break-word; }
.msg.me .bubble { background: rgba(196, 92, 38, 0.14); }
.trans { margin-top: 4px; font-size: 12px; color: var(--muted); border-top: 1px dashed var(--border); padding-top: 4px; }
.cimg { max-width: 220px; border-radius: 8px; margin-top: 6px; display: block; }
.ts { margin-top: 3px; }
.placeholder { padding: 60px 20px; text-align: center; }

/* badges */
.badge { display: inline-block; padding: 2px 8px; border-radius: 12px; font-size: 12px; background: var(--surface2); color: var(--muted); white-space: nowrap; }
.badge.green { background: rgba(46, 158, 91, 0.15); color: #2e9e5b; }
.badge.red { background: rgba(192, 57, 43, 0.15); color: #c0392b; }
.badge.yellow { background: rgba(212, 154, 22, 0.18); color: #b5810a; }
.badge.blue { background: rgba(58, 120, 194, 0.15); color: #3a78c2; }
.badge.gray { background: var(--surface2); color: var(--muted); }
.sos { font-weight: 700; }

.muted { color: var(--muted); }
.small { font-size: 11px; }
.toast { position: fixed; bottom: 26px; left: 50%; transform: translateX(-50%); background: var(--text); color: var(--bg); padding: 10px 18px; border-radius: 8px; font-size: 13px; opacity: 0; pointer-events: none; transition: opacity 0.2s; z-index: 1100; }
.toast.on { opacity: 1; }

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

/* Avatar upload */
.avatar-upload-wrapper {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
  padding: 16px;
  background: var(--surface2);
  border-radius: 12px;
}
.avatar-preview-lg {
  width: 80px;
  height: 80px;
  border-radius: 50%;
  object-fit: cover;
  border: 2px solid var(--border);
}
.avatar-placeholder {
  width: 80px;
  height: 80px;
  border-radius: 50%;
  background: var(--border);
  display: flex;
  align-items: center;
  justify-content: center;
  color: var(--muted);
}

/* Form */
.fgrid { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
.f { display: block; font-size: 12px; color: var(--muted); }
.f input, .f select { margin-top: 4px; width: 100%; }
</style>