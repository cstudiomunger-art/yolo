<script setup>
import { ref, computed, reactive, onMounted } from "vue";
import { useVisa } from "@/stores/visa";
import { supabase } from "@/lib/supabase";

const visa = useVisa();
const tab = ref("grant");
const toast = ref("");

// policy_type → which editor sections to show
const TYPES = {
  "互免": ["stay", "area", "entry"],
  "单方面免签": ["stay", "area", "entry"],
  "过境免签": ["stay", "area", "ports", "onward", "entry"],
  "区域免签": ["stay", "area", "entry"],
  "团体免签": ["stay", "area", "group", "entry"],
  "普通签证": ["info"],
};
const ENTRY_COUNTS = ["single", "double", "multiple", "per_entry"];

function showToast(m) {
  toast.value = m;
  setTimeout(() => (toast.value = ""), 1800);
}
const asArray = (v) => (Array.isArray(v) ? v : []);
const gkey = (p, c) => p + "|" + c;

onMounted(async () => {
  if (!visa.loaded) await visa.loadAll();
});

const memberPolicies = computed(() => visa.policies.filter((p) => p.node_kind === "computed"));
const grantMap = computed(() => {
  const m = {};
  visa.grants.forEach((g) => (m[gkey(g.policy_id, g.country_code)] = g));
  return m;
});
const activeGrantCount = computed(() => visa.grants.filter((g) => g.is_active !== false).length);

// ───────── ① grant matrix ─────────
const gQuery = ref("");
const gPolicyFilter = ref("");

const matrixRows = computed(() => {
  const q = gQuery.value.trim().toLowerCase();
  const fp = gPolicyFilter.value;
  return visa.countries.filter((ct) => {
    const match = !q || (ct.name_zh || "").toLowerCase().includes(q) ||
      (ct.country_code || "").toLowerCase().includes(q) || (ct.name_en || "").toLowerCase().includes(q);
    if (!match) return false;
    if (fp) {
      const g0 = grantMap.value[gkey(fp, ct.country_code)];
      if (!g0 || g0.is_active === false) return false;
    }
    return true;
  });
});

async function toggleGrant(pid, cc, on) {
  const g = grantMap.value[gkey(pid, cc)];
  let err;
  if (g) {
    ({ error: err } = await supabase.from("visa_policy_grants_v2").update({ is_active: on }).eq("id", g.id));
  } else if (on) {
    const id = `${pid}_${cc}`.toLowerCase();
    ({ error: err } = await supabase.from("visa_policy_grants_v2").upsert(
      { id, policy_id: pid, country_code: cc, effective_date: "1900-01-01", is_active: true },
      { onConflict: "id" }
    ));
  }
  if (err) return showToast("失败：" + err.message);
  await visa.loadAll();
}

// grant editor modal
const grantEdit = ref(null); // { policy, country, form }
function openGrant(pid, cc) {
  const g = grantMap.value[gkey(pid, cc)];
  if (!g) return showToast("先勾选该国，再编辑");
  const policy = visa.policies.find((x) => x.id === pid);
  const country = visa.countries.find((x) => x.country_code === cc);
  grantEdit.value = {
    policy, country, id: g.id,
    form: {
      max_stay_override: g.max_stay_override ?? "",
      entry_count_override: g.entry_count_override || "",
      effective_date: g.effective_date || "",
      expiry_date: g.expiry_date || "",
      announced_date: g.announced_date || "",
      last_verified: g.last_verified || "",
      source_url: g.source_url || "",
      evidence_quote: g.evidence_quote || "",
    },
  };
}
async function saveGrant() {
  const f = grantEdit.value.form;
  const patch = {
    max_stay_override: f.max_stay_override !== "" ? Number(f.max_stay_override) : null,
    entry_count_override: f.entry_count_override || null,
    effective_date: f.effective_date || null,
    expiry_date: f.expiry_date || null,
    announced_date: f.announced_date || null,
    last_verified: f.last_verified || null,
    source_url: f.source_url || null,
    evidence_quote: f.evidence_quote || null,
  };
  const { error } = await supabase.from("visa_policy_grants_v2").update(patch).eq("id", grantEdit.value.id);
  if (error) return showToast("失败：" + error.message);
  await visa.loadAll();
  grantEdit.value = null;
  showToast("已保存");
}
async function disableGrant() {
  const { policy, country } = grantEdit.value;
  await toggleGrant(policy.id, country.country_code, false);
  grantEdit.value = null;
}

