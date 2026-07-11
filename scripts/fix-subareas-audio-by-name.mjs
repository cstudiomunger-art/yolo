#!/usr/bin/env node
import { mkdirSync, readFileSync, readdirSync, statSync, writeFileSync } from "fs";
import { join } from "path";

const ROOT = "/Users/vesperal/Desktop/YOLO";
const SOURCE_BENEDICT = "/Users/vesperal/Downloads/全量英文解说音频_Benedict";
const OUT_DIR = join(ROOT, "scripts/generated");
const OUT_SQL = join(OUT_DIR, "sub_areas_audio_remap_by_name.sql");
const OUT_REPORT = join(OUT_DIR, "sub_areas_audio_remap_by_name_report.json");
const AUDIO_BUCKET = "audio-guides";
const EXCLUDED_ATTRACTION_IDS = new Set(["chongqing_jiujie"]);

const apply = process.argv.includes("--apply");
const cityFilter = (() => {
  const idx = process.argv.indexOf("--city");
  return idx >= 0 ? process.argv[idx + 1] : null;
})();

const ATTRACTION_ALIASES = {
  南京大屠杀纪念馆: "侵华日军南京大屠杀遇难同胞纪念馆",
  南京老门东: "老门东历史文化街区",
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
};

const MANUAL_HINT_TO_ZH = {
  "Floor 1 — Riverside Entrance (Starting Point)": "层临江入口（起点）",
  "Floor 10 — Sky Public Corridor": "层空中公共连廊",
  "Yangtze Cable Car Frame Window": "长江索道同框观景窗",
  "Floor 15 — Jiefang East Road Exit (Final Stop)": "层解放东路出口（终点）",
  "Jiushigang Riverbank": "九石缸河滩",
  "Tianlong Bridge": "天龙桥",
  "Tianfu Post Station": "天官赐福",
  "Qinglong Bridge": "青龙桥",
  "Shenying Tiankeng": "神鹰天坑",
  "Heilong Bridge": "黑龙桥",
  "Longquan Cave": "龙泉洞",
  "Longshuixia Slot Canyon": "龙水峡地缝",
  "Milky Way Falls": "银河飞瀑",
  "Jiaolong Cold Cave": "蛟龙寒窟",
  "Muti Station": "仙女山国家公园-木梯子站",
  "Grand Grassland Station": "仙女山国家公园-大草原站",
  "Jiefangbei Square": "解放碑广场",
  "Monument to the Liberation of the People": "解放碑纪念碑",
  "Jiefangbei Pedestrian Street Sculpture Group": "解放碑步行街雕塑群",
  "Zouronglu Pedestrian Street": "邹容路步行街",
  "Bayi Road Snack Street": "八一路好吃街",
  "WFC Huixian Tower Observation Deck": "环球金融中心会仙楼观景台",
  "North Station (Xinhua Road, Yuzhong District)": "北站（渝中区新华路站）",
  "The Cabin": "索道轿厢",
  "South Station (Longmenghao, Nan'an District)": "南站（南岸区龙门浩站）",
  "Floor 8 — Zone 78 Trendy Play World (Upper Level)": "八楼：78 区潮玩世界",
  "Floor 7 — Zone 78 Trendy Play World (Lower Level)": "七楼：78 区潮玩世界",
};

const SKIP_HINTS = /^(Welcome|Closing|结束语|Closing Words|Closing Remarks)/i;

function readXcconfigValue(path, key) {
  const text = readFileSync(path, "utf8");
  const line = text.split(/\r?\n/).find((it) => it.trim().startsWith(`${key} =`));
  if (!line) return "";
  return line.split("=").slice(1).join("=").replace(/\$\(\)/g, "").trim();
}

function getSupabaseConfig() {
  const xcPath = join(ROOT, "Secrets.xcconfig");
  const url = process.env.SUPABASE_URL || readXcconfigValue(xcPath, "SUPABASE_URL");
  const key =
    process.env.SUPABASE_SERVICE_ROLE_KEY ||
    process.env.SUPABASE_ANON_KEY ||
    readXcconfigValue(xcPath, "SUPABASE_ANON_KEY");
  if (!url || !key) throw new Error("缺少 SUPABASE_URL 或 key");
  return { url, key };
}

function sqlStr(value) {
  if (value == null) return "NULL";
  return `'${String(value).replace(/'/g, "''")}'`;
}

function onlyDirs(path) {
  return readdirSync(path).filter((n) => statSync(join(path, n)).isDirectory());
}

function parseAudioSeq(filename) {
  const m = filename.match(/_([0-9]{1,3})\./);
  return m ? Number(m[1]) : 0;
}

