<script setup>
import { ref, reactive } from "vue";
import { useNav } from "@/stores/nav";
import { useRefCache } from "@/stores/refCache";
import { TABLES } from "@/schema/tables";
import { supabase } from "@/lib/supabase";

const nav = useNav();
const refCache = useRefCache();

// ---- accordion state (one open per level) ----
const openGroup = ref("cities"); // top-level group id ('cities' or a group key)
const openCity = ref(null);
const attractionsOpen = ref(false); // 景点 node under the open city
const openAttraction = ref(null);
const attrPanel = ref(null); // 'sub' | 'audio' | null — accordion under the open attraction

// ---- lazy caches ----
const attractionsByCity = reactive({});
const subAreasByAttraction = reactive({});
const loading = reactive({});

// city-level panels → each opens that table filtered to the city (城市概览 edits the city row)
const CITY_PANELS = [
  { id: "overview", label: "城市概览" },
  { id: "city_guides", label: "城市指南", table: "city_guides" },
  { id: "hotels", label: "酒店", table: "hotels" },
  { id: "checklist_items", label: "行前清单", table: "checklist_items" },
  { id: "home_tips", label: "首页提示", table: "home_tips" },
  { id: "shopping_items", label: "购物清单", table: "shopping_items" },
  { id: "reading_list", label: "阅读清单", table: "reading_list" },
  { id: "city_audio", label: "音频导览（城市）", table: "city_guides" },
];

// other top-level groups (label → leaves). table leaves use the generic engine;
// leaves whose table isn't in the schema are bespoke hubs (placeholder for now).
const GROUPS = [
  { id: "users", label: "用户", leaves: [{ label: "用户管理", hubId: "users" }] },
  { id: "membership", label: "会员与购买", leaves: [
    { label: "👑 会员计划", hubId: "membership" },
    { label: "🏷️ 景点定价", hubId: "pricing" },
    { label: "💳 购买记录", hubId: "transactions" },
  ] },
  { id: "config", label: "全局配置", leaves: [
    { label: "应用配置", table: "app_settings" },
    { label: "紧急联系", table: "emergency_config" },
  ] },
  { id: "assistant", label: "助手", leaves: [
    { label: "助手场景", table: "assistant_scenarios" },
    { label: "助手芯片", table: "assistant_chips" },
    { label: "助手回复", table: "assistant_replies" },
  ] },
  { id: "culture", label: "文化", leaves: [{ label: "文化贴士", table: "culture_tips" }] },
  { id: "visa", label: "🛂 签证引擎 v2", leaves: [
    { label: "🛂 签证工作台", hubId: "visa" },
    { label: "护照国家（国籍）", table: "passport_countries" },
    { label: "国家受控词表", table: "visa_countries" },
    { label: "城市维表", table: "visa_cities" },
    { label: "口岸维表", table: "visa_ports" },
    { label: "许可区", table: "visa_permit_zones" },
    { label: "城市×政策矩阵", table: "visa_city_policy_matrix" },
    { label: "引擎参数", table: "visa_config" },
  ] },
  { id: "payment", label: "💳 支付助手", leaves: [
    { label: "支付建议规则", table: "payment_advice_rules" },
    { label: "商家短语", table: "payment_merchant_phrases" },
    { label: "外链", table: "payment_helper_links" },
  ] },
  { id: "support", label: "💬 客服管理", leaves: [
    { label: "客服坐席", table: "support_agents" },
    { label: "会话监控", table: "support_conversations" },
    { label: "消息监控", table: "support_messages" },
  ] },
  { id: "practical", label: "🧭 实用信息", leaves: [
    { label: "交通攻略", table: "transport_tips" },
    { label: "常用语", table: "common_phrases" },
    { label: "方言彩蛋", table: "dialect_phrases" },
  ] },
  { id: "tools", label: "工具 · 跨城", leaves: [
    { label: "行程模板", table: "content_itineraries" },
    { label: "全表：城市", table: "cities" },
    { label: "全表：景点", table: "attractions" },
    { label: "全表：音频导览", table: "audio_guides" },
    { label: "用户行程", table: "user_itineraries" },
  ] },
];

