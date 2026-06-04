/* ChinaGo Admin — table CRUD, modals, single-page forms */

(function () {
  const App = window.ChinaGoAdmin;

  App.fieldMatchesShowWhen = function fieldMatchesShowWhen(field, formValues) {
    if (!field.showWhen) return true;
    const current = formValues[field.showWhen.field];
    return field.showWhen.values.includes(current);
  };

  App.shouldRenderField = function shouldRenderField(field, ctx) {
    if (field.hideInForm) return false;
    if (field.type === "slug" && !ctx.showSlug) return false;
    if (field.key === "city_id" && ctx.fixedCityId && field.advanced) return false;
    if (field.key === "attraction_id" && ctx.fixedAttractionId) return false;
    if (field.advanced && !ctx.showAdvanced) return false;
    if (!ctx.isNew && field.readonly && field.key === ctx.pk && field.type === "text" && !ctx.showAdvanced) {
      return false;
    }
    if (ctx.formValues && !App.fieldMatchesShowWhen(field, ctx.formValues)) return false;
    return true;
  };

  App.renderContextBanner = function renderContextBanner(ctx) {
    const parts = [];
    if (ctx.fixedCityId) parts.push(`<span class="context-chip">城市：${App.escapeHtml(App.cityLabel(ctx.fixedCityId))}</span>`);
    if (ctx.fixedAttractionId) {
      parts.push(`<span class="context-chip">景点：${App.escapeHtml(App.attractionLabel(ctx.fixedAttractionId))}</span>`);
    }
    if (!parts.length) return "";
    return `<div class="context-banner">${parts.join("")}<span class="muted">已自动关联，无需填写 ID</span></div>`;
  };

  App.renderHiddenContextFields = function renderHiddenContextFields(ctx, meta) {
    let html = "";
    if (ctx.fixedCityId && meta.fields.some((f) => f.key === "city_id")) {
      html += `<input type="hidden" name="city_id" value="${App.escapeHtml(ctx.fixedCityId)}" />`;
    }
    if (ctx.fixedAttractionId && meta.fields.some((f) => f.key === "attraction_id")) {
      html += `<input type="hidden" name="attraction_id" value="${App.escapeHtml(ctx.fixedAttractionId)}" />`;
    }
    return html;
  };

  App.ensureRecordId = function ensureRecordId(payload, meta, form, ctx) {
    const pk = meta.pk;
    if (payload[pk]) return;
    const slugField = meta.fields.find((f) => f.key === pk && f.type === "slug");
    if (!slugField) return;
    const sourceEl = App.formFieldEl(form, slugField.slugSource);
    const sourceVal = sourceEl?.value?.trim();
    if (!sourceVal) throw new Error("请填写名称后再保存");
    let prefix = slugField.slugPrefix || "";
    if (slugField.slugPrefixField) {
      const prefixEl = App.formFieldEl(form, slugField.slugPrefixField);
      prefix = prefixEl?.value?.trim() || ctx.fixedCityId || prefix;
    }
    if (ctx.fixedCityId && slugField.slugPrefixField === "city_id") prefix = ctx.fixedCityId;
    payload[pk] = App.slugify(sourceVal, prefix);
  };

  App.buildFormFieldsHtml = function buildFormFieldsHtml(meta, row, ctx) {
    const isNew = !row || !row[meta.pk];
    const formValues = { ...(row || {}) };
    const fieldCtx = { ...ctx, isNew, pk: meta.pk, formValues };
    let html = App.renderContextBanner(ctx) + App.renderHiddenContextFields(ctx, meta);

    // Grouped layout: each `section` opens a collapsible card wrapping its fields.
    if (meta.groupedSections) {
      let groupOpen = false;
      // Fields before the first section render in a small "general" group.
      meta.fields.forEach((f) => {
        if (!App.shouldRenderField(f, fieldCtx)) return;
        if (f.advanced || f.type === "slug") return; // advanced handled below
        if (f.type === "section") {
          if (groupOpen) html += `</div></details>`;
          const hint = f.hint ? `<p class="field-hint section-hint">${App.escapeHtml(f.hint)}</p>` : "";
          html += `<details class="settings-group" open id="grp-${App.escapeHtml(f.key)}">`
            + `<summary>${App.escapeHtml(f.label || "")}</summary>`
            + `<div class="settings-group-body">${hint}`;
          groupOpen = true;
          return;
        }
        if (!groupOpen) {
          html += `<details class="settings-group" open id="grp-_general"><summary>基础开关</summary><div class="settings-group-body">`;
          groupOpen = true;
        }
        const val = App.fieldToFormValue(f, row ? row[f.key] : "");
        html += App.renderFieldBlock(f, val, fieldCtx);
      });
      if (groupOpen) html += `</div></details>`;
      html += App.buildAdvancedFieldsHtml(meta, row, fieldCtx, isNew);
      return html;
    }

    meta.fields.forEach((f) => {
      if (!App.shouldRenderField(f, fieldCtx)) return;
      const val = App.fieldToFormValue(f, row ? row[f.key] : "");
      html += App.renderFieldBlock(f, val, fieldCtx);
    });

    html += App.buildAdvancedFieldsHtml(meta, row, fieldCtx, isNew);
    return html;
  };

  App.buildAdvancedFieldsHtml = function buildAdvancedFieldsHtml(meta, row, fieldCtx, isNew) {
    const advancedFields = meta.fields.filter((f) => {
      if (f.type === "section") return false;
      if (f.type === "slug") return true;
      if (f.advanced) return true;
      if (!isNew && f.readonly && f.key === meta.pk && f.type === "text") return true;
      return false;
    });
    if (!advancedFields.length) return "";
    let html = `<details class="advanced-fields"><summary>高级选项（ID / 技术字段）</summary><div class="advanced-inner">`;
    advancedFields.forEach((f) => {
      html += App.renderFieldBlock(f, App.fieldToFormValue(f, row ? row[f.key] : ""), { ...fieldCtx, showAdvanced: true });
    });
    html += `</div></details>`;
    return html;
  };

  App.getTableCreateContext = function getTableCreateContext(table) {
    const ctx = {};
    const cfg = App.TABLE_CITY_FILTERS[table];
    if (cfg && App.tableListCtx.cityId) ctx.fixedCityId = App.tableListCtx.cityId;
    if (table === "audio_guides" && App.tableListCtx.attractionId) {
      ctx.fixedAttractionId = App.tableListCtx.attractionId;
    }
    if (table === "checklist_items") {
      Object.assign(ctx, App.getChecklistCreateDefaults(ctx));
    }
    return ctx;
  };

  App.filterTableRowsByCity = function filterTableRowsByCity(table, rows, cityId) {
    if (!cityId) return rows;
    if (table === "checklist_items") return App.filterChecklistRowsByCity(rows, cityId);
    const cfg = App.TABLE_CITY_FILTERS[table];
    if (!cfg) return rows;
    if (cfg.viaAttraction) {
      return rows.filter((r) => {
        const a = App.refCache.attractions.find((x) => x.id === r.attraction_id);
        return a && a.city_id === cityId;
      });
    }
    return rows.filter((r) => {
      if (r[cfg.cityField] === cityId) return true;
      if (cfg.includeGlobal && (r[cfg.cityField] === null || r[cfg.cityField] === "")) return true;
      return false;
    });
  };

  App.searchTableRows = function searchTableRows(table, rows, query) {
    const q = String(query || "").trim().toLowerCase();
    if (!q) return rows;
    const meta = App.TABLES[table];
    const cols = meta.listColumns || [];
    return rows.filter((row) =>
      cols.some((c) => {
        const key = typeof c === "string" ? c : c.key;
        let v = row[key];
        if (typeof c === "object" && c.ref === "city") v = App.cityLabel(v);
        if (typeof c === "object" && c.ref === "attraction") v = App.attractionLabel(v);
        if (typeof c === "object" && c.ref === "scenario") v = App.scenarioLabel(v);
        if (typeof c === "object" && c.ref === "country") v = App.countryLabel(v);
        return String(v ?? "").toLowerCase().includes(q);
      })
    );
  };

  App.renderTableBody = function renderTableBody(table, rows) {
    const meta = App.TABLES[table];
    const cols = (meta.listColumns || []).filter((c) => !(typeof c === "object" && c.advanced));
    let html = `<div class="table-wrap"><table><thead><tr>`;
    cols.forEach((c) => {
      html += `<th>${App.escapeHtml(App.getListColumnLabel(c))}</th>`;
    });
    html += `<th>操作</th></tr></thead><tbody>`;
    if (!rows.length) {
      html += `<tr><td colspan="${cols.length + 1}" class="muted">暂无数据</td></tr>`;
    }
    rows.forEach((row) => {
      html += "<tr>";
      cols.forEach((c) => {
        html += `<td>${App.formatListCell(c, row)}</td>`;
      });
      let actions = `<button class="btn btn-sm btn-secondary" data-edit-id="${App.escapeHtml(String(row[meta.pk]))}">编辑</button>`;
      if (table === "user_itineraries" && row.user_id) {
        actions += ` <button class="btn btn-sm" data-open-profile="${App.escapeHtml(String(row.user_id))}">用户</button>`;
      }
      if (!meta.noDelete) {
        actions += ` <button class="btn btn-sm btn-danger" data-del="${App.escapeHtml(String(row[meta.pk]))}">删除</button>`;
      }
      html += `<td>${actions}</td></tr>`;
    });
    html += "</tbody></table></div>";
    return html;
  };

  App.collectFormPayload = async function collectFormPayload(form, meta, row, isNew, ctx = {}) {
    App.syncAllQuillFields(form);
    let payload = { updated_at: new Date().toISOString() };
    const fieldCtx = { ...ctx, isNew };

    for (const f of meta.fields) {
      if (f.type === "section") continue;
      if (f.virtual) continue;
      if (
        f.readonly ||
        f.type === "audio_upload" ||
        f.type === "image_upload" ||
        f.type === "image_url_list" ||
        f.type === "content_blocks_list"
      ) {
        continue;
      }
      if (f.type === "image_preview" || f.type === "audio_preview") {
        const v = App.readFieldValue(f, form);
        if (v) payload[f.key] = v;
        continue;
      }
      if (f.type === "slug" && isNew && !ctx.showSlug) continue;
      if (f.computed) continue;
      const v = App.readFieldValue(f, form);
      if (v === undefined) continue;
      if (v === null && f.type === "number" && !f.allowNull) continue;
      payload[f.key] = v;
    }

    App.fillTableDefaults(payload, ctx.table);

    const metaHasField = (key) => meta.fields.some((f) => f.key === key);
    if (ctx.fixedCityId && metaHasField("city_id")) payload.city_id = ctx.fixedCityId;
    if (ctx.fixedAttractionId && metaHasField("attraction_id")) {
      payload.attraction_id = ctx.fixedAttractionId;
    }
    App.ensureRecordId(payload, meta, form, fieldCtx);

    const audioField = meta.fields.find((f) => f.type === "audio_upload");
    if (audioField && ctx.table === "audio_guides") {
      if (form?.dataset?.audioUploading === "1") {
        throw new Error("音频仍在上传中，请稍候再保存");
      }
      const pending = form?.dataset?.pendingAudioUrl?.trim();
      if (pending) {
        payload.audio_url = pending;
      }
      const fileInput = App.formFileInput(form, audioField.key);
      const guideId = payload.id || row?.[meta.pk];
      if (fileInput?.files?.[0]) {
        if (!guideId) throw new Error("请先填写标题并保存，再上传音频");
        payload.audio_url = await App.uploadAudioGuideFile(fileInput.files[0], guideId);
        try {
          const seconds = await App.probeAudioDurationSeconds(fileInput.files[0]);
          App.applyAudioDurationToForm(form, seconds, { force: true });
          if (meta.fields.some((f) => f.key === "duration_seconds")) {
            payload.duration_seconds = Number(
              form.querySelector('[name="duration_seconds"]')?.value
            );
          }
        } catch (_) {
          /* optional */
        }
      }
      delete form?.dataset?.pendingAudioUrl;
    }

    const entityId = payload.id || row?.[meta.pk];

    const imageField = meta.fields.find((f) => f.type === "image_upload");
    if (imageField) {
      const fileInput = App.formFileInput(form, imageField.key);
      if (fileInput?.files?.[0]) {
        if (!entityId) throw new Error("请先填写名称后再上传封面");
        const folder = imageField.uploadFolder || "misc";
        payload[imageField.uploadTarget || "cover_image_path"] = await App.uploadCoverImage(
          fileInput.files[0],
          folder,
          entityId
        );
      }
    }

    for (const f of meta.fields) {
      if (f.type === "image_url_list") {
        payload[f.key] = await App.collectImageUrlList(form, f, entityId);
      }
      if (f.type === "content_blocks_list") {
        payload[f.key] = await App.collectContentBlocks(form, f, entityId);
      }
    }

    if (ctx.table === "sub_areas") {
      if (form?.dataset?.audioUploading === "1") {
        throw new Error("音频仍在上传中，请稍候再保存");
      }
      const entityId = payload.id || row?.[meta.pk];
      const audioUp = App.formFileInput(form, "_sa_audio_upload");
      if (audioUp?.files?.[0]) {
        if (!entityId) throw new Error("请先填写子区域英文名");
        payload.audio_url = await App.uploadSubAreaAudioFile(audioUp.files[0], entityId);
        form.dataset.pendingAudioUrl = payload.audio_url;
      } else {
        const resolved = App.resolveSubAreaAudioUrl(form, row);
        if (resolved !== undefined) payload.audio_url = resolved;
      }
      payload.content_blocks = [];
      for (const key of Object.keys(payload)) {
        if (key.startsWith("_")) delete payload[key];
      }
      delete form.dataset.pendingAudioUrl;
    }

    if (ctx.table === "city_guides") {
      if (form?.dataset?.audioUploading === "1") {
        throw new Error("音频仍在上传中，请稍候再保存");
      }
      const entityId = payload.id || row?.[meta.pk];
      const pending = form?.dataset?.pendingAudioUrl?.trim();
      if (pending) {
        payload.audio_url = pending;
      }
      const audioUp = App.formFileInput(form, "_cg_audio_upload");
      if (audioUp?.files?.[0]) {
        if (!entityId) throw new Error("请先填写指南英文标题");
        payload.audio_url = await App.uploadCityGuideAudioFile(audioUp.files[0], entityId);
        try {
          const seconds = await App.probeAudioDurationSeconds(audioUp.files[0]);
          App.applyAudioDurationToForm(form, seconds, { durationField: "audio_duration_seconds", force: true });
          payload.audio_duration_seconds = Number(
            form.querySelector('[name="audio_duration_seconds"]')?.value
          );
        } catch (_) {
          /* optional */
        }
      }
      delete form?.dataset?.pendingAudioUrl;
      payload = App.sanitizePayloadForTable(payload, "city_guides", { omitId: isNew });
    }

    if (ctx.table === "user_itineraries") {
      return App.packUserItineraryPayload(payload, row);
    }

    if (ctx.table === "checklist_items") {
      App.sanitizeChecklistPayload(payload, ctx);
    }

    return payload;
  };

  App.renderSingleForm = async function renderSingleForm(table, idValue) {
    const meta = App.TABLES[table];
    const main = App.$("#main-content");
    main.innerHTML = `<div class="status-bar info">保存后立即生效。</div><form id="single-form" class="settings-form settings-form--wide"></form><button type="submit" form="single-form" class="btn" style="margin-top:12px">保存</button>`;

    const { data, error } = await App.client.from(table).select("*").eq(meta.pk, idValue).maybeSingle();
    if (error) {
      main.innerHTML = `<div class="status-bar error">${App.escapeHtml(error.message)}</div>`;
      return;
    }
    const row = data || { [meta.pk]: idValue };

    const form = App.$("#single-form");
    form.innerHTML = App.buildFormFieldsHtml(meta, row, { fixedCityId: null });
    App.mountFieldInteractions(form, meta, { isNew: false, pk: meta.pk, formEl: form });

    form.addEventListener("submit", async (e) => {
      e.preventDefault();
      try {
        const payload = await App.collectFormPayload(form, meta, row, false, { table });
        const { error: err } = data
          ? await App.client.from(table).update(payload).eq(meta.pk, idValue)
          : await App.client.from(table).insert({ ...payload, [meta.pk]: idValue });
        if (err) throw err;
        App.showToast("已保存");
        await App.loadRefCache(true);
      } catch (ex) {
        App.showToast(ex.message, "error");
      }
    });
  };

  App.renderAppSettings = async function renderAppSettings() {
    const main = App.$("#main-content");
    const meta = App.TABLES.app_settings;
    App.$("#page-title").textContent = meta.label;

    // Quick-jump chips from the section list
    const sections = meta.fields.filter((f) => f.type === "section");
    const chips = [`<button type="button" class="settings-chip" data-jump="grp-_general">基础开关</button>`]
      .concat(sections.map((s) =>
        `<button type="button" class="settings-chip" data-jump="grp-${App.escapeHtml(s.key)}">${App.escapeHtml(s.label || s.key)}</button>`
      )).join("");

    main.innerHTML = `
      <details class="settings-help">
        <summary>📖 配置说明（点击展开）</summary>
        <div class="settings-help-body">${App.iapPreviewSettingsBannerHtml()}</div>
      </details>
      <div class="settings-nav">${chips}</div>
      <form id="single-form" class="settings-form settings-form--wide"></form>
      <div class="settings-save-bar">
        <span class="muted">保存后 App 下次拉取 app_settings 或刷新内容模式时生效</span>
        <button type="submit" form="single-form" class="btn">保存配置</button>
      </div>`;

    const { data, error } = await App.client.from("app_settings").select("*").eq(meta.pk, "global").maybeSingle();
    if (error) {
      main.innerHTML = `<div class="status-bar error">${App.escapeHtml(error.message)}</div>`;
      return;
    }
    const row = data || { [meta.pk]: "global" };
    const form = App.$("#single-form");
    form.innerHTML = App.buildFormFieldsHtml(meta, row, { fixedCityId: null });
    App.mountFieldInteractions(form, meta, { isNew: false, pk: meta.pk, formEl: form });

    // Quick-jump: open the target group and scroll to it
    main.querySelectorAll("[data-jump]").forEach((btn) => {
      btn.addEventListener("click", () => {
        const el = document.getElementById(btn.dataset.jump);
        if (el) {
          el.open = true;
          el.scrollIntoView({ behavior: "smooth", block: "start" });
        }
      });
    });

    form.addEventListener("submit", async (e) => {
      e.preventDefault();
      try {
        const payload = await App.collectFormPayload(form, meta, row, false, { table: "app_settings" });
        const { error: err } = data
          ? await App.client.from("app_settings").update(payload).eq(meta.pk, "global")
          : await App.client.from("app_settings").insert({ ...payload, [meta.pk]: "global" });
        if (err) throw err;
        App.showToast("已保存");
        await App.loadRefCache(true);
      } catch (ex) {
        App.showToast(ex.message, "error");
      }
    });
  };

  App.iapPreviewSettingsBannerHtml = function iapPreviewSettingsBannerHtml() {
    return `<div class="status-bar info iap-settings-banner">
      <strong>试听与内购</strong>
      <ul>
        <li><code>free_audio_preview_seconds</code>：未购用户主景点与子区域共用试听上限（秒）。</li>
        <li><code>use_remote_iap</code>：开启后 App 显示锁定与付费墙；关闭则全员视为已解锁（本地演示）。</li>
        <li>Paywall 文案区控制解锁弹窗；<code>iap_pro_*</code> 为 Profile 等展示文案。</li>
        <li>景点级 <code>iap_product_id</code> 在城市工作台 → 编辑解说 →「内购（景点级）」；当前 App 购买仍为本地模拟。</li>
        <li>音频上传：城市工作台内联「语音导览」选文件即传；侧栏「音频导览」表需先有导览 ID。</li>
      </ul>
    </div>`;
  };

  App.renderEmergencyConfig = async function renderEmergencyConfig() {
    await App.renderSingleForm("emergency_config", "global");
    App.$("#page-title").textContent = App.TABLES.emergency_config.label;
  };

  App.renderChecklistSettings = async function renderChecklistSettings() {
    const main = App.$("#main-content");
    const backBtn =
      App.currentView === "checklist_settings_global" && App.cityHubCityId
        ? `<button type="button" class="btn btn-secondary btn-sm" id="cl-settings-back" style="margin-bottom:12px">← 返回行前清单</button>`
        : "";
    main.innerHTML = `${backBtn}${App.checklistArchitectureBannerHtml()}
      <div class="status-bar info">保存后 App 下次打开 Prepare 或刷新内容时生效。</div>
      <form id="single-form" class="settings-form settings-form--wide"></form>
      <button type="submit" form="single-form" class="btn" style="margin-top:12px">保存</button>`;
    App.$("#page-title").textContent = App.TABLES.checklist_settings.label;

    const meta = App.TABLES.checklist_settings;
    const { data, error } = await App.client.from("checklist_settings").select("*").eq("id", "global").maybeSingle();
    if (error) {
      main.innerHTML = `<div class="status-bar error">${App.escapeHtml(error.message)}</div>`;
      return;
    }
    const row = data || { id: "global" };
    const form = App.$("#single-form", main);
    form.innerHTML = App.buildFormFieldsHtml(meta, row, { fixedCityId: null });
    App.mountFieldInteractions(form, meta, { isNew: false, pk: meta.pk, formEl: form });

    App.$("#cl-settings-back", main)?.addEventListener("click", () => {
      if (App.navigateTo && App.cityHubCityId) {
        App.navigateTo({ kind: "city_panel", cityId: App.cityHubCityId, panel: "checklist" });
      }
    });

    form.addEventListener("submit", async (e) => {
      e.preventDefault();
      try {
        const payload = await App.collectFormPayload(form, meta, row, false, { table: "checklist_settings" });
        const { error: err } = data
          ? await App.client.from("checklist_settings").update(payload).eq("id", "global")
          : await App.client.from("checklist_settings").insert({ ...payload, id: "global" });
        if (err) throw err;
        App.showToast("已保存");
      } catch (ex) {
        App.showToast(ex.message, "error");
      }
    });
  };

  App.renderTable = async function renderTable(table, filterFn) {
    const meta = App.TABLES[table];
    const main = App.$("#main-content");
    const cityCfg = App.TABLE_CITY_FILTERS[table];

    if (table === "user_itineraries") {
      try {
        await App.loadUserProfilesIndex();
      } catch (_) {
        /* list still works with UUID fallback */
      }
    }

    let query = App.client.from(table).select("*");
    if (meta.order) query = query.order(meta.order, { ascending: !meta.orderDesc });

    const { data, error } = await query;
    if (error) {
      main.innerHTML = `<div class="status-bar error">${App.escapeHtml(error.message)}</div>`;
      return;
    }

    let allRows = data || [];
    if (filterFn) allRows = allRows.filter(filterFn);

    const storedCity = sessionStorage.getItem(App.tableFilterStorageKey(table));
    if (storedCity && !App.tableListCtx.cityId) App.tableListCtx.cityId = storedCity;
    const storedType = sessionStorage.getItem(App.tableTypeFilterStorageKey(table));
    if (meta.typeFilter && storedType && !App.tableListCtx.typeFilter) {
      App.tableListCtx.typeFilter = storedType;
    }

    let toolbar = `<div class="hub-toolbar table-toolbar">
      <input type="search" id="table-search" class="search-input" placeholder="搜索…" value="${App.escapeHtml(App.tableListCtx.search || "")}" />`;
    if (meta.typeFilter) {
      const typeOpts = [
        { value: "", label: "全部类型" },
        ...(App.TABLES.checklist_items?.fields?.find((f) => f.key === "type")?.options || []),
      ];
      toolbar += `<select id="table-type-filter" class="search-input">`;
      typeOpts.forEach((o) => {
        const val = typeof o === "string" ? o : o.value;
        const label = typeof o === "string" ? o : o.label;
        const sel = App.tableListCtx.typeFilter === val ? "selected" : "";
        toolbar += `<option value="${App.escapeHtml(val)}" ${sel}>${App.escapeHtml(label)}</option>`;
      });
      toolbar += `</select>`;
    }
    if (cityCfg) {
      toolbar += `<select id="table-city-filter" class="search-input">
        <option value="">全部城市</option>`;
      App.refCache.cities.forEach((c) => {
        const sel = App.tableListCtx.cityId === c.id ? "selected" : "";
        toolbar += `<option value="${App.escapeHtml(c.id)}" ${sel}>${App.escapeHtml(App.cityLabel(c.id))}</option>`;
      });
      toolbar += `</select>`;
    }
    toolbar += `<span id="table-row-count" class="table-row-count muted"></span></div>`;
    if (table === "checklist_items") {
      toolbar += App.checklistArchitectureBannerHtml();
    }
    const hubTables = ["cities", "attractions", "sub_areas", "audio_guides", "city_guides", "hotels", "checklist_items"];
    if (hubTables.includes(table)) {
      toolbar += `<div class="status-bar info workflow-hint">推荐从侧栏 <strong>城市</strong> 树按城编辑；此页适合跨城浏览与批量操作。</div>`;
    }
    toolbar += `<div id="table-body-host"></div>`;

    main.innerHTML = toolbar;
    const host = App.$("#table-body-host", main);

    const bindTableRowActions = (tbl, root, extraFilter) => {
      root.querySelectorAll("[data-edit-id]").forEach((btn) => {
        btn.addEventListener("click", async () => {
          const id = btn.dataset.editId;
          const { data: row } = await App.client.from(tbl).select("*").eq(meta.pk, id).single();
          const ctx = App.getTableCreateContext(tbl);
          if (row?.city_id) ctx.fixedCityId = ctx.fixedCityId || row.city_id;
          if (row?.attraction_id) ctx.fixedAttractionId = ctx.fixedAttractionId || row.attraction_id;
          App.openModal(row, tbl, ctx);
        });
      });
      root.querySelectorAll("[data-del]").forEach((btn) => {
        btn.addEventListener("click", async () => {
          if (!confirm("确定删除？")) return;
          const { error: err } = await App.client.from(tbl).delete().eq(meta.pk, btn.dataset.del);
          if (err) App.showToast(err.message, "error");
          else {
            App.showToast("已删除");
            await App.loadRefCache(true);
            await App.renderTable(tbl, extraFilter);
          }
        });
      });
    };

    const applyFilters = () => {
      let rows = allRows;
      const userFilter = sessionStorage.getItem("yolo.admin.userItinerariesFilter");
      if (table === "user_itineraries" && userFilter) {
        rows = rows.filter((r) => r.user_id === userFilter);
      }
      rows = App.filterTableRowsByCity(table, rows, App.tableListCtx.cityId);
      if (meta.typeFilter) rows = App.filterChecklistRowsByType(rows, App.tableListCtx.typeFilter);
      rows = App.searchTableRows(table, rows, App.tableListCtx.search);
      let bodyHtml = App.renderTableBody(table, rows);
      if (table === "user_itineraries" && userFilter) {
        bodyHtml =
          `<div class="status-bar info">仅显示用户 <code>${App.escapeHtml(userFilter.slice(0, 8))}…</code>（${App.escapeHtml(App.profileEmail(userFilter))}）的行程。
          <button type="button" class="btn btn-sm btn-secondary" id="clear-user-itin-filter" style="margin-left:8px">显示全部</button></div>` +
          bodyHtml;
      }
      host.innerHTML = bodyHtml;
      const countEl = App.$("#table-row-count", main);
      if (countEl) countEl.textContent = `共 ${rows.length} 条`;
      App.$("#clear-user-itin-filter", host)?.addEventListener("click", () => {
        sessionStorage.removeItem("yolo.admin.userItinerariesFilter");
        applyFilters();
      });
      bindTableRowActions(table, host, filterFn);
      host.querySelectorAll("[data-open-profile]").forEach((btn) => {
        btn.addEventListener("click", () => {
          App.usersHubUserId = btn.dataset.openProfile;
          App.currentView = "users_hub";
          App.$$(".nav-btn").forEach((b) => b.classList.remove("active"));
          App.$('.nav-btn[data-view="users_hub"]')?.classList.add("active");
          App.loadCurrentSection();
        });
      });
    };

    App.$("#table-search", main)?.addEventListener("input", (e) => {
      App.tableListCtx.search = e.target.value;
      applyFilters();
    });
    App.$("#table-city-filter", main)?.addEventListener("change", (e) => {
      App.tableListCtx.cityId = e.target.value;
      sessionStorage.setItem(App.tableFilterStorageKey(table), App.tableListCtx.cityId || "");
      applyFilters();
    });
    App.$("#table-type-filter", main)?.addEventListener("change", (e) => {
      App.tableListCtx.typeFilter = e.target.value;
      sessionStorage.setItem(App.tableTypeFilterStorageKey(table), App.tableListCtx.typeFilter || "");
      applyFilters();
    });

    applyFilters();
  };

  App.openModal = async function openModal(row, tableOverride, ctxExtra) {
    await App.loadRefCache();
    const table = tableOverride || App.currentTable;
    const meta = App.TABLES[table];
    const isNew = !row || !row[meta.pk];
    const title = isNew ? `新建 · ${meta.label}` : `编辑 · ${meta.label}`;
    const wide = meta.fields.some((f) =>
      ["itinerary_builder", "richtext", "segment_list", "link_list"].includes(f.type)
    ) || table === "checklist_items";

    const backdrop = document.createElement("div");
    backdrop.className = "modal-backdrop";
    backdrop.innerHTML = `
      <div class="modal ${wide ? "modal--wide" : ""}">
        <h3>${App.escapeHtml(title)}</h3>
        <form id="edit-form" class="edit-form"></form>
        <div class="modal-actions">
          <button type="button" class="btn btn-secondary" id="modal-cancel">取消</button>
          <button type="submit" form="edit-form" class="btn">保存</button>
        </div>
      </div>`;

    const form = backdrop.querySelector("#edit-form");
    const ctx = {
      isNew,
      pk: meta.pk,
      fixedCityId: ctxExtra?.fixedCityId || (isNew ? App.tableListCtx.cityId : null) || row?.city_id || null,
      fixedAttractionId: ctxExtra?.fixedAttractionId || row?.attraction_id || null,
      formEl: form,
    };
    let formRow = row ? { ...row } : {};
    if (table === "checklist_items" && isNew) {
      formRow = { ...App.getChecklistCreateDefaults(ctx), ...formRow };
    }
    if (table === "user_itineraries" && row) {
      formRow = App.hydrateUserItineraryRow(row);
    }
    if (table === "sub_areas") {
      formRow = App.hydrateSubAreaRowForForm(formRow);
      if (row && !formRow.body && Array.isArray(formRow.content_blocks) && formRow.content_blocks.length) {
        formRow.body = App.contentBlocksToHtml(formRow.content_blocks);
      }
    }
    form.innerHTML = App.buildFormFieldsHtml(meta, formRow, ctx);
    const mountCtx =
      table === "sub_areas"
        ? {
            ...ctx,
            table,
            subAreaRow: formRow,
            fixedAttractionId: ctx.fixedAttractionId || formRow.attraction_id || "",
          }
        : ctx;
    const closeModal = () => {
      App.destroyQuillInRoot(backdrop);
      backdrop.remove();
    };

    document.body.appendChild(backdrop);
    App.mountFieldInteractions(form, meta, mountCtx);
    if (table === "checklist_items") App.mountChecklistTypeVisibility(form, meta);
    App.ensurePendingQuillHosts(backdrop);

    backdrop.querySelector("#modal-cancel").onclick = closeModal;
    backdrop.addEventListener("click", (e) => {
      if (e.target === backdrop) closeModal();
    });

    form.addEventListener("submit", async (e) => {
      e.preventDefault();
      try {
        let payload = await App.collectFormPayload(form, meta, row || {}, isNew, { ...ctx, table });
        if (table === "sub_areas") {
          payload = App.sanitizePayloadForTable(payload, "sub_areas", { omitId: isNew });
        }
        let err;
        const persist = (data) =>
          isNew
            ? App.client.from(table).insert(data)
            : App.client.from(table).update(data).eq(meta.pk, row[meta.pk]);
        ({ error: err } = await persist(payload));
        if (err && table === "sub_areas") {
          if (/body/i.test(err.message || "") && /column/i.test(err.message || "")) {
            const withoutBody = { ...payload };
            delete withoutBody.body;
            ({ error: err } = await persist(withoutBody));
            if (!err) {
              App.showToast("已保存（正文列未就绪：请在 Supabase 执行 032_sub_area_body.sql）", "error");
            }
          } else if (/audio_url/i.test(err.message || "") && /column/i.test(err.message || "")) {
            const withoutAudio = { ...payload };
            delete withoutAudio.audio_url;
            ({ error: err } = await persist(withoutAudio));
            if (!err) {
              App.showToast("已保存（音频列未就绪：请在 Supabase 执行 033_sub_area_audio_url.sql）", "error");
            }
          }
        }
        if (err) throw err;
        const attractionIdForSync =
          payload.id ||
          row?.[meta.pk] ||
          payload.attraction_id ||
          row?.attraction_id ||
          ctx.fixedAttractionId;
        if (table === "attractions" && attractionIdForSync) {
          await App.syncAttractionAudioGuideCount(attractionIdForSync);
        } else if (table === "audio_guides" && attractionIdForSync) {
          await App.syncAttractionAudioGuideCount(attractionIdForSync);
        }
        closeModal();
        App.showToast("已保存");
        await App.loadRefCache(true);
        if (ctxExtra?.onSaved) await ctxExtra.onSaved();
        else await App.loadCurrentSection();
      } catch (ex) {
        App.showToast(ex.message, "error");
      }
    });
  };

  App.mountChecklistTypeVisibility = function mountChecklistTypeVisibility(form, meta) {
    const typeEl = form.elements.type;
    if (!typeEl || form.dataset.checklistTypeBound === "1") return;
    form.dataset.checklistTypeBound = "1";

    const groupEl = form.elements.group_title;

    const refresh = () => {
      const t = typeEl.value;
      const formValues = { type: t };
      meta.fields.forEach((f) => {
        if (!f.showWhen) return;
        const block = form.querySelector(`[data-field-key="${f.key}"]`);
        if (!block) return;
        block.classList.toggle("hidden", !App.fieldMatchesShowWhen(f, formValues));
      });
      if (groupEl && !groupEl.dataset.userEdited) {
        if (t === "entry" && !groupEl.value.trim()) groupEl.value = "Entry Requirements";
        if (t === "universal" && !groupEl.value.trim()) groupEl.value = "Essential Prep";
      }
    };

    if (groupEl) {
      groupEl.addEventListener("input", () => {
        groupEl.dataset.userEdited = "1";
      });
    }
    typeEl.addEventListener("change", refresh);
    refresh();
  };
})();
