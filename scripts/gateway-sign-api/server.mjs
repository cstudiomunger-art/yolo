#!/usr/bin/env node
/**
 * Gateway media sign API — runs on ECS behind Nginx at /api/v1/media/sign
 *
 * Env:
 *   PORT=3001
 *   SUPABASE_URL=
 *   SUPABASE_ANON_KEY=            (preferred — JWT sets auth.uid for RPC)
 *   SUPABASE_SERVICE_ROLE_KEY=    (fallback if anon unset)
 *   OSS_ACCESS_KEY_ID=
 *   OSS_ACCESS_KEY_SECRET=
 *   OSS_PRIVATE_BUCKET=yolo-private-prod
 *   OSS_REGION=oss-cn-shanghai
 *   SIGN_EXPIRES_SEC=3600
 */
import http from "http";
import { createClient } from "@supabase/supabase-js";
import ws from "ws";
import OSS from "ali-oss";

const PORT = Number(process.env.PORT || 3001);
const EXPIRES = Number(process.env.SIGN_EXPIRES_SEC || 3600);
const supabaseUrl = process.env.SUPABASE_URL?.replace(/\/$/, "");
// Prefer anon key so user JWT sets auth.uid() for can_access_conversation RPC.
const apiKey = process.env.SUPABASE_ANON_KEY || process.env.SUPABASE_SERVICE_ROLE_KEY;
const privateBucket = process.env.OSS_PRIVATE_BUCKET || "yolo-private-prod";
const region = process.env.OSS_REGION || "oss-cn-shanghai";

function json(res, status, body) {
  const data = JSON.stringify(body);
  res.writeHead(status, {
    "Content-Type": "application/json",
    "Cache-Control": "private, no-store",
    "Content-Length": Buffer.byteLength(data),
  });
  res.end(data);
}

function parseBearer(req) {
  const h = req.headers.authorization || "";
  const m = /^Bearer\s+(.+)$/i.exec(h);
  return m?.[1]?.trim() || "";
}

function parsePath(query) {
  const raw = query.get("path")?.trim() || "";
  if (!raw || raw.includes("..") || raw.startsWith("/")) return null;
  // Expected: {convId}/{uuid}.jpg
  const parts = raw.split("/");
  if (parts.length < 2) return null;
  const convId = parts[0];
  if (!/^[0-9a-f-]{36}$/i.test(convId)) return null;
  return { objectPath: raw, convId };
}

function loadOSS() {
  const accessKeyId = process.env.OSS_ACCESS_KEY_ID;
  const accessKeySecret = process.env.OSS_ACCESS_KEY_SECRET;
  if (!accessKeyId || !accessKeySecret) throw new Error("missing OSS credentials");
  return new OSS({ region, bucket: privateBucket, accessKeyId, accessKeySecret });
}

async function canAccess(userClient, convId) {
  const { data, error } = await userClient.rpc("can_access_conversation", { conv: convId });
  if (error) throw error;
  return Boolean(data);
}

const server = http.createServer(async (req, res) => {
  try {
    const url = new URL(req.url || "/", `http://${req.headers.host || "localhost"}`);
    if (req.method === "GET" && url.pathname === "/health") {
      return json(res, 200, { ok: true });
    }
    if (req.method !== "GET" || url.pathname !== "/api/v1/media/sign") {
      return json(res, 404, { error: "not_found" });
    }
    if (!supabaseUrl || !apiKey) {
      return json(res, 500, { error: "server_misconfigured" });
    }

    const token = parseBearer(req);
    if (!token) return json(res, 401, { error: "missing_token" });

    const parsed = parsePath(url.searchParams);
    if (!parsed) return json(res, 400, { error: "invalid_path" });

    const userClient = createClient(supabaseUrl, apiKey, {
      auth: { persistSession: false, autoRefreshToken: false },
      realtime: { transport: ws },
      global: { headers: { Authorization: `Bearer ${token}` } },
    });

    const allowed = await canAccess(userClient, parsed.convId);
    if (!allowed) return json(res, 403, { error: "forbidden" });

    const oss = loadOSS();
    const ossKey = `chat-images/${parsed.objectPath}`;
    const urlSigned = oss.signatureUrl(ossKey, { expires: EXPIRES, method: "GET" });
    const expiresAt = new Date(Date.now() + EXPIRES * 1000).toISOString();
    return json(res, 200, { url: urlSigned, expiresAt, path: parsed.objectPath });
  } catch (e) {
    console.error(e);
    return json(res, 500, { error: "internal", message: String(e?.message ?? e) });
  }
});

server.listen(PORT, "127.0.0.1", () => {
  console.log(`gateway-sign-api listening on 127.0.0.1:${PORT}`);
});
