/* global supabase */

const TABLES = {
  app_settings: {
    label: "应用配置",
    single: true,
    pk: "id",
    order: null,
    fields: [
      { key: "id", type: "text", readonly: true },
      { key: "use_remote_content", type: "bool", label: "远程内容（Live Services）" },
      { key: "use_remote_ai", type: "bool", label: "远程 AI" },
      { key: "use_remote_iap", type: "bool", label: "远程内购" },
      { key: "support_email", type: "text", label: "反馈邮箱" },
      { key: "about_title", type: "text", label: "关于 · 标题" },
      { key: "about_version", type: "text", label: "关于 · 版本号" },
      { key: "about_body", type: "textarea", label: "关于 · 简介" },
      { key: "iap_pro_title", type: "text", label: "内购 · Pro 标题" },
      { key: "iap_pro_price", type: "text", label: "内购 · Pro 价格文案" },
      { key: "iap_pro_trial_text", type: "text", label: "内购 · 试用文案" },
      { key: "iap_pro_features", type: "textarea", label: "内购 · Pro 权益（每行一条）" },
      { key: "iap_single_price_label", type: "text", label: "内购 · 单购按钮文案" },
      { key: "assistant_greeting_general", type: "textarea", label: "助手 · 通用问候" },
      { key: "assistant_greeting_planning", type: "textarea", label: "助手 · 规划问候" },
      { key: "plan_alert_message", type: "textarea", label: "Plan · 顶部警告文案" },
      { key: "plan_alert_link_attraction_id", type: "text", label: "Plan · 警告链接 attraction_id" },
      { key: "plan_alert_link_city_id", type: "text", label: "Plan · 警告链接 city_id" },
      { key: "plan_alert_link_label", type: "text", label: "Plan · 警告链接按钮文案" },
      { key: "free_audio_preview_seconds", type: "number", label: "音频 · 免费试听秒数" },
    ],
  },
  assistant_chips: {
    label: "助手快捷芯片",
    pk: "id",
    order: "sort_order",
    listColumns: ["id", "scenario_id", "label", "is_active"],
    fields: [
      { key: "id", type: "text", required: true },
      { key: "scenario_id", type: "text", required: true, label: "scenario_id（对应 assistant_replies）" },
      { key: "label", type: "text", required: true },
      { key: "sort_order", type: "number" },
      { key: "is_active", type: "bool", label: "启用" },
    ],
  },
  cities: {
    label: "城市",
    pk: "id",
    order: "display_order",
    listColumns: ["id", "name", "chinese_name", "is_published", "display_order"],
    fields: [
      { key: "id", type: "text", required: true },
      { key: "name", type: "text", required: true },
      { key: "chinese_name", type: "text", required: true },
      { key: "emoji", type: "text" },
      { key: "description", type: "textarea" },
      { key: "best_for", type: "tags", label: "best_for（逗号分隔）" },
      { key: "season_note", type: "text" },
      { key: "best_time_to_visit", type: "text" },
      { key: "avg_days_recommended", type: "number" },
      { key: "attraction_count", type: "number" },
      { key: "display_order", type: "number" },
      { key: "is_published", type: "bool", label: "已发布" },
    ],
  },
  attractions: {
    label: "景点",
    pk: "id",
    order: "display_order",
    listColumns: ["id", "city_id", "name", "priority", "is_published"],
    fields: [
      { key: "id", type: "text", required: true },
      { key: "city_id", type: "text", required: true },
      { key: "name", type: "text", required: true },
      { key: "chinese_name", type: "text", required: true },
      { key: "category", type: "text" },
      { key: "summary", type: "textarea" },
      { key: "introduction", type: "textarea" },
      { key: "priority", type: "text" },
      { key: "ticket_price", type: "text" },
      { key: "recommended_duration", type: "text" },
      { key: "opening_hours", type: "text" },
      { key: "closed_days", type: "text" },
      { key: "requires_advance_booking", type: "bool" },
      { key: "metro_access", type: "text" },
      { key: "western_visitor_tips", type: "json", label: "western_visitor_tips (JSON 数组)" },
      { key: "nearby_places", type: "json", label: "nearby_places (JSON 数组)" },
      { key: "audio_guide_count", type: "number" },
      { key: "iap_product_id", type: "text" },
      { key: "display_order", type: "number" },
      { key: "is_published", type: "bool", label: "已发布" },
    ],
  },
  checklist_items: {
    label: "行前清单",
    pk: "id",
    order: "sort_order",
    listColumns: ["id", "city_id", "phase", "title_en", "is_active"],
    fields: [
      { key: "id", type: "text", required: true },
      { key: "city_id", type: "text", label: "city_id（空=全局）" },
      { key: "phase", type: "text", required: true },
      { key: "group_title", type: "text", required: true },
      { key: "title_en", type: "text", required: true },
      { key: "estimated_minutes", type: "number" },
      { key: "display_tags", type: "tags", label: "display_tags（逗号分隔）" },
      { key: "cultural_tip", type: "textarea" },
      { key: "sort_order", type: "number" },
      { key: "is_active", type: "bool", label: "启用" },
    ],
  },
  home_tips: {
    label: "首页提示",
    pk: "id",
    order: "sort_order",
    listColumns: ["id", "city_id", "headline", "is_active"],
    fields: [
      { key: "id", type: "text", required: true },
      { key: "city_id", type: "text" },
      { key: "kicker", type: "text" },
      { key: "headline", type: "text", required: true },
      { key: "body", type: "textarea", required: true },
      { key: "link_label", type: "text" },
      { key: "link_attraction_id", type: "text", label: "link_attraction_id（Guide 深链）" },
      { key: "link_url", type: "text" },
      { key: "sort_order", type: "number" },
      { key: "is_active", type: "bool", label: "启用" },
    ],
  },
  city_routes: {
    label: "城市路线",
    pk: "id",
    order: "sort_order",
    listColumns: ["id", "city_id", "title", "days"],
    fields: [
      { key: "id", type: "text", required: true },
      { key: "city_id", type: "text", required: true },
      { key: "title", type: "text", required: true },
      { key: "days", type: "number", required: true },
      { key: "summary", type: "textarea", required: true },
      { key: "sort_order", type: "number" },
    ],
  },
  audio_guides: {
    label: "音频导览",
    pk: "id",
    order: "sort_order",
    listColumns: ["id", "attraction_id", "title_en", "is_active"],
    fields: [
      { key: "id", type: "text", required: true },
      { key: "attraction_id", type: "text", required: true },
      { key: "title_en", type: "text", required: true },
      { key: "description", type: "textarea" },
      { key: "duration_seconds", type: "number" },
      { key: "audio_url", type: "text", label: "audio_url（HTTPS 或 Storage 上传后自动填入）" },
      { key: "_audio_upload", type: "audio_upload", label: "上传音频文件" },
      { key: "quote", type: "textarea" },
      { key: "segments", type: "json", label: "segments (JSON 数组)" },
      { key: "is_main_guide", type: "bool" },
      { key: "sort_order", type: "number" },
      { key: "is_active", type: "bool", label: "启用" },
    ],
  },
  shopping_items: {
    label: "购物清单",
    pk: "id",
    order: "sort_order",
    listColumns: ["id", "city_id", "title_en", "is_active"],
    fields: [
      { key: "id", type: "text", required: true },
      { key: "city_id", type: "text", label: "city_id（空=全局）" },
      { key: "title_en", type: "text", required: true },
      { key: "note_en", type: "textarea" },
      { key: "sort_order", type: "number" },
      { key: "is_active", type: "bool", label: "启用" },
    ],
  },
  reading_list: {
    label: "阅读清单",
    pk: "id",
    order: "sort_order",
    listColumns: ["id", "title", "author", "is_active"],
    fields: [
      { key: "id", type: "text", required: true },
      { key: "city_ids", type: "tags", label: "city_ids（逗号分隔）" },
      { key: "title", type: "text", required: true },
      { key: "author", type: "text", required: true },
      { key: "genre", type: "text", required: true },
      { key: "synopsis_en", type: "textarea", required: true },
      { key: "sort_order", type: "number" },
      { key: "is_active", type: "bool", label: "启用" },
    ],
  },
  hotels: {
    label: "酒店",
    pk: "id",
    order: "sort_order",
    listColumns: ["id", "city_id", "name", "is_active"],
    fields: [
      { key: "id", type: "text", required: true },
      { key: "city_id", type: "text", required: true },
      { key: "name", type: "text", required: true },
      { key: "chinese_name", type: "text", required: true },
      { key: "stars", type: "number" },
      { key: "price_min_usd", type: "number" },
      { key: "has_english_staff", type: "bool" },
      { key: "english_staff_note", type: "textarea" },
      { key: "language_tip", type: "textarea" },
      { key: "location_note", type: "textarea" },
      { key: "booking_platforms", type: "tags", label: "booking_platforms（逗号分隔）" },
      { key: "sort_order", type: "number" },
      { key: "is_active", type: "bool", label: "启用" },
    ],
  },
  passport_countries: {
    label: "护照国家",
    pk: "code",
    order: "display_order",
    listColumns: ["code", "name", "flag", "is_active"],
    fields: [
      { key: "code", type: "text", required: true },
      { key: "name", type: "text", required: true },
      { key: "flag", type: "text" },
      { key: "display_order", type: "number" },
      { key: "is_active", type: "bool", label: "启用" },
    ],
  },
  visa_rules: {
    label: "签证规则",
    pk: "country_code",
    order: "country_code",
    listColumns: ["country_code", "country_name", "visa_free", "is_active"],
    fields: [
      { key: "country_code", type: "text", required: true },
      { key: "country_name", type: "text", required: true },
      { key: "flag", type: "text" },
      { key: "visa_free", type: "bool" },
      { key: "stay_days", type: "number" },
      { key: "headline", type: "text", required: true },
      { key: "details", type: "json", label: "details (JSON 数组)" },
      { key: "is_active", type: "bool", label: "启用" },
    ],
  },
  culture_tips: {
    label: "文化贴士",
    pk: "id",
    order: "sort_order",
    listColumns: ["id", "title", "is_active"],
    fields: [
      { key: "id", type: "text", required: true },
      { key: "emoji", type: "text" },
      { key: "title", type: "text", required: true },
      { key: "preview", type: "textarea", required: true },
      { key: "body", type: "textarea", required: true },
      { key: "sort_order", type: "number" },
      { key: "is_active", type: "bool", label: "启用" },
    ],
  },
  assistant_replies: {
    label: "助手回复",
    pk: "scenario_id",
    order: "scenario_id",
    listColumns: ["scenario_id", "is_active"],
    fields: [
      { key: "scenario_id", type: "text", required: true },
      { key: "user_message", type: "textarea" },
      { key: "assistant_message", type: "textarea", required: true },
      { key: "is_active", type: "bool", label: "启用" },
    ],
  },
  emergency_config: {
    label: "紧急联系",
    single: true,
    pk: "id",
    order: null,
    fields: [
      { key: "id", type: "text", readonly: true },
      { key: "embassy_note", type: "textarea", required: true },
      { key: "contacts", type: "json", label: "contacts (JSON 数组)" },
    ],
  },
  content_itineraries: {
    label: "行程模板",
    pk: "id",
    order: "sort_order",
    listColumns: ["id", "kind", "title", "is_active"],
    fields: [
      { key: "id", type: "text", required: true },
      { key: "kind", type: "text", required: true, label: "kind: sample | planning" },
      { key: "title", type: "text", required: true },
      { key: "meta", type: "text", required: true },
      { key: "route_summary", type: "text", required: true },
      { key: "estimated_budget", type: "text", required: true },
      { key: "days", type: "json", label: "days (JSON 数组)" },
      { key: "sort_order", type: "number" },
      { key: "is_active", type: "bool", label: "启用" },
    ],
  },
};

