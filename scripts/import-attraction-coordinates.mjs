#!/usr/bin/env node
/**
 * Import attraction latitude/longitude from CSV (WGS84 columns).
 *
 * Usage:
 *   node scripts/import-attraction-coordinates.mjs --csv "/path.csv" --dry-run
 *   node scripts/import-attraction-coordinates.mjs --csv "/path.csv" --apply
 */
import { createClient } from "@supabase/supabase-js";
import { existsSync, mkdirSync, readFileSync, writeFileSync } from "fs";
import { join } from "path";

const ROOT = "/Users/vesperal/Desktop/YOLO";
const OUT_DIR = join(ROOT, "scripts/generated");

const CITY_ZH_TO_ID = {
  上海: "shanghai",
  北京: "beijing",
  成都: "chengdu",
  杭州: "hangzhou",
  苏州: "suzhou",
  南京: "nanjing",
  重庆: "chongqing",
};

const CSV_ATTRACTION_ALIASES = {
  东方明珠广播电视塔: "东方明珠",
  上海外滩: "外滩",
  徐家汇源景区: "徐家汇源",
  熊猫基地: "大熊猫基地",
  良渚古城: "良渚古城遗址公园",
  "浙江省博物馆（之江馆区）": "浙江省博物馆",
  河坊街: "河坊街（清河坊历史街区）",
  周庄古镇: "周庄",
  平江路历史街区: "平江路",
  故宫: "故宫博物院",
  国博: "国博",
  南京老门东: "老门东历史文化街区",
  "甘熙宅第（南京民俗博物馆）": "甘熙宅第",
  南京大屠杀纪念馆: "侵华日军南京大屠杀遇难同胞纪念馆",
  来福士: "来福士广场",
  磁器口古镇: "磁器口",
  洪崖洞民俗风貌区: "重庆洪崖洞民俗风貌区",
  "解放碑-八一好吃街": "解放碑广场",
  武隆喀斯特旅游区: "武隆喀斯特",
  鹅岭二厂文创公园: "鹅岭二厂",
  留园: "留园景区",
  耦园: "耦园（又称藕园）",
  环秀山庄: "苏州环秀山庄",
  沧浪亭: "沧浪亭景区",
  同里古镇: "同里",
  "石臼湖（溧水境内）": "石臼湖",
};

const args = process.argv.slice(2);
const dryRun = args.includes("--dry-run") || !args.includes("--apply");

function argValue(flag) {
  const i = args.indexOf(flag);
  return i >= 0 && args[i + 1] ? args[i + 1] : "";
}

const csvPath = argValue("--csv") || "/Users/vesperal/Desktop/城市景点列表_已查询经纬度.csv";

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
  const res = await fetch(`${url}${path}`, {
    ...init,
    headers: { apikey: key, Authorization: `Bearer ${key}`, ...(init.headers || {}) },
  });
  if (!res.ok) throw new Error(`${path} -> ${res.status} ${await res.text()}`);
  return res;
}

function parseCsv(text) {
  const lines = text.trim().split(/\r?\n/);
  const header = lines[0].split(",");
  const rows = [];
  for (let i = 1; i < lines.length; i++) {
    const line = lines[i];
    if (!line.trim()) continue;
    const cols = [];
    let cur = "";
    let inQuotes = false;
    for (let j = 0; j < line.length; j++) {
      const ch = line[j];
      if (ch === '"') inQuotes = !inQuotes;
      else if (ch === "," && !inQuotes) {
        cols.push(cur);
        cur = "";
      } else cur += ch;
    }
    cols.push(cur);
    const row = {};
    header.forEach((h, idx) => {
      row[h.trim()] = (cols[idx] || "").trim();
    });
    rows.push(row);
  }
  return rows;
}

