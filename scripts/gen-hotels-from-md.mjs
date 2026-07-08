#!/usr/bin/env node
import { mkdirSync, readFileSync, writeFileSync } from "fs";
import { join } from "path";

const ROOT = "/Users/vesperal/Desktop/YOLO";
const OUT_DIR = join(ROOT, "scripts/generated");

const CITY_SOURCES = [
  {
    cityId: "beijing",
    path: "/Users/vesperal/Desktop/EN_Beijing_Hotel_Recommendations.md",
    inactiveTierCodes: [],
  },
  {
    cityId: "shanghai",
    path: "/Users/vesperal/Desktop/EN_Shanghai_Hotel_Recommendations.md",
    inactiveTierCodes: [],
  },
  {
    cityId: "chongqing",
    path: "/Users/vesperal/Desktop/EN_Chongqing_Hotel_Recommendations.md",
    inactiveTierCodes: [],
  },
  {
    cityId: "nanjing",
    path: "/Users/vesperal/Desktop/EN_Nanjing_Hotel_Recommendations.md",
    inactiveTierCodes: [],
  },
  {
    cityId: "hangzhou",
    path: "/Users/vesperal/Desktop/EN_Hangzhou_Hotel_Recommendations.md",
    inactiveTierCodes: ["H3-2"],
  },
  {
    cityId: "suzhou",
    path: "/Users/vesperal/Desktop/EN_Suzhou_Hotel_Recommendations.md",
    inactiveTierCodes: [],
  },
  {
    cityId: "chengdu",
    path: "/Users/vesperal/Desktop/ZH_Chengdu_Hotel_Recommendations_EN.md",
    inactiveTierCodes: [],
  },
];

const CHENGDU_ID_BY_TIER = {
  "T1-1": "hotel_chengdu_temple_house",
  "T1-2": "hotel_chengdu_niccolo",
  "T1-3": "hotel_chengdu_wanda_reign",
  "T1-4": "hotel_chengdu_jw_marriott",
  "T1-5": "hotel_chengdu_shangri_la",
  "T1-6": "hotel_chengdu_palm_springs",
  "T1-7": "hotel_chengdu_intercontinental_century_city",
  "T1-8": "hotel_chengdu_hanshi_wuhou",
  "T2-1": "hotel_chengdu_holiday_inn_express_gulou",
  "T2-2": "hotel_chengdu_hampton_chunxi",
  "T2-3": "hotel_chengdu_hilton_garden_kuanzhai",
  "T2-4": "hotel_chengdu_atour_taikoo_li",
  "T2-5": "hotel_chengdu_ji_kuanzhai",
  "T2-6": "hotel_chengdu_mercure_downtown",
  "T2-7": "hotel_chengdu_novotel_chunxi",
  "T2-8": "hotel_chengdu_courtyard_south",
  "T3-1": "hotel_chengdu_mix_hostel",
  "T3-2": "hotel_chengdu_flipflop_hostel",
  "T3-3": "hotel_chengdu_mrs_panda_hostel",
  "T3-4": "hotel_chengdu_lazybones_hostel",
  "T3-5": "hotel_chengdu_dreams_travel_hostel",
  "T3-6": "hotel_chengdu_desti_hostel_taikoo_li",
  "T3-7": "hotel_chengdu_loft_hostel",
  "T3-8": "hotel_chengdu_atour_light_taikoo_li",
};

const REQUIRED_FIELDS = [
  "Chinese Name",
  "English Name",
  "Price Range",
  "Chinese Address",
  "English Address",
  "Accepts Foreign Passport",
  "English Service",
];

const PLACEHOLDER_ONLY_FIELDS = new Set(["Description", "Recommendation"]);

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
  if (!url || !key) return null;
  return { url, key };
}

function sqlStr(value) {
  if (value == null) return "NULL";
  return `'${String(value).replace(/'/g, "''")}'`;
}

function sqlJson(value) {
  return `'${JSON.stringify(value).replace(/'/g, "''")}'::jsonb`;
}

function sqlArray(values) {
  if (!values?.length) return "ARRAY[]::text[]";
  return `ARRAY[${values.map((v) => sqlStr(v)).join(", ")}]`;
}

