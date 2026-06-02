import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
  "Access-Control-Allow-Headers": "authorization, content-type",
};

function jsonResponse(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}

// RevenueCat event types we handle
const HANDLED_EVENTS = new Set([
  "INITIAL_PURCHASE",
  "RENEWAL",
  "CANCELLATION",
  "EXPIRATION",
  "REFUND",
  "NON_RENEWING_PURCHASE",
]);

const ACTIVE_EVENTS = new Set(["INITIAL_PURCHASE", "RENEWAL", "NON_RENEWING_PURCHASE"]);
const INACTIVE_EVENTS = new Set(["CANCELLATION", "EXPIRATION", "REFUND"]);

interface RCEvent {
  type: string;
  app_user_id: string;
  aliases?: string[];
  product_id: string;
  period_type?: string;
  purchased_at_ms?: number;
  expiration_at_ms?: number | null;
  price?: number | null;
  currency?: string | null;
  transaction_id?: string;
  original_transaction_id?: string;
  store?: string;
}

interface RCPayload {
  event: RCEvent;
  api_version?: string;
}

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response(null, { status: 204, headers: corsHeaders });
  }

  if (req.method !== "POST") {
    return new Response("Method not allowed", { status: 405, headers: corsHeaders });
  }

  // Verify RevenueCat webhook authorization header
  const authHeader = req.headers.get("Authorization");
  const webhookSecret = Deno.env.get("RC_WEBHOOK_SECRET");
  if (webhookSecret && authHeader !== webhookSecret) {
    return new Response("Unauthorized", { status: 401, headers: corsHeaders });
  }

  const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
  );

  let payload: RCPayload;
  try {
    payload = await req.json();
  } catch {
    return jsonResponse({ error: "Invalid JSON" }, 400);
  }

  const event = payload.event;
  if (!event || !HANDLED_EVENTS.has(event.type)) {
    return jsonResponse({ ok: true, skipped: true });
  }

  // Resolve Supabase user UUID from RevenueCat app_user_id (we set RC appUserID = Supabase UUID)
  const appUserId = event.app_user_id;
  let userId: string | null = null;

  if (/^[0-9a-f-]{36}$/i.test(appUserId)) {
    userId = appUserId.toLowerCase();
  } else {
    for (const alias of event.aliases ?? []) {
      if (/^[0-9a-f-]{36}$/i.test(alias)) {
        userId = alias.toLowerCase();
        break;
      }
    }
  }

  if (!userId) {
    console.warn("Cannot resolve Supabase user from RC app_user_id:", appUserId);
    return jsonResponse({ ok: true, skipped: true, reason: "no_user_id" });
  }

  // Ensure profiles row exists (auto-created by trigger on signup, but RC may fire first)
  const { data: existingProfile } = await supabase
    .from("profiles")
    .select("id")
    .eq("id", userId)
    .limit(1);

  if (!existingProfile || existingProfile.length === 0) {
    // Create minimal profile so updates don't silently fail
    const { error: insertError } = await supabase
      .from("profiles")
      .insert({ id: userId, country_code: "GB" });
    if (insertError) {
      console.error("Failed to create profile for user", userId, insertError.message);
      return jsonResponse({ ok: false, error: "profile_insert_failed" }, 500);
    }
  }

  // Resolve plan_id from product_id
  const { data: planRows } = await supabase
    .from("membership_plans")
    .select("id")
    .eq("apple_product_id", event.product_id)
    .limit(1);

  const planId = planRows?.[0]?.id ?? null;

  // Build timestamps
  const purchasedAt = event.purchased_at_ms
    ? new Date(event.purchased_at_ms).toISOString()
    : new Date().toISOString();
  const expiresAt = event.expiration_at_ms
    ? new Date(event.expiration_at_ms).toISOString()
    : null;

  // Write transaction log (upsert on rc_transaction_id for idempotency)
  const rcTransactionId = event.transaction_id ?? `${appUserId}-${event.type}-${Date.now()}`;
  const { error: txError } = await supabase.from("user_iap_transactions").upsert(
    {
      user_id: userId,
      rc_transaction_id: rcTransactionId,
      apple_transaction_id: event.original_transaction_id ?? null,
      product_id: event.product_id,
      event_type: event.type,
      plan_id: planId,
      price_usd: event.price ?? null,
      currency: event.currency ?? null,
      purchased_at: purchasedAt,
      expires_at: expiresAt,
      raw_payload: payload,
    },
    { onConflict: "rc_transaction_id" }
  );

  if (txError) {
    console.error("Failed to write transaction", rcTransactionId, txError.message);
  }

  // Update profiles based on event type
  if (ACTIVE_EVENTS.has(event.type)) {
    const profilePatch: Record<string, unknown> = {
      is_pro: true,
      rc_customer_id: appUserId,
    };

    if (event.type !== "NON_RENEWING_PURCHASE") {
      // Subscription: set plan and expiry
      profilePatch.subscription_plan_id = planId;
      profilePatch.subscription_expires_at = expiresAt;
    }
    // NON_RENEWING_PURCHASE (single attraction): attraction unlock handled client-side after purchase

    const { error: profileError } = await supabase
      .from("profiles")
      .update(profilePatch)
      .eq("id", userId);
    if (profileError) {
      console.error("Failed to update profile (active)", userId, profileError.message);
    }
  } else if (INACTIVE_EVENTS.has(event.type)) {
    // Only clear subscription if no other active subscription exists
    const { data: activeRows } = await supabase
      .from("user_iap_transactions")
      .select("id")
      .eq("user_id", userId)
      .in("event_type", ["INITIAL_PURCHASE", "RENEWAL"])
      .gt("expires_at", new Date().toISOString())
      .limit(1);

    if (!activeRows || activeRows.length === 0) {
      const { error: profileError } = await supabase
        .from("profiles")
        .update({
          is_pro: false,
          subscription_plan_id: null,
          subscription_expires_at: null,
        })
        .eq("id", userId);
      if (profileError) {
        console.error("Failed to update profile (inactive)", userId, profileError.message);
      }
    }
  }

  return jsonResponse({ ok: true });
});