// ───────── ② policy editor ─────────
const curIdx = ref(0);
const curPolicy = computed(() => visa.policies[curIdx.value] || null);
const sections = computed(() => (curPolicy.value ? TYPES[curPolicy.value.policy_type] || ["stay", "area"] : []));
const areaMode = computed(() => (curPolicy.value?.allowed_area === "national" ? "national" : "list"));

const cityName = (code) => visa.cities.find((c) => c.city_id === code)?.name_zh || "?";
const portName = (code) => visa.ports.find((p) => p.code === code)?.name_zh || "?";

function setP(field, value) {
  if (curPolicy.value) curPolicy.value[field] = value;
}
function setArea(mode) {
  curPolicy.value.allowed_area = mode === "national" ? "national" : asArray(curPolicy.value.allowed_area);
}
function rmCode(field, code) {
  curPolicy.value[field] = asArray(curPolicy.value[field]).filter((x) => x !== code);
}
function pushCode(field, code) {
  const a = asArray(curPolicy.value[field]);
  if (!a.includes(code)) a.push(code);
  curPolicy.value[field] = [...a];
}
function togglePurpose(v, on) {
  let a = asArray(curPolicy.value.purpose);
  curPolicy.value.purpose = on ? [...new Set([...a, v])] : a.filter((x) => x !== v);
}

const CONDS = [
  ["onward_ticket", "需续程客票", "onward"],
  ["onward_third_country", "需前往第三国", "onward"],
  ["group_required", "需随团", "group"],
  ["entry_port_limited", "限定口岸", "ports"],
];
const visibleConds = computed(() => CONDS.filter((c) => sections.value.includes(c[2])));
const PURPOSES = [["tourism", "旅游"], ["business", "商务"], ["transit", "过境"], ["family", "探亲"]];

async function savePolicy() {
  const p = curPolicy.value;
  const patch = {
    policy_type: p.policy_type, official_name_zh: p.official_name_zh, official_name_en: p.official_name_en,
    entry_count: p.entry_count, max_stay_default: p.max_stay_default, max_stay_unit: p.max_stay_unit,
    clock_rule: p.clock_rule, allowed_area: p.allowed_area, entry_ports: p.entry_ports, exit_ports: p.exit_ports,
    onward_ticket: !!p.onward_ticket, onward_third_country: !!p.onward_third_country, group_required: !!p.group_required,
    entry_port_limited: !!p.entry_port_limited, passport_ordinary_only: !!p.passport_ordinary_only, purpose: p.purpose,
    source_url: p.source_url, last_verified: p.last_verified || null,
  };
  const { error } = await supabase.from("visa_policies_v2").update(patch).eq("id", p.id);
  if (error) return showToast("失败：" + error.message);
  await visa.loadAll();
  showToast("政策已保存");
}