function resolveAttraction(cityId, csvName, pool) {
  const candidates = [CSV_ATTRACTION_ALIASES[csvName] || csvName, csvName].filter(Boolean);
  for (const guess of candidates) {
    const exact = pool.find((a) => String(a.chinese_name || "").trim() === guess);
    if (exact) return exact;
  }
  for (const guess of candidates) {
    const fuzzy = pool.filter(
      (a) =>
        String(a.chinese_name || "").includes(guess) || guess.includes(String(a.chinese_name || "").trim())
    );
    if (fuzzy.length === 1) return fuzzy[0];
    if (fuzzy.length > 1) {
      fuzzy.sort((a, b) => String(a.chinese_name).length - String(b.chinese_name).length);
      return fuzzy[0];
    }
  }
  return null;
}

async function main() {
  mkdirSync(OUT_DIR, { recursive: true });
  if (!existsSync(csvPath)) throw new Error(`CSV 不存在: ${csvPath}`);

  const csvRows = parseCsv(readFileSync(csvPath, "utf8"));
  const { usesServiceRole } = getSupabaseConfig();
  if (!dryRun && !usesServiceRole) {
    throw new Error("缺少 SUPABASE_SERVICE_ROLE_KEY，--apply 需要 service role");
  }
  const supabase = createSupabase();

  const all = await (await rest("/rest/v1/attractions?select=id,city_id,chinese_name,latitude,longitude")).json();

  const matched = [];
  const unmatched = [];
  const skipped = [];

  for (const row of csvRows) {
    const cityId = CITY_ZH_TO_ID[row["城市"]];
    if (!cityId) {
      unmatched.push({ row, reason: "unknown_city" });
      continue;
    }
    if (row["状态"] && !row["状态"].startsWith("OK")) {
      skipped.push({ row, reason: row["状态"] });
    }
    const pool = all.filter((a) => a.city_id === cityId);
    const attraction = resolveAttraction(cityId, row["景点"], pool);
    if (!attraction) {
      unmatched.push({ city: row["城市"], name: row["景点"], reason: "attraction_not_found" });
      continue;
    }
    const lat = Number(row["纬度_wgs84"]);
    const lon = Number(row["经度_wgs84"]);
    if (!Number.isFinite(lat) || !Number.isFinite(lon)) {
      unmatched.push({ city: row["城市"], name: row["景点"], reason: "invalid_coords" });
      continue;
    }
    matched.push({
      id: attraction.id,
      cityId,
      csvName: row["景点"],
      dbName: attraction.chinese_name,
      latitude: lat,
      longitude: lon,
      prevLat: attraction.latitude,
      prevLon: attraction.longitude,
      gaodeName: row["高德命中名称"],
      status: row["状态"],
    });
  }

  if (!dryRun && matched.length) {
    for (const item of matched) {
      const { error } = await supabase
        .from("attractions")
        .update({ latitude: item.latitude, longitude: item.longitude })
        .eq("id", item.id);
      if (error) throw new Error(`update ${item.id}: ${error.message}`);
    }
  }

  const report = {
    generatedAt: new Date().toISOString(),
    mode: dryRun ? "dry-run" : "apply",
    csvPath,
    stats: {
      csvRows: csvRows.length,
      matched: matched.length,
      unmatched: unmatched.length,
      skipped: skipped.length,
    },
    matched,
    unmatched,
    skipped,
  };
  const outPath = join(OUT_DIR, "attraction_coordinates_report.json");
  writeFileSync(outPath, JSON.stringify(report, null, 2), "utf8");

  console.log(JSON.stringify(report.stats, null, 2));
  if (unmatched.length) {
    console.log("unmatched:", unmatched.map((u) => `${u.city || u.row?.["城市"]}/${u.name || u.row?.["景点"]}: ${u.reason}`).join("\n  "));
  }
  if (skipped.length) {
    console.log("skipped:", skipped.map((s) => `${s.row["城市"]}/${s.row["景点"]}: ${s.reason}`).join("\n  "));
  }
  console.log(`Report: ${outPath}`);
  if (dryRun) console.log("\n[dry-run] 未写库。确认后运行 --apply");
  else console.log(`\n[apply] 完成：更新 ${matched.length} 个景点坐标`);
}

main().catch((err) => {
  console.error(err.message);
  process.exit(1);
});
