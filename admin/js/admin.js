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
      const storageProbe = await App.probeStorageAccess();
      if (!storageProbe.ok) {
        App.showToast(`Storage 不可达：${storageProbe.message}`, "error");
      }
      await App.loadCurrentSection();
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

  function setActiveNav(btn) {
    App.$$(".nav-btn").forEach((b) => b.classList.remove("active"));
    btn.classList.add("active");
  }

  function bindNav() {
    App.$$(".nav-btn[data-view]").forEach((btn) => {
      btn.addEventListener("click", () => {
        setActiveNav(btn);
        App.currentView = btn.dataset.view;
        App.currentTable = null;
        App.cityHubCityId = null;
        App.attractionEditId = null;
        App.usersHubUserId = null;
        App.loadCurrentSection();
      });
    });

    App.$$(".nav-btn[data-table]").forEach((btn) => {
      btn.addEventListener("click", () => {
        setActiveNav(btn);
        App.currentView = "table";
        App.currentTable = btn.dataset.table;
        App.cityHubCityId = null;
        App.attractionEditId = null;
        App.usersHubUserId = null;
        App.loadCurrentSection();
      });
    });

    App.$("#logout-btn").addEventListener("click", handleLogout);
    App.$("#add-row-btn").addEventListener("click", () => {
      if (App.currentView === "city_hub") {
        App.openModal(null, "cities", { onSaved: () => App.renderCityHubList() });
      } else if (App.currentTable) {
        App.openModal(null, App.currentTable, App.getTableCreateContext(App.currentTable));
      }
    });
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

    if (App.currentView === "city_detail" && App.cityHubCityId) {
      await App.openCityHub(App.cityHubCityId);
      return;
    }

    if (App.currentView === "attraction_edit" && App.attractionEditId && App.cityHubCityId) {
      await App.openAttractionEditor(App.attractionEditId, App.cityHubCityId);
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

    App.$("#login-form").addEventListener("submit", handleLogin);
    bindNav();

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
        App.currentView = "city_hub";
        setActiveNav(App.$('.nav-btn[data-view="city_hub"]'));
        await App.loadCurrentSection();
      } catch (e) {
        App.showLogin();
      }
    } else {
      App.showLogin();
    }
  }

  document.addEventListener("DOMContentLoaded", boot);
})();
