#!/usr/bin/env node
import { createClient } from "@supabase/supabase-js";
import { mkdirSync, readFileSync, readdirSync, statSync, writeFileSync } from "fs";
import { basename, join } from "path";

const ROOT = "/Users/vesperal/Desktop/YOLO";
const SOURCE_ROOT = "/Users/vesperal/Downloads/后台填写信息汇总（照片+文字信息）";
const OUT_SQL = "/Users/vesperal/Desktop/YOLO/scripts/generated/sub_areas_from_all_md.sql";
const OUT_REPORT = "/Users/vesperal/Desktop/YOLO/scripts/generated/sub_areas_from_all_md_report.json";

function readXcconfigValue(path, key) {
  const text = readFileSync(path, "utf8");
  const line = text.split(/\r?\n/).find((it) => it.trim().startsWith(`${key} =`));
  if (!line) return "";
  return line.split("=").slice(1).join("=").replace(/\$\(\)/g, "").trim();
}

function getSupabaseConfig() {
  const xc = join(ROOT, "Secrets.xcconfig");
  const url = process.env.SUPABASE_URL || readXcconfigValue(xc, "SUPABASE_URL");
  const key =
    process.env.SUPABASE_SERVICE_ROLE_KEY ||
    process.env.SUPABASE_ANON_KEY ||
    readXcconfigValue(xc, "SUPABASE_ANON_KEY");
  if (!url || !key) throw new Error("缺少 Supabase 配置");
  return { url, key };
}

function sqlStr(v) {
  if (v == null) return "NULL";
  return `'${String(v).replace(/'/g, "''")}'`;
}

function walkMdFiles(dir, acc = []) {
  for (const name of readdirSync(dir)) {
    const full = join(dir, name);
    const st = statSync(full);
    if (st.isDirectory()) {
      walkMdFiles(full, acc);
      continue;
    }
    if (name.toLowerCase().endsWith(".md")) acc.push(full);
  }
  return acc;
}

function cjkRatio(s) {
  const txt = String(s || "");
  if (!txt) return 0;
  const cjk = (txt.match(/[\u4e00-\u9fff]/g) || []).length;
  return cjk / txt.length;
}

