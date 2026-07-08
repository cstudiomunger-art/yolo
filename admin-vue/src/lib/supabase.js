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

// ═══════════════════════════════════════════════════════════════
// Admin Management Functions
// ═══════════════════════════════════════════════════════════════

/** Add an existing user as admin */
export async function addAdmin(userId, email) {
  const { data, error } = await supabase
    .from("admin_users")
    .insert({ user_id: userId, email })
    .select()
    .single();
  if (error) throw error;
  return data;
}

/** Remove admin privileges from a user */
export async function removeAdmin(userId) {
  const { data, error } = await supabase
    .from("admin_users")
    .delete()
    .eq("user_id", userId)
    .select();
  if (error) throw error;
  return data;
}

/** Create a new admin user (requires Edge Function) */
export async function createAdminUser(email, password) {
  const { data, error } = await supabase.functions.invoke("manage-admin", {
    body: { action: "create_user", email, password },
  });
  if (error) throw error;
  return data;
}

/** Add an existing user as admin (via Edge Function) */
export async function addExistingUserAsAdmin(userId, email) {
  const { data, error } = await supabase.functions.invoke("manage-admin", {
    body: { action: "add_existing_user", targetUserId: userId, targetEmail: email },
  });
  if (error) throw error;
  return data;
}

/** Check if a user is an admin */
export async function isAdmin(userId) {
  const { data, error } = await supabase
    .from("admin_users")
    .select("user_id")
    .eq("user_id", userId)
    .maybeSingle();
  if (error) throw error;
  return !!data;
}
