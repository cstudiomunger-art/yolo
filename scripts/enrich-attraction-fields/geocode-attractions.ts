/** Geocode attractions.name + city → lat/lng. Requires AMAP_KEY or similar in env. */
const SUPABASE_URL = Deno.env.get("SUPABASE_URL") ?? "";
const SUPABASE_KEY =
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? Deno.env.get("SUPABASE_ANON_KEY") ?? "";

if (import.meta.main) {
  console.log("geocode-attractions: stub — set AMAP_KEY and wire geocoder before production run");
  console.log({ hasSupabase: Boolean(SUPABASE_URL && SUPABASE_KEY) });
}
