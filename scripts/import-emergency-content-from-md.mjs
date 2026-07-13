#!/usr/bin/env node
/**
 * Import emergency help/medical markdown + per-city hospital lists.
 *
 *   node scripts/import-emergency-content-from-md.mjs --dry-run
 *   node scripts/import-emergency-content-from-md.mjs --apply
 */
import { createClient } from "@supabase/supabase-js";
import { mkdirSync, readFileSync, writeFileSync } from "fs";
import { join } from "path";
import { getSupabaseConfig, loadServiceKey } from "./lib/supabase-service.mjs";

const ROOT = "/Users/vesperal/Desktop/YOLO";
const OUT_DIR = join(ROOT, "scripts/generated");
const OUT_REPORT = join(OUT_DIR, "emergency_content_report.json");

const HELP_ITEM = {
  id: "consular_emergency_help",
  icon: "🆘",
  path: "/Users/vesperal/Desktop/EN_Consular Protection and Emergency Help Guide.md",
  title_en: "Consular Protection & Emergency Help Guide",
  subtitle_en: "What to do · language tips · find your embassy",
  sort_order: 0,
};

const MEDICAL_ITEMS = [
  {
    id: "health_prep",
    icon: "📋",
    path: "/Users/vesperal/Desktop/EN_出行前健康准备（急救卡与处方药）.md",
    title_en: "Health Prep Before You Travel",
    subtitle_en: "Your Health Card & Prescription Medicines",
    sort_order: 0,
  },
  {
    id: "hospital_visit",
    icon: "🏥",
    path: "/Users/vesperal/Desktop/EN_在中国怎么看病就医（外国游客指南）.md",
    title_en: "How to Get Medical Care in China",
    subtitle_en: "A Guide for Foreign Visitors",
    sort_order: 1,
  },
  {
    id: "buy_medicine",
    icon: "💊",
    path: "/Users/vesperal/Desktop/EN_在中国怎么买药（外国游客指南）.md",
    title_en: "How to Buy Medicine in China",
    subtitle_en: "A Guide for Foreign Visitors",
    sort_order: 2,
  },
  {
    id: "help_card",
    icon: "🗣️",
    path: "/Users/vesperal/Desktop/EN_紧急医疗英文求助句.md",
    title_en: "Help Card — Point to These",
    subtitle_en: "Ask a Stranger for Help",
    sort_order: 3,
  },
];

const HELP_PHRASES_PATH = "/Users/vesperal/Desktop/EN_紧急医疗英文求助句.md";

const HOSPITAL_SOURCES = [
  { cityId: "beijing", path: "/Users/vesperal/Desktop/EN_北京涉外就医与医院清单.md" },
  { cityId: "shanghai", path: "/Users/vesperal/Desktop/EN_上海涉外就医与医院清单.md" },
  { cityId: "nanjing", path: "/Users/vesperal/Desktop/EN_南京涉外就医与医院清单.md" },
  { cityId: "chengdu", path: "/Users/vesperal/Desktop/EN_成都涉外就医与医院清单.md" },
  { cityId: "hangzhou", path: "/Users/vesperal/Desktop/EN_杭州涉外就医与医院清单.md" },
  { cityId: "suzhou", path: "/Users/vesperal/Desktop/EN_苏州涉外就医与医院清单.md" },
  { cityId: "chongqing", path: "/Users/vesperal/Desktop/EN_重庆涉外就医与医院清单.md" },
];

const args = process.argv.slice(2);
const dryRun = args.includes("--dry-run") || !args.includes("--apply");

function stripMd(text) {
  return String(text || "")
    .replace(/\*\*/g, "")
    .replace(/~~/g, "")
    .replace(/\[([^\]]+)\]\([^)]+\)/g, "$1")
    .trim();
}

function toSlug(text) {
  return stripMd(text)
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-+|-+$/g, "")
    .slice(0, 48);
}

function parseHospitalName(cell) {
  const raw = stripMd(cell);
  const m = raw.match(/^(.+?)\s*\(([^)]+)\)\s*$/);
  if (m) return { name_zh: m[1].trim(), name_en: m[2].trim() };
  if (/[\u4e00-\u9fff]/.test(raw)) return { name_zh: raw, name_en: raw };
  return { name_zh: "", name_en: raw };
}

function parseHospitals(mdText, cityId) {
  const lines = mdText.split(/\r?\n/);
  const hospitals = [];
  let sort = 0;

  for (const line of lines) {
    if (!line.startsWith("| **")) continue;
    const cols = line
      .split("|")
      .slice(1, -1)
      .map((c) => c.trim());
    if (cols.length < 5) continue;

    const { name_zh, name_en } = parseHospitalName(cols[0]);
    const addressCell = cols[1];
    const addressMatch = addressCell.match(/\(([^)]+)\)\s*$/);
    const address_en = addressMatch ? addressMatch[1].trim() : stripMd(addressCell);
    const address_zh = addressMatch ? stripMd(addressCell.replace(/\([^)]+\)\s*$/, "")) : "";
    const phone = stripMd(cols[2]);
    const services = stripMd(cols[3]);
    const note = stripMd(cols[4]);
    const hasInternational =
      /international|english throughout|english service|foreign-invested|multilingual/i.test(services);

    const slug = toSlug(name_en || name_zh) || `hospital-${sort + 1}`;
    hospitals.push({
      id: `${cityId}-${slug}`,
      city_id: cityId,
      name_en: name_en || name_zh,
      name_zh,
      phone,
      address_en,
      address_zh,
      has_international_dept: hasInternational,
      note: [services, note].filter(Boolean).join(" · "),
      sort_order: sort,
      is_active: true,
    });
    sort += 1;
  }

  if (!hospitals.length) throw new Error(`${cityId}: 未解析到医院行`);
  return hospitals;
}

