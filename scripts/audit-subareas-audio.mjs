#!/usr/bin/env node
import { mkdirSync, readFileSync, readdirSync, statSync, writeFileSync } from "fs";
import { join } from "path";

const ROOT = "/Users/vesperal/Desktop/YOLO";
const SOURCE_BENEDICT = "/Users/vesperal/Downloads/全量英文解说音频_Benedict";
const OUT_DIR = join(ROOT, "scripts/generated");
const OUT_FULL_LIST = join(OUT_DIR, "sub_areas_audio_audit_full_list.md");
const OUT_REPORT = join(OUT_DIR, "sub_areas_audio_audit_report.json");
const OUT_SUMMARY = join(OUT_DIR, "sub_areas_audio_audit_summary.md");
const AUDIO_BUCKET = "audio-guides";
const EXCLUDED_ATTRACTION_IDS = new Set(["chongqing_jiujie"]);

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
};

const cityFilter = (() => {
  const idx = process.argv.indexOf("--city");
  return idx >= 0 ? process.argv[idx + 1] : null;
})();

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

function normalizeName(value) {
  return String(value || "")
    .replace(/[（(].*?[）)]/g, "")
    .replace(/[·\-—–、，,。.\s]/g, "")
    .toLowerCase();
}

function parseNameHintFromFilename(filename) {
  const m = filename.match(/_\d+\.(.+?)\.mp3$/i);
  return m ? m[1].trim() : "";
}

function hasCjk(text) {
  return /[\u3400-\u9fff]/.test(text);
}

function normalizeEn(value) {
  return String(value || "")
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, " ")
    .trim();
}

function enRoughlyMatch(hint, dbEn) {
  const a = normalizeEn(hint);
  const b = normalizeEn(dbEn);
  if (!a || !b) return true;
  const aw = a.split(/\s+/).filter((w) => w.length > 3);
  const bw = b.split(/\s+/).filter((w) => w.length > 3);
  if (!aw.length || !bw.length) return a.includes(b) || b.includes(a);
  const overlap = aw.filter((w) => bw.some((x) => x.includes(w) || w.includes(x)));
  return overlap.length >= Math.min(2, Math.min(aw.length, bw.length));
}

