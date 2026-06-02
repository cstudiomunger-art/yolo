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

interface ModerateRequest {
  userId: string;
  avatarPath: string;
}

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response(null, { status: 204, headers: corsHeaders });
  }

  if (req.method !== "POST") {
    return new Response("Method not allowed", { status: 405, headers: corsHeaders });
  }

  // Authenticate the caller: must be a valid Supabase session
  const bearerToken = req.headers.get("Authorization")?.replace("Bearer ", "");
  if (!bearerToken) {
    return new Response("Unauthorized", { status: 401, headers: corsHeaders });
  }

  // Use service role for all DB operations, but verify the caller's token first
  const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
  );

  const { data: { user }, error: authError } = await supabase.auth.getUser(bearerToken);
  if (authError || !user) {
    return new Response("Unauthorized", { status: 401, headers: corsHeaders });
  }

  let body: ModerateRequest;
  try {
    body = await req.json();
  } catch {
    return jsonResponse({ error: "Invalid JSON" }, 400);
  }

  const { userId, avatarPath } = body;
  if (!userId || !avatarPath) {
    return jsonResponse({ error: "Missing userId or avatarPath" }, 400);
  }

  // Normalise to lowercase — Swift UUID.uuidString is uppercase but Supabase auth.uid() is lowercase
  const normUserId = userId.toLowerCase();

  // A user can only trigger moderation for their own avatar
  if (user.id.toLowerCase() !== normUserId) {
    return new Response("Forbidden", { status: 403, headers: corsHeaders });
  }

  // Verify the avatarPath belongs to this user (path must start with userId/)
  if (!avatarPath.toLowerCase().startsWith(`${normUserId}/`)) {
    return new Response("Forbidden", { status: 403, headers: corsHeaders });
  }

  // Download the uploaded image
  const { data: fileData, error: downloadError } = await supabase.storage
    .from("avatars")
    .download(avatarPath);

  if (downloadError || !fileData) {
    await supabase.from("profiles").update({ avatar_status: "rejected" }).eq("id", normUserId);
    return jsonResponse({ ok: false, reason: "download_failed" });
  }

  const bytes = await fileData.arrayBuffer();

  // Check file size (max 2 MB)
  if (bytes.byteLength > 2 * 1024 * 1024) {
    await supabase.storage.from("avatars").remove([avatarPath]);
    await supabase.from("profiles").update({ avatar_status: "rejected", avatar_url: null }).eq("id", normUserId);
    return jsonResponse({ ok: false, reason: "file_too_large" });
  }

  // Validate magic bytes for JPEG / PNG / WebP
  const header = new Uint8Array(bytes, 0, 12);
  const isJpeg = header[0] === 0xff && header[1] === 0xd8;
  const isPng = header[0] === 0x89 && header[1] === 0x50 && header[2] === 0x4e && header[3] === 0x47;
  const isWebp =
    header[0] === 0x52 && header[1] === 0x49 && header[2] === 0x46 && header[3] === 0x46 &&
    header[8] === 0x57 && header[9] === 0x45 && header[10] === 0x42 && header[11] === 0x50;

  if (!isJpeg && !isPng && !isWebp) {
    await supabase.storage.from("avatars").remove([avatarPath]);
    await supabase.from("profiles").update({ avatar_status: "rejected", avatar_url: null }).eq("id", normUserId);
    return jsonResponse({ ok: false, reason: "invalid_format" });
  }

  // TODO: Integrate cloud content moderation (AWS Rekognition / Google Vision API)
  // when required for production. Basic format/size validation is sufficient for v1.

  // Mark as approved
  await supabase.from("profiles").update({ avatar_status: "approved" }).eq("id", normUserId);

  return jsonResponse({ ok: true, status: "approved" });
});
