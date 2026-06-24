<script setup>
import { onMounted } from "vue";
import { useRouter } from "vue-router";
import { useAuthStore } from "@/stores/auth";
import { useRefCache } from "@/stores/refCache";
import { useTheme } from "@/composables/useTheme";
import TreeNav from "@/components/TreeNav.vue";
import WorkArea from "@/components/WorkArea.vue";

const auth = useAuthStore();
const router = useRouter();
const refCache = useRefCache();
const { cycle } = useTheme();

onMounted(() => refCache.load());

async function onLogout() {
  await auth.logout();
  router.push({ name: "login" });
}
</script>

<template>
  <!--
    Sidebar (nested tree) and main work area are SEPARATE scroll containers
    (each overflow-y:auto) so they never scroll together — fixes the legacy 同步滑动.
  -->
  <div class="shell">
    <aside class="sidebar">
      <div class="brand">
        YOLO <span>HAPPY</span> CMS
        <button type="button" class="btn btn-secondary btn-sm theme" title="切换主题" @click="cycle">◐</button>
      </div>
      <div class="nav-scroll">
        <TreeNav />
      </div>
      <div class="footer">
        <div class="email">{{ auth.email }}</div>
        <button type="button" class="btn btn-secondary btn-sm logout" @click="onLogout">退出</button>
      </div>
    </aside>

    <main class="main">
      <WorkArea />
    </main>
  </div>
</template>

<style scoped>
.shell {
  display: flex;
  height: 100vh;
  overflow: hidden;
}
.sidebar {
  width: 300px;
  flex-shrink: 0;
  display: flex;
  flex-direction: column;
  background: var(--surface);
  border-right: 1px solid var(--border);
}
.brand {
  padding: 16px;
  font-weight: 700;
  font-size: 15px;
  border-bottom: 1px solid var(--border);
  display: flex;
  align-items: center;
  gap: 8px;
}
.brand span { color: var(--accent); }
.brand .theme { margin-left: auto; }
.nav-scroll {
  flex: 1;
  overflow-y: auto;
  padding: 8px 4px;
}
.footer {
  padding: 12px;
  border-top: 1px solid var(--border);
}
.email { font-size: 12px; color: var(--muted); margin-bottom: 8px; word-break: break-all; }
.logout { width: 100%; }
.main {
  flex: 1;
  min-width: 0;
  overflow-y: auto;
  padding: 24px;
}
</style>
