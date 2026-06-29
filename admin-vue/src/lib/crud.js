import { supabase } from "@/lib/supabase";

/** Schema table key == DB table name for all content tables. */
export async function fetchList(tableKey, schema) {
  const orderCol = schema.order || schema.pk;
  let q = supabase.from(tableKey).select("*");
  if (orderCol) q = q.order(orderCol, { ascending: !schema.orderDesc });
  const { data, error } = await q;
  if (error) throw error;
  return data || [];
}

export async function fetchOne(tableKey, pk, id) {
  const { data, error } = await supabase.from(tableKey).select("*").eq(pk, id).maybeSingle();
  if (error) throw error;
  return data;
}

/** Single-row tables (app_settings, checklist_settings, …): fetch the one row. */
export async function fetchSingle(tableKey) {
  const { data, error } = await supabase.from(tableKey).select("*").limit(1).maybeSingle();
  if (error) throw error;
  return data;
}

export async function upsertRow(tableKey, payload) {
  const { data, error } = await supabase.from(tableKey).upsert(payload).select().maybeSingle();
  if (error) throw error;
  return data;
}

export async function deleteRow(tableKey, pk, id) {
  const { error } = await supabase.from(tableKey).delete().eq(pk, id);
  if (error) throw error;
}

/**
 * City filtering for flat list tables — mirror of core.js TABLE_CITY_FILTERS.
 * `attractionCity` maps an attraction_id → city_id (from refCache).
 */
const CITY_FILTERS = {
  attractions: { field: "city_id" },
  city_guides: { field: "city_id" },
  audio_guides: { field: "attraction_id", viaAttraction: true },
  sub_areas: { field: "attraction_id", viaAttraction: true },
  checklist_items: { field: "city_id", includeGlobal: true },
  home_tips: { field: "city_id", includeGlobal: true },
  shopping_items: { field: "city_id", includeGlobal: true },
  hotels: { field: "city_id" },
  city_hospitals: { field: "city_id" },
  city_embassies: { field: "city_id" },
};

export function hasCityFilter(tableKey) {
  return Boolean(CITY_FILTERS[tableKey]);
}

export function filterRowsByCity(tableKey, rows, cityId, attractionCity) {
  if (!cityId) return rows;
  const cfg = CITY_FILTERS[tableKey];
  if (!cfg) return rows;
  return rows.filter((r) => {
    if (cfg.viaAttraction) {
      return attractionCity(r[cfg.field]) === cityId;
    }
    const v = r[cfg.field];
    if (cfg.includeGlobal && (v == null || v === "")) return true;
    return v === cityId;
  });
}

/** Simple client-side text search across a row's string values. */
export function filterRowsBySearch(rows, search) {
  const s = (search || "").trim().toLowerCase();
  if (!s) return rows;
  return rows.filter((r) =>
    Object.values(r).some((v) => typeof v === "string" && v.toLowerCase().includes(s))
  );
}
