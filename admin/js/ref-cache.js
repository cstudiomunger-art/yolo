/* ChinaGo Admin — reference data cache for pickers */

(function () {
  const App = window.ChinaGoAdmin;

  App.refCache = {
    cities: [],
    attractions: [],
    audioGuides: [],
    scenarios: [],
    countries: [],
    loaded: false,
  };

  App.loadRefCache = async function loadRefCache(force) {
    if (App.refCache.loaded && !force) return;
    const [citiesRes, attrRes, audioRes, scenRes, countryRes] = await Promise.all([
      App.client.from("cities").select("id,name,chinese_name,emoji").order("display_order", { ascending: true }),
      App.client.from("attractions").select("id,city_id,name,chinese_name").order("display_order", { ascending: true }),
      App.client.from("audio_guides").select("id,attraction_id,title_en,is_active").order("sort_order", { ascending: true }),
      App.client.from("assistant_scenarios").select("id,label,description,sort_order,is_active").order("sort_order", { ascending: true }),
      App.client.from("passport_countries").select("code,name,flag").order("display_order", { ascending: true }),
    ]);
    if (citiesRes.error) throw citiesRes.error;
    if (attrRes.error) throw attrRes.error;
    if (audioRes.error) throw audioRes.error;
    if (scenRes.error) throw scenRes.error;
    if (countryRes.error) throw countryRes.error;
    App.refCache.cities = citiesRes.data || [];
    App.refCache.attractions = attrRes.data || [];
    App.refCache.audioGuides = audioRes.data || [];
    App.refCache.scenarios = scenRes.data || [];
    App.refCache.countries = countryRes.data || [];
    App.refCache.loaded = true;
  };

  App.audioGuidesForAttraction = function audioGuidesForAttraction(attractionId) {
    if (!attractionId) return [];
    return App.refCache.audioGuides.filter((g) => g.attraction_id === attractionId && g.is_active !== false);
  };

  /** Picker list: ctx guides / city-hub cache / ref cache (attractionId optional if ctx supplies guides). */
  App.listAudioGuidesForPicker = function listAudioGuidesForPicker(attractionId, ctx = {}) {
    const byId = new Map();
    const merge = (arr) => {
      for (const g of arr || []) {
        if (g?.id) byId.set(g.id, g);
      }
    };
    if (Array.isArray(ctx.audioGuides)) merge(ctx.audioGuides);
    if (typeof ctx.getAudioGuides === "function") merge(ctx.getAudioGuides(attractionId));
    if (attractionId && App.attractionGuidesCache?.[attractionId]) {
      merge(App.attractionGuidesCache[attractionId]);
    }
    if (attractionId) merge(App.audioGuidesForAttraction(attractionId));
    const showInactive = ctx.includeInactiveAudioGuides === true;
    return [...byId.values()]
      .filter((g) => showInactive || g.is_active !== false)
      .sort((a, b) => (a.sort_order ?? 0) - (b.sort_order ?? 0));
  };

  App.audioGuideLabel = function audioGuideLabel(id) {
    if (!id) return "—";
    const g = App.refCache.audioGuides.find((x) => x.id === id);
    if (!g) return id;
    return g.title_en || id;
  };

  App.createScenarioQuick = async function createScenarioQuick(label) {
    const trimmed = String(label || "").trim();
    if (!trimmed) throw new Error("请填写场景名称");
    let baseId = App.slugify(trimmed, "scene");
    let id = baseId;
    let n = 2;
    while (App.refCache.scenarios.some((s) => s.id === id)) {
      id = `${baseId}_${n}`;
      n += 1;
    }
    const { error } = await App.client.from("assistant_scenarios").insert({
      id,
      label: trimmed,
      sort_order: App.refCache.scenarios.length,
      is_active: true,
      updated_at: new Date().toISOString(),
    });
    if (error) throw error;
    await App.loadRefCache(true);
    return id;
  };

  App.cityLabel = function cityLabel(id) {
    if (!id) return "—";
    const c = App.refCache.cities.find((x) => x.id === id);
    if (!c) return id;
    return `${c.emoji || ""} ${c.chinese_name || c.name}`.trim();
  };

  App.attractionLabel = function attractionLabel(id) {
    if (!id) return "—";
    const a = App.refCache.attractions.find((x) => x.id === id);
    if (!a) return id;
    return `${a.chinese_name || a.name} (${App.cityLabel(a.city_id)})`;
  };

  App.scenarioLabel = function scenarioLabel(id) {
    if (!id) return "—";
    const s = App.refCache.scenarios.find((x) => x.id === id);
    if (!s) return id;
    return s.label || id;
  };

  App.countryLabel = function countryLabel(code) {
    if (!code) return "—";
    const c = App.refCache.countries.find((x) => x.code === code);
    if (!c) return code;
    return `${c.flag || ""} ${c.name}`.trim();
  };

  App.attractionsForCity = function attractionsForCity(cityId) {
    if (!cityId) return App.refCache.attractions;
    return App.refCache.attractions.filter((a) => a.city_id === cityId);
  };

  App.cityIdFromName = function cityIdFromName(name) {
    if (!name) return "";
    const lower = String(name).toLowerCase();
    const c = App.refCache.cities.find(
      (x) =>
        (x.chinese_name && x.chinese_name.toLowerCase() === lower) ||
        (x.name && x.name.toLowerCase() === lower) ||
        App.cityLabel(x.id).toLowerCase() === lower
    );
    return c?.id || "";
  };
})();
