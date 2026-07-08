#!/usr/bin/env node
import { mkdirSync, readFileSync, writeFileSync } from "fs";
import { join } from "path";

const ROOT = "/Users/vesperal/Desktop/YOLO";
const SOURCE_ROOT = "/Users/vesperal/Desktop/重庆文化探索补充";
const OUT_SQL = join(ROOT, "scripts/generated/chongqing_cultural_guides_upsert.sql");
const OUT_REPORT = join(ROOT, "scripts/generated/chongqing_cultural_guides_report.json");

const CITY_ID = "chongqing";

const SOURCES = [
  {
    file: "Chongqing_Republican_Era_Citywalk_revised.md",
    id: "chongqing_republican_citywalk",
    title_zh: "民国建筑 Citywalk",
    icon: "🚶",
    badge: "Citywalk",
    display_order: 0,
    meta_items: [{ icon: "📍", label: "Stops", value: "4 districts" }],
  },
  {
    file: "Anderson_Warehouse_Memorial_REVISED.md",
    id: "chongqing_palace_museum_southern_relocation",
    title_zh: "故宫文物南迁纪念馆",
    icon: "🏛",
    badge: "Culture",
    display_order: 1,
    meta_items: [],
  },
];

function sqlStr(v) {
  if (v == null) return "NULL";
  return `'${String(v).replace(/'/g, "''")}'`;
}

function sqlJson(v) {
  return `'${JSON.stringify(v).replace(/'/g, "''")}'::jsonb`;
}

function escapeHtml(s) {
  return String(s || "")
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;");
}

function inlineMd(s) {
  return escapeHtml(s).replace(/\*\*(.+?)\*\*/g, (_, t) => `<strong>${escapeHtml(t)}</strong>`);
}

