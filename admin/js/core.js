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
App.tableListCtx = { cityId: "", search: "" };

/** Flat-list tables: city filter + optional global rows (city_id empty). */
App.TABLE_CITY_FILTERS = {
  attractions: { cityField: "city_id" },
  audio_guides: { cityField: "attraction_id", viaAttraction: true },
  sub_areas: { cityField: "attraction_id", viaAttraction: true },
  checklist_items: { cityField: "city_id", includeGlobal: true },
  home_tips: { cityField: "city_id", includeGlobal: true },
  shopping_items: { cityField: "city_id", includeGlobal: true },
  hotels: { cityField: "city_id" },
};

App.tableFilterStorageKey = function tableFilterStorageKey(table) {
  return `cms_city_filter_${table}`;
};

App.tableTypeFilterStorageKey = function tableTypeFilterStorageKey(table) {
  return `cms_type_filter_${table}`;
};

/** v2 checklist: entry/universal always visible; city rows match city_id or target_cities. */
App.checklistItemMatchesCity = function checklistItemMatchesCity(row, cityId) {
  if (!cityId) return true;
  const type = row.type || "city";
  if (type === "entry" || type === "universal") return true;
  if (row.city_id === cityId) return true;
  const targets = Array.isArray(row.target_cities) ? row.target_cities : [];
  if (!targets.length) return true;
  return targets.includes(cityId);
};

App.filterChecklistRowsByCity = function filterChecklistRowsByCity(rows, cityId) {
  if (!cityId) return rows;
  return rows.filter((r) => App.checklistItemMatchesCity(r, cityId));
};

App.filterChecklistRowsByType = function filterChecklistRowsByType(rows, typeFilter) {
  if (!typeFilter) return rows;
  return rows.filter((r) => (r.type || "city") === typeFilter);
};

App.sanitizeChecklistPayload = function sanitizeChecklistPayload(payload, ctx = {}) {
  const type = payload.type || "city";
  if (type === "entry") {
    payload.city_id = null;
    payload.target_cities = [];
    if (!Array.isArray(payload.target_nationalities)) payload.target_nationalities = [];
  } else if (type === "universal") {
    payload.city_id = null;
    payload.target_cities = [];
    payload.target_nationalities = [];
  } else if (type === "city") {
    payload.target_nationalities = [];
    const targets = Array.isArray(payload.target_cities) ? payload.target_cities.filter(Boolean) : [];
    payload.target_cities = targets;
    if (ctx.fixedCityId && !targets.length) {
      payload.target_cities = [ctx.fixedCityId];
      payload.city_id = ctx.fixedCityId;
    } else {
      if (targets.length && !payload.city_id) payload.city_id = targets[0];
      if (!targets.length && payload.city_id) payload.target_cities = [payload.city_id];
    }
  }
  if (!payload.priority) payload.priority = "recommended";
  if (!payload.type) payload.type = "city";
  if (!Array.isArray(payload.target_nationalities)) payload.target_nationalities = [];
  if (!Array.isArray(payload.external_links)) payload.external_links = [];
  if (!Array.isArray(payload.display_tags)) payload.display_tags = [];
  return payload;
};

App.getChecklistCreateDefaults = function getChecklistCreateDefaults(ctx = {}) {
  const row = {
    type: "universal",
    phase: "before_departure",
    priority: "recommended",
    is_active: true,
    group_title: "Essential Prep",
    target_nationalities: [],
    target_cities: [],
  };
  if (ctx.fixedCityId) {
    const city = App.refCache.cities.find((c) => c.id === ctx.fixedCityId);
    row.type = "city";
    row.city_id = ctx.fixedCityId;
    row.target_cities = [ctx.fixedCityId];
    row.group_title = city?.name || ctx.fixedCityId;
    row.target_nationalities = [];
  }
  return row;
};

/** Intro banner for global checklist_items list (three-tier rules). */
App.checklistArchitectureBannerHtml = function checklistArchitectureBannerHtml() {
  return `<div class="status-bar info checklist-arch-banner">
    <strong>三类清单</strong>：
    <em>入境 entry</em> — 按 <code>target_nationalities</code> 与护照匹配，无需行程；
    <em>通用 universal</em> — 全员可见；
    <em>城市 city</em> — 用户保存行程后，<code>target_cities</code> 与行程城市交集才展示。
    完成度：勾选或 Skip 均计入。城市完成态按行程隔离。
  </div>`;
};

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
  App.client = supabase.createClient(cfg.supabaseUrl, cfg.supabaseAnonKey, {
    auth: {
      persistSession: true,
      autoRefreshToken: true,
      detectSessionInUrl: true,
    },
  });
};

