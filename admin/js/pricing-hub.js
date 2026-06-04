/* YOLO Admin — Attraction & sub-area pricing / paywall config (batch friendly) */

(function () {
  const App = window.ChinaGoAdmin;

  App.pricingState = App.pricingState || { cityId: "", tiers: [], selected: new Set() };

  App.renderPricingHub = async function renderPricingHub() {
    App.currentView = "pricing_hub";
    App.currentTable = null;
    App.$("#page-title").textContent = "景点定价";
    App.$("#add-row-btn").classList.add("hidden");

    const main = App.$("#main-content");
    main.innerHTML = `
      <div class="status-bar info">
        默认全部免费。把需要收费的景点/子景点勾选「付费」并选价格档。
        买父景点会自动解锁其全部子景点；子景点也可单独购买。
        价格档在「会员计划」里管理（类型=单次购买）。
      </div>
      <div class="hub-toolbar" style="flex-wrap:wrap;gap:10px">
        <select id="pr-city" class="search-input" style="max-width:220px"></select>
        <input type="search" id="pr-search" class="search-input" placeholder="搜索名称…" style="max-width:200px" />
        <span class="toolbar-spacer"></span>
        <span class="muted" id="pr-selcount">已选 0</span>
        <select id="pr-batch-tier" class="search-input" style="max-width:160px">
          <option value="">批量设价格档…</option>
        </select>
        <button type="button" class="btn btn-sm" id="pr-batch-paid">批量设为付费</button>
        <button type="button" class="btn btn-sm btn-secondary" id="pr-batch-free">批量设为免费</button>
        <button type="button" class="btn btn-sm btn-secondary" id="pr-refresh">刷新</button>
      </div>
      <div id="pr-host"></div>`;

    // Load price tiers (one_time_attraction plans)
    const { data: tiers } = await App.client
      .from("membership_plans")
      .select("id,name_zh,name_en,price_label,is_active")
      .eq("plan_type", "one_time_attraction")
      .order("display_order");
    App.pricingState.tiers = tiers || [];

    // City selector
    await App.loadRefCache();
    const cities = App.refCache.cities || [];
    const citySel = App.$("#pr-city");
    citySel.innerHTML = `<option value="">全部城市</option>` +
      cities.map((c) => `<option value="${App.escapeHtml(c.id)}">${App.escapeHtml(c.chinese_name || c.name || c.id)}</option>`).join("");
    citySel.value = App.pricingState.cityId || "";

    // Batch tier options
    const batchTier = App.$("#pr-batch-tier");
    batchTier.innerHTML = `<option value="">批量设价格档…</option>` +
      App.pricingState.tiers.map((t) =>
        `<option value="${App.escapeHtml(t.id)}">${App.escapeHtml(t.name_zh || t.name_en)} · ${App.escapeHtml(t.price_label)}</option>`
      ).join("");

    citySel.addEventListener("change", () => { App.pricingState.cityId = citySel.value; App.pricingState.selected.clear(); App.renderPricingRows(); });
    App.$("#pr-search").addEventListener("input", () => App.renderPricingRows());
    App.$("#pr-refresh").addEventListener("click", () => App.renderPricingHub());
    App.$("#pr-batch-paid").addEventListener("click", () => App.applyBatch({ requires_purchase: true, price_tier_id: batchTier.value || null }));
    App.$("#pr-batch-free").addEventListener("click", () => App.applyBatch({ requires_purchase: false }));
    batchTier.addEventListener("change", () => {
      if (batchTier.value) App.applyBatch({ requires_purchase: true, price_tier_id: batchTier.value });
    });

    await App.renderPricingRows();
  };

  App.renderPricingRows = async function renderPricingRows() {
    const host = App.$("#pr-host");
    host.innerHTML = `<p class="muted">加载中…</p>`;
    const cityId = App.pricingState.cityId;
    const q = (App.$("#pr-search")?.value || "").trim().toLowerCase();

    try {
      // Attractions in scope
      let aQuery = App.client.from("attractions").select("id,name,chinese_name,city_id,requires_purchase,price_tier_id").order("display_order");
      if (cityId) aQuery = aQuery.eq("city_id", cityId);
      const { data: attractions, error: aErr } = await aQuery;
      if (aErr) throw aErr;

      const attrIds = (attractions || []).map((a) => a.id);
      let subs = [];
      if (attrIds.length) {
        const { data: subRows } = await App.client
          .from("sub_areas")
          .select("id,name_en,name_zh,attraction_id,requires_purchase,price_tier_id")
          .in("attraction_id", attrIds)
          .order("sort_order");
        subs = subRows || [];
      }
      const subsByAttr = {};
      subs.forEach((s) => { (subsByAttr[s.attraction_id] = subsByAttr[s.attraction_id] || []).push(s); });

      const tierLabel = (id) => {
        const t = App.pricingState.tiers.find((x) => x.id === id);
        return t ? `${t.name_zh || t.name_en} · ${t.price_label}` : "默认档";
      };
      const tierOptions = (sel) =>
        `<option value="">默认档</option>` +
        App.pricingState.tiers.map((t) =>
          `<option value="${App.escapeHtml(t.id)}" ${sel === t.id ? "selected" : ""}>${App.escapeHtml(t.name_zh || t.name_en)} · ${App.escapeHtml(t.price_label)}</option>`
        ).join("");

      const matches = (name) => !q || name.toLowerCase().includes(q);

      let rows = "";
      (attractions || []).forEach((a) => {
        const aName = a.chinese_name || a.name || a.id;
        const childSubs = (subsByAttr[a.id] || []);
        if (!matches(aName) && !childSubs.some((s) => matches(s.name_zh || s.name_en || ""))) return;

        rows += pricingRowHtml({
          kind: "attraction", id: a.id, name: aName, indent: 0,
          requires: a.requires_purchase, tierId: a.price_tier_id, tierOptions, tierLabel,
        });
        childSubs.forEach((s) => {
          rows += pricingRowHtml({
            kind: "sub_areas", id: s.id, name: s.name_zh || s.name_en || s.id, indent: 1,
            requires: s.requires_purchase, tierId: s.price_tier_id, tierOptions, tierLabel,
          });
        });
      });

      host.innerHTML = `<table class="data-table"><thead><tr>
        <th style="width:32px"></th><th>名称</th><th style="width:90px">付费</th>
        <th style="width:220px">价格档</th>
      </tr></thead><tbody>${rows || `<tr><td colspan="4" class="muted">无景点</td></tr>`}</tbody></table>`;

      // Wire per-row controls
      host.querySelectorAll("[data-pay-toggle]").forEach((el) => {
        el.addEventListener("change", () => {
          App.savePricingRow(el.dataset.kind, el.dataset.id, { requires_purchase: el.checked });
        });
      });
      host.querySelectorAll("[data-tier-select]").forEach((el) => {
        el.addEventListener("change", () => {
          App.savePricingRow(el.dataset.kind, el.dataset.id, { price_tier_id: el.value || null });
        });
      });
      host.querySelectorAll("[data-sel]").forEach((el) => {
        el.checked = App.pricingState.selected.has(`${el.dataset.kind}:${el.dataset.id}`);
        el.addEventListener("change", () => {
          const key = `${el.dataset.kind}:${el.dataset.id}`;
          if (el.checked) App.pricingState.selected.add(key); else App.pricingState.selected.delete(key);
          App.$("#pr-selcount").textContent = `已选 ${App.pricingState.selected.size}`;
        });
      });
      App.$("#pr-selcount").textContent = `已选 ${App.pricingState.selected.size}`;
    } catch (ex) {
      host.innerHTML = `<div class="status-bar error">${App.escapeHtml(ex.message)}</div>`;
    }
  };

  function pricingRowHtml({ kind, id, name, indent, requires, tierId, tierOptions, tierLabel }) {
    const subTag = indent ? `<span class="pr-sub-label">子景点</span>` : "";
    return `<tr>
      <td style="text-align:center"><input type="checkbox" data-sel data-kind="${kind}" data-id="${App.escapeHtml(id)}"></td>
      <td class="pr-name${indent ? " indent" : ""}">${subTag}${App.escapeHtml(name)} <code>${App.escapeHtml(id)}</code></td>
      <td><label class="switch-sm"><input type="checkbox" data-pay-toggle data-kind="${kind}" data-id="${App.escapeHtml(id)}" ${requires ? "checked" : ""}> 付费</label></td>
      <td>
        <select data-tier-select data-kind="${kind}" data-id="${App.escapeHtml(id)}" class="search-input" ${requires ? "" : "disabled"}>
          ${tierOptions(tierId)}
        </select>
      </td>
    </tr>`;
  }

  App.savePricingRow = async function savePricingRow(kind, id, patch) {
    try {
      const table = kind === "attraction" ? "attractions" : "sub_areas";
      const { error } = await App.client.from(table).update(patch).eq("id", id);
      if (error) throw error;
      App.showToast("已保存");
      // If toggling paid off/on, re-render to enable/disable the tier select
      if ("requires_purchase" in patch) App.renderPricingRows();
    } catch (ex) {
      App.showToast(ex.message, "error");
    }
  };

  App.applyBatch = async function applyBatch(patch) {
    const sel = [...App.pricingState.selected];
    if (!sel.length) { App.showToast("请先勾选要批量操作的行", "error"); return; }
    const attrIds = sel.filter((s) => s.startsWith("attraction:")).map((s) => s.split(":")[1]);
    const subIds = sel.filter((s) => s.startsWith("sub_areas:")).map((s) => s.split(":")[1]);
    try {
      if (attrIds.length) {
        const { error } = await App.client.from("attractions").update(patch).in("id", attrIds);
        if (error) throw error;
      }
      if (subIds.length) {
        const { error } = await App.client.from("sub_areas").update(patch).in("id", subIds);
        if (error) throw error;
      }
      App.showToast(`已批量更新 ${sel.length} 项`);
      App.pricingState.selected.clear();
      App.renderPricingRows();
    } catch (ex) {
      App.showToast(ex.message, "error");
    }
  };
})();