function parseHelpPhrases(mdText) {
  const phrases = [];
  const lines = mdText.split(/\r?\n/);
  for (let i = 0; i < lines.length; i += 1) {
    const chineseLine = lines[i].match(/^\*\*(.+)\*\*$/);
    if (!chineseLine) continue;
    const pinyin = (lines[i + 1] || "").trim();
    const englishLine = (lines[i + 2] || "").trim();
    const englishMatch = englishLine.match(/^\*(.+)\*$/);
    if (!pinyin || !englishMatch) continue;
    phrases.push({
      chinese: chineseLine[1].trim(),
      pinyin,
      english: englishMatch[1].trim(),
    });
  }
  if (!phrases.length) throw new Error("未解析到应急短语");
  return phrases;
}

function loadContentItem(meta) {
  const body_en = readFileSync(meta.path, "utf8").trim();
  return {
    id: meta.id,
    icon: meta.icon,
    title_zh: "",
    title_en: meta.title_en,
    subtitle_zh: "",
    subtitle_en: meta.subtitle_en,
    body_zh: "",
    body_en,
    sort_order: meta.sort_order,
    is_active: true,
  };
}

async function main() {
  mkdirSync(OUT_DIR, { recursive: true });

  const helpItem = loadContentItem(HELP_ITEM);
  const medicalItems = MEDICAL_ITEMS.map(loadContentItem);
  const helpPhrases = parseHelpPhrases(readFileSync(HELP_PHRASES_PATH, "utf8"));
  const hospitalsByCity = HOSPITAL_SOURCES.map((source) => ({
    cityId: source.cityId,
    hospitals: parseHospitals(readFileSync(source.path, "utf8"), source.cityId),
  }));

  const report = {
    generatedAt: new Date().toISOString(),
    mode: dryRun ? "dry-run" : "apply",
    helpItem: { id: helpItem.id, chars: helpItem.body_en.length },
    medicalItems: medicalItems.map((m) => ({ id: m.id, chars: m.body_en.length })),
    helpPhrases: helpPhrases.length,
    hospitals: hospitalsByCity.map((c) => ({ cityId: c.cityId, count: c.hospitals.length })),
  };

  writeFileSync(OUT_REPORT, `${JSON.stringify(report, null, 2)}\n`, "utf8");

  console.log(`help: ${helpItem.id} (${helpItem.body_en.length} chars)`);
  for (const m of medicalItems) console.log(`medical: ${m.id} (${m.body_en.length} chars)`);
  console.log(`help_phrases: ${helpPhrases.length}`);
  for (const c of hospitalsByCity) console.log(`hospitals ${c.cityId}: ${c.hospitals.length}`);
  console.log(`Report: ${OUT_REPORT}`);

  if (dryRun) {
    console.log("\n[dry-run] 未写库。确认后加 --apply");
    return;
  }

  if (!loadServiceKey()) throw new Error("缺少 SUPABASE_SERVICE_ROLE_KEY");

  const supabase = createClient(getSupabaseConfig().url, loadServiceKey(), {
    auth: { persistSession: false, autoRefreshToken: false },
  });

  const { error: helpErr } = await supabase.from("emergency_help_items").upsert(helpItem, { onConflict: "id" });
  if (helpErr) throw new Error(`help item: ${helpErr.message}`);

  const { error: medErr } = await supabase.from("emergency_medical_items").upsert(medicalItems, { onConflict: "id" });
  if (medErr) throw new Error(`medical items: ${medErr.message}`);

  const { error: phraseErr } = await supabase
    .from("emergency_config")
    .update({ help_phrases: helpPhrases, updated_at: new Date().toISOString() })
    .eq("id", "global");
  if (phraseErr) throw new Error(`help_phrases: ${phraseErr.message}`);

  for (const { cityId, hospitals } of hospitalsByCity) {
    const keepIds = new Set(hospitals.map((h) => h.id));
    const { data: existing, error: listErr } = await supabase
      .from("city_hospitals")
      .select("id")
      .eq("city_id", cityId);
    if (listErr) throw new Error(`list hospitals ${cityId}: ${listErr.message}`);

    const staleIds = (existing || []).map((r) => r.id).filter((id) => !keepIds.has(id));
    if (staleIds.length) {
      const { error: delErr } = await supabase.from("city_hospitals").delete().in("id", staleIds);
      if (delErr) throw new Error(`delete hospitals ${cityId}: ${delErr.message}`);
    }

    const { error } = await supabase.from("city_hospitals").upsert(hospitals, { onConflict: "id" });
    if (error) throw new Error(`upsert hospitals ${cityId}: ${error.message}`);
    console.log(`[apply] hospitals ${cityId}: ${hospitals.length}`);
  }

  console.log("[apply] emergency content uploaded");
}

main().catch((err) => {
  console.error(err.message || err);
  process.exit(1);
});
