<script setup>
import { ref, computed, onMounted } from "vue";
import { supabase } from "@/lib/supabase";

const profiles = ref([]);
const plans = ref([]);
const search = ref("");
const error = ref("");
const toast = ref("");
const editing = ref(null);
function showToast(m) { toast.value = m; setTimeout(() => (toast.value = ""), 1600); }

async function load() {
  error.value = "";
  const [pr, pl] = await Promise.all([
    supabase.from("profiles").select("id,email,display_name,subscription_plan_id,subscription_expires_at").order("email"),
    supabase.from("membership_plans").select("id,name_zh,name_en,plan_type").eq("plan_type", "subscription").order("display_order"),
  ]);
  if (pr.error) error.value = pr.error.message;
  profiles.value = pr.data || [];
  plans.value = pl.data || [];
}

const filtered = computed(() => {
  const q = search.value.trim().toLowerCase();
  if (!q) return profiles.value;
  return profiles.value.filter((p) =>
    (p.email || "").toLowerCase().includes(q) || (p.display_name || "").toLowerCase().includes(q)
  );
});

const planLabel = (id) => {
  const p = plans.value.find((x) => x.id === id);
  return p ? p.name_zh || p.name_en : id || "—";
};

function edit(p) {
  editing.value = {
    id: p.id,
    email: p.email,
    subscription_plan_id: p.subscription_plan_id || "",
    subscription_expires_at: (p.subscription_expires_at || "").slice(0, 10),
  };
}
async function save() {
  const e = editing.value;
  const patch = {
    subscription_plan_id: e.subscription_plan_id || null,
    subscription_expires_at: e.subscription_expires_at || null,
  };
  const { error: er } = await supabase.from("profiles").update(patch).eq("id", e.id);
  if (er) { showToast("失败：" + er.message); return; }
  editing.value = null;
  await load();
  showToast("已保存");
}

onMounted(load);
</script>

<template>
  <div class="uh">
    <h1>用户管理</h1>
    <div v-if="error" class="status-bar error">{{ error }}</div>

    <template v-if="editing">
      <div class="form-head">
        <h2>编辑订阅 · {{ editing.email }}</h2>
        <div>
          <button class="btn btn-secondary btn-sm" @click="editing = null">取消</button>
          <button class="btn btn-sm" @click="save">保存</button>
        </div>
      </div>
      <div class="fgrid">
        <label class="f">订阅计划
          <select v-model="editing.subscription_plan_id">
            <option value="">— 无 —</option>
            <option v-for="p in plans" :key="p.id" :value="p.id">{{ p.name_zh || p.name_en }}</option>
          </select>
        </label>
        <label class="f">到期日<input type="date" v-model="editing.subscription_expires_at" /></label>
      </div>
    </template>

    <template v-else>
      <div class="bar"><input v-model="search" class="search" placeholder="搜邮箱/昵称…" /><span class="muted">{{ filtered.length }} 人</span></div>
      <table class="data-table">
        <thead><tr><th>邮箱</th><th>昵称</th><th>订阅计划</th><th>到期</th></tr></thead>
        <tbody>
          <tr v-for="p in filtered" :key="p.id" class="click" @click="edit(p)">
            <td>{{ p.email }}</td>
            <td>{{ p.display_name || "—" }}</td>
            <td>{{ planLabel(p.subscription_plan_id) }}</td>
            <td>{{ (p.subscription_expires_at || "").slice(0, 10) || "—" }}</td>
          </tr>
          <tr v-if="!filtered.length"><td colspan="4" class="center muted">暂无用户</td></tr>
        </tbody>
      </table>
    </template>

    <div class="toast" :class="{ on: toast }">{{ toast }}</div>
  </div>
</template>

<style scoped>
.uh h1 { margin: 0 0 12px; font-size: 20px; }
.bar { display: flex; gap: 12px; align-items: center; margin-bottom: 12px; }
.bar .search { width: auto; min-width: 220px; }
.form-head { display: flex; justify-content: space-between; align-items: center; margin-bottom: 14px; }
.form-head h2 { margin: 0; font-size: 18px; }
.form-head .btn { margin-left: 8px; }
.fgrid { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; max-width: 560px; }
.f { display: block; font-size: 12px; color: var(--muted); }
.f input, .f select { margin-top: 4px; }
.data-table { width: 100%; border-collapse: collapse; font-size: 14px; }
.data-table th, .data-table td { text-align: left; padding: 8px 12px; border-bottom: 1px solid var(--border); }
.data-table th { color: var(--muted); font-size: 13px; }
.click { cursor: pointer; }
.click:hover { background: var(--surface2); }
.muted { color: var(--muted); }
.center { text-align: center; padding: 24px; }
.toast { position: fixed; bottom: 26px; left: 50%; transform: translateX(-50%); background: var(--text); color: var(--bg); padding: 10px 18px; border-radius: 8px; font-size: 13px; opacity: 0; pointer-events: none; transition: opacity 0.2s; z-index: 1100; }
.toast.on { opacity: 1; }
</style>
