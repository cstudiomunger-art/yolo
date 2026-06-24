import { defineStore } from "pinia";
import { ref } from "vue";
import { supabase, checkIsAdmin } from "@/lib/supabase";

export const useAuthStore = defineStore("auth", () => {
  const session = ref(null);
  const email = ref("");
  const ready = ref(false); // initial session restore finished

  /** Restore an existing Supabase session on app boot. */
  async function init() {
    const { data } = await supabase.auth.getSession();
    if (data.session) {
      const ok = await checkIsAdmin(data.session.user.id).catch(() => false);
      if (ok) {
        session.value = data.session;
        email.value = data.session.user.email || "";
      } else {
        await supabase.auth.signOut();
      }
    }
    ready.value = true;
  }

  async function login(emailInput, password) {
    const { data, error } = await supabase.auth.signInWithPassword({
      email: emailInput,
      password,
    });
    if (error) throw error;
    const ok = await checkIsAdmin(data.session.user.id);
    if (!ok) {
      await supabase.auth.signOut();
      throw new Error(
        "该账号不在 admin_users 表中，无法使用后台。请在 Supabase SQL 中添加管理员。"
      );
    }
    session.value = data.session;
    email.value = data.session.user.email || "";
  }

  async function logout() {
    await supabase.auth.signOut();
    session.value = null;
    email.value = "";
  }

  return { session, email, ready, init, login, logout };
});
