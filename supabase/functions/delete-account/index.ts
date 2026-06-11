import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.49.1";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

function json(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }
  if (req.method !== "POST") {
    return json({ error: "Method not allowed" }, 405);
  }

  const authHeader = req.headers.get("Authorization");
  if (!authHeader?.startsWith("Bearer ")) {
    return json({ error: "Unauthorized" }, 401);
  }

  const supabaseUrl = Deno.env.get("SUPABASE_URL");
  const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
  if (!supabaseUrl || !serviceRoleKey) {
    return json({ error: "Server misconfigured" }, 500);
  }

  const userClient = createClient(supabaseUrl, Deno.env.get("SUPABASE_ANON_KEY") ?? "", {
    global: { headers: { Authorization: authHeader } },
  });
  const { data: userData, error: userError } = await userClient.auth.getUser();
  if (userError || !userData.user) {
    return json({ error: "Unauthorized" }, 401);
  }

  const admin = createClient(supabaseUrl, serviceRoleKey);

  // 删除该用户的头像文件（avatars/{userId}/...）。失败不阻断删号。
  try {
    const { data: files } = await admin.storage.from("avatars").list(userData.user.id);
    if (files?.length) {
      await admin.storage
        .from("avatars")
        .remove(files.map((f) => `${userData.user.id}/${f.name}`));
    }
  } catch (_) {
    // 头像清理失败可忽略：账号仍会被删除。
  }

  const { error: deleteError } = await admin.auth.admin.deleteUser(userData.user.id);
  if (deleteError) {
    return json({ error: deleteError.message }, 500);
  }

  return json({ ok: true });
});