// chip picker modal
const picker = ref(null); // { title, items:[{code,label,sub}], field }
function pickArea() {
  picker.value = {
    title: "选停留区域（GB/T 2260）", field: "allowed_area",
    items: visa.cities.map((c) => ({ code: c.city_id, label: c.name_zh, sub: c.city_id })),
  };
}
function pickPort(field) {
  picker.value = {
    title: "选" + (field === "entry_ports" ? "入境" : "出境") + "口岸", field,
    items: visa.ports.map((o) => ({ code: o.code, label: o.name_zh, sub: o.code })),
  };
}
const pickerQuery = ref("");
const pickerItems = computed(() => {
  if (!picker.value) return [];
  const q = pickerQuery.value.trim().toLowerCase();
  return picker.value.items.filter((it) => !q || it.label.toLowerCase().includes(q) || it.code.toLowerCase().includes(q));
});
function pickerSelected(code) {
  return asArray(curPolicy.value[picker.value.field]).includes(code);
}
function pickerPick(code) {
  if (!pickerSelected(code)) pushCode(picker.value.field, code);
}

// ───────── ③ city matrix ─────────
const matrixMap = computed(() => {
  const mm = {};
  visa.matrix.forEach((m) => (mm[m.city_id + "|" + m.policy_id] = m.feasibility));
  return mm;
});

// ───────── ④ snapshot ─────────
const snapshot = computed(() =>
  JSON.stringify(
    { policies: visa.policies, grants: visa.grants.filter((g) => g.is_active !== false) },
    null, 2
  )
);
</script>