/** Human-readable message for fetch / Storage / PostgREST errors. */
App.formatClientError = function formatClientError(err, context) {
  const label = context || "操作";
  const msg = err?.message || String(err || "");
  if (
    msg === "Failed to fetch" ||
    err?.name === "TypeError" ||
    /networkerror|load failed/i.test(msg)
  ) {
    const origin =
      typeof location !== "undefined" && location.protocol === "file:"
        ? "当前通过本地文件 (file://) 打开页面，浏览器会拦截上传请求。"
        : "网络无法连接 Supabase。";
    return `${label}失败：${origin}请用 \`cd admin && python3 -m http.server 8080\` 打开 http://localhost:8080 ，确认已登录，并检查浏览器是否拦截 *.supabase.co。`;
  }
  if (err?.statusCode === 401 || /jwt|session|not authenticated/i.test(msg)) {
    return `${label}失败：登录已过期，请退出后重新登录。`;
  }
  if (
    err?.statusCode === 403 ||
    /row-level security|permission denied|not allowed/i.test(msg)
  ) {
    return `${label}失败：无 Storage 写入权限。请确认账号在 admin_users 表中，且已执行 012_audio_storage.sql。`;
  }
  if (/invalid mime|mime type|unsupported media/i.test(msg)) {
    return `${label}失败：音频格式不被 Storage 桶接受。请使用 MP3/M4A，并在 Supabase 执行 033_audio_storage_mime_types.sql。`;
  }
  if (/bucket not found|does not exist/i.test(msg)) {
    return `${label}失败：Storage 桶不存在，请在 Supabase SQL Editor 执行 012_audio_storage.sql。`;
  }
  if (/apikey.*invalid|missing or invalid/i.test(msg)) {
    return `${label}失败：API Key 无效。请在 Dashboard → Settings → API Keys 复制 Publishable key 或 Legacy anon key 到 admin/js/config.js。`;
  }
  return msg || `${label}失败`;
};

App.encodeStoragePath = function encodeStoragePath(path) {
  return String(path || "")
    .split("/")
    .map((seg) => encodeURIComponent(seg))
    .join("/");
};

/** Direct Storage REST upload (fallback when supabase-js throws Failed to fetch). */
App.uploadStorageFileViaFetch = async function uploadStorageFileViaFetch(bucket, path, file, contentType) {
  const session = await App.ensureAuthSession();
  const cfg = App.getConfig();
  const base = cfg.supabaseUrl.replace(/\/$/, "");
  const encodedPath = App.encodeStoragePath(path);
  const url = `${base}/storage/v1/object/${encodeURIComponent(bucket)}/${encodedPath}`;
  let res;
  try {
    res = await fetch(url, {
      method: "POST",
      headers: {
        apikey: cfg.supabaseAnonKey,
        Authorization: `Bearer ${session.access_token}`,
        "Content-Type": contentType || file.type || "application/octet-stream",
        "x-upsert": "true",
      },
      body: file,
    });
  } catch (ex) {
    const hint = App.formatClientError(ex, `上传到 ${bucket}`);
    throw new Error(hint);
  }
  if (!res.ok) {
    let body = {};
    try {
      body = await res.json();
    } catch (_) {
      /* ignore */
    }
    const err = new Error(body.message || body.error || res.statusText || `HTTP ${res.status}`);
    err.statusCode = Number(body.statusCode) || res.status;
    throw new Error(App.formatClientError(err, `上传到 ${bucket}`));
  }
  const { data: urlData } = App.client.storage.from(bucket).getPublicUrl(path);
  return urlData.publicUrl;
};

