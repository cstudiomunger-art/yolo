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
      <div class="hub-toolbar">
        <input type="search" id="city-search" placeholder="搜索城市名称…" class="search-input" />
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

    App.$("#city-search")?.addEventListener("input", (e) => {
      const q = e.target.value.toLowerCase();
      App.$$(".city-card", grid).forEach((card) => {
        card.classList.toggle("hidden", q && !card.dataset.name.includes(q));
      });
    });

    main.querySelectorAll("[data-open-hub]").forEach((btn) => {
      btn.addEventListener("click", () => App.openCityHub(btn.dataset.openHub));
    });
    main.querySelectorAll("[data-edit-city]").forEach((btn) => {
      btn.addEventListener("click", async () => {
        const { data } = await App.client.from("cities").select("*").eq("id", btn.dataset.editCity).single();
        App.openModal(data, "cities", { onSaved: () => App.renderCityHubList() });
      });
    });
  };

  App.openCityHub = async function openCityHub(cityId) {
    App.cityHubCityId = cityId;
    App.currentView = "city_detail";
    const city = App.refCache.cities.find((c) => c.id === cityId) || (await App.client.from("cities").select("*").eq("id", cityId).single()).data;
    App.$("#page-title").innerHTML = `<button type="button" class="breadcrumb-link" id="hub-back">城市工作台</button> <span class="breadcrumb-sep">›</span> ${App.escapeHtml(city?.chinese_name || city?.name || cityId)}`;
    App.$("#add-row-btn").classList.add("hidden");
    App.$("#hub-back")?.addEventListener("click", () => {
      App.currentView = "city_hub";
      App.renderCityHubList();
    });

    const main = App.$("#main-content");
    main.innerHTML = `
      <nav class="hub-tabs">
        <button type="button" class="hub-tab active" data-tab="overview">概览</button>
        <button type="button" class="hub-tab" data-tab="attractions">景点与解说</button>
        <button type="button" class="hub-tab" data-tab="audio">音频导览</button>
        <button type="button" class="hub-tab" data-tab="routes">路线</button>
        <button type="button" class="hub-tab" data-tab="hotels">酒店</button>
        <button type="button" class="hub-tab" data-tab="checklist">行前清单</button>
      </nav>
      <div id="hub-panel"></div>`;

    const loadTab = async (tab) => {
      App.$$(".hub-tab", main).forEach((b) => b.classList.toggle("active", b.dataset.tab === tab));
      const panel = App.$("#hub-panel");
      if (tab === "overview") await App.renderCityOverview(cityId, panel);
      else if (tab === "attractions") await App.renderCityAttractionsList(cityId, panel);
      else if (tab === "audio") await App.renderCityAudioHub(cityId, panel);
      else if (tab === "routes") await App.renderCitySubTable(cityId, panel, "city_routes");
      else if (tab === "hotels") await App.renderCitySubTable(cityId, panel, "hotels");
      else if (tab === "checklist") await App.renderCityChecklist(cityId, panel);
    };

    App.$$(".hub-tab", main).forEach((btn) => {
      btn.addEventListener("click", () => loadTab(btn.dataset.tab));
    });
    await loadTab("overview");
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
        const payload = await App.collectFormPayload(form, meta, city, false);
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
      html += `<article class="attraction-card">
        <h4>${App.escapeHtml(a.chinese_name || a.name)}</h4>
        <p class="muted">${App.escapeHtml(a.summary || "")}</p>
        <p class="intro-preview">${App.escapeHtml(intro)}${(a.introduction || "").length > 120 ? "…" : ""}</p>
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
      btn.addEventListener("click", () => App.openAttractionEditor(btn.dataset.editAttr, cityId));
    });
  };

  App.openAttractionEditor = async function openAttractionEditor(attractionId, cityId) {
    App.attractionEditId = attractionId;
    App.currentView = "attraction_edit";
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
        <section class="editor-section"><h3>语音导览</h3><div id="attr-audio-list"></div>
          <button type="button" class="btn btn-sm btn-secondary" id="add-audio-guide">+ 添加音频导览</button>
        </section>
        <div class="editor-actions">
          <button type="button" class="btn btn-secondary" id="cancel-attr-edit">取消</button>
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

    const renderAudioSection = async () => {
      const listEl = App.$("#attr-audio-list");
      if (isNew) {
        listEl.innerHTML = `<p class="muted">请先保存景点，再添加音频导览。</p>`;
        return;
      }
      const { data: guides } = await App.client
        .from("audio_guides")
        .select("*")
        .eq("attraction_id", attractionId)
        .order("sort_order", { ascending: true });
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
        box.innerHTML = agMeta.fields
          .filter((f) => f.type !== "ref_attraction")
          .map((f) => App.renderFieldBlock(f, App.fieldToFormValue(f, g[f.key]), { isNew: false, pk: "id" }))
          .join("");
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
            const audioUp = box.querySelector('[name="_audio_upload"]');
            if (audioUp?.files?.[0]) {
              payload.audio_url = await App.uploadAudioGuideFile(audioUp.files[0], g.id);
            }
            const { error: err } = await App.client.from("audio_guides").update(payload).eq("id", g.id);
            if (err) throw err;
            App.showToast("音频导览已保存");
            await renderAudioSection();
          } catch (ex) {
            App.showToast(ex.message, "error");
          }
        });
        box.appendChild(saveBtn);
      }
    };

    await renderAudioSection();

    App.$("#hub-back-attr")?.addEventListener("click", () => App.openCityHub(cityId));
    App.$("#cancel-attr-edit")?.addEventListener("click", () => App.openCityHub(cityId));
    App.$("#add-audio-guide")?.addEventListener("click", () => {
      if (isNew) {
        App.showToast("请先保存景点", "error");
        return;
      }
      App.openModal({ attraction_id: attractionId }, "audio_guides", {
        fixedCityId: cityId,
        fixedAttractionId: attractionId,
        onSaved: () => renderAudioSection(),
      });
    });

    form.addEventListener("submit", async (e) => {
      e.preventDefault();
      try {
        const payload = await App.collectFormPayload(form, meta, row, isNew, editorCtx);
        let err;
        if (isNew) {
          ({ error: err } = await App.client.from("attractions").insert(payload));
        } else {
          ({ error: err } = await App.client.from("attractions").update(payload).eq("id", attractionId));
        }
        if (err) throw err;
        App.showToast("景点已保存");
        await App.loadRefCache(true);
        if (isNew && payload.id) App.openAttractionEditor(payload.id, cityId);
        else await renderAudioSection();
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
        html += `<li>${App.escapeHtml(g.title_en)} · ${g.duration_seconds || 0}s
          <button type="button" class="btn btn-sm btn-secondary" data-edit-audio="${App.escapeHtml(g.id)}">编辑</button></li>`;
      });
      if (!(byAttr[a.id] || []).length) html += `<li class="muted">暂无导览</li>`;
      html += `</ul>`;
    });
    panel.innerHTML = html;
    App.$("#new-audio", panel)?.addEventListener("click", () => {
      App.openModal(null, "audio_guides", {
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

  App.renderCityChecklist = async function renderCityChecklist(cityId, panel) {
    panel.innerHTML = `<div class="hub-toolbar"><button type="button" class="btn" id="hub-new-cl">+ 新建清单项</button></div><p class="muted">显示本城市专属项 + 全局项</p><div id="hub-cl-host"></div>`;
    App.$("#hub-new-cl", panel).addEventListener("click", () => {
      App.openModal({ city_id: cityId }, "checklist_items", {
        onSaved: () => App.renderCityChecklist(cityId, panel),
      });
    });
    const { data, error } = await App.client.from("checklist_items").select("*").order("sort_order");
    if (error) {
      App.$("#hub-cl-host", panel).innerHTML = `<div class="status-bar error">${error.message}</div>`;
      return;
    }
    const rows = (data || []).filter((r) => !r.city_id || r.city_id === cityId);
    let html = `<div class="table-wrap"><table><thead><tr><th>标题</th><th>城市</th><th>阶段</th><th></th></tr></thead><tbody>`;
    rows.forEach((row) => {
      html += `<tr><td>${App.escapeHtml(row.title_en)}</td><td>${row.city_id ? App.cityLabel(row.city_id) : "全局"}</td><td>${App.escapeHtml(row.phase)}</td>
        <td><button class="btn btn-sm btn-secondary" data-edit-cl="${App.escapeHtml(row.id)}">编辑</button></td></tr>`;
    });
    html += `</tbody></table></div>`;
    App.$("#hub-cl-host", panel).innerHTML = html;
    panel.querySelectorAll("[data-edit-cl]").forEach((btn) => {
      btn.addEventListener("click", async () => {
        const { data: row } = await App.client.from("checklist_items").select("*").eq("id", btn.dataset.editCl).single();
        App.openModal(row, "checklist_items", { onSaved: () => App.renderCityChecklist(cityId, panel) });
      });
    });
  };
})();
