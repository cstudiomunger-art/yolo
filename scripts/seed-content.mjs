#!/usr/bin/env node
/**
 * Import YOLO/Resources/Static/*.json into Supabase (CMS tables).
 *
 * Usage (from repo root):
 *   SUPABASE_URL=https://xxx.supabase.co \
 *   SUPABASE_SERVICE_ROLE_KEY=eyJ... \
 *   node scripts/seed-content.mjs
 *
 * Requires service_role key — run locally, never commit the key.
 */

import { createClient } from "@supabase/supabase-js";
import { readFileSync, readdirSync } from "fs";
import { join, dirname } from "path";
import { fileURLToPath } from "url";

const __dirname = dirname(fileURLToPath(import.meta.url));
const root = join(__dirname, "..");
const staticDir = join(root, "YOLO/Resources/Static");

const url = process.env.SUPABASE_URL;
const key = process.env.SUPABASE_SERVICE_ROLE_KEY;

if (!url || !key) {
  console.error("Set SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY");
  process.exit(1);
}

const supabase = createClient(url, key);

function loadJson(name) {
  const path = join(staticDir, `${name}.json`);
  return JSON.parse(readFileSync(path, "utf8"));
}

async function upsert(table, rows, onConflict = "id") {
  if (!rows?.length) return;
  const { error } = await supabase.from(table).upsert(rows, { onConflict });
  if (error) throw new Error(`${table}: ${error.message}`);
  console.log(`  ✓ ${table} (${rows.length} rows)`);
}

async function main() {
  console.log("Seeding ChinaGo content from bundled JSON…\n");

  const cities = loadJson("cities");
  await upsert("cities", cities);

  try {
    await upsert("city_guides", loadJson("city_guides"));
  } catch (e) {
    console.warn("  ⚠ city_guides skipped:", e.message);
  }

  try {
    await upsert("city_routes", loadJson("city_routes"));
  } catch (e) {
    console.warn("  ⚠ city_routes skipped:", e.message);
  }
  await upsert("attractions", loadJson("attractions"));
  await upsert("audio_guides", loadJson("audio_guides"));
  await upsert("checklist_items", loadJson("checklist_items"));
  await upsert("shopping_items", loadJson("shopping_items"));

  const reading = loadJson("reading_list").map((r) => ({
    id: r.id,
    city_ids: r.city_ids ?? r.cityIds ?? [],
    title: r.title,
    author: r.author,
    genre: r.genre,
    synopsis_en: r.synopsis_en ?? r.synopsisEn,
    sort_order: r.sort_order ?? r.sortOrder ?? 0,
    is_active: true,
  }));
  await upsert("reading_list", reading);

  const hotels = loadJson("hotels").map((h) => ({
    id: h.id,
    city_id: h.city_id ?? h.cityId,
    name: h.name,
    chinese_name: h.chinese_name ?? h.chineseName,
    stars: h.stars ?? 4,
    price_min_usd: h.price_min_usd ?? h.priceMinUsd ?? 0,
    has_english_staff: h.has_english_staff ?? h.hasEnglishStaff ?? false,
    english_staff_note: h.english_staff_note ?? h.englishStaffNote,
    language_tip: h.language_tip ?? h.languageTip,
    location_note: h.location_note ?? h.locationNote,
    booking_platforms: h.booking_platforms ?? h.bookingPlatforms ?? [],
    sort_order: h.sort_order ?? h.sortOrder ?? 0,
    is_active: true,
  }));
  await upsert("hotels", hotels);

  const homeTips = loadJson("home_tips").map((t) => ({
    id: t.id,
    city_id: t.city_id ?? t.cityId ?? null,
    kicker: t.kicker,
    headline: t.headline,
    body: t.body,
    link_label: t.link_label ?? t.linkLabel ?? null,
    link_attraction_id: t.link_attraction_id ?? t.linkAttractionId ?? null,
    link_url: t.link_url ?? t.linkUrl ?? null,
    sort_order: t.sort_order ?? t.sortOrder ?? 0,
    is_active: true,
  }));
  await upsert("home_tips", homeTips);

  const culture = loadJson("culture_tips").map((c, i) => ({
    ...c,
    sort_order: i,
    is_active: true,
  }));
  await upsert("culture_tips", culture);

  const replies = loadJson("assistant_replies").map((r) => ({
    scenario_id: r.scenario_id ?? r.scenarioId,
    user_message: r.user_message ?? r.userMessage,
    assistant_message: r.assistant_message ?? r.assistantMessage,
    is_active: true,
  }));
  await upsert("assistant_replies", replies, "scenario_id");

  const visaBundle = loadJson("visa-rules");
  const visaRows = visaBundle.rules.map((r) => ({
    country_code: r.country_code ?? r.countryCode,
    country_name: r.country_name ?? r.countryName,
    flag: r.flag,
    visa_free: r.visa_free ?? r.visaFree,
    stay_days: r.stay_days ?? r.stayDays,
    headline: r.headline,
    details: r.details,
    is_active: true,
  }));
  await upsert("visa_rules", visaRows, "country_code");

  const passportCountries = visaRows.map((r, i) => ({
    code: r.country_code,
    name: r.country_name,
    flag: r.flag,
    display_order: i,
    is_active: true,
  }));
  await upsert("passport_countries", passportCountries, "code");

  const emergency = loadJson("emergency-data");
  const { error: emErr } = await supabase.from("emergency_config").upsert({
    id: "global",
    embassy_note: emergency.embassy_note ?? emergency.embassyNote,
    contacts: emergency.contacts,
  });
  if (emErr) throw new Error(`emergency_config: ${emErr.message}`);
  console.log("  ✓ emergency_config");

  const sample = loadJson("sample_itinerary");
  await upsert(
    "content_itineraries",
    [
      {
        id: sample.id,
        kind: "sample",
        title: sample.title,
        meta: sample.meta,
        route_summary: sample.route_summary ?? sample.routeSummary,
        estimated_budget: sample.estimated_budget ?? sample.estimatedBudget,
        days: sample.days,
        sort_order: 0,
        is_active: true,
      },
    ],
    "id"
  );

  try {
    const planning = loadJson("planning_itinerary");
    await upsert(
      "content_itineraries",
      [
        {
          id: planning.id,
          kind: "planning",
          title: planning.title,
          meta: planning.meta,
          route_summary: planning.route_summary ?? planning.routeSummary,
          estimated_budget: planning.estimated_budget ?? planning.estimatedBudget,
          days: planning.days,
          sort_order: 1,
          is_active: true,
        },
      ],
      "id"
    );
  } catch {
    console.log("  · planning_itinerary.json skipped");
  }

  const { error: settingsErr } = await supabase.from("app_settings").upsert({
    id: "global",
    use_remote_content: true,
    use_remote_ai: false,
    use_remote_iap: false,
  });
  if (settingsErr) throw new Error(`app_settings: ${settingsErr.message}`);
  console.log("  ✓ app_settings (use_remote_content=true)");

  console.log("\nDone. Open admin CMS to edit content, or use the iOS app with Live Services.");
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
