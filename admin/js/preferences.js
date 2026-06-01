/* ChinaGo Admin — theme & persisted UI preferences */

(function () {
  const App = window.ChinaGoAdmin;

  const THEME_KEY = "yolo.admin.theme";
  const LAST_ROUTE_KEY = "yolo.admin.lastRoute";
  const TREE_EXPANDED_KEY = "yolo.admin.treeExpanded";
  const NAV_GROUPS_KEY = "yolo.admin.navGroups";
  const NAV_FILTER_KEY = "yolo.admin.navFilter";

  App.getThemePreference = function getThemePreference() {
    const v = localStorage.getItem(THEME_KEY);
    if (v === "light" || v === "dark" || v === "system") return v;
    return "system";
  };

  App.resolveTheme = function resolveTheme(pref) {
    if (pref === "light" || pref === "dark") return pref;
    if (typeof matchMedia !== "undefined" && matchMedia("(prefers-color-scheme: dark)").matches) {
      return "dark";
    }
    return "light";
  };

  App.applyTheme = function applyTheme(pref) {
    const p = pref || App.getThemePreference();
    const resolved = App.resolveTheme(p);
    document.documentElement.dataset.theme = resolved;
    document.documentElement.dataset.themePref = p;
    const btn = App.$("#theme-toggle");
    if (btn) {
      const labels = { system: "主题：跟随系统", light: "主题：浅色", dark: "主题：深色" };
      btn.title = labels[p] || labels.system;
      btn.setAttribute("aria-label", btn.title);
      btn.textContent = p === "light" ? "☀" : p === "dark" ? "☾" : "◐";
    }
  };

  App.cycleTheme = function cycleTheme() {
    const order = ["system", "light", "dark"];
    const cur = App.getThemePreference();
    const next = order[(order.indexOf(cur) + 1) % order.length];
    localStorage.setItem(THEME_KEY, next);
    App.applyTheme(next);
  };

  App.initThemeListener = function initThemeListener() {
    if (App._themeMqBound) return;
    App._themeMqBound = true;
    const mq = matchMedia("(prefers-color-scheme: dark)");
    const onChange = () => {
      if (App.getThemePreference() === "system") App.applyTheme("system");
    };
    mq.addEventListener("change", onChange);
  };

  App.getLastRoute = function getLastRoute() {
    try {
      const raw = localStorage.getItem(LAST_ROUTE_KEY);
      return raw ? JSON.parse(raw) : null;
    } catch {
      return null;
    }
  };

  App.saveLastRoute = function saveLastRoute(route) {
    if (!route) return;
    localStorage.setItem(LAST_ROUTE_KEY, JSON.stringify(route));
  };

  App.getTreeExpanded = function getTreeExpanded() {
    try {
      const raw = localStorage.getItem(TREE_EXPANDED_KEY);
      return raw ? JSON.parse(raw) : {};
    } catch {
      return {};
    }
  };

  App.setTreeExpanded = function setTreeExpanded(key, value) {
    const state = App.getTreeExpanded();
    state[key] = value;
    localStorage.setItem(TREE_EXPANDED_KEY, JSON.stringify(state));
  };

  App.isTreeExpanded = function isTreeExpanded(key, defaultVal) {
    const state = App.getTreeExpanded();
    if (key in state) return !!state[key];
    return defaultVal !== undefined ? defaultVal : false;
  };

  App.getNavGroupsState = function getNavGroupsState() {
    try {
      const raw = localStorage.getItem(NAV_GROUPS_KEY);
      return raw ? JSON.parse(raw) : {};
    } catch {
      return {};
    }
  };

  App.setNavGroupExpanded = function setNavGroupExpanded(groupId, expanded) {
    const state = App.getNavGroupsState();
    state[groupId] = expanded;
    localStorage.setItem(NAV_GROUPS_KEY, JSON.stringify(state));
  };

  App.isNavGroupExpanded = function isNavGroupExpanded(groupId, defaultVal) {
    const state = App.getNavGroupsState();
    if (groupId in state) return !!state[groupId];
    return defaultVal !== undefined ? defaultVal : false;
  };

  App.getNavFilter = function getNavFilter() {
    return localStorage.getItem(NAV_FILTER_KEY) || "";
  };

  App.setNavFilter = function setNavFilter(q) {
    if (q) localStorage.setItem(NAV_FILTER_KEY, q);
    else localStorage.removeItem(NAV_FILTER_KEY);
  };

  /** Inline in index.html head — keep in sync */
  App.applyThemeEarly = function applyThemeEarly() {
    try {
      const pref = localStorage.getItem(THEME_KEY) || "system";
      let resolved = pref;
      if (pref === "system") {
        resolved =
          typeof matchMedia !== "undefined" && matchMedia("(prefers-color-scheme: dark)").matches
            ? "dark"
            : "light";
      }
      document.documentElement.dataset.theme = resolved;
    } catch (_) {
      /* ignore */
    }
  };
})();
