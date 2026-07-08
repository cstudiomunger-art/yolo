#!/usr/bin/env node
import { mkdirSync, readFileSync, writeFileSync } from "fs";
import { basename, join } from "path";

const ROOT = "/Users/vesperal/Desktop/YOLO";
const OUT_SQL = join(ROOT, "scripts/generated/beijing_sub_areas_from_guides_upsert.sql");
const OUT_REPORT = join(ROOT, "scripts/generated/beijing_sub_areas_from_guides_report.json");

const SOURCE_FILES = [
  "/Users/vesperal/Desktop/北京雍和宫景点导览.md",
  "/Users/vesperal/Desktop/北京颐和园景点导览.md",
  "/Users/vesperal/Desktop/北京天坛景点导览.md",
  "/Users/vesperal/Desktop/北京十三陵景点导览.md",
  "/Users/vesperal/Desktop/北京慕田峪长城景点导览.md",
  "/Users/vesperal/Desktop/北京国家博物馆景点导览.md",
  "/Users/vesperal/Desktop/北京故宫景点导览.md",
  "/Users/vesperal/Desktop/北京恭王府景点导览.md",
  "/Users/vesperal/Desktop/北京北海公园景点导览.md",
];

const ATTRACTION_BY_KEY = {
  雍和宫: "beijing_lama_temple",
  颐和园: "beijing_summer_palace",
  天坛: "beijing_temple_of_heaven",
  十三陵: "beijing_ming_tombs",
  慕田峪长城: "beijing_mutianyu_great_wall",
  国家博物馆: "beijing_national_museum",
  故宫: "beijing_forbidden_city",
  恭王府: "beijing_prince_gong_mansion",
  北海公园: "beijing_beihai_park",
};

