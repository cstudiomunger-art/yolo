#!/usr/bin/env node
import { mkdirSync, readFileSync, readdirSync, statSync, writeFileSync } from "fs";
import { basename, join } from "path";

const ROOT = "/Users/vesperal/Desktop/YOLO";
const OUT_SQL = join(ROOT, "scripts/generated/city_guides_upsert.sql");
const OUT_REPORT = join(ROOT, "scripts/generated/city_guides_report.json");

const DEFAULT_ROOTS = [
  "/Users/vesperal/Desktop/00_城市总览",
  "/Users/vesperal/Desktop/00_城市总览(1)",
  "/Users/vesperal/Desktop/00_城市总览(2)",
  "/Users/vesperal/Desktop/00_城市总览(3)",
  "/Users/vesperal/Desktop/00_城市总览(4)",
  "/Users/vesperal/Desktop/北京京昆文化体验推荐指南",
  "/Users/vesperal/Desktop/北京吃喝指南",
  "/Users/vesperal/Desktop/北京独立咖啡体验指南",
  "/Users/vesperal/Desktop/北京胡同Citywalk指南",
  "/Users/vesperal/Desktop/北京米其林餐厅指南",
  "/Users/vesperal/Desktop/北京名人故居景点介绍",
  "/Users/vesperal/Desktop/北京最佳旅行季节指南",
  "/Users/vesperal/Desktop/北京城市魅力推介",
];

const CITY_PREFIX_TO_ID = {
  北京: "beijing",
  上海: "shanghai",
  南京: "nanjing",
  杭州: "hangzhou",
  成都: "chengdu",
  苏州: "suzhou",
};

const LEGACY_BEIJING_IDS = [
  "beijing_highlights",
  "beijing_best_season",
  "beijing_hutong_citywalk",
];

const FOLDER_ID_SLUGS = {
  北京城市魅力推介: "city_charm",
  北京最佳旅行季节指南: "best_season",
  北京胡同Citywalk指南: "hutong_citywalk",
  北京京昆文化体验推荐指南: "kunqu_culture",
  北京吃喝指南: "food_drink",
  北京名人故居景点介绍: "celebrity_residences",
  北京景点预约与排队攻略: "booking_tips",
  北京独立咖啡体验指南: "coffee",
  北京米其林餐厅指南: "michelin",
  北京美食推荐指南_隋坡推荐: "food_suipo",
  上海博物馆书画馆介绍: "museum_painting",
  上海博物馆外国游客推介: "museum_overview",
  上海博物馆明清家具馆介绍: "museum_furniture",
  上海博物馆玉器馆介绍: "museum_jade",
  上海外滩百年建筑深度游旅行指南: "bund_architecture",
  上海武康路街区景点介绍: "wukang_road",
  上海独立咖啡体验指南: "coffee",
  上海米其林餐厅指南: "michelin",
  上海美食推荐指南_隋坡推荐: "food_suipo",
  南京外国人本地文化活动指南: "local_culture",
  南京文化街区Citywalk指南: "districts_citywalk",
  南京独立咖啡体验指南: "coffee",
  南京米其林餐厅指南_App文案: "michelin",
  杭州梁祝化蝶: "butterfly_lovers",
  杭州独立精品咖啡推荐: "coffee",
  杭州米其林指南2026: "michelin_2026",
  杭州经典古代传说: "ancient_legends",
  杭州美食推荐指南_隋坡好评餐厅: "food_suipo",
  浙江省博物馆: "zhejiang_museum",
  成都博物馆官方旅行线路与景点介绍: "museum_routes",
  成都四川博物院参观路线与景点介绍: "sichuan_museum",
  成都独立咖啡体验指南: "coffee",
  苏州文化体验指南: "cultural_experiences",
  苏州汉服体验指南: "hanfu",
  苏州独立咖啡体验指南_TOP10: "coffee_top10",
  苏州米其林餐厅: "michelin",
};

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
    if (/^#\s+/.test(trimmed)) continue;
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
      const plainTitle = cleanPlain(titleEn);
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

const FOLDER_TITLE_EN = {
  北京最佳旅行季节指南: "Best Season to Visit Beijing",
  成都博物馆官方旅行线路与景点介绍: "Chengdu Museum: Official Visitor Routes and Attraction Guide",
  成都四川博物院参观路线与景点介绍: "Sichuan Museum: Visitor Routes and Attraction Guide",
};

function isSectionBoldTitle(text) {
  return /^(Part|Route|Chapter|Section)\s+/i.test(text) || /^[0-9]+[\.\)、]/.test(text);
}

