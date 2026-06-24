import { defineStore } from "pinia";
import { ref } from "vue";
import { supabase } from "@/lib/supabase";

/** Loads the visa engine v2 tables for the workbench. */
export const useVisa = defineStore("visa", () => {
  const policies = ref([]);
  const grants = ref([]);
  const countries = ref([]);
  const cities = ref([]);
  const ports = ref([]);
  const matrix = ref([]);
  const loaded = ref(false);
  const error = ref("");

  async function loadAll() {
    error.value = "";
    const [pol, gr, ct, ci, po, mx] = await Promise.all([
      supabase.from("visa_policies_v2").select("*").order("priority", { ascending: true }),
      supabase.from("visa_policy_grants_v2").select("*"),
      supabase.from("visa_countries").select("*").order("country_code", { ascending: true }),
      supabase.from("visa_cities").select("*").order("city_id", { ascending: true }),
      supabase.from("visa_ports").select("*").order("display_order", { ascending: true }),
      supabase.from("visa_city_policy_matrix").select("*"),
    ]);
    const firstErr = [pol, gr, ct, ci, po, mx].find((r) => r.error);
    if (firstErr) error.value = firstErr.error.message;
    policies.value = pol.data || [];
    grants.value = gr.data || [];
    countries.value = ct.data || [];
    cities.value = ci.data || [];
    ports.value = po.data || [];
    matrix.value = mx.data || [];
    loaded.value = true;
  }

  return { policies, grants, countries, cities, ports, matrix, loaded, error, loadAll };
});
