/* ChinaGo Admin — sidebar navigation & city tree */

(function () {
  const App = window.ChinaGoAdmin;

  App.treeCache = App.treeCache || { subAreas: {}, audioGuides: {} };
  App.navSelection = App.navSelection || { kind: "city_list" };

  App.CITY_TREE_PANELS = [
    { id: "overview", label: "城市概览" },
    { id: "city_guides", label: "城市指南", table: "city_guides" },
    { id: "hotels", label: "酒店", table: "hotels" },
    { id: "checklist", label: "行前清单", table: "checklist_items" },
    { id: "home_tips", label: "首页提示", table: "home_tips" },
    { id: "shopping_items", label: "购物清单", table: "shopping_items" },
    { id: "reading_list", label: "阅读清单", table: "reading_list" },
    { id: "audio", label: "音频导览（城市）", panel: "audio" },
  ];

  App.GLOBAL_NAV_GROUPS = [
    {
      id: "workspace",
      label: "工作台",
      defaultExpanded: true,
      items: [{ kind: "city_list", label: "城市工作台" }],
    },
    {
      id: "users",
      label: "用户",
      defaultExpanded: true,
      items: [{ kind: "view", view: "users_hub", label: "用户与购买" }],
    },
    {
      id: "global",
      label: "全局配置",
      defaultExpanded: true,
      items: [
        { kind: "table", table: "app_settings", label: "应用配置" },
        { kind: "table", table: "emergency_config", label: "紧急联系" },
      ],
    },
    {
      id: "assistant",
      label: "助手",
      defaultExpanded: false,
      items: [
        { kind: "table", table: "assistant_scenarios", label: "助手场景" },
        { kind: "table", table: "assistant_chips", label: "助手芯片" },
      ],
    },
    {
      id: "visa",
      label: "签证与文化",
      defaultExpanded: false,
      items: [
        { kind: "table", table: "passport_countries", label: "护照国家" },
        { kind: "table", table: "visa_rules", label: "签证规则" },
        { kind: "table", table: "culture_tips", label: "文化贴士" },
      ],
    },
    {
      id: "tools",
      label: "工具 · 跨城",
      defaultExpanded: false,
      items: [
        { kind: "table", table: "content_itineraries", label: "行程模板" },
        { kind: "table", table: "cities", label: "全表：城市" },
        { kind: "table", table: "attractions", label: "全表：景点" },
        { kind: "table", table: "audio_guides", label: "全表：音频导览" },
        { kind: "table", table: "user_itineraries", label: "用户行程" },
      ],
    },
  ];

  App.navCaretMarkup = function navCaretMarkup(expanded) {
    const cls = expanded ? "nav-caret--expanded" : "nav-caret--collapsed";
    return `<span class="nav-caret ${cls}" aria-hidden="true"></span>`;
  };

  App.cityLabelShort = function cityLabelShort(city) {
    if (!city) return "";
    return `${city.emoji || ""} ${city.chinese_name || city.name || city.id}`.trim();
  };

  App.attractionLabelShort = function attractionLabelShort(attr) {
    if (!attr) return "";
    return attr.chinese_name || attr.name || attr.id;
  };

  App.syncNavSelectionFromState = function syncNavSelectionFromState() {
    if (App.currentView === "users_hub") {
      App.navSelection = { kind: "view", view: "users_hub" };
    } else if (App.currentView === "table" && App.currentTable) {
      App.navSelection = { kind: "table", table: App.currentTable };
    } else if (App.currentView === "attraction_edit" && App.cityHubCityId) {
      App.navSelection = {
        kind: "attraction",
        cityId: App.cityHubCityId,
        attractionId: App.attractionEditId,
        focusSection: App.attractionFocusSection || null,
        focusId: App.attractionFocusId || null,
      };
    } else if (App.currentView === "city_detail" && App.cityHubCityId) {
      App.navSelection = {
        kind: "city_panel",
        cityId: App.cityHubCityId,
        panel: App.cityHubPanel || "overview",
      };
    } else if (App.currentView === "city_hub") {
      App.navSelection = { kind: "city_list" };
    } else if (App.currentView === "checklist_settings_global") {
      App.navSelection = { kind: "checklist_settings_global", cityId: App.cityHubCityId };
    }
  };

  App.applyNavSelectionToState = function applyNavSelectionToState(sel) {
    App.navSelection = sel || { kind: "city_list" };
    App.usersHubUserId = null;
    App.attractionFocusSection = sel?.focusSection || null;
    App.attractionFocusId = sel?.focusId || null;

    if (sel.kind === "view") {
      App.currentView = sel.view;
      App.currentTable = null;
      App.cityHubCityId = null;
      App.attractionEditId = null;
    } else if (sel.kind === "table") {
      App.currentView = "table";
      App.currentTable = sel.table;
      App.cityHubCityId = null;
      App.attractionEditId = null;
    } else if (sel.kind === "city_list") {
      App.currentView = "city_hub";
      App.currentTable = null;
      App.cityHubCityId = null;
      App.attractionEditId = null;
    } else if (sel.kind === "city_panel") {
      App.currentView = "city_detail";
      App.currentTable = null;
      App.cityHubCityId = sel.cityId;
      App.cityHubPanel = sel.panel || "overview";
      App.attractionEditId = null;
    } else if (sel.kind === "attraction") {
      App.currentView = "attraction_edit";
      App.currentTable = null;
      App.cityHubCityId = sel.cityId;
      App.attractionEditId = sel.attractionId || null;
    } else if (sel.kind === "checklist_settings_global") {
      App.currentView = "checklist_settings_global";
      App.cityHubCityId = sel.cityId || null;
    }
    App.saveLastRoute(App.navSelection);
  };

  App.navigateTo = async function navigateTo(sel) {
    App.applyNavSelectionToState(sel);
    App.expandTreePathForSelection(sel);
    App.highlightNavSelection();
    await App.loadCurrentSection();
    await App.renderSidebar();
  };

  App.highlightNavSelection = function highlightNavSelection() {
    const sel = App.navSelection;
    App.$$(".nav-tree-row, .nav-btn").forEach((el) => el.classList.remove("active"));
    if (!sel) return;

    if (sel.kind === "view") {
      App.$(`.nav-btn[data-nav-view="${sel.view}"]`)?.classList.add("active");
    } else if (sel.kind === "table") {
      App.$(`.nav-btn[data-nav-table="${sel.table}"]`)?.classList.add("active");
    } else if (sel.kind === "city_list") {
      App.$('.nav-btn[data-nav-city-list], .nav-tree-row[data-nav-kind="city_list"]')?.classList.add("active");
    } else if (sel.cityId) {
      const rowSel = `[data-city-id="${sel.cityId}"]`;
      if (sel.kind === "city_panel" && sel.panel) {
        App.$(`.nav-tree-row[data-nav-kind="city_panel"][data-city-id="${sel.cityId}"][data-panel="${sel.panel}"]`)?.classList.add(
          "active"
        );
      } else if (sel.kind === "attraction" && sel.attractionId) {
        if (sel.focusSection === "sub_areas" && sel.focusId) {
          App.$(
            `.nav-tree-row[data-nav-kind="sub_area"][data-city-id="${sel.cityId}"][data-attraction-id="${sel.attractionId}"][data-sub-area-id="${sel.focusId}"]`
          )?.classList.add("active");
        } else if (sel.focusSection === "audio" && sel.focusId) {
          App.$(
            `.nav-tree-row[data-nav-kind="audio_guide"][data-city-id="${sel.cityId}"][data-attraction-id="${sel.attractionId}"][data-audio-id="${sel.focusId}"]`
          )?.classList.add("active");
        } else {
          App.$(
            `.nav-tree-row[data-nav-kind="attraction"][data-city-id="${sel.cityId}"][data-attraction-id="${sel.attractionId}"]`
          )?.classList.add("active");
        }
      } else if (sel.kind === "city_panel" && sel.panel === "overview") {
        App.$(`.nav-tree-row[data-nav-kind="city"][data-city-id="${sel.cityId}"]`)?.classList.add("active");
      }
    }
  };

  App.expandTreePathForSelection = function expandTreePathForSelection(sel) {
    App.setTreeExpanded("cities_root", true);
    if (!sel?.cityId) return;
    App.setTreeExpanded(`city:${sel.cityId}`, true);
    if (sel.kind === "attraction" || sel.panel === "attractions") {
      App.setTreeExpanded(`city:${sel.cityId}:attractions`, true);
    }
    if (sel.attractionId) {
      App.setTreeExpanded(`city:${sel.cityId}:attr:${sel.attractionId}`, true);
      if (sel.focusSection === "sub_areas") {
        App.setTreeExpanded(`city:${sel.cityId}:attr:${sel.attractionId}:sub`, true);
      }
      if (sel.focusSection === "audio") {
        App.setTreeExpanded(`city:${sel.cityId}:attr:${sel.attractionId}:audio`, true);
      }
    }
  };

  App.loadAttractionsForCity = async function loadAttractionsForCity(cityId) {
    const cached = App.treeCache.attractionsByCity?.[cityId];
    if (cached) return cached;
    const { data, error } = await App.client
      .from("attractions")
      .select("id,city_id,name,chinese_name,display_order")
      .eq("city_id", cityId)
      .order("display_order", { ascending: true });
    if (error) throw error;
    App.treeCache.attractionsByCity = App.treeCache.attractionsByCity || {};
    App.treeCache.attractionsByCity[cityId] = data || [];
    return data || [];
  };

  App.loadSubAreasForAttraction = async function loadSubAreasForAttraction(attractionId) {
    if (App.treeCache.subAreas[attractionId]) return App.treeCache.subAreas[attractionId];
    const { data, error } = await App.client
      .from("sub_areas")
      .select("id,name_en,name_zh,sort_order")
      .eq("attraction_id", attractionId)
      .order("sort_order", { ascending: true });
    if (error) throw error;
    App.treeCache.subAreas[attractionId] = data || [];
    return data || [];
  };

  App.loadAudioGuidesForAttraction = async function loadAudioGuidesForAttraction(attractionId) {
    if (App.treeCache.audioGuides[attractionId]) return App.treeCache.audioGuides[attractionId];
    const { data, error } = await App.client
      .from("audio_guides")
      .select("id,title_en,sort_order")
      .eq("attraction_id", attractionId)
      .order("sort_order", { ascending: true });
    if (error) throw error;
    App.treeCache.audioGuides[attractionId] = data || [];
    return data || [];
  };

  App.invalidateCityTreeCache = function invalidateCityTreeCache(cityId) {
    if (cityId && App.treeCache.attractionsByCity) delete App.treeCache.attractionsByCity[cityId];
    App.treeCache.subAreas = {};
    App.treeCache.audioGuides = {};
  };

  App.renderCityTreeBranch = async function renderCityTreeBranch(city, filterQ) {
    const cityId = city.id;
    const cityExpanded = App.isTreeExpanded(`city:${cityId}`, false);
    const q = (filterQ || "").toLowerCase();
    const cityHay = `${city.name} ${city.chinese_name} ${city.id}`.toLowerCase();
    let attrs = [];
    if (cityExpanded || q) {
      try {
        attrs = await App.loadAttractionsForCity(cityId);
      } catch {
        attrs = App.refCache.attractions.filter((a) => a.city_id === cityId);
      }
    }

    let html = `<div class="nav-tree-branch" data-city-branch="${App.escapeHtml(cityId)}">`;
    html += `<div class="nav-tree-row nav-tree-row--depth-1" data-nav-kind="city" data-city-id="${App.escapeHtml(cityId)}" role="button" tabindex="0">
      <button type="button" class="nav-tree-toggle" data-toggle-key="city:${App.escapeHtml(cityId)}" aria-expanded="${cityExpanded}" aria-label="展开或收起">${App.navCaretMarkup(cityExpanded)}</button>
      <span class="nav-tree-label">${App.escapeHtml(App.cityLabelShort(city))}</span>
    </div>`;

    if (!cityExpanded && !q) {
      html += `</div>`;
      return { html, visible: !q || cityHay.includes(q) };
    }

    html += `<div class="nav-tree-children ${cityExpanded || q ? "" : "hidden"}">`;

    for (const panel of App.CITY_TREE_PANELS) {
      const panelHay = panel.label.toLowerCase();
      if (q && !cityHay.includes(q) && !panelHay.includes(q)) continue;
      html += `<div class="nav-tree-row nav-tree-row--depth-2" data-nav-kind="city_panel" data-city-id="${App.escapeHtml(cityId)}" data-panel="${App.escapeHtml(panel.id)}" role="button" tabindex="0">
        <span class="nav-tree-spacer"></span><span class="nav-tree-label">${App.escapeHtml(panel.label)}</span>
      </div>`;
    }

    const attrFolderKey = `city:${cityId}:attractions`;
    const attrExpanded = App.isTreeExpanded(attrFolderKey, false);
    const filteredAttrs = attrs.filter((a) => {
      if (!q) return true;
      const hay = `${a.name} ${a.chinese_name} ${a.id}`.toLowerCase();
      return hay.includes(q) || cityHay.includes(q);
    });

    if (!q && !filteredAttrs.length && !attrExpanded) {
      /* still show empty folder */
    }

    html += `<div class="nav-tree-row nav-tree-row--depth-2" data-nav-kind="attr_folder" data-city-id="${App.escapeHtml(cityId)}" role="button" tabindex="0">
      <button type="button" class="nav-tree-toggle" data-toggle-key="${App.escapeHtml(attrFolderKey)}" aria-expanded="${attrExpanded}" aria-label="展开或收起">${App.navCaretMarkup(attrExpanded)}</button>
      <span class="nav-tree-label">景点 (${filteredAttrs.length})</span>
    </div>`;

    if (attrExpanded || q) {
      html += `<div class="nav-tree-children">`;
      for (const attr of filteredAttrs) {
        const attrId = attr.id;
        const attrKey = `city:${cityId}:attr:${attrId}`;
        const attrNodeExpanded = App.isTreeExpanded(attrKey, false);
        const attrHay = `${attr.name} ${attr.chinese_name}`.toLowerCase();

        html += `<div class="nav-tree-row nav-tree-row--depth-3" data-nav-kind="attraction" data-city-id="${App.escapeHtml(cityId)}" data-attraction-id="${App.escapeHtml(attrId)}" role="button" tabindex="0">
          <button type="button" class="nav-tree-toggle" data-toggle-key="${App.escapeHtml(attrKey)}" aria-expanded="${attrNodeExpanded}" aria-label="展开或收起">${App.navCaretMarkup(attrNodeExpanded)}</button>
          <span class="nav-tree-label">${App.escapeHtml(App.attractionLabelShort(attr))}</span>
        </div>`;

        if (attrNodeExpanded || q) {
          html += `<div class="nav-tree-children">`;
          html += `<div class="nav-tree-row nav-tree-row--depth-4" data-nav-kind="attraction" data-city-id="${App.escapeHtml(cityId)}" data-attraction-id="${App.escapeHtml(attrId)}" data-focus-section="" role="button" tabindex="0">
            <span class="nav-tree-spacer"></span><span class="nav-tree-label">解说与详情</span>
          </div>`;

          const subKey = `city:${cityId}:attr:${attrId}:sub`;
          const subExpanded = App.isTreeExpanded(subKey, false);
          let subAreas = [];
          if (subExpanded || (q && attrHay.includes(q))) {
            try {
              subAreas = await App.loadSubAreasForAttraction(attrId);
            } catch {
              subAreas = [];
            }
          }
          html += `<div class="nav-tree-row nav-tree-row--depth-4" data-nav-kind="sub_folder" data-city-id="${App.escapeHtml(cityId)}" data-attraction-id="${App.escapeHtml(attrId)}" role="button" tabindex="0">
            <button type="button" class="nav-tree-toggle" data-toggle-key="${App.escapeHtml(subKey)}" aria-expanded="${subExpanded}" aria-label="展开或收起">${App.navCaretMarkup(subExpanded)}</button>
            <span class="nav-tree-label">子区域 (${subAreas.length})</span>
          </div>`;
          if (subExpanded || q) {
            html += `<div class="nav-tree-children">`;
            for (const sa of subAreas) {
              const saLabel = sa.name_zh || sa.name_en || sa.id;
              if (q && !saLabel.toLowerCase().includes(q) && !attrHay.includes(q) && !cityHay.includes(q)) continue;
              html += `<div class="nav-tree-row nav-tree-row--depth-5" data-nav-kind="sub_area" data-city-id="${App.escapeHtml(cityId)}" data-attraction-id="${App.escapeHtml(attrId)}" data-sub-area-id="${App.escapeHtml(sa.id)}" role="button" tabindex="0">
                <span class="nav-tree-spacer"></span><span class="nav-tree-label">${App.escapeHtml(saLabel)}</span>
              </div>`;
            }
            html += `</div>`;
          }

          const audioKey = `city:${cityId}:attr:${attrId}:audio`;
          const audioExpanded = App.isTreeExpanded(audioKey, false);
          let guides = [];
          if (audioExpanded || (q && attrHay.includes(q))) {
            try {
              guides = await App.loadAudioGuidesForAttraction(attrId);
            } catch {
              guides = [];
            }
          }
          html += `<div class="nav-tree-row nav-tree-row--depth-4" data-nav-kind="audio_folder" data-city-id="${App.escapeHtml(cityId)}" data-attraction-id="${App.escapeHtml(attrId)}" role="button" tabindex="0">
            <button type="button" class="nav-tree-toggle" data-toggle-key="${App.escapeHtml(audioKey)}" aria-expanded="${audioExpanded}" aria-label="展开或收起">${App.navCaretMarkup(audioExpanded)}</button>
            <span class="nav-tree-label">语音导览 (${guides.length})</span>
          </div>`;
          if (audioExpanded || q) {
            html += `<div class="nav-tree-children">`;
            for (const g of guides) {
              const gLabel = g.title_en || g.id;
              if (q && !gLabel.toLowerCase().includes(q) && !attrHay.includes(q) && !cityHay.includes(q)) continue;
              html += `<div class="nav-tree-row nav-tree-row--depth-5" data-nav-kind="audio_guide" data-city-id="${App.escapeHtml(cityId)}" data-attraction-id="${App.escapeHtml(attrId)}" data-audio-id="${App.escapeHtml(g.id)}" role="button" tabindex="0">
                <span class="nav-tree-spacer"></span><span class="nav-tree-label">${App.escapeHtml(gLabel)}</span>
              </div>`;
            }
            html += `</div>`;
          }
          html += `</div>`;
        }
      }
      html += `<div class="nav-tree-row nav-tree-row--depth-3 nav-tree-row--action" data-nav-kind="new_attraction" data-city-id="${App.escapeHtml(cityId)}" role="button" tabindex="0">
        <span class="nav-tree-spacer"></span><span class="nav-tree-label muted">+ 新建景点</span>
      </div>`;
      html += `</div>`;
    }
    html += `</div></div>`;
    const visible = !q || cityHay.includes(q) || filteredAttrs.length > 0;
    return { html, visible };
  };

  App.renderSidebar = async function renderSidebar() {
    const host = App.$("#sidebar-nav");
    if (!host) return;

    const filterInput = App.$("#nav-filter");
    const filterQ = (filterInput?.value || App.getNavFilter() || "").trim();
    if (filterInput && !filterInput.value && filterQ) filterInput.value = filterQ;
    const citiesRootExpanded = App.isTreeExpanded("cities_root", true);

    let globalHtml = "";
    for (const group of App.GLOBAL_NAV_GROUPS) {
      const expanded = App.isNavGroupExpanded(group.id, group.defaultExpanded);
      globalHtml += `<section class="nav-group ${expanded ? "" : "nav-group--collapsed"}" data-group-id="${App.escapeHtml(group.id)}">
        <button type="button" class="nav-group-toggle" aria-expanded="${expanded}">${App.navCaretMarkup(expanded)}<span class="nav-group-label">${App.escapeHtml(group.label)}</span></button>
        <div class="nav-group-items">`;
      for (const item of group.items) {
        if (item.kind === "view") {
          globalHtml += `<button type="button" class="nav-btn" data-nav-view="${App.escapeHtml(item.view)}">${App.escapeHtml(item.label)}</button>`;
        } else if (item.kind === "city_list") {
          globalHtml += `<button type="button" class="nav-btn nav-btn--primary" data-nav-city-list="1">${App.escapeHtml(item.label)}</button>`;
        } else {
          globalHtml += `<button type="button" class="nav-btn" data-nav-table="${App.escapeHtml(item.table)}">${App.escapeHtml(item.label)}</button>`;
        }
      }
      globalHtml += `</div></section>`;
    }

    let citiesHtml = `<section class="nav-group nav-group--cities ${citiesRootExpanded ? "" : "nav-group--collapsed"}" data-group-id="cities">
      <button type="button" class="nav-group-toggle nav-group-toggle--cities" data-toggle-key="cities_root" aria-expanded="${citiesRootExpanded}">${App.navCaretMarkup(citiesRootExpanded)}<span class="nav-group-label">城市</span></button>
      <div class="nav-group-items nav-tree-wrap">
        <div class="nav-tree-row nav-tree-row--depth-0 nav-tree-row--action" data-nav-kind="new_city" role="button" tabindex="0">
          <span class="nav-tree-label">+ 新建城市</span>
        </div>
        <div id="city-tree-host" class="${citiesRootExpanded ? "" : "hidden"}">`;

    if (citiesRootExpanded || filterQ) {
      const cities = App.refCache.cities?.length ? App.refCache.cities : [];
      const branches = await Promise.all(cities.map((c) => App.renderCityTreeBranch(c, filterQ)));
      let anyVisible = false;
      branches.forEach((b) => {
        if (b.visible) {
          anyVisible = true;
          citiesHtml += b.html;
        }
      });
      if (filterQ && !anyVisible) {
        citiesHtml += `<p class="nav-tree-empty muted">无匹配城市或景点</p>`;
      }
    }

    citiesHtml += `</div></div></section>`;

    host.innerHTML = globalHtml + citiesHtml;
    App.highlightNavSelection();
    App.updateNavCarets();
  };

  App.updateNavCarets = function updateNavCarets() {
    App.$$(".nav-tree-toggle[data-toggle-key]").forEach((btn) => {
      const key = btn.dataset.toggleKey;
      if (!key) return;
      const open = App.isTreeExpanded(key, btn.getAttribute("aria-expanded") === "true");
      btn.setAttribute("aria-expanded", open);
      btn.classList.toggle("is-open", open);
      const caret = btn.querySelector(".nav-caret");
      if (caret) {
        caret.classList.toggle("nav-caret--expanded", open);
        caret.classList.toggle("nav-caret--collapsed", !open);
      }
    });

    App.$$(".nav-group-toggle").forEach((btn) => {
      const open = btn.getAttribute("aria-expanded") === "true";
      const caret = btn.querySelector(".nav-caret");
      if (caret) {
        caret.classList.toggle("nav-caret--expanded", open);
        caret.classList.toggle("nav-caret--collapsed", !open);
      }
    });
  };

  App.handleNavTreeClick = async function handleNavTreeClick(e) {
    const toggle = e.target.closest(".nav-tree-toggle");
    if (toggle?.dataset.toggleKey) {
      e.stopPropagation();
      const key = toggle.dataset.toggleKey;
      const next = !App.isTreeExpanded(key, false);
      App.setTreeExpanded(key, next);
      if (key.startsWith("city:") && !key.includes(":attr") && next) {
        /* city expand — no navigation */
      }
      await App.renderSidebar();
      return;
    }

    const groupToggle = e.target.closest(".nav-group-toggle");
    if (groupToggle && !groupToggle.dataset.toggleKey) {
      const section = groupToggle.closest(".nav-group");
      const gid = section?.dataset.groupId;
      if (gid) {
        const collapsed = section.classList.contains("nav-group--collapsed");
        App.setNavGroupExpanded(gid, collapsed);
        section.classList.toggle("nav-group--collapsed");
        groupToggle.setAttribute("aria-expanded", collapsed);
        App.updateNavCarets();
      }
      return;
    }

    if (groupToggle?.dataset.toggleKey === "cities_root") {
      e.stopPropagation();
      const next = !App.isTreeExpanded("cities_root", true);
      App.setTreeExpanded("cities_root", next);
      await App.renderSidebar();
      return;
    }

    const row = e.target.closest(".nav-tree-row");
    if (!row) return;

    const kind = row.dataset.navKind;
    const cityId = row.dataset.cityId;

    if (kind === "city_list") {
      await App.navigateTo({ kind: "city_list" });
      return;
    }
    if (kind === "new_city") {
      App.openModal(null, "cities", {
        onSaved: async () => {
          await App.loadRefCache(true);
          App.invalidateCityTreeCache?.();
          await App.renderSidebar();
          if (App.currentView === "city_hub") await App.renderCityHubList();
        },
      });
      return;
    }
    if (kind === "new_attraction" && cityId) {
      await App.navigateTo({ kind: "attraction", cityId, attractionId: null });
      return;
    }
    if (kind === "city" && cityId) {
      App.setTreeExpanded(`city:${cityId}`, true);
      await App.navigateTo({ kind: "city_panel", cityId, panel: "overview" });
      return;
    }
    if (kind === "city_panel" && cityId) {
      await App.navigateTo({ kind: "city_panel", cityId, panel: row.dataset.panel });
      return;
    }
    if (kind === "attr_folder" && cityId) {
      const key = `city:${cityId}:attractions`;
      App.setTreeExpanded(key, !App.isTreeExpanded(key, false));
      await App.renderSidebar();
      return;
    }
    if (kind === "attraction" && cityId && row.dataset.attractionId) {
      const focus = row.dataset.focusSection;
      await App.navigateTo({
        kind: "attraction",
        cityId,
        attractionId: row.dataset.attractionId,
        focusSection: focus || null,
        focusId: null,
      });
      return;
    }
    if (kind === "sub_folder" && cityId && row.dataset.attractionId) {
      const key = `city:${cityId}:attr:${row.dataset.attractionId}:sub`;
      App.setTreeExpanded(key, !App.isTreeExpanded(key, false));
      await App.renderSidebar();
      return;
    }
    if (kind === "sub_area" && cityId && row.dataset.attractionId) {
      await App.navigateTo({
        kind: "attraction",
        cityId,
        attractionId: row.dataset.attractionId,
        focusSection: "sub_areas",
        focusId: row.dataset.subAreaId,
      });
      return;
    }
    if (kind === "audio_folder" && cityId && row.dataset.attractionId) {
      const key = `city:${cityId}:attr:${row.dataset.attractionId}:audio`;
      App.setTreeExpanded(key, !App.isTreeExpanded(key, false));
      await App.renderSidebar();
      return;
    }
    if (kind === "audio_guide" && cityId && row.dataset.attractionId) {
      await App.navigateTo({
        kind: "attraction",
        cityId,
        attractionId: row.dataset.attractionId,
        focusSection: "audio",
        focusId: row.dataset.audioId,
      });
    }
  };

  App.bindSidebarEvents = function bindSidebarEvents() {
    if (App._sidebarBound) return;
    App._sidebarBound = true;

    const nav = App.$("#sidebar-nav");
    nav?.addEventListener("click", (e) => App.handleNavTreeClick(e));

    nav?.addEventListener("keydown", (e) => {
      if (e.key !== "Enter" && e.key !== " ") return;
      const row = e.target.closest(".nav-tree-row");
      if (row) {
        e.preventDefault();
        row.click();
      }
    });

    nav?.addEventListener("click", (e) => {
      const btn = e.target.closest(".nav-btn[data-nav-view], .nav-btn[data-nav-table], .nav-btn[data-nav-city-list]");
      if (!btn) return;
      if (btn.dataset.navCityList) {
        App.navigateTo({ kind: "city_list" });
      } else if (btn.dataset.navView) {
        App.navigateTo({ kind: "view", view: btn.dataset.navView });
      } else if (btn.dataset.navTable) {
        App.navigateTo({ kind: "table", table: btn.dataset.navTable });
      }
    });

    App.$("#nav-filter")?.addEventListener("input", (e) => {
      App.setNavFilter(e.target.value);
      App.renderSidebar();
    });

    App.$("#theme-toggle")?.addEventListener("click", () => App.cycleTheme());
  };

  App.restoreLastRoute = function restoreLastRoute() {
    const last = App.getLastRoute();
    if (last && last.kind) return last;
    return { kind: "city_list" };
  };
})();