let client = null;
let session = null;
let currentTable = "app_settings";
let editingRow = null;

function $(sel) {
  return document.querySelector(sel);
}

function showToast(msg, type = "success") {
  const el = document.createElement("div");
  el.className = `toast ${type}`;
  el.textContent = msg;
  document.body.appendChild(el);
  setTimeout(() => el.remove(), 3500);
}

function getConfig() {
  const c = window.CHINAGO_ADMIN_CONFIG;
  if (!c?.supabaseUrl || !c?.supabaseAnonKey) {
    throw new Error("请复制 admin/js/config.example.js 为 config.js 并填写 Supabase URL 与 Anon Key");
  }
  if (c.supabaseUrl.includes("你的项目")) {
    throw new Error("请在 admin/js/config.js 中填写真实的 Supabase 配置");
  }
  return c;
}

function initClient() {
  const cfg = getConfig();
  client = supabase.createClient(cfg.supabaseUrl, cfg.supabaseAnonKey);
}

async function checkIsAdmin(userId) {
  const { data, error } = await client
    .from("admin_users")
    .select("user_id")
    .eq("user_id", userId)
    .maybeSingle();
  if (error) throw error;
  return !!data;
}

async function refreshSession() {
  const { data } = await client.auth.getSession();
  session = data.session;
  return session;
}

