/* YOLO Admin — user profiles, purchases, subscriptions, avatar moderation */

(function () {
  const App = window.ChinaGoAdmin;

  App.userProfilesCache = App.userProfilesCache || {};

  // ─── Data loading ──────────────────────────────────────────────────────────

  App.loadUserProfilesIndex = async function loadUserProfilesIndex(force) {
    if (!force && App.userProfilesIndex?.length) return App.userProfilesIndex;
    const { data, error } = await App.client
      .from("profiles")
      .select(
        "id,email,display_name,avatar_url,avatar_status,country_code," +
        "has_completed_onboarding,departure_date,selected_city_ids," +
        "purchased_attraction_ids,is_pro,subscription_plan_id,subscription_expires_at," +
        "rc_customer_id,active_itinerary_id,created_at,updated_at"
      )
      .order("updated_at", { ascending: false });
    if (error) throw error;
    App.userProfilesIndex = data || [];
    App.userProfilesCache = Object.fromEntries(App.userProfilesIndex.map((p) => [p.id, p]));
    return App.userProfilesIndex;
  };

  App.profileEmail = function profileEmail(userId) {
    if (!userId) return "—";
    const p = App.userProfilesCache?.[userId];
    return p?.email || `${String(userId).slice(0, 8)}…`;
  };

  // ─── Hub entry ─────────────────────────────────────────────────────────────

  App.renderUsersHub = async function renderUsersHub() {
    App.currentView = "users_hub";
    App.currentTable = null;
    App.$("#page-title").textContent = "用户管理";
    App.$("#add-row-btn").classList.add("hidden");

    if (App.usersHubUserId) {
      await App.renderUserDetail(App.usersHubUserId);
      return;
    }
    await App.renderUsersHubList();
  };

  // ─── User list ─────────────────────────────────────────────────────────────

  App.renderUsersHubList = async function renderUsersHubList() {
    const main = App.$("#main-content");
    main.innerHTML = `
      <div class="hub-toolbar users-hub-toolbar">
        <input type="search" id="users-search" class="search-input" placeholder="搜索邮箱、昵称、UUID…" />
        <select id="users-filter" class="search-input">
          <option value="">全部用户</option>
          <option value="subscribed">订阅会员</option>
          <option value="pro">is_pro 标记</option>
          <option value="purchased">已单购景点</option>
          <option value="onboarded">已完成引导</option>
        </select>
        <button type="button" class="btn btn-secondary btn-sm" id="users-refresh">刷新</button>
      </div>
      <div id="users-list-host"></div>
      <section class="editor-section" style="margin-top:24px">
        <h3>CMS 管理员</h3>
        <p class="muted">新增管理员请在 Supabase SQL 中向 <code>admin_users</code> 插入对应 <code>auth.users</code> 的 UUID。</p>
        <div id="admin-users-host"></div>
      </section>`;

    const host = App.$("#users-list-host");

    const render = async () => {
      host.innerHTML = `<p class="muted">加载中…</p>`;
      try {
        await App.loadRefCache();
        const rows = await App.loadUserProfilesIndex(true);
        const q = (App.$("#users-search")?.value || "").trim().toLowerCase();
        const filter = App.$("#users-filter")?.value || "";

        let list = rows;
        if (q) {
          list = list.filter((p) => {
            const blob = [p.email, p.display_name, p.id, p.country_code].filter(Boolean).join(" ").toLowerCase();
            return blob.includes(q);
          });
        }
        if (filter === "subscribed") list = list.filter((p) => p.subscription_plan_id);
        if (filter === "pro") list = list.filter((p) => p.is_pro);
        if (filter === "purchased") list = list.filter((p) => (p.purchased_attraction_ids || []).length > 0);
        if (filter === "onboarded") list = list.filter((p) => p.has_completed_onboarding);

        if (!list.length) {
          host.innerHTML = `<p class="muted">无匹配用户。</p>`;
          return;
        }

        const now = new Date();
        let html = `<table class="data-table"><thead><tr>
          <th>头像</th><th>邮箱 / 昵称</th><th>国籍</th>
          <th>会员</th><th>到期</th><th>已购景点</th>
          <th>头像状态</th><th>更新</th><th></th>
        </tr></thead><tbody>`;

        list.forEach((p) => {
          const purchased = p.purchased_attraction_ids || [];
          const avatarThumb = p.avatar_url
            ? `<img src="${App.escapeHtml(p.avatar_url)}" style="width:28px;height:28px;border-radius:50%;object-fit:cover;" />`
            : `<span class="avatar-initial">${(p.display_name || p.email || "?")[0].toUpperCase()}</span>`;

          const subscriptionBadge = p.subscription_plan_id
            ? `<span class="badge badge-green">${App.escapeHtml(p.subscription_plan_id)}</span>`
            : (p.is_pro ? `<span class="badge badge-blue">is_pro</span>` : `<span class="badge badge-gray">免费</span>`);

          const expiresAt = p.subscription_expires_at
            ? new Date(p.subscription_expires_at)
            : null;
          const expiresLabel = expiresAt
            ? (expiresAt < now
                ? `<span class="badge badge-red">已到期 ${expiresAt.toLocaleDateString("zh-CN")}</span>`
                : expiresAt.toLocaleDateString("zh-CN"))
            : "—";

          const purchaseTag = purchased.length > 0
            ? `<span class="badge badge-blue">${purchased.length} 个</span>`
            : `<span class="muted">0</span>`;

          const avatarStatusMap = {
            none: `<span class="muted">—</span>`,
            pending: `<span class="badge badge-yellow">待审核</span>`,
            approved: `<span class="badge badge-green">已通过</span>`,
            rejected: `<span class="badge badge-red">已拒绝</span>`,
          };
          const avatarBadge = avatarStatusMap[p.avatar_status] || `<span class="muted">—</span>`;
          const updated = p.updated_at ? new Date(p.updated_at).toLocaleString("zh-CN") : "—";

          html += `<tr>
            <td style="text-align:center">${avatarThumb}</td>
            <td>
              <div>${App.escapeHtml(p.email || "—")}</div>
              ${p.display_name ? `<div class="muted" style="font-size:11px">${App.escapeHtml(p.display_name)}</div>` : ""}
            </td>
            <td>${App.escapeHtml(p.country_code || "—")}</td>
            <td>${subscriptionBadge}</td>
            <td>${expiresLabel}</td>
            <td>${purchaseTag}</td>
            <td>${avatarBadge}</td>
            <td class="muted" style="font-size:11px">${App.escapeHtml(updated)}</td>
            <td><button type="button" class="btn btn-sm" data-open-user="${App.escapeHtml(p.id)}">详情</button></td>
          </tr>`;
        });
        html += `</tbody></table>`;
        host.innerHTML = html;

        host.querySelectorAll("[data-open-user]").forEach((btn) => {
          btn.addEventListener("click", () => {
            App.usersHubUserId = btn.dataset.openUser;
            App.renderUsersHub();
          });
        });
      } catch (ex) {
        host.innerHTML = `<div class="status-bar error">${App.escapeHtml(ex.message)}</div>`;
      }
    };

    await render();
    App.$("#users-search")?.addEventListener("input", render);
    App.$("#users-filter")?.addEventListener("change", render);
    App.$("#users-refresh")?.addEventListener("click", render);

    // Admin users list
    try {
      const { data: admins, error } = await App.client
        .from("admin_users")
        .select("user_id,email,created_at")
        .order("created_at");
      const adminHost = App.$("#admin-users-host");
      if (error) {
        adminHost.innerHTML = `<div class="status-bar error">${App.escapeHtml(error.message)}</div>`;
      } else if (!(admins || []).length) {
        adminHost.innerHTML = `<p class="muted">暂无管理员记录。</p>`;
      } else {
        adminHost.innerHTML = `<ul class="admin-users-list">${(admins || [])
          .map((a) => `<li>
            <code>${App.escapeHtml(a.user_id)}</code>
            · ${App.escapeHtml(a.email || "—")}
            · ${a.created_at ? new Date(a.created_at).toLocaleDateString("zh-CN") : ""}
          </li>`).join("")}</ul>`;
      }
    } catch (ex) {
      const adminHost = App.$("#admin-users-host");
      if (adminHost) adminHost.innerHTML = `<div class="status-bar error">${App.escapeHtml(ex.message)}</div>`;
    }
  };

  // ─── User detail ───────────────────────────────────────────────────────────

  App.renderUserDetail = async function renderUserDetail(userId) {
    const main = App.$("#main-content");
    main.innerHTML = `<p class="muted">加载用户…</p>`;
    try {
      await App.loadRefCache();

      const { data: profile, error } = await App.client
        .from("profiles")
        .select("*")
        .eq("id", userId)
        .single();
      if (error) throw error;

      // Load membership plans for dropdown
      const { data: plans } = await App.client
        .from("membership_plans")
        .select("id,name_zh,name_en,plan_type")
        .eq("is_active", true)
        .order("display_order");

      // Load user itineraries
      const { data: trips } = await App.client
        .from("user_itineraries")
        .select("id,title,cities,is_deleted,updated_at")
        .eq("user_id", userId)
        .order("updated_at", { ascending: false });

      // Load purchase transactions
      const { data: transactions } = await App.client
        .from("user_iap_transactions")
        .select("id,event_type,product_id,plan_id,price_usd,purchased_at")
        .eq("user_id", userId)
        .order("purchased_at", { ascending: false })
        .limit(20);

      // Load refund requests
      const { data: refundRequests } = await App.client
        .from("user_refund_requests")
        .select("id,rc_transaction_id,plan_id,reason,status,created_at")
        .eq("user_id", userId)
        .order("created_at", { ascending: false });

      const purchased = profile.purchased_attraction_ids || [];
      const purchaseField = {
        key: "purchased_attraction_ids",
        type: "ref_attractions_multi",
        label: "已购景点（单购解锁）",
      };

      const planOptions = (plans || [])
        .map((p) => `<option value="${App.escapeHtml(p.id)}" ${profile.subscription_plan_id === p.id ? "selected" : ""}>${App.escapeHtml(p.name_zh || p.name_en)} (${p.plan_type === "subscription" ? "订阅" : "单次"})</option>`)
        .join("");

      const avatarSection = profile.avatar_url
        ? `<div class="field-block">
            <label>当前头像</label>
            <img src="${App.escapeHtml(profile.avatar_url)}"
                 style="width:64px;height:64px;border-radius:50%;object-fit:cover;border:1px solid var(--border)" />
          </div>`
        : `<div class="field-block"><label>当前头像</label><p class="muted">未上传头像</p></div>`;

      const eventLabels = {
        INITIAL_PURCHASE: "首次购买", RENEWAL: "续费", REFUND: "退款",
        CANCELLATION: "取消", EXPIRATION: "到期", NON_RENEWING_PURCHASE: "单次购买",
      };

      const txRows = (transactions || []).map((tx) => `
        <tr>
          <td>${new Date(tx.purchased_at).toLocaleString("zh-CN")}</td>
          <td><span class="badge ${tx.event_type === "REFUND" ? "badge-red" : tx.event_type === "INITIAL_PURCHASE" ? "badge-green" : "badge-gray"}">${eventLabels[tx.event_type] || tx.event_type}</span></td>
          <td><code style="font-size:11px">${App.escapeHtml(tx.product_id)}</code></td>
          <td>${tx.price_usd != null ? "$" + Number(tx.price_usd).toFixed(2) : "—"}</td>
        </tr>`).join("") || `<tr><td colspan="4" class="muted">暂无交易记录</td></tr>`;

      const statusColors = { pending: "badge-yellow", approved: "badge-green", rejected: "badge-red" };
      const refundRows = (refundRequests || []).map((r) => `
        <tr>
          <td>${new Date(r.created_at).toLocaleString("zh-CN")}</td>
          <td>${App.escapeHtml(r.reason || "—")}</td>
          <td><span class="badge ${statusColors[r.status] || "badge-gray"}">${r.status}</span></td>
          <td>
            ${r.status === "pending" ? `
              <button type="button" class="btn btn-sm" data-refund-approve="${App.escapeHtml(r.id)}">通过</button>
              <button type="button" class="btn btn-sm btn-danger" data-refund-reject="${App.escapeHtml(r.id)}">拒绝</button>
            ` : ""}
          </td>
        </tr>`).join("") || `<tr><td colspan="4" class="muted">暂无退款申请</td></tr>`;

      main.innerHTML = `
        <div class="hub-toolbar">
          <button type="button" class="btn btn-secondary btn-sm" id="user-detail-back">← 用户列表</button>
        </div>
        <form id="user-profile-form" class="editor-page settings-form--wide">

          <section class="editor-section">
            <h3>账号信息</h3>
            <div class="field-block"><label>用户 UUID</label>
              <input type="text" readonly value="${App.escapeHtml(profile.id)}" />
            </div>
            <div class="field-block"><label>邮箱</label>
              <input type="text" readonly value="${App.escapeHtml(profile.email || "")}" />
            </div>
            <div class="field-block"><label>显示名</label>
              <input name="display_name" type="text" value="${App.escapeHtml(profile.display_name || "")}" />
            </div>
            <div class="field-block"><label>国籍代码</label>
              <input name="country_code" type="text" value="${App.escapeHtml(profile.country_code || "")}" placeholder="如 GB、US" />
            </div>
            ${avatarSection}
            <div class="field-block"><label>注册 / 最后更新</label>
              <p class="muted">
                ${profile.created_at ? new Date(profile.created_at).toLocaleString("zh-CN") : "—"}
                · ${profile.updated_at ? new Date(profile.updated_at).toLocaleString("zh-CN") : "—"}
              </p>
            </div>
          </section>

          <section class="editor-section">
            <h3>会员与订阅</h3>
            <p class="muted">修改后 App 下次拉取 profile 或用户重新登录时生效。</p>
            <div class="field-block">
              <label>订阅计划</label>
              <select name="subscription_plan_id">
                <option value="">— 无订阅 —</option>
                ${planOptions}
              </select>
            </div>
            <div class="field-block">
              <label>订阅到期时间</label>
              <input name="subscription_expires_at" type="datetime-local"
                value="${profile.subscription_expires_at ? new Date(profile.subscription_expires_at).toISOString().slice(0,16) : ""}" />
              <span class="muted" style="font-size:11px">留空 = 永久有效（不自动续费的终身计划）</span>
            </div>
            <div class="field-block">
              <label class="checkbox-chip" style="display:inline-flex">
                <input type="checkbox" name="is_pro" ${profile.is_pro ? "checked" : ""} />
                &nbsp;is_pro 标记（遗留字段，优先使用 subscription_plan_id）
              </label>
            </div>
            <div class="field-block"><label>RevenueCat Customer ID</label>
              <input name="rc_customer_id" type="text" value="${App.escapeHtml(profile.rc_customer_id || "")}" placeholder="通常与 Supabase UUID 相同" />
            </div>
            ${App.renderFieldBlock(purchaseField, purchased, { isNew: false, pk: "id" })}
          </section>

          <section class="editor-section">
            <h3>行程偏好</h3>
            <label class="checkbox-chip" style="display:inline-flex;margin-bottom:8px">
              <input type="checkbox" name="has_completed_onboarding" ${profile.has_completed_onboarding ? "checked" : ""} />
              &nbsp;已完成引导
            </label>
            <div class="field-block"><label>出发日期</label>
              <input name="departure_date" type="date" value="${App.escapeHtml(profile.departure_date || "")}" />
            </div>
            <div class="field-block"><label>当前行程 ID</label>
              <input name="active_itinerary_id" type="text" value="${App.escapeHtml(profile.active_itinerary_id || "")}" placeholder="user_itineraries.id" />
            </div>
          </section>

          <section class="editor-section">
            <h3>用户行程 <span class="muted">(${(trips || []).filter((t) => !t.is_deleted).length} 条有效)</span></h3>
            <button type="button" class="btn btn-sm btn-secondary" id="user-open-itineraries">在「用户行程」表中筛选</button>
            <ul class="user-trips-list">
              ${(trips || []).map((t) => {
                const deleted = t.is_deleted ? " <span class='badge badge-red'>已删</span>" : "";
                return `<li>
                  ${App.escapeHtml(t.title || t.id)}${deleted}
                  · <span class="muted">${App.escapeHtml((t.cities || []).join(", "))}</span>
                  <button type="button" class="btn btn-sm btn-secondary" data-edit-trip="${App.escapeHtml(t.id)}">编辑</button>
                </li>`;
              }).join("") || "<li class='muted'>暂无行程</li>"}
            </ul>
          </section>

          <section class="editor-section">
            <h3>交易记录 <span class="muted">（最近 20 条）</span></h3>
            <table class="data-table">
              <thead><tr><th>时间</th><th>类型</th><th>商品</th><th>金额</th></tr></thead>
              <tbody>${txRows}</tbody>
            </table>
          </section>

          <section class="editor-section">
            <h3>退款申请</h3>
            <table class="data-table">
              <thead><tr><th>时间</th><th>原因</th><th>状态</th><th>操作</th></tr></thead>
              <tbody id="refund-requests-tbody">${refundRows}</tbody>
            </table>
          </section>

          <div class="editor-actions">
            <button type="submit" class="btn">保存用户资料</button>
          </div>
        </form>`;

      // ── Event wiring ──

      App.$("#user-detail-back")?.addEventListener("click", () => {
        App.usersHubUserId = null;
        App.renderUsersHub();
      });

      App.$("#user-open-itineraries")?.addEventListener("click", () => {
        sessionStorage.setItem("yolo.admin.userItinerariesFilter", userId);
        App.usersHubUserId = null;
        App.navigateTo?.({ kind: "table", table: "user_itineraries" });
      });

      // Edit trips
      const form = App.$("#user-profile-form");
      form?.querySelectorAll("[data-edit-trip]").forEach((btn) => {
        btn.addEventListener("click", async () => {
          const { data: row } = await App.client
            .from("user_itineraries")
            .select("*")
            .eq("id", btn.dataset.editTrip)
            .single();
          if (row) App.openModal(row, "user_itineraries", {});
        });
      });

      // Refund request actions
      App.$("#refund-requests-tbody")?.querySelectorAll("[data-refund-approve],[data-refund-reject]").forEach((btn) => {
        btn.addEventListener("click", async () => {
          const id = btn.dataset.refundApprove || btn.dataset.refundReject;
          const newStatus = btn.dataset.refundApprove ? "approved" : "rejected";
          if (!confirm(`确认将退款申请标记为「${newStatus === "approved" ? "通过" : "拒绝"}」？`)) return;
          const { error } = await App.client
            .from("user_refund_requests")
            .update({ status: newStatus })
            .eq("id", id);
          if (error) return App.showToast(error.message, "error");
          App.showToast(`退款申请已${newStatus === "approved" ? "通过" : "拒绝"}`);
          await App.renderUserDetail(userId);
        });
      });

      // Save form
      form?.addEventListener("submit", async (e) => {
        e.preventDefault();
        try {
          const expiresRaw = form.querySelector('[name="subscription_expires_at"]')?.value?.trim();
          const payload = {
            display_name: form.querySelector('[name="display_name"]')?.value?.trim() || null,
            country_code: form.querySelector('[name="country_code"]')?.value?.trim() || "GB",
            is_pro: !!form.querySelector('[name="is_pro"]')?.checked,
            subscription_plan_id: form.querySelector('[name="subscription_plan_id"]')?.value || null,
            subscription_expires_at: expiresRaw ? new Date(expiresRaw).toISOString() : null,
            rc_customer_id: form.querySelector('[name="rc_customer_id"]')?.value?.trim() || null,
            has_completed_onboarding: !!form.querySelector('[name="has_completed_onboarding"]')?.checked,
            departure_date: form.querySelector('[name="departure_date"]')?.value?.trim() || null,
            active_itinerary_id: form.querySelector('[name="active_itinerary_id"]')?.value?.trim() || null,
            purchased_attraction_ids: App.readFieldValue(purchaseField, form) || [],
            updated_at: new Date().toISOString(),
          };
          const { error: err } = await App.client
            .from("profiles")
            .update(payload)
            .eq("id", userId);
          if (err) throw err;
          App.showToast("用户资料已保存");
          await App.loadUserProfilesIndex(true);
          await App.renderUserDetail(userId);
        } catch (ex) {
          App.showToast(ex.message, "error");
        }
      });
    } catch (ex) {
      main.innerHTML = `
        <div class="status-bar error">${App.escapeHtml(ex.message)}</div>
        <button type="button" class="btn btn-secondary" id="user-detail-back">← 返回</button>`;
      App.$("#user-detail-back")?.addEventListener("click", () => {
        App.usersHubUserId = null;
        App.renderUsersHub();
      });
    }
  };
})();