function toggleGroup(id) {
  openGroup.value = openGroup.value === id ? null : id;
}

async function toggleCity(city) {
  if (openCity.value === city.id) {
    openCity.value = null;
    return;
  }
  openCity.value = city.id;
  attractionsOpen.value = false;
  openAttraction.value = null;
  attrPanel.value = null;
}

async function toggleAttractions(cityId) {
  attractionsOpen.value = !attractionsOpen.value;
  openAttraction.value = null;
  attrPanel.value = null;
  if (attractionsOpen.value && !attractionsByCity[cityId]) {
    loading[`c:${cityId}`] = true;
    const { data } = await supabase
      .from("attractions").select("id,city_id,name,chinese_name,display_order")
      .eq("city_id", cityId).order("display_order");
    attractionsByCity[cityId] = data || [];
    loading[`c:${cityId}`] = false;
  }
}

async function toggleAttraction(a) {
  if (openAttraction.value === a.id) {
    openAttraction.value = null;
    attrPanel.value = null;
    return;
  }
  openAttraction.value = a.id;
  attrPanel.value = null;
}

async function toggleSub(attractionId) {
  attrPanel.value = attrPanel.value === "sub" ? null : "sub"; // accordion with 音频导览
  if (attrPanel.value === "sub" && !subAreasByAttraction[attractionId]) {
    loading[`a:${attractionId}`] = true;
    const { data } = await supabase
      .from("sub_areas").select("id,attraction_id,name_en,sort_order")
      .eq("attraction_id", attractionId).order("sort_order");
    subAreasByAttraction[attractionId] = data || [];
    loading[`a:${attractionId}`] = false;
  }
}


function pickPanel(cityId, panel) {
  if (panel.id === "overview") nav.select({ kind: "record", tableKey: "cities", id: cityId });
  else nav.select({ kind: "table", tableKey: panel.table, fixedCityId: cityId });
}
function newCity() {
  nav.select({ kind: "new", tableKey: "cities" });
}
function newAttraction(cityId) {
  nav.select({ kind: "new", tableKey: "attractions", presets: { city_id: cityId } });
}
function pickAttraction(a) {
  nav.select({ kind: "record", tableKey: "attractions", id: a.id });
}
function newSubArea(attractionId) {
  nav.select({ kind: "new", tableKey: "sub_areas", presets: { attraction_id: attractionId } });
}
function pickSubArea(sa) {
  nav.select({ kind: "record", tableKey: "sub_areas", id: sa.id });
}
function pickLeaf(leaf) {
  if (leaf.hubId) nav.select({ kind: "hub", hubId: leaf.hubId });
  else if (leaf.table && TABLES[leaf.table]) nav.select({ kind: "table", tableKey: leaf.table });
  else nav.select({ kind: "placeholder", label: `「${leaf.label}」待迁移` });
}

function isActive(sel) {
  const s = nav.selection;
  return Object.keys(sel).every((k) => s[k] === sel[k]);
}
</script>