function showLogin() {
  $("#login-screen").classList.remove("hidden");
  $("#app-screen").classList.add("hidden");
}

function showApp(email) {
  $("#login-screen").classList.add("hidden");
  $("#app-screen").classList.remove("hidden");
  $("#user-email").textContent = email || "";
}

async function handleLogin(e) {
  e.preventDefault();
  const email = $("#login-email").value.trim();
  const password = $("#login-password").value;
  $("#login-error").classList.add("hidden");

  try {
    const { data, error } = await client.auth.signInWithPassword({ email, password });
    if (error) throw error;
    session = data.session;
    const ok = await checkIsAdmin(session.user.id);
    if (!ok) {
      await client.auth.signOut();
      throw new Error("该账号不在 admin_users 表中，无法使用后台。请在 Supabase SQL 中添加管理员。");
    }
    showApp(session.user.email);
    await loadCurrentSection();
  } catch (err) {
    const box = $("#login-error");
    box.textContent = err.message;
    box.classList.remove("hidden");
  }
}

async function handleLogout() {
  await client.auth.signOut();
  session = null;
  showLogin();
}

function bindNav() {
  document.querySelectorAll(".nav-btn[data-table]").forEach((btn) => {
    btn.addEventListener("click", () => {
      document.querySelectorAll(".nav-btn").forEach((b) => b.classList.remove("active"));
      btn.classList.add("active");
      currentTable = btn.dataset.table;
      loadCurrentSection();
    });
  });
  $("#logout-btn").addEventListener("click", handleLogout);
  $("#add-row-btn").addEventListener("click", () => openModal(null));
}