<template>
  <div class="vh">
    <div class="head">
      <h1>🛂 签证工作台</h1>
      <span class="prog">已配置 grant {{ activeGrantCount }} · 国家 {{ visa.countries.length }} · 政策 {{ visa.policies.length }}</span>
    </div>
    <div v-if="visa.error" class="status-bar error">{{ visa.error }}</div>

    <div class="tabs">
      <button :class="{ on: tab === 'grant' }" @click="tab = 'grant'">① 国别核对</button>
      <button :class="{ on: tab === 'policy' }" @click="tab = 'policy'">② 政策定义</button>
      <button :class="{ on: tab === 'city' }" @click="tab = 'city'">③ 城市可达</button>
      <button :class="{ on: tab === 'snap' }" @click="tab = 'snap'">④ 快照</button>
    </div>

    <!-- ① grant matrix -->
    <section v-show="tab === 'grant'">
      <div class="filters">
        <input v-model="gQuery" class="search" placeholder="搜国家名/代码" />
        <select v-model="gPolicyFilter">
          <option value="">全部政策（不筛）</option>
          <option v-for="p in memberPolicies" :key="p.id" :value="p.id">{{ p.official_name_zh }}</option>
        </select>
        <span class="muted">显示 {{ matrixRows.length }} 国</span>
      </div>
      <div class="mwrap">
        <table class="grid">
          <thead>
            <tr>
              <th class="cty">国家</th>
              <th v-for="c in memberPolicies" :key="c.id">
                {{ c.official_name_zh }}<br /><span class="th-sub">{{ c.id }}</span>
              </th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="ct in matrixRows" :key="ct.country_code">
              <td class="cty">{{ ct.flag_emoji || "" }} {{ ct.name_zh }} <span class="muted2">{{ ct.country_code }}</span></td>
              <td v-for="p in memberPolicies" :key="p.id">
                <span class="cell" :class="{ on: grantMap[gkey(p.id, ct.country_code)] && grantMap[gkey(p.id, ct.country_code)].is_active !== false }"
                  @click="openGrant(p.id, ct.country_code)">
                  <input type="checkbox" class="cbx"
                    :checked="grantMap[gkey(p.id, ct.country_code)] && grantMap[gkey(p.id, ct.country_code)].is_active !== false"
                    @click.stop="toggleGrant(p.id, ct.country_code, $event.target.checked)" />
                  <span v-if="grantMap[gkey(p.id, ct.country_code)]?.max_stay_override" class="ovb">{{ grantMap[gkey(p.id, ct.country_code)].max_stay_override }}d</span>
                </span>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </section>

    <!-- ② policy editor -->
    <section v-show="tab === 'policy'" class="layout">
      <div class="plist">
        <div v-for="(p, i) in visa.policies" :key="p.id" class="pitem" :class="{ on: i === curIdx }" @click="curIdx = i">
          <div class="nm">{{ p.official_name_zh }}</div>
          <div class="ty">{{ p.policy_type }} · {{ p.id }}</div>
        </div>
      </div>

      <div v-if="curPolicy" class="card">
        <h2>{{ curPolicy.official_name_zh }} <span class="pid">{{ curPolicy.id }}</span></h2>
        <div v-if="curPolicy.node_kind === 'info'" class="info">🛈 兜底信息节点（L 签）：不参与「算离境上限」，作信息卡展示。</div>

        <div class="sec">
          <h3>基本</h3>
          <div class="fgrid">
            <label class="f">政策类型
              <select :value="curPolicy.policy_type" @change="setP('policy_type', $event.target.value)">
                <option v-for="t in Object.keys(TYPES)" :key="t" :value="t">{{ t }}</option>
              </select>
            </label>
            <label class="f">中文名<input :value="curPolicy.official_name_zh" @input="setP('official_name_zh', $event.target.value)" /></label>
            <label class="f">英文名<input :value="curPolicy.official_name_en" @input="setP('official_name_en', $event.target.value)" /></label>
            <label class="f">入境次数
              <select :value="curPolicy.entry_count" @change="setP('entry_count', $event.target.value)">
                <option v-for="v in ENTRY_COUNTS" :key="v" :value="v">{{ v }}</option>
              </select>
            </label>
          </div>
        </div>

        <div v-if="sections.includes('stay')" class="sec">
          <h3>停留时长</h3>
          <div class="fgrid">
            <label class="f">默认时长<input type="number" :value="curPolicy.max_stay_default ?? ''" @input="setP('max_stay_default', $event.target.value === '' ? null : +$event.target.value)" /></label>
            <label class="f">单位
              <select :value="curPolicy.max_stay_unit" @change="setP('max_stay_unit', $event.target.value)">
                <option value="days">天</option><option value="hours">小时</option>
              </select>
            </label>
            <label class="f full">计时规则
              <select :value="curPolicy.clock_rule" @change="setP('clock_rule', $event.target.value)">
                <option value="entry_day">入境当日0时起算</option>
                <option value="next_day_0000">入境次日0时起算</option>
                <option value="by_hour">按入境精确时刻</option>
              </select>
            </label>
          </div>
        </div>

        <div v-if="sections.includes('area')" class="sec">
          <h3>空间 · 停留区域 allowed_area</h3>
          <div class="seg">
            <button :class="{ on: areaMode === 'national' }" @click="setArea('national')">全国</button>
            <button :class="{ on: areaMode === 'list' }" @click="setArea('list')">指定地区</button>
          </div>
          <div v-if="areaMode === 'list'" class="chips">
            <span v-for="c in asArray(curPolicy.allowed_area)" :key="c" class="chip">
              {{ cityName(c) }} <b>{{ c }}</b><span class="x" @click="rmCode('allowed_area', c)">×</span>
            </span>
            <span class="chip add" @click="pickArea">＋ 选区域</span>
          </div>
        </div>

        <div v-if="sections.includes('ports')" class="sec">
          <h3>空间 · 口岸（受控词表）</h3>
          <div class="fgrid">
            <div class="f">入境口岸
              <div class="chips">
                <span v-for="c in asArray(curPolicy.entry_ports)" :key="c" class="chip">{{ portName(c) }} <b>{{ c }}</b><span class="x" @click="rmCode('entry_ports', c)">×</span></span>
                <span class="chip add" @click="pickPort('entry_ports')">＋ 选口岸</span>
              </div>
            </div>
            <div class="f">出境口岸
              <div class="chips">
                <span v-for="c in asArray(curPolicy.exit_ports)" :key="c" class="chip">{{ portName(c) }} <b>{{ c }}</b><span class="x" @click="rmCode('exit_ports', c)">×</span></span>
                <span class="chip add" @click="pickPort('exit_ports')">＋ 选口岸</span>
              </div>
            </div>
          </div>
        </div>

        <div v-if="visibleConds.length" class="sec">
          <h3>条件勾选</h3>
          <div class="conds">
            <label v-for="c in visibleConds" :key="c[0]" class="cond">
              <input type="checkbox" :checked="!!curPolicy[c[0]]" @change="setP(c[0], $event.target.checked)" />{{ c[1] }}
            </label>
          </div>
        </div>

        <div v-if="sections.includes('entry')" class="sec">
          <h3>门槛</h3>
          <div class="conds">
            <label class="cond"><input type="checkbox" :checked="!!curPolicy.passport_ordinary_only" @change="setP('passport_ordinary_only', $event.target.checked)" />仅普通护照</label>
          </div>
          <label class="mini">入境目的 purpose</label>
          <div class="conds">
            <label v-for="[v, t] in PURPOSES" :key="v" class="cond">
              <input type="checkbox" :checked="asArray(curPolicy.purpose).includes(v)" @change="togglePurpose(v, $event.target.checked)" />{{ t }}
            </label>
          </div>
        </div>

        <div class="sec">
          <h3>治理</h3>
          <div class="fgrid">
            <label class="f">一级信源 URL<input :value="curPolicy.source_url" @input="setP('source_url', $event.target.value)" /></label>
            <label class="f">人工核验日<input type="date" :value="curPolicy.last_verified || ''" @input="setP('last_verified', $event.target.value)" /></label>
          </div>
        </div>

        <div class="bar"><button class="btn" @click="savePolicy">保存政策</button></div>
      </div>
    </section>

    <!-- ③ city matrix -->
    <section v-show="tab === 'city'">
      <div class="mwrap">
        <table class="grid">
          <thead>
            <tr><th class="cty">城市 / 码</th><th v-for="c in memberPolicies" :key="c.id">{{ c.official_name_zh }}</th></tr>
          </thead>
          <tbody>
            <tr v-for="ct in visa.cities" :key="ct.city_id">
              <td class="cty">{{ ct.name_zh }} <span class="muted2">{{ ct.city_id }}</span></td>
              <td v-for="p in memberPolicies" :key="p.id">
                <span class="pill" :class="(matrixMap[ct.city_id + '|' + p.id] || 'no') === 'permit_required' ? 'permit' : (matrixMap[ct.city_id + '|' + p.id] || 'no')">
                  {{ (matrixMap[ct.city_id + '|' + p.id] || 'no') === 'permit_required' ? 'permit' : (matrixMap[ct.city_id + '|' + p.id] || 'no') }}
                </span>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </section>

    <!-- ④ snapshot -->
    <section v-show="tab === 'snap'">
      <pre class="pre">{{ snapshot }}</pre>
    </section>

    <!-- grant editor modal -->
    <div v-if="grantEdit" class="ov" @click.self="grantEdit = null">
      <div class="modal">
        <h3>{{ grantEdit.country?.name_zh || grantEdit.country?.country_code }} <span class="muted">{{ grantEdit.country?.country_code }}</span> · {{ grantEdit.policy.official_name_zh }}</h3>
        <p class="mp">编辑该国在此政策下的窗口。改完点保存即时生效。</p>
        <div class="fgrid">
          <label class="f">停留天数覆盖（留空=默认 {{ grantEdit.policy.max_stay_default ?? '-' }}）<input type="number" v-model="grantEdit.form.max_stay_override" placeholder="默认" /></label>
          <label class="f">入境次数覆盖
            <select v-model="grantEdit.form.entry_count_override">
              <option value="">默认（{{ grantEdit.policy.entry_count || '' }}）</option>
              <option v-for="v in ENTRY_COUNTS" :key="v" :value="v">{{ v }}</option>
            </select>
          </label>
          <label class="f">生效日<input type="date" v-model="grantEdit.form.effective_date" /></label>
          <label class="f">失效日（长期留空）<input type="date" v-model="grantEdit.form.expiry_date" /></label>
          <label class="f">公告日<input type="date" v-model="grantEdit.form.announced_date" /></label>
          <label class="f">核验日<input type="date" v-model="grantEdit.form.last_verified" /></label>
          <label class="f full">该国信源 URL<input v-model="grantEdit.form.source_url" /></label>
          <label class="f full">原文引文<textarea rows="2" v-model="grantEdit.form.evidence_quote"></textarea></label>
        </div>
        <div class="bar">
          <button class="btn btn-sm" @click="saveGrant">保存</button>
          <button class="btn btn-sm btn-secondary" @click="disableGrant">停用该国（留痕）</button>
          <button class="btn btn-sm btn-secondary" style="margin-left:auto" @click="grantEdit = null">关闭</button>
        </div>
      </div>
    </div>

    <!-- chip picker modal -->
    <div v-if="picker" class="ov" @click.self="picker = null">
      <div class="modal">
        <h3>{{ picker.title }}</h3>
        <p class="mp">点选即加入；移除在卡片上点 ×。</p>
        <input v-model="pickerQuery" class="search" placeholder="搜名称/代码" style="width:100%;margin-bottom:10px" />
        <div class="pkbody">
          <div v-for="it in pickerItems" :key="it.code" class="pkrow" :class="{ on: pickerSelected(it.code) }" @click="pickerPick(it.code)">
            <span>{{ it.label }} <span class="muted2">{{ it.sub }}</span></span>
            <span v-if="pickerSelected(it.code)">✓</span>
          </div>
        </div>
        <div class="bar"><button class="btn btn-sm btn-secondary" style="margin-left:auto" @click="picker = null">完成</button></div>
      </div>
    </div>

    <div class="toast" :class="{ on: toast }">{{ toast }}</div>
  </div>