/** Quick check that browser can reach Supabase Storage with current session. */
App.probeStorageAccess = async function probeStorageAccess() {
  try {
    const session = await App.ensureAuthSession();
    const cfg = App.getConfig();
    const res = await fetch(`${cfg.supabaseUrl.replace(/\/$/, "")}/storage/v1/bucket`, {
      headers: {
        apikey: cfg.supabaseAnonKey,
        Authorization: `Bearer ${session.access_token}`,
      },
    });
    if (!res.ok) {
      const body = await res.json().catch(() => ({}));
      return { ok: false, message: body.message || `HTTP ${res.status}` };
    }
    return { ok: true };
  } catch (ex) {
    return { ok: false, message: App.formatClientError(ex, "Storage 连接") };
  }
};

App.isNetworkFetchError = function isNetworkFetchError(err) {
  const msg = err?.message || String(err || "");
  return msg === "Failed to fetch" || err?.name === "TypeError" || /networkerror|load failed/i.test(msg);
};

App.ensureAuthSession = async function ensureAuthSession() {
  const { data, error } = await App.client.auth.getSession();
  if (error) throw error;
  if (!data?.session) {
    throw new Error("登录已过期，请重新登录后再上传");
  }
  const exp = data.session.expires_at;
  if (exp && exp * 1000 < Date.now() + 120_000) {
    const { data: refreshed, error: refreshErr } = await App.client.auth.refreshSession();
    if (refreshErr) throw refreshErr;
    App.session = refreshed.session;
  } else {
    App.session = data.session;
  }
  return App.session;
};

App.normalizeAudioContentType = function normalizeAudioContentType(file) {
  const ext = (file.name.split(".").pop() || "").toLowerCase();
  const raw = (file.type || "").toLowerCase().split(";")[0].trim();
  if (raw && raw !== "application/octet-stream") return raw;
  const byExt = {
    mp3: "audio/mpeg",
    m4a: "audio/mp4",
    mp4: "audio/mp4",
    wav: "audio/wav",
    aac: "audio/aac",
  };
  return byExt[ext] || "audio/mpeg";
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
  const ct = contentType || file.type || "application/octet-stream";
  await App.ensureAuthSession();
  let upErr;
  try {
    ({ error: upErr } = await App.client.storage.from(bucket).upload(path, file, {
      upsert: true,
      contentType: ct,
    }));
  } catch (ex) {
    if (App.isNetworkFetchError(ex)) {
      return App.uploadStorageFileViaFetch(bucket, path, file, ct);
    }
    throw new Error(App.formatClientError(ex, `上传到 ${bucket}`));
  }
  if (upErr) {
    if (App.isNetworkFetchError(upErr)) {
      return App.uploadStorageFileViaFetch(bucket, path, file, ct);
    }
    throw new Error(App.formatClientError(upErr, `上传到 ${bucket}`));
  }
  const { data: urlData } = App.client.storage.from(bucket).getPublicUrl(path);
  return urlData.publicUrl;
};

App.formFileInput = function formFileInput(form, name) {
  if (!form) return null;
  return (
    form.querySelector(`input[type="file"][name="${name}"]`) ||
    (form.elements && form.elements[name]) ||
    null
  );
};

App.uploadAudioGuideFile = async function uploadAudioGuideFile(file, guideId) {
  const ext = (file.name.split(".").pop() || "m4a").toLowerCase().replace(/[^a-z0-9]/g, "") || "m4a";
  const path = `${guideId}.${ext}`;
  return App.uploadStorageFile("audio-guides", path, file, App.normalizeAudioContentType(file));
};

/** Upload sub-area audio directly (no audio_guides row). */
App.uploadSubAreaAudioFile = async function uploadSubAreaAudioFile(file, subAreaId) {
  if (!subAreaId) throw new Error("请先填写子区域英文名后再上传音频");
  const ext = (file.name.split(".").pop() || "m4a").toLowerCase().replace(/[^a-z0-9]/g, "") || "m4a";
  const path = `sub-areas/${subAreaId}.${ext}`;
  return App.uploadStorageFile("audio-guides", path, file, App.normalizeAudioContentType(file));
};

/** Per-attraction audio guide list (city-hub + modals). */
App.attractionGuidesCache = App.attractionGuidesCache || {};

App.fetchAudioGuidesForAttraction = async function fetchAudioGuidesForAttraction(attractionId, opts = {}) {
  if (!attractionId) return [];
  if (!opts.force && App.attractionGuidesCache[attractionId]) {
    return App.attractionGuidesCache[attractionId];
  }
  const { data, error } = await App.client
    .from("audio_guides")
    .select("id,attraction_id,title_en,audio_url,is_active,sort_order")
    .eq("attraction_id", attractionId)
    .order("sort_order", { ascending: true });
  if (error) throw error;
  const guides = data || [];
  App.attractionGuidesCache[attractionId] = guides;
  return guides;
};