async function loadCurrentSection() {
  const meta = TABLES[currentTable];
  $("#page-title").textContent = meta.label;
  $("#add-row-btn").classList.toggle("hidden", !!meta.single);

  if (currentTable === "app_settings") {
    await renderAppSettings();
  } else {
    await renderTable(currentTable);
  }
}

async function renderAppSettings() {
  const main = $("#main-content");
  const meta = TABLES.app_settings;
  main.innerHTML = `<div class="status-bar info">保存后 App 在下次刷新或回到前台时读取 app_settings。</div><form id="settings-form" class="settings-form"></form><button type="submit" form="settings-form" class="btn" style="margin-top:12px">保存应用配置</button>`;

  const { data, error } = await client.from("app_settings").select("*").eq("id", "global").single();
  if (error) {
    main.innerHTML = `<div class="status-bar error">${error.message}</div>`;
    return;
  }

  const form = $("#settings-form");
  meta.fields.forEach((f) => {
    if (f.readonly) return;
    const label = f.label || f.key;
    const val = fieldToFormValue(f, data[f.key]);
    if (f.type === "bool") {
      const row = document.createElement("div");
      row.className = "setting-row";
      row.innerHTML = `
        <label>${label}</label>
        <label class="toggle">
          <input type="checkbox" name="${f.key}" ${val ? "checked" : ""} />
          <span></span>
        </label>`;
      form.appendChild(row);
    } else if (f.type === "textarea") {
      const block = document.createElement("div");
      block.innerHTML = `<label>${label}</label><textarea name="${f.key}">${escapeHtml(String(val))}</textarea>`;
      form.appendChild(block);
    } else {
      const block = document.createElement("div");
      block.innerHTML = `<label>${label}</label><input name="${f.key}" type="${f.type === "number" ? "number" : "text"}" value="${escapeHtml(String(val))}" />`;
      form.appendChild(block);
    }
  });

  form.addEventListener("submit", async (e) => {
    e.preventDefault();
    const payload = { updated_at: new Date().toISOString() };
    try {
      meta.fields.forEach((f) => {
        if (f.readonly) return;
        const el = form.elements[f.key];
        if (!el) return;
        payload[f.key] = f.type === "bool" ? el.checked : formValueToField(f, el.value.trim());
      });
      const { error: err } = await client.from("app_settings").update(payload).eq("id", "global");
      if (err) throw err;
      showToast("应用配置已保存");
    } catch (ex) {
      showToast(ex.message, "error");
    }
  });
}

