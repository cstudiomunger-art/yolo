#!/usr/bin/env node
import { createClient } from "@supabase/supabase-js";
import { mkdirSync, readFileSync, readdirSync, statSync, writeFileSync } from "fs";
import { basename, join } from "path";

const ROOT = "/Users/vesperal/Desktop/YOLO";
const SOURCE_ROOT = "/Users/vesperal/Downloads/后台填写信息汇总（照片+文字信息）";
const OUT_SQL = "/Users/vesperal/Desktop/YOLO/scripts/generated/sub_areas_from_selected_paths.sql";
const OUT_REPORT = "/Users/vesperal/Desktop/YOLO/scripts/generated/sub_areas_from_selected_paths_report.json";

const SELECTED_PATHS = [
  "/Users/vesperal/Downloads/后台填写信息汇总（照片+文字信息）/成都子景点/成都子景点-信息/成都博物馆子景点信息",
  "/Users/vesperal/Downloads/后台填写信息汇总（照片+文字信息）/重庆子景点/重庆子景点-信息",
  "/Users/vesperal/Downloads/后台填写信息汇总（照片+文字信息）/杭州子景点/法喜寺/法喜寺",
  "/Users/vesperal/Downloads/后台填写信息汇总（照片+文字信息）/杭州子景点/杭州大运河拱宸桥景区/大运河拱宸桥景区",
  "/Users/vesperal/Downloads/后台填写信息汇总（照片+文字信息）/杭州子景点/河坊街/河坊街",
  "/Users/vesperal/Downloads/后台填写信息汇总（照片+文字信息）/杭州子景点/京杭大运河/京杭大运河",
  "/Users/vesperal/Downloads/后台填写信息汇总（照片+文字信息）/杭州子景点/雷峰塔/雷峰塔",
  "/Users/vesperal/Downloads/后台填写信息汇总（照片+文字信息）/杭州子景点/良渚古城/良渚古城",
  "/Users/vesperal/Downloads/后台填写信息汇总（照片+文字信息）/杭州子景点/灵隐寺/灵隐寺",
  "/Users/vesperal/Downloads/后台填写信息汇总（照片+文字信息）/杭州子景点/六和塔/六和塔",
  "/Users/vesperal/Downloads/后台填写信息汇总（照片+文字信息）/杭州子景点/千岛湖/千岛湖",
  "/Users/vesperal/Downloads/后台填写信息汇总（照片+文字信息）/杭州子景点/丝绸博物馆/丝绸博物馆",
  "/Users/vesperal/Downloads/后台填写信息汇总（照片+文字信息）/杭州子景点/西湖/西湖",
  "/Users/vesperal/Downloads/后台填写信息汇总（照片+文字信息）/杭州子景点/西湖文化广场/西湖文化广场",
  "/Users/vesperal/Downloads/后台填写信息汇总（照片+文字信息）/杭州子景点/西溪国家湿地公园/西溪国家湿地公园",
  "/Users/vesperal/Downloads/后台填写信息汇总（照片+文字信息）/杭州子景点/小河直街/小河直街",
  "/Users/vesperal/Downloads/后台填写信息汇总（照片+文字信息）/杭州子景点/浙江省博物馆之江馆区/浙江省博物馆之江馆区",
  "/Users/vesperal/Downloads/后台填写信息汇总（照片+文字信息）/南京子景点/夫子庙/夫子庙.md",
  "/Users/vesperal/Downloads/后台填写信息汇总（照片+文字信息）/南京子景点/晨光1865科技创意产业园/晨光1865科技创意产业园.md",
  "/Users/vesperal/Downloads/后台填写信息汇总（照片+文字信息）/南京子景点/甘熙宅第/甘熙宅第.md",
  "/Users/vesperal/Downloads/后台填写信息汇总（照片+文字信息）/南京子景点/老门东历史文化街区/老门东历史文化街区.md",
  "/Users/vesperal/Downloads/后台填写信息汇总（照片+文字信息）/南京子景点/明城墙/明城墙.md",
  "/Users/vesperal/Downloads/后台填写信息汇总（照片+文字信息）/南京子景点/明孝陵/明孝陵.md",
  "/Users/vesperal/Downloads/后台填写信息汇总（照片+文字信息）/南京子景点/南京博物馆/南京博物院.md",
  "/Users/vesperal/Downloads/后台填写信息汇总（照片+文字信息）/南京子景点/南京大屠杀遇难同胞纪念馆/侵华日军南京大屠杀遇难同胞纪念馆.md",
  "/Users/vesperal/Downloads/后台填写信息汇总（照片+文字信息）/南京子景点/牛首山/牛首山.md",
  "/Users/vesperal/Downloads/后台填写信息汇总（照片+文字信息）/南京子景点/石臼湖/石臼湖.md",
  "/Users/vesperal/Downloads/后台填写信息汇总（照片+文字信息）/南京子景点/中山陵/中山陵.md",
  "/Users/vesperal/Downloads/后台填写信息汇总（照片+文字信息）/南京子景点/总统府/总统府.md",
  "/Users/vesperal/Downloads/后台填写信息汇总（照片+文字信息）/上海子景点/上海子景点-文字信息",
  "/Users/vesperal/Downloads/后台填写信息汇总（照片+文字信息）/苏州子景点/沧浪亭/苏州沧浪亭景点导览.md",
  "/Users/vesperal/Downloads/后台填写信息汇总（照片+文字信息）/苏州子景点/留园/苏州留园景点导览.md",
  "/Users/vesperal/Downloads/后台填写信息汇总（照片+文字信息）/苏州子景点/耦园/苏州藕园景点导览.md",
  "/Users/vesperal/Downloads/后台填写信息汇总（照片+文字信息）/苏州子景点/平江路历史街区/苏州平江路历史街区景点导览.md",
  "/Users/vesperal/Downloads/后台填写信息汇总（照片+文字信息）/苏州子景点/狮子林/苏州狮子林景点导览.md",
  "/Users/vesperal/Downloads/后台填写信息汇总（照片+文字信息）/苏州子景点/苏州博物馆/苏州博物馆景点导览.md",
  "/Users/vesperal/Downloads/后台填写信息汇总（照片+文字信息）/苏州子景点/苏州环秀山庄/苏州环秀山庄景点导览.md",
  "/Users/vesperal/Downloads/后台填写信息汇总（照片+文字信息）/苏州子景点/同里古镇/苏州同里古镇景点导览.md",
  "/Users/vesperal/Downloads/后台填写信息汇总（照片+文字信息）/苏州子景点/退思园/苏州退思园景点导览.md",
  "/Users/vesperal/Downloads/后台填写信息汇总（照片+文字信息）/苏州子景点/网师园/苏州网师园景点导览.md",
  "/Users/vesperal/Downloads/后台填写信息汇总（照片+文字信息）/苏州子景点/艺圃/苏州艺圃景点导览.md",
  "/Users/vesperal/Downloads/后台填写信息汇总（照片+文字信息）/苏州子景点/周庄古镇/苏州周庄古镇景点导览.md",
  "/Users/vesperal/Downloads/后台填写信息汇总（照片+文字信息）/苏州子景点/拙政园/苏州拙政园景点导览.md",
];

