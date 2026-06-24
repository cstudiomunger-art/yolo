<script setup>
import { ref } from "vue";
import { useRouter } from "vue-router";
import { useAuthStore } from "@/stores/auth";
import { useTheme } from "@/composables/useTheme";

const auth = useAuthStore();
const router = useRouter();
const { cycle } = useTheme();

const email = ref("");
const password = ref("");
const error = ref("");
const loading = ref(false);

async function onSubmit() {
  error.value = "";
  loading.value = true;
  try {
    await auth.login(email.value, password.value);
    router.push({ name: "dashboard" });
  } catch (e) {
    error.value = e?.message || "登录失败";
  } finally {
    loading.value = false;
  }
}
</script>

<template>
  <div class="login-wrap">
    <div class="login-card">
      <div class="login-header">
        <h1>YOLO HAPPY <span>CMS</span></h1>
        <button
          type="button"
          class="btn btn-secondary btn-sm"
          title="切换主题"
          @click="cycle"
        >
          ◐
        </button>
      </div>
      <p class="hint">使用 Supabase 管理员账号登录</p>

      <div v-if="error" class="status-bar error">{{ error }}</div>

      <form @submit.prevent="onSubmit">
        <label for="email">邮箱</label>
        <input id="email" v-model="email" type="email" autocomplete="username" required />

        <label for="password">密码</label>
        <input
          id="password"
          v-model="password"
          type="password"
          autocomplete="current-password"
          required
        />

        <button type="submit" class="btn submit" :disabled="loading">
          {{ loading ? "登录中…" : "登录" }}
        </button>
      </form>
    </div>
  </div>
</template>

<style scoped>
.login-wrap {
  height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 20px;
}
.login-card {
  width: 100%;
  max-width: 380px;
  background: var(--surface);
  border: 1px solid var(--border);
  border-radius: 12px;
  padding: 28px;
}
.login-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
}
.login-header h1 {
  font-size: 20px;
  margin: 0;
}
.login-header span {
  color: var(--accent);
}
.hint {
  color: var(--muted);
  font-size: 13px;
  margin: 8px 0 16px;
}
label {
  display: block;
  font-size: 13px;
  margin: 12px 0 6px;
  color: var(--muted);
}
.submit {
  width: 100%;
  margin-top: 18px;
}
.status-bar.error {
  margin-bottom: 12px;
}
</style>