/** Update 「当前音频」 preview block (avoids broken URLs from escapeHtml in src). */
App.setAudioPreviewField = function setAudioPreviewField(form, fieldKey, url) {
  if (!form) return;
  const block =
    form.querySelector(`[data-audio-preview-field="${fieldKey}"]`)?.closest(".field-block") ||
    form.querySelector(`input[name="${fieldKey}"]`)?.closest(".field-block");
  if (!block) return;
  const label = block.querySelector("label");
  const labelText = label?.textContent || "当前音频";
  block.innerHTML = "";
  const lbl = document.createElement("label");
  lbl.textContent = labelText;
  block.appendChild(lbl);
  const wrap = document.createElement("div");
  wrap.className = "media-preview";
  wrap.dataset.audioPreviewField = fieldKey;
  if (url) {
    const audio = document.createElement("audio");
    audio.controls = true;
    audio.src = url;
    wrap.appendChild(audio);
    const hidden = document.createElement("input");
    hidden.type = "hidden";
    hidden.name = fieldKey;
    hidden.value = url;
    wrap.appendChild(hidden);
  } else {
    wrap.classList.add("empty");
    wrap.textContent = "暂无音频";
    const hidden = document.createElement("input");
    hidden.type = "hidden";
    hidden.name = fieldKey;
    hidden.value = "";
    wrap.appendChild(hidden);
  }
  block.appendChild(wrap);
};


/** Fill audio_guide_id <select> options (reliable vs innerHTML replace). */
App.populateAudioGuideSelect = function populateAudioGuideSelect(selectEl, guides, opts = {}) {
  if (!selectEl) return;
  const allowEmpty = opts.allowEmpty !== false;
  const emptyLabel = opts.emptyLabel || (allowEmpty ? "— 不关联音频 —" : "— 选择音频导览 —");
  const value = opts.value ?? selectEl.value ?? "";
  const sorted = (guides || [])
    .slice()
    .sort((a, b) => (a.sort_order ?? 0) - (b.sort_order ?? 0));
  let html = `<option value="">${App.escapeHtml(emptyLabel)}</option>`;
  sorted.forEach((g) => {
    html += `<option value="${App.escapeHtml(g.id)}" ${value === g.id ? "selected" : ""}>${App.escapeHtml(g.title_en || g.id)}</option>`;
  });
  if (value && !sorted.some((g) => g.id === value)) {
    html += `<option value="${App.escapeHtml(value)}" selected>${App.escapeHtml(App.audioGuideLabel(value))}</option>`;
  }
  if (opts.attractionId) selectEl.dataset.attractionId = opts.attractionId;
  selectEl.innerHTML = html;
};

/** Resolve sub-area audio_url from pending upload or form field. */
App.resolveSubAreaAudioUrl = function resolveSubAreaAudioUrl(form, area) {
  const pending = form?.dataset?.pendingAudioUrl?.trim();
  if (pending) return pending;
  const hidden = form?.querySelector('[name="audio_url"]')?.value?.trim();
  if (hidden) return hidden;
  return area?.audio_url || "";
};

/** Backfill audio_url from legacy audio_guide_id when column empty. */
App.hydrateSubAreaRowForForm = function hydrateSubAreaRowForForm(row) {
  if (!row) return {};
  const out = { ...row };
  if (out.audio_url?.trim() || !out.audio_guide_id) return out;
  let guide =
    App.refCache?.audioGuides?.find((g) => g.id === out.audio_guide_id) || null;
  if (!guide?.audio_url && out.attraction_id && App.attractionGuidesCache?.[out.attraction_id]) {
    guide = App.attractionGuidesCache[out.attraction_id].find((g) => g.id === out.audio_guide_id) || guide;
  }
  if (guide?.audio_url) out.audio_url = guide.audio_url;
  return out;
};

