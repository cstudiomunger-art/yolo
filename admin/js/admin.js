/* global supabase */
/* ChinaGo Admin — bootstrap & navigation */

(function () {
  const App = window.ChinaGoAdmin;

  async function handleLogin(e) {
    e.preventDefault();
    const email = App.$("#login-email").value.trim();
    const password = App.$("#login-password").value;
    App.$("#login-error").classList.add("hidden");

    try {
      const { data, error } = await App.client.auth.signInWithPassword({ email, password });
      if (error) throw error;
      App.session = data.session;
      const ok = await App.checkIsAdmin(App.session.user.id);
      if (!ok) {
        await App.client.auth.signOut();
        throw new Error("该账号不在 admin_users 表中，无法使用后台。请在 Supabase SQL 中添加管理员。");
      }
      App.showApp(App.session.user.email);
      await App.loadRefCache();
      App.invalidateCityTreeCache?.();
      const storageProbe = await App.probeStorageAccess();
      if (!storageProbe.ok) {
        App.showToast(`Storage 不可达：${storageProbe.message}`, "error");
      }
      await App.renderSidebar();
      const route = App.restoreLastRoute();
      App.expandTreePathForSelection?.(route);
      await App.navigateTo(route);
    } catch (err) {
      const box = App.$("#login-error");
      box.textContent = err.message;
      box.classList.remove("hidden");
    }
  }

  async function handleLogout() {
    await App.client.auth.signOut();
    App.session = null;
    App.showLogin();
  }

  App.loadCurrentSection = async function loadCurrentSection() {
    const addBtn = App.$("#add-row-btn");

    if (App.currentView === "city_hub") {
      await App.renderCityHubList();
      return;
    }

    if (App.currentView === "users_hub") {
      await App.renderUsersHub();
      return;
    }

    if (App.currentView === "membership_hub") {
      await App.renderMembershipHub();
      return;
    }

    if (App.currentView === "transactions_hub") {
      await App.renderTransactionsHub();
      return;
    }

    if (App.currentView === "city_detail" && App.cityHubCityId) {
      await App.loadCityPanel(App.cityHubCityId, App.cityHubPanel || "overview");
      return;
    }

    if (App.currentView === "attraction_edit" && App.cityHubCityId) {
      await App.openAttractionEditor(App.attractionEditId, App.cityHubCityId, {
        focusSection: App.attractionFocusSection,
        focusId: App.attractionFocusId,
      });
      return;
    }

    if (App.currentView === "checklist_settings_global") {
      const cityId = App.cityHubCityId;
      const city = App.refCache.cities.find((c) => c.id === cityId);
      App.$("#page-title").textContent = city
        ? `${city.chinese_name || city.name} · 全局清单设置`
        : "全局清单设置";
      addBtn.classList.add("hidden");
      await App.renderChecklistSettings();
      return;
    }

    const meta = App.TABLES[App.currentTable];
    if (!meta) return;

    App.tableListCtx.search = "";
    App.tableListCtx.typeFilter = "";
    const storedCity = sessionStorage.getItem(App.tableFilterStorageKey(App.currentTable));
    App.tableListCtx.cityId = storedCity || "";
    const storedType = sessionStorage.getItem(App.tableTypeFilterStorageKey(App.currentTable));
    App.tableListCtx.typeFilter = storedType || "";

    App.$("#page-title").textContent = meta.label;
    addBtn.classList.toggle("hidden", !!meta.single || !!meta.noCreate);
    addBtn.textContent = "+ 新建";

    if (App.currentTable === "app_settings") {
      await App.renderAppSettings();
    } else if (App.currentTable === "emergency_config") {
      await App.renderEmergencyConfig();
    } else if (App.currentTable === "checklist_settings") {
      await App.renderChecklistSettings();
    } else {
      await App.renderTable(App.currentTable);
    }
  };

  async function boot() {
    try {
      App.initClient();
    } catch (e) {
      document.body.innerHTML = `<div class="login-wrap"><div class="login-card"><div class="status-bar error">${App.escapeHtml(e.message)}</div></div></div>`;
      return;
    }

    App.initThemeListener?.();
    App.applyTheme?.();
    App.$("#login-theme-toggle")?.addEventListener("click", () => App.cycleTheme());
    App.$("#login-form").addEventListener("submit", handleLogin);
    App.bindSidebarEvents?.();
    App.$("#logout-btn")?.addEventListener("click", handleLogout);

    App.$("#add-row-btn")?.addEventListener("click", () => {
      if (App.currentView === "city_hub") {
        App.openModal(null, "cities", {
          onSaved: async () => {
            await App.loadRefCache(true);
            App.invalidateCityTreeCache?.();
            await App.renderSidebar();
            await App.renderCityHubList();
          },
        });
      } else if (App.currentTable) {
        App.openModal(null, App.currentTable, App.getTableCreateContext(App.currentTable));
      }
    });

    await App.refreshSession();
    if (App.session) {
      try {
        const ok = await App.checkIsAdmin(App.session.user.id);
        if (!ok) {
          await App.client.auth.signOut();
          App.showLogin();
          App.$("#login-error").textContent = "当前用户不是管理员";
          App.$("#login-error").classList.remove("hidden");
          return;
        }
        App.showApp(App.session.user.email);
        await App.loadRefCache();
        const storageProbe = await App.probeStorageAccess();
        if (!storageProbe.ok) {
          App.showToast(`Storage 不可达：${storageProbe.message}`, "error");
        }
        await App.renderSidebar();
        const route = App.restoreLastRoute();
        App.expandTreePathForSelection?.(route);
        await App.navigateTo(route);
      } catch (e) {
        App.showLogin();
      }
    } else {
      App.showLogin();
    }
  }

  document.addEventListener("DOMContentLoaded", boot);
})();
