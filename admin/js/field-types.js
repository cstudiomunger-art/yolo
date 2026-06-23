/* ChinaGo Admin — visual field renderers and value readers */

(function () {
  const App = window.ChinaGoAdmin;

  App.fieldToFormValue = function fieldToFormValue(field, value) {
    if (field.type === "bool") {
      if (value === null || value === undefined || value === "") {
        return field.defaultTrue === true;
      }
      return !!value;
    }
    if (field.type === "tags" || field.type === "features_list") {
      if (Array.isArray(value)) return value.join("\n");
      if (typeof value === "string" && value.includes("\n")) return value;
      return value || "";
    }
    if (
      field.type === "ref_cities_multi" ||
      field.type === "ref_countries_multi" ||
      field.type === "ref_attractions_multi" ||
      field.type === "ref_ports_multi" ||
      field.type === "enum_multi"
    ) {
      return Array.isArray(value) ? value : [];
    }
    if (
      field.type === "json" ||
      field.type === "string_list" ||
      field.type === "image_url_list" ||
      field.type === "place_list" ||
      field.type === "segment_list" ||
      field.type === "visa_detail_list" ||
      field.type === "practical_info_list" ||
      field.type === "contact_list" ||
      field.type === "link_list" ||
      field.type === "content_blocks_list" ||
      field.type === "flight_platform_list" ||
      field.type === "help_phrase_list" ||
      field.type === "itinerary_builder"
    ) {
      if (value === null || value === undefined) {
        if (field.type === "string_list" || field.type === "image_url_list" || field.type === "practical_info_list") {
          return [];
        }
        if (field.type === "contact_list") return [];
        return field.type === "itinerary_builder" ? [] : [];
      }
      return typeof value === "string" ? JSON.parse(value) : value;
    }
    if (field.type === "enum" && field.options?.[0]?.value !== undefined) {
      return value ?? "";
    }
    if (value === null || value === undefined) return "";
    return value;
  };

  App.normalizeEnumOptions = function normalizeEnumOptions(options) {
    if (!options?.length) return [];
    if (typeof options[0] === "string") return options.map((o) => ({ value: o, label: o }));
    return options;
  };

  App.renderFieldBlock = function renderFieldBlock(field, value, ctx) {
    if (field.type === "section") {
      const hint = field.hint
        ? `<p class="field-hint section-hint">${App.escapeHtml(field.hint)}</p>`
        : "";
      return `<div class="form-section"><h3 class="form-section-title">${App.escapeHtml(field.label || "")}</h3>${hint}</div>`;
    }

    const label = field.label || field.key;
    const name = field.key;
    const ro = field.readonly || (!ctx.isNew && field.key === ctx.pk) ? "readonly" : "";
    const advanced = field.advanced ? ' data-advanced="1"' : "";
    let inner = "";

    switch (field.type) {
      case "bool":
        inner = `<label class="toggle field-toggle">
          <input type="checkbox" name="${name}" ${value ? "checked" : ""} ${ro} />
          <span></span>
        </label>`;
        break;
      case "textarea":
        inner = `<textarea name="${name}" ${ro}>${App.escapeHtml(String(value))}</textarea>`;
        break;
      case "richtext":
        inner = App.renderRichTextHost(name, String(value ?? ""), {
          uploadFolder: field.uploadFolder,
          uploadEntityField: field.uploadEntityField,
          uploadSlugSource: field.uploadSlugSource,
          uploadSlugPrefix: field.uploadSlugPrefix,
          uploadSlugPrefixField: field.uploadSlugPrefixField,
        });
        break;
      case "number":
        inner = `<input name="${name}" type="number" value="${App.escapeHtml(String(value))}" ${ro} />`;
        break;
      case "enum": {
        const opts = App.normalizeEnumOptions(field.options);
        // Pre-select field.default for new rows so NOT NULL enum columns never submit null.
        const ev = (value === undefined || value === null || value === "")
          ? (field.default ?? "")
          : value;
        const placeholder = field.default ? "" : `<option value="">— 请选择 —</option>`;
        inner = `<select name="${name}" ${ro}>${placeholder}`;
        opts.forEach((o) => {
          inner += `<option value="${App.escapeHtml(o.value)}" ${ev === o.value ? "selected" : ""}>${App.escapeHtml(o.label)}</option>`;
        });
        inner += `</select>`;
        break;
      }
      case "ref_city":
        inner = App.renderRefCitySelect(name, value, field);
        break;
      case "ref_attraction":
        inner = App.renderRefAttractionSelect(name, value, field, ctx);
        break;
      case "ref_scenario":
        inner = App.renderRefScenarioSelect(name, value, field);
        break;
      case "ref_country":
        inner = App.renderRefCountrySelect(name, value);
        break;
      case "ref_user":
        inner = App.renderRefUserSelect(name, value, field);
        break;
      case "ref_visa_policy_v2":
        inner = App.renderRefVisaPolicyV2Select(name, value, field);
        break;
      case "payment_match":
        inner = App.renderPaymentMatch(name, value);
        break;
      case "ref_cities_multi":
        inner = App.renderRefCitiesMulti(name, value);
        break;
      case "ref_attractions_multi":
        inner = App.renderRefAttractionsMulti(name, value);
        break;
      case "ref_countries_multi":
        inner = App.renderRefCountriesMulti(name, value);
        break;
      case "ref_ports_multi":
        inner = App.renderRefPortsMulti(name, value);
        break;
      case "enum_multi":
        inner = App.renderEnumMulti(name, value, field);
        break;
      case "ref_audio_guide":
        inner = App.renderRefAudioGuideSelect(name, value, field, ctx);
        break;
      case "link_list":
        inner = App.renderLinkList(name, value);
        break;
      case "content_blocks_list":
        inner = App.renderContentBlocksList(name, value, field);
        break;
      case "flight_platform_list":
        inner = App.renderFlightPlatformList(name, value);
        break;
      case "help_phrase_list":
        inner = App.renderHelpPhraseList(name, value);
        break;
      case "slug":
        inner = `<input name="${name}" type="text" value="${App.escapeHtml(String(value))}" ${ctx.isNew ? "" : "readonly"} class="slug-input" data-slug-source="${field.slugSource || ""}" data-slug-prefix="${field.slugPrefix || ""}" data-slug-prefix-field="${field.slugPrefixField || ""}" />`;
        if (ctx.isNew) inner += `<div class="field-hint">根据名称自动生成，可在高级选项中修改</div>`;
        break;
      case "tags":
        inner = `<input name="${name}" type="text" value="${App.escapeHtml(String(value))}" placeholder="逗号分隔" ${ro} />`;
        break;
      case "features_list":
        inner = `<textarea name="${name}" class="features-list-area" rows="4" placeholder="每行一条权益" ${ro}>${App.escapeHtml(String(value))}</textarea>`;
        break;
      case "string_list":
        inner = App.renderStringList(name, value);
        break;
      case "image_url_list":
        inner = App.renderImageUrlList(name, value, field);
        break;
      case "place_list":
        inner = App.renderPlaceList(name, value);
        break;
      case "segment_list":
        inner = App.renderSegmentList(name, value);
        break;
      case "visa_detail_list":
        inner = App.renderVisaDetailList(name, value);
        break;
      case "practical_info_list":
        inner = App.renderPracticalInfoList(name, value, field);
        break;
      case "contact_list":
        inner = App.renderContactList(name, value);
        break;
      case "itinerary_builder":
        inner = App.renderItineraryBuilder(name, value);
        break;
      case "image_preview":
        inner = App.renderImagePreview(name, value);
        break;
      case "audio_preview":
        inner = App.renderAudioPreview(name, value);
        break;
      case "image_upload":
        inner = `<div class="image-upload-wrap">
          <label class="btn btn-sm btn-secondary image-file-label">选择本地图片
            <input type="file" name="${name}" class="image-upload-input" accept="image/jpeg,image/png,image/webp" data-upload-folder="${field.uploadFolder || ""}" data-upload-target="${field.uploadTarget || ""}" hidden />
          </label>
          <span class="image-upload-filename muted"></span>
          <div class="image-upload-preview" hidden></div>
          <p class="field-hint">保存表单时自动上传到 Storage</p>
        </div>`;
        break;
      case "audio_upload":
        inner = `<div class="audio-upload-wrap">
          <label class="btn btn-sm btn-secondary audio-file-label">选择本地音频
            <input type="file" name="${name}" class="audio-upload-input" accept="audio/*,.mp3,.m4a,.wav,.aac,.mpeg" hidden />
          </label>
          <span class="audio-upload-status muted"></span>
          <div class="audio-upload-preview media-preview" hidden></div>
          <p class="field-hint">${field.subAreaDirect ? "选择后自动上传至 Storage；需先填写子区域英文名" : "选择后自动上传；成功后会更新「当前音频」"}</p>
        </div>`;
        break;
      case "json":
        inner = `<textarea name="${name}" class="json-area">${App.escapeHtml(typeof value === "string" ? value : JSON.stringify(value, null, 2))}</textarea>`;
        break;
      default:
        inner = `<input name="${name}" type="text" value="${App.escapeHtml(String(value))}" ${ro} ${field.autoFromCountry ? 'data-auto-country="1"' : ""} />`;
    }

    const hintHtml = field.hint
      ? `<p class="field-hint">${App.escapeHtml(field.hint)}</p>`
      : "";
    if (field.type === "bool") {
      return `<div class="field-block field-block--bool" data-field-key="${App.escapeHtml(name)}"${advanced}><span class="field-label">${App.escapeHtml(label)}</span>${inner}${hintHtml}</div>`;
    }
    return `<div class="field-block" data-field-key="${App.escapeHtml(name)}"${advanced}><label>${App.escapeHtml(label)}</label>${inner}${hintHtml}</div>`;
  };

  App.renderRefCitySelect = function renderRefCitySelect(name, value, field) {
    let html = `<select name="${name}" data-ref-city="1"><option value="">${field.emptyLabel || "— 选择城市 —"}</option>`;
    App.refCache.cities.forEach((c) => {
      html += `<option value="${App.escapeHtml(c.id)}" ${value === c.id ? "selected" : ""}>${App.escapeHtml(`${c.emoji || ""} ${c.chinese_name || c.name}`.trim())}</option>`;
    });
    html += `</select>`;
    return html;
  };

  App.renderRefAttractionSelect = function renderRefAttractionSelect(name, value, field, ctx) {
    const filterField = field.filterByCityField;
    let cityId = ctx.fixedCityId || "";
    if (filterField && ctx.formEl?.elements[filterField]) {
      cityId = ctx.formEl.elements[filterField].value || cityId;
    }
    const list = App.attractionsForCity(cityId || null);
    let html = `<select name="${name}" data-ref-attraction="1" data-filter-field="${filterField || ""}"><option value="">${field.allowEmpty ? "— 不关联 —" : "— 选择景点 —"}</option>`;
    list.forEach((a) => {
      const label = `${a.chinese_name || a.name}（${App.cityLabel(a.city_id)}）`;
      html += `<option value="${App.escapeHtml(a.id)}" ${value === a.id ? "selected" : ""}>${App.escapeHtml(label)}</option>`;
    });
    html += `</select>`;
    return html;
  };

  App.renderRefScenarioSelect = function renderRefScenarioSelect(name, value, field) {
    let html = `<select name="${name}" data-ref-scenario="1"><option value="">${field?.allowEmpty ? "— 不关联 —" : "— 选择场景 —"}</option>`;
    App.refCache.scenarios
      .filter((s) => s.is_active !== false)
      .forEach((s) => {
        html += `<option value="${App.escapeHtml(s.id)}" ${value === s.id ? "selected" : ""}>${App.escapeHtml(s.label || s.id)}</option>`;
      });
    html += `<option value="__new__">+ 新建场景…</option></select>`;
    return html;
  };

  App.renderAttractionSelectOptions = function renderAttractionSelectOptions(cityId, selectedId) {
    let html = `<option value="">— 无景点 —</option>`;
    App.attractionsForCity(cityId || null).forEach((a) => {
      html += `<option value="${App.escapeHtml(a.id)}" ${selectedId === a.id ? "selected" : ""}>${App.escapeHtml(a.chinese_name || a.name)}</option>`;
    });
    return html;
  };

  App.renderRefCountrySelect = function renderRefCountrySelect(name, value) {
    let html = `<select name="${name}" data-ref-country="1"><option value="">— 选择国家 —</option>`;
    App.refCache.countries.forEach((c) => {
      html += `<option value="${App.escapeHtml(c.code)}" ${value === c.code ? "selected" : ""}>${App.escapeHtml(`${c.flag || ""} ${c.name}`.trim())}</option>`;
    });
    html += `</select>`;
    return html;
  };

  App.renderRefUserSelect = function renderRefUserSelect(name, value, field) {
    let html = `<select name="${name}"><option value="">${field?.emptyLabel || "— 选择登录账号（邮箱）—"}</option>`;
    (App.refCache.users || []).forEach((u) => {
      const label = u.email || u.display_name || u.id;
      html += `<option value="${App.escapeHtml(u.id)}" ${value === u.id ? "selected" : ""}>${App.escapeHtml(label)}</option>`;
    });
    html += `</select>`;
    return html;
  };

  // Dynamic policy picker — options come from visa_policies_v2 so new policies appear
  // automatically (no hardcoded enum to maintain when China adds a visa-free scheme).
  App.renderRefVisaPolicyV2Select = function renderRefVisaPolicyV2Select(name, value, field) {
    let html = `<select name="${name}"><option value="">${field?.emptyLabel || "— 选择政策 —"}</option>`;
    (App.refCache.visaPoliciesV2 || []).forEach((p) => {
      const label = `${p.id} · ${p.official_name_zh || ""}`.trim();
      html += `<option value="${App.escapeHtml(p.id)}" ${value === p.id ? "selected" : ""}>${App.escapeHtml(label)}</option>`;
    });
    // Keep a stale/unknown value visible so editing an old grant never silently drops it.
    if (value && !(App.refCache.visaPoliciesV2 || []).some((p) => p.id === value)) {
      html += `<option value="${App.escapeHtml(value)}" selected>${App.escapeHtml(value)}</option>`;
    }
    html += `</select>`;
    return html;
  };

  // Structured editor for payment_advice_rules.match_json:
  //   { country?: string[], cards_exclude?: string[], trip?: 'city'|'both'|'remote' }
  App.renderPaymentMatch = function renderPaymentMatch(name, value) {
    const v = value && typeof value === "object" ? value : {};
    const countries = (Array.isArray(v.country) ? v.country : []).map((c) => String(c).toUpperCase());
    const cards = Array.isArray(v.cards_exclude) ? v.cards_exclude : [];
    const trip = v.trip || "";
    const cardOpts = [["visa", "Visa"], ["mc", "Mastercard"], ["jcb", "JCB"], ["unionpay", "银联 UnionPay"], ["amex", "Amex"]];

    let html = `<div class="checkbox-grid" data-name="${name}" data-payment-match="1">`;

    html += `<div class="checkbox-group" data-pm="country" style="width:100%"><span class="checkbox-group-label">国家 country（不选 = 对所有国家显示）</span>`;
    (App.refCache.countries || []).forEach((c) => {
      const code = String(c.code).toUpperCase();
      const checked = countries.includes(code) ? "checked" : "";
      html += `<label class="checkbox-chip"><input type="checkbox" value="${App.escapeHtml(c.code)}" ${checked} /> ${App.escapeHtml(`${c.flag || ""} ${c.name}`)}</label>`;
    });
    html += `</div>`;

    html += `<div class="checkbox-group" data-pm="cards" style="width:100%"><span class="checkbox-group-label">用户「没有」这些卡时才显示 cards_exclude（不选 = 不限）</span>`;
    cardOpts.forEach(([val, label]) => {
      const checked = cards.includes(val) ? "checked" : "";
      html += `<label class="checkbox-chip"><input type="checkbox" value="${val}" ${checked} /> ${label}</label>`;
    });
    html += `</div>`;

    html += `<div class="checkbox-group" style="width:100%"><span class="checkbox-group-label">行程类型 trip（不选 = 不限）</span>`;
    html += `<select data-pm="trip"><option value="">不限</option>`;
    [["city", "大城市为主"], ["both", "城市 + 乡村"], ["remote", "主要偏远"]].forEach(([val, label]) => {
      html += `<option value="${val}" ${trip === val ? "selected" : ""}>${label}</option>`;
    });
    html += `</select></div>`;

    html += `</div>`;
    return html;
  };

  App.renderRefCitiesMulti = function renderRefCitiesMulti(name, selectedIds) {
    const ids = Array.isArray(selectedIds) ? selectedIds : [];
    let html = `<div class="checkbox-grid" data-name="${name}">`;
    App.refCache.cities.forEach((c) => {
      const checked = ids.includes(c.id) ? "checked" : "";
      html += `<label class="checkbox-chip"><input type="checkbox" value="${App.escapeHtml(c.id)}" ${checked} /> ${App.escapeHtml(`${c.emoji || ""} ${c.chinese_name || c.name}`)}</label>`;
    });
    html += `</div>`;
    return html;
  };

  App.renderRefAttractionsMulti = function renderRefAttractionsMulti(name, selectedIds) {
    const ids = Array.isArray(selectedIds) ? selectedIds : [];
    let html = `<div class="checkbox-grid checkbox-grid--attractions" data-name="${name}">`;
    const byCity = {};
    (App.refCache.attractions || []).forEach((a) => {
      const cid = a.city_id || "_";
      if (!byCity[cid]) byCity[cid] = [];
      byCity[cid].push(a);
    });
    Object.keys(byCity)
      .sort((a, b) => App.cityLabel(a).localeCompare(App.cityLabel(b), "zh"))
      .forEach((cityId) => {
        html += `<div class="checkbox-group"><span class="checkbox-group-label">${App.escapeHtml(App.cityLabel(cityId))}</span>`;
        byCity[cityId].forEach((a) => {
          const checked = ids.includes(a.id) ? "checked" : "";
          html += `<label class="checkbox-chip"><input type="checkbox" value="${App.escapeHtml(a.id)}" ${checked} /> ${App.escapeHtml(a.chinese_name || a.name)}</label>`;
        });
        html += `</div>`;
      });
    if (!App.refCache.attractions?.length) {
      html += `<p class="muted">暂无景点数据，请先加载城市内容。</p>`;
    }
    html += `</div>`;
    return html;
  };

  App.renderEnumMulti = function renderEnumMulti(name, selected, field) {
    const ids = Array.isArray(selected) ? selected : [];
    const opts = App.normalizeEnumOptions(field.options || []);
    let html = `<div class="checkbox-grid" data-name="${name}">`;
    opts.forEach((o) => {
      const checked = ids.includes(o.value) ? "checked" : "";
      html += `<label class="checkbox-chip"><input type="checkbox" value="${App.escapeHtml(o.value)}" ${checked} /> ${App.escapeHtml(o.label)}</label>`;
    });
    html += `</div>`;
    return html;
  };

  App.renderRefCountriesMulti = function renderRefCountriesMulti(name, selectedCodes) {
    const codes = Array.isArray(selectedCodes) ? selectedCodes : [];
    let html = `<div class="checkbox-grid" data-name="${name}">`;
    App.refCache.countries.forEach((c) => {
      const checked = codes.includes(c.code) ? "checked" : "";
      html += `<label class="checkbox-chip"><input type="checkbox" value="${App.escapeHtml(c.code)}" ${checked} /> ${App.escapeHtml(`${c.flag || ""} ${c.name}`.trim())}</label>`;
    });
    html += `</div>`;
    return html;
  };

  App.renderRefPortsMulti = function renderRefPortsMulti(name, selectedCodes) {
    const codes = Array.isArray(selectedCodes) ? selectedCodes : [];
    const ports = App.refCache.ports || [];
    let html = `<div class="checkbox-grid" data-name="${name}">`;
    ports.forEach((p) => {
      const checked = codes.includes(p.code) ? "checked" : "";
      const inactive = p.is_active === false ? "（停用）" : "";
      html += `<label class="checkbox-chip"><input type="checkbox" value="${App.escapeHtml(p.code)}" ${checked} /> ${App.escapeHtml(`${p.name_zh || ""} · ${p.code}${inactive}`.trim())}</label>`;
    });
    // Keep any code referenced by the policy but absent from visa_ports (so editing never
    // silently drops it) — surfaces the namespace gap instead of hiding it.
    codes.filter((c) => !ports.some((p) => p.code === c)).forEach((c) => {
      html += `<label class="checkbox-chip"><input type="checkbox" value="${App.escapeHtml(c)}" checked /> ⚠️ ${App.escapeHtml(c)}（不在口岸维表）</label>`;
    });
    html += `</div>`;
    if (!ports.length) html += `<div class="field-hint">口岸维表为空，请先在「口岸维表（IATA）」中添加</div>`;
    return html;
  };

  App.resolveAudioGuideAttractionId = function resolveAudioGuideAttractionId(ctx, filterField = "attraction_id") {
    const host = ctx.formEl?.classList?.contains?.("sub-area-inline-form")
      ? ctx.formEl
      : ctx.formEl?.closest?.(".sub-area-inline-form");
    let attractionId =
      ctx.fixedAttractionId || host?.dataset?.attractionId || ctx.formEl?.dataset?.attractionId || "";
    if (!attractionId && ctx.formEl?.elements?.[filterField]) {
      attractionId = ctx.formEl.elements[filterField].value || attractionId;
    }
    if (!attractionId && ctx.formEl?.querySelector?.(`[name="${filterField}"]`)) {
      attractionId = ctx.formEl.querySelector(`[name="${filterField}"]`).value || attractionId;
    }
    return attractionId;
  };

  App.renderRefAudioGuideSelect = function renderRefAudioGuideSelect(name, value, field, ctx) {
    const filterField = field.filterByAttractionField || "attraction_id";
    const attractionId = App.resolveAudioGuideAttractionId(ctx, filterField);
    const list = App.listAudioGuidesForPicker(attractionId, ctx);
    let html = `<select name="${name}" data-ref-audio-guide="1" data-filter-attraction-field="${filterField}" data-attraction-id="${App.escapeHtml(attractionId)}"><option value="">${field.allowEmpty ? "— 不关联音频 —" : "— 选择音频导览 —"}</option>`;
    list.forEach((g) => {
      html += `<option value="${App.escapeHtml(g.id)}" ${value === g.id ? "selected" : ""}>${App.escapeHtml(g.title_en || g.id)}</option>`;
    });
    if (value && !list.some((g) => g.id === value)) {
      html += `<option value="${App.escapeHtml(value)}" selected>${App.escapeHtml(App.audioGuideLabel(value))}</option>`;
    }
    if (attractionId && !list.length) {
      html += `<option value="" disabled>请先在下方「语音导览」或侧栏「音频导览」中添加</option>`;
    }
    html += `</select>`;
    const countHint =
      list.length > 0
        ? ` (${list.length} 条可选)`
        : attractionId
          ? " (暂无导览)"
          : " (请先选择所属景点)";
    html += `<span class="field-hint audio-guide-picker-hint">${App.escapeHtml(countHint)}</span>`;
    return html;
  };

  App.refreshAudioGuideSelects = function refreshAudioGuideSelects(form, meta, ctx) {
    const root = ctx.scopeRoot || form;
    const field = meta.fields.find((f) => f.key === "audio_guide_id");
    if (!field) return;
    root.querySelectorAll('[name="audio_guide_id"]').forEach((sel) => {
      const inlineForm = sel.closest(".sub-area-inline-form");
      const pickCtx = inlineForm
        ? {
            ...ctx,
            formEl: inlineForm,
            fixedAttractionId:
              ctx.fixedAttractionId ||
              inlineForm.dataset.attractionId ||
              sel.dataset.attractionId ||
              "",
            includeInactiveAudioGuides: true,
            getAudioGuides: ctx.getAudioGuides,
          }
        : { ...ctx, formEl: ctx.formEl || form };
      const attractionId = App.resolveAudioGuideAttractionId(
        pickCtx,
        field.filterByAttractionField
      );
      const guides = App.listAudioGuidesForPicker(attractionId, pickCtx);
      const current =
        inlineForm?.dataset?.pendingAudioGuideId?.trim() || sel.value;
      App.populateAudioGuideSelect(sel, guides, {
        value: current,
        allowEmpty: field.allowEmpty,
        emptyLabel: field.allowEmpty ? "— 不关联音频 —" : "— 选择音频导览 —",
        attractionId,
      });
      const hint = sel.parentElement?.querySelector(".audio-guide-picker-hint");
      if (hint) {
        hint.textContent =
          guides.length > 0
            ? ` (${guides.length} 条可选)`
            : attractionId
              ? " (暂无导览)"
              : " (请先选择所属景点)";
      }
    });
  };

  App.renderStringList = function renderStringList(name, items) {
    const arr = Array.isArray(items) ? items : [];
    let html = `<div class="list-builder" data-list-type="string" data-name="${name}">`;
    arr.forEach((item, i) => {
      html += `<div class="list-row"><input type="text" value="${App.escapeHtml(String(item))}" data-idx="${i}" /><button type="button" class="btn btn-sm btn-danger list-rm">删</button></div>`;
    });
    html += `<button type="button" class="btn btn-sm btn-secondary list-add">+ 添加一条</button></div>`;
    return html;
  };

  App.renderImageUrlRow = function renderImageUrlRow(url, i, opts = {}) {
    const showUrl = opts.showUrl !== false;
    const thumb = url
      ? `<img src="${App.escapeHtml(url)}" alt="" class="image-url-thumb" />`
      : `<span class="image-url-placeholder">预览</span>`;
    const urlInput = showUrl
      ? `<input type="text" class="image-url-input" value="${App.escapeHtml(String(url || ""))}" placeholder="图片 URL（上传后自动填入）" data-idx="${i}" />`
      : `<input type="hidden" class="image-url-input" value="${App.escapeHtml(String(url || ""))}" data-idx="${i}" />`;
    const uploadBtn = showUrl
      ? `<label class="btn btn-sm btn-secondary image-file-label">本地上传
        <input type="file" class="image-file-input" accept="image/jpeg,image/png,image/webp" hidden />
      </label>`
      : `<input type="file" class="image-file-input" accept="image/jpeg,image/png,image/webp" hidden />`;
    return `<div class="list-row list-row--image${showUrl ? "" : " list-row--image-pending"}">
      <div class="image-url-thumb-wrap">${thumb}</div>
      ${urlInput}
      ${uploadBtn}
      <button type="button" class="btn btn-sm btn-danger list-rm">删</button>
    </div>`;
  };

  App.renderImageUrlList = function renderImageUrlList(name, items, field) {
    const arr = Array.isArray(items) ? items : [];
    const folder = field.uploadFolder || "misc";
    const uploadPrimary = field.uploadPrimary === true;
    let html = `<div class="list-builder list-builder--images" data-list-type="image_url" data-name="${name}" data-upload-folder="${App.escapeHtml(folder)}"${uploadPrimary ? ' data-upload-primary="1"' : ""}>`;
    arr.forEach((item, i) => {
      html += App.renderImageUrlRow(item, i, { showUrl: !uploadPrimary || Boolean(item) });
    });
    if (uploadPrimary) {
      html += `<div class="image-list-toolbar">
        <label class="btn btn-sm btn-secondary image-file-label">+ 本地上传
          <input type="file" class="image-bulk-input" accept="image/jpeg,image/png,image/webp" multiple hidden />
        </label>
        <button type="button" class="btn btn-sm btn-secondary list-add-url">+ 粘贴 URL</button>
      </div>`;
    } else {
      html += `<button type="button" class="btn btn-sm btn-secondary list-add">+ 添加图片</button>`;
    }
    html += `</div>`;
    return html;
  };

  App.addImageUrlRowWithFile = function addImageUrlRowWithFile(box, file, showUrl) {
    const anchor = box.querySelector(".image-list-toolbar, .list-add");
    const i = box.querySelectorAll(".list-row--image").length;
    const tmp = document.createElement("div");
    tmp.innerHTML = App.renderImageUrlRow("", i, { showUrl: showUrl !== false });
    const row = tmp.firstChild;
    if (anchor) anchor.insertAdjacentElement("beforebegin", row);
    else box.appendChild(row);
    const fileInput = App.$(".image-file-input", row);
    if (file && fileInput) {
      const dt = new DataTransfer();
      dt.items.add(file);
      fileInput.files = dt.files;
      App.bindImageFileInput(fileInput, { row });
      const thumbWrap = row.querySelector(".image-url-thumb-wrap");
      if (thumbWrap) {
        const objectUrl = URL.createObjectURL(file);
        thumbWrap.innerHTML = `<img src="${objectUrl}" alt="" class="image-url-thumb" />`;
      }
    }
    return row;
  };

  App.renderPlaceList = function renderPlaceList(name, items) {
    const arr = Array.isArray(items) ? items : [];
    let html = `<div class="list-builder" data-list-type="place" data-name="${name}"><div class="list-header"><span>名称</span><span>距离</span><span></span></div>`;
    arr.forEach((item, i) => {
      html += `<div class="list-row"><input type="text" placeholder="名称" value="${App.escapeHtml(item.name || "")}" data-field="name" data-idx="${i}" /><input type="text" placeholder="距离" value="${App.escapeHtml(item.distance || "")}" data-field="distance" data-idx="${i}" /><button type="button" class="btn btn-sm btn-danger list-rm">删</button></div>`;
    });
    html += `<button type="button" class="btn btn-sm btn-secondary list-add">+ 添加地点</button></div>`;
    return html;
  };

  App.renderSegmentList = function renderSegmentList(name, items) {
    const arr = Array.isArray(items) ? items : [];
    let html = `<div class="list-builder" data-list-type="segment" data-name="${name}"><div class="list-header"><span>章节标题</span><span>开始秒</span><span></span></div>`;
    arr.forEach((item, i) => {
      html += `<div class="list-row"><input type="text" value="${App.escapeHtml(item.title || "")}" data-field="title" data-idx="${i}" placeholder="如 Intro / History" /><input type="number" value="${item.start_seconds ?? 0}" data-field="start_seconds" data-idx="${i}" min="0" /><button type="button" class="btn btn-sm btn-danger list-rm">删</button></div>`;
    });
    html += `<button type="button" class="btn btn-sm btn-secondary list-add">+ 添加章节</button></div>`;
    return html;
  };

  App.renderPracticalInfoRow = function renderPracticalInfoRow(item, i) {
    return `<div class="list-row">
      <input type="text" class="practical-icon-input" placeholder="图标" value="${App.escapeHtml(item.icon || "")}" data-field="icon" data-idx="${i}" maxlength="4" />
      <input type="text" placeholder="标签（如 Ticket）" value="${App.escapeHtml(item.label || "")}" data-field="label" data-idx="${i}" />
      <input type="text" placeholder="内容" value="${App.escapeHtml(item.value || "")}" data-field="value" data-idx="${i}" />
      <button type="button" class="btn btn-sm btn-danger list-rm">删</button>
    </div>`;
  };

  App.renderPracticalInfoList = function renderPracticalInfoList(name, items, field) {
    const arr = Array.isArray(items) ? items : [];
    const presets = field.presets || App.PRACTICAL_INFO_PRESETS || [];
    let html = `<div class="list-builder list-builder--practical" data-list-type="practical_info" data-name="${name}">`;
    html += `<div class="list-header list-header--practical"><span>图标</span><span>标签</span><span>内容</span><span></span></div>`;
    arr.forEach((item, i) => {
      html += App.renderPracticalInfoRow(item, i);
    });
    if (presets.length) {
      html += `<div class="practical-presets">`;
      presets.forEach((p) => {
        html += `<button type="button" class="btn btn-sm btn-secondary list-preset" data-preset-icon="${App.escapeHtml(p.icon || "")}" data-preset-label="${App.escapeHtml(p.label || "")}">+ ${App.escapeHtml(p.label || "")}</button>`;
      });
      html += `</div>`;
    }
    html += `<button type="button" class="btn btn-sm btn-secondary list-add">+ 添加条目</button></div>`;
    return html;
  };

  App.renderVisaDetailList = function renderVisaDetailList(name, items) {
    const arr = Array.isArray(items) ? items : [];
    let html = `<div class="list-builder" data-list-type="visa_detail" data-name="${name}"><div class="list-header"><span>标签</span><span>内容</span><span></span></div>`;
    arr.forEach((item, i) => {
      html += `<div class="list-row"><input type="text" value="${App.escapeHtml(item.label || "")}" data-field="label" data-idx="${i}" /><input type="text" value="${App.escapeHtml(item.value || "")}" data-field="value" data-idx="${i}" /><button type="button" class="btn btn-sm btn-danger list-rm">删</button></div>`;
    });
    html += `<button type="button" class="btn btn-sm btn-secondary list-add">+ 添加条目</button></div>`;
    return html;
  };

  App.renderContactList = function renderContactList(name, items) {
    const arr = Array.isArray(items) ? items : [];
    let html = `<div class="list-builder" data-list-type="contact" data-name="${name}"><div class="list-header"><span>名称</span><span>号码</span><span>备注</span><span></span></div>`;
    arr.forEach((item, i) => {
      html += `<div class="list-row"><input type="text" value="${App.escapeHtml(item.label || "")}" data-field="label" data-idx="${i}" /><input type="text" value="${App.escapeHtml(item.number || "")}" data-field="number" data-idx="${i}" /><input type="text" value="${App.escapeHtml(item.note || "")}" data-field="note" data-idx="${i}" /><button type="button" class="btn btn-sm btn-danger list-rm">删</button></div>`;
    });
    html += `<button type="button" class="btn btn-sm btn-secondary list-add">+ 添加联系人</button></div>`;
    return html;
  };

  App.renderLinkList = function renderLinkList(name, items) {
    const arr = Array.isArray(items) ? items : [];
    let html = `<div class="list-builder" data-list-type="link" data-name="${name}"><div class="list-header"><span>按钮文案</span><span>链接 URL</span><span></span></div>`;
    arr.forEach((item, i) => {
      html += `<div class="list-row"><input type="text" placeholder="如 Booking.com" value="${App.escapeHtml(item.label || "")}" data-field="label" data-idx="${i}" /><input type="url" placeholder="https://..." value="${App.escapeHtml(item.url || item.url_template || "")}" data-field="url" data-idx="${i}" /><button type="button" class="btn btn-sm btn-danger list-rm">删</button></div>`;
    });
    html += `<button type="button" class="btn btn-sm btn-secondary list-add">+ 添加链接</button></div>`;
    return html;
  };

  App.renderContentBlockRow = function renderContentBlockRow(item, i) {
    const blockType = App.inferContentBlockType(item);
    const imagePath =
      item.imagePath || item.image_path || (blockType === "image" ? item.body || "" : "");
    const thumb = imagePath
      ? `<img src="${App.escapeHtml(imagePath)}" alt="" class="image-url-thumb" />`
      : `<span class="image-url-placeholder">预览</span>`;
    const typeOpts = [
      { value: "heading", label: "标题" },
      { value: "paragraph", label: "正文" },
      { value: "image", label: "图片" },
    ]
      .map(
        (o) =>
          `<option value="${o.value}" ${blockType === o.value ? "selected" : ""}>${o.label}</option>`
      )
      .join("");
    return `<div class="list-row list-row--content-block" data-block-type="${blockType}">
      <select data-field="block_type" class="content-block-type">${typeOpts}</select>
      <div class="content-block-fields content-block-fields--heading" ${blockType !== "heading" ? "hidden" : ""}>
        <input type="text" placeholder="标题文字" value="${App.escapeHtml(blockType === "heading" ? item.title || "" : "")}" data-field="title" data-idx="${i}" />
      </div>
      <div class="content-block-fields content-block-fields--paragraph" ${blockType !== "paragraph" ? "hidden" : ""}>
        <div class="rich-text-host rich-text-host--compact content-block-body-host" data-field="body">
          <div class="rich-text-editor">${blockType === "paragraph" ? App.plainTextToHtml(item.body || "") : ""}</div>
        </div>
      </div>
      <div class="content-block-fields content-block-fields--image" ${blockType !== "image" ? "hidden" : ""}>
        <div class="image-url-thumb-wrap block-image-thumb">${thumb}</div>
        <input type="hidden" data-field="image_path" value="${App.escapeHtml(imagePath)}" />
        <input type="text" placeholder="图片说明（可选）" value="${App.escapeHtml(blockType === "image" ? item.title || "" : "")}" data-field="title" data-idx="${i}" />
        <label class="btn btn-sm btn-secondary image-file-label">本地上传
          <input type="file" class="block-image-file image-file-input" accept="image/jpeg,image/png,image/webp" hidden />
        </label>
      </div>
      <button type="button" class="btn btn-sm btn-danger list-rm">删</button>
    </div>`;
  };

  App.renderContentBlocksList = function renderContentBlocksList(name, items, field) {
    const arr = Array.isArray(items) ? items : [];
    const folder = field?.uploadFolder || "sub-areas";
    let html = `<div class="list-builder list-builder--blocks" data-list-type="content_block" data-name="${name}" data-upload-folder="${App.escapeHtml(folder)}">`;
    arr.forEach((item, i) => {
      html += App.renderContentBlockRow(item, i);
    });
    html += `<button type="button" class="btn btn-sm btn-secondary list-add">+ 添加内容块</button></div>`;
    return html;
  };

  App.renderFlightPlatformList = function renderFlightPlatformList(name, items) {
    const arr = Array.isArray(items) ? items : [];
    let html = `<div class="list-builder" data-list-type="flight_platform" data-name="${name}"><div class="list-header"><span>平台 ID</span><span>显示名</span><span>链接</span><span></span></div>`;
    arr.forEach((item, i) => {
      html += `<div class="list-row"><input type="text" placeholder="skyscanner" value="${App.escapeHtml(item.id || "")}" data-field="id" data-idx="${i}" /><input type="text" placeholder="Skyscanner" value="${App.escapeHtml(item.label || "")}" data-field="label" data-idx="${i}" /><input type="url" placeholder="https://..." value="${App.escapeHtml(item.url_template || item.url || "")}" data-field="url_template" data-idx="${i}" /><button type="button" class="btn btn-sm btn-danger list-rm">删</button></div>`;
    });
    html += `<button type="button" class="btn btn-sm btn-secondary list-add">+ 添加平台</button></div>`;
    return html;
  };

  App.renderHelpPhraseList = function renderHelpPhraseList(name, items) {
    const arr = Array.isArray(items) ? items : [];
    let html = `<div class="list-builder" data-list-type="help_phrase" data-name="${name}"><div class="list-header"><span>中文</span><span>拼音</span><span>英文</span><span></span></div>`;
    arr.forEach((item, i) => {
      html += `<div class="list-row"><input type="text" value="${App.escapeHtml(item.chinese || "")}" data-field="chinese" data-idx="${i}" /><input type="text" value="${App.escapeHtml(item.pinyin || "")}" data-field="pinyin" data-idx="${i}" /><input type="text" value="${App.escapeHtml(item.english || "")}" data-field="english" data-idx="${i}" /><button type="button" class="btn btn-sm btn-danger list-rm">删</button></div>`;
    });
    html += `<button type="button" class="btn btn-sm btn-secondary list-add">+ 添加短语</button></div>`;
    return html;
  };

  App.renderItineraryBuilder = function renderItineraryBuilder(name, days) {
    const arr = Array.isArray(days) ? days : [];
    let html = `<div class="itinerary-builder" data-name="${name}">`;
    arr.forEach((day, di) => {
      html += App.renderItineraryDay(day, di);
    });
    html += `<button type="button" class="btn btn-sm btn-secondary itin-add-day">+ 添加一天</button></div>`;
    return html;
  };

  App.renderItineraryDay = function renderItineraryDay(day, di) {
    const activities = day.activities || [];
    const cityId = day.city_id || App.cityIdFromName(day.city_name) || "";
    let cityOpts = `<option value="">— 选择城市 —</option>`;
    App.refCache.cities.forEach((c) => {
      cityOpts += `<option value="${App.escapeHtml(c.id)}" ${cityId === c.id ? "selected" : ""}>${App.escapeHtml(`${c.emoji || ""} ${c.chinese_name || c.name}`.trim())}</option>`;
    });
    let html = `<div class="itin-day" data-day-idx="${di}" data-day-id="${App.escapeHtml(day.id || `day_${di + 1}`)}" data-day-city-id="${App.escapeHtml(cityId)}">
      <div class="itin-day-head"><strong>第 ${di + 1} 天</strong>
        <span class="itin-day-moves">
          <button type="button" class="btn btn-sm btn-secondary itin-move-day-up" data-day="${di}" ${di === 0 ? "disabled" : ""}>↑</button>
          <button type="button" class="btn btn-sm btn-secondary itin-move-day-down" data-day="${di}">↓</button>
        </span>
        <button type="button" class="btn btn-sm btn-danger itin-rm-day">删除天</button>
      </div>
      <label>日期标签</label><input type="text" data-day-field="date_label" value="${App.escapeHtml(day.date_label || "")}" />
      <label>城市</label><select class="itin-city-select" data-day-field="city_id">${cityOpts}</select>
      <label>费用估算</label><input type="text" data-day-field="cost_estimate" value="${App.escapeHtml(day.cost_estimate || "")}" />
      <div class="itin-activities">`;
    activities.forEach((act, ai) => {
      html += App.renderItineraryActivity(act, di, ai, cityId);
    });
    html += `</div><button type="button" class="btn btn-sm btn-secondary itin-add-act" data-day="${di}">+ 添加活动</button></div>`;
    return html;
  };

  App.renderItineraryActivity = function renderItineraryActivity(act, di, ai, cityId) {
    const slots = App.TIME_SLOT_OPTIONS;
    let slotOpts = slots.map((s) => `<option value="${s}" ${act.time_slot === s ? "selected" : ""}>${s}</option>`).join("");
    const attrOpts = App.renderAttractionSelectOptions(cityId, act.attraction_id);
    return `<div class="itin-act" data-day="${di}" data-act="${ai}">
      <select data-act-field="time_slot">${slotOpts}</select>
      <input type="text" data-act-field="name" placeholder="活动名称" value="${App.escapeHtml(act.name || "")}" />
      <input type="text" data-act-field="detail" placeholder="详情" value="${App.escapeHtml(act.detail || "")}" />
      <select data-act-field="attraction_id">${attrOpts}</select>
      <label class="inline-check"><input type="checkbox" data-act-field="has_audio" ${act.has_audio ? "checked" : ""} /> 有音频</label>
      <button type="button" class="btn btn-sm btn-danger itin-rm-act">删</button>
    </div>`;
  };

  App.refreshItineraryDayAttractions = function refreshItineraryDayAttractions(dayEl) {
    const cityId = App.$(".itin-city-select", dayEl)?.value || "";
    dayEl.dataset.dayCityId = cityId;
    App.$$(".itin-act", dayEl).forEach((actEl) => {
      const sel = App.$('[data-act-field="attraction_id"]', actEl);
      if (!sel) return;
      const current = sel.value;
      sel.innerHTML = App.renderAttractionSelectOptions(cityId, current);
    });
  };

  App.renderImagePreview = function renderImagePreview(name, url) {
    if (!url) return `<div class="media-preview empty">暂无封面图</div><input type="hidden" name="${name}" value="" />`;
    return `<div class="media-preview"><img src="${App.escapeHtml(url)}" alt="" /><input type="hidden" name="${name}" value="${App.escapeHtml(url)}" /></div>`;
  };

  App.renderAudioPreview = function renderAudioPreview(name, url) {
    if (!url) {
      return `<div class="media-preview empty" data-audio-preview-field="${App.escapeHtml(name)}">暂无音频</div><input type="hidden" name="${name}" value="" />`;
    }
    return `<div class="media-preview" data-audio-preview-field="${App.escapeHtml(name)}"><audio controls src="${App.escapeHtml(url)}"></audio><input type="hidden" name="${name}" value="${App.escapeHtml(url)}" /></div>`;
  };

  App.bindAudioUploadInput = function bindAudioUploadInput(input, opts = {}) {
    if (!input || input.dataset.audioBound === "1") return;
    input.dataset.audioBound = "1";

    input.addEventListener("change", async () => {
      const file = input.files?.[0];
      const wrap = input.closest(".audio-upload-wrap");
      const statusEl = wrap?.querySelector(".audio-upload-status");
      const previewEl = wrap?.querySelector(".audio-upload-preview");
      if (!file) {
        if (statusEl) statusEl.textContent = "";
        if (previewEl) {
          previewEl.hidden = true;
          previewEl.innerHTML = "";
        }
        return;
      }
      const sizeMb = (file.size / (1024 * 1024)).toFixed(1);
      if (statusEl) statusEl.textContent = `正在上传 ${file.name} (${sizeMb} MB)…`;

      if (typeof opts.onUpload === "function") {
        try {
          input.disabled = true;
          if (opts.form) opts.form.dataset.audioUploading = "1";
          const result = await opts.onUpload(file, { wrap, input });
          if (previewEl && result?.audioUrl) {
            previewEl.hidden = false;
            previewEl.innerHTML = "";
            const a = document.createElement("audio");
            a.controls = true;
            a.src = result.audioUrl;
            previewEl.appendChild(a);
          }
          if (opts.form && opts.previewFieldKey && result?.audioUrl) {
            App.setAudioPreviewField(opts.form, opts.previewFieldKey, result.audioUrl);
          }
          if (statusEl) {
            statusEl.textContent = result?.guideId
              ? `✓ 已上传并关联导览 ${result.guideId}`
              : `✓ 已上传 ${file.name}`;
          }
          input.value = "";
        } catch (ex) {
          const detail = App.formatClientError
            ? App.formatClientError(ex, "音频上传")
            : ex.message || "上传失败";
          App.showToast(detail, "error");
          if (statusEl) statusEl.textContent = `上传失败：${detail}`;
          console.error("音频上传失败", ex);
        } finally {
          input.disabled = false;
          if (opts.form) delete opts.form.dataset.audioUploading;
        }
        return;
      }

      if (previewEl) {
        previewEl.hidden = false;
        previewEl.innerHTML = `<audio controls src="${URL.createObjectURL(file)}"></audio>`;
      }
      App.showToast("已选择音频，保存表单后上传");
    });
  };

  App.formFieldEl = function formFieldEl(root, key) {
    if (root?.elements && root.elements[key] !== undefined) return root.elements[key];
    return root?.querySelector(`[name="${key}"]`);
  };

  App.readFieldValue = function readFieldValue(field, form) {
    const el = App.formFieldEl(form, field.key);
    switch (field.type) {
      case "bool":
        return el ? el.checked : false;
      case "number": {
        const v = el?.value?.trim();
        if (v === "" || v === undefined) return field.allowNull ? null : undefined;
        const n = Number(v);
        if (Number.isNaN(n)) return field.allowNull ? null : undefined;
        return n;
      }
      case "tags": {
        const raw = el?.value?.trim() || "";
        if (!raw) return [];
        return raw.split(",").map((s) => s.trim()).filter(Boolean);
      }
      case "features_list": {
        const raw = el?.value?.trim() || "";
        if (!raw) return "";
        return raw.split("\n").map((s) => s.trim()).filter(Boolean).join("\n");
      }
      case "ref_cities_multi":
      case "ref_countries_multi":
      case "ref_attractions_multi":
      case "ref_ports_multi":
      case "enum_multi": {
        const box = form.querySelector(`[data-name="${field.key}"]`);
        if (!box) return [];
        return App.$$(`input:checked`, box).map((inp) => inp.value);
      }
      case "string_list":
      case "place_list":
      case "segment_list":
      case "visa_detail_list":
      case "practical_info_list":
      case "contact_list":
      case "link_list":
      case "content_blocks_list":
      case "flight_platform_list":
      case "help_phrase_list":
        return App.readListBuilder(form, field);
      case "itinerary_builder":
        return App.readItineraryBuilder(form, field.key);
      case "image_preview":
      case "audio_preview":
        return el?.value?.trim() || null;
      case "image_upload":
      case "audio_upload":
      case "image_url_list":
      case "content_blocks_list":
        return undefined;
      case "json": {
        const raw = el?.value?.trim() || "[]";
        return JSON.parse(raw);
      }
      case "payment_match": {
        const box = form.querySelector(`[data-name="${field.key}"][data-payment-match]`);
        if (!box) return {};
        const country = App.$$(`[data-pm="country"] input:checked`, box).map((i) => i.value);
        const cards = App.$$(`[data-pm="cards"] input:checked`, box).map((i) => i.value);
        const tripSel = box.querySelector(`[data-pm="trip"]`);
        const trip = tripSel ? tripSel.value : "";
        const out = {};
        if (country.length) out.country = country;
        if (cards.length) out.cards_exclude = cards;
        if (trip) out.trip = trip;
        return out;
      }
      case "richtext":
        return App.readRichTextValue(form, field.key) || null;
      default:
        return el?.value?.trim() === "" ? null : el?.value?.trim();
    }
  };

  App.readListBuilder = function readListBuilder(form, field, root) {
    const scope = root || form;
    const box = scope.querySelector(`[data-name="${field.key}"]`);
    if (!box) return [];
    const type = box.dataset.listType;
    const rows = App.$$(".list-row", box);
    if (type === "string") {
      return rows.map((r) => App.$("input", r)?.value?.trim()).filter(Boolean);
    }
    if (type === "place") {
      return rows
        .map((r) => ({
          name: App.$('[data-field="name"]', r)?.value?.trim() || "",
          distance: App.$('[data-field="distance"]', r)?.value?.trim() || "",
        }))
        .filter((p) => p.name);
    }
    if (type === "segment") {
      return rows
        .map((r, idx) => {
          const title = App.$('[data-field="title"]', r)?.value?.trim() || "";
          const start_seconds = Number(App.$('[data-field="start_seconds"]', r)?.value || 0);
          if (!title) return null;
          const slug = App.slugify(title, "seg");
          return { id: slug || `seg_${idx + 1}`, title, start_seconds };
        })
        .filter(Boolean);
    }
    if (type === "visa_detail") {
      return rows.map((r) => ({
        label: App.$('[data-field="label"]', r)?.value?.trim() || "",
        value: App.$('[data-field="value"]', r)?.value?.trim() || "",
      }));
    }
    if (type === "practical_info") {
      return rows
        .map((r) => {
          const label = App.$('[data-field="label"]', r)?.value?.trim() || "";
          const value = App.$('[data-field="value"]', r)?.value?.trim() || "";
          if (!label || !value) return null;
          const icon = App.$('[data-field="icon"]', r)?.value?.trim() || "";
          const item = { label, value };
          if (icon) item.icon = icon;
          return item;
        })
        .filter(Boolean);
    }
    if (type === "contact") {
      return rows.map((r) => ({
        label: App.$('[data-field="label"]', r)?.value?.trim() || "",
        number: App.$('[data-field="number"]', r)?.value?.trim() || "",
        note: App.$('[data-field="note"]', r)?.value?.trim() || null,
      }));
    }
    if (type === "link") {
      return rows
        .map((r) => ({
          label: App.$('[data-field="label"]', r)?.value?.trim() || "",
          url: App.$('[data-field="url"]', r)?.value?.trim() || "",
        }))
        .filter((x) => x.label && x.url);
    }
    if (type === "content_block") {
      return rows
        .map((r) => {
          const blockType = App.$('[data-field="block_type"]', r)?.value || "paragraph";
          if (blockType === "heading") {
            const title = App.$('[data-field="title"]', r)?.value?.trim() || "";
            return title ? { type: "heading", title } : null;
          }
          if (blockType === "image") {
            const imagePath = App.$('[data-field="image_path"]', r)?.value?.trim() || "";
            if (!imagePath) return null;
            const title = App.$('[data-field="title"]', r)?.value?.trim() || "";
            const block = { type: "image", imagePath };
            if (title) block.title = title;
            return block;
          }
          const body = App.readContentBlockBody(r);
          return body ? { type: "paragraph", body } : null;
        })
        .filter(Boolean);
    }
    if (type === "flight_platform") {
      return rows
        .map((r) => ({
          id: App.$('[data-field="id"]', r)?.value?.trim() || "",
          label: App.$('[data-field="label"]', r)?.value?.trim() || "",
          url_template: App.$('[data-field="url_template"]', r)?.value?.trim() || "",
        }))
        .filter((x) => x.id && x.label);
    }
    if (type === "help_phrase") {
      return rows
        .map((r) => ({
          chinese: App.$('[data-field="chinese"]', r)?.value?.trim() || "",
          pinyin: App.$('[data-field="pinyin"]', r)?.value?.trim() || "",
          english: App.$('[data-field="english"]', r)?.value?.trim() || "",
        }))
        .filter((x) => x.chinese);
    }
    return [];
  };

  App.readItineraryBuilder = function readItineraryBuilder(form, name) {
    const root = form.querySelector(`[data-name="${name}"]`);
    if (!root) return [];
    const days = [];
    App.$$(".itin-day", root).forEach((dayEl, di) => {
      const day = {
        id: dayEl.dataset.dayId || `day_${di + 1}`,
        day_index: di + 1,
        date_label: App.$('[data-day-field="date_label"]', dayEl)?.value?.trim() || "",
        cost_estimate: App.$('[data-day-field="cost_estimate"]', dayEl)?.value?.trim() || "",
        activities: [],
      };
      const cityId = App.$('[data-day-field="city_id"]', dayEl)?.value?.trim() || "";
      day.city_name = cityId ? App.cityLabel(cityId) : "";
      if (cityId) day.city_id = cityId;
      App.$$(".itin-act", dayEl).forEach((actEl, ai) => {
        day.activities.push({
          id: `a${ai + 1}`,
          time_slot: App.$('[data-act-field="time_slot"]', actEl)?.value || "AM",
          name: App.$('[data-act-field="name"]', actEl)?.value?.trim() || "",
          detail: App.$('[data-act-field="detail"]', actEl)?.value?.trim() || "",
          attraction_id: App.$('[data-act-field="attraction_id"]', actEl)?.value || null,
          has_audio: App.$('[data-act-field="has_audio"]', actEl)?.checked || false,
        });
      });
      days.push(day);
    });
    return days;
  };

  App.appendListRow = function appendListRow(box, type, opts = {}) {
    const addBtn = box.querySelector(".list-add, .list-add-url");
    const i = box.querySelectorAll(".list-row").length;
    let row = "";
    if (type === "string") {
      row = `<div class="list-row"><input type="text" value="" data-idx="${i}" /><button type="button" class="btn btn-sm btn-danger list-rm">删</button></div>`;
    } else if (type === "place") {
      row = `<div class="list-row"><input type="text" placeholder="名称" data-field="name" data-idx="${i}" /><input type="text" placeholder="距离" data-field="distance" data-idx="${i}" /><button type="button" class="btn btn-sm btn-danger list-rm">删</button></div>`;
    } else if (type === "segment") {
      row = `<div class="list-row"><input type="text" data-field="title" data-idx="${i}" placeholder="如 Intro / History" /><input type="number" value="0" data-field="start_seconds" data-idx="${i}" min="0" /><button type="button" class="btn btn-sm btn-danger list-rm">删</button></div>`;
    } else if (type === "visa_detail") {
      row = `<div class="list-row"><input type="text" data-field="label" data-idx="${i}" /><input type="text" data-field="value" data-idx="${i}" /><button type="button" class="btn btn-sm btn-danger list-rm">删</button></div>`;
    } else if (type === "practical_info") {
      row = App.renderPracticalInfoRow({ icon: opts.presetIcon || "", label: opts.presetLabel || "", value: "" }, i);
    } else if (type === "contact") {
      row = `<div class="list-row"><input type="text" data-field="label" data-idx="${i}" /><input type="text" data-field="number" data-idx="${i}" /><input type="text" data-field="note" data-idx="${i}" /><button type="button" class="btn btn-sm btn-danger list-rm">删</button></div>`;
    } else if (type === "link") {
      row = `<div class="list-row"><input type="text" placeholder="按钮文案" data-field="label" data-idx="${i}" /><input type="url" placeholder="https://..." data-field="url" data-idx="${i}" /><button type="button" class="btn btn-sm btn-danger list-rm">删</button></div>`;
    } else if (type === "image_url") {
      row = App.renderImageUrlRow("", i, { showUrl: opts.showUrl !== false });
    } else if (type === "content_block") {
      const tmp = document.createElement("div");
      tmp.innerHTML = App.renderContentBlockRow({}, i);
      addBtn.insertAdjacentElement("beforebegin", tmp.firstChild);
      App.bindContentBlockRow(tmp.firstChild);
      return;
    } else if (type === "flight_platform") {
      row = `<div class="list-row"><input type="text" placeholder="skyscanner" data-field="id" data-idx="${i}" /><input type="text" placeholder="Skyscanner" data-field="label" data-idx="${i}" /><input type="url" placeholder="https://..." data-field="url_template" data-idx="${i}" /><button type="button" class="btn btn-sm btn-danger list-rm">删</button></div>`;
    } else if (type === "help_phrase") {
      row = `<div class="list-row"><input type="text" data-field="chinese" data-idx="${i}" /><input type="text" data-field="pinyin" data-idx="${i}" /><input type="text" data-field="english" data-idx="${i}" /><button type="button" class="btn btn-sm btn-danger list-rm">删</button></div>`;
    }
    if (row) {
      addBtn.insertAdjacentHTML("beforebegin", row);
      if (type === "image_url") {
        const newRow = addBtn.previousElementSibling;
        App.bindImageFileInput(App.$(".image-file-input", newRow), { row: newRow });
      }
    }
  };

  App.bindImageFileInput = function bindImageFileInput(input, opts = {}) {
    if (!input || input.dataset.imageBound) return;
    input.dataset.imageBound = "1";
    input.addEventListener("change", () => {
      const file = input.files?.[0];
      if (!file) return;
      const row = opts.row || input.closest(".list-row--image, .list-row--content-block");
      const thumbWrap =
        opts.thumbWrap || row?.querySelector(".image-url-thumb-wrap, .block-image-thumb");
      const filenameEl =
        opts.filenameEl || input.closest(".image-upload-wrap")?.querySelector(".image-upload-filename");
      const previewEl = input.closest(".image-upload-wrap")?.querySelector(".image-upload-preview");
      if (filenameEl) filenameEl.textContent = file.name;
      const objectUrl = URL.createObjectURL(file);
      if (thumbWrap) {
        thumbWrap.innerHTML = `<img src="${objectUrl}" alt="" class="image-url-thumb" />`;
      }
      if (previewEl) {
        previewEl.hidden = false;
        previewEl.innerHTML = `<img src="${objectUrl}" alt="" class="image-url-thumb" />`;
      }
    });
  };

  App.toggleContentBlockFields = function toggleContentBlockFields(row, blockType) {
    if (!row) return;
    row.dataset.blockType = blockType;
    const heading = row.querySelector(".content-block-fields--heading");
    const paragraph = row.querySelector(".content-block-fields--paragraph");
    const image = row.querySelector(".content-block-fields--image");
    if (heading) heading.hidden = blockType !== "heading";
    if (paragraph) paragraph.hidden = blockType !== "paragraph";
    if (image) image.hidden = blockType !== "image";
    if (blockType === "paragraph") {
      const host = row.querySelector(".content-block-body-host");
      App.initRichTextHost(host, { compact: true });
    }
  };

  App.bindContentBlockRow = function bindContentBlockRow(row) {
    if (!row) return;
    const typeSel = row.querySelector('[data-field="block_type"]');
    if (typeSel && !typeSel.dataset.blockBound) {
      typeSel.dataset.blockBound = "1";
      typeSel.addEventListener("change", () => App.toggleContentBlockFields(row, typeSel.value));
    }
    const fileInput = row.querySelector(".block-image-file");
    App.bindImageFileInput(fileInput, { row });
    const blockType = typeSel?.value || row.dataset.blockType || "paragraph";
    if (blockType === "paragraph") {
      const host = row.querySelector(".content-block-body-host");
      App.initRichTextHost(host, { compact: true });
    }
  };

  App.mountFieldInteractions = function mountFieldInteractions(form, meta, ctx) {
    App.$$(".list-builder", form).forEach((box) => {
      const type = box.dataset.listType;
      box.addEventListener("click", (e) => {
        const presetBtn = e.target.closest(".list-preset");
        if (presetBtn) {
          App.appendListRow(box, type, {
            presetIcon: presetBtn.dataset.presetIcon || "",
            presetLabel: presetBtn.dataset.presetLabel || "",
          });
          return;
        }
        if (e.target.classList.contains("list-add")) {
          App.appendListRow(box, type);
        }
        if (e.target.classList.contains("list-add-url")) {
          App.appendListRow(box, type, { showUrl: true });
        }
        if (e.target.classList.contains("list-rm")) {
          e.target.closest(".list-row")?.remove();
        }
      });
    });

    form.querySelectorAll('[data-list-type="image_url"]').forEach((box) => {
      if (box.dataset.imageListBound) return;
      box.dataset.imageListBound = "1";
      const bulk = box.querySelector(".image-bulk-input");
      if (bulk) {
        bulk.addEventListener("change", () => {
          const files = [...(bulk.files || [])];
          files.forEach((file) => App.addImageUrlRowWithFile(box, file, false));
          bulk.value = "";
        });
      }
    });

    form.querySelectorAll(".list-row--content-block").forEach((row) => App.bindContentBlockRow(row));
    form.querySelectorAll(".list-row--image .image-file-input").forEach((input) => {
      App.bindImageFileInput(input, { row: input.closest(".list-row--image") });
    });
    form.querySelectorAll(".image-upload-input").forEach((input) => App.bindImageFileInput(input));

    const itinRoot = form.querySelector(".itinerary-builder");
    if (itinRoot && !itinRoot.dataset.mounted) {
      itinRoot.dataset.mounted = "1";
      const field = meta.fields.find((f) => f.type === "itinerary_builder");
      itinRoot.addEventListener("click", (e) => {
        if (e.target.classList.contains("itin-add-day")) {
          const days = App.readItineraryBuilder(form, field.key);
          days.push({ id: `day_${days.length + 1}`, day_index: days.length + 1, date_label: "", city_name: "", cost_estimate: "", activities: [] });
          const tmp = document.createElement("div");
          tmp.innerHTML = App.renderItineraryBuilder(field.key, days);
          itinRoot.replaceWith(tmp.firstChild);
          App.mountFieldInteractions(form, meta, ctx);
        }
        if (e.target.classList.contains("itin-move-day-up")) {
          const di = Number(e.target.dataset.day);
          const days = App.readItineraryBuilder(form, field.key);
          if (di > 0) {
            const t = days[di];
            days[di] = days[di - 1];
            days[di - 1] = t;
            const tmp = document.createElement("div");
            tmp.innerHTML = App.renderItineraryBuilder(field.key, days);
            itinRoot.replaceWith(tmp.firstChild);
            App.mountFieldInteractions(form, meta, ctx);
          }
        }
        if (e.target.classList.contains("itin-move-day-down")) {
          const di = Number(e.target.dataset.day);
          const days = App.readItineraryBuilder(form, field.key);
          if (di < days.length - 1) {
            const t = days[di];
            days[di] = days[di + 1];
            days[di + 1] = t;
            const tmp = document.createElement("div");
            tmp.innerHTML = App.renderItineraryBuilder(field.key, days);
            itinRoot.replaceWith(tmp.firstChild);
            App.mountFieldInteractions(form, meta, ctx);
          }
        }
        if (e.target.classList.contains("itin-rm-day")) e.target.closest(".itin-day")?.remove();
        if (e.target.classList.contains("itin-add-act")) {
          const dayIdx = Number(e.target.dataset.day);
          const dayEl = form.querySelectorAll(".itin-day")[dayIdx];
          const acts = dayEl?.querySelector(".itin-activities");
          if (acts) {
            const ai = acts.querySelectorAll(".itin-act").length;
            const cityId = App.$(".itin-city-select", dayEl)?.value || "";
            acts.insertAdjacentHTML(
              "beforeend",
              App.renderItineraryActivity({ time_slot: "AM", name: "", detail: "", attraction_id: null, has_audio: false }, dayIdx, ai, cityId)
            );
          }
        }
        if (e.target.classList.contains("itin-rm-act")) e.target.closest(".itin-act")?.remove();
      });
    }

    if (!form.dataset.itinCityBound) {
      form.dataset.itinCityBound = "1";
      form.addEventListener("change", (e) => {
        if (e.target.classList?.contains("itin-city-select")) {
          App.refreshItineraryDayAttractions(e.target.closest(".itin-day"));
        }
      });
    }

    form.querySelectorAll("[data-ref-scenario]").forEach((sel) => {
      if (sel.dataset.scenarioBound) return;
      sel.dataset.scenarioBound = "1";
      sel.addEventListener("change", async () => {
        if (sel.value !== "__new__") return;
        const prev = sel.dataset.prevValue || "";
        const label = window.prompt("场景显示名称（如「🚗 租车」）");
        if (!label?.trim()) {
          sel.value = prev;
          return;
        }
        try {
          const id = await App.createScenarioQuick(label.trim());
          const field = meta.fields.find((f) => f.key === sel.name);
          const tmp = document.createElement("div");
          tmp.innerHTML = App.renderRefScenarioSelect(sel.name, id, field);
          const next = tmp.firstChild;
          sel.replaceWith(next);
          App.mountFieldInteractions(form, meta, ctx);
        } catch (ex) {
          App.showToast(ex.message, "error");
          sel.value = prev;
        }
      });
      sel.addEventListener("focus", () => {
        sel.dataset.prevValue = sel.value === "__new__" ? "" : sel.value;
      });
    });

    form.querySelectorAll("[data-ref-country]").forEach((sel) => {
      sel.addEventListener("change", () => {
        const c = App.refCache.countries.find((x) => x.code === sel.value);
        const nameInput = form.elements.country_name;
        const flagInput = form.elements.flag;
        if (c && nameInput && nameInput.dataset.autoCountry) nameInput.value = c.name;
        if (c && flagInput) flagInput.value = c.flag || "";
      });
    });

    form.querySelectorAll("[data-filter-field]").forEach((sel) => {
      const filterField = sel.dataset.filterField;
      if (!filterField) return;
      const citySel = form.elements[filterField];
      const refresh = () => {
        const current = sel.value;
        const field = meta.fields.find((f) => f.key === sel.name);
        const tmp = document.createElement("div");
        tmp.innerHTML = App.renderRefAttractionSelect(sel.name, current, field, { ...ctx, formEl: form });
        sel.replaceWith(tmp.firstChild);
        App.mountFieldInteractions(form, meta, ctx);
      };
      citySel?.addEventListener("change", refresh);
    });

    form.querySelectorAll("[data-ref-attraction]").forEach((sel) => {
      if (sel.dataset.audioRefreshBound) return;
      sel.dataset.audioRefreshBound = "1";
      sel.addEventListener("change", async () => {
        const attId = sel.value?.trim() || "";
        if (attId) {
          try {
            await App.fetchAudioGuidesForAttraction(attId, { force: true });
          } catch (ex) {
            App.showToast(ex.message, "error");
            return;
          }
        }
        App.refreshAudioGuideSelects(form, meta, {
          ...ctx,
          formEl: form,
          scopeRoot: form,
          fixedAttractionId: attId || ctx.fixedAttractionId,
        });
      });
    });

    if (ctx.isNew) {
      const slugInput = form.querySelector(".slug-input");
      if (slugInput) {
        const sourceKey = slugInput.dataset.slugSource;
        const prefixField = slugInput.dataset.slugPrefixField;
        const fixedPrefix = slugInput.dataset.slugPrefix;
        const sourceEl = form.elements[sourceKey];
        const updateSlug = () => {
          let prefix = fixedPrefix;
          if (prefixField && form.elements[prefixField]) {
            prefix = form.elements[prefixField].value || fixedPrefix;
          }
          slugInput.value = App.slugify(sourceEl?.value || "", prefix);
        };
        sourceEl?.addEventListener("input", updateSlug);
        form.elements[prefixField]?.addEventListener("change", updateSlug);
        updateSlug();
      }
    }

    const subAreaUpload = form.querySelector('[name="_sa_audio_upload"]');
    const phraseUpload = form.querySelector('[name="_ph_audio_upload"]');
    if (subAreaUpload && !subAreaUpload.closest(".sub-area-inline-form")) {
      App.setupSubAreaAudioControls(form, {
        ...ctx,
        row: ctx.subAreaRow,
        fixedAttractionId: ctx.fixedAttractionId,
      });
    } else if (phraseUpload) {
      App.setupPhraseAudioControls(form, ctx);
    } else {
      const cityGuideUpload = form.querySelector('[name="_cg_audio_upload"]');
      if (cityGuideUpload) {
        App.setupCityGuideAudioControls(form, ctx);
      } else {
      const guideId =
        form.querySelector('[name="id"]')?.value?.trim() ||
        form.dataset.audioGuideId?.trim() ||
        "";
      if (guideId && form.querySelector('[name="_audio_upload"]')) {
        App.setupAudioGuideControls(form, guideId, ctx);
      } else {
        form.querySelectorAll(".audio-upload-input").forEach((input) => {
          if (input.closest(".sub-area-inline-form")) return;
          App.bindAudioUploadInput(input);
        });
      }
      }
    }

    App.initRichTextHosts(form);
    App.bindDeferredQuillHosts(form);
  };

  App.formatListCell = function formatListCell(col, row) {
    const key = typeof col === "string" ? col : col.key;
    let v = row[key];
    if (typeof col === "object" && col.format === "checklist_type") {
      return App.escapeHtml(App.CHECKLIST_TYPE_LABELS?.[v] || v || "—");
    }
    if (typeof col === "object" && col.format === "checklist_phase") {
      return App.escapeHtml(App.CHECKLIST_PHASE_LABELS?.[v] || v || "—");
    }
    if (typeof col === "object" && col.format === "checklist_priority") {
      return App.escapeHtml(App.CHECKLIST_PRIORITY_LABELS?.[v] || v || "—");
    }
    if (typeof col === "object" && col.ref === "city") return App.cityLabel(v);
    if (typeof col === "object" && col.ref === "countries") {
      const ids = Array.isArray(v) ? v : [];
      if (!ids.length) return '<span class="muted">全部</span>';
      return App.escapeHtml(ids.map((id) => App.countryLabel(id)).join(", "));
    }
    if (typeof col === "object" && col.ref === "cities") {
      const ids = Array.isArray(v) ? v : [];
      if (!ids.length) return '<span class="muted">—</span>';
      return App.escapeHtml(ids.map((id) => App.cityLabel(id)).join(", "));
    }
    if (typeof col === "object" && col.format === "has_audio") {
      const url = (v || "").trim();
      return url
        ? '<span class="tag on">有音频</span>'
        : '<span class="tag off">无音频</span>';
    }
    if (typeof col === "object" && col.format === "user_email") {
      return App.escapeHtml(App.profileEmail(v));
    }
    if (typeof col === "object" && col.format === "purchased_count") {
      const n = Array.isArray(v) ? v.length : 0;
      return n > 0
        ? `<span class="tag on">${n}</span>`
        : '<span class="tag off">0</span>';
    }
    if (typeof col === "object" && col.format === "duration_mmss") {
      const sec = Number(v);
      if (!Number.isFinite(sec) || sec <= 0) return "—";
      const m = Math.floor(sec / 60);
      const s = sec % 60;
      return App.escapeHtml(`${m}:${String(s).padStart(2, "0")}`);
    }
    if (typeof col === "object" && col.ref === "attraction") return App.attractionLabel(v);
    if (typeof col === "object" && col.ref === "scenario") return App.scenarioLabel(v);
    if (typeof col === "object" && col.ref === "country") return App.countryLabel(v);
    if (typeof col === "object" && col.type === "image_thumb") {
      if (!v) return "—";
      const src = String(v);
      return `<img class="list-thumb" src="${App.escapeHtml(src)}" alt="" loading="lazy" />`;
    }
    if (typeof v === "boolean") {
      return `<span class="tag ${v ? "on" : "off"}">${v ? "是" : "否"}</span>`;
    }
    if (v === null || v === undefined) return "—";
    if (Array.isArray(v)) return App.escapeHtml(v.join(", "));
    return App.escapeHtml(String(v));
  };

  App.getListColumnLabel = function getListColumnLabel(col) {
    if (typeof col === "string") return col;
    return col.label || col.key;
  };
})();