function cleanPlain(s) {
  return String(s || "")
    .replace(/\*\*/g, "")
    .replace(/\*/g, "")
    .replace(/`/g, "")
    .trim();
}

function isBoldOnlyLine(line) {
  const m = String(line || "").trim().match(/^\*\*(.+)\*\*$/);
  return m ? m[1].trim() : null;
}

function boldHeadingLevel(text) {
  if (/^(Part|Route|Chapter)\s+/i.test(text)) return 2;
  if (/^[0-9]+[\.\)、]/.test(text)) return 3;
  if (text.length <= 90) return 2;
  return 3;
}

function mdToHtml(raw, { titleEn = "" } = {}) {
  const lines = String(raw || "").split(/\r?\n/);
  const out = [];
  let paraBuf = [];
  let listBuf = [];
  const plainTitle = cleanPlain(titleEn);

  function flushPara() {
    if (!paraBuf.length) return;
    const text = paraBuf.join(" ").trim();
    paraBuf = [];
    if (text) out.push(`<p>${inlineMd(text)}</p>`);
  }

  function flushList() {
    if (!listBuf.length) return;
    out.push(`<ul>${listBuf.map((it) => `<li>${inlineMd(it)}</li>`).join("")}</ul>`);
    listBuf = [];
  }

  for (const rawLine of lines) {
    const line = rawLine.trimEnd();
    const trimmed = line.trim();

    if (!trimmed) {
      flushPara();
      flushList();
      continue;
    }
    if (/^---+$/.test(trimmed)) continue;
    if (/^>\s?/.test(trimmed)) continue;
    if (/^#\s+/.test(trimmed) && !/^##/.test(trimmed)) {
      if (!plainTitle || cleanPlain(trimmed.replace(/^#\s+/, "")) === plainTitle) continue;
    }
    if (/^##\s+/.test(trimmed)) {
      flushPara();
      flushList();
      out.push(`<h2>${inlineMd(trimmed.replace(/^##\s+/, ""))}</h2>`);
      continue;
    }
    if (/^###\s+/.test(trimmed)) {
      flushPara();
      flushList();
      out.push(`<h3>${inlineMd(trimmed.replace(/^###\s+/, ""))}</h3>`);
      continue;
    }
    if (/^\s*-\s+/.test(line)) {
      flushPara();
      listBuf.push(line.replace(/^\s*-\s+/, "").trim());
      continue;
    }

    const boldOnly = isBoldOnlyLine(trimmed);
    if (boldOnly) {
      if (plainTitle && cleanPlain(boldOnly) === plainTitle) continue;
      flushPara();
      flushList();
      const level = boldHeadingLevel(boldOnly);
      out.push(`<h${level}>${inlineMd(boldOnly)}</h${level}>`);
      continue;
    }

    flushList();
    paraBuf.push(trimmed);
  }

  flushPara();
  flushList();
  return out.join("");
}

function extractTitle(content) {
  for (const line of String(content || "").split(/\r?\n/)) {
    const trimmed = line.trim();
    if (/^#\s+/.test(trimmed) && !/^##/.test(trimmed)) {
      return cleanPlain(trimmed.replace(/^#\s+/, ""));
    }
  }
  return "";
}

function extractSubtitle(content, titleEn) {
  const lines = String(content || "").split(/\r?\n/);
  let passedTitle = false;
  const plainTitle = cleanPlain(titleEn);

  for (const line of lines) {
    const trimmed = line.trim();
    if (!passedTitle) {
      if (/^#\s+/.test(trimmed) && !/^##/.test(trimmed)) {
        passedTitle = true;
        continue;
      }
      continue;
    }
    if (!trimmed || /^---+$/.test(trimmed) || /^>\s/.test(trimmed)) continue;
    if (/^#{2,3}\s+/.test(trimmed)) continue;
    if (/^\*\*/.test(trimmed)) continue;
    const text = cleanPlain(trimmed);
    if (!text || text.length < 40) continue;
    const sentence = text.match(/^.{40,220}?[.!?](?:\s|$)/)?.[0]?.trim() || text.slice(0, 180).trim();
    return sentence || null;
  }
  return null;
}

function stripBodySource(content, titleEn) {
  const lines = String(content || "").split(/\r?\n/);
  const out = [];
  let skippedTitle = false;
  const plainTitle = cleanPlain(titleEn);

  for (const line of lines) {
    const trimmed = line.trim();
    if (!skippedTitle) {
      if (/^#\s+/.test(trimmed) && !/^##/.test(trimmed)) {
        if (!plainTitle || cleanPlain(trimmed.replace(/^#\s+/, "")) === plainTitle) {
          skippedTitle = true;
          continue;
        }
      }
    }
    if (/^---+$/.test(trimmed)) continue;
    out.push(line);
  }
  return out.join("\n").trim();
}

function buildInsert(row) {
  return `INSERT INTO city_guides (
  id, city_id, title_en, title_zh, subtitle, icon, badge,
  cover_images, body, meta_items, display_order, is_published
) VALUES (
  ${sqlStr(row.id)},
  ${sqlStr(row.city_id)},
  ${sqlStr(row.title_en)},
  ${sqlStr(row.title_zh)},
  ${sqlStr(row.subtitle)},
  ${sqlStr(row.icon)},
  ${sqlStr(row.badge)},
  ARRAY[]::TEXT[],
  ${sqlStr(row.body)},
  ${sqlJson(row.meta_items)},
  ${row.display_order},
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  city_id = EXCLUDED.city_id,
  title_en = EXCLUDED.title_en,
  title_zh = EXCLUDED.title_zh,
  subtitle = EXCLUDED.subtitle,
  icon = EXCLUDED.icon,
  badge = EXCLUDED.badge,
  cover_images = EXCLUDED.cover_images,
  body = EXCLUDED.body,
  meta_items = EXCLUDED.meta_items,
  audio_url = NULL,
  audio_title = NULL,
  audio_duration_seconds = 0,
  audio_quote = NULL,
  audio_transcript = NULL,
  display_order = EXCLUDED.display_order,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();`;
}

function parseSource(source) {
  const path = join(SOURCE_ROOT, source.file);
  const content = readFileSync(path, "utf8");
  const titleEn = extractTitle(content);
  if (!titleEn) throw new Error(`Missing title in ${source.file}`);

  const subtitle = extractSubtitle(content, titleEn);
  const body = mdToHtml(stripBodySource(content, titleEn), { titleEn });
  if (!body) throw new Error(`Empty body in ${source.file}`);

  return {
    id: source.id,
    city_id: CITY_ID,
    source_file: source.file,
    title_en: titleEn,
    title_zh: source.title_zh,
    subtitle,
    icon: source.icon,
    badge: source.badge,
    body,
    body_length: body.length,
    meta_items: source.meta_items,
    display_order: source.display_order,
  };
}

function main() {
  mkdirSync(join(ROOT, "scripts/generated"), { recursive: true });

  const rows = SOURCES.map(parseSource);
  const sql = `-- Generated city_guides upsert for Chongqing cultural exploration supplements
-- Source: ${SOURCE_ROOT}
-- Generated: ${new Date().toISOString()}
-- Guides: ${rows.length}

${rows.map(buildInsert).join("\n\n")}
`;

  writeFileSync(OUT_SQL, sql, "utf8");
  writeFileSync(
    OUT_REPORT,
    `${JSON.stringify(
      {
        generatedAt: new Date().toISOString(),
        sourceRoot: SOURCE_ROOT,
        cityId: CITY_ID,
        sqlPath: OUT_SQL,
        guides: rows.map(({ body, ...rest }) => rest),
      },
      null,
      2
    )}\n`,
    "utf8"
  );

  console.log(`Generated ${rows.length} Chongqing city guides`);
  console.log(`SQL: ${OUT_SQL}`);
  console.log(`Report: ${OUT_REPORT}`);
  for (const row of rows) {
    console.log(`  ${row.id}: ${row.body_length} chars — ${row.title_en}`);
  }
}

main();