function extractTitle(content, folderName) {
  if (FOLDER_TITLE_EN[folderName]) return FOLDER_TITLE_EN[folderName];

  const lines = String(content || "").split(/\r?\n/);
  for (const line of lines) {
    const trimmed = line.trim();
    if (/^#\s+/.test(trimmed) && !/^##/.test(trimmed)) {
      return cleanPlain(trimmed.replace(/^#\s+/, ""));
    }
  }
  for (const line of lines) {
    const trimmed = line.trim();
    if (/^##\s+/.test(trimmed)) {
      const title = cleanPlain(trimmed.replace(/^##\s+/, ""));
      if (!/^(Contents|目录|Introduction:|Visitor Notes)/i.test(title)) return title;
    }
  }
  for (const line of lines) {
    const bold = isBoldOnlyLine(line.trim());
    if (bold && !isSectionBoldTitle(bold)) return cleanPlain(bold);
  }
  return "";
}

function extractTitleZh(content, fallback) {
  const title = extractTitle(content);
  if (!title) return fallback;
  return title
    .replace(/[（(][^）)]*[A-Za-z][^）)]*[）)]/g, "")
    .replace(/\([^)]*[A-Za-z][^)]*\)/g, "")
    .replace(/\s+/g, " ")
    .trim();
}

function extractSubtitle(content) {
  const lines = String(content || "").split(/\r?\n/);
  const quotes = [];
  for (const line of lines) {
    const trimmed = line.trim();
    if (/^>\s/.test(trimmed)) {
      quotes.push(trimmed.replace(/^>\s*/, "").trim());
      continue;
    }
    if (quotes.length && trimmed) break;
  }
  if (!quotes.length) return null;
  const text = cleanPlain(quotes.join(" "));
  if (!text) return null;
  const sentence = text.match(/^.{20,220}?[.!?](?:\s|$)/)?.[0]?.trim() || text.slice(0, 160).trim();
  return sentence || null;
}

function stripBodySource(content, titleEn) {
  const lines = String(content || "").split(/\r?\n/);
  const out = [];
  let skippedTitle = false;
  let skippingQuotes = true;
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
      if (/^##\s+/.test(trimmed)) {
        if (!plainTitle || cleanPlain(trimmed.replace(/^##\s+/, "")) === plainTitle) {
          skippedTitle = true;
          continue;
        }
      }
      const bold = isBoldOnlyLine(trimmed);
      if (bold && plainTitle && cleanPlain(bold) === plainTitle) {
        skippedTitle = true;
        continue;
      }
    }
    if (skippingQuotes) {
      if (/^>\s/.test(trimmed)) continue;
      if (!trimmed || /^---+$/.test(trimmed)) continue;
      skippingQuotes = false;
    }
    if (/^---+$/.test(trimmed)) continue;
    out.push(line);
  }
  return out.join("\n").trim();
}

function extractMetaItems(content, folderName) {
  const isCitywalk = /citywalk|Citywalk|漫步|街区|胡同|外滩|武康路|文化街区/i.test(folderName);
  if (!isCitywalk) return [];

  const text = String(content || "");
  const items = [];

  const distance =
    text.match(/\*\*Total distance\*\*:\s*([^\n]+)/i)?.[1] ||
    text.match(/\*\*Distance\*\*:\s*([^\n]+)/i)?.[1] ||
    text.match(/Total distance:\s*([^\n]+)/i)?.[1];
  if (distance) items.push({ icon: "📏", label: "Distance", value: cleanPlain(distance) });

  const duration =
    text.match(/\*\*Recommended duration\*\*:\s*([^\n]+)/i)?.[1] ||
    text.match(/\*\*Duration\*\*:\s*([^\n]+)/i)?.[1] ||
    text.match(/Recommended duration:\s*([^\n]+)/i)?.[1];
  if (duration) items.push({ icon: "⏱", label: "Duration", value: cleanPlain(duration) });

  const stops =
    text.match(/\*\*Stops\*\*:\s*([0-9]+)/i)?.[1] ||
    text.match(/(\d+)\s+stops/i)?.[1];
  if (stops) items.push({ icon: "📍", label: "Stops", value: String(stops) });

  return items;
}