<template>
  <div class="tree">
    <!-- 城市 group (the nested tree) -->
    <div class="grp">
      <button class="grp-head" @click="toggleGroup('cities')">
        <span class="caret" :class="{ open: openGroup === 'cities' }">▶</span> 城市
      </button>
      <div v-show="openGroup === 'cities'" class="grp-body">
        <button class="leaf new" @click="newCity">＋ 新建城市</button>

        <div v-for="c in refCache.cities" :key="c.id" class="node">
          <button class="row lvl1" @click="toggleCity(c)">
            <span class="caret" :class="{ open: openCity === c.id }">▶</span>
            {{ (c.emoji || "") + " " + (c.chinese_name || c.name) }}
          </button>

          <div v-show="openCity === c.id" class="children">
            <!-- city panels -->
            <button
              v-for="p in CITY_PANELS"
              :key="p.id"
              class="row lvl2 leaf"
              :class="{ active: p.id === 'overview'
                ? isActive({ kind: 'record', tableKey: 'cities', id: c.id })
                : isActive({ kind: 'table', tableKey: p.table, fixedCityId: c.id }) }"
              @click="pickPanel(c.id, p)"
            >
              {{ p.label }}
            </button>

            <!-- 景点 -->
            <button class="row lvl2" @click="toggleAttractions(c.id)">
              <span class="caret" :class="{ open: attractionsOpen }">▶</span>
              景点 <span class="muted">({{ (attractionsByCity[c.id] || []).length }})</span>
            </button>
            <div v-show="attractionsOpen" class="children">
              <button class="leaf new lvl3" @click="newAttraction(c.id)">＋ 新建景点</button>
              <div v-if="loading[`c:${c.id}`]" class="muted lvl3">加载中…</div>
              <div v-for="a in attractionsByCity[c.id] || []" :key="a.id" class="node">
                <button class="row lvl3" @click="toggleAttraction(a)">
                  <span class="caret" :class="{ open: openAttraction === a.id }">▶</span>
                  {{ a.chinese_name || a.name }}
                </button>
                <div v-show="openAttraction === a.id" class="children">
                  <button
                    class="row lvl4 leaf"
                    :class="{ active: isActive({ kind: 'record', tableKey: 'attractions', id: a.id }) }"
                    @click="pickAttraction(a)"
                  >解说与详情</button>

                  <button class="row lvl4" @click="toggleSub(a.id)">
                    <span class="caret" :class="{ open: attrPanel === 'sub' }">▶</span>
                    子区域 <span class="muted">({{ (subAreasByAttraction[a.id] || []).length }})</span>
                  </button>
                  <div v-show="attrPanel === 'sub'" class="children">
                    <button class="leaf new lvl5" @click="newSubArea(a.id)">＋ 新建子区域</button>
                    <div v-if="loading[`a:${a.id}`]" class="muted lvl5">加载中…</div>
                    <button
                      v-for="sa in subAreasByAttraction[a.id] || []"
                      :key="sa.id"
                      class="row lvl5 leaf"
                      :class="{ active: isActive({ kind: 'record', tableKey: 'sub_areas', id: sa.id }) }"
                      @click="pickSubArea(sa)"
                    >{{ sa.name_en }}</button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- other top-level groups -->
    <div v-for="g in GROUPS" :key="g.id" class="grp">
      <button class="grp-head" @click="toggleGroup(g.id)">
        <span class="caret" :class="{ open: openGroup === g.id }">▶</span> {{ g.label }}
      </button>
      <div v-show="openGroup === g.id" class="grp-body">
        <button
          v-for="(leaf, i) in g.leaves"
          :key="i"
          class="row lvl1 leaf"
          :class="{ active: (leaf.hubId && isActive({ kind: 'hub', hubId: leaf.hubId })) || (leaf.table && isActive({ kind: 'table', tableKey: leaf.table })) }"
          @click="pickLeaf(leaf)"
        >
          {{ leaf.label }}
        </button>
      </div>
    </div>
  </div>
</template>

<style scoped>
.tree { font-size: 14px; }
.grp { margin-bottom: 2px; }
.grp-head {
  width: 100%; text-align: left; background: transparent; border: none;
  color: var(--text); font-weight: 600; padding: 8px 10px; cursor: pointer;
  display: flex; align-items: center; gap: 6px;
}
.grp-body { padding-bottom: 4px; }
.row, .leaf {
  width: 100%; text-align: left; background: transparent; border: none;
  color: var(--text); padding: 6px 10px; cursor: pointer; border-radius: 6px;
  display: flex; align-items: center; gap: 6px;
}
.row:hover, .leaf:hover { background: var(--surface2); }
.leaf.active, .row.active { background: var(--surface2); border-left: 3px solid var(--accent); }
.new { color: var(--accent); font-weight: 600; }
.caret {
  display: inline-block; font-size: 9px; transition: transform 0.12s;
  color: var(--muted); width: 10px;
}
.caret.open { transform: rotate(90deg); }
.muted { color: var(--muted); font-size: 12px; }
.lvl1 { padding-left: 12px; }
.lvl2 { padding-left: 28px; }
.lvl3 { padding-left: 44px; }
.lvl4 { padding-left: 60px; }
.lvl5 { padding-left: 76px; }
.children { display: block; }
</style>