/** Read duration from a local File or remote URL (seconds, rounded). */
App.probeAudioDurationSeconds = function probeAudioDurationSeconds(source) {
  return new Promise((resolve, reject) => {
    const audio = document.createElement("audio");
    audio.preload = "metadata";
    const cleanup = () => {
      if (source instanceof File) URL.revokeObjectURL(audio.src);
    };
    audio.addEventListener("loadedmetadata", () => {
      const d = audio.duration;
      cleanup();
      if (!Number.isFinite(d) || d <= 0) {
        reject(new Error("无法读取音频时长"));
        return;
      }
      resolve(Math.max(1, Math.round(d)));
    });
    audio.addEventListener("error", () => {
      cleanup();
      reject(new Error("无法读取音频元数据"));
    });
    if (source instanceof File) {
      audio.src = URL.createObjectURL(source);
    } else if (typeof source === "string" && source.trim()) {
      audio.crossOrigin = "anonymous";
      audio.src = source.trim();
    } else {
      reject(new Error("无效的音频源"));
    }
  });
};

/** Apply duration_seconds to a form if the field exists and is empty or force. */
App.applyAudioDurationToForm = function applyAudioDurationToForm(form, seconds, opts = {}) {
  if (!form || !Number.isFinite(seconds)) return;
  const inp = form.querySelector('[name="duration_seconds"]');
  if (!inp) return;
  const current = Number(inp.value);
  if (!opts.force && inp.value?.trim() !== "" && Number.isFinite(current) && current > 0) return;
  inp.value = String(Math.max(1, Math.round(seconds)));
};

/** Bind audio_guides upload — immediate upload + preview refresh (city-hub inline & modals). */
App.setupAudioGuideControls = function setupAudioGuideControls(form, guideId, ctx = {}) {
  const audioInput = App.formFileInput(form, "_audio_upload");
  if (!audioInput || audioInput.dataset.audioGuideSetup === "1") return;
  audioInput.dataset.audioGuideSetup = "1";
  const gid = (guideId || form.querySelector('[name="id"]')?.value || "").trim();
  if (!gid) return;

  App.bindAudioUploadInput(audioInput, {
    form,
    previewFieldKey: "audio_url",
    onUpload: async (file) => {
      const audioUrl = await App.uploadAudioGuideFile(file, gid);
      form.dataset.pendingAudioUrl = audioUrl;
      App.setAudioPreviewField(form, "audio_url", audioUrl);
      try {
        const seconds = await App.probeAudioDurationSeconds(file);
        App.applyAudioDurationToForm(form, seconds);
      } catch (_) {
        /* duration optional */
      }
      const saveHint = form.classList.contains("audio-guide-inline-form")
        ? "音频已上传，请点击「保存此导览」"
        : "音频已上传，请点击「保存」";
      App.showToast(saveHint);
      if (typeof ctx.onUploaded === "function") {
        ctx.onUploaded({ audioUrl, guideId: gid });
      }
      return { audioUrl, guideId: gid };
    },
  });
};

/** Bind sub-area direct audio upload (modal and city-hub inline forms). */
App.setupSubAreaAudioControls = function setupSubAreaAudioControls(form, ctx = {}) {
  const saAudioInput = App.formFileInput(form, "_sa_audio_upload");
  if (!saAudioInput || saAudioInput.dataset.subAreaAudioSetup === "1") return;
  saAudioInput.dataset.subAreaAudioSetup = "1";

  const resolveSubAreaId = () => {
    const nameEn = form.querySelector('[name="name_en"]')?.value?.trim();
    return (
      form.querySelector('[name="id"]')?.value?.trim() ||
      (nameEn ? App.slugify(nameEn, "area") : "")
    );
  };

  App.bindAudioUploadInput(saAudioInput, {
    form,
    previewFieldKey: "audio_url",
    onUpload: async (file) => {
      const subAreaId = resolveSubAreaId();
      if (!subAreaId) throw new Error("请先填写子区域英文名");
      const audioUrl = await App.uploadSubAreaAudioFile(file, subAreaId);
      form.dataset.pendingAudioUrl = audioUrl;
      App.setAudioPreviewField(form, "audio_url", audioUrl);
      try {
        const seconds = await App.probeAudioDurationSeconds(file);
        App.applyAudioDurationToForm(form, seconds);
      } catch (_) {
        /* duration on sub_areas N/A — guides table only */
      }
      const saveHint = form.classList.contains("sub-area-inline-form")
        ? "音频已上传，请点击「保存子区域」"
        : "音频已上传，请点击「保存」";
      App.showToast(saveHint);
      if (typeof ctx.onUploaded === "function") {
        ctx.onUploaded({ audioUrl, subAreaId });
      }
      return { audioUrl };
    },
  });
};

