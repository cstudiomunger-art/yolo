#!/usr/bin/env node
/**
 * Import English narration scripts into sub_areas.body from nested EN_*.md folders.
 *
 * Usage:
 *   node scripts/import-subarea-en-scripts.mjs --root "/path/英文解说词原文" --dry-run
 *   node scripts/import-subarea-en-scripts.mjs --root "/path" --apply
 */
import { createClient } from "@supabase/supabase-js";
import { existsSync, mkdirSync, readFileSync, readdirSync, statSync, writeFileSync } from "fs";
import { join } from "path";
import { isValidAttractionRecord } from "./audit-subareas.mjs";

const ROOT = "/Users/vesperal/Desktop/YOLO";
const OUT_DIR = join(ROOT, "scripts/generated");
const OUT_CONFIRM = join(OUT_DIR, "en_scripts_confirm.md");
const OUT_REPORT = join(OUT_DIR, "en_scripts_report.json");
const EXCLUDED_ATTRACTION_IDS = new Set(["chongqing_jiujie"]);

const CITY_FOLDER_TO_ID = {
  上海: "shanghai",
  北京: "beijing",
  南京: "nanjing",
  成都: "chengdu",
  杭州: "hangzhou",
  苏州: "suzhou",
  重庆: "chongqing",
};

const FOLDER_ALIASES_BY_CITY = {
  suzhou: {
    留园: "留园景区",
    沧浪亭: "沧浪亭景区",
    耦园: "耦园（又称藕园）",
    苏州环秀山庄: "环秀山庄",
  },
  shanghai: { 徐家汇源: "徐家汇源景区" },
  chengdu: {
    成都熊猫基地: "大熊猫基地",
    成都大熊猫繁育研究基地: "大熊猫基地",
    熊猫基地: "大熊猫基地",
  },
  hangzhou: {
    千岛湖: "千岛湖景区",
    杭州大运河拱宸桥景区: "大运河拱宸桥",
    浙江省博物馆之江馆区: "浙江省博物馆",
    "浙江省博物馆（之江馆区）": "浙江省博物馆",
    丝绸博物馆: "中国丝绸博物馆",
    良渚古城: "良渚古城遗址公园",
    河坊街: "河坊街（清河坊历史街区）",
  },
  chongqing: {
    洪崖洞: "重庆洪崖洞民俗风貌区",
    磁器口古镇: "磁器口",
    解放碑: "解放碑广场",
    武隆喀斯特旅游区: "武隆喀斯特",
  },
};

const ATTRACTION_ALIASES = {
  国家博物馆: "国博",
  南京大屠杀纪念馆: "侵华日军南京大屠杀遇难同胞纪念馆",
  南京老门东: "老门东历史文化街区",
  "石臼湖（溧水境内）": "石臼湖",
  熊猫基地: "大熊猫基地",
  成都熊猫基地: "大熊猫基地",
  成都博物院: "成都博物馆",
  南京博物馆: "南京博物院",
  夫子庙: "南京夫子庙-秦淮河风光带",
  耦园: "耦园（又称藕园）",
  苏州环秀山庄: "环秀山庄",
  浙江省博物馆之江馆区: "浙江省博物馆",
  "浙江省博物馆（之江馆区）": "浙江省博物馆",
  丝绸博物馆: "中国丝绸博物馆",
  良渚古城: "良渚古城遗址公园",
  河坊街: "河坊街（清河坊历史街区）",
  大运河拱宸桥景区: "大运河拱宸桥",
  磁器口古镇: "磁器口",
  解放碑: "解放碑广场",
  "解放碑-八一好吃街": "解放碑",
  苏州十二国色: "苏州河十二国色",
  武隆喀斯特旅游区: "武隆喀斯特",
  洪崖洞民俗风貌区: "重庆洪崖洞民俗风貌区",
  周庄古镇: "周庄",
  平江路历史街区: "平江路",
  同里古镇: "同里",
  留园: "留园景区",
  故宫: "故宫博物院",
};

const MANUAL_HINT_TO_ZH = {
  "Floor 1 — Riverside Entrance (Starting Point)": "层临江入口（起点）",
  "Floor 10 — Sky Public Corridor": "层空中公共连廊",
  "Yangtze Cable Car Frame Window": "长江索道同框观景窗",
  "Floor 15 — Jiefang East Road Exit (Final Stop)": "层解放东路出口（终点）",
};

