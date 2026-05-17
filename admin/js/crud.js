/* ChinaGo Admin — table CRUD, modals, single-page forms */

(function () {
  const App = window.ChinaGoAdmin;

  App.shouldRenderField = function shouldRenderField(field, ctx) {
    if (field.hideInForm) return false;
    if (field.type === "slug" && ctx.isNew && !ctx.showSlug) return false;
    if (field.key === "city_id" && ctx.fixedCityId) return false;
    if (field.key === "attraction_id" && ctx.fixedAttractionId) return false;
    if (field.advanced && ctx.isNew && !ctx.showAdvanced) return false;
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

  App.renderHiddenContextFields = function renderHiddenContextFields(ctx) {
    let html = "";
    if (ctx.fixedCityId) html += `<input type="hidden" name="city_id" value="${App.escapeHtml(ctx.fixedCityId)}" />`;
    if (ctx.fixedAttractionId) {
      html += `<input type="hidden" name="attraction_id" value="${App.escapeHtml(ctx.fixedAttractionId)}" />`;
    }
    return html;
  };

  App.ensureRecordId = function ensureRecordId(payload, meta, form, ctx) {
    const pk = meta.pk;
    if (payload[pk]) return;
    const slugField = meta.fields.find((f) => f.key === pk && f.type === "slug");
    if (!slugField) return;
    const sourceVal = form.elements[slugField.slugSource]?.value?.trim();
    if (!sourceVal) throw new Error("请填写名称后再保存");
    let prefix = slugField.slugPrefix || "";
    if (slugField.slugPrefixField) {
      prefix = form.elements[slugField.slugPrefixField]?.value?.trim() || ctx.fixedCityId || prefix;
    }
    if (ctx.fixedCityId && slugField.slugPrefixField === "city_id") prefix = ctx.fixedCityId;
    payload[pk] = App.slugify(sourceVal, prefix);
  };

  App.buildFormFieldsHtml = function buildFormFieldsHtml(meta, row, ctx) {
    const isNew = !row || !row[meta.pk];
    const fieldCtx = { ...ctx, isNew, pk: meta.pk };
    let html = App.renderContextBanner(ctx) + App.renderHiddenContextFields(ctx);

    meta.fields.forEach((f) => {
      if (!App.shouldRenderField(f, fieldCtx)) return;
      const val = App.fieldToFormValue(f, row ? row[f.key] : "");
      html += App.renderFieldBlock(f, val, fieldCtx);
    });

    const advancedFields = meta.fields.filter((f) => f.advanced && f.type !== "slug");
    if (isNew && advancedFields.length) {
      html += `<details class="advanced-fields"><summary>高级选项</summary><div class="advanced-inner">`;
      advancedFields.forEach((f) => {
        html += App.renderFieldBlock(f, App.fieldToFormValue(f, row ? row[f.key] : ""), { ...fieldCtx, showAdvanced: true });
      });
      html += `</div></details>`;
    }
    return html;
  };

  App.collectFormPayload = async function collectFormPayload(form, meta, row, isNew, ctx = {}) {
    const payload = { updated_at: new Date().toISOString() };
    const fieldCtx = { ...ctx, isNew };

    for (const f of meta.fields) {
      if (f.readonly || f.type === "audio_upload" || f.type === "image_upload") continue;
      if (f.type === "image_preview" || f.type === "audio_preview") {
        const v = App.readFieldValue(f, form);
        if (v) payload[f.key] = v;
        continue;
      }
      if (f.type === "slug" && isNew && !ctx.showSlug) continue;
      const v = App.readFieldValue(f, form);
      if (v !== undefined) payload[f.key] = v;
    }

    if (ctx.fixedCityId) payload.city_id = ctx.fixedCityId;
    if (ctx.fixedAttractionId) payload.attraction_id = ctx.fixedAttractionId;
    App.ensureRecordId(payload, meta, form, fieldCtx);

    const audioField = meta.fields.find((f) => f.type === "audio_upload");
    if (audioField) {
      const fileInput = form.elements[audioField.key];
      const guideId = payload.id || row?.[meta.pk];
      if (fileInput?.files?.[0]) {
        if (!guideId) throw new Error("请先填写标题并保存，再上传音频");
        payload.audio_url = await App.uploadAudioGuideFile(fileInput.files[0], guideId);
      }
    }

    const imageField = meta.fields.find((f) => f.type === "image_upload");
    if (imageField) {
      const fileInput = form.elements[imageField.key];
      const entityId = payload.id || row?.[meta.pk];
      if (fileInput?.files?.[0]) {
        if (!entityId) throw new Error("请先填写名称并保存，再上传封面");
        const folder = imageField.uploadFolder || "misc";
        payload[imageField.uploadTarget || "cover_image_path"] = await App.uploadCoverImage(
          fileInput.files[0],
          folder,
          entityId
        );
      }
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
        const payload = await App.collectFormPayload(form, meta, row, false);
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
    await App.renderSingleForm("app_settings", "global");
    App.$("#page-title").textContent = App.TABLES.app_settings.label;
  };

  App.renderEmergencyConfig = async function renderEmergencyConfig() {
    await App.renderSingleForm("emergency_config", "global");
    App.$("#page-title").textContent = App.TABLES.emergency_config.label;
  };

  App.renderTable = async function renderTable(table, filterFn) {
    const meta = App.TABLES[table];
    const main = App.$("#main-content");

    let query = App.client.from(table).select("*");
    if (meta.order) query = query.order(meta.order, { ascending: true });

    const { data, error } = await query;
    if (error) {
      main.innerHTML = `<div class="status-bar error">${App.escapeHtml(error.message)}</div>`;
      return;
    }

    let rows = data || [];
    if (filterFn) rows = rows.filter(filterFn);

    const cols = meta.listColumns || [];
    let html = `<div class="table-wrap"><table><thead><tr>`;
    cols.forEach((c) => {
      html += `<th>${App.escapeHtml(App.getListColumnLabel(c))}</th>`;
    });
    html += `<th>操作</th></tr></thead><tbody>`;

    rows.forEach((row) => {
      html += "<tr>";
      cols.forEach((c) => {
        html += `<td>${App.formatListCell(c, row)}</td>`;
      });
      html += `<td>
        <button class="btn btn-sm btn-secondary" data-edit-id="${App.escapeHtml(String(row[meta.pk]))}">编辑</button>
        <button class="btn btn-sm btn-danger" data-del="${App.escapeHtml(String(row[meta.pk]))}">删除</button>
      </td></tr>`;
    });

    html += "</tbody></table></div>";
    main.innerHTML = html;

    main.querySelectorAll("[data-edit-id]").forEach((btn) => {
      btn.addEventListener("click", async () => {
        const id = btn.dataset.editId;
        const { data: row } = await App.client.from(table).select("*").eq(meta.pk, id).single();
        App.openModal(row, table);
      });
    });

    main.querySelectorAll("[data-del]").forEach((btn) => {
      btn.addEventListener("click", async () => {
        if (!confirm("确定删除？")) return;
        const { error: err } = await App.client.from(table).delete().eq(meta.pk, btn.dataset.del);
        if (err) App.showToast(err.message, "error");
        else {
          App.showToast("已删除");
          await App.loadRefCache(true);
          await App.renderTable(table, filterFn);
        }
      });
    });
  };

  App.openModal = async function openModal(row, tableOverride, ctxExtra) {
    await App.loadRefCache();
    const table = tableOverride || App.currentTable;
    const meta = App.TABLES[table];
    const isNew = !row || !row[meta.pk];
    const title = isNew ? `新建 · ${meta.label}` : `编辑 · ${meta.label}`;
    const wide = meta.fields.some((f) =>
      ["itinerary_builder", "richtext", "segment_list"].includes(f.type)
    );

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
      fixedCityId: ctxExtra?.fixedCityId || row?.city_id || null,
      fixedAttractionId: ctxExtra?.fixedAttractionId || row?.attraction_id || null,
      formEl: form,
    };
    form.innerHTML = App.buildFormFieldsHtml(meta, row || {}, ctx);
    App.mountFieldInteractions(form, meta, ctx);

    document.body.appendChild(backdrop);
    backdrop.querySelector("#modal-cancel").onclick = () => backdrop.remove();
    backdrop.addEventListener("click", (e) => {
      if (e.target === backdrop) backdrop.remove();
    });

    form.addEventListener("submit", async (e) => {
      e.preventDefault();
      try {
        const payload = await App.collectFormPayload(form, meta, row || {}, isNew, ctx);
        let err;
        if (isNew) {
          ({ error: err } = await App.client.from(table).insert(payload));
        } else {
          ({ error: err } = await App.client.from(table).update(payload).eq(meta.pk, row[meta.pk]));
        }
        if (err) throw err;
        backdrop.remove();
        App.showToast("已保存");
        await App.loadRefCache(true);
        if (ctxExtra?.onSaved) await ctxExtra.onSaved();
        else await App.loadCurrentSection();
      } catch (ex) {
        App.showToast(ex.message, "error");
      }
    });
  };
})();
