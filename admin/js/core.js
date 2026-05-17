/* global supabase */
/* ChinaGo Admin — core utilities, auth, Supabase client */

window.ChinaGoAdmin = window.ChinaGoAdmin || {};

const App = window.ChinaGoAdmin;

App.client = null;
App.session = null;
App.currentTable = "city_hub";
App.currentView = "city_hub";
App.cityHubCityId = null;
App.attractionEditId = null;
App.editingRow = null;

App.$ = function $(sel, root) {
  return (root || document).querySelector(sel);
};

App.$$ = function $$(sel, root) {
  return Array.from((root || document).querySelectorAll(sel));
};

App.showToast = function showToast(msg, type = "success") {
  const el = document.createElement("div");
  el.className = `toast ${type}`;
  el.textContent = msg;
  document.body.appendChild(el);
  setTimeout(() => el.remove(), 3500);
};

App.escapeHtml = function escapeHtml(s) {
  return String(s)
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;");
};

App.getConfig = function getConfig() {
  const c = window.CHINAGO_ADMIN_CONFIG;
  if (!c?.supabaseUrl || !c?.supabaseAnonKey) {
    throw new Error("请复制 admin/js/config.example.js 为 config.js 并填写 Supabase URL 与 Anon Key");
  }
  if (c.supabaseUrl.includes("你的项目")) {
    throw new Error("请在 admin/js/config.js 中填写真实的 Supabase 配置");
  }
  return c;
};

App.initClient = function initClient() {
  const cfg = App.getConfig();
  App.client = supabase.createClient(cfg.supabaseUrl, cfg.supabaseAnonKey);
};

App.checkIsAdmin = async function checkIsAdmin(userId) {
  const { data, error } = await App.client
    .from("admin_users")
    .select("user_id")
    .eq("user_id", userId)
    .maybeSingle();
  if (error) throw error;
  return !!data;
};

App.refreshSession = async function refreshSession() {
  const { data } = await App.client.auth.getSession();
  App.session = data.session;
  return App.session;
};

App.showLogin = function showLogin() {
  App.$("#login-screen").classList.remove("hidden");
  App.$("#app-screen").classList.add("hidden");
};

App.showApp = function showApp(email) {
  App.$("#login-screen").classList.add("hidden");
  App.$("#app-screen").classList.remove("hidden");
  App.$("#user-email").textContent = email || "";
};

App.slugify = function slugify(text, prefix) {
  const part = String(text || "")
    .toLowerCase()
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .replace(/[^a-z0-9]+/g, "_")
    .replace(/^_+|_+$/g, "");
  if (prefix) return `${prefix}_${part}`.replace(/__+/g, "_");
  return part || "item";
};

App.uploadStorageFile = async function uploadStorageFile(bucket, path, file, contentType) {
  const { error: upErr } = await App.client.storage.from(bucket).upload(path, file, {
    upsert: true,
    contentType: contentType || file.type,
  });
  if (upErr) throw upErr;
  const { data: urlData } = App.client.storage.from(bucket).getPublicUrl(path);
  return urlData.publicUrl;
};

App.uploadAudioGuideFile = async function uploadAudioGuideFile(file, guideId) {
  const ext = file.name.split(".").pop() || "m4a";
  const path = `${guideId}.${ext}`;
  return App.uploadStorageFile("audio-guides", path, file, file.type || "audio/mpeg");
};

App.uploadCoverImage = async function uploadCoverImage(file, folder, entityId) {
  const ext = (file.name.split(".").pop() || "jpg").toLowerCase();
  const path = `${folder}/${entityId}.${ext}`;
  return App.uploadStorageFile("cover-images", path, file, file.type || "image/jpeg");
};
