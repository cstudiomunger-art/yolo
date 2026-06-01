/* YOLO Admin — user profiles, purchases, itineraries */

(function () {
  const App = window.ChinaGoAdmin;

  App.userProfilesCache = App.userProfilesCache || {};

  App.loadUserProfilesIndex = async function loadUserProfilesIndex(force) {
    if (!force && App.userProfilesIndex?.length) return App.userProfilesIndex;
    const { data, error } = await App.client
      .from("profiles")
      .select(
        "id,email,display_name,country_code,has_completed_onboarding,departure_date,selected_city_ids,purchased_attraction_ids,is_pro,active_itinerary_id,created_at,updated_at"
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

  App.renderUsersHub = async function renderUsersHub() {
    App.currentView = "users_hub";
    App.currentTable = null;
    App.$("#page-title").textContent = "用户与购买";
    App.$("#add-row-btn").classList.add("hidden");

    if (App.usersHubUserId) {
      await App.renderUserDetail(App.usersHubUserId);
      return;
    }
    await App.renderUsersHubList();
  };

  App.renderUsersHubList = async function renderUsersHubList() {
    const main = App.$("#main-content");
    main.innerHTML = `<div class="status-bar info">购买记录来自 App 同步的 <code>profiles.purchased_attraction_ids</code> 与 <code>is_pro</code>（当前为本地模拟内购，非 App Store 收据）。</div>
      <div class="hub-toolbar users-hub-toolbar">
        <input type="search" id="users-search" class="search-input" placeholder="搜索邮箱、昵称或 UUID…" />
        <select id="users-filter" class="search-input">
          <option value="">全部用户</option>
          <option value="pro">仅 Pro</option>
          <option value="purchased">已单购景点</option>
          <option value="onboarded">已完成引导</option>
        </select>
        <button type="button" class="btn btn-secondary btn-sm" id="users-refresh">刷新</button>
      </div>
      <div id="users-list-host"></div>
      <section class="editor-section" style="margin-top:24px"><h3>CMS 管理员</h3>
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
        if (filter === "pro") list = list.filter((p) => p.is_pro);
        if (filter === "purchased") list = list.filter((p) => (p.purchased_attraction_ids || []).length > 0);
        if (filter === "onboarded") list = list.filter((p) => p.has_completed_onboarding);

        if (!list.length) {
          host.innerHTML = `<p class="muted">无匹配用户。请确认已执行 <code>037_admin_profiles_access.sql</code>。</p>`;
          return;
        }

        let html = `<table class="data-table"><thead><tr>
          <th>邮箱</th><th>昵称</th><th>国籍</th><th>Pro</th><th>已购景点</th><th>引导</th><th>更新</th><th></th>
        </tr></thead><tbody>`;
        list.forEach((p) => {
          const purchased = p.purchased_attraction_ids || [];
          const proTag = p.is_pro
            ? '<span class="tag on">Pro</span>'
            : '<span class="tag off">—</span>';
          const purchaseTag =
            purchased.length > 0
              ? `<span class="tag on">${purchased.length} 个</span>`
              : '<span class="tag off">0</span>';
          const onboard = p.has_completed_onboarding
            ? '<span class="tag on">完成</span>'
            : '<span class="tag off">未完成</span>';
          const updated = p.updated_at ? new Date(p.updated_at).toLocaleString("zh-CN") : "—";
          html += `<tr>
            <td>${App.escapeHtml(p.email || "—")}</td>
            <td>${App.escapeHtml(p.display_name || "—")}</td>
            <td>${App.escapeHtml(p.country_code || "—")}</td>
            <td>${proTag}</td>
            <td>${purchaseTag}</td>
            <td>${onboard}</td>
            <td class="muted">${App.escapeHtml(updated)}</td>
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

    try {
      const { data: admins, error } = await App.client.from("admin_users").select("user_id,email,created_at").order("created_at");
      const adminHost = App.$("#admin-users-host");
      if (error) {
        adminHost.innerHTML = `<div class="status-bar error">${App.escapeHtml(error.message)}</div>`;
      } else if (!(admins || []).length) {
        adminHost.innerHTML = `<p class="muted">暂无管理员记录。</p>`;
      } else {
        adminHost.innerHTML = `<ul class="admin-users-list">${(admins || [])
          .map(
            (a) =>
              `<li><code>${App.escapeHtml(a.user_id)}</code> · ${App.escapeHtml(a.email || "—")} · ${a.created_at ? new Date(a.created_at).toLocaleDateString("zh-CN") : ""}</li>`
          )
          .join("")}</ul>`;
      }
    } catch (ex) {
      App.$("#admin-users-host").innerHTML = `<div class="status-bar error">${App.escapeHtml(ex.message)}</div>`;
    }
  };

  App.renderUserDetail = async function renderUserDetail(userId) {
    const main = App.$("#main-content");
    main.innerHTML = `<p class="muted">加载用户…</p>`;
    try {
      await App.loadRefCache();
      const { data: profile, error } = await App.client.from("profiles").select("*").eq("id", userId).single();
      if (error) throw error;

      const { data: trips } = await App.client
        .from("user_itineraries")
        .select("id,title,cities,is_deleted,updated_at")
        .eq("user_id", userId)
        .order("updated_at", { ascending: false });

      const purchased = profile.purchased_attraction_ids || [];
      const purchaseField = {
        key: "purchased_attraction_ids",
        type: "ref_attractions_multi",
        label: "已购景点（单购解锁）",
      };

      main.innerHTML = `
        <div class="hub-toolbar">
          <button type="button" class="btn btn-secondary btn-sm" id="user-detail-back">← 用户列表</button>
        </div>
        <form id="user-profile-form" class="editor-page settings-form--wide">
          <section class="editor-section">
            <h3>账号</h3>
            <div class="field-block"><label>用户 UUID</label><input type="text" readonly value="${App.escapeHtml(profile.id)}" /></div>
            <div class="field-block"><label>邮箱</label><input type="text" readonly value="${App.escapeHtml(profile.email || "")}" /></div>
            <div class="field-block"><label>显示名</label><input name="display_name" type="text" value="${App.escapeHtml(profile.display_name || "")}" /></div>
            <div class="field-block"><label>国籍代码</label><input name="country_code" type="text" value="${App.escapeHtml(profile.country_code || "")}" placeholder="如 GB、US" /></div>
            <div class="field-block"><label>注册 / 更新</label>
              <p class="muted">${App.escapeHtml(profile.created_at ? new Date(profile.created_at).toLocaleString("zh-CN") : "—")} · ${App.escapeHtml(profile.updated_at ? new Date(profile.updated_at).toLocaleString("zh-CN") : "—")}</p>
            </div>
          </section>
          <section class="editor-section">
            <h3>购买与会员</h3>
            <p class="muted">修改后 App 下次拉取 profile 或用户重新登录时生效。Pro 与单购景点可同时存在；Pro 通常解锁全部导览。</p>
            <label class="checkbox-chip" style="display:inline-flex;margin-bottom:12px">
              <input type="checkbox" name="is_pro" ${profile.is_pro ? "checked" : ""} /> YOLO HAPPY Pro（<code>is_pro</code>）
            </label>
            ${App.renderFieldBlock(purchaseField, purchased, { isNew: false, pk: "id" })}
          </section>
          <section class="editor-section">
            <h3>行程偏好</h3>
            <label class="checkbox-chip" style="display:inline-flex;margin-bottom:8px">
              <input type="checkbox" name="has_completed_onboarding" ${profile.has_completed_onboarding ? "checked" : ""} /> 已完成引导
            </label>
            <div class="field-block"><label>出发日期</label><input name="departure_date" type="date" value="${App.escapeHtml(profile.departure_date || "")}" /></div>
            <div class="field-block"><label>当前行程 ID</label><input name="active_itinerary_id" type="text" value="${App.escapeHtml(profile.active_itinerary_id || "")}" placeholder="user_itineraries.id" /></div>
          </section>
          <section class="editor-section">
            <h3>用户行程 <span class="muted">(${ (trips || []).filter((t) => !t.is_deleted).length } 条有效)</span></h3>
            <button type="button" class="btn btn-sm btn-secondary" id="user-open-itineraries">在「用户行程」表中筛选</button>
            <ul class="user-trips-list">${(trips || [])
              .map((t) => {
                const deleted = t.is_deleted ? " (已删)" : "";
                return `<li>${App.escapeHtml(t.title || t.id)}${deleted} · ${App.escapeHtml((t.cities || []).join(", "))}
                  <button type="button" class="btn btn-sm btn-secondary" data-edit-trip="${App.escapeHtml(t.id)}">编辑</button></li>`;
              })
              .join("") || "<li class=\"muted\">暂无行程</li>"}</ul>
          </section>
          <div class="editor-actions">
            <button type="submit" class="btn">保存用户资料</button>
          </div>
        </form>`;

      const form = App.$("#user-profile-form");
      App.$("#user-detail-back")?.addEventListener("click", () => {
        App.usersHubUserId = null;
        App.renderUsersHub();
      });
      App.$("#user-open-itineraries")?.addEventListener("click", () => {
        sessionStorage.setItem("yolo.admin.userItinerariesFilter", userId);
        App.usersHubUserId = null;
        if (App.navigateTo) {
          App.navigateTo({ kind: "table", table: "user_itineraries" });
        } else {
          App.currentView = "table";
          App.currentTable = "user_itineraries";
          App.loadCurrentSection();
        }
      });
      form.querySelectorAll("[data-edit-trip]").forEach((btn) => {
        btn.addEventListener("click", async () => {
          const { data: row } = await App.client
            .from("user_itineraries")
            .select("*")
            .eq("id", btn.dataset.editTrip)
            .single();
          if (row) App.openModal(row, "user_itineraries", {});
        });
      });

      form.addEventListener("submit", async (e) => {
        e.preventDefault();
        try {
          const payload = {
            display_name: form.querySelector('[name="display_name"]')?.value?.trim() || null,
            country_code: form.querySelector('[name="country_code"]')?.value?.trim() || "GB",
            is_pro: !!form.querySelector('[name="is_pro"]')?.checked,
            has_completed_onboarding: !!form.querySelector('[name="has_completed_onboarding"]')?.checked,
            departure_date: form.querySelector('[name="departure_date"]')?.value?.trim() || null,
            active_itinerary_id: form.querySelector('[name="active_itinerary_id"]')?.value?.trim() || null,
            purchased_attraction_ids: App.readFieldValue(purchaseField, form) || [],
            updated_at: new Date().toISOString(),
          };
          const { error: err } = await App.client.from("profiles").update(payload).eq("id", userId);
          if (err) throw err;
          App.showToast("用户资料已保存");
          await App.loadUserProfilesIndex(true);
          await App.renderUserDetail(userId);
        } catch (ex) {
          App.showToast(ex.message, "error");
        }
      });
    } catch (ex) {
      main.innerHTML = `<div class="status-bar error">${App.escapeHtml(ex.message)}</div>
        <button type="button" class="btn btn-secondary" id="user-detail-back">← 返回</button>`;
      App.$("#user-detail-back")?.addEventListener("click", () => {
        App.usersHubUserId = null;
        App.renderUsersHub();
      });
    }
  };
})();
