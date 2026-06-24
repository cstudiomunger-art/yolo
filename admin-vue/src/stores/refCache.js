import { defineStore } from "pinia";
import { ref } from "vue";
import { supabase } from "@/lib/supabase";

/** Reference lookups shared by ref_* field selectors (cities, attractions, …). */
export const useRefCache = defineStore("refCache", () => {
  const cities = ref([]);
  const attractions = ref([]);
  const audioGuides = ref([]);
  const scenarios = ref([]);
  const countries = ref([]);
  const users = ref([]);
  const ports = ref([]);
  const countriesV2 = ref([]);
  const visaPoliciesV2 = ref([]);
  const loaded = ref(false);

  async function load(force = false) {
    if (loaded.value && !force) return;
    const [citiesRes, attrRes, audioRes, scenRes, countryRes] = await Promise.all([
      supabase.from("cities").select("id,name,chinese_name,emoji").order("display_order", { ascending: true }),
      supabase.from("attractions").select("id,city_id,name,chinese_name").order("display_order", { ascending: true }),
      supabase.from("audio_guides").select("id,attraction_id,title_en,is_active").order("sort_order", { ascending: true }),
      supabase.from("assistant_scenarios").select("id,label,description,sort_order,is_active").order("sort_order", { ascending: true }),
      supabase.from("passport_countries").select("code,name,flag").order("display_order", { ascending: true }),
    ]);
    cities.value = citiesRes.data || [];
    attractions.value = attrRes.data || [];
    audioGuides.value = audioRes.data || [];
    scenarios.value = scenRes.data || [];
    countries.value = countryRes.data || [];

    // Secondary refs (admin-only tables); ignore individual failures so the
    // core editors still work if e.g. visa tables aren't seeded.
    const [usersRes, portsRes, countriesV2Res, visaPolRes] = await Promise.all([
      supabase.from("profiles").select("id,email,display_name").order("email", { ascending: true }),
      supabase.from("visa_ports").select("code,name_zh,display_order,is_active").order("display_order", { ascending: true }),
      supabase.from("visa_countries").select("country_code,name_zh,flag_emoji,is_active").order("country_code", { ascending: true }),
      supabase.from("visa_policies_v2").select("id,official_name_zh,policy_type,priority").order("priority", { ascending: true }),
    ]);
    users.value = usersRes.data || [];
    ports.value = portsRes.data || [];
    countriesV2.value = countriesV2Res.data || [];
    visaPoliciesV2.value = visaPolRes.data || [];
    loaded.value = true;
  }

  function cityLabel(id) {
    if (!id) return "—";
    const c = cities.value.find((x) => x.id === id);
    return c ? `${c.emoji || ""} ${c.chinese_name || c.name}`.trim() : id;
  }
  function attractionLabel(id) {
    if (!id) return "—";
    const a = attractions.value.find((x) => x.id === id);
    return a ? `${a.chinese_name || a.name}` : id;
  }
  function attractionsForCity(cityId) {
    if (!cityId) return attractions.value;
    return attractions.value.filter((a) => a.city_id === cityId);
  }

  function userLabel(id) {
    const u = users.value.find((x) => x.id === id);
    return u ? u.email || u.display_name || u.id : id;
  }

  return {
    cities, attractions, audioGuides, scenarios, countries,
    users, ports, countriesV2, visaPoliciesV2, loaded,
    load, cityLabel, attractionLabel, attractionsForCity, userLabel,
  };
});