function collectAudioFiles(scenicPath) {
  const results = [];
  function walk(dir, rel = "") {
    for (const name of readdirSync(dir)) {
      const full = join(dir, name);
      const st = statSync(full);
      if (st.isDirectory()) {
        walk(full, rel ? `${rel}/${name}` : name);
        continue;
      }
      if (!name.toLowerCase().endsWith(".mp3")) continue;
      results.push({ file: name, localPath: full, relDir: rel, fileSeq: parseAudioSeq(name) });
    }
  }
  walk(scenicPath);
  const nested = results.some((r) => r.relDir);
  if (nested) {
    results.sort(
      (a, b) =>
        a.relDir.localeCompare(b.relDir, "zh-Hans-CN") ||
        a.fileSeq - b.fileSeq ||
        a.file.localeCompare(b.file)
    );
    return results.map((r, idx) => ({ ...r, seq: idx + 1 }));
  }
  return results
    .sort((a, b) => a.fileSeq - b.fileSeq || a.file.localeCompare(b.file))
    .map((r) => ({ ...r, seq: r.fileSeq }));
}

function parseNameHint(filename) {
  const m = filename.match(/_\d+\.(.+?)\.mp3$/i);
  return m ? m[1].trim() : "";
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
  return normalizeEn(text)
    .split(/\s+/)
    .filter((w) => w.length > 2);
}