async function uploadAudioGuideFile(file, guideId) {
  const ext = file.name.split(".").pop() || "m4a";
  const path = `${guideId}.${ext}`;
  const { error: upErr } = await client.storage.from("audio-guides").upload(path, file, {
    upsert: true,
    contentType: file.type || "audio/mpeg",
  });
  if (upErr) throw upErr;
  const { data: urlData } = client.storage.from("audio-guides").getPublicUrl(path);
  return urlData.publicUrl;
}

async function renderTable(table) {
  const meta = TABLES[table];
  const main = $("#main-content");

  let query = client.from(table).select("*");
  if (meta.order) query = query.order(meta.order, { ascending: true });

  const { data, error } = await query;
  if (error) {
    main.innerHTML = `<div class="status-bar error">${error.message}</div>`;
    return;
  }

  const cols = meta.listColumns;
  let html = `<div class="table-wrap"><table><thead><tr>`;
  cols.forEach((c) => {
    html += `<th>${c}</th>`;
  });
  html += `<th>操作</th></tr></thead><tbody>`;

  (data || []).forEach((row) => {
    html += "<tr>";
    cols.forEach((c) => {
      let v = row[c];
      if (typeof v === "boolean") {
        v = `<span class="tag ${v ? "on" : "off"}">${v ? "是" : "否"}</span>`;
      } else if (v === null || v === undefined) {
        v = "—";
      } else if (Array.isArray(v)) {
        v = v.join(", ");
      }
      html += `<td>${v}</td>`;
    });
    html += `<td>
      <button class="btn btn-sm btn-secondary" data-edit='${encodeURIComponent(JSON.stringify(row))}'>编辑</button>
      <button class="btn btn-sm btn-danger" data-del="${row[meta.pk]}">删除</button>
    </td></tr>`;
  });

  html += "</tbody></table></div>";
  main.innerHTML = html;

  main.querySelectorAll("[data-edit]").forEach((btn) => {
    btn.addEventListener("click", () => {
      const row = JSON.parse(decodeURIComponent(btn.dataset.edit));
      openModal(row);
    });
  });

  main.querySelectorAll("[data-del]").forEach((btn) => {
    btn.addEventListener("click", async () => {
      if (!confirm("确定删除？")) return;
      const { error: err } = await client.from(table).delete().eq(meta.pk, btn.dataset.del);
      if (err) showToast(err.message, "error");
      else {
        showToast("已删除");
        await renderTable(table);
      }
    });
  });
}

function fieldToFormValue(field, value) {
  if (field.type === "bool") return !!value;
  if (field.type === "tags") {
    if (Array.isArray(value)) return value.join(", ");
    return value || "";
  }
  if (field.type === "json") {
    if (value === null || value === undefined) return "[]";
    return typeof value === "string" ? value : JSON.stringify(value, null, 2);
  }
  if (value === null || value === undefined) return "";
  return value;
}

function formValueToField(field, raw) {
  if (field.type === "bool") return raw;
  if (field.type === "number") {
    if (raw === "" || raw === null) return null;
    return Number(raw);
  }
  if (field.type === "tags") {
    if (!raw.trim()) return [];
    return raw.split(",").map((s) => s.trim()).filter(Boolean);
  }
  if (field.type === "json") {
    if (!raw.trim()) return [];
    return JSON.parse(raw);
  }
  if (raw === "") return null;
  return raw;
}

