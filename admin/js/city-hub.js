/* ChinaGo Admin — city workspace & attraction editor */

(function () {
  const App = window.ChinaGoAdmin;

  App.renderCityHubList = async function renderCityHubList() {
    const main = App.$("#main-content");
    App.$("#page-title").textContent = "城市工作台";
    App.$("#add-row-btn").classList.remove("hidden");
    App.$("#add-row-btn").textContent = "+ 新建城市";
    App.$("#add-row-btn").onclick = () => App.openModal(null, "cities");

    const { data: cities, error } = await App.client.from("cities").select("*").order("display_order", { ascending: true });
    if (error) {
      main.innerHTML = `<div class="status-bar error">${App.escapeHtml(error.message)}</div>`;
      return;
    }

    const { data: attrCounts } = await App.client.from("attractions").select("city_id");
    const countMap = {};
    (attrCounts || []).forEach((a) => {
      countMap[a.city_id] = (countMap[a.city_id] || 0) + 1;
    });

    main.innerHTML = `
      <div class="status-bar info workflow-hint">在侧栏 <strong>城市工作台</strong> 下方展开 <strong>城市</strong> 树选择城市；此处可浏览全部城市卡片，或使用顶部「+ 新建城市」。</div>
      <div class="hub-toolbar">
        <input type="search" id="city-search" placeholder="搜索城市名称…" class="search-input" />
        <span id="city-grid-count" class="muted"></span>
      </div>
      <div class="city-grid" id="city-grid"></div>`;

    const grid = App.$("#city-grid");
    (cities || []).forEach((city) => {
      const card = document.createElement("article");
      card.className = "city-card";
      card.dataset.name = `${city.name} ${city.chinese_name}`.toLowerCase();
      const cover = city.cover_image_path
        ? `<img src="${App.escapeHtml(city.cover_image_path)}" alt="" class="city-card-cover" />`
        : `<div class="city-card-cover placeholder">${city.emoji || "🏙"}</div>`;
      card.innerHTML = `
        ${cover}
        <div class="city-card-body">
          <h3>${App.escapeHtml(city.emoji || "")} ${App.escapeHtml(city.chinese_name || city.name)}</h3>
          <p class="muted">${App.escapeHtml(city.name)} · ${countMap[city.id] || 0} 个景点</p>
          <span class="tag ${city.is_published ? "on" : "off"}">${city.is_published ? "已发布" : "草稿"}</span>
          <div class="city-card-actions">
            <button type="button" class="btn btn-sm" data-open-hub="${App.escapeHtml(city.id)}">进入工作台</button>
            <button type="button" class="btn btn-sm btn-secondary" data-edit-city="${App.escapeHtml(city.id)}">快速编辑</button>
          </div>
        </div>`;
      grid.appendChild(card);
    });

    const updateCityGridCount = () => {
      const visible = App.$$(".city-card", grid).filter((c) => !c.classList.contains("hidden")).length;
      const total = App.$$(".city-card", grid).length;
      const el = App.$("#city-grid-count");
      if (el) el.textContent = `显示 ${visible} / ${total}`;
    };
    updateCityGridCount();

    App.$("#city-search")?.addEventListener("input", (e) => {
      const q = e.target.value.toLowerCase();
      App.$$(".city-card", grid).forEach((card) => {
        card.classList.toggle("hidden", q && !card.dataset.name.includes(q));
      });
      updateCityGridCount();
    });

    main.querySelectorAll("[data-open-hub]").forEach((btn) => {
      btn.addEventListener("click", () => {
        if (App.navigateTo) App.navigateTo({ kind: "city_panel", cityId: btn.dataset.openHub, panel: "overview" });
        else App.openCityHub(btn.dataset.openHub);
      });
    });
    main.querySelectorAll("[data-edit-city]").forEach((btn) => {
      btn.addEventListener("click", async () => {
        const { data } = await App.client.from("cities").select("*").eq("id", btn.dataset.editCity).single();
        App.openModal(data, "cities", { onSaved: () => App.renderCityHubList() });
      });
    });
  };

  App.HUB_PANEL_LABELS = {
    overview: "城市概览",
    city_guides: "城市指南",
    attractions: "景点与解说",
    audio: "音频导览",
    hotels: "酒店",
    checklist: "行前清单",
    home_tips: "首页提示",
    shopping_items: "购物清单",
    reading_list: "阅读清单",
  };

  App.loadCityPanel = async function loadCityPanel(cityId, panelId) {
    App.cityHubCityId = cityId;
    App.cityHubPanel = panelId || "overview";
    App.currentView = "city_detail";
    App.currentTable = null;

    const city =
      App.refCache.cities.find((c) => c.id === cityId) ||
      (await App.client.from("cities").select("*").eq("id", cityId).single()).data;
    const panelLabel = App.HUB_PANEL_LABELS[App.cityHubPanel] || App.cityHubPanel;
    App.$("#page-title").textContent = `${city?.chinese_name || city?.name || cityId} · ${panelLabel}`;
    App.$("#add-row-btn").classList.add("hidden");

    const main = App.$("#main-content");
    main.innerHTML = `<div id="hub-panel"></div>`;
    const panel = App.$("#hub-panel");

    const p = App.cityHubPanel;
    if (p === "overview") await App.renderCityOverview(cityId, panel);
    else if (p === "city_guides") await App.renderCitySubTable(cityId, panel, "city_guides");
    else if (p === "attractions") await App.renderCityAttractionsList(cityId, panel);
    else if (p === "audio") await App.renderCityAudioHub(cityId, panel);
    else if (p === "hotels") await App.renderCitySubTable(cityId, panel, "hotels");
    else if (p === "checklist") await App.renderCityChecklist(cityId, panel);
    else if (p === "home_tips") await App.renderCitySubTable(cityId, panel, "home_tips");
    else if (p === "shopping_items") await App.renderCitySubTable(cityId, panel, "shopping_items");
    else if (p === "reading_list") await App.renderCityReadingList(cityId, panel);
    else await App.renderCityOverview(cityId, panel);

    if (App.syncNavSelectionFromState && App.highlightNavSelection) {
      App.syncNavSelectionFromState();
      App.highlightNavSelection();
    }
  };

  App.openCityHub = async function openCityHub(cityId, panelId) {
    await App.loadCityPanel(cityId, panelId || "overview");
  };

  App.renderCityOverview = async function renderCityOverview(cityId, panel) {
    const { data: city, error } = await App.client.from("cities").select("*").eq("id", cityId).single();
    if (error) {
      panel.innerHTML = `<div class="status-bar error">${App.escapeHtml(error.message)}</div>`;
      return;
    }
    panel.innerHTML = `<form id="city-overview-form" class="editor-page"></form><button type="submit" form="city-overview-form" class="btn">保存城市信息</button>`;
    const form = App.$("#city-overview-form", panel);
    const meta = App.TABLES.cities;
    form.innerHTML = App.buildFormFieldsHtml(meta, city, { fixedCityId: cityId });
    App.mountFieldInteractions(form, meta, { isNew: false, pk: "id", formEl: form });
    form.addEventListener("submit", async (e) => {
      e.preventDefault();
      try {
        const payload = await App.collectFormPayload(form, meta, city, false, { table: "cities" });
        const { error: err } = await App.client.from("cities").update(payload).eq("id", cityId);
        if (err) throw err;
        App.showToast("城市信息已保存");
        await App.loadRefCache(true);
      } catch (ex) {
        App.showToast(ex.message, "error");
      }
    });
  };

  App.renderCityAttractionsList = async function renderCityAttractionsList(cityId, panel) {
    const { data, error } = await App.client
      .from("attractions")
      .select("*")
      .eq("city_id", cityId)
      .order("display_order", { ascending: true });
    if (error) {
      panel.innerHTML = `<div class="status-bar error">${App.escapeHtml(error.message)}</div>`;
      return;
    }
    let html = `<div class="hub-toolbar"><button type="button" class="btn" id="new-attraction">+ 新建景点</button></div><div class="attraction-cards">`;
    (data || []).forEach((a) => {
      const intro = (a.introduction || "").slice(0, 120);
      const agCount = a.audio_guide_count ?? 0;
      const iapTag = a.iap_product_id?.trim()
        ? '<span class="tag on" title="已配置 App Store Product ID">IAP</span>'
        : '<span class="tag off" title="未配置 Product ID（App 本地模拟单购仍可用）">无 IAP ID</span>';
      const audioTag =
        agCount > 0
          ? `<span class="tag on">🎧 ${agCount} 条导览</span>`
          : '<span class="tag off">无导览</span>';
      html += `<article class="attraction-card">
        <h4>${App.escapeHtml(a.chinese_name || a.name)}</h4>
        <p class="muted">${App.escapeHtml(a.summary || "")}</p>
        <p class="intro-preview">${App.escapeHtml(intro)}${(a.introduction || "").length > 120 ? "…" : ""}</p>
        <p class="attraction-card-tags">${audioTag} ${iapTag}</p>
        <span class="tag ${a.is_published ? "on" : "off"}">${a.priority || "—"} · ${a.is_published ? "已发布" : "草稿"}</span>
        <button type="button" class="btn btn-sm" data-edit-attr="${App.escapeHtml(a.id)}">编辑解说</button>
      </article>`;
    });
    html += `</div>`;
    panel.innerHTML = html;
    App.$("#new-attraction", panel)?.addEventListener("click", () => {
      App.openAttractionEditor(null, cityId);
    });
    panel.querySelectorAll("[data-edit-attr]").forEach((btn) => {
      btn.addEventListener("click", () => {
        if (App.navigateTo) {
          App.navigateTo({ kind: "attraction", cityId, attractionId: btn.dataset.editAttr });
        } else {
          App.openAttractionEditor(btn.dataset.editAttr, cityId);
        }
      });
    });
  };

  App.openAttractionEditor = async function openAttractionEditor(attractionId, cityId, options) {
    const opts = options || {};
    App.attractionEditId = attractionId;
    App.attractionFocusSection = opts.focusSection || null;
    App.attractionFocusId = opts.focusId || null;
    App.currentView = "attraction_edit";
    await App.loadRefCache();
    const isNew = !attractionId;
    let row = { city_id: cityId };
    if (!isNew) {
      const { data, error } = await App.client.from("attractions").select("*").eq("id", attractionId).single();
      if (error) {
        App.showToast(error.message, "error");
        return;
      }
      row = data;
    }

    const city = App.refCache.cities.find((c) => c.id === cityId);
    App.$("#page-title").innerHTML = `
      <button type="button" class="breadcrumb-link" id="hub-back-attr">‹ ${App.escapeHtml(city?.chinese_name || "城市")}</button>
      <span class="breadcrumb-sep">›</span> ${isNew ? "新建景点" : App.escapeHtml(row.chinese_name || row.name)}`;
    App.$("#add-row-btn").classList.add("hidden");

    const main = App.$("#main-content");
    main.innerHTML = `
      <form id="attraction-editor" class="editor-page editor-page--wide">
        <section class="editor-section"><h3>基本信息</h3><div id="attr-basic"></div></section>
        <section class="editor-section"><h3>书面解说</h3><div id="attr-intro"></div></section>
        <section class="editor-section"><h3>西方游客贴士</h3><div id="attr-tips"></div></section>
        <section class="editor-section"><h3>周边推荐</h3><div id="attr-nearby"></div></section>
        <section class="editor-section"><h3>子区域 / 展区</h3><div id="attr-subareas-list"></div>
          <button type="button" class="btn btn-sm btn-secondary" id="add-sub-area">+ 添加子区域</button>
        </section>
        <section class="editor-section"><h3>语音导览</h3><div id="attr-audio-list"></div>
          <button type="button" class="btn btn-sm btn-secondary" id="add-audio-guide">+ 添加音频导览</button>
        </section>
        <div class="editor-actions">
          <button type="button" class="btn btn-secondary" id="cancel-attr-edit">取消</button>
          ${isNew ? "" : '<button type="button" class="btn btn-danger" id="delete-attr-edit">删除景点</button>'}
          <button type="submit" class="btn">保存景点</button>
        </div>
      </form>`;

    const meta = App.TABLES.attractions;
    const editorCtx = { isNew, pk: "id", fixedCityId: cityId };
    const form = App.$("#attraction-editor");
    editorCtx.formEl = form;

    const fieldsHost = document.createElement("div");
    fieldsHost.id = "attr-fields";
    form.insertBefore(fieldsHost, form.querySelector(".editor-section"));
    form.querySelectorAll(".editor-section").forEach((sec) => {
      if (sec.querySelector("#attr-basic, #attr-intro, #attr-tips, #attr-nearby")) sec.remove();
    });
    fieldsHost.innerHTML = App.buildFormFieldsHtml(meta, row, editorCtx);
    App.mountFieldInteractions(form, meta, editorCtx);

    const saMeta = App.TABLES.sub_areas;
    let guideById = {};
    const guidesForPicker = () =>
      Object.values(guideById).sort((a, b) => (a.sort_order ?? 0) - (b.sort_order ?? 0));
    editorCtx.fixedAttractionId = attractionId || "";
    editorCtx.includeInactiveAudioGuides = true;
    editorCtx.getAudioGuides = guidesForPicker;

    const refreshAttractionGuides = async function refreshAttractionGuides() {
      if (!attractionId) {
        guideById = {};
        return [];
      }
      const { data, error } = await App.client
        .from("audio_guides")
        .select("*")
        .eq("attraction_id", attractionId)
        .order("sort_order", { ascending: true });
      if (error) throw error;
      const guides = data || [];
      guideById = Object.fromEntries(guides.map((g) => [g.id, g]));
      App.attractionGuidesCache = App.attractionGuidesCache || {};
      App.attractionGuidesCache[attractionId] = guides;
      await App.loadRefCache(true);
      return guides;
    };

    const mountSubAreaForm = (container, area, areaIsNew) => {
      const hydrated = App.hydrateSubAreaRowForForm(area);
      const saForm = document.createElement("div");
      saForm.className = "sub-area-inline-form";
      if (attractionId) saForm.dataset.attractionId = attractionId;
      const saCtx = {
        isNew: areaIsNew,
        pk: "id",
        fixedAttractionId: attractionId,
        formEl: saForm,
      };
      saForm.innerHTML =
        App.renderHiddenContextFields(saCtx, saMeta) +
        saMeta.fields
          .filter((f) => f.key !== "attraction_id" && f.key !== "id" && f.type !== "section")
          .map((f) => {
            let raw = hydrated[f.key];
            if (f.key === "body" && !raw && Array.isArray(hydrated.content_blocks) && hydrated.content_blocks.length) {
              raw = App.contentBlocksToHtml(hydrated.content_blocks);
            }
            return App.renderFieldBlock(f, App.fieldToFormValue(f, raw), saCtx);
          })
          .join("") +
        (hydrated.id ? `<input type="hidden" name="id" value="${App.escapeHtml(hydrated.id)}" />` : "");
      container.appendChild(saForm);
      App.mountFieldInteractions(saForm, saMeta, saCtx);
      App.bindDeferredQuillHosts(saForm);
      App.setupSubAreaAudioControls(saForm, { row: hydrated, fixedAttractionId: attractionId });

      const actions = document.createElement("div");
      actions.className = "inline-form-actions";
      const saveBtn = document.createElement("button");
      saveBtn.type = "button";
      saveBtn.className = "btn btn-sm";
      saveBtn.textContent = areaIsNew ? "创建子区域" : "保存子区域";
      saveBtn.addEventListener("click", async (e) => {
        e.preventDefault();
        e.stopPropagation();
        const prevLabel = saveBtn.textContent;
        saveBtn.disabled = true;
        saveBtn.textContent = "保存中…";
        try {
          if (saForm.dataset.audioUploading === "1") {
            throw new Error("音频仍在上传中，请稍候再保存");
          }
          const payload = await App.collectFormPayload(saForm, saMeta, area || {}, areaIsNew, {
            table: "sub_areas",
            fixedAttractionId: attractionId,
          });
          if (!payload.id) payload.id = App.slugify(payload.name_en || "area", "area");
          if (!payload.name_en?.trim()) throw new Error("请填写子区域英文名");
          payload.attraction_id = attractionId;
          const imageField = saMeta.fields.find((f) => f.type === "image_upload");
          if (imageField) {
            const fileInput = App.formFileInput(saForm, imageField.key);
            if (fileInput?.files?.[0]) {
              payload.cover_image_path = await App.uploadCoverImage(
                fileInput.files[0],
                imageField.uploadFolder || "attractions",
                payload.id
              );
            }
          }
          const audioUp = App.formFileInput(saForm, "_sa_audio_upload");
          if (audioUp?.files?.[0]) {
            payload.audio_url = await App.uploadSubAreaAudioFile(audioUp.files[0], payload.id);
            saForm.dataset.pendingAudioUrl = payload.audio_url;
          } else {
            const resolved = App.resolveSubAreaAudioUrl(saForm, area);
            if (resolved !== undefined) payload.audio_url = resolved;
          }
          App.fillTableDefaults(payload, "sub_areas");
          payload.content_blocks = [];
          for (const key of Object.keys(payload)) {
            if (key.startsWith("_")) delete payload[key];
          }
          const rowPayload = App.sanitizePayloadForTable(payload, "sub_areas", {
            omitId: !areaIsNew,
          });
          const saveSubArea = async (data) => {
            if (areaIsNew) return App.client.from("sub_areas").insert(data);
            return App.client.from("sub_areas").update(data).eq("id", area.id);
          };
          let { error: err } = await saveSubArea(rowPayload);
          if (err && /body/i.test(err.message || "") && /column/i.test(err.message || "")) {
            const withoutBody = { ...rowPayload };
            delete withoutBody.body;
            ({ error: err } = await saveSubArea(withoutBody));
            if (!err) {
              App.showToast("已保存（正文列未就绪：请在 Supabase 执行 032_sub_area_body.sql）", "error");
            }
          }
          if (err && /audio_url/i.test(err.message || "") && /column/i.test(err.message || "")) {
            const withoutAudio = { ...rowPayload };
            delete withoutAudio.audio_url;
            ({ error: err } = await saveSubArea(withoutAudio));
            if (!err) {
              App.showToast("已保存（音频列未就绪：请在 Supabase 执行 033_sub_area_audio_url.sql）", "error");
            }
          }
          if (err) throw new Error(err.message || "保存失败");
          delete saForm.dataset.pendingAudioUrl;
          App.showToast("子区域已保存");
          await renderSubAreasSection();
        } catch (ex) {
          App.showToast(ex?.message || String(ex), "error");
          console.error("子区域保存失败", ex);
        } finally {
          saveBtn.disabled = false;
          saveBtn.textContent = prevLabel;
        }
      });
      if (!areaIsNew && area.id) {
        const delBtn = document.createElement("button");
        delBtn.type = "button";
        delBtn.className = "btn btn-sm btn-danger";
        delBtn.textContent = "删除";
        delBtn.addEventListener("click", async () => {
          if (!confirm("确定删除该子区域？")) return;
          const { error: err } = await App.client.from("sub_areas").delete().eq("id", area.id);
          if (err) App.showToast(err.message, "error");
          else {
            App.showToast("已删除");
            await renderSubAreasSection();
          }
        });
        actions.appendChild(delBtn);
      }
      actions.appendChild(saveBtn);
      container.appendChild(actions);
    };

    const renderSubAreasSection = async () => {
      const listEl = App.$("#attr-subareas-list");
      if (isNew) {
        listEl.innerHTML = `<p class="muted">请先保存景点，再添加子区域。</p>`;
        return;
      }
      try {
        await refreshAttractionGuides();
      } catch (ex) {
        listEl.innerHTML = `<div class="status-bar error">${App.escapeHtml(ex.message)}</div>`;
        return;
      }
      const { data: areas, error } = await App.client
        .from("sub_areas")
        .select("*")
        .eq("attraction_id", attractionId)
        .order("sort_order", { ascending: true });
      if (error) {
        listEl.innerHTML = `<div class="status-bar error">${App.escapeHtml(error.message)}</div>`;
        return;
      }
      App.destroyQuillInRoot(listEl);
      listEl.innerHTML = "";
      if (!(areas || []).length) {
        listEl.innerHTML = `<p class="muted">暂无子区域。可点击下方「+ 添加子区域」。</p>`;
      } else {
        (areas || []).forEach((area) => {
          const block = document.createElement("details");
          block.className = "sub-area-block";
          block.open = true;
          block.innerHTML = `<summary>${App.escapeHtml(area.name_zh || area.name_en)}${area.is_active === false ? " (停用)" : ""}</summary><div class="sub-area-fields"></div>`;
          mountSubAreaForm(block.querySelector(".sub-area-fields"), area, false);
          listEl.appendChild(block);
        });
      }
    };

    const renderAudioSection = async () => {
      const listEl = App.$("#attr-audio-list");
      if (isNew) {
        listEl.innerHTML = `<p class="muted">请先保存景点，再添加音频导览。</p>`;
        return;
      }
      let guides;
      try {
        guides = await refreshAttractionGuides();
      } catch (ex) {
        listEl.innerHTML = `<div class="status-bar error">${App.escapeHtml(ex.message)}</div>`;
        return;
      }
      let html = "";
      (guides || []).forEach((g) => {
        html += `<details class="audio-guide-block" open>
          <summary>${App.escapeHtml(g.title_en)} ${g.is_active ? "" : "(停用)"}</summary>
          <div class="audio-guide-fields" data-guide-id="${App.escapeHtml(g.id)}"></div>
        </details>`;
      });
      listEl.innerHTML = html || `<p class="muted">暂无音频导览</p>`;
      for (const g of guides || []) {
        const box = listEl.querySelector(`[data-guide-id="${g.id}"]`);
        const agMeta = App.TABLES.audio_guides;
        box.className = "audio-guide-fields audio-guide-inline-form";
        box.dataset.audioGuideId = g.id;
        box.innerHTML = agMeta.fields
          .filter((f) => f.type !== "ref_attraction")
          .map((f) => App.renderFieldBlock(f, App.fieldToFormValue(f, g[f.key]), { isNew: false, pk: "id" }))
          .join("");
        App.mountFieldInteractions(box, agMeta, {
          isNew: false,
          pk: "id",
          fixedAttractionId: attractionId,
          formEl: box,
        });
        App.setupAudioGuideControls(box, g.id, { fixedAttractionId: attractionId });
        const saveBtn = document.createElement("button");
        saveBtn.type = "button";
        saveBtn.className = "btn btn-sm";
        saveBtn.textContent = "保存此导览";
        saveBtn.addEventListener("click", async () => {
          try {
            const payload = { updated_at: new Date().toISOString() };
            for (const f of agMeta.fields) {
              if (f.readonly || f.type === "audio_upload" || f.type === "audio_preview") continue;
              if (f.key.startsWith("_")) continue;
              let v;
              if (f.type === "segment_list") {
                v = App.readListBuilder(box, f, box);
              } else if (f.type === "bool") {
                v = box.querySelector(`[name="${f.key}"]`)?.checked || false;
              } else {
                const inp = box.querySelector(`[name="${f.key}"]`);
                if (!inp) continue;
                v = inp.value?.trim() === "" ? null : inp.value?.trim();
                if (f.type === "number" && v !== null) v = Number(v);
              }
              if (v !== undefined) payload[f.key] = v;
            }
            const pendingUrl = box.dataset.pendingAudioUrl?.trim();
            if (pendingUrl) {
              payload.audio_url = pendingUrl;
            } else {
              const audioUp = box.querySelector('[name="_audio_upload"]');
              if (audioUp?.files?.[0]) {
                payload.audio_url = await App.uploadAudioGuideFile(audioUp.files[0], g.id);
              }
            }
            const audioUrlHidden = box.querySelector('[name="audio_url"]')?.value?.trim();
            if (audioUrlHidden) payload.audio_url = audioUrlHidden;
            App.fillTableDefaults(payload, "audio_guides");
            const { error: err } = await App.client.from("audio_guides").update(payload).eq("id", g.id);
            if (err) throw err;
            await App.syncAttractionAudioGuideCount(attractionId);
            await App.loadRefCache(true);
            App.showToast("音频导览已保存");
            await renderAudioSection();
            await renderSubAreasSection();
          } catch (ex) {
            App.showToast(ex.message, "error");
          }
        });
        box.appendChild(saveBtn);
      }
    };

    await renderSubAreasSection();
    await renderAudioSection();

    const backToCity = () => {
      if (App.navigateTo) App.navigateTo({ kind: "city_panel", cityId, panel: "attractions" });
      else App.openCityHub(cityId, "attractions");
    };
    App.$("#hub-back-attr")?.addEventListener("click", backToCity);
    App.$("#cancel-attr-edit")?.addEventListener("click", backToCity);

    if (App.attractionFocusSection === "sub_areas" && App.attractionFocusId) {
      form.querySelectorAll(".sub-area-block").forEach((b) => {
        const idInput = b.querySelector('[name="id"]');
        if (idInput?.value === App.attractionFocusId) {
          b.open = true;
          b.scrollIntoView({ behavior: "smooth", block: "start" });
        }
      });
    }
    if (App.attractionFocusSection === "audio" && App.attractionFocusId) {
      const block = form.querySelector(`[data-guide-id="${App.attractionFocusId}"]`);
      block?.closest("details")?.scrollIntoView({ behavior: "smooth", block: "start" });
      if (block?.closest("details")) block.closest("details").open = true;
    }
    App.$("#delete-attr-edit")?.addEventListener("click", async () => {
      if (!attractionId || !confirm("确定删除该景点？关联子区域与音频需已手动处理或将被级联删除。")) return;
      const { error: err } = await App.client.from("attractions").delete().eq("id", attractionId);
      if (err) {
        App.showToast(err.message, "error");
        return;
      }
      App.showToast("景点已删除");
      await App.loadRefCache(true);
      App.openCityHub(cityId);
    });
    App.$("#add-sub-area")?.addEventListener("click", () => {
      if (isNew) {
        App.showToast("请先保存景点", "error");
        return;
      }
      const listEl = App.$("#attr-subareas-list");
      listEl.querySelector(".muted")?.remove();
      const block = document.createElement("details");
      block.className = "sub-area-block sub-area-block--new";
      block.open = true;
      block.innerHTML = `<summary>新建子区域</summary><div class="sub-area-fields"></div>`;
      mountSubAreaForm(block.querySelector(".sub-area-fields"), { body: "", is_active: true, sort_order: 0 }, true);
      listEl.prepend(block);
    });
    App.$("#add-audio-guide")?.addEventListener("click", () => {
      if (isNew) {
        App.showToast("请先保存景点", "error");
        return;
      }
      App.openModal({ attraction_id: attractionId }, "audio_guides", {
        fixedCityId: cityId,
        fixedAttractionId: attractionId,
        onSaved: async () => {
          await App.loadRefCache(true);
          await renderAudioSection();
          await renderSubAreasSection();
        },
      });
    });

    form.addEventListener("submit", async (e) => {
      e.preventDefault();
      try {
        const payload = await App.collectFormPayload(form, meta, row, isNew, {
          ...editorCtx,
          table: "attractions",
        });
        let err;
        if (isNew) {
          ({ error: err } = await App.client.from("attractions").insert(payload));
        } else {
          ({ error: err } = await App.client.from("attractions").update(payload).eq("id", attractionId));
        }
        if (err) throw err;
        const savedId = payload.id || attractionId;
        await App.syncAttractionAudioGuideCount(savedId);
        App.showToast("景点已保存");
        await App.loadRefCache(true);
        if (isNew && payload.id) App.openAttractionEditor(payload.id, cityId);
        else {
          await renderSubAreasSection();
          await renderAudioSection();
        }
      } catch (ex) {
        App.showToast(ex.message, "error");
      }
    });
  };

  App.renderCityAudioHub = async function renderCityAudioHub(cityId, panel) {
    const attrs = App.attractionsForCity(cityId);
    let guides = [];
    let error = null;
    if (attrs.length) {
      const res = await App.client
        .from("audio_guides")
        .select("*")
        .in("attraction_id", attrs.map((a) => a.id))
        .order("sort_order", { ascending: true });
      guides = res.data;
      error = res.error;
    }
    if (error) {
      panel.innerHTML = `<div class="status-bar error">${App.escapeHtml(error.message)}</div>`;
      return;
    }
    let html = `<div class="hub-toolbar"><button type="button" class="btn" id="new-audio">+ 新建音频导览</button></div>`;
    const byAttr = {};
    (guides || []).forEach((g) => {
      if (!byAttr[g.attraction_id]) byAttr[g.attraction_id] = [];
      byAttr[g.attraction_id].push(g);
    });
    attrs.forEach((a) => {
      html += `<h4 class="audio-group-title">${App.escapeHtml(a.chinese_name || a.name)}</h4><ul class="audio-group-list">`;
      (byAttr[a.id] || []).forEach((g) => {
        const hasAudio = !!(g.audio_url || "").trim();
        const dur = Number(g.duration_seconds) || 0;
        const durLabel =
          dur > 0
            ? `${Math.floor(dur / 60)}:${String(dur % 60).padStart(2, "0")}`
            : "—";
        const audioBadge = hasAudio
          ? '<span class="tag on">有音频</span>'
          : '<span class="tag off">无音频</span>';
        html += `<li>${audioBadge} ${App.escapeHtml(g.title_en)} · ${durLabel}
          <button type="button" class="btn btn-sm btn-secondary" data-edit-audio="${App.escapeHtml(g.id)}">编辑</button></li>`;
      });
      if (!(byAttr[a.id] || []).length) html += `<li class="muted">暂无导览</li>`;
      html += `</ul>`;
    });
    panel.innerHTML = html;
    App.$("#new-audio", panel)?.addEventListener("click", () => {
      App.openModal(null, "audio_guides", {
        fixedCityId: cityId,
        onSaved: () => App.renderCityAudioHub(cityId, panel),
      });
    });
    panel.querySelectorAll("[data-edit-audio]").forEach((btn) => {
      btn.addEventListener("click", async () => {
        const { data } = await App.client.from("audio_guides").select("*").eq("id", btn.dataset.editAudio).single();
        App.openModal(data, "audio_guides", { onSaved: () => App.renderCityAudioHub(cityId, panel) });
      });
    });
  };

  App.renderCitySubTable = async function renderCitySubTable(cityId, panel, table) {
    const meta = App.TABLES[table];
    panel.innerHTML = `<div class="hub-toolbar"><button type="button" class="btn" id="hub-new-row">+ 新建</button></div><div id="hub-table-host"></div>`;
    App.$("#hub-new-row", panel).addEventListener("click", () => {
      App.openModal({ city_id: cityId }, table, {
        fixedCityId: cityId,
        onSaved: () => App.renderCitySubTable(cityId, panel, table),
      });
    });
    const host = App.$("#hub-table-host", panel);
    const { data, error } = await App.client.from(table).select("*").eq("city_id", cityId).order(meta.order || "id");
    if (error) {
      host.innerHTML = `<div class="status-bar error">${App.escapeHtml(error.message)}</div>`;
      return;
    }
    const cols = meta.listColumns || [];
    let html = `<div class="table-wrap"><table><thead><tr>`;
    cols.forEach((c) => { html += `<th>${App.escapeHtml(App.getListColumnLabel(c))}</th>`; });
    html += `<th>操作</th></tr></thead><tbody>`;
    (data || []).forEach((row) => {
      html += "<tr>";
      cols.forEach((c) => { html += `<td>${App.formatListCell(c, row)}</td>`; });
      html += `<td><button class="btn btn-sm btn-secondary" data-edit-row="${App.escapeHtml(String(row[meta.pk]))}">编辑</button>
        <button class="btn btn-sm btn-danger" data-del-row="${App.escapeHtml(String(row[meta.pk]))}">删除</button></td></tr>`;
    });
    html += "</tbody></table></div>";
    host.innerHTML = html;
    host.querySelectorAll("[data-edit-row]").forEach((btn) => {
      btn.addEventListener("click", async () => {
        const { data: row } = await App.client.from(table).select("*").eq(meta.pk, btn.dataset.editRow).single();
        App.openModal(row, table, { fixedCityId: cityId, onSaved: () => App.renderCitySubTable(cityId, panel, table) });
      });
    });
    host.querySelectorAll("[data-del-row]").forEach((btn) => {
      btn.addEventListener("click", async () => {
        if (!confirm("确定删除？")) return;
        const { error: err } = await App.client.from(table).delete().eq(meta.pk, btn.dataset.delRow);
        if (err) App.showToast(err.message, "error");
        else {
          App.showToast("已删除");
          await App.renderCitySubTable(cityId, panel, table);
        }
      });
    });
  };

  App.renderCityReadingList = async function renderCityReadingList(cityId, panel) {
    const meta = App.TABLES.reading_list;
    panel.innerHTML = `<div class="hub-toolbar"><button type="button" class="btn" id="hub-new-row">+ 新建</button></div><div id="hub-table-host"></div>`;
    App.$("#hub-new-row", panel).addEventListener("click", () => {
      App.openModal({ city_ids: [cityId] }, "reading_list", {
        fixedCityId: cityId,
        onSaved: () => App.renderCityReadingList(cityId, panel),
      });
    });
    const host = App.$("#hub-table-host", panel);
    const { data, error } = await App.client.from("reading_list").select("*").order(meta.order || "sort_order");
    if (error) {
      host.innerHTML = `<div class="status-bar error">${App.escapeHtml(error.message)}</div>`;
      return;
    }
    const rows = (data || []).filter((r) => {
      const ids = Array.isArray(r.city_ids) ? r.city_ids : [];
      return !ids.length || ids.includes(cityId);
    });
    host.innerHTML = App.renderTableBody("reading_list", rows);
    host.querySelectorAll("[data-edit-id]").forEach((btn) => {
      btn.addEventListener("click", async () => {
        const { data: row } = await App.client.from("reading_list").select("*").eq(meta.pk, btn.dataset.editId).single();
        App.openModal(row, "reading_list", { fixedCityId: cityId, onSaved: () => App.renderCityReadingList(cityId, panel) });
      });
    });
    host.querySelectorAll("[data-del]").forEach((btn) => {
      btn.addEventListener("click", async () => {
        if (!confirm("确定删除？")) return;
        const { error: err } = await App.client.from("reading_list").delete().eq(meta.pk, btn.dataset.del);
        if (err) App.showToast(err.message, "error");
        else {
          App.showToast("已删除");
          await App.renderCityReadingList(cityId, panel);
        }
      });
    });
  };

  App.renderCityChecklist = async function renderCityChecklist(cityId, panel) {
    const meta = App.TABLES.checklist_items;
    panel.innerHTML = `<div class="hub-toolbar">
      <button type="button" class="btn btn-secondary btn-sm" id="hub-global-cl-settings">全局清单设置</button>
      <button type="button" class="btn" id="hub-new-cl">+ 新建清单项</button>
      <select id="hub-cl-type-filter" class="search-input">
        <option value="">全部类型</option>
        ${(meta.fields.find((f) => f.key === "type")?.options || [])
          .map((o) => `<option value="${App.escapeHtml(o.value)}">${App.escapeHtml(o.label)}</option>`)
          .join("")}
      </select>
    </div>
    <p class="muted">本页显示：全部 <strong>入境 entry</strong> 与 <strong>通用 universal</strong>（与行程无关）+ <strong>target_cities</strong> 含本城市的 city 项。用户未保存行程时 App 不展示任何 city 项。</p>
    <div id="hub-cl-host"></div>`;

    App.$("#hub-global-cl-settings", panel)?.addEventListener("click", () => {
      if (App.navigateTo) App.navigateTo({ kind: "checklist_settings_global", cityId });
      else App.renderChecklistSettings();
    });

    App.$("#hub-new-cl", panel).addEventListener("click", () => {
      App.openModal(App.getChecklistCreateDefaults({ fixedCityId: cityId }), "checklist_items", {
        fixedCityId: cityId,
        onSaved: () => App.renderCityChecklist(cityId, panel),
      });
    });

    const { data, error } = await App.client.from("checklist_items").select("*").order("sort_order");
    if (error) {
      App.$("#hub-cl-host", panel).innerHTML = `<div class="status-bar error">${error.message}</div>`;
      return;
    }

    const host = App.$("#hub-cl-host", panel);
    const typeFilterEl = App.$("#hub-cl-type-filter", panel);
    let typeFilter = "";

    const paint = () => {
      let rows = App.filterChecklistRowsByCity(data || [], cityId);
      rows = App.filterChecklistRowsByType(rows, typeFilter);
      host.innerHTML = App.renderTableBody("checklist_items", rows);
      host.querySelectorAll("[data-edit-id]").forEach((btn) => {
        btn.addEventListener("click", async () => {
          const { data: row } = await App.client
            .from("checklist_items")
            .select("*")
            .eq("id", btn.dataset.editId)
            .single();
          App.openModal(row, "checklist_items", {
            fixedCityId: cityId,
            onSaved: () => App.renderCityChecklist(cityId, panel),
          });
        });
      });
      host.querySelectorAll("[data-del]").forEach((btn) => {
        btn.addEventListener("click", async () => {
          if (!confirm("确定删除该清单项？")) return;
          const { error: err } = await App.client.from("checklist_items").delete().eq("id", btn.dataset.del);
          if (err) App.showToast(err.message, "error");
          else {
            App.showToast("已删除");
            await App.renderCityChecklist(cityId, panel);
          }
        });
      });
    };

    typeFilterEl?.addEventListener("change", (e) => {
      typeFilter = e.target.value;
      paint();
    });
    paint();
  };
})();