function readXcconfigValue(path, key) {
  const text = readFileSync(path, "utf8");
  const line = text.split(/\r?\n/).find((it) => it.trim().startsWith(`${key} =`));
  if (!line) return "";
  return line.split("=").slice(1).join("=").replace(/\$\(\)/g, "").trim();
}
function getSupabaseConfig() {
  const xc = join(ROOT, "Secrets.xcconfig");
  const url = process.env.SUPABASE_URL || readXcconfigValue(xc, "SUPABASE_URL");
  const key = process.env.SUPABASE_SERVICE_ROLE_KEY || process.env.SUPABASE_ANON_KEY || readXcconfigValue(xc, "SUPABASE_ANON_KEY");
  if (!url || !key) throw new Error("缺少 Supabase 配置");
  return { url, key };
}
function sqlStr(v) {
  if (v == null) return "NULL";
  return `'${String(v).replace(/'/g, "''")}'`;
}
function cleanMdMarks(s) {
  return String(s || "").replace(/\*\*/g, "").replace(/\*/g, "").replace(/`/g, "").trim();
}
function stripLeadingOrder(s) {
  return String(s || "").replace(/^\s*[0-9]{1,3}(?:[._-][0-9]{1,3})?\s*[.、:：\-_)\]]*\s*/u, "").trim();
}
function cjkRatio(s) {
  const txt = String(s || "");
  if (!txt) return 0;
  const cjk = (txt.match(/[\u4e00-\u9fff]/g) || []).length;
  return cjk / txt.length;
}
function extractEnglishFromMixedLine(line) {
  const m = String(line || "").match(/[A-Za-z][\s\S]*$/);
  return m ? cleanMdMarks(m[0]) : "";
}
function sectionBody(content, headingRegex) {
  const lines = content.split(/\r?\n/);
  let inSection = false;
  const out = [];
  for (const line of lines) {
    if (/^##\s+/.test(line)) {
      if (inSection) break;
      if (headingRegex.test(line)) {
        inSection = true;
        continue;
      }
    }
    if (inSection) out.push(line);
  }
  return out.join("\n").trim();
}
function parseTitle(line) {
  const t = cleanMdMarks(line.replace(/^#+\s*/, ""));
  if (t.includes("/")) {
    const [zh, en] = t.split("/").map((x) => x.trim());
    return { nameZh: zh || "", nameEn: en || "" };
  }
  return { nameZh: t, nameEn: "" };
}
function parseOneSubarea(content, fallbackName) {
  const lines = content.split(/\r?\n/);
  let title = "";
  for (const ln of lines) {
    if (/^#\s+/.test(ln)) {
      title = ln;
      break;
    }
  }
  let { nameZh, nameEn } = title ? parseTitle(title) : { nameZh: "", nameEn: "" };
  const nameSection = sectionBody(content, /^##\s*名字|^##\s*Name|^##\s*名字\s*\/\s*Name/i);
  if (nameSection) {
    const nls = nameSection.split(/\r?\n/).map((x) => cleanMdMarks(x)).filter(Boolean);
    if (!nameZh) nameZh = nls.find((x) => cjkRatio(x) > 0.2) || "";
    if (!nameEn) nameEn = nls.find((x) => /[A-Za-z]/.test(x) && cjkRatio(x) < 0.2) || "";
  }
  if (!nameZh) nameZh = fallbackName;
  if (!nameEn && nameZh.includes("/")) nameEn = nameZh.split("/")[1]?.trim() || "";
  nameZh = stripLeadingOrder(cleanMdMarks(nameZh.split("/")[0]));
  nameEn = stripLeadingOrder(cleanMdMarks(nameEn || ""));

  let detail = sectionBody(content, /^##\s*长文描述|^##\s*Detailed Description/i);
  if (!detail) {
    const mixed = content.split(/\r?\n/).find((x) => x.includes("长文描述 / Description") || x.includes("Detailed Description"));
    detail = mixed ? extractEnglishFromMixedLine(mixed) : "";
  }
  const englishLines = detail
    .split(/\r?\n/)
    .map((x) => cleanMdMarks(x))
    .filter(Boolean)
    .map((x) => (cjkRatio(x) < 0.35 ? x : extractEnglishFromMixedLine(x)))
    .filter((x) => /[A-Za-z]/.test(x));
  return { nameZh, nameEn, bodyEn: englishLines.join(" ") };
}
function splitByH3(content) {
  const lines = content.split(/\r?\n/);
  const chunks = [];
  let cur = null;
  for (const line of lines) {
    const m = line.match(/^###\s*([0-9]{1,3}(?:[._-][0-9]{1,3})?)\s*[.、\-_)\s]*\s*(.+)\s*$/);
    if (m) {
      if (cur) chunks.push(cur);
      cur = { title: m[2].trim(), lines: [] };
      continue;
    }
    if (cur) cur.lines.push(line);
  }
  if (cur) chunks.push(cur);
  return chunks;
}
function toMarkdown(text) {
  return cleanMdMarks(text).trim();
}
function collectMdFromPath(path, out) {
  const st = statSync(path, { throwIfNoEntry: false });
  if (!st) return;
  if (st.isDirectory()) {
    for (const n of readdirSync(path)) collectMdFromPath(join(path, n), out);
    return;
  }
  if (path.toLowerCase().endsWith(".md")) out.add(path);
}
function deriveAttractionNameFromPath(mdPath) {
  const rel = mdPath.replace(`${SOURCE_ROOT}/`, "");
  const parts = rel.split("/");
  const idxInfo = parts.findIndex((p) => p.includes("信息"));
  if (idxInfo >= 0 && parts[idxInfo + 1]) {
    return parts[idxInfo + 1]
      .replace(/子景点信息/g, "")
      .replace(/景点信息/g, "")
      .replace(/^成都|^上海|^重庆|^北京|^南京|^杭州|^苏州/g, "")
      .trim();
  }
  if (parts.length >= 2) return parts[parts.length - 2].trim();
  return "";
}

async function main() {
  mkdirSync(join(ROOT, "scripts/generated"), { recursive: true });
  const mdSet = new Set();
  for (const p of SELECTED_PATHS) collectMdFromPath(p, mdSet);
  const mdFiles = Array.from(mdSet).sort();

  const { url, key } = getSupabaseConfig();
  const supabase = createClient(url, key);
  const { data: attractions, error } = await supabase.from("attractions").select("id,chinese_name");
  if (error) throw new Error(error.message);

  const alias = new Map([
    ["国家博物馆", "国博"],
    ["成都博物院", "成都博物馆"],
    ["成都熊猫基地", "大熊猫基地"],
    ["南京博物馆", "南京博物院"],
    ["磁器口古镇", "磁器口"],
    ["解放碑-八一好吃街", "解放碑广场"],
  ]);

  const byAttractionId = new Map();
  const unmatchedAttractions = [];

  for (const path of mdFiles) {
    const raw = readFileSync(path, "utf8");
    const guessRaw = deriveAttractionNameFromPath(path);
    const guess = alias.get(guessRaw) || guessRaw;
    const parent =
      attractions.find((a) => String(a.chinese_name || "").trim() === guess) ||
      attractions.find((a) => String(a.chinese_name || "").includes(guess) || guess.includes(String(a.chinese_name || "")));
    if (!parent) {
      unmatchedAttractions.push({ path, attractionGuess: guessRaw });
      continue;
    }

    const list = byAttractionId.get(parent.id) || [];
    const chunks = splitByH3(raw);
    if (chunks.length) {
      for (const ch of chunks) {
        const parsed = parseOneSubarea(ch.lines.join("\n"), ch.title);
        const titleParts = ch.title.split("/").map((x) => x.trim());
        list.push({
          attractionId: parent.id,
          nameZh: stripLeadingOrder(parsed.nameZh || cleanMdMarks(titleParts[0] || ch.title)),
          nameEn: stripLeadingOrder(parsed.nameEn || cleanMdMarks(titleParts[1] || "")), // keep empty if missing
          body: toMarkdown(parsed.bodyEn),
        });
      }
    } else {
      const parsed = parseOneSubarea(raw, basename(path, ".md"));
      list.push({
        attractionId: parent.id,
        nameZh: stripLeadingOrder(parsed.nameZh || basename(path, ".md")),
        nameEn: stripLeadingOrder(parsed.nameEn || ""), // keep empty if missing
        body: toMarkdown(parsed.bodyEn),
      });
    }
    byAttractionId.set(parent.id, list);
  }

  const upsertRows = [];
  const inserts = [];
  let totalRows = 0;
  for (const [attrId, rows] of byAttractionId.entries()) {
    rows.forEach((r, idx) => {
      const id = `${attrId}_sa_${String(idx + 1).padStart(2, "0")}`;
      upsertRows.push({
        id,
        attraction_id: attrId,
        name_en: r.nameEn || "",
        name_zh: r.nameZh,
        body: r.body,
        sort_order: idx,
        is_active: true,
      });
      inserts.push(`INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  ${sqlStr(id)}, ${sqlStr(attrId)}, ${sqlStr(r.nameEn || "")}, ${sqlStr(r.nameZh)}, ${sqlStr(r.body)}, ${idx}, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();`);
      totalRows += 1;
    });
  }

  writeFileSync(OUT_SQL, `-- Generated from selected markdown paths\n${inserts.join("\n\n")}\n`, "utf8");

  let appliedRows = 0;
  const chunkSize = 200;
  for (let i = 0; i < upsertRows.length; i += chunkSize) {
    const chunk = upsertRows.slice(i, i + chunkSize);
    const { error: upErr } = await supabase.from("sub_areas").upsert(chunk, { onConflict: "id" });
    if (upErr) throw new Error(`upsert sub_areas 失败: ${upErr.message}`);
    appliedRows += chunk.length;
  }

  writeFileSync(
    OUT_REPORT,
    JSON.stringify(
      {
        generatedAt: new Date().toISOString(),
        selectedPathCount: SELECTED_PATHS.length,
        totalMdFiles: mdFiles.length,
        totalRows,
        totalAttractions: byAttractionId.size,
        unmatchedAttractionsCount: unmatchedAttractions.length,
        unmatchedAttractions,
        appliedRows,
      },
      null,
      2
    ),
    "utf8"
  );
  console.log(`sql: ${OUT_SQL}`);
  console.log(`report: ${OUT_REPORT}`);
  console.log(`rows: ${totalRows}, mdFiles: ${mdFiles.length}, unmatchedAttractions: ${unmatchedAttractions.length}, appliedRows: ${appliedRows}`);
}

main().catch((err) => {
  console.error(err.message);
  process.exit(1);
});