function openModal(row) {
  editingRow = row;
  const meta = TABLES[currentTable];
  const isNew = !row;
  const title = isNew ? `新建 · ${meta.label}` : `编辑 · ${meta.label}`;

  let fieldsHtml = "";
  meta.fields.forEach((f) => {
    const label = f.label || f.key;
    const val = fieldToFormValue(f, row ? row[f.key] : "");
    const ro = f.readonly || (!isNew && f.key === meta.pk) ? "readonly" : "";
    if (f.type === "bool") {
      fieldsHtml += `<label>${label}</label>
        <label class="toggle" style="margin-bottom:16px">
          <input type="checkbox" name="${f.key}" ${val ? "checked" : ""} ${ro} />
          <span></span>
        </label>`;
    } else if (f.type === "audio_upload") {
      fieldsHtml += `<label>${label}</label><input type="file" name="${f.key}" accept="audio/*,.mp3,.m4a,.wav" />`;
    } else if (f.type === "textarea" || f.type === "json") {
      fieldsHtml += `<label>${label}</label><textarea name="${f.key}" ${ro}>${escapeHtml(String(val))}</textarea>`;
    } else {
      fieldsHtml += `<label>${label}</label><input name="${f.key}" type="${f.type === "number" ? "number" : "text"}" value="${escapeHtml(String(val))}" ${ro} />`;
    }
  });

  const backdrop = document.createElement("div");
  backdrop.className = "modal-backdrop";
  backdrop.innerHTML = `
    <div class="modal">
      <h3>${title}</h3>
      <form id="edit-form">${fieldsHtml}
        <div class="modal-actions">
          <button type="button" class="btn btn-secondary" id="modal-cancel">取消</button>
          <button type="submit" class="btn">保存</button>
        </div>
      </form>
    </div>`;

  document.body.appendChild(backdrop);
  backdrop.querySelector("#modal-cancel").onclick = () => backdrop.remove();
  backdrop.addEventListener("click", (e) => {
    if (e.target === backdrop) backdrop.remove();
  });

  backdrop.querySelector("#edit-form").onsubmit = async (e) => {
    e.preventDefault();
    const form = e.target;
    const payload = { updated_at: new Date().toISOString() };

    try {
      for (const f of meta.fields) {
        if (f.readonly || f.type === "audio_upload") continue;
        const el = form.elements[f.key];
        if (!el) continue;
        if (f.type === "bool") {
          payload[f.key] = el.checked;
        } else {
          payload[f.key] = formValueToField(f, el.value.trim());
        }
      }

      const uploadField = meta.fields.find((f) => f.type === "audio_upload");
      if (uploadField) {
        const fileInput = form.elements[uploadField.key];
        const guideId = payload.id || row?.[meta.pk];
        if (fileInput?.files?.[0]) {
          if (!guideId) throw new Error("请先填写音频导览 ID，再上传文件");
          payload.audio_url = await uploadAudioGuideFile(fileInput.files[0], guideId);
        }
      }

      let err;
      if (isNew) {
        ({ error: err } = await client.from(currentTable).insert(payload));
      } else {
        ({ error: err } = await client.from(currentTable).update(payload).eq(meta.pk, row[meta.pk]));
      }
      if (err) throw err;
      backdrop.remove();
      showToast("已保存");
      await loadCurrentSection();
    } catch (ex) {
      showToast(ex.message, "error");
    }
  };
}

function escapeHtml(s) {
  return s
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;");
}

async function boot() {
  try {
    initClient();
  } catch (e) {
    document.body.innerHTML = `<div class="login-wrap"><div class="login-card"><div class="status-bar error">${e.message}</div></div></div>`;
    return;
  }

  $("#login-form").addEventListener("submit", handleLogin);
  bindNav();

  await refreshSession();
  if (session) {
    try {
      const ok = await checkIsAdmin(session.user.id);
      if (!ok) {
        await client.auth.signOut();
        showLogin();
        $("#login-error").textContent = "当前用户不是管理员";
        $("#login-error").classList.remove("hidden");
        return;
      }
      showApp(session.user.email);
      await loadCurrentSection();
    } catch (e) {
      showLogin();
    }
  } else {
    showLogin();
  }
}

document.addEventListener("DOMContentLoaded", boot);
