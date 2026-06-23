/* YOLO Admin — 签证工作台（可视化编辑器）
   交付包 index.html 的功能移植：① 国别核对网格 · ② 政策卡片编辑器 · ③ 城市可达矩阵(派生只读) · ④ 快照。
   后端改为 Supabase（visa_* 表），直接编辑生产；无 review_status 工作流——
   勾选=新增/启用 grant，取消=停用(is_active=false，留痕不硬删)。 */
(function () {
  const App = window.ChinaGoAdmin;
  const VH = (window.__vh = {});
  App.visaState = App.visaState || { tab: "grant", curP: 0 };

  const esc = (s) => App.escapeHtml(String(s == null ? "" : s));
  const S = () => App.visaState;
  const gkey = (p, c) => p + "|" + c;

  // 政策类型 → 显示哪些编辑分区
  const TYPES = {
    "互免": ["stay", "area", "entry"], "单方面免签": ["stay", "area", "entry"],
    "过境免签": ["stay", "area", "ports", "onward", "entry"], "区域免签": ["stay", "area", "entry"],
    "团体免签": ["stay", "area", "group", "entry"], "普通签证": ["info"],
  };

  function vToast(m) {
    let t = document.getElementById("vh-toast");
    if (!t) { t = document.createElement("div"); t.id = "vh-toast"; document.body.appendChild(t); }
    t.textContent = m; t.classList.add("on");
    clearTimeout(t._t); t._t = setTimeout(() => t.classList.remove("on"), 1800);
  }
  function asArray(v) { return Array.isArray(v) ? v : []; }

  App.renderVisaHub = async function renderVisaHub() {
    App.currentView = "visa_hub";
    App.currentTable = null;
    App.$("#page-title").textContent = "签证工作台";
    App.$("#add-row-btn").classList.add("hidden");

    App.$("#main-content").innerHTML = `
      ${STYLE}
      <div class="vh">
        <div class="vh-head">
          <div class="status-bar info" style="margin:0;flex:1">可视化编辑生产数据：勾选即新增/启用 grant，取消=停用(留痕)。改动即时生效线上。</div>
          <div class="vh-prog"><span id="vh-ptxt" class="muted"></span><div class="vh-pbar"><i id="vh-pbar"></i></div></div>
        </div>
        <div class="vh-tabs">
          <div class="vh-tab" data-v="grant">① 国别核对</div>
          <div class="vh-tab" data-v="policy">② 政策定义</div>
          <div class="vh-tab" data-v="city">③ 城市可达（派生）</div>
          <div class="vh-tab" data-v="snap">④ 快照</div>
        </div>
        <section class="vh-view" id="vv-grant">
          <div class="hub-toolbar" style="flex-wrap:wrap;gap:8px">
            <input id="vh-q" class="search-input" style="max-width:200px" placeholder="搜国家/代码" oninput="__vh.renderGrant()">
            <select id="vh-fpolicy" class="search-input" style="max-width:240px" onchange="__vh.renderGrant()"><option value="">全部政策（不筛）</option></select>
            <span class="muted" id="vh-gcount"></span>
          </div>
          <div class="vh-mwrap"><table id="vh-gtable" class="vh-grid"></table></div>
        </section>
        <section class="vh-view" id="vv-policy" style="display:none">
          <div class="vh-layout"><div class="vh-plist" id="vh-plist"></div><div class="vh-card" id="vh-pcard"></div></div>
        </section>
        <section class="vh-view" id="vv-city" style="display:none">
          <div class="hub-toolbar"><button class="btn btn-sm btn-secondary" onclick="__vh.loadAll().then(__vh.renderCity)">刷新</button>
            <span class="muted">由 allowed_area 行政区划码匹配派生（DB 触发器维护，运营不手填）</span></div>
          <div class="vh-mwrap"><table id="vh-ctable" class="vh-grid"></table></div>
        </section>
        <section class="vh-view" id="vv-snap" style="display:none">
          <div class="hub-toolbar"><span class="muted" id="vh-snapinfo"></span></div>
          <pre id="vh-snapout" class="vh-pre"></pre>
        </section>
      </div>
      <div class="vh-ov" id="vh-ov" onclick="if(event.target===this)__vh.closeModal()"><div class="vh-modal" id="vh-modal"></div></div>`;

    document.querySelectorAll(".vh-tab").forEach((t) => t.onclick = () => VH.switchTab(t.dataset.v));
    await VH.loadAll();
    VH.switchTab(S().tab || "grant");
  };

  VH.loadAll = async function loadAll() {
    const c = App.client;
    const [pol, gr, ct, ci, po, mx] = await Promise.all([
      c.from("visa_policies_v2").select("*").order("priority", { ascending: true }),
      c.from("visa_policy_grants_v2").select("*"),
      c.from("visa_countries").select("*").order("country_code", { ascending: true }),
      c.from("visa_cities").select("*").order("city_id", { ascending: true }),
      c.from("visa_ports").select("*").order("display_order", { ascending: true }),
      c.from("visa_city_policy_matrix").select("*"),
    ]);
    const st = S();
    st.policies = pol.data || []; st.grants = gr.data || []; st.countries = ct.data || [];
    st.cities = ci.data || []; st.ports = po.data || []; st.matrix = mx.data || [];
    if (st.curP >= st.policies.length) st.curP = 0;
  };

  VH.switchTab = function switchTab(v) {
    S().tab = v;
    document.querySelectorAll(".vh-tab").forEach((x) => x.classList.toggle("on", x.dataset.v === v));
    document.querySelectorAll(".vh-view").forEach((x) => x.style.display = (x.id === "vv-" + v) ? "" : "none");
    if (v === "grant") { VH.renderProgress(); VH.populatePolicyFilter(); VH.renderGrant(); }
    else if (v === "policy") { VH.renderPList(); VH.renderPCard(); }
    else if (v === "city") VH.renderCity();
    else if (v === "snap") VH.renderSnap();
  };

  function memberPolicies() { return S().policies.filter((p) => p.node_kind === "computed"); }
  function grantMap() { const m = {}; S().grants.forEach((g) => m[gkey(g.policy_id, g.country_code)] = g); return m; }
  function curPol() { return S().policies[S().curP]; }

  // ───────── ① 国别核对网格 ─────────
  VH.renderProgress = function () {
    const active = S().grants.filter((g) => g.is_active !== false).length;
    document.getElementById("vh-ptxt").textContent = `已配置 grant ${active} · 国家 ${S().countries.length} · 政策 ${S().policies.length}`;
    const pct = S().countries.length ? Math.min(100, 100 * active / (S().countries.length * Math.max(1, memberPolicies().length))) : 0;
    document.getElementById("vh-pbar").style.width = pct + "%";
  };
  VH.populatePolicyFilter = function () {
    const sel = document.getElementById("vh-fpolicy"); if (!sel) return;
    const cur = sel.value;
    sel.innerHTML = `<option value="">全部政策（不筛）</option>` +
      memberPolicies().map((c) => `<option value="${esc(c.id)}">仅 ${esc(c.official_name_zh)}（${esc(c.id)}）的国家</option>`).join("");
    if (cur) sel.value = cur;
  };
  VH.renderGrant = function () {
    const gm = grantMap(), cols = memberPolicies();
    const q = (document.getElementById("vh-q").value || "").trim().toLowerCase();
    const fp = document.getElementById("vh-fpolicy").value;
    let h = `<thead><tr><th class="cty">国家</th>${cols.map((c) => `<th>${esc(c.official_name_zh)}<br><span class="th-sub">${esc(c.id)}</span></th>`).join("")}</tr></thead><tbody>`;
    let shown = 0;
    S().countries.forEach((ct) => {
      const match = !q || ct.name_zh.toLowerCase().includes(q) || ct.country_code.toLowerCase().includes(q) || (ct.name_en || "").toLowerCase().includes(q);
      if (!match) return;
      if (fp) { const g0 = gm[gkey(fp, ct.country_code)]; if (!g0 || g0.is_active === false) return; }
      let row = `<td class="cty">${esc(ct.flag_emoji || "")} ${esc(ct.name_zh)} <span class="muted2">${esc(ct.country_code)}</span></td>`;
      cols.forEach((p) => {
        const g = gm[gkey(p.id, ct.country_code)];
        const on = g && g.is_active !== false;
        const ov = g && g.max_stay_override ? `<span class="ovb">${esc(g.max_stay_override)}d</span>` : "";
        row += `<td><span class="cell ${on ? "on" : ""}" onclick="__vh.openGrant('${esc(p.id)}','${esc(ct.country_code)}')">
          <input type="checkbox" class="cbx" ${on ? "checked" : ""} onclick="event.stopPropagation();__vh.toggleG('${esc(p.id)}','${esc(ct.country_code)}',this.checked)">${ov}</span></td>`;
      });
      h += `<tr>${row}</tr>`; shown++;
    });
    document.getElementById("vh-gtable").innerHTML = h + "</tbody>";
    document.getElementById("vh-gcount").textContent = `显示 ${shown} 国`;
  };
  VH.toggleG = async function (pid, cc, on) {
    const g = grantMap()[gkey(pid, cc)];
    let err;
    if (g) {
      ({ error: err } = await App.client.from("visa_policy_grants_v2").update({ is_active: on }).eq("id", g.id));
    } else if (on) {
      const id = `${pid}_${cc}`.toLowerCase();
      ({ error: err } = await App.client.from("visa_policy_grants_v2").upsert(
        { id, policy_id: pid, country_code: cc, effective_date: "1900-01-01", is_active: true }, { onConflict: "id" }));
    }
    if (err) { vToast("失败：" + err.message); return; }
    await VH.loadAll(); VH.renderProgress(); VH.renderGrant();
  };
  VH.openGrant = function (pid, cc) {
    const g = grantMap()[gkey(pid, cc)];
    const p = S().policies.find((x) => x.id === pid), ct = S().countries.find((x) => x.country_code === cc);
    if (!g) { vToast("先勾选该国，再编辑"); return; }
    const quote = g.evidence_quote ? `<div class="vh-quote">采集引文：…${esc(g.evidence_quote)}…${g.source_url ? `<br><a href="${esc(g.source_url)}" target="_blank">↗ 一级信源</a>` : ""}</div>` : "";
    document.getElementById("vh-modal").innerHTML = `
      <h3>${esc(ct ? ct.name_zh : cc)} <span class="muted">${esc(cc)}</span> · ${esc(p.official_name_zh)}</h3>
      <p class="vh-mp">编辑该国在此政策下的窗口。改完点保存即时生效。</p>${quote}
      <div class="vh-fgrid">
        <div class="vh-f"><label>停留天数覆盖（留空=政策默认 ${esc(p.max_stay_default ?? "-")}${p.max_stay_unit === "hours" ? "h" : "d"}）</label><input id="g_ov" type="number" value="${esc(g.max_stay_override ?? "")}" placeholder="默认"></div>
        <div class="vh-f"><label>入境次数覆盖</label><select id="g_ec"><option value="">默认(${esc(p.entry_count || "")})</option>${["single", "double", "multiple", "per_entry"].map((v) => `<option ${g.entry_count_override === v ? "selected" : ""}>${v}</option>`).join("")}</select></div>
        <div class="vh-f"><label>生效日</label><input id="g_eff" type="date" value="${esc(g.effective_date || "")}"></div>
        <div class="vh-f"><label>失效日（长期留空）</label><input id="g_exp" type="date" value="${esc(g.expiry_date || "")}"></div>
        <div class="vh-f"><label>公告日</label><input id="g_ann" type="date" value="${esc(g.announced_date || "")}"></div>
        <div class="vh-f"><label>核验日</label><input id="g_lv" type="date" value="${esc(g.last_verified || "")}"></div>
        <div class="vh-f full"><label>该国信源 URL</label><input id="g_src" type="text" value="${esc(g.source_url || "")}"></div>
        <div class="vh-f full"><label>原文引文</label><textarea id="g_q" rows="2">${esc(g.evidence_quote || "")}</textarea></div>
      </div>
      <div class="vh-bar">
        <button class="btn btn-sm" onclick="__vh.saveGrant('${esc(g.id)}')">保存</button>
        <button class="btn btn-sm btn-secondary" onclick="__vh.toggleG('${esc(pid)}','${esc(cc)}',false);__vh.closeModal()">停用该国（留痕）</button>
        <button class="btn btn-sm btn-secondary" style="margin-left:auto" onclick="__vh.closeModal()">关闭</button>
      </div>`;
    document.getElementById("vh-ov").classList.add("on");
  };
  VH.saveGrant = async function (id) {
    const v = (x) => document.getElementById(x).value;
    const patch = {
      max_stay_override: v("g_ov") ? Number(v("g_ov")) : null,
      entry_count_override: v("g_ec") || null,
      effective_date: v("g_eff") || null, expiry_date: v("g_exp") || null,
      announced_date: v("g_ann") || null, last_verified: v("g_lv") || null,
      source_url: v("g_src") || null, evidence_quote: v("g_q") || null,
    };
    const { error } = await App.client.from("visa_policy_grants_v2").update(patch).eq("id", id);
    if (error) { vToast("失败：" + error.message); return; }
    await VH.loadAll(); VH.renderProgress(); VH.renderGrant(); VH.closeModal(); vToast("已保存");
  };

  // ───────── ② 政策定义 ─────────
  VH.renderPList = function () {
    document.getElementById("vh-plist").innerHTML = S().policies.map((p, i) =>
      `<div class="vh-pitem ${i === S().curP ? "on" : ""}" onclick="__vh.selPolicy(${i})">
        <div class="nm">${esc(p.official_name_zh)}</div><div class="ty">${esc(p.policy_type)} · ${esc(p.id)}</div></div>`).join("");
  };
  VH.selPolicy = function (i) { S().curP = i; VH.renderPList(); VH.renderPCard(); };
  VH.renderPCard = function () {
    const p = curPol(); if (!p) { document.getElementById("vh-pcard").innerHTML = "（无政策）"; return; }
    const show = TYPES[p.policy_type] || ["stay", "area"];
    const areaMode = p.allowed_area === "national" ? "national" : "list";
    const seg = (mode) => `<div class="vh-seg"><button class="${areaMode === "national" ? "on" : ""}" onclick="__vh.setArea('national')">全国</button><button class="${areaMode === "list" ? "on" : ""}" onclick="__vh.setArea('list')">指定地区</button></div>`;
    let h = `<h2>${esc(p.official_name_zh)} <span class="vh-pid">${esc(p.id)}</span></h2>`;
    if (p.node_kind === "info") h += `<div class="vh-info">🛈 兜底信息节点（L 签）：不参与「算离境上限」，作信息卡展示。</div>`;
    h += `<div class="vh-sec"><h3>基本</h3><div class="vh-fgrid">
      <div class="vh-f"><label>政策类型</label><select onchange="__vh.setP('policy_type',this.value)">${Object.keys(TYPES).map((t) => `<option ${p.policy_type === t ? "selected" : ""}>${t}</option>`).join("")}</select></div>
      <div class="vh-f"><label>中文名</label><input value="${esc(p.official_name_zh || "")}" onchange="__vh.setP('official_name_zh',this.value)"></div>
      <div class="vh-f"><label>英文名</label><input value="${esc(p.official_name_en || "")}" onchange="__vh.setP('official_name_en',this.value)"></div>
      <div class="vh-f"><label>入境次数</label><select onchange="__vh.setP('entry_count',this.value)">${["single", "double", "multiple", "per_entry"].map((v) => `<option ${p.entry_count === v ? "selected" : ""}>${v}</option>`).join("")}</select></div>
    </div></div>`;
    if (show.includes("stay")) h += `<div class="vh-sec"><h3>停留时长</h3><div class="vh-fgrid">
      <div class="vh-f"><label>默认时长</label><input type="number" value="${esc(p.max_stay_default ?? "")}" onchange="__vh.setP('max_stay_default',this.value===''?null:+this.value)"></div>
      <div class="vh-f"><label>单位</label><select onchange="__vh.setP('max_stay_unit',this.value)"><option value="days" ${p.max_stay_unit === "days" ? "selected" : ""}>天</option><option value="hours" ${p.max_stay_unit === "hours" ? "selected" : ""}>小时</option></select></div>
      <div class="vh-f full"><label>计时规则</label><select onchange="__vh.setP('clock_rule',this.value)">
        <option value="entry_day" ${p.clock_rule === "entry_day" ? "selected" : ""}>入境当日0时起算</option>
        <option value="next_day_0000" ${p.clock_rule === "next_day_0000" ? "selected" : ""}>入境次日0时起算</option>
        <option value="by_hour" ${p.clock_rule === "by_hour" ? "selected" : ""}>按入境精确时刻</option></select></div></div></div>`;
    if (show.includes("area")) {
      h += `<div class="vh-sec"><h3>空间 · 停留区域 allowed_area</h3><div class="vh-f"><label>适用范围</label>${seg()}</div>`;
      if (areaMode === "list") {
        const arr = asArray(p.allowed_area), cmap = {}; S().cities.forEach((c) => cmap[c.city_id] = c.name_zh);
        h += `<div style="margin-top:9px"><label class="vh-mini">停留区域（GB/T 2260，省码 XX0000 展开全省）</label>
          <div class="vh-chips">${arr.map((c) => `<span class="vh-chip">${esc(cmap[c] || "?")} <b>${esc(c)}</b><span class="x" onclick="__vh.rmCode('allowed_area','${esc(c)}')">×</span></span>`).join("")}<span class="vh-chip add" onclick="__vh.pickArea()">＋ 选区域</span></div></div>`;
      }
      h += `</div>`;
    }
    if (show.includes("ports")) {
      const pmap = {}; S().ports.forEach((o) => pmap[o.code] = o.name_zh);
      const portChips = (field) => { const arr = asArray(p[field]); return `<div class="vh-chips">${arr.length ? arr.map((c) => `<span class="vh-chip">${esc(pmap[c] || "?")} <b>${esc(c)}</b><span class="x" onclick="__vh.rmCode('${field}','${esc(c)}')">×</span></span>`).join("") : '<span class="vh-mini">（空=不限）</span>'}<span class="vh-chip add" onclick="__vh.pickPort('${field}')">＋ 选口岸</span></div>`; };
      h += `<div class="vh-sec"><h3>空间 · 口岸（受控词表，选不打）</h3><div class="vh-fgrid">
        <div class="vh-f"><label>入境口岸</label>${portChips("entry_ports")}</div>
        <div class="vh-f"><label>出境口岸</label>${portChips("exit_ports")}</div></div></div>`;
    }
    const conds = [["onward_ticket", "需续程客票", "onward"], ["onward_third_country", "需前往第三国", "onward"], ["group_required", "需随团", "group"], ["entry_port_limited", "限定口岸", "ports"]];
    const vc = conds.filter((c) => show.includes(c[2]));
    if (vc.length) h += `<div class="vh-sec"><h3>条件勾选</h3><div class="vh-conds">${vc.map((c) => `<label class="vh-cond"><input type="checkbox" ${p[c[0]] ? "checked" : ""} onchange="__vh.setP('${c[0]}',this.checked)">${c[1]}</label>`).join("")}</div></div>`;
    if (show.includes("entry")) {
      const purp = asArray(p.purpose), POPT = [["tourism", "旅游"], ["business", "商务"], ["transit", "过境"], ["family", "探亲"]];
      h += `<div class="vh-sec"><h3>门槛</h3>
        <div class="vh-conds"><label class="vh-cond"><input type="checkbox" ${p.passport_ordinary_only ? "checked" : ""} onchange="__vh.setP('passport_ordinary_only',this.checked)">仅普通护照</label></div>
        <label class="vh-mini" style="margin-top:8px;display:block">入境目的 purpose</label>
        <div class="vh-conds">${POPT.map(([v, t]) => `<label class="vh-cond"><input type="checkbox" ${purp.includes(v) ? "checked" : ""} onchange="__vh.togglePurpose('${v}',this.checked)">${t}</label>`).join("")}</div></div>`;
    }
    h += `<div class="vh-sec"><h3>治理</h3><div class="vh-fgrid">
      <div class="vh-f"><label>一级信源 URL</label><input value="${esc(p.source_url || "")}" onchange="__vh.setP('source_url',this.value)"></div>
      <div class="vh-f"><label>人工核验日</label><input type="date" value="${esc(p.last_verified || "")}" onchange="__vh.setP('last_verified',this.value)"></div>
    </div></div>`;
    h += `<div class="vh-bar"><button class="btn btn-sm" onclick="__vh.savePolicy()">保存政策</button></div>`;
    document.getElementById("vh-pcard").innerHTML = h;
  };
  VH.setP = function (f, v) { curPol()[f] = v; };
  VH.setArea = function (mode) { curPol().allowed_area = mode === "national" ? "national" : asArray(curPol().allowed_area); VH.renderPCard(); };
  VH.rmCode = function (field, code) {
    if (field === "allowed_area") curPol().allowed_area = asArray(curPol().allowed_area).filter((x) => x !== code);
    else curPol()[field] = asArray(curPol()[field]).filter((x) => x !== code);
    VH.renderPCard();
  };
  VH.pushCode = function (field, code) {
    if (field === "allowed_area") { const a = asArray(curPol().allowed_area); if (!a.includes(code)) a.push(code); curPol().allowed_area = a; }
    else { const a = asArray(curPol()[field]); if (!a.includes(code)) a.push(code); curPol()[field] = a; }
    VH.renderPCard();
  };
  VH.togglePurpose = function (v, on) { let a = asArray(curPol().purpose); a = on ? [...new Set([...a, v])] : a.filter((x) => x !== v); curPol().purpose = a; };
  VH.pickArea = function () { VH.openPicker("选停留区域（GB/T 2260）", S().cities.map((c) => ({ code: c.city_id, label: c.name_zh, sub: c.city_id })), asArray(curPol().allowed_area), (c) => VH.pushCode("allowed_area", c)); };
  VH.pickPort = function (field) { VH.openPicker("选" + (field === "entry_ports" ? "入境" : "出境") + "口岸", S().ports.map((o) => ({ code: o.code, label: o.name_zh, sub: o.code + " · " + (o.port_type || "air") })), asArray(curPol()[field]), (c) => VH.pushCode(field, c)); };
  VH.openPicker = function (title, items, selected, onPick) {
    const sel = new Set(selected);
    const render = (q = "") => { const ql = q.toLowerCase(); return items.filter((it) => !ql || it.label.toLowerCase().includes(ql) || it.code.toLowerCase().includes(ql)).map((it) => `<div class="vh-pkrow ${sel.has(it.code) ? "on" : ""}" onclick="__vh._pick('${esc(it.code)}')"><span>${esc(it.label)} <span class="muted2">${esc(it.sub)}</span></span>${sel.has(it.code) ? "✓" : ""}</div>`).join(""); };
    VH._pick = (code) => { if (!sel.has(code)) { sel.add(code); onPick(code); } document.getElementById("vh-pkbody").innerHTML = render(document.getElementById("vh-pkq").value); };
    document.getElementById("vh-modal").innerHTML = `<h3>${esc(title)}</h3><p class="vh-mp">点选即加入；移除在卡片上点 ×。</p>
      <input id="vh-pkq" class="search-input" placeholder="搜名称/代码" oninput="document.getElementById('vh-pkbody').innerHTML=window.__vh._pkrender(this.value)" style="margin-bottom:10px;width:100%">
      <div id="vh-pkbody" style="max-height:50vh;overflow:auto">${render()}</div>
      <div class="vh-bar"><button class="btn btn-sm btn-secondary" style="margin-left:auto" onclick="__vh.closeModal()">完成</button></div>`;
    VH._pkrender = render;
    document.getElementById("vh-ov").classList.add("on");
  };
  VH.savePolicy = async function () {
    const p = curPol();
    const patch = {
      policy_type: p.policy_type, official_name_zh: p.official_name_zh, official_name_en: p.official_name_en,
      entry_count: p.entry_count, max_stay_default: p.max_stay_default, max_stay_unit: p.max_stay_unit,
      clock_rule: p.clock_rule, allowed_area: p.allowed_area, entry_ports: p.entry_ports, exit_ports: p.exit_ports,
      onward_ticket: !!p.onward_ticket, onward_third_country: !!p.onward_third_country, group_required: !!p.group_required,
      entry_port_limited: !!p.entry_port_limited, passport_ordinary_only: !!p.passport_ordinary_only, purpose: p.purpose,
      source_url: p.source_url, last_verified: p.last_verified || null,
    };
    const { error } = await App.client.from("visa_policies_v2").update(patch).eq("id", p.id);
    if (error) { vToast("失败：" + error.message); return; }
    await VH.loadAll(); VH.renderPList(); VH.renderPCard(); vToast("政策已保存");
  };

  // ───────── ③ 城市可达（派生只读）─────────
  VH.renderCity = function () {
    const cols = memberPolicies(), mm = {}; S().matrix.forEach((m) => mm[m.city_id + "|" + m.policy_id] = m.feasibility);
    let h = `<thead><tr><th class="cty">城市 / 码</th>${cols.map((c) => `<th>${esc(c.official_name_zh)}</th>`).join("")}</tr></thead><tbody>`;
    S().cities.forEach((ct) => {
      h += `<tr><td class="cty">${esc(ct.name_zh)} <span class="muted2">${esc(ct.city_id)}</span></td>` +
        cols.map((p) => { const f = mm[ct.city_id + "|" + p.id] || "no"; return `<td><span class="vh-pill ${f === "permit_required" ? "permit" : f}">${f === "permit_required" ? "permit" : f}</span></td>`; }).join("") + `</tr>`;
    });
    document.getElementById("vh-ctable").innerHTML = h + "</tbody>";
  };

  // ───────── ④ 快照 ─────────
  VH.renderSnap = function () {
    const st = S();
    const activeGrants = st.grants.filter((g) => g.is_active !== false);
    document.getElementById("vh-snapinfo").textContent = `政策 ${st.policies.length} · 启用 grant ${activeGrants.length} · 国家 ${st.countries.length} · 口岸 ${st.ports.length} · 矩阵 ${st.matrix.length}`;
    document.getElementById("vh-snapout").textContent = JSON.stringify({ policies: st.policies, grants: activeGrants }, null, 2);
  };

  VH.closeModal = function () { document.getElementById("vh-ov").classList.remove("on"); };

  const STYLE = `<style>
  .vh{font-size:13px} .vh-head{display:flex;gap:14px;align-items:center;margin-bottom:12px;flex-wrap:wrap}
  .vh-prog{display:flex;align-items:center;gap:8px;min-width:220px} .vh-pbar{width:140px;height:7px;background:#eee;border-radius:4px;overflow:hidden} .vh-pbar i{display:block;height:100%;background:#27AE60;width:0;transition:width .3s}
  .vh-tabs{display:flex;gap:4px;border-bottom:1px solid #e8e4dc;margin-bottom:14px}
  .vh-tab{padding:9px 16px;cursor:pointer;color:#888;font-weight:600;border-bottom:2px solid transparent} .vh-tab.on{color:#111;border-bottom-color:#C8A97E}
  .vh-mwrap{overflow:auto;max-height:64vh;border:1px solid #eee;border-radius:8px}
  .vh-grid{border-collapse:collapse;width:100%} .vh-grid th,.vh-grid td{border:1px solid #f0ece8;padding:6px 8px;text-align:center;font-size:12px}
  .vh-grid thead th{position:sticky;top:0;background:#faf7f2;z-index:1} .vh-grid th.cty,.vh-grid td.cty{text-align:left;white-space:nowrap;position:sticky;left:0;background:#fff}
  .vh-grid thead th.cty{z-index:2} .th-sub{font-weight:400;font-size:10px;color:#888} .muted2{color:#aaa;font-size:11px}
  .cell{display:inline-flex;align-items:center;gap:4px;justify-content:center;min-width:34px;min-height:24px;border-radius:5px;cursor:pointer} .cell.on{background:rgba(39,174,96,.12)}
  .cbx{cursor:pointer} .ovb{font-size:10px;color:#C8572C;font-weight:700}
  .vh-pill{display:inline-block;padding:1px 7px;border-radius:10px;font-size:11px;font-weight:600} .vh-pill.ok{background:rgba(39,174,96,.15);color:#1e8e4e} .vh-pill.no{background:#f3f3f3;color:#999} .vh-pill.permit{background:rgba(245,166,35,.18);color:#b9770a}
  .vh-layout{display:grid;grid-template-columns:230px 1fr;gap:16px;align-items:start}
  .vh-plist{display:flex;flex-direction:column;gap:6px} .vh-pitem{padding:9px 11px;border:1px solid #e8e4dc;border-radius:8px;cursor:pointer} .vh-pitem.on{border-color:#C8A97E;background:#faf7f2} .vh-pitem .nm{font-weight:600} .vh-pitem .ty{font-size:11px;color:#888}
  .vh-card{border:1px solid #e8e4dc;border-radius:10px;padding:16px} .vh-card h2{margin:0 0 12px;font-size:17px} .vh-pid{font-size:12px;color:#888;font-weight:400}
  .vh-sec{padding:12px 0;border-top:1px solid #f0ece8} .vh-sec:first-of-type{border-top:none} .vh-sec h3{margin:0 0 9px;font-size:12px;color:#666;font-weight:700}
  .vh-fgrid{display:grid;grid-template-columns:1fr 1fr;gap:10px} .vh-f.full{grid-column:1/-1} .vh-f label{display:block;font-size:11px;color:#888;margin-bottom:3px} .vh-f input,.vh-f select,.vh-f textarea{width:100%;padding:7px 9px;border:1px solid #e0dccf;border-radius:6px;font-size:13px}
  .vh-seg{display:inline-flex;border:1px solid #e0dccf;border-radius:7px;overflow:hidden} .vh-seg button{border:none;background:#fff;padding:6px 14px;cursor:pointer;font-size:12px} .vh-seg button.on{background:#111;color:#fff}
  .vh-chips{display:flex;flex-wrap:wrap;gap:6px;margin-top:6px} .vh-chip{display:inline-flex;align-items:center;gap:5px;padding:3px 9px;background:#faf7f2;border:1px solid #e8e4dc;border-radius:14px;font-size:12px} .vh-chip b{font-weight:700} .vh-chip .x{cursor:pointer;color:#C8572C;font-weight:700} .vh-chip.add{cursor:pointer;border-style:dashed;color:#C8A97E} .vh-mini{font-size:11px;color:#888}
  .vh-conds{display:flex;flex-wrap:wrap;gap:14px} .vh-cond{display:inline-flex;align-items:center;gap:5px;font-size:13px;cursor:pointer}
  .vh-info{background:#fffbf2;border:1px solid #f3e2c0;border-radius:8px;padding:10px;font-size:12px}
  .vh-bar{display:flex;gap:8px;align-items:center;margin-top:14px} .vh-pre{background:#1e1e1e;color:#d4d4d4;padding:14px;border-radius:8px;max-height:60vh;overflow:auto;font-size:11px}
  .vh-ov{position:fixed;inset:0;background:rgba(0,0,0,.35);display:none;align-items:center;justify-content:center;z-index:1000} .vh-ov.on{display:flex} .vh-modal{background:#fff;border-radius:12px;padding:20px;width:min(560px,92vw);max-height:88vh;overflow:auto} .vh-modal h3{margin:0 0 4px} .vh-mp{font-size:12px;color:#888;margin:0 0 12px} .vh-quote{background:#faf7f2;border-left:3px solid #C8A97E;padding:8px 10px;font-size:12px;margin-bottom:12px;border-radius:0 6px 6px 0}
  .vh-pkrow{display:flex;justify-content:space-between;padding:8px 10px;border-bottom:1px solid #f0ece8;cursor:pointer} .vh-pkrow.on{background:rgba(39,174,96,.08);color:#1e8e4e}
  #vh-toast{position:fixed;bottom:26px;left:50%;transform:translateX(-50%);background:#111;color:#fff;padding:10px 18px;border-radius:8px;font-size:13px;opacity:0;pointer-events:none;transition:opacity .2s;z-index:1100} #vh-toast.on{opacity:1}
  </style>`;
})();
