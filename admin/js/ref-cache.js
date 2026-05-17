/* ChinaGo Admin — reference data cache for pickers */

(function () {
  const App = window.ChinaGoAdmin;

  App.refCache = {
    cities: [],
    attractions: [],
    scenarios: [],
    countries: [],
    loaded: false,
  };

  App.loadRefCache = async function loadRefCache(force) {
    if (App.refCache.loaded && !force) return;
    const [citiesRes, attrRes, scenRes, countryRes] = await Promise.all([
      App.client.from("cities").select("id,name,chinese_name,emoji").order("display_order", { ascending: true }),
      App.client.from("attractions").select("id,city_id,name,chinese_name").order("display_order", { ascending: true }),
      App.client.from("assistant_replies").select("scenario_id,user_message,is_active").order("scenario_id"),
      App.client.from("passport_countries").select("code,name,flag").order("display_order", { ascending: true }),
    ]);
    if (citiesRes.error) throw citiesRes.error;
    if (attrRes.error) throw attrRes.error;
    if (scenRes.error) throw scenRes.error;
    if (countryRes.error) throw countryRes.error;
    App.refCache.cities = citiesRes.data || [];
    App.refCache.attractions = attrRes.data || [];
    App.refCache.scenarios = scenRes.data || [];
    App.refCache.countries = countryRes.data || [];
    App.refCache.loaded = true;
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
    const s = App.refCache.scenarios.find((x) => x.scenario_id === id);
    if (!s) return id;
    const msg = (s.user_message || "").slice(0, 40);
    return msg ? `${id} — ${msg}` : id;
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
})();