function cleanMdMarks(s) {
  return String(s || "")
    .replace(/\*\*/g, "")
    .replace(/\*/g, "")
    .replace(/`/g, "")
    .trim();
}

function stripLeadingOrder(s) {
  return String(s || "")
    .replace(/^\s*[0-9]{1,3}(?:[._-][0-9]{1,3})?\s*[.、:：\-_)\]]*\s*/u, "")
    .trim();
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
    const nls = nameSection
      .split(/\r?\n/)
      .map((x) => cleanMdMarks(x))
      .filter(Boolean);
    if (!nameZh) nameZh = nls.find((x) => cjkRatio(x) > 0.2) || "";
    if (!nameEn) nameEn = nls.find((x) => /[A-Za-z]/.test(x) && cjkRatio(x) < 0.2) || "";
  }
  if (!nameZh) nameZh = fallbackName;
  if (!nameEn && nameZh.includes("/")) nameEn = nameZh.split("/")[1]?.trim() || "";
  if (!nameEn) nameEn = extractEnglishFromMixedLine(nameZh);
  nameZh = stripLeadingOrder(cleanMdMarks(nameZh.split("/")[0]).trim());
  nameEn = stripLeadingOrder(cleanMdMarks(nameEn).trim());

  let detail = sectionBody(content, /^##\s*长文描述|^##\s*Detailed Description/i);
  if (!detail) {
    const mixed = content
      .split(/\r?\n/)
      .find((x) => x.includes("长文描述 / Description") || x.includes("Detailed Description"));
    detail = mixed ? extractEnglishFromMixedLine(mixed) : "";
  }

  const englishLines = detail
    .split(/\r?\n/)
    .map((x) => cleanMdMarks(x))
    .filter(Boolean)
    .map((x) => (cjkRatio(x) < 0.35 ? x : extractEnglishFromMixedLine(x)))
    .filter((x) => /[A-Za-z]/.test(x));
  const bodyEn = englishLines.join(" ");
  return { nameZh, nameEn, bodyEn };
}

function splitByH3(content) {
  const lines = content.split(/\r?\n/);
  const chunks = [];
  let cur = null;
  for (const line of lines) {
    const m = line.match(/^###\s*([0-9]{1,3}(?:[._-][0-9]{1,3})?)\s*[.、\-_)\s]*\s*(.+)\s*$/);
    if (m) {
      if (cur) chunks.push(cur);
      cur = { seq: m[1], title: m[2].trim(), lines: [] };
      continue;
    }
    if (cur) cur.lines.push(line);
  }
  if (cur) chunks.push(cur);
  return chunks;
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

function toHtml(text) {
  const safe = cleanMdMarks(text).replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
  return safe ? `<p>${safe}</p>` : "";
}

function generatedEnglishName(attractionId, order) {
  const base = String(attractionId || "sub_area")
    .replace(/_/g, " ")
    .trim();
  return `${base} sub area ${String(order + 1).padStart(2, "0")}`;
}

async function main() {
  mkdirSync(join(ROOT, "scripts/generated"), { recursive: true });
  const mdFiles = walkMdFiles(SOURCE_ROOT).sort();
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
    const attractionGuessRaw = deriveAttractionNameFromPath(path);
    const attractionGuess = alias.get(attractionGuessRaw) || attractionGuessRaw;
    const parent =
      attractions.find((a) => String(a.chinese_name || "").trim() === attractionGuess) ||
      attractions.find((a) => String(a.chinese_name || "").includes(attractionGuess) || attractionGuess.includes(String(a.chinese_name || "")));
    if (!parent) {
      unmatchedAttractions.push({ path, attractionGuess: attractionGuessRaw });
      continue;
    }

    const chunks = splitByH3(raw);
    const targetList = byAttractionId.get(parent.id) || [];
    if (chunks.length) {
      for (const ch of chunks) {
        const parsed = parseOneSubarea(ch.lines.join("\n"), ch.title);
        const titleParts = ch.title.split("/").map((x) => x.trim());
        const nameZh = stripLeadingOrder(parsed.nameZh || cleanMdMarks(titleParts[0] || ch.title));
        const nameEn = stripLeadingOrder(parsed.nameEn || cleanMdMarks(titleParts[1] || ""));
        targetList.push({
          attractionId: parent.id,
          nameZh,
          nameEn,
          body: toHtml(parsed.bodyEn),
        });
      }
    } else {
      const parsed = parseOneSubarea(raw, basename(path, ".md"));
      targetList.push({
        attractionId: parent.id,
        nameZh: stripLeadingOrder(parsed.nameZh || basename(path, ".md")),
        nameEn: stripLeadingOrder(parsed.nameEn || ""),
        body: toHtml(parsed.bodyEn),
      });
    }
    byAttractionId.set(parent.id, targetList);
  }

  const inserts = [];
  const upsertRows = [];
  let totalRows = 0;
  for (const [attrId, rows] of byAttractionId.entries()) {
    rows.forEach((r, idx) => {
      const id = `${attrId}_sa_${String(idx + 1).padStart(2, "0")}`;
      const finalNameEn = r.nameEn && r.nameEn.trim() ? r.nameEn.trim() : generatedEnglishName(attrId, idx);
      upsertRows.push({
        id,
        attraction_id: attrId,
        name_en: finalNameEn,
        name_zh: r.nameZh,
        body: r.body,
        sort_order: idx,
        is_active: true,
      });
      inserts.push(`INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  ${sqlStr(id)}, ${sqlStr(attrId)}, ${sqlStr(finalNameEn)}, ${sqlStr(r.nameZh)}, ${sqlStr(r.body)}, ${idx}, TRUE
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

  const sql = `-- Generated from all markdown files under backend source\n${inserts.join("\n\n")}\n`;
  writeFileSync(OUT_SQL, sql, "utf8");

  let applied = false;
  let appliedRows = 0;
  if (process.env.APPLY_TO_DB === "1") {
    const chunkSize = 200;
    for (let i = 0; i < upsertRows.length; i += chunkSize) {
      const chunk = upsertRows.slice(i, i + chunkSize);
      const { error: upErr } = await supabase
        .from("sub_areas")
        .upsert(chunk, { onConflict: "id" });
      if (upErr) throw new Error(`upsert sub_areas 失败: ${upErr.message}`);
      appliedRows += chunk.length;
    }
    applied = true;
  }

  writeFileSync(
    OUT_REPORT,
    JSON.stringify(
      {
        generatedAt: new Date().toISOString(),
        sourceRoot: SOURCE_ROOT,
        totalMdFiles: mdFiles.length,
        totalRows,
        totalAttractions: byAttractionId.size,
        unmatchedAttractionsCount: unmatchedAttractions.length,
        unmatchedAttractions,
        applied,
        appliedRows,
      },
      null,
      2
    ),
    "utf8"
  );

  console.log(`sql: ${OUT_SQL}`);
  console.log(`report: ${OUT_REPORT}`);
  console.log(`rows: ${totalRows}, mdFiles: ${mdFiles.length}, unmatchedAttractions: ${unmatchedAttractions.length}`);
  if (applied) console.log(`appliedRows: ${appliedRows}`);
}

main().catch((err) => {
  console.error(err.message);
  process.exit(1);
});