const SKIP_HINTS = /^(Welcome|Closing|结束语|Closing Words|Closing Remarks)/i;
const SKIP_FOLDER = /结束语|结束（|结束$/;
const SUB_FOLDER_RE_SIMPLE = /^(\d{1,2})_(.+)$/;
const SUB_FOLDER_RE_COMPOUND = /^(.+)-(\d{1,2})_(.+)$/;
const EN_MD_RE = /^EN_.*\.md$/i;

const args = process.argv.slice(2);
const dryRun = args.includes("--dry-run") || !args.includes("--apply");

function argValue(flag) {
  const i = args.indexOf(flag);
  return i >= 0 && args[i + 1] ? args[i + 1] : "";
}

const sourceRoot = argValue("--root") || "/Users/vesperal/Desktop/英文解说词原文";
const cityFilter = argValue("--city");

function readXcconfigValue(path, key) {
  const text = readFileSync(path, "utf8");
  const line = text.split(/\r?\n/).find((it) => it.trim().startsWith(`${key} =`));
  if (!line) return "";
  return line.split("=").slice(1).join("=").replace(/\$\(\)/g, "").trim();
}

function loadServiceKey() {
  if (process.env.SUPABASE_SERVICE_ROLE_KEY) return process.env.SUPABASE_SERVICE_ROLE_KEY;
  const tmp = join(ROOT, ".env.local.tmp");
  try {
    const m = readFileSync(tmp, "utf8").match(/SUPABASE_SERVICE_ROLE_KEY\s*=\s*"?([^"\n]+)"?/);
    if (m?.[1]) return m[1].trim();
  } catch {
    /* optional */
  }
  return "";
}

function getSupabaseConfig() {
  const xcPath = join(ROOT, "Secrets.xcconfig");
  const url = (process.env.SUPABASE_URL || readXcconfigValue(xcPath, "SUPABASE_URL")).replace(/\$\(\)/g, "");
  const key =
    loadServiceKey() ||
    process.env.SUPABASE_ANON_KEY ||
    readXcconfigValue(xcPath, "SUPABASE_ANON_KEY");
  if (!url || !key) throw new Error("缺少 SUPABASE_URL 或 key");
  return { url, key, usesServiceRole: Boolean(loadServiceKey()) };
}

function createSupabase() {
  const { url, key } = getSupabaseConfig();
  return createClient(url, key, { auth: { persistSession: false, autoRefreshToken: false } });
}

async function rest(path, init = {}) {
  const { url, key } = getSupabaseConfig();
  let lastErr;
  for (let attempt = 0; attempt < 3; attempt += 1) {
    try {
      const res = await fetch(`${url}${path}`, {
        ...init,
        headers: { apikey: key, Authorization: `Bearer ${key}`, ...(init.headers || {}) },
      });
      if (!res.ok) throw new Error(`${path} -> ${res.status} ${await res.text()}`);
      return res;
    } catch (err) {
      lastErr = err;
      if (attempt < 2) await new Promise((r) => setTimeout(r, 1000 * (attempt + 1)));
    }
  }
  throw lastErr;
}

function onlyDirs(path) {
  if (!existsSync(path)) return [];
  return readdirSync(path).filter((n) => {
    try {
      return statSync(join(path, n)).isDirectory() && !n.startsWith(".");
    } catch {
      return false;
    }
  });
}

function normalizeName(value) {
  return String(value || "")
    .replace(/[（(].*?[）)]/g, "")
    .replace(/[·\-—–、，,。.\s]/g, "")
    .toLowerCase();
}

function normalizeEn(value) {
  return String(value || "")
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, " ")
    .trim();
}

function hasCjk(text) {
  return /[\u3400-\u9fff]/.test(text);
}

function tokenizeEn(text) {
  return normalizeEn(text).split(/\s+/).filter((w) => w.length > 2);
}