App.uploadCoverImage = async function uploadCoverImage(file, folder, entityId) {
  const ext = (file.name.split(".").pop() || "jpg").toLowerCase();
  const path = `${folder}/${entityId}.${ext}`;
  return App.uploadStorageFile("cover-images", path, file, file.type || "image/jpeg");
};

/** Gallery / inline content images — unique path per file under entity folder. */
App.uploadGalleryImage = async function uploadGalleryImage(file, folder, entityId, uniqueKey) {
  const ext = (file.name.split(".").pop() || "jpg").toLowerCase();
  const safeKey = String(uniqueKey || Date.now())
    .replace(/[^a-zA-Z0-9_-]/g, "_")
    .slice(0, 64);
  const path = `${folder}/${entityId}/${safeKey}.${ext}`;
  return App.uploadStorageFile("cover-images", path, file, file.type || "image/jpeg");
};

App.collectImageUrlList = async function collectImageUrlList(form, field, entityId) {
  const box = form.querySelector(`[data-name="${field.key}"]`);
  if (!box) return [];
  const folder = field.uploadFolder || box.dataset.uploadFolder || "misc";
  const urls = [];
  const rows = App.$$(".list-row--image", box);
  for (let i = 0; i < rows.length; i++) {
    const row = rows[i];
    const fileInput = App.$(".image-file-input", row);
    const urlInput = App.$(".image-url-input", row);
    if (fileInput?.files?.[0]) {
      if (!entityId) throw new Error("请先填写名称后再上传图片");
      const url = await App.uploadGalleryImage(
        fileInput.files[0],
        folder,
        entityId,
        `img_${Date.now()}_${i}`
      );
      urls.push(url);
    } else {
      const u = urlInput?.value?.trim();
      if (u) urls.push(u);
    }
  }
  return urls;
};

App.inferContentBlockType = function inferContentBlockType(item) {
  if (!item || typeof item !== "object") return "paragraph";
  const raw = (item.type || "").toLowerCase();
  if (raw === "heading" || raw === "paragraph" || raw === "image") return raw;
  if (item.imagePath || item.image_path) return "image";
  if (item.title && !item.body) return "heading";
  return "paragraph";
};

App.collectContentBlocks = async function collectContentBlocks(form, field, entityId) {
  const box = form.querySelector(`[data-name="${field.key}"]`);
  if (!box) return [];
  const folder = field.uploadFolder || box.dataset.uploadFolder || "sub-areas";
  const blocks = [];
  const rows = App.$$(".list-row--content-block", box);
  for (let i = 0; i < rows.length; i++) {
    const row = rows[i];
    const blockType = App.$('[data-field="block_type"]', row)?.value || "paragraph";
    if (blockType === "image") {
      const fileInput = App.$(".block-image-file", row);
      const urlInput = App.$('[data-field="image_path"]', row);
      const title = App.$('[data-field="title"]', row)?.value?.trim() || "";
      let imagePath = urlInput?.value?.trim() || "";
      if (fileInput?.files?.[0]) {
        if (!entityId) throw new Error("请先填写名称后再上传图片");
        imagePath = await App.uploadGalleryImage(
          fileInput.files[0],
          folder,
          entityId,
          `block_${i}_${Date.now()}`
        );
      }
      if (imagePath) {
        const block = { type: "image", imagePath };
        if (title) block.title = title;
        blocks.push(block);
      }
    } else if (blockType === "heading") {
      const title = App.$('[data-field="title"]', row)?.value?.trim() || "";
      if (title) blocks.push({ type: "heading", title });
    } else {
      const body = App.readContentBlockBody(row);
      if (body) blocks.push({ type: "paragraph", body });
    }
  }
  return blocks;
};

/** Keep only real DB columns (avoids 400 from PostgREST on stray form keys). */
App.TABLE_COLUMNS = {
  sub_areas: [
    "id",
    "attraction_id",
    "name_en",
    "name_zh",
    "cover_image_path",
    "content_blocks",
    "body",
    "audio_url",
    "audio_guide_id",
    "sort_order",
    "is_active",
    "updated_at",
  ],
};

