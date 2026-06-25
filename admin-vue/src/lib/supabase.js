import { createClient } from "@supabase/supabase-js";

// Public anon / publishable key — safe to embed in the browser bundle. These
// committed fallbacks make CI / Cloudflare Workers Builds self-contained (no
// dashboard env vars needed). Local dev can still override via .env.local.
const FALLBACK_URL = "https://edwvrriuwzaaqznklrgi.supabase.co";
const FALLBACK_ANON_KEY = "sb_publishable_b4CZMaImh7KsCVx_uufaGw_h3-HEZPZ";

const url = import.meta.env.VITE_SUPABASE_URL || FALLBACK_URL;
const anonKey = import.meta.env.VITE_SUPABASE_ANON_KEY || FALLBACK_ANON_KEY;

export const supabase = createClient(url, anonKey, {
  auth: {
    persistSession: true,
    autoRefreshToken: true,
    detectSessionInUrl: true,
  },
});

/** Mirror of the old core.js admin_users membership check. */
export async function checkIsAdmin(userId) {
  const { data, error } = await supabase
    .from("admin_users")
    .select("user_id")
    .eq("user_id", userId)
    .maybeSingle();
  if (error) throw error;
  return !!data;
}