</template>

<style scoped>
.vh { font-size: 13px; }
.head { display: flex; align-items: baseline; gap: 14px; margin-bottom: 12px; }
.head h1 { margin: 0; font-size: 20px; }
.prog { color: var(--muted); font-size: 13px; }
.tabs { display: flex; gap: 4px; border-bottom: 1px solid var(--border); margin-bottom: 14px; }
.tabs button { background: transparent; border: none; padding: 9px 16px; cursor: pointer; color: var(--muted); font-weight: 600; border-bottom: 2px solid transparent; }
.tabs button.on { color: var(--text); border-bottom-color: var(--accent); }
.filters { display: flex; gap: 10px; align-items: center; margin-bottom: 10px; }
.filters .search, .filters select { width: auto; min-width: 200px; }
.muted { color: var(--muted); }
.muted2 { color: var(--muted); font-size: 11px; }
.mwrap { overflow: auto; max-height: 64vh; border: 1px solid var(--border); border-radius: 8px; }
.grid { border-collapse: collapse; width: 100%; }
.grid th, .grid td { border: 1px solid var(--border); padding: 6px 8px; text-align: center; font-size: 12px; }
.grid thead th { position: sticky; top: 0; background: var(--surface2); z-index: 1; }
.grid th.cty, .grid td.cty { text-align: left; white-space: nowrap; position: sticky; left: 0; background: var(--surface); }
.grid thead th.cty { z-index: 2; }
.th-sub { font-weight: 400; font-size: 10px; color: var(--muted); }
.cell { display: inline-flex; align-items: center; gap: 4px; justify-content: center; min-width: 34px; min-height: 24px; border-radius: 5px; cursor: pointer; }
.cell.on { background: rgba(39, 174, 96, 0.16); }
.cbx { cursor: pointer; width: auto; }
.ovb { font-size: 10px; color: var(--accent); font-weight: 700; }
.pill { display: inline-block; padding: 1px 7px; border-radius: 10px; font-size: 11px; font-weight: 600; }
.pill.ok { background: rgba(39, 174, 96, 0.15); color: #1e8e4e; }
.pill.no { background: var(--surface2); color: var(--muted); }
.pill.permit { background: rgba(245, 166, 35, 0.18); color: #b9770a; }
.layout { display: grid; grid-template-columns: 230px 1fr; gap: 16px; align-items: start; }
.plist { display: flex; flex-direction: column; gap: 6px; }
.pitem { padding: 9px 11px; border: 1px solid var(--border); border-radius: 8px; cursor: pointer; }
.pitem.on { border-color: var(--accent); background: var(--surface2); }
.pitem .nm { font-weight: 600; }
.pitem .ty { font-size: 11px; color: var(--muted); }
.card { border: 1px solid var(--border); border-radius: 10px; padding: 16px; }
.card h2 { margin: 0 0 12px; font-size: 17px; }
.pid { font-size: 12px; color: var(--muted); font-weight: 400; }
.sec { padding: 12px 0; border-top: 1px solid var(--border); }
.sec h3 { margin: 0 0 9px; font-size: 12px; color: var(--muted); font-weight: 700; }
.fgrid { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; }
.f { display: block; font-size: 11px; color: var(--muted); }
.f.full { grid-column: 1 / -1; }
.f input, .f select, .f textarea { margin-top: 3px; }
.seg { display: inline-flex; border: 1px solid var(--border); border-radius: 7px; overflow: hidden; }
.seg button { border: none; background: var(--bg); padding: 6px 14px; cursor: pointer; font-size: 12px; color: var(--text); }
.seg button.on { background: var(--text); color: var(--bg); }
.chips { display: flex; flex-wrap: wrap; gap: 6px; margin-top: 6px; }
.chip { display: inline-flex; align-items: center; gap: 5px; padding: 3px 9px; background: var(--surface2); border: 1px solid var(--border); border-radius: 14px; font-size: 12px; }
.chip .x { cursor: pointer; color: var(--accent); font-weight: 700; }
.chip.add { cursor: pointer; border-style: dashed; color: var(--accent); }
.mini { font-size: 11px; color: var(--muted); margin-top: 8px; display: block; }
.conds { display: flex; flex-wrap: wrap; gap: 14px; }
.cond { display: inline-flex; align-items: center; gap: 5px; font-size: 13px; cursor: pointer; }
.cond input { width: auto; }
.info { background: rgba(245, 166, 35, 0.1); border: 1px solid rgba(245, 166, 35, 0.3); border-radius: 8px; padding: 10px; font-size: 12px; }
.bar { display: flex; gap: 8px; align-items: center; margin-top: 14px; }
.pre { background: #1e1e1e; color: #d4d4d4; padding: 14px; border-radius: 8px; max-height: 60vh; overflow: auto; font-size: 11px; }
.ov { position: fixed; inset: 0; background: rgba(0, 0, 0, 0.4); display: flex; align-items: center; justify-content: center; z-index: 1000; }
.modal { background: var(--surface); border-radius: 12px; padding: 20px; width: min(560px, 92vw); max-height: 88vh; overflow: auto; }
.modal h3 { margin: 0 0 4px; }
.mp { font-size: 12px; color: var(--muted); margin: 0 0 12px; }
.pkbody { max-height: 50vh; overflow: auto; }
.pkrow { display: flex; justify-content: space-between; padding: 8px 10px; border-bottom: 1px solid var(--border); cursor: pointer; }
.pkrow.on { background: rgba(39, 174, 96, 0.1); }
.toast { position: fixed; bottom: 26px; left: 50%; transform: translateX(-50%); background: var(--text); color: var(--bg); padding: 10px 18px; border-radius: 8px; font-size: 13px; opacity: 0; pointer-events: none; transition: opacity 0.2s; z-index: 1100; }
.toast.on { opacity: 1; }
</style>