App.sanitizePayloadForTable = function sanitizePayloadForTable(payload, table, opts = {}) {
  const allowed = App.TABLE_COLUMNS[table];
  if (!allowed) return payload;
  const out = {};
  for (const key of allowed) {
    if (payload[key] === undefined) continue;
    let v = payload[key];
    if (key === "audio_guide_id" && (v === "" || v === null)) {
      v = null;
    }
    out[key] = v;
  }
  if (opts.omitId) delete out.id;
  return out;
};

/** Fill NOT NULL numeric columns when the form left them empty (omit null so DB default applies). */
App.fillTableDefaults = function fillTableDefaults(payload, table) {
  if (!table) return payload;
  const defaults = {
    attractions: { audio_guide_count: 0, display_order: 0, is_published: true, category: "sight", priority: "P1" },
    cities: { attraction_count: 0, display_order: 0, is_published: true },
    audio_guides: { duration_seconds: 0, sort_order: 0, is_active: true },
    sub_areas: { sort_order: 0, is_active: true },
    checklist_items: { sort_order: 0, is_active: true, priority: "recommended", type: "universal" },
    home_tips: { sort_order: 0 },
    shopping_items: { sort_order: 0 },
    reading_list: { sort_order: 0 },
    hotels: { sort_order: 0, is_active: true, accepts_foreigners: true, stars: 4, price_min_usd: 0 },
    culture_tips: { sort_order: 0 },
    assistant_scenarios: { sort_order: 0 },
    assistant_chips: { sort_order: 0 },
    content_itineraries: { sort_order: 0 },
    user_itineraries: { is_deleted: false },
    passport_countries: { display_order: 0 },
  };
  const tableDefaults = defaults[table];
  if (!tableDefaults) return payload;
  for (const [key, value] of Object.entries(tableDefaults)) {
    if (payload[key] === null || payload[key] === undefined) {
      payload[key] = value;
    }
  }
  return payload;
};

/** Flatten user_itineraries.payload for the itinerary_builder form. */
App.hydrateUserItineraryRow = function hydrateUserItineraryRow(row) {
  if (!row) return {};
  let payload = row.payload;
  if (typeof payload === "string") {
    try {
      payload = JSON.parse(payload);
    } catch {
      payload = {};
    }
  }
  payload = payload || {};
  return {
    ...row,
    title: row.title || payload.title || "",
    meta: payload.meta || "",
    route_summary: payload.route_summary || "",
    estimated_budget: payload.estimated_budget || "",
    days: Array.isArray(payload.days) ? payload.days : [],
  };
};

/** Merge itinerary_builder days back into payload JSONB. */
App.packUserItineraryPayload = function packUserItineraryPayload(payload, row) {
  const days = payload.days;
  delete payload.days;
  let existing = row?.payload || {};
  if (typeof existing === "string") {
    try {
      existing = JSON.parse(existing);
    } catch {
      existing = {};
    }
  }
  const cities = Array.isArray(payload.cities) ? payload.cities : existing.cities || [];
  const metaText = payload.meta ?? existing.meta ?? "";
  const routeSummary =
    payload.route_summary || existing.route_summary || (cities.length ? cities.join(" · ") : "");
  const estimatedBudget = payload.estimated_budget ?? existing.estimated_budget ?? "";
  delete payload.meta;
  delete payload.route_summary;
  delete payload.estimated_budget;
  payload.payload = {
    ...existing,
    id: existing.id || payload.id,
    title: payload.title || existing.title || "",
    meta: metaText,
    route_summary: routeSummary,
    estimated_budget: estimatedBudget,
    days: days || [],
  };
  return payload;
};

/** Keep attractions.audio_guide_count in sync with active audio_guides rows. */
App.syncAttractionAudioGuideCount = async function syncAttractionAudioGuideCount(attractionId) {
  if (!attractionId || !App.client) return;
  const { count, error } = await App.client
    .from("audio_guides")
    .select("id", { count: "exact", head: true })
    .eq("attraction_id", attractionId)
    .eq("is_active", true);
  if (error) throw error;
  const { error: updateErr } = await App.client
    .from("attractions")
    .update({
      audio_guide_count: count ?? 0,
      updated_at: new Date().toISOString(),
    })
    .eq("id", attractionId);
  if (updateErr) throw updateErr;
};
