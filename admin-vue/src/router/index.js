import { createRouter, createWebHashHistory } from "vue-router";
import { useAuthStore } from "@/stores/auth";

const routes = [
  {
    path: "/login",
    name: "login",
    component: () => import("@/views/LoginView.vue"),
    meta: { public: true },
  },
  {
    path: "/",
    name: "app",
    component: () => import("@/components/AppShell.vue"),
  },
];

// Hash history keeps Cloudflare static-asset hosting trivial (no SPA fallback rules).
const router = createRouter({
  history: createWebHashHistory(),
  routes,
});

router.beforeEach(async (to) => {
  const auth = useAuthStore();
  if (!auth.ready) await auth.init();
  if (!to.meta.public && !auth.session) return { name: "login" };
  if (to.name === "login" && auth.session) return { name: "app" };
  return true;
});

export default router;