function inferIconAndBadge(folderName) {
  const name = folderName.toLowerCase();
  if (/citywalk|胡同|外滩|武康路|文化街区/.test(folderName)) return { icon: "🚶", badge: "Citywalk" };
  if (/咖啡|coffee/.test(name)) return { icon: "☕", badge: null };
  if (/米其林|michelin/.test(name)) return { icon: "🍽", badge: "Dining" };
  if (/博物馆|museum|博物院/.test(folderName)) return { icon: "🏛", badge: "Museum" };
  if (/美食|吃喝|餐厅|food/.test(name)) return { icon: "🍜", badge: "Food" };
  if (/季节|season/.test(name)) return { icon: "☀", badge: null };
  if (/汉服|hanfu/.test(name)) return { icon: "👘", badge: null };
  if (/传说|legend|梁祝|化蝶/.test(folderName)) return { icon: "📖", badge: "Culture" };
  if (/文化|kunqu|京昆|活动/.test(folderName)) return { icon: "🎭", badge: "Culture" };
  if (/预约|booking|排队/.test(folderName)) return { icon: "🎫", badge: "Tips" };
  if (/魅力|highlights|推介/.test(folderName)) return { icon: "✦", badge: null };
  if (/名人|故居/.test(folderName)) return { icon: "🏠", badge: null };
  return { icon: "✦", badge: null };
}

const FOLDER_CITY_OVERRIDES = {
  浙江省博物馆: "hangzhou",
};

function detectCityId(folderName, rootPath) {
  if (FOLDER_CITY_OVERRIDES[folderName]) return FOLDER_CITY_OVERRIDES[folderName];
  for (const [prefix, cityId] of Object.entries(CITY_PREFIX_TO_ID)) {
    if (folderName.startsWith(prefix)) return cityId;
  }
  const root = basename(rootPath);
  for (const [prefix, cityId] of Object.entries(CITY_PREFIX_TO_ID)) {
    if (root.includes(prefix)) return cityId;
  }
  return null;
}

function makeGuideId(folderName, cityId) {
  const slug = FOLDER_ID_SLUGS[folderName];
  if (!slug) throw new Error(`缺少 slug 映射: ${folderName}`);
  return `${cityId}_${slug}`;
}