function scoreMatch(hint, subArea) {
  const manualZh = MANUAL_HINT_TO_ZH[hint];
  if (manualZh && String(subArea.name_zh || "").includes(manualZh.replace(/[（(].*$/, ""))) return 100;

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

  const zhParts = String(subArea.name_zh || "")
    .split(/[·\-—–]/)
    .map((p) => normalizeName(p))
    .filter(Boolean);
  for (const part of zhParts) {
    const overlap = hw.filter((w) => part.includes(w.slice(0, 4)) || w.length >= 5);
    if (overlap.length >= 2) return 75;
  }

  if (en && (h.includes(en) || en.includes(h))) return 60;
  return 0;
}

function assignByGreedy(areas, files, parent, supabaseUrl, report) {
  const pairs = [];
  for (const entry of files) {
    const hint = parseNameHint(entry.file);
    if (SKIP_HINTS.test(hint) || hint === "结束语") continue;
    for (const area of areas) {
      const score = scoreMatch(hint, area);
      if (score >= 50) {
        pairs.push({ entry, area, score, hint });
      }
    }
  }
  pairs.sort((a, b) => b.score - a.score || a.entry.seq - b.entry.seq);

  const usedAreas = new Set();
  const usedFiles = new Set();
  const assignments = [];

  for (const p of pairs) {
    const fileKey = `${p.entry.relDir ? p.entry.relDir + "/" : ""}${p.entry.file}`;
    if (usedAreas.has(p.area.id) || usedFiles.has(fileKey)) continue;
    usedAreas.add(p.area.id);
    usedFiles.add(fileKey);
    assignments.push(p);
  }

  for (const p of assignments) {
    const fileKey = storageFileKey(parent.id, p.entry.seq);
    const audioUrl = publicStorageUrl(supabaseUrl, fileKey);
    const sourceFile = p.entry.relDir ? `${p.entry.relDir}/${p.entry.file}` : p.entry.file;
    report.stats.matched += 1;
    const current = String(p.area.audio_url || "").trim();
    if (current === audioUrl) continue;
    report.stats.updated += 1;
    report.items.push({
      city: report._city,
      scenic: report._scenic,
      sourceFile,
      hint: p.hint,
      fileKey,
      subAreaId: p.area.id,
      nameZh: p.area.name_zh,
      score: p.score,
      previousUrl: current,
      newUrl: audioUrl,
    });
  }

  for (const entry of files) {
    const hint = parseNameHint(entry.file);
    if (SKIP_HINTS.test(hint) || hint === "结束语") continue;
    const sourceFile = entry.relDir ? `${entry.relDir}/${entry.file}` : entry.file;
    const assigned = assignments.some((a) => {
      const f = a.entry.relDir ? `${a.entry.relDir}/${a.entry.file}` : a.entry.file;
      return f === sourceFile;
    });
    if (assigned) continue;

    const scored = areas
      .map((a) => ({ area: a, score: scoreMatch(hint, a) }))
      .filter((s) => s.score > 0)
      .sort((a, b) => b.score - a.score);
    if (!scored.length) {
      report.stats.unmatchedFiles += 1;
      report.unmatched.push({
        city: report._city,
        scenic: report._scenic,
        sourceFile,
        hint,
        fileKey: storageFileKey(parent.id, entry.seq),
      });
      continue;
    }
    const best = scored[0];
    const second = scored[1];
    if (second && best.score - second.score < 10) {
      report.stats.ambiguous += 1;
      report.ambiguous.push({
        city: report._city,
        scenic: report._scenic,
        sourceFile,
        hint,
        candidates: scored.slice(0, 3).map((s) => ({
          id: s.area.id,
          nameZh: s.area.name_zh,
          nameEn: s.area.name_en,
          score: s.score,
        })),
      });
    } else if (best.score < 50) {
      report.stats.skippedLowScore += 1;
    }
  }
}

function storageFileKey(attractionId, seq) {
  return `${attractionId}_${String(seq).padStart(3, "0")}.mp3`;
}

function publicStorageUrl(supabaseUrl, fileKey) {
  return `${supabaseUrl}/storage/v1/object/public/${AUDIO_BUCKET}/sub-areas/${fileKey}`;
}

function resolveAttraction(scenic, attractions) {
  const guess = ATTRACTION_ALIASES[scenic] || scenic;
  return (
    attractions.find((a) => String(a.chinese_name || "").trim() === guess) ||
    attractions.find(
      (a) =>
        String(a.chinese_name || "").includes(guess) ||
        guess.includes(String(a.chinese_name || "").trim())
    )
  );
}

async function rest(path, init = {}) {
  const { url, key } = getSupabaseConfig();
  const res = await fetch(`${url}${path}`, {
    ...init,
    headers: { apikey: key, Authorization: `Bearer ${key}`, ...(init.headers || {}) },
  });
  if (!res.ok) throw new Error(`${path} -> ${res.status} ${await res.text()}`);
  return res;
}

async function main() {
  mkdirSync(OUT_DIR, { recursive: true });
  const { url: supabaseUrl } = getSupabaseConfig();

  const attractions = await (await rest("/rest/v1/attractions?select=id,chinese_name")).json();
  const subAreas = await (
    await rest("/rest/v1/sub_areas?select=id,attraction_id,sort_order,audio_url,name_zh,name_en,is_active")
  ).json();

  const subAreasByAttr = new Map();
  for (const row of subAreas) {
    if (!row.is_active || EXCLUDED_ATTRACTION_IDS.has(row.attraction_id)) continue;
    if (!subAreasByAttr.has(row.attraction_id)) subAreasByAttr.set(row.attraction_id, []);
    subAreasByAttr.get(row.attraction_id).push(row);
  }

  const report = {
    generatedAt: new Date().toISOString(),
    mode: apply ? "apply" : "dry-run",
    cityFilter,
    stats: { matched: 0, updated: 0, skippedLowScore: 0, unmatchedFiles: 0, ambiguous: 0 },
    items: [],
    unmatched: [],
    ambiguous: [],
  };

  const sqlBlocks = ["-- Remap sub_areas.audio_url by matching Benedict filename to sub_area name"];

  let cities = onlyDirs(SOURCE_BENEDICT).sort();
  if (cityFilter) cities = cities.filter((c) => c === cityFilter);

  for (const city of cities) {
    const cityPath = join(SOURCE_BENEDICT, city);
    for (const scenic of onlyDirs(cityPath).sort((a, b) => a.localeCompare(b, "zh-Hans-CN"))) {
      const parent = resolveAttraction(scenic, attractions);
      if (!parent || EXCLUDED_ATTRACTION_IDS.has(parent.id)) continue;

      const areas = subAreasByAttr.get(parent.id) || [];
      const files = collectAudioFiles(join(cityPath, scenic));
      report._city = city;
      report._scenic = scenic;
      assignByGreedy(areas, files, parent, supabaseUrl, report);
    }
  }

  for (const item of report.items) {
    sqlBlocks.push(
      `UPDATE sub_areas SET audio_url=${sqlStr(item.newUrl)}, updated_at=NOW() WHERE id=${sqlStr(item.subAreaId)};`
    );
  }

  delete report._city;
  delete report._scenic;

  writeFileSync(OUT_SQL, `${sqlBlocks.join("\n\n")}\n`, "utf8");
  writeFileSync(OUT_REPORT, JSON.stringify(report, null, 2), "utf8");

  if (apply && report.items.length > 0) {
    for (const item of report.items) {
      await rest(`/rest/v1/sub_areas?id=eq.${encodeURIComponent(item.subAreaId)}`, {
        method: "PATCH",
        headers: { "Content-Type": "application/json", Prefer: "return=minimal" },
        body: JSON.stringify({ audio_url: item.newUrl, updated_at: new Date().toISOString() }),
      });
    }
  }

  console.log(`sql: ${OUT_SQL}`);
  console.log(`report: ${OUT_REPORT}`);
  console.log(JSON.stringify(report.stats, null, 2));
}

main().catch((err) => {
  console.error(err.message);
  process.exit(1);
});