function stripMd(text) {
  return String(text || "")
    .replace(/\*\*/g, "")
    .replace(/~~/g, "")
    .replace(/\[([^\]]+)\]\([^)]+\)/g, "$1")
    .replace(/\s+/g, " ")
    .trim();
}

function isEmptyField(value) {
  const v = stripMd(value);
  return !v || v === "—" || v === "-" || v === "N/A";
}

function parseStars(starField, tierCode) {
  const count = (String(starField || "").match(/★/g) || []).length;
  if (count > 0) return count;
  const cat = Number(tierCode.match(/^[A-Z]([0-9])/)?.[1] || 0);
  if (cat === 3) return 2;
  if (cat === 2) return 3;
  return 5;
}

function parsePriceMinUsd(priceRange) {
  const text = String(priceRange || "");
  const m = text.match(/¥\s*([0-9][0-9,]*)/);
  if (!m) return 0;
  const rmb = Number(m[1].replace(/,/g, ""));
  return Math.round(rmb / 7);
}

function sortOrderFromTierCode(tierCode) {
  const m = tierCode.match(/^([A-Z])([0-9]+)-([0-9]+)$/);
  if (!m) return 0;
  const category = Number(m[2]);
  const index = Number(m[3]);
  const base = category === 1 ? 0 : category === 2 ? 10 : category === 3 ? 20 : 0;
  return base + (index - 1);
}

function parseAcceptsForeigners(value) {
  const text = String(value || "");
  if (/⚠️/.test(text)) return false;
  if (/✅|Yes/i.test(text)) return true;
  return false;
}

function parseEnglishService(value) {
  const raw = stripMd(value);
  const hasEnglish =
    /✅/.test(String(value || "")) ||
    /full english|english-speaking|english service|english reception|english front desk|bilingual/i.test(raw);
  let note = raw.replace(/^✅\s*/i, "").trim();
  if (!note) note = null;
  return { hasEnglishStaff: hasEnglish, englishStaffNote: note };
}

function labelFromUrl(url) {
  const host = url.replace(/^https?:\/\//, "").split("/")[0].toLowerCase();
  if (host.includes("booking.com")) return "Booking.com";
  if (host.includes("trip.com")) return "Trip.com";
  if (host.includes("agoda.com")) return "Agoda";
  if (host.includes("hostelworld.com")) return "Hostelworld";
  if (host.includes("marriott.com")) return "Marriott";
  if (host.includes("hilton.com")) return "Hilton";
  if (host.includes("ihg.com")) return "IHG";
  if (host.includes("accor.com")) return "Accor";
  if (host.includes("radissonhotels.com")) return "Radisson";
  if (host.includes("shangri-la.com")) return "Official";
  if (host.includes("tripadvisor.com")) return "TripAdvisor";
  if (host.includes("kayak.com")) return "KAYAK";
  if (host.includes("hihostels.com")) return "HI Hostels";
  return "Official";
}

function parseBookingLinks(fields) {
  const links = [];
  const seen = new Set();

  function add(label, url) {
    const clean = String(url || "").trim().replace(/[)\],.;]+$/g, "");
    if (!clean.startsWith("http")) return;
    const key = clean.split("?")[0];
    if (seen.has(key)) return;
    seen.add(key);
    links.push({ label: label || labelFromUrl(clean), url: clean });
  }

  function ingest(text, defaultLabel) {
    if (isEmptyField(text)) return;
    const raw = String(text);
    for (const m of raw.matchAll(/\[([^\]]*)\]\((https?:[^)\s]+)\)/g)) {
      add(stripMd(m[1]) || defaultLabel, m[2]);
    }
    for (const m of raw.matchAll(/https?:\/\/[^\s)\]|·<>"]+/g)) {
      add(labelFromUrl(m[0]), m[0]);
    }
    for (const part of raw.split(/[·•]/)) {
      const kv = part.match(/^([^:：]+)[:：]\s*(https?:\/\/\S+)/);
      if (kv) add(stripMd(kv[1]), kv[2]);
    }
  }

  ingest(fields["Official Website"], "Official");
  ingest(fields["Main OTA"], "Booking.com");
  return links;
}