function namesRoughlyMatch(hint, dbName, dbEn) {
  if (!hint) return true;
  if (hasCjk(hint)) {
    if (!dbName) return true;
    const a = normalizeName(hint);
    const b = normalizeName(dbName);
    if (!a || !b) return true;
    return a.includes(b) || b.includes(a) || a.slice(0, 4) === b.slice(0, 4);
  }
  return enRoughlyMatch(hint, dbEn);
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

async function headUrl(url) {
  try {
    const res = await fetch(url, { method: "HEAD" });
    return res.ok;
  } catch {
    return false;
  }
}

async function mapConcurrent(items, limit, fn) {
  const results = new Array(items.length);
  let i = 0;
  async function worker() {
    while (i < items.length) {
      const idx = i++;
      results[idx] = await fn(items[idx], idx);
    }
  }
  await Promise.all(Array.from({ length: Math.min(limit, items.length) }, () => worker()));
  return results;
}

function deriveStatus(issues) {
  if (!issues.length) return "ok";
  if (issues.includes("attraction_unmatched")) return "attraction_unmatched";
  if (issues.includes("db_row_missing")) return "missing_db";
  if (issues.includes("audio_url_empty")) return "missing_url";
  if (issues.includes("url_key_mismatch")) return "wrong_key";
  if (issues.includes("storage_missing")) return "storage_404";
  if (issues.includes("name_hint_mismatch")) return "sort_drift";
  return issues[0];
}

function issueLabels(issues) {
  const map = {
    attraction_unmatched: "主景点未匹配",
    db_row_missing: "DB 无对应子景点",
    audio_url_empty: "audio_url 为空",
    url_key_mismatch: "URL 与 storage key 不一致",
    storage_missing: "Storage 404",
    name_hint_mismatch: "文件名与中文名不匹配(可能 sort 错位)",
    count_mismatch: "音频数与 DB 子景点数不一致",
  };
  return issues.map((it) => map[it] || it).join("；");
}

function buildFullListMarkdown(report) {
  const lines = [
    "# 子景点解说音频逐项审计清单",
    "",
    `生成时间：${report.generatedAt}`,
    `数据源：${report.sourceRoot}`,
    cityFilter ? `城市过滤：${cityFilter}` : "",
    "",
    "## 统计摘要",
    "",
    `- 审计条目：${report.stats.totalItems}`,
    `- 通过 (ok)：${report.stats.ok}`,
    `- 上传绑定正确 (binding_ok)：${report.stats.bindingOk}`,
    `- 语义对应正确 (semantic_ok)：${report.stats.semanticOk}`,
    `- 有问题：${report.stats.notOk}`,
    "",
  ].filter(Boolean);

  for (const city of report.cities) {
    lines.push(`## ${city.city}`);
    lines.push("");
    for (const attr of city.attractions) {
      lines.push(`### ${attr.attractionNameZh}（${attr.folder}）`);
      lines.push("");
      lines.push(`- attraction_id: \`${attr.attractionId}\``);
      lines.push(`- Benedict 音频数：${attr.benedictCount}；DB 活跃子景点数：${attr.dbCount}`);
      if (attr.countMismatch) lines.push(`- **数量不一致**`);
      lines.push("");
      lines.push("| seq | sort | 中文名 | 源文件 | storage key | DB audio_url | Storage | 状态 | 问题 |");
      lines.push("| --- | --- | --- | --- | --- | --- | --- | --- | --- |");
      for (const item of attr.items) {
        const dbUrl = item.dbAudioUrl ? (item.dbAudioUrl.length > 48 ? "…" + item.dbAudioUrl.slice(-40) : item.dbAudioUrl) : "（空）";
        lines.push(
          `| ${item.seq} | ${item.sortOrder} | ${item.dbNameZh || "—"} | ${item.sourceFile} | ${item.storageKey} | ${dbUrl} | ${item.storageOk ? "200" : "404"} | ${item.status} | ${issueLabels(item.issues)} |`
        );
      }
      lines.push("");
    }
  }

  if (report.orphans.length) {
    lines.push("## 反向检查：DB 有 audio 但无 Benedict 源");
    lines.push("");
    for (const o of report.orphans) {
      lines.push(`- \`${o.subAreaId}\` ${o.nameZh} → ${o.audioUrl}`);
    }
    lines.push("");
  }

  return lines.join("\n");
}

function buildSummaryMarkdown(report) {
  const lines = [
    "# 子景点解说音频审计摘要",
    "",
    `生成时间：${report.generatedAt}`,
    "",
    "## 总体",
    "",
    "| 指标 | 数量 |",
    "| --- | --- |",
    `| 审计条目 | ${report.stats.totalItems} |`,
    `| 通过 (ok) | ${report.stats.ok} |`,
    `| 上传绑定正确 | ${report.stats.bindingOk} |`,
    `| 语义对应正确 | ${report.stats.semanticOk} |`,
    `| 有问题 | ${report.stats.notOk} |`,
    "",
    "## 问题类型",
    "",
    "| 类型 | 数量 |",
    "| --- | --- |",
  ];
  for (const [k, v] of Object.entries(report.stats.issueCounts).sort((a, b) => b[1] - a[1])) {
    lines.push(`| ${k} | ${v} |`);
  }
  lines.push("", "## 按城市", "", "| 城市 | 总数 | ok | 有问题 |", "| --- | --- | --- | --- |");
  for (const c of report.byCity) {
    lines.push(`| ${c.city} | ${c.total} | ${c.ok} | ${c.notOk} |`);
  }

  const focusCities = ["成都", "重庆"];
  for (const fc of focusCities) {
    const city = report.cities.find((c) => c.city === fc);
    if (!city) continue;
    const bad = [];
    for (const attr of city.attractions) {
      for (const item of attr.items) {
        if (item.status !== "ok") {
          bad.push({ ...item, attraction: attr.attractionNameZh, folder: attr.folder });
        }
      }
    }
    lines.push("", `## ${fc} 重点（非 ok 共 ${bad.length} 条）`, "");
    if (!bad.length) {
      lines.push("全部通过。");
      continue;
    }
    lines.push("| 主景点 | seq | 中文名 | 源文件 | 状态 | 问题 |");
    lines.push("| --- | --- | --- | --- | --- | --- |");
    for (const b of bad) {
      lines.push(`| ${b.attraction} | ${b.seq} | ${b.dbNameZh || "—"} | ${b.sourceFile} | ${b.status} | ${issueLabels(b.issues)} |`);
    }
  }

  return lines.join("\n");
}

async function main() {
  mkdirSync(OUT_DIR, { recursive: true });
  const { url: supabaseUrl } = getSupabaseConfig();

  const attractions = await (await rest("/rest/v1/attractions?select=id,chinese_name")).json();
  const subAreas = await (
    await rest("/rest/v1/sub_areas?select=id,attraction_id,sort_order,audio_url,name_zh,name_en,is_active")
  ).json();

  const dbByAttrSort = new Map();
  const dbById = new Map();
  const dbCountByAttr = new Map();
  for (const row of subAreas) {
    if (!row.is_active) continue;
    if (EXCLUDED_ATTRACTION_IDS.has(row.attraction_id)) continue;
    dbById.set(row.id, row);
    dbByAttrSort.set(`${row.attraction_id}:${row.sort_order}`, row);
    dbCountByAttr.set(row.attraction_id, (dbCountByAttr.get(row.attraction_id) || 0) + 1);
  }

  const expectedKeys = new Set();
  const allItems = [];
  const unmatchedAttractions = [];

  let cities = onlyDirs(SOURCE_BENEDICT).sort();
  if (cityFilter) cities = cities.filter((c) => c === cityFilter);

  for (const city of cities) {
    const cityPath = join(SOURCE_BENEDICT, city);
    for (const scenic of onlyDirs(cityPath).sort((a, b) => a.localeCompare(b, "zh-Hans-CN"))) {
      const parent = resolveAttraction(scenic, attractions);
      if (!parent) {
        unmatchedAttractions.push({ city, folder: scenic });
        continue;
      }
      if (EXCLUDED_ATTRACTION_IDS.has(parent.id)) continue;

      const files = collectAudioFiles(join(cityPath, scenic));
      const dbCount = dbCountByAttr.get(parent.id) || 0;
      const countMismatch = files.length !== dbCount;

      for (const entry of files) {
        const seq = entry.seq;
        if (!seq) continue;
        const sortOrder = seq - 1;
        const fileKey = storageFileKey(parent.id, seq);
        const expectedUrl = publicStorageUrl(supabaseUrl, fileKey);
        expectedKeys.add(`${parent.id}:${sortOrder}`);

        const sourceFile = entry.relDir ? `${entry.relDir}/${entry.file}` : entry.file;
        const nameHint = parseNameHintFromFilename(entry.file);
        const dbRow = dbByAttrSort.get(`${parent.id}:${sortOrder}`);
        const issues = [];

        if (countMismatch) issues.push("count_mismatch");

        if (!dbRow) {
          issues.push("db_row_missing");
        } else {
          const dbUrl = String(dbRow.audio_url || "").trim();
          if (!dbUrl) issues.push("audio_url_empty");
          else if (!dbUrl.includes(fileKey)) issues.push("url_key_mismatch");
          if (!namesRoughlyMatch(nameHint, dbRow.name_zh, dbRow.name_en)) issues.push("name_hint_mismatch");
        }

        const bindingOk =
          dbRow &&
          String(dbRow.audio_url || "").trim() &&
          String(dbRow.audio_url || "").includes(fileKey);

        allItems.push({
          city,
          folder: scenic,
          attractionId: parent.id,
          attractionNameZh: String(parent.chinese_name || "").trim(),
          benedictCount: files.length,
          dbCount,
          countMismatch,
          seq,
          sortOrder,
          sourceFile,
          nameHint,
          storageKey: fileKey,
          expectedUrl,
          dbSubAreaId: dbRow?.id || null,
          dbNameZh: dbRow?.name_zh || null,
          dbNameEn: dbRow?.name_en || null,
          dbAudioUrl: dbRow ? String(dbRow.audio_url || "").trim() : "",
          bindingOk: Boolean(bindingOk),
          issues,
          status: deriveStatus(issues.filter((i) => i !== "count_mismatch")),
          storageOk: null,
        });
      }
    }
  }

  const uniqueUrls = [...new Set(allItems.map((it) => it.dbAudioUrl).filter(Boolean))];
  const urlOkMap = new Map();
  const expectedUrls = [...new Set(allItems.map((it) => it.expectedUrl))];

  await mapConcurrent(expectedUrls, 12, async (u) => {
    urlOkMap.set(u, await headUrl(u));
  });
  await mapConcurrent(uniqueUrls.filter((u) => !urlOkMap.has(u)), 12, async (u) => {
    urlOkMap.set(u, await headUrl(u));
  });

  for (const item of allItems) {
    if (item.dbAudioUrl) {
      const ok = urlOkMap.get(item.dbAudioUrl);
      if (ok === false) item.issues.push("storage_missing");
    } else {
      const expectedOk = urlOkMap.get(item.expectedUrl);
      if (!expectedOk && !item.issues.includes("db_row_missing")) {
        item.issues.push("storage_missing");
      }
    }
    item.storageOk = item.dbAudioUrl
      ? urlOkMap.get(item.dbAudioUrl) === true
      : urlOkMap.get(item.expectedUrl) === true;
    item.status = deriveStatus(item.issues.filter((i) => i !== "count_mismatch"));
  }

  const orphans = [];
  for (const row of subAreas) {
    if (!row.is_active) continue;
    if (EXCLUDED_ATTRACTION_IDS.has(row.attraction_id)) continue;
    const audioUrl = String(row.audio_url || "").trim();
    if (!audioUrl) continue;
    const key = `${row.attraction_id}:${row.sort_order}`;
    if (!expectedKeys.has(key)) {
      orphans.push({
        subAreaId: row.id,
        attractionId: row.attraction_id,
        sortOrder: row.sort_order,
        nameZh: row.name_zh,
        audioUrl,
      });
    }
  }

  const issueCounts = {};
  let ok = 0;
  let notOk = 0;
  let bindingOk = 0;
  let semanticOk = 0;
  for (const item of allItems) {
    if (item.status === "ok") ok += 1;
    else notOk += 1;
    if (item.bindingOk) bindingOk += 1;
    if (item.status === "ok" || (item.bindingOk && !item.issues.includes("name_hint_mismatch"))) semanticOk += 1;
    for (const iss of item.issues) {
      issueCounts[iss] = (issueCounts[iss] || 0) + 1;
    }
  }

  const cityMap = new Map();
  for (const item of allItems) {
    if (!cityMap.has(item.city)) cityMap.set(item.city, { city: item.city, total: 0, ok: 0, notOk: 0, attractions: new Map() });
    const c = cityMap.get(item.city);
    c.total += 1;
    if (item.status === "ok") c.ok += 1;
    else c.notOk += 1;

    const attrKey = item.attractionId;
    if (!c.attractions.has(attrKey)) {
      c.attractions.set(attrKey, {
        folder: item.folder,
        attractionId: item.attractionId,
        attractionNameZh: item.attractionNameZh,
        benedictCount: item.benedictCount,
        dbCount: item.dbCount,
        countMismatch: item.countMismatch,
        items: [],
      });
    }
    c.attractions.get(attrKey).items.push(item);
  }

  const report = {
    generatedAt: new Date().toISOString(),
    sourceRoot: SOURCE_BENEDICT,
    cityFilter,
    stats: {
      totalItems: allItems.length,
      ok,
      notOk,
      bindingOk,
      semanticOk,
      unmatchedAttractions: unmatchedAttractions.length,
      orphans: orphans.length,
      issueCounts,
    },
    unmatchedAttractions,
    orphans,
    byCity: [...cityMap.values()].map((c) => ({ city: c.city, total: c.total, ok: c.ok, notOk: c.notOk })),
    cities: [...cityMap.values()].map((c) => ({
      city: c.city,
      attractions: [...c.attractions.values()].map((a) => ({
        ...a,
        items: a.items.sort((x, y) => x.seq - y.seq),
      })),
    })),
    items: allItems,
  };

  writeFileSync(OUT_REPORT, JSON.stringify(report, null, 2), "utf8");
  writeFileSync(OUT_FULL_LIST, buildFullListMarkdown(report), "utf8");
  writeFileSync(OUT_SUMMARY, buildSummaryMarkdown(report), "utf8");

  console.log(`report: ${OUT_REPORT}`);
  console.log(`full list: ${OUT_FULL_LIST}`);
  console.log(`summary: ${OUT_SUMMARY}`);
  console.log(JSON.stringify(report.stats, null, 2));
}

main().catch((err) => {
  console.error(err.message);
  process.exit(1);
});