function collectGuides(roots) {
  const guides = [];
  for (const root of roots) {
    const files = readdirSync(root);
    const enFile = files.find((f) => f.startsWith("EN_") && f.endsWith(".md"));
    if (enFile) {
      const zhFile = files.find((f) => f.startsWith("ZH_") && f.endsWith(".md")) || null;
      guides.push({
        folderName: basename(root),
        rootPath: root,
        enPath: join(root, enFile),
        zhPath: zhFile ? join(root, zhFile) : null,
      });
      continue;
    }
    for (const entry of files) {
      const dir = join(root, entry);
      if (!statSync(dir).isDirectory()) continue;
      const subFiles = readdirSync(dir);
      const subEn = subFiles.find((f) => f.startsWith("EN_") && f.endsWith(".md"));
      if (!subEn) continue;
      const subZh = subFiles.find((f) => f.startsWith("ZH_") && f.endsWith(".md")) || null;
      guides.push({
        folderName: entry,
        rootPath: root,
        enPath: join(dir, subEn),
        zhPath: subZh ? join(dir, subZh) : null,
      });
    }
  }
  return guides;
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

function parseGuide(entry, displayOrder) {
  const warnings = [];
  const enText = readFileSync(entry.enPath, "utf8");
  const zhText = entry.zhPath ? readFileSync(entry.zhPath, "utf8") : "";

  const cityId = detectCityId(entry.folderName, entry.rootPath);
  if (!cityId) warnings.push("city_id_not_detected");

  const titleEn = extractTitle(enText, entry.folderName) || entry.folderName;
  const titleZh = extractTitleZh(zhText, entry.folderName.replace(/^(北京|上海|南京|杭州|成都|苏州)/, "")) || null;
  if (!entry.zhPath) warnings.push("missing_zh_pair");

  const subtitle = extractSubtitle(enText);
  const bodySource = stripBodySource(enText, titleEn);
  const body = bodySource;
  if (!body) warnings.push("empty_body");

  const metaItems = extractMetaItems(enText, entry.folderName);
  const { icon, badge } = inferIconAndBadge(entry.folderName);
  const id = makeGuideId(entry.folderName, cityId);

  return {
    id,
    city_id: cityId,
    folder_name: entry.folderName,
    en_path: entry.enPath,
    zh_path: entry.zhPath,
    title_en: titleEn,
    title_zh: titleZh,
    subtitle,
    icon,
    badge,
    body,
    body_length: body.length,
    meta_items: metaItems,
    display_order: displayOrder,
    warnings,
  };
}

export function buildCityGuideRows(roots = DEFAULT_ROOTS) {
  const entries = collectGuides(roots);
  const byCity = new Map();
  for (const entry of entries) {
    const cityId = detectCityId(entry.folderName, entry.rootPath);
    if (!byCity.has(cityId)) byCity.set(cityId, []);
    byCity.get(cityId).push(entry);
  }

  const rows = [];
  for (const [, cityEntries] of [...byCity.entries()].sort(([a], [b]) => String(a).localeCompare(String(b)))) {
    cityEntries.sort((a, b) => a.folderName.localeCompare(b.folderName, "zh"));
    cityEntries.forEach((entry, index) => {
      rows.push(parseGuide(entry, index));
    });
  }

  return rows.sort((a, b) =>
    a.city_id === b.city_id ? a.display_order - b.display_order : String(a.city_id).localeCompare(String(b.city_id))
  );
}

function main() {
  const roots = process.argv.slice(2).length ? process.argv.slice(2) : DEFAULT_ROOTS;
  mkdirSync(join(ROOT, "scripts/generated"), { recursive: true });

  const rows = buildCityGuideRows(roots);
  const byCity = new Map();
  for (const row of rows) {
    if (!byCity.has(row.city_id)) byCity.set(row.city_id, []);
    byCity.get(row.city_id).push(row);
  }

  const beijingIds = rows.filter((r) => r.city_id === "beijing").map((r) => r.id);
  const deleteBeijingSql = `-- Beijing: remove all legacy guides before inserting new content
DELETE FROM city_guides WHERE city_id = 'beijing';

`;
  const sql = `-- Generated city_guides upsert from Desktop city overview markdown
-- Total guides: ${rows.length}
-- Beijing: full replace (${beijingIds.length} guides, legacy ids dropped: ${LEGACY_BEIJING_IDS.join(", ")})

${deleteBeijingSql}${rows.map(buildInsert).join("\n\n")}
`;
  writeFileSync(OUT_SQL, sql, "utf8");

  const report = {
    generatedAt: new Date().toISOString(),
    roots,
    beijingReplace: {
      deletedAllForCity: true,
      legacyIdsRemoved: LEGACY_BEIJING_IDS,
      newIds: beijingIds,
    },
    totals: {
      guides: rows.length,
      withWarnings: rows.filter((r) => r.warnings.length).length,
    },
    byCity: Object.fromEntries(
      [...byCity.keys()].sort().map((cityId) => [
        cityId,
        rows.filter((r) => r.city_id === cityId).map((r) => ({
          id: r.id,
          folder: r.folder_name,
          title_en: r.title_en,
          title_zh: r.title_zh,
          body_length: r.body_length,
          warnings: r.warnings,
        })),
      ]),
    ),
    guides: rows.map(({ body, ...rest }) => rest),
  };
  writeFileSync(OUT_REPORT, JSON.stringify(report, null, 2), "utf8");

  console.log(`Generated ${rows.length} city guides`);
  console.log(`SQL: ${OUT_SQL}`);
  console.log(`Report: ${OUT_REPORT}`);
  console.log(`Beijing: full replace with ${beijingIds.length} guides`);
  console.log(`Legacy Beijing ids removed: ${LEGACY_BEIJING_IDS.join(", ")}`);
  if (report.totals.withWarnings) {
    console.warn(`Warnings: ${report.totals.withWarnings} guides`);
  }
}

import { fileURLToPath } from "url";

if (process.argv[1] && fileURLToPath(import.meta.url) === process.argv[1]) {
  main();
}