function toSlug(name) {
  return stripMd(name)
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "_")
    .replace(/^_+|_+$/g, "")
    .slice(0, 40);
}

function parseFieldTable(block) {
  const fields = {};
  for (const line of block.split(/\r?\n/)) {
    const m = line.match(/^\|\s*\*\*(.+?)\*\*\s*\|\s*(.*?)\s*\|?\s*$/);
    if (!m) continue;
    fields[stripMd(m[1])] = m[2].trim();
  }
  return fields;
}

function splitHotelBlocks(text) {
  const re = /^## ([A-Z][0-9]+-[0-9]+)\s*[｜|]\s*(.+)$/gm;
  const blocks = [];
  let match;
  const indices = [];
  while ((match = re.exec(text))) {
    indices.push({ tierCode: match[1], title: match[2].trim(), start: match.index });
  }
  for (let i = 0; i < indices.length; i += 1) {
    const cur = indices[i];
    const end = i + 1 < indices.length ? indices[i + 1].start : text.length;
    blocks.push({
      tierCode: cur.tierCode,
      title: cur.title,
      body: text.slice(cur.start, end),
    });
  }
  return blocks;
}

function parseOverviewTierCodes(text) {
  const codes = new Set();
  const re = /\*\*([A-Z][0-9]+-[0-9]+)\*\*/g;
  let m;
  while ((m = re.exec(text))) codes.add(m[1]);
  return codes;
}

function parseOverviewEnglishNames(text) {
  const map = new Map();
  for (const line of text.split(/\r?\n/)) {
    const m = line.match(/^\|\s*\*\*([A-Z][0-9]+-[0-9]+)\*\*\s*\|\s*([^|]+?)\s*\|/);
    if (!m) continue;
    const namePart = m[2].split("<br>")[0].trim();
    map.set(m[1], stripMd(namePart));
  }
  return map;
}

function validateFields(fields) {
  const missing = REQUIRED_FIELDS.filter((key) => isEmptyField(fields[key]));
  const keys = new Set(Object.keys(fields));
  const onlyPlaceholder =
    keys.size > 0 && [...keys].every((k) => PLACEHOLDER_ONLY_FIELDS.has(k) || missing.includes(k));
  return { missing, onlyPlaceholder };
}

function makeHotelId(cityId, tierCode, englishName, usedIds) {
  if (cityId === "chengdu") {
    const id = CHENGDU_ID_BY_TIER[tierCode];
    if (!id) throw new Error(`缺少成都 tier 映射: ${tierCode}`);
    return id;
  }
  let slug = toSlug(englishName);
  if (!slug) slug = tierCode.toLowerCase().replace("-", "_");
  let id = `hotel_${cityId}_${slug}`;
  if (!usedIds.has(id)) return id;
  id = `hotel_${cityId}_${slug}_${tierCode.toLowerCase().replace("-", "_")}`;
  if (!usedIds.has(id)) return id;
  throw new Error(`无法生成唯一 id: ${cityId} ${tierCode}`);
}

