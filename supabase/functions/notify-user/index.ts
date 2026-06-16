import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

// Sends an APNs push to all of a user's device tokens. Called by the web/support
// console after an agent replies, so users get notified while the app is closed.
// Requires these Edge Function secrets (set in Supabase Dashboard → Functions):
//   APNS_KEY_P8     — contents of the AuthKey_XXXX.p8 (PEM, incl. BEGIN/END lines)
//   APNS_KEY_ID     — the key id (10 chars)
//   APNS_TEAM_ID    — Apple developer Team ID (10 chars)
//   APNS_BUNDLE_ID  — com.chengduyuliu.yolohappy
//   APNS_HOST       — api.push.apple.com (prod) or api.sandbox.push.apple.com (dev)

const cors: Record<string, string> = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

function json(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), { status, headers: { ...cors, "Content-Type": "application/json" } });
}

function b64url(bytes: Uint8Array): string {
  let s = btoa(String.fromCharCode(...bytes));
  return s.replace(/\+/g, "-").replace(/\//g, "_").replace(/=+$/, "");
}

function pemToDer(pem: string): Uint8Array {
  const body = pem.replace(/-----BEGIN [^-]+-----/g, "").replace(/-----END [^-]+-----/g, "").replace(/\s+/g, "");
  const bin = atob(body);
  return Uint8Array.from(bin, (c) => c.charCodeAt(0));
}

let cachedJwt: { token: string; at: number } | null = null;

async function apnsJwt(): Promise<string> {
  // APNs tokens are valid up to 60 min; reuse for ~50.
  if (cachedJwt && Date.now() - cachedJwt.at < 50 * 60 * 1000) return cachedJwt.token;

  const keyId = Deno.env.get("APNS_KEY_ID") ?? "";
  const teamId = Deno.env.get("APNS_TEAM_ID") ?? "";
  const p8 = Deno.env.get("APNS_KEY_P8") ?? "";
  if (!keyId || !teamId || !p8) throw new Error("APNs secrets not configured");

  const header = b64url(new TextEncoder().encode(JSON.stringify({ alg: "ES256", kid: keyId })));
  const payload = b64url(new TextEncoder().encode(JSON.stringify({ iss: teamId, iat: Math.floor(Date.now() / 1000) })));
  const signingInput = `${header}.${payload}`;

  const key = await crypto.subtle.importKey(
    "pkcs8", pemToDer(p8), { name: "ECDSA", namedCurve: "P-256" }, false, ["sign"],
  );
  const sig = new Uint8Array(await crypto.subtle.sign(
    { name: "ECDSA", hash: "SHA-256" }, key, new TextEncoder().encode(signingInput),
  ));
  const token = `${signingInput}.${b64url(sig)}`;
  cachedJwt = { token, at: Date.now() };
  return token;
}

serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: cors });
  try {
    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const serviceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const anonKey = Deno.env.get("SUPABASE_ANON_KEY")!;

    // Caller must be a support agent.
    const authHeader = req.headers.get("Authorization") ?? "";
    const callerClient = createClient(supabaseUrl, anonKey, { global: { headers: { Authorization: authHeader } } });
    const { data: userData } = await callerClient.auth.getUser();
    const callerId = userData?.user?.id;
    if (!callerId) return json({ error: "unauthorized" }, 401);

    const admin = createClient(supabaseUrl, serviceKey);
    const { data: agentRows } = await admin.from("support_agents").select("id").eq("user_id", callerId).limit(1);
    if (!agentRows || agentRows.length === 0) return json({ error: "not an agent" }, 403);

    const body = await req.json().catch(() => ({}));
    const userId = String(body.user_id ?? "");
    const title = String(body.title ?? "ChinaGo");
    const message = String(body.body ?? "");
    if (!userId) return json({ error: "user_id required" }, 400);

    const { data: tokens } = await admin.from("device_tokens").select("token").eq("user_id", userId);
    if (!tokens || tokens.length === 0) return json({ sent: 0 });

    const jwt = await apnsJwt();
    const host = Deno.env.get("APNS_HOST") ?? "api.push.apple.com";
    const bundle = Deno.env.get("APNS_BUNDLE_ID") ?? "com.chengduyuliu.yolohappy";
    const payload = JSON.stringify({ aps: { alert: { title, body: message }, sound: "default", "mutable-content": 1 } });

    let sent = 0;
    await Promise.all((tokens as { token: string }[]).map(async (t) => {
      try {
        const res = await fetch(`https://${host}/3/device/${t.token}`, {
          method: "POST",
          headers: { authorization: `bearer ${jwt}`, "apns-topic": bundle, "apns-push-type": "alert" },
          body: payload,
        });
        if (res.ok) sent++;
      } catch (_) { /* ignore individual failures */ }
    }));

    return json({ sent });
  } catch (err) {
    console.error("notify-user error:", err);
    return json({ error: err instanceof Error ? err.message : "error" }, 500);
  }
});