function scoreMatch(hint, subArea, folderNameZh = "") {
  const manualZh = MANUAL_HINT_TO_ZH[hint];
  if (manualZh && String(subArea.name_zh || "").includes(manualZh.replace(/[（(].*$/, ""))) return 100;

  if (folderNameZh) {
    const fn = normalizeName(folderNameZh);
    const zh = normalizeName(subArea.name_zh);
    if (fn && zh) {
      if (fn === zh) return 98;
      if (zh.includes(fn) || fn.includes(zh)) return 90;
    }
  }

  const zh = normalizeName(subArea.name_zh);
  const en = normalizeEn(subArea.name_en);
  const h = hasCjk(hint) ? normalizeName(hint) : normalizeEn(hint);
  if (!h) return 0;

  if (hasCjk(hint) && zh) {
    if (h === zh) return 100;
    if (zh.includes(h) || h.includes(zh)) return 85;
    const h4 = h.slice(0, 4);
    const z4 = zh.slice(0, 4);
    if (h4.length >= 3 && h4 === z4) return 65;
    let overlap = 0;
    for (let i = 0; i < Math.min(h.length, zh.length); i++) {
      if (h[i] === zh[i]) overlap++;
    }
    return overlap >= 4 ? 45 : 0;
  }

  const hw = tokenizeEn(hint);
  const ew = tokenizeEn(subArea.name_en);
  if (ew.length) {
    const overlap = hw.filter((w) => ew.some((x) => x.includes(w) || w.includes(x)));
    if (overlap.length >= 3) return 95;
    if (overlap.length >= 2) return 85;
    if (overlap.length === 1) return 55;
  }

  if (en && (h.includes(en) || en.includes(h))) return 60;
  return 0;
}

function resolveAttraction(folderName, attractions, cityId) {
  const cityAliases = FOLDER_ALIASES_BY_CITY[cityId] || {};
  const lookup = cityAliases[folderName] || ATTRACTION_ALIASES[folderName] || folderName;
  const pool = attractions.filter(isValidAttractionRecord).filter((a) => a.city_id === cityId);
  const candidates = [
    lookup,
    folderName,
    folderName.replace(/子景点信息/g, "").replace(/景点信息/g, ""),
    folderName.replace(/^成都|^上海|^重庆|^南京|^杭州|^苏州/g, ""),
  ].filter(Boolean);

  for (const guess of candidates) {
    const exact = pool.find((a) => String(a.chinese_name || "").trim() === guess);
    if (exact) return exact;
  }
  for (const guess of candidates) {
    const fuzzy = pool
      .filter((a) => {
        const cn = String(a.chinese_name || "").trim();
        return cn.includes(guess) || guess.includes(cn);
      })
      .sort((a, b) => String(b.chinese_name || "").length - String(a.chinese_name || "").length);
    if (fuzzy.length) return fuzzy[0];
  }
  return null;
}

function parseSubFolder(folderName) {
  let m = folderName.match(SUB_FOLDER_RE_SIMPLE);
  if (m) {
    return {
      seq: Number(m[1]),
      folderNameZh: m[2].trim(),
      sortOrder: Number(m[1]) - 1,
      zonePrefix: "",
      isCompound: false,
    };
  }
  m = folderName.match(SUB_FOLDER_RE_COMPOUND);
  if (!m) return null;
  return {
    seq: Number(m[2]),
    folderNameZh: m[3].trim(),
    sortOrder: Number(m[2]) - 1,
    zonePrefix: m[1].trim(),
    isCompound: true,
  };
}

function collectScriptEntries(attractionPath) {
  const entries = [];
  for (const subFolder of onlyDirs(attractionPath).sort((a, b) => a.localeCompare(b, "zh-Hans-CN"))) {
    if (SKIP_FOLDER.test(subFolder)) continue;
    const parsed = parseSubFolder(subFolder);
    if (!parsed) continue;
    const subPath = join(attractionPath, subFolder);
    const mdFile = readdirSync(subPath).find((n) => EN_MD_RE.test(n));
    if (!mdFile) continue;
    const hint = mdFile
      .replace(/^EN_/i, "")
      .replace(/^\d+\./, "")
      .replace(/\.md$/i, "")
      .trim();
    const body = readFileSync(join(subPath, mdFile), "utf8").trim();
    if (!body || SKIP_HINTS.test(body.slice(0, 80))) continue;
    entries.push({
      subFolder,
      ...parsed,
      mdFile,
      hint,
      body,
      voices: hint ? { Script: { hint } } : {},
    });
  }
  return entries;
}

function matchSubArea(entry, areas) {
  const seqPadded = String(entry.seq).padStart(2, "0");

  if (!entry.isCompound) {
    const byIdSuffix = areas.find((a) => a.id.endsWith(`_sa_${seqPadded}`));
    if (byIdSuffix) return { area: byIdSuffix, method: "id_suffix", score: 100 };

    const bySort = areas.find((a) => a.sort_order === entry.sortOrder);
    if (bySort) return { area: bySort, method: "sort_order", score: 100 };
  }

  if (entry.zonePrefix) {
    const raw = entry.zonePrefix.replace(/^大足石刻-?/, "").replace(/国家森林公园$/, "");
    const zp = normalizeName(raw);
    const zoneHits = areas.filter((a) => {
      const zh = normalizeName(a.name_zh);
      return zh.includes(zp) || zp.includes(zh);
    });
    if (zoneHits.length >= 1 && entry.seq === 1) {
      return { area: zoneHits[0], method: "zone_prefix", score: 95 };
    }
  }

  const hints = Object.values(entry.voices)
    .map((v) => v.hint)
    .filter(Boolean);
  const folderZh = entry.folderNameZh;
  let best = null;
  for (const area of areas) {
    for (const hint of hints.length ? hints : [folderZh]) {
      if (SKIP_HINTS.test(hint)) continue;
      const score = scoreMatch(hint, area, folderZh);
      if (!best || score > best.score) best = { area, score, hint, method: "name" };
    }
  }
  if (best && best.score >= 50) {
    const bestSuffix = best.area.id.match(/_sa_(\d+)$/)?.[1];
    if (bestSuffix && Number(bestSuffix) !== entry.seq) return null;
    return best;
  }
  return null;
}

async function main() {
  mkdirSync(OUT_DIR, { recursive: true });
  if (!existsSync(sourceRoot)) throw new Error(`源目录不存在: ${sourceRoot}`);

  const { usesServiceRole } = getSupabaseConfig();
  if (!dryRun && !usesServiceRole) {
    throw new Error("缺少 SUPABASE_SERVICE_ROLE_KEY：--apply 需 service role");
  }

  const attractions = await (await rest("/rest/v1/attractions?select=id,chinese_name,city_id")).json();
  const subAreas = await (
    await rest("/rest/v1/sub_areas?select=id,attraction_id,sort_order,name_zh,name_en,body,is_active")
  ).json();

  const subAreasByAttr = new Map();
  for (const row of subAreas) {
    if (!row.is_active || EXCLUDED_ATTRACTION_IDS.has(row.attraction_id)) continue;
    if (!subAreasByAttr.has(row.attraction_id)) subAreasByAttr.set(row.attraction_id, []);
    subAreasByAttr.get(row.attraction_id).push(row);
  }

  const stats = {
    scriptFolders: 0,
    matched: 0,
    unmatchedFolders: 0,
    unmatchedAttractions: 0,
    emptyBody: 0,
    updated: 0,
  };
  const matched = [];
  const unmatched = [];
  const applyQueue = [];

  let cityFolders = onlyDirs(sourceRoot).sort((a, b) => a.localeCompare(b, "zh-Hans-CN"));
  if (cityFilter) cityFolders = cityFolders.filter((c) => c === cityFilter);

  for (const cityFolder of cityFolders) {
    const cityId = CITY_FOLDER_TO_ID[cityFolder];
    if (!cityId) continue;
    const cityPath = join(sourceRoot, cityFolder);

    for (const attractionFolder of onlyDirs(cityPath).sort((a, b) => a.localeCompare(b, "zh-Hans-CN"))) {
      const parent = resolveAttraction(attractionFolder, attractions, cityId);
      if (!parent) {
        stats.unmatchedAttractions += 1;
        unmatched.push({ cityFolder, attractionFolder, subFolder: "*", reason: "主景点未匹配" });
        continue;
      }
      if (EXCLUDED_ATTRACTION_IDS.has(parent.id)) continue;

      const areas = subAreasByAttr.get(parent.id) || [];
      const entries = collectScriptEntries(join(cityPath, attractionFolder));
      const usedAreaIds = new Set();

      for (const entry of entries) {
        if (entry.isCompound && entry.seq !== 1) continue;
        stats.scriptFolders += 1;
        if (!entry.body) {
          stats.emptyBody += 1;
          continue;
        }

        const match = matchSubArea(entry, areas.filter((a) => !usedAreaIds.has(a.id)));
        if (!match) {
          stats.unmatchedFolders += 1;
          unmatched.push({
            cityFolder,
            attractionFolder,
            subFolder: entry.subFolder,
            reason: "子景点未匹配",
          });
          continue;
        }

        usedAreaIds.add(match.area.id);
        stats.matched += 1;
        const record = {
          cityFolder,
          cityId,
          attractionFolder,
          attractionId: parent.id,
          subFolder: entry.subFolder,
          subAreaId: match.area.id,
          nameZh: match.area.name_zh,
          mdFile: entry.mdFile,
          matchMethod: match.method,
          bodyLength: entry.body.length,
          body: entry.body,
          previousBodyLength: String(match.area.body || "").length,
        };
        matched.push(record);
        applyQueue.push(record);
      }
    }
  }

  if (!dryRun && applyQueue.length) {
    const supabase = createSupabase();
    const batchSize = 30;
    for (let i = 0; i < applyQueue.length; i += batchSize) {
      const batch = applyQueue.slice(i, i + batchSize);
      for (const rec of batch) {
        const { error } = await supabase
          .from("sub_areas")
          .update({ body: rec.body, audio_transcript: rec.body, updated_at: new Date().toISOString() })
          .eq("id", rec.subAreaId);
        if (error) throw new Error(`update ${rec.subAreaId}: ${error.message}`);
        stats.updated += 1;
      }
      console.log(`  updated ${Math.min(i + batchSize, applyQueue.length)}/${applyQueue.length}`);
    }
  }

  const confirmLines = [
    "# 英文解说词导入确认",
    "",
    `生成时间：${new Date().toISOString()}`,
    `模式：${dryRun ? "dry-run" : "apply"}`,
    `匹配：${stats.matched} | 未匹配文件夹：${stats.unmatchedFolders} | 未匹配主景点：${stats.unmatchedAttractions}`,
    "",
  ];
  let lastCity = "";
  let lastAttr = "";
  for (const m of matched.slice(0, 200)) {
    if (m.cityFolder !== lastCity) {
      confirmLines.push(`## ${m.cityFolder}`);
      lastCity = m.cityFolder;
      lastAttr = "";
    }
    if (m.attractionFolder !== lastAttr) {
      confirmLines.push(`### ${m.attractionFolder}`);
      lastAttr = m.attractionFolder;
    }
    confirmLines.push(
      `- \`${m.subFolder}\` → \`${m.subAreaId}\` ${m.nameZh} [${m.matchMethod}] ${m.bodyLength} chars`
    );
  }
  if (matched.length > 200) confirmLines.push(`\n… 另有 ${matched.length - 200} 条，见 report.json`);
  if (unmatched.length) {
    confirmLines.push("", "## 未匹配", "");
    for (const u of unmatched.slice(0, 100)) {
      confirmLines.push(`- ${u.cityFolder}/${u.attractionFolder}/${u.subFolder}: ${u.reason}`);
    }
    if (unmatched.length > 100) confirmLines.push(`… 另有 ${unmatched.length - 100} 条`);
  }

  const report = {
    generatedAt: new Date().toISOString(),
    mode: dryRun ? "dry-run" : "apply",
    sourceRoot,
    stats,
    unmatched,
    matched: matched.map(({ body, ...rest }) => rest),
  };

  writeFileSync(OUT_CONFIRM, confirmLines.join("\n"), "utf8");
  writeFileSync(OUT_REPORT, JSON.stringify(report, null, 2), "utf8");

  console.log(JSON.stringify(stats, null, 2));
  console.log(`Confirm: ${OUT_CONFIRM}`);
  console.log(`Report: ${OUT_REPORT}`);
  if (dryRun) console.log("\n[dry-run] 未写库。确认后运行 --apply");
  else console.log(`\n[apply] 完成：更新 ${stats.updated} 条 body`);
}

main().catch((err) => {
  console.error(err.message);
  process.exit(1);
});
