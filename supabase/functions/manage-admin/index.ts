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

async function cleanupUserAvatars(
  adminClient: ReturnType<typeof createClient>,
  targetUserId: string,
) {
  try {
    const { data: files } = await adminClient.storage.from("avatars").list(targetUserId);
    if (files?.length) {
      await adminClient.storage
        .from("avatars")
        .remove(files.map((f) => `${targetUserId}/${f.name}`));
    }
  } catch {
    // Avatar cleanup failure should not block account deletion.
  }
}

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }
  if (req.method !== "POST") {
    return json({ error: "Method not allowed" }, 405);
  }

  // Verify the caller is authenticated
  const authHeader = req.headers.get("Authorization");
  if (!authHeader?.startsWith("Bearer ")) {
    return json({ error: "Unauthorized" }, 401);
  }

  const supabaseUrl = Deno.env.get("SUPABASE_URL");
  const serviceRoleKey =
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? Deno.env.get("ADMIN_SERVICE_ROLE_KEY");
  const anonKey = Deno.env.get("SUPABASE_ANON_KEY");
  if (!supabaseUrl || !serviceRoleKey) {
    return json({ error: "Server misconfigured" }, 500);
  }

  // Create clients
  const userClient = createClient(supabaseUrl, anonKey ?? "", {
    global: { headers: { Authorization: authHeader } },
  });
  const adminClient = createClient(supabaseUrl, serviceRoleKey);

  // Verify caller is an admin
  const { data: userData, error: userError } = await userClient.auth.getUser();
  if (userError || !userData.user) {
    return json({ error: "Unauthorized" }, 401);
  }

  const userId = userData.user.id;
  const { data: isAdminCheck, error: adminCheckError } = await userClient
    .from("admin_users")
    .select("user_id")
    .eq("user_id", userId)
    .maybeSingle();

  if (adminCheckError || !isAdminCheck) {
    return json({ error: "Forbidden: admin access required" }, 403);
  }

  // Parse request body
  let body;
  try {
    body = await req.json();
  } catch {
    return json({ error: "Invalid JSON" }, 400);
  }

  const { action } = body;

  try {
    switch (action) {
      case "create_user": {
        // Create a new user and add them as admin
        const { email, password } = body;
        if (!email || !password) {
          return json({ error: "Email and password required" }, 400);
        }

        // Create the user
        const { data: newUser, error: createError } = await adminClient.auth.admin.createUser({
          email,
          password,
          email_confirm: true,
          user_metadata: { role: "admin" },
        });

        if (createError || !newUser.user) {
          return json({ error: createError?.message || "Failed to create user" }, 500);
        }

        // Add to admin_users table
        const { error: insertError } = await adminClient
          .from("admin_users")
          .insert({ user_id: newUser.user.id, email: newUser.user.email });

        if (insertError) {
          return json({ error: insertError.message }, 500);
        }

        return json({
          ok: true,
          user: {
            id: newUser.user.id,
            email: newUser.user.email,
          },
        });
      }

      case "add_existing_user": {
        // Add an existing user as admin
        const { targetUserId, targetEmail } = body;
        if (!targetUserId) {
          return json({ error: "User ID required" }, 400);
        }

        // Verify user exists in auth.users
        const { data: targetUser, error: targetError } = await adminClient.auth.admin.getUserById(
          targetUserId
        );

        if (targetError || !targetUser.user) {
          return json({ error: "User not found" }, 404);
        }

        // Add to admin_users table
        const { error: insertError } = await adminClient
          .from("admin_users")
          .insert({ user_id: targetUserId, email: targetUser.user.email });

        if (insertError) {
          if (insertError.code === "23505") {
            return json({ error: "User is already an admin" }, 409);
          }
          return json({ error: insertError.message }, 500);
        }

        return json({
          ok: true,
          user: {
            id: targetUser.user.id,
            email: targetUser.user.email,
          },
        });
      }

      case "remove_admin": {
        // Remove admin privileges from a user
        const { targetUserId } = body;
        if (!targetUserId) {
          return json({ error: "User ID required" }, 400);
        }

        // Prevent self-removal
        if (targetUserId === userId) {
          return json({ error: "Cannot remove your own admin access" }, 400);
        }

        const { error: deleteError } = await adminClient
          .from("admin_users")
          .delete()
          .eq("user_id", targetUserId);

        if (deleteError) {
          return json({ error: deleteError.message }, 500);
        }

        return json({ ok: true });
      }

      case "list_admins": {
        // List all admins
        const { data: admins, error: listError } = await userClient
          .from("admin_users")
          .select("user_id, email, created_at")
          .order("created_at", { ascending: false });

        if (listError) {
          return json({ error: listError.message }, 500);
        }

        return json({ ok: true, admins: admins || [] });
      }

      case "create_app_user": {
        const { email, password, display_name, country_code } = body;
        if (!email || !password) {
          return json({ error: "Email and password required" }, 400);
        }

        const { data: newUser, error: createError } = await adminClient.auth.admin.createUser({
          email,
          password,
          email_confirm: true,
        });

        if (createError || !newUser.user) {
          return json({ error: createError?.message || "Failed to create user" }, 500);
        }

        const profilePatch: Record<string, string | null> = {};
        if (typeof display_name === "string" && display_name.trim()) {
          profilePatch.display_name = display_name.trim();
        }
        if (typeof country_code === "string" && country_code.trim()) {
          profilePatch.country_code = country_code.trim().toUpperCase();
        }
        if (Object.keys(profilePatch).length) {
          const { error: profileError } = await adminClient
            .from("profiles")
            .update(profilePatch)
            .eq("id", newUser.user.id);
          if (profileError) {
            return json({ error: profileError.message }, 500);
          }
        }

        return json({
          ok: true,
          user: {
            id: newUser.user.id,
            email: newUser.user.email,
          },
        });
      }

      case "delete_app_user": {
        const { targetUserId } = body;
        if (!targetUserId) {
          return json({ error: "User ID required" }, 400);
        }
        if (targetUserId === userId) {
          return json({ error: "Cannot delete your own account" }, 400);
        }

        const { data: targetUser, error: targetError } = await adminClient.auth.admin.getUserById(
          targetUserId,
        );
        if (targetError || !targetUser.user) {
          return json({ error: "User not found" }, 404);
        }

        await cleanupUserAvatars(adminClient, targetUserId);

        const { error: deleteError } = await adminClient.auth.admin.deleteUser(targetUserId);
        if (deleteError) {
          return json({ error: deleteError.message }, 500);
        }

        return json({ ok: true });
      }

      default:
        return json({ error: "Unknown action" }, 400);
    }
  } catch (error) {
    return json({ error: error.message || "Internal server error" }, 500);
  }
});