function buildHotelRecord(block, cityId, inactiveTierCodes, usedIds) {
  const { tierCode, title, body } = block;
  const warnings = [];

  if (/~~/.test(title)) {
    return {
      skip: true,
      tierCode,
      reason: "duplicate_merged",
      detail: stripMd(title),
    };
  }

  const fields = parseFieldTable(body);
  const { missing, onlyPlaceholder } = validateFields(fields);

  if (onlyPlaceholder) {
    return {
      skip: true,
      tierCode,
      reason: "incomplete_fields",
      detail: `placeholder-only fields: ${Object.keys(fields).join(", ")}`,
    };
  }
  if (missing.length) {
    return {
      skip: true,
      tierCode,
      reason: "incomplete_fields",
      detail: `missing: ${missing.join(", ")}`,
    };
  }

  const englishName = stripMd(fields["English Name"]);
  const { hasEnglishStaff, englishStaffNote } = parseEnglishService(fields["English Service"]);
  const bookingLinks = parseBookingLinks(fields);
  const bookingPlatforms = bookingLinks.map((l) => l.label);
  const id = makeHotelId(cityId, tierCode, englishName, usedIds);
  usedIds.add(id);

  let isActive = true;
  if (inactiveTierCodes.includes(tierCode)) {
    isActive = false;
    warnings.push("marked_inactive_by_plan");
  }
  if (/permanently closed/i.test(body)) {
    isActive = false;
    warnings.push("permanently_closed_in_doc");
  }

  return {
    skip: false,
    id,
    cityId,
    tierCode,
    name: englishName,
    chineseName: stripMd(fields["Chinese Name"]),
    stars: parseStars(fields["Star Rating / Type"], tierCode),
    priceMinUsd: parsePriceMinUsd(fields["Price Range"]),
    hasEnglishStaff,
    englishStaffNote,
    languageTip: null,
    locationNote: isEmptyField(fields["Distance to Key Areas"])
      ? null
      : stripMd(fields["Distance to Key Areas"]),
    addressZh: stripMd(fields["Chinese Address"]),
    addressEn: stripMd(fields["English Address"]),
    bookingPlatforms,
    bookingLinks,
    acceptsForeigners: parseAcceptsForeigners(fields["Accepts Foreign Passport"]),
    sortOrder: sortOrderFromTierCode(tierCode),
    isActive,
    warnings,
    headerTitle: stripMd(title),
  };
}

function renderInsert(hotel) {
  return `INSERT INTO hotels (
  id, city_id, name, chinese_name, stars, price_min_usd,
  has_english_staff, english_staff_note, language_tip, location_note,
  address_zh, address_en, booking_platforms, booking_links,
  accepts_foreigners, sort_order, is_active
) VALUES (
  ${sqlStr(hotel.id)},
  ${sqlStr(hotel.cityId)},
  ${sqlStr(hotel.name)},
  ${sqlStr(hotel.chineseName)},
  ${hotel.stars},
  ${hotel.priceMinUsd},
  ${hotel.hasEnglishStaff ? "TRUE" : "FALSE"},
  ${sqlStr(hotel.englishStaffNote)},
  NULL,
  ${sqlStr(hotel.locationNote)},
  ${sqlStr(hotel.addressZh)},
  ${sqlStr(hotel.addressEn)},
  ${sqlArray(hotel.bookingPlatforms)},
  ${sqlJson(hotel.bookingLinks)},
  ${hotel.acceptsForeigners ? "TRUE" : "FALSE"},
  ${hotel.sortOrder},
  ${hotel.isActive ? "TRUE" : "FALSE"}
) ON CONFLICT (id) DO UPDATE SET
  city_id = EXCLUDED.city_id,
  name = EXCLUDED.name,
  chinese_name = EXCLUDED.chinese_name,
  stars = EXCLUDED.stars,
  price_min_usd = EXCLUDED.price_min_usd,
  has_english_staff = EXCLUDED.has_english_staff,
  english_staff_note = EXCLUDED.english_staff_note,
  language_tip = EXCLUDED.language_tip,
  location_note = EXCLUDED.location_note,
  address_zh = EXCLUDED.address_zh,
  address_en = EXCLUDED.address_en,
  booking_platforms = EXCLUDED.booking_platforms,
  booking_links = EXCLUDED.booking_links,
  accepts_foreigners = EXCLUDED.accepts_foreigners,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();`;
}

function renderCitySql(cityId, hotels, sourcePath) {
  const ids = hotels.map((h) => sqlStr(h.id)).join(", ");
  const header = `-- Generated hotels for ${cityId}
-- Source: ${sourcePath}
-- Total hotels: ${hotels.length}

-- Remove hotels in ${cityId} not in the new manifest set
DELETE FROM hotels
WHERE city_id = ${sqlStr(cityId)} AND id NOT IN (${ids});

`;
  return `${header}${hotels.map(renderInsert).join("\n\n")}\n`;
}

async function fetchExistingHotelIds(cityId) {
  const cfg = getSupabaseConfig();
  if (!cfg) return [];
  const res = await fetch(`${cfg.url}/rest/v1/hotels?city_id=eq.${cityId}&select=id`, {
    headers: { apikey: cfg.key, Authorization: `Bearer ${cfg.key}` },
  });
  if (!res.ok) return [];
  return (await res.json()).map((row) => row.id);
}