function sqlStr(v) {
  if (v == null) return "NULL";
  return `'${String(v).replace(/'/g, "''")}'`;
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

function cjkRatio(s) {
  const txt = String(s || "");
  if (!txt) return 0;
  return (txt.match(/[\u4e00-\u9fff]/g) || []).length / txt.length;
}

function extractEnglishFromMixedLine(line) {
  const m = String(line || "").match(/[A-Za-z][\s\S]*$/);
  return m ? cleanMdMarks(m[0]) : "";
}

function splitZhEn(text) {
  const raw = cleanMdMarks(text);
  if (!raw.includes("/")) {
    return cjkRatio(raw) > 0.2
      ? { nameZh: stripLeadingOrder(raw), nameEn: extractEnglishFromMixedLine(raw) }
      : { nameZh: "", nameEn: stripLeadingOrder(raw) };
  }
  const [left, right] = raw.split("/").map((x) => x.trim());
  const nameZh = stripLeadingOrder(cjkRatio(left) >= cjkRatio(right) ? left : right);
  const nameEn = stripLeadingOrder(cjkRatio(left) < cjkRatio(right) ? left : right);
  return { nameZh, nameEn };
}

function fieldValueFromLine(line, label) {
  const plain = String(line || "");
  const idx = plain.indexOf(label);
  if (idx < 0) return "";
  return plain
    .slice(idx + label.length)
    .replace(/^\s*[:：]\s*/, "")
    .trim();
}

function extractEnglishDescription(sectionLines) {
  const lines = sectionLines.slice();
  let start = -1;
  for (let i = 0; i < lines.length; i += 1) {
    if (/长文描述\s*\/\s*Description|Detailed Description/i.test(lines[i])) {
      start = i;
      break;
    }
  }
  if (start < 0) return "";

  const englishParts = [];
  const first = extractEnglishFromMixedLine(fieldValueFromLine(lines[start], "长文描述 / Description"));
  if (first) englishParts.push(first);

  for (let i = start + 1; i < lines.length; i += 1) {
    const trimmed = lines[i].trim();
    if (!trimmed) continue;
    if (/^---+$/.test(trimmed)) break;
    if (/^\-\s+\*\*/.test(trimmed)) break;
    const plain = cleanMdMarks(trimmed);
    if (!plain) continue;
    if (cjkRatio(plain) < 0.35 && /[A-Za-z]/.test(plain)) {
      englishParts.push(plain);
      continue;
    }
    const mixed = extractEnglishFromMixedLine(plain);
    if (mixed) englishParts.push(mixed);
  }

  return englishParts.join(" ").replace(/\s+/g, " ").trim();
}

function toHtml(text) {
  const safe = cleanMdMarks(text)
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;");
  return safe ? `<p>${safe}</p>` : "";
}

function splitByH3(content) {
  const lines = content.split(/\r?\n/);
  const chunks = [];
  let cur = null;
  for (const line of lines) {
    const m = line.match(/^###\s*([0-9]{1,3}(?:[._-][0-9]{1,3})?)\s*[.、\-_)\s]*\s*(.+)\s*$/);
    if (m) {
      if (cur) chunks.push(cur);
      cur = { seq: m[1], heading: m[2].trim(), lines: [] };
      continue;
    }
    if (cur) cur.lines.push(line);
  }
  if (cur) chunks.push(cur);
  return chunks;
}

function detectAttractionId(filePath) {
  const name = basename(filePath, ".md");
  const key = Object.keys(ATTRACTION_BY_KEY).find((k) => name.includes(k));
  if (!key) throw new Error(`无法从文件名识别景点: ${filePath}`);
  return { key, attractionId: ATTRACTION_BY_KEY[key] };
}

function parseSection(chunk, order, attractionId) {
  const headingParts = splitZhEn(chunk.heading);
  let nameZh = headingParts.nameZh;
  let nameEn = headingParts.nameEn;

  for (const line of chunk.lines) {
    if (/名字\s*\/\s*Name/i.test(line)) {
      const value = fieldValueFromLine(line, "名字 / Name");
      const parsed = splitZhEn(value);
      if (parsed.nameZh) nameZh = parsed.nameZh;
      if (parsed.nameEn) nameEn = parsed.nameEn;
      break;
    }
  }

  const bodyEn = extractEnglishDescription(chunk.lines);
  if (!bodyEn) throw new Error(`${attractionId} #${chunk.seq} 缺少英文长文描述`);

  return {
    id: `${attractionId}_bj_sa_${String(order + 1).padStart(2, "0")}`,
    attraction_id: attractionId,
    name_zh: nameZh,
    name_en: nameEn,
    body: toHtml(bodyEn),
    body_length: bodyEn.length,
    sort_order: order,
    seq: chunk.seq,
    heading: chunk.heading,
  };
}

function buildInsert(row) {
  return `INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  ${sqlStr(row.id)},
  ${sqlStr(row.attraction_id)},
  ${sqlStr(row.name_en)},
  ${sqlStr(row.name_zh)},
  ${sqlStr(row.body)},
  ${row.sort_order},
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();`;
}

function main() {
  mkdirSync(join(ROOT, "scripts/generated"), { recursive: true });

  const allRows = [];
  const byAttraction = [];

  for (const filePath of SOURCE_FILES) {
    const { key, attractionId } = detectAttractionId(filePath);
    const content = readFileSync(filePath, "utf8");
    const chunks = splitByH3(content);
    if (!chunks.length) throw new Error(`${filePath} 未解析到 ### 子景点`);

    const rows = chunks.map((chunk, order) => parseSection(chunk, order, attractionId));
    allRows.push(...rows);
    byAttraction.push({
      sourceFile: filePath,
      attractionKey: key,
      attractionId,
      subAreaCount: rows.length,
      subAreas: rows.map(({ body, ...rest }) => rest),
    });
  }

  const sql = `-- Generated Beijing sub_areas from Desktop 景点导览 markdown
-- Updates text fields only; preserves existing cover_image_path and audio_url
-- Generated: ${new Date().toISOString()}
-- Total sub_areas: ${allRows.length}

${allRows.map(buildInsert).join("\n\n")}
`;

  writeFileSync(OUT_SQL, sql, "utf8");
  writeFileSync(
    OUT_REPORT,
    `${JSON.stringify(
      {
        generatedAt: new Date().toISOString(),
        sqlPath: OUT_SQL,
        totalSubAreas: allRows.length,
        totalAttractions: byAttraction.length,
        attractions: byAttraction,
      },
      null,
      2
    )}\n`,
    "utf8"
  );

  console.log(`Generated ${allRows.length} sub_areas for ${byAttraction.length} attractions`);
  console.log(`SQL: ${OUT_SQL}`);
  console.log(`Report: ${OUT_REPORT}`);
  for (const item of byAttraction) {
    console.log(`  ${item.attractionKey} (${item.attractionId}): ${item.subAreaCount} sub_areas`);
  }
}

main();
