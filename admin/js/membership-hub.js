/* YOLO Admin — Membership plans, transactions, refund requests */

(function () {
  const App = window.ChinaGoAdmin;

  // ─── Membership Plans Hub ─────────────────────────────────────────────────

  App.renderMembershipHub = async function renderMembershipHub() {
    App.currentView = "membership_hub";
    App.currentTable = null;
    App.$("#page-title").textContent = "会员计划";
    App.$("#add-row-btn").classList.add("hidden");

    const main = App.$("#main-content");
    main.innerHTML = `
      <div class="hub-toolbar">
        <button type="button" class="btn" id="mh-add-btn">+ 新建计划</button>
        <button type="button" class="btn btn-secondary btn-sm" id="mh-refresh">刷新</button>
      </div>
      <div id="mh-status" class="status-bar hidden"></div>
      <table class="data-table" id="mh-table">
        <thead>
          <tr>
            <th>ID</th><th>名称</th><th>类型</th>
            <th>Apple Product ID</th><th>RC Package ID</th>
            <th>价格文案</th><th>时效（天）</th><th>试用</th>
            <th>内容权益</th><th>最优惠</th><th>激活</th><th>操作</th>
          </tr>
        </thead>
        <tbody id="mh-tbody"><tr><td colspan="12" class="muted">加载中…</td></tr></tbody>
      </table>`;

    App.$("#mh-add-btn")?.addEventListener("click", () => App.openPlanEditor(null));
    App.$("#mh-refresh")?.addEventListener("click", () => App.refreshPlansTable());
    await App.refreshPlansTable();
  };

  App.refreshPlansTable = async function refreshPlansTable() {
    const tbody = App.$("#mh-tbody");
    if (!tbody) return;
    tbody.innerHTML = `<tr><td colspan="12" class="muted">加载中…</td></tr>`;
    try {
      const { data: plans, error } = await App.client
        .from("membership_plans")
        .select("*")
        .order("display_order", { ascending: true });
      if (error) throw error;

      if (!plans?.length) {
        tbody.innerHTML = `<tr><td colspan="12" class="muted">暂无计划</td></tr>`;
        return;
      }

      const flagIcons = {
        audio_guides: "🎧",
        text_content: "📄",
        offline_download: "⬇",
        visitor_tips: "💡",
        ai_advanced: "🤖",
      };

      tbody.innerHTML = plans.map((p) => {
        const flags = p.access_flags || {};
        const flagBadges = Object.entries(flagIcons)
          .filter(([k]) => flags[k])
          .map(([, icon]) => `<span title="${icon}" style="font-size:14px">${icon}</span>`)
          .join(" ");

        return `<tr>
          <td><code>${App.escapeHtml(p.id)}</code></td>
          <td>
            <div>${App.escapeHtml(p.name_zh || p.name_en)}</div>
            ${p.name_zh ? `<div class="muted" style="font-size:11px">${App.escapeHtml(p.name_en)}</div>` : ""}
          </td>
          <td><span class="badge ${p.plan_type === "subscription" ? "badge-blue" : "badge-gray"}">
            ${p.plan_type === "subscription" ? "订阅" : "单次"}
          </span></td>
          <td><code style="font-size:11px">${App.escapeHtml(p.apple_product_id)}</code></td>
          <td><code style="font-size:11px">${App.escapeHtml(p.rc_package_id || "—")}</code></td>
          <td>${App.escapeHtml(p.price_label)}</td>
          <td>${p.duration_days ?? "永久"}</td>
          <td>${p.free_trial_days ? `<span class="badge badge-green">${p.free_trial_days}天</span>` : "—"}</td>
          <td>${flagBadges || "<span class='muted'>无</span>"}</td>
          <td>${p.is_best_value ? "★" : ""}</td>
          <td><span class="badge ${p.is_active ? "badge-green" : "badge-gray"}">${p.is_active ? "激活" : "停用"}</span></td>
          <td>
            <button type="button" class="btn btn-sm btn-secondary" data-edit-plan="${App.escapeHtml(p.id)}">编辑</button>
            <button type="button" class="btn btn-sm btn-danger" data-delete-plan="${App.escapeHtml(p.id)}">删除</button>
          </td>
        </tr>`;
      }).join("");

      tbody.querySelectorAll("[data-edit-plan]").forEach((btn) => {
        btn.addEventListener("click", () => App.openPlanEditor(btn.dataset.editPlan));
      });
      tbody.querySelectorAll("[data-delete-plan]").forEach((btn) => {
        btn.addEventListener("click", () => App.confirmDeletePlan(btn.dataset.deletePlan));
      });
    } catch (ex) {
      tbody.innerHTML = `<tr><td colspan="12" class="status-bar error">${App.escapeHtml(ex.message)}</td></tr>`;
    }
  };

  App.openPlanEditor = async function openPlanEditor(planId) {
    let plan = {
      id: "", rc_package_id: "", apple_product_id: "", name_en: "", name_zh: "",
      price_label: "", duration_days: null, free_trial_days: 0, plan_type: "subscription",
      access_flags: { audio_guides: false, text_content: false, offline_download: false, visitor_tips: false, ai_advanced: false },
      feature_lines: [], is_best_value: false, display_order: 0, is_active: true,
    };

    if (planId) {
      const { data } = await App.client.from("membership_plans").select("*").eq("id", planId).single();
      if (data) plan = data;
    }

    function flagToggle(id, label, checked) {
      return `<label style="display:flex;align-items:center;gap:6px;padding:4px 0">
        <input type="checkbox" id="${id}" ${checked ? "checked" : ""}> ${label}
      </label>`;
    }
    function featureLine(idx, val) {
      return `<div style="display:flex;gap:6px;margin-bottom:4px">
        <input class="mh-feature-input" style="flex:1" value="${App.escapeHtml(val)}" placeholder="权益描述文字">
        <button type="button" class="btn btn-sm btn-danger" onclick="this.parentElement.remove()">×</button>
      </div>`;
    }

    const modal = document.createElement("div");
    modal.className = "modal-overlay";
    modal.innerHTML = `
      <div class="modal-card" style="max-width:600px;width:100%;max-height:90vh;overflow-y:auto">
        <h3>${planId ? "编辑" : "新建"}会员计划</h3>

        <div class="form-grid" style="display:grid;grid-template-columns:1fr 1fr;gap:12px">
          <label>ID <small>（创建后不可改）</small>
            <input id="mh-id" value="${App.escapeHtml(plan.id)}" ${planId ? "disabled" : ""} placeholder="annual / quarterly / monthly">
          </label>
          <label>类型
            <select id="mh-type">
              <option value="subscription" ${plan.plan_type === "subscription" ? "selected" : ""}>订阅</option>
              <option value="one_time_attraction" ${plan.plan_type === "one_time_attraction" ? "selected" : ""}>单次购买</option>
            </select>
          </label>
          <label>英文名称 *
            <input id="mh-name-en" value="${App.escapeHtml(plan.name_en)}" required>
          </label>
          <label>中文名称
            <input id="mh-name-zh" value="${App.escapeHtml(plan.name_zh || "")}">
          </label>
          <label>Apple Product ID *
            <input id="mh-apple-id" value="${App.escapeHtml(plan.apple_product_id)}" required>
          </label>
          <label>RevenueCat Package ID
            <input id="mh-rc-id" value="${App.escapeHtml(plan.rc_package_id || "")}" placeholder="\$rc_annual">
          </label>
          <label>价格展示文案
            <input id="mh-price" value="${App.escapeHtml(plan.price_label)}" placeholder="$19.99/year">
          </label>
          <label>有效天数 <small>（空 = 永久）</small>
            <input id="mh-days" type="number" value="${plan.duration_days || ""}" placeholder="365">
          </label>
          <label>免费试用天数 <small>（0 = 无试用）</small>
            <input id="mh-trial" type="number" value="${plan.free_trial_days || 0}" placeholder="7">
          </label>
          <label>排序 <small>（数字越小越靠前）</small>
            <input id="mh-order" type="number" value="${plan.display_order}">
          </label>
        </div>

        <h4 style="margin:16px 0 8px">内容权益 (access_flags)</h4>
        <div style="display:grid;grid-template-columns:1fr 1fr;background:var(--bg-subtle);padding:12px;border-radius:4px">
          ${flagToggle("mh-audio", "🎧 音频导览（解锁全部景点音频）", plan.access_flags?.audio_guides)}
          ${flagToggle("mh-text", "📄 文字内容（解锁景点完整介绍）", plan.access_flags?.text_content)}
          ${flagToggle("mh-offline", "⬇ 离线下载（允许下载音频）", plan.access_flags?.offline_download)}
          ${flagToggle("mh-tips", "💡 访客贴士（解锁全部贴士）", plan.access_flags?.visitor_tips)}
          ${flagToggle("mh-ai", "🤖 AI 高级模式", plan.access_flags?.ai_advanced)}
        </div>

        <h4 style="margin:16px 0 8px">权益描述（展示给用户）</h4>
        <div id="mh-features-list">
          ${(plan.feature_lines || []).map((l, i) => featureLine(i, l)).join("")}
        </div>
        <button type="button" class="btn btn-sm btn-secondary" id="mh-add-feature">+ 添加权益描述</button>

        <div style="display:flex;gap:16px;margin-top:16px">
          <label><input type="checkbox" id="mh-best-value" ${plan.is_best_value ? "checked" : ""}> 标注为「最优惠」★</label>
          <label><input type="checkbox" id="mh-active" ${plan.is_active ? "checked" : ""}> 激活（App 中展示）</label>
        </div>

        <div id="mh-edit-error" class="status-bar error hidden" style="margin-top:12px"></div>
        <div class="modal-actions" style="margin-top:16px">
          <button type="button" class="btn btn-secondary" id="mh-cancel">取消</button>
          <button type="button" class="btn" id="mh-save">保存</button>
        </div>
      </div>`;
    document.body.appendChild(modal);

    let featureCount = (plan.feature_lines || []).length;
    modal.querySelector("#mh-add-feature")?.addEventListener("click", () => {
      const list = modal.querySelector("#mh-features-list");
      const div = document.createElement("div");
      div.style.cssText = "display:flex;gap:6px;margin-bottom:4px";
      div.innerHTML = `<input class="mh-feature-input" style="flex:1" placeholder="权益描述文字">
        <button type="button" class="btn btn-sm btn-danger" onclick="this.parentElement.remove()">×</button>`;
      list.appendChild(div);
      featureCount++;
    });

    modal.querySelector("#mh-cancel")?.addEventListener("click", () => modal.remove());

    modal.querySelector("#mh-save")?.addEventListener("click", async () => {
      const errEl = modal.querySelector("#mh-edit-error");
      errEl.classList.add("hidden");
      try {
        const features = [...modal.querySelectorAll(".mh-feature-input")]
          .map((el) => el.value.trim())
          .filter(Boolean);

        const updated = {
          id: modal.querySelector("#mh-id").value.trim(),
          rc_package_id: modal.querySelector("#mh-rc-id").value.trim() || null,
          apple_product_id: modal.querySelector("#mh-apple-id").value.trim(),
          name_en: modal.querySelector("#mh-name-en").value.trim(),
          name_zh: modal.querySelector("#mh-name-zh").value.trim() || null,
          price_label: modal.querySelector("#mh-price").value.trim(),
          duration_days: parseInt(modal.querySelector("#mh-days").value) || null,
          free_trial_days: parseInt(modal.querySelector("#mh-trial").value) || 0,
          plan_type: modal.querySelector("#mh-type").value,
          display_order: parseInt(modal.querySelector("#mh-order").value) || 0,
          access_flags: {
            audio_guides: modal.querySelector("#mh-audio").checked,
            text_content: modal.querySelector("#mh-text").checked,
            offline_download: modal.querySelector("#mh-offline").checked,
            visitor_tips: modal.querySelector("#mh-tips").checked,
            ai_advanced: modal.querySelector("#mh-ai").checked,
          },
          feature_lines: features,
          is_best_value: modal.querySelector("#mh-best-value").checked,
          is_active: modal.querySelector("#mh-active").checked,
        };

        if (!updated.id) throw new Error("请填写计划 ID");
        if (!updated.apple_product_id) throw new Error("请填写 Apple Product ID");
        if (!updated.name_en) throw new Error("请填写英文名称");

        const { error } = await App.client
          .from("membership_plans")
          .upsert(updated, { onConflict: "id" });
        if (error) throw error;

        modal.remove();
        App.showToast("会员计划已保存");
        await App.refreshPlansTable();
      } catch (ex) {
        errEl.textContent = ex.message;
        errEl.classList.remove("hidden");
      }
    });
  };

  App.confirmDeletePlan = async function confirmDeletePlan(id) {
    if (!confirm(`确认删除计划「${id}」？此操作不可恢复。`)) return;
    try {
      const { error } = await App.client.from("membership_plans").delete().eq("id", id);
      if (error) throw error;
      App.showToast("计划已删除");
      await App.refreshPlansTable();
    } catch (ex) {
      App.showToast(ex.message, "error");
    }
  };

  // ─── Transactions Hub ─────────────────────────────────────────────────────

  App.renderTransactionsHub = async function renderTransactionsHub() {
    App.currentView = "transactions_hub";
    App.currentTable = null;
    App.$("#page-title").textContent = "购买记录";
    App.$("#add-row-btn").classList.add("hidden");

    const main = App.$("#main-content");
    main.innerHTML = `
      <div class="hub-toolbar">
        <input type="search" id="tx-search" class="search-input" placeholder="搜索邮箱、商品 ID…" style="max-width:240px" />
        <select id="tx-filter" class="search-input">
          <option value="">全部事件</option>
          <option value="INITIAL_PURCHASE">首次购买</option>
          <option value="RENEWAL">续费</option>
          <option value="REFUND">退款</option>
          <option value="EXPIRATION">到期</option>
          <option value="NON_RENEWING_PURCHASE">单次购买</option>
        </select>
        <button type="button" class="btn btn-secondary btn-sm" id="tx-refresh">刷新</button>
        <span id="tx-count" class="muted" style="margin-left:8px"></span>
      </div>
      <div id="tx-host"></div>

      <section class="editor-section" style="margin-top:32px">
        <h3>退款申请 <span class="muted" id="refund-pending-count"></span></h3>
        <div id="refund-host"></div>
      </section>`;

    const loadTx = async () => {
      const host = App.$("#tx-host");
      host.innerHTML = `<p class="muted">加载中…</p>`;
      try {
        const { data, error } = await App.client
          .from("user_iap_transactions")
          .select("*, profiles(email,display_name)")
          .order("purchased_at", { ascending: false })
          .limit(500);
        if (error) throw error;

        const q = (App.$("#tx-search")?.value || "").trim().toLowerCase();
        const filter = App.$("#tx-filter")?.value || "";

        let rows = data || [];
        if (q) {
          rows = rows.filter((r) => {
            const blob = [r.profiles?.email, r.profiles?.display_name, r.product_id, r.plan_id]
              .filter(Boolean).join(" ").toLowerCase();
            return blob.includes(q);
          });
        }
        if (filter) rows = rows.filter((r) => r.event_type === filter);

        App.$("#tx-count").textContent = `共 ${rows.length} 条`;

        const eventLabels = {
          INITIAL_PURCHASE: "首次购买", RENEWAL: "续费", REFUND: "退款",
          CANCELLATION: "取消", EXPIRATION: "到期", NON_RENEWING_PURCHASE: "单次购买",
        };
        const badgeClass = {
          INITIAL_PURCHASE: "badge-green", RENEWAL: "badge-blue",
          REFUND: "badge-red", CANCELLATION: "badge-gray",
          EXPIRATION: "badge-gray", NON_RENEWING_PURCHASE: "badge-blue",
        };

        if (!rows.length) {
          host.innerHTML = `<p class="muted">无匹配记录</p>`;
          return;
        }

        host.innerHTML = `<table class="data-table">
          <thead><tr>
            <th>时间</th><th>用户</th><th>事件</th>
            <th>商品 ID</th><th>计划</th><th>金额 (USD)</th><th>到期</th>
          </tr></thead>
          <tbody>${rows.map((r) => `
            <tr>
              <td style="white-space:nowrap">${new Date(r.purchased_at).toLocaleString("zh-CN")}</td>
              <td>
                <div>${App.escapeHtml(r.profiles?.email || r.user_id?.slice(0, 8) + "…")}</div>
                ${r.profiles?.display_name ? `<div class="muted" style="font-size:11px">${App.escapeHtml(r.profiles.display_name)}</div>` : ""}
              </td>
              <td><span class="badge ${badgeClass[r.event_type] || "badge-gray"}">${eventLabels[r.event_type] || r.event_type}</span></td>
              <td><code style="font-size:11px">${App.escapeHtml(r.product_id)}</code></td>
              <td>${App.escapeHtml(r.plan_id || "—")}</td>
              <td>${r.price_usd != null ? "$" + Number(r.price_usd).toFixed(2) : "—"}</td>
              <td class="muted" style="font-size:11px">${r.expires_at ? new Date(r.expires_at).toLocaleDateString("zh-CN") : "—"}</td>
            </tr>`).join("")}</tbody>
        </table>`;
      } catch (ex) {
        App.$("#tx-host").innerHTML = `<div class="status-bar error">${App.escapeHtml(ex.message)}</div>`;
      }
    };

    const loadRefunds = async () => {
      const host = App.$("#refund-host");
      host.innerHTML = `<p class="muted">加载中…</p>`;
      try {
        const { data, error } = await App.client
          .from("user_refund_requests")
          .select("*, profiles(email,display_name)")
          .order("created_at", { ascending: false });
        if (error) throw error;

        const rows = data || [];
        const pending = rows.filter((r) => r.status === "pending");
        const countEl = App.$("#refund-pending-count");
        if (countEl) {
          countEl.textContent = pending.length > 0 ? `(${pending.length} 待处理)` : "";
        }

        if (!rows.length) {
          host.innerHTML = `<p class="muted">暂无退款申请</p>`;
          return;
        }

        const statusColors = { pending: "badge-yellow", approved: "badge-green", rejected: "badge-red" };

        host.innerHTML = `<table class="data-table">
          <thead><tr><th>时间</th><th>用户</th><th>计划</th><th>原因</th><th>状态</th><th>操作</th></tr></thead>
          <tbody>${rows.map((r) => `
            <tr>
              <td style="white-space:nowrap">${new Date(r.created_at).toLocaleString("zh-CN")}</td>
              <td>${App.escapeHtml(r.profiles?.email || r.user_id?.slice(0, 8) + "…")}</td>
              <td>${App.escapeHtml(r.plan_id || "—")}</td>
              <td>${App.escapeHtml(r.reason || "—")}</td>
              <td><span class="badge ${statusColors[r.status] || "badge-gray"}">${r.status}</span></td>
              <td>
                ${r.status === "pending" ? `
                  <button type="button" class="btn btn-sm" data-refund-approve="${App.escapeHtml(r.id)}">通过</button>
                  <button type="button" class="btn btn-sm btn-danger" data-refund-reject="${App.escapeHtml(r.id)}">拒绝</button>
                ` : ""}
              </td>
            </tr>`).join("")}</tbody>
        </table>`;

        host.querySelectorAll("[data-refund-approve],[data-refund-reject]").forEach((btn) => {
          btn.addEventListener("click", async () => {
            const id = btn.dataset.refundApprove || btn.dataset.refundReject;
            const newStatus = btn.dataset.refundApprove ? "approved" : "rejected";
            if (!confirm(`确认将退款申请标记为「${newStatus === "approved" ? "通过" : "拒绝"}」？`)) return;
            const { error } = await App.client
              .from("user_refund_requests")
              .update({ status: newStatus })
              .eq("id", id);
            if (error) return App.showToast(error.message, "error");
            App.showToast(`已${newStatus === "approved" ? "通过" : "拒绝"}退款申请`);
            await loadRefunds();
          });
        });
      } catch (ex) {
        App.$("#refund-host").innerHTML = `<div class="status-bar error">${App.escapeHtml(ex.message)}</div>`;
      }
    };

    await Promise.all([loadTx(), loadRefunds()]);

    App.$("#tx-search")?.addEventListener("input", loadTx);
    App.$("#tx-filter")?.addEventListener("change", loadTx);
    App.$("#tx-refresh")?.addEventListener("click", () => Promise.all([loadTx(), loadRefunds()]));
  };

})();
