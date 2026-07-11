<script setup>
import { ref, computed, watch } from "vue";
import { storeToRefs } from "pinia";
import { useNav } from "@/stores/nav";
import { TABLES } from "@/schema/tables";
import { fetchOne } from "@/lib/crud";
import TablePane from "@/components/TablePane.vue";
import RecordForm from "@/components/RecordForm.vue";
import AttractionEditor from "@/components/AttractionEditor.vue";
import VisaWorkbench from "@/components/hubs/VisaWorkbench.vue";
import PricingHub from "@/components/hubs/PricingHub.vue";
import MembershipHub from "@/components/hubs/MembershipHub.vue";
import UsersHub from "@/components/hubs/UsersHub.vue";
import SupportWorkbench from "@/components/hubs/SupportWorkbench.vue";
import ChecklistWorkbench from "@/components/hubs/ChecklistWorkbench.vue";
import PaymentWorkbench from "@/components/hubs/PaymentWorkbench.vue";
import ImageManagerHub from "@/components/hubs/ImageManagerHub.vue";
import SchedulingWorkbench from "@/components/hubs/SchedulingWorkbench.vue";

const HUBS = {
  visa: VisaWorkbench,
  pricing: PricingHub,
  scheduling: SchedulingWorkbench,
  membership: MembershipHub,
  transactions: MembershipHub, // shares the membership hub (交易/退款 tabs)
  users: UsersHub,
  support: SupportWorkbench,
  checklist: ChecklistWorkbench,
  payment: PaymentWorkbench,
  images: ImageManagerHub,
};

const nav = useNav();
const { selection } = storeToRefs(nav);

const loadingRow = ref(false);
const row = ref(null);
const error = ref("");

const schema = computed(() =>
  selection.value.tableKey ? TABLES[selection.value.tableKey] : null
);

// for kind:'record' load the row by id
watch(
  selection,
  async (sel) => {
    error.value = "";
    row.value = null;
    if (sel.kind === "record" && sel.tableKey !== "attractions") {
      loadingRow.value = true;
      try {
        row.value = await fetchOne(sel.tableKey, TABLES[sel.tableKey].pk || "id", sel.id);
      } catch (e) {
        error.value = e.message || String(e);
      } finally {
        loadingRow.value = false;
      }
    }
  },
  { immediate: true }
);

function onSaved() {
  // re-fetch the edited record to reflect server state
  if (selection.value.kind === "record") {
    const sel = selection.value;
    fetchOne(sel.tableKey, TABLES[sel.tableKey].pk || "id", sel.id)
      .then((r) => (row.value = r))
      .catch(() => {});
  }
  nav.requestReload();
}

function onDeleted() {
  nav.requestReload();
  nav.select({ kind: "placeholder", label: "已删除 · ← 从左侧选择内容" });
}

// After creating a NEW record: switch into its edit view and refresh the tree
// so it appears immediately (no manual page refresh needed).
function onNewSaved(savedRow) {
  const sel = selection.value;
  const pk = TABLES[sel.tableKey]?.pk || "id";
  nav.requestReload();
  if (savedRow && savedRow[pk]) {
    nav.select({ kind: "record", tableKey: sel.tableKey, id: savedRow[pk] });
  }
}
</script>

<template>
  <div class="work">
    <div v-if="error" class="status-bar error">{{ error }}</div>

    <!-- list (optionally city-locked) -->
    <TablePane
      v-if="selection.kind === 'table'"
      :key="selection.tableKey + '|' + (selection.fixedCityId || '')"
      :table-key="selection.tableKey"
      :fixed-city-id="selection.fixedCityId || ''"
    />

    <!-- attraction record → 解说与详情 (main info + embedded main audio guide) -->
    <AttractionEditor
      v-else-if="selection.kind === 'record' && selection.tableKey === 'attractions'"
      :key="'attr-editor-' + selection.id"
      :attraction-id="selection.id"
    />

    <!-- edit existing record -->
    <template v-else-if="selection.kind === 'record'">
      <div v-if="loadingRow">加载中…</div>
      <RecordForm
        v-else-if="row"
        :key="selection.tableKey + '|' + selection.id"
        :table-key="selection.tableKey"
        :schema="schema"
        :initial="row"
        @saved="onSaved"
        @deleted="onDeleted"
        @cancel="() => {}"
      />
      <div v-else class="muted">未找到记录</div>
    </template>

    <!-- create new record -->
    <RecordForm
      v-else-if="selection.kind === 'new'"
      :key="'new|' + selection.tableKey"
      :table-key="selection.tableKey"
      :schema="schema"
      :initial="null"
      :presets="selection.presets || null"
      @saved="onNewSaved"
      @cancel="() => {}"
    />

    <!-- bespoke hubs -->
    <component v-else-if="selection.kind === 'hub' && HUBS[selection.hubId]" :is="HUBS[selection.hubId]" />

    <!-- placeholder / not-yet-built -->
    <div v-else class="placeholder">
      <p class="muted">{{ selection.label || "← 从左侧选择内容" }}</p>
    </div>
  </div>
</template>

<style scoped>
.work { max-width: 1100px; }
.muted { color: var(--muted); }
.placeholder { padding: 40px 0; }
</style>