function processCity(source) {
  const text = readFileSync(source.path, "utf8");
  const overviewCodes = parseOverviewTierCodes(text);
  const overviewNames = parseOverviewEnglishNames(text);
  const blocks = splitHotelBlocks(text);
  const usedIds = new Set();
  const imported = [];
  const skipped = [];
  const namingMismatches = [];

  for (const block of blocks) {
    const result = buildHotelRecord(block, source.cityId, source.inactiveTierCodes, usedIds);
    if (result.skip) {
      skipped.push({
        tierCode: result.tierCode,
        reason: result.reason,
        detail: result.detail,
      });
      continue;
    }
    imported.push(result);

    const overviewName = overviewNames.get(result.tierCode);
    if (overviewName && overviewName.toLowerCase() !== result.name.toLowerCase()) {
      namingMismatches.push({
        tierCode: result.tierCode,
        overviewName,
        detailName: result.name,
      });
    }
  }

  imported.sort((a, b) => a.sortOrder - b.sortOrder);

  const importedCodes = new Set(imported.map((h) => h.tierCode));
  for (const code of overviewCodes) {
    if (!importedCodes.has(code) && !skipped.some((s) => s.tierCode === code)) {
      skipped.push({ tierCode: code, reason: "no_detail_section", detail: "listed in overview only" });
    }
  }

  return {
    cityId: source.cityId,
    sourcePath: source.path,
    imported,
    skipped,
    namingMismatches,
  };
}

async function main() {
  mkdirSync(OUT_DIR, { recursive: true });

  const cityResults = [];
  const allSqlParts = [];

  for (const source of CITY_SOURCES) {
    const result = processCity(source);
    const existingIds = await fetchExistingHotelIds(result.cityId);
    const newIds = new Set(result.imported.map((h) => h.id));
    result.deletedIds = existingIds.filter((id) => !newIds.has(id));

    const outSql = join(OUT_DIR, `hotels_${result.cityId}_upsert.sql`);
    const sql = renderCitySql(result.cityId, result.imported, result.sourcePath);
    writeFileSync(outSql, sql, "utf8");
    allSqlParts.push(sql);

    cityResults.push({
      cityId: result.cityId,
      sourcePath: result.sourcePath,
      sqlPath: outSql,
      imported: result.imported.map((h) => ({
        id: h.id,
        tierCode: h.tierCode,
        name: h.name,
        chineseName: h.chineseName,
        sortOrder: h.sortOrder,
        acceptsForeigners: h.acceptsForeigners,
        isActive: h.isActive,
        priceMinUsd: h.priceMinUsd,
        warnings: h.warnings,
      })),
      skipped: result.skipped,
      namingMismatches: result.namingMismatches,
      deletedIds: result.deletedIds,
      stats: {
        imported: result.imported.length,
        skipped: result.skipped.length,
        deleted: result.deletedIds.length,
      },
    });

    console.log(
      `${result.cityId}: imported ${result.imported.length}, skipped ${result.skipped.length}, deleted ${result.deletedIds.length}`
    );
  }

  const allSqlPath = join(OUT_DIR, "hotels_all_upsert.sql");
  writeFileSync(allSqlPath, allSqlParts.join("\n"), "utf8");

  const report = {
    generatedAt: new Date().toISOString(),
    cities: cityResults,
    stats: {
      cities: cityResults.length,
      imported: cityResults.reduce((n, c) => n + c.stats.imported, 0),
      skipped: cityResults.reduce((n, c) => n + c.stats.skipped, 0),
      deleted: cityResults.reduce((n, c) => n + c.stats.deleted, 0),
    },
    chengduIds: cityResults.find((c) => c.cityId === "chengdu")?.imported.map((h) => h.id) ?? [],
  };

  const reportPath = join(OUT_DIR, "hotels_report.json");
  writeFileSync(reportPath, `${JSON.stringify(report, null, 2)}\n`, "utf8");

  console.log("\nReport:", reportPath);
  console.log("All SQL:", allSqlPath);
  console.log("Totals:", report.stats);
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
