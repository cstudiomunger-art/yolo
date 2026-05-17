/* ChinaGo Admin — visual field renderers and value readers */

(function () {
  const App = window.ChinaGoAdmin;

  App.fieldToFormValue = function fieldToFormValue(field, value) {
    if (field.type === "bool") return !!value;
    if (field.type === "tags" || field.type === "features_list") {
      if (Array.isArray(value)) return value.join("\n");
      if (typeof value === "string" && value.includes("\n")) return value;
      return value || "";
    }
    if (field.type === "ref_cities_multi") {
      return Array.isArray(value) ? value : [];
    }
    if (
      field.type === "json" ||
      field.type === "string_list" ||
      field.type === "place_list" ||
      field.type === "segment_list" ||
      field.type === "visa_detail_list" ||
      field.type === "contact_list" ||
      field.type === "itinerary_builder"
    ) {
      if (value === null || value === undefined) {
        if (field.type === "string_list") return [];
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
      case "richtext":
        inner = `<textarea name="${name}" class="${field.type === "richtext" ? "richtext-area" : ""}" ${ro}>${App.escapeHtml(String(value))}</textarea>`;
        if (field.type === "richtext") {
          inner += `<div class="char-count" data-for="${name}">${String(value).length} 字</div>`;
        }
        break;
      case "number":
        inner = `<input name="${name}" type="number" value="${App.escapeHtml(String(value))}" ${ro} />`;
        break;
      case "enum": {
        const opts = App.normalizeEnumOptions(field.options);
        inner = `<select name="${name}" ${ro}><option value="">— 请选择 —</option>`;
        opts.forEach((o) => {
          inner += `<option value="${App.escapeHtml(o.value)}" ${value === o.value ? "selected" : ""}>${App.escapeHtml(o.label)}</option>`;
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
        inner = App.renderRefScenarioSelect(name, value);
        break;
      case "ref_country":
        inner = App.renderRefCountrySelect(name, value);
        break;
      case "ref_cities_multi":
        inner = App.renderRefCitiesMulti(name, value);
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
      case "place_list":
        inner = App.renderPlaceList(name, value);
        break;
      case "segment_list":
        inner = App.renderSegmentList(name, value);
        break;
      case "visa_detail_list":
        inner = App.renderVisaDetailList(name, value);
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
        inner = `<input type="file" name="${name}" accept="image/jpeg,image/png,image/webp" data-upload-folder="${field.uploadFolder || ""}" data-upload-target="${field.uploadTarget || ""}" />`;
        break;
      case "audio_upload":
        inner = `<input type="file" name="${name}" accept="audio/*,.mp3,.m4a,.wav" />`;
        break;
      case "json":
        inner = `<textarea name="${name}" class="json-area">${App.escapeHtml(typeof value === "string" ? value : JSON.stringify(value, null, 2))}</textarea>`;
        break;
      default:
        inner = `<input name="${name}" type="text" value="${App.escapeHtml(String(value))}" ${ro} ${field.autoFromCountry ? 'data-auto-country="1"' : ""} />`;
    }

    if (field.type === "bool") {
      return `<div class="field-block field-block--bool"${advanced}><span class="field-label">${App.escapeHtml(label)}</span>${inner}</div>`;
    }
    return `<div class="field-block"${advanced}><label>${App.escapeHtml(label)}</label>${inner}</div>`;
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

  App.renderRefScenarioSelect = function renderRefScenarioSelect(name, value) {
    let html = `<select name="${name}"><option value="">— 选择场景 —</option>`;
    App.refCache.scenarios.forEach((s) => {
      const label = App.scenarioLabel(s.scenario_id);
      html += `<option value="${App.escapeHtml(s.scenario_id)}" ${value === s.scenario_id ? "selected" : ""}>${App.escapeHtml(label)}</option>`;
    });
    html += `</select>`;
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

  App.renderStringList = function renderStringList(name, items) {
    const arr = Array.isArray(items) ? items : [];
    let html = `<div class="list-builder" data-list-type="string" data-name="${name}">`;
    arr.forEach((item, i) => {
      html += `<div class="list-row"><input type="text" value="${App.escapeHtml(String(item))}" data-idx="${i}" /><button type="button" class="btn btn-sm btn-danger list-rm">删</button></div>`;
    });
    html += `<button type="button" class="btn btn-sm btn-secondary list-add">+ 添加一条</button></div>`;
    return html;
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
    let html = `<div class="list-builder" data-list-type="segment" data-name="${name}"><div class="list-header"><span>章节 ID</span><span>标题</span><span>开始秒</span><span></span></div>`;
    arr.forEach((item, i) => {
      html += `<div class="list-row"><input type="text" value="${App.escapeHtml(item.id || "")}" data-field="id" data-idx="${i}" placeholder="id" /><input type="text" value="${App.escapeHtml(item.title || "")}" data-field="title" data-idx="${i}" /><input type="number" value="${item.start_seconds ?? 0}" data-field="start_seconds" data-idx="${i}" /><button type="button" class="btn btn-sm btn-danger list-rm">删</button></div>`;
    });
    html += `<button type="button" class="btn btn-sm btn-secondary list-add">+ 添加章节</button></div>`;
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
    let html = `<div class="itin-day" data-day-idx="${di}" data-day-id="${App.escapeHtml(day.id || `day_${di + 1}`)}">
      <div class="itin-day-head"><strong>第 ${di + 1} 天</strong>
        <button type="button" class="btn btn-sm btn-danger itin-rm-day">删除天</button>
      </div>
      <label>日期标签</label><input type="text" data-day-field="date_label" value="${App.escapeHtml(day.date_label || "")}" />
      <label>城市名</label><input type="text" data-day-field="city_name" value="${App.escapeHtml(day.city_name || "")}" />
      <label>费用估算</label><input type="text" data-day-field="cost_estimate" value="${App.escapeHtml(day.cost_estimate || "")}" />
      <div class="itin-activities">`;
    activities.forEach((act, ai) => {
      html += App.renderItineraryActivity(act, di, ai);
    });
    html += `</div><button type="button" class="btn btn-sm btn-secondary itin-add-act" data-day="${di}">+ 添加活动</button></div>`;
    return html;
  };

  App.renderItineraryActivity = function renderItineraryActivity(act, di, ai) {
    const slots = App.TIME_SLOT_OPTIONS;
    let slotOpts = slots.map((s) => `<option value="${s}" ${act.time_slot === s ? "selected" : ""}>${s}</option>`).join("");
    let attrOpts = `<option value="">— 无景点 —</option>`;
    App.refCache.attractions.forEach((a) => {
      attrOpts += `<option value="${App.escapeHtml(a.id)}" ${act.attraction_id === a.id ? "selected" : ""}>${App.escapeHtml(a.chinese_name || a.name)}</option>`;
    });
    return `<div class="itin-act" data-day="${di}" data-act="${ai}" data-act-id="${App.escapeHtml(act.id || `a${ai + 1}`)}">
      <select data-act-field="time_slot">${slotOpts}</select>
      <input type="text" data-act-field="name" placeholder="活动名称" value="${App.escapeHtml(act.name || "")}" />
      <input type="text" data-act-field="detail" placeholder="详情" value="${App.escapeHtml(act.detail || "")}" />
      <select data-act-field="attraction_id">${attrOpts}</select>
      <label class="inline-check"><input type="checkbox" data-act-field="has_audio" ${act.has_audio ? "checked" : ""} /> 有音频</label>
      <button type="button" class="btn btn-sm btn-danger itin-rm-act">删</button>
    </div>`;
  };

  App.renderImagePreview = function renderImagePreview(name, url) {
    if (!url) return `<div class="media-preview empty">暂无封面图</div><input type="hidden" name="${name}" value="" />`;
    return `<div class="media-preview"><img src="${App.escapeHtml(url)}" alt="" /><input type="hidden" name="${name}" value="${App.escapeHtml(url)}" /></div>`;
  };

  App.renderAudioPreview = function renderAudioPreview(name, url) {
    if (!url) return `<div class="media-preview empty">暂无音频</div><input type="hidden" name="${name}" value="" />`;
    return `<div class="media-preview"><audio controls src="${App.escapeHtml(url)}"></audio><input type="hidden" name="${name}" value="${App.escapeHtml(url)}" /></div>`;
  };

  App.readFieldValue = function readFieldValue(field, form) {
    const el = form.elements[field.key];
    switch (field.type) {
      case "bool":
        return el ? el.checked : false;
      case "number": {
        const v = el?.value?.trim();
        if (v === "" || v === undefined) return null;
        return Number(v);
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
      case "ref_cities_multi": {
        const box = form.querySelector(`[data-name="${field.key}"]`);
        if (!box) return [];
        return App.$$(`input:checked`, box).map((inp) => inp.value);
      }
      case "string_list":
      case "place_list":
      case "segment_list":
      case "visa_detail_list":
      case "contact_list":
        return App.readListBuilder(form, field);
      case "itinerary_builder":
        return App.readItineraryBuilder(form, field.key);
      case "image_preview":
      case "audio_preview":
        return el?.value?.trim() || null;
      case "image_upload":
      case "audio_upload":
        return undefined;
      case "json": {
        const raw = el?.value?.trim() || "[]";
        return JSON.parse(raw);
      }
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
      return rows.map((r) => ({
        id: App.$('[data-field="id"]', r)?.value?.trim() || "",
        title: App.$('[data-field="title"]', r)?.value?.trim() || "",
        start_seconds: Number(App.$('[data-field="start_seconds"]', r)?.value || 0),
      }));
    }
    if (type === "visa_detail") {
      return rows.map((r) => ({
        label: App.$('[data-field="label"]', r)?.value?.trim() || "",
        value: App.$('[data-field="value"]', r)?.value?.trim() || "",
      }));
    }
    if (type === "contact") {
      return rows.map((r) => ({
        label: App.$('[data-field="label"]', r)?.value?.trim() || "",
        number: App.$('[data-field="number"]', r)?.value?.trim() || "",
        note: App.$('[data-field="note"]', r)?.value?.trim() || null,
      }));
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
        city_name: App.$('[data-day-field="city_name"]', dayEl)?.value?.trim() || "",
        cost_estimate: App.$('[data-day-field="cost_estimate"]', dayEl)?.value?.trim() || "",
        activities: [],
      };
      App.$$(".itin-act", dayEl).forEach((actEl, ai) => {
        day.activities.push({
          id: actEl.dataset.actId || `a${ai + 1}`,
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

  App.appendListRow = function appendListRow(box, type) {
    const addBtn = box.querySelector(".list-add");
    const i = box.querySelectorAll(".list-row").length;
    let row = "";
    if (type === "string") {
      row = `<div class="list-row"><input type="text" value="" data-idx="${i}" /><button type="button" class="btn btn-sm btn-danger list-rm">删</button></div>`;
    } else if (type === "place") {
      row = `<div class="list-row"><input type="text" placeholder="名称" data-field="name" data-idx="${i}" /><input type="text" placeholder="距离" data-field="distance" data-idx="${i}" /><button type="button" class="btn btn-sm btn-danger list-rm">删</button></div>`;
    } else if (type === "segment") {
      row = `<div class="list-row"><input type="text" data-field="id" data-idx="${i}" placeholder="id" /><input type="text" data-field="title" data-idx="${i}" /><input type="number" value="0" data-field="start_seconds" data-idx="${i}" /><button type="button" class="btn btn-sm btn-danger list-rm">删</button></div>`;
    } else if (type === "visa_detail") {
      row = `<div class="list-row"><input type="text" data-field="label" data-idx="${i}" /><input type="text" data-field="value" data-idx="${i}" /><button type="button" class="btn btn-sm btn-danger list-rm">删</button></div>`;
    } else if (type === "contact") {
      row = `<div class="list-row"><input type="text" data-field="label" data-idx="${i}" /><input type="text" data-field="number" data-idx="${i}" /><input type="text" data-field="note" data-idx="${i}" /><button type="button" class="btn btn-sm btn-danger list-rm">删</button></div>`;
    }
    if (row) addBtn.insertAdjacentHTML("beforebegin", row);
  };

  App.mountFieldInteractions = function mountFieldInteractions(form, meta, ctx) {
    App.$$(".list-builder", form).forEach((box) => {
      const type = box.dataset.listType;
      box.addEventListener("click", (e) => {
        if (e.target.classList.contains("list-add")) {
          App.appendListRow(box, type);
        }
        if (e.target.classList.contains("list-rm")) {
          e.target.closest(".list-row")?.remove();
        }
      });
    });

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
        if (e.target.classList.contains("itin-rm-day")) e.target.closest(".itin-day")?.remove();
        if (e.target.classList.contains("itin-add-act")) {
          const dayIdx = Number(e.target.dataset.day);
          const dayEl = form.querySelectorAll(".itin-day")[dayIdx];
          const acts = dayEl?.querySelector(".itin-activities");
          if (acts) {
            const ai = acts.querySelectorAll(".itin-act").length;
            acts.insertAdjacentHTML("beforeend", App.renderItineraryActivity({ time_slot: "AM", name: "", detail: "", attraction_id: null, has_audio: false }, dayIdx, ai));
          }
        }
        if (e.target.classList.contains("itin-rm-act")) e.target.closest(".itin-act")?.remove();
      });
    }

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

    form.querySelectorAll(".richtext-area").forEach((ta) => {
      const counter = form.querySelector(`[data-for="${ta.name}"]`);
      ta.addEventListener("input", () => {
        if (counter) counter.textContent = `${ta.value.length} 字`;
      });
    });
  };

  App.formatListCell = function formatListCell(col, row) {
    const key = typeof col === "string" ? col : col.key;
    let v = row[key];
    if (typeof col === "object" && col.ref === "city") return App.cityLabel(v);
    if (typeof col === "object" && col.ref === "attraction") return App.attractionLabel(v);
    if (typeof col === "object" && col.ref === "scenario") return App.scenarioLabel(v);
    if (typeof col === "object" && col.ref === "country") return App.countryLabel(v);
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
