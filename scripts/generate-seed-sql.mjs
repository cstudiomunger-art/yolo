#!/usr/bin/env node
/**
 * Generates supabase/migrations/008_seed_content.sql from bundled JSON.
 * Run: node scripts/generate-seed-sql.mjs
 */

import { readFileSync, writeFileSync } from "fs";
import { join, dirname } from "path";
import { fileURLToPath } from "url";

const __dirname = dirname(fileURLToPath(import.meta.url));
const root = join(__dirname, "..");
const staticDir = join(root, "YOLO/Resources/Static");
const outPath = join(root, "supabase/migrations/008_seed_content.sql");

function load(name) {
  return JSON.parse(readFileSync(join(staticDir, `${name}.json`), "utf8"));
}

function sqlStr(v) {
  if (v === null || v === undefined) return "NULL";
  return `'${String(v).replace(/\\/g, "\\\\").replace(/'/g, "''").replace(/\r/g, "").replace(/\n/g, "\\n")}'`;
}

function sqlBool(v) {
  if (v === null || v === undefined) return "NULL";
  return v ? "TRUE" : "FALSE";
}

function sqlTextArray(arr) {
  if (!arr || arr.length === 0) return "ARRAY[]::TEXT[]";
  return `ARRAY[${arr.map((x) => sqlStr(x)).join(", ")}]`;
}

function sqlJson(obj) {
  return `'${JSON.stringify(obj).replace(/'/g, "''")}'::jsonb`;
}

const lines = [];
const w = (s = "") => lines.push(s);

w("-- ChinaGo: initial content seed (from YOLO/Resources/Static/*.json)");
w("-- Run after 001–007, 009_align_content_columns.sql, 010_fix_text_primary_keys.sql.");
w("-- Regenerate: node scripts/generate-seed-sql.mjs");
w("-- column missing → 009 | invalid input syntax for type uuid → 010");
w("");
w("BEGIN;");
w("");

// app_settings
w("-- app_settings");
w(`UPDATE app_settings SET
  use_remote_content = TRUE,
  use_remote_ai = FALSE,
  use_remote_iap = FALSE,
  updated_at = NOW()
WHERE id = 'global';`);
w("");

// cities
const cities = load("cities");
w("-- cities");
for (let i = 0; i < cities.length; i++) {
  const c = cities[i];
  w(`INSERT INTO cities (
  id, name, chinese_name, emoji, cover_image_path, description,
  best_for, season_note, best_time_to_visit, avg_days_recommended,
  attraction_count, display_order, is_published
) VALUES (
  ${sqlStr(c.id)}, ${sqlStr(c.name)}, ${sqlStr(c.chinese_name)}, ${sqlStr(c.emoji)},
  ${sqlStr(c.cover_image_path)}, ${sqlStr(c.description)},
  ${sqlTextArray(c.best_for)}, ${sqlStr(c.season_note)}, ${sqlStr(c.best_time_to_visit)},
  ${c.avg_days_recommended ?? "NULL"}, ${c.attraction_count ?? 0}, ${i}, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  chinese_name = EXCLUDED.chinese_name,
  emoji = EXCLUDED.emoji,
  description = EXCLUDED.description,
  best_for = EXCLUDED.best_for,
  season_note = EXCLUDED.season_note,
  best_time_to_visit = EXCLUDED.best_time_to_visit,
  avg_days_recommended = EXCLUDED.avg_days_recommended,
  attraction_count = EXCLUDED.attraction_count,
  display_order = EXCLUDED.display_order,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();`);
}
w("");

// city_routes
const routes = load("city_routes");
w("-- city_routes");
for (const r of routes) {
  w(`INSERT INTO city_routes (id, city_id, title, days, summary, sort_order)
VALUES (${sqlStr(r.id)}, ${sqlStr(r.city_id)}, ${sqlStr(r.title)}, ${r.days}, ${sqlStr(r.summary)}, ${r.sort_order ?? 0})
ON CONFLICT (id) DO UPDATE SET
  city_id = EXCLUDED.city_id, title = EXCLUDED.title, days = EXCLUDED.days,
  summary = EXCLUDED.summary, sort_order = EXCLUDED.sort_order, updated_at = NOW();`);
}
w("");

// attractions
const attractions = load("attractions");
w("-- attractions");
for (let i = 0; i < attractions.length; i++) {
  const a = attractions[i];
  w(`INSERT INTO attractions (
  id, city_id, name, chinese_name, category, cover_image_path, summary, introduction,
  priority, ticket_price, recommended_duration, opening_hours, closed_days,
  requires_advance_booking, metro_access, western_visitor_tips, nearby_places,
  audio_guide_count, iap_product_id, display_order, is_published
) VALUES (
  ${sqlStr(a.id)}, ${sqlStr(a.city_id)}, ${sqlStr(a.name)}, ${sqlStr(a.chinese_name)},
  ${sqlStr(a.category ?? "sight")}, ${sqlStr(a.cover_image_path)}, ${sqlStr(a.summary)},
  ${sqlStr(a.introduction)}, ${sqlStr(a.priority ?? "P1")}, ${sqlStr(a.ticket_price)},
  ${sqlStr(a.recommended_duration)}, ${sqlStr(a.opening_hours)}, ${sqlStr(a.closed_days)},
  ${sqlBool(a.requires_advance_booking ?? false)}, ${sqlStr(a.metro_access)},
  ${sqlJson(a.western_visitor_tips ?? [])}, ${sqlJson(a.nearby_places ?? [])},
  ${a.audio_guide_count ?? 0}, ${sqlStr(a.iap_product_id)}, ${a.display_order ?? i}, TRUE
) ON CONFLICT (id) DO UPDATE SET
  city_id = EXCLUDED.city_id, name = EXCLUDED.name, chinese_name = EXCLUDED.chinese_name,
  category = EXCLUDED.category, summary = EXCLUDED.summary, introduction = EXCLUDED.introduction,
  priority = EXCLUDED.priority, ticket_price = EXCLUDED.ticket_price,
  western_visitor_tips = EXCLUDED.western_visitor_tips, nearby_places = EXCLUDED.nearby_places,
  audio_guide_count = EXCLUDED.audio_guide_count, is_published = EXCLUDED.is_published,
  updated_at = NOW();`);
}
w("");

// audio_guides
const audioGuides = load("audio_guides");
w("-- audio_guides");
for (let i = 0; i < audioGuides.length; i++) {
  const g = audioGuides[i];
  w(`INSERT INTO audio_guides (
  id, attraction_id, title_en, description, duration_seconds, audio_url, quote,
  segments, is_main_guide, sort_order, is_active
) VALUES (
  ${sqlStr(g.id)}, ${sqlStr(g.attraction_id)}, ${sqlStr(g.title_en)}, ${sqlStr(g.description)},
  ${g.duration_seconds ?? 0}, ${sqlStr(g.audio_url ?? "")}, ${sqlStr(g.quote)},
  ${sqlJson(g.segments ?? [])}, ${sqlBool(g.is_main_guide ?? false)}, ${g.sort_order ?? i}, TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id, title_en = EXCLUDED.title_en,
  duration_seconds = EXCLUDED.duration_seconds, audio_url = EXCLUDED.audio_url,
  segments = EXCLUDED.segments, updated_at = NOW();`);
}
w("");

// checklist_items
const checklist = load("checklist_items");
w("-- checklist_items");
for (let i = 0; i < checklist.length; i++) {
  const c = checklist[i];
  w(`INSERT INTO checklist_items (
  id, city_id, phase, group_title, title_en, estimated_minutes, display_tags,
  cultural_tip, sort_order, is_active
) VALUES (
  ${sqlStr(c.id)}, ${sqlStr(c.city_id)}, ${sqlStr(c.phase)}, ${sqlStr(c.group_title)},
  ${sqlStr(c.title_en)}, ${c.estimated_minutes ?? "NULL"}, ${sqlTextArray(c.display_tags ?? [])},
  ${sqlStr(c.cultural_tip)}, ${c.sort_order ?? i}, TRUE
) ON CONFLICT (id) DO UPDATE SET
  title_en = EXCLUDED.title_en, phase = EXCLUDED.phase, group_title = EXCLUDED.group_title,
  estimated_minutes = EXCLUDED.estimated_minutes, cultural_tip = EXCLUDED.cultural_tip,
  updated_at = NOW();`);
}
w("");

// shopping_items
const shopping = load("shopping_items");
w("-- shopping_items");
for (let i = 0; i < shopping.length; i++) {
  const s = shopping[i];
  w(`INSERT INTO shopping_items (id, city_id, title_en, note_en, sort_order, is_active)
VALUES (${sqlStr(s.id)}, ${sqlStr(s.city_id)}, ${sqlStr(s.title_en)}, ${sqlStr(s.note_en)}, ${s.sort_order ?? i}, TRUE)
ON CONFLICT (id) DO UPDATE SET title_en = EXCLUDED.title_en, note_en = EXCLUDED.note_en, updated_at = NOW();`);
}
w("");

// reading_list
const reading = load("reading_list");
w("-- reading_list");
for (let i = 0; i < reading.length; i++) {
  const r = reading[i];
  const cityIds = r.city_ids ?? r.cityIds ?? [];
  w(`INSERT INTO reading_list (id, city_ids, title, author, genre, synopsis_en, sort_order, is_active)
VALUES (${sqlStr(r.id)}, ${sqlTextArray(cityIds)}, ${sqlStr(r.title)}, ${sqlStr(r.author)}, ${sqlStr(r.genre)}, ${sqlStr(r.synopsis_en ?? r.synopsisEn)}, ${r.sort_order ?? r.sortOrder ?? i}, TRUE)
ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title, author = EXCLUDED.author, synopsis_en = EXCLUDED.synopsis_en, updated_at = NOW();`);
}
w("");

// hotels
const hotels = load("hotels");
w("-- hotels");
for (let i = 0; i < hotels.length; i++) {
  const h = hotels[i];
  w(`INSERT INTO hotels (
  id, city_id, name, chinese_name, stars, price_min_usd, has_english_staff,
  english_staff_note, language_tip, location_note, booking_platforms, sort_order, is_active
) VALUES (
  ${sqlStr(h.id)}, ${sqlStr(h.city_id ?? h.cityId)}, ${sqlStr(h.name)}, ${sqlStr(h.chinese_name ?? h.chineseName)},
  ${h.stars ?? 4}, ${h.price_min_usd ?? h.priceMinUsd ?? 0}, ${sqlBool(h.has_english_staff ?? h.hasEnglishStaff ?? false)},
  ${sqlStr(h.english_staff_note ?? h.englishStaffNote)}, ${sqlStr(h.language_tip ?? h.languageTip)},
  ${sqlStr(h.location_note ?? h.locationNote)}, ${sqlTextArray(h.booking_platforms ?? h.bookingPlatforms ?? [])},
  ${h.sort_order ?? h.sortOrder ?? i}, TRUE
) ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name, chinese_name = EXCLUDED.chinese_name, updated_at = NOW();`);
}
w("");

// home_tips — use TEXT id (004 schema); skip if 001 created uuid table
w("-- home_tips (requires TEXT id column from migration 004)");
const homeTips = load("home_tips");
for (let i = 0; i < homeTips.length; i++) {
  const t = homeTips[i];
  w(`INSERT INTO home_tips (
  id, city_id, kicker, headline, body, link_label, link_attraction_id, link_url, sort_order, is_active
) VALUES (
  ${sqlStr(t.id)}, ${sqlStr(t.city_id ?? t.cityId)}, ${sqlStr(t.kicker)}, ${sqlStr(t.headline)},
  ${sqlStr(t.body)}, ${sqlStr(t.link_label ?? t.linkLabel)}, ${sqlStr(t.link_attraction_id ?? t.linkAttractionId)},
  ${sqlStr(t.link_url ?? t.linkUrl)}, ${t.sort_order ?? t.sortOrder ?? i}, TRUE
) ON CONFLICT (id) DO UPDATE SET
  headline = EXCLUDED.headline, body = EXCLUDED.body, link_label = EXCLUDED.link_label,
  link_attraction_id = EXCLUDED.link_attraction_id, updated_at = NOW();`);
}
w("");

// culture_tips
const culture = load("culture_tips");
w("-- culture_tips");
for (let i = 0; i < culture.length; i++) {
  const c = culture[i];
  w(`INSERT INTO culture_tips (id, emoji, title, preview, body, sort_order, is_active)
VALUES (${sqlStr(c.id)}, ${sqlStr(c.emoji)}, ${sqlStr(c.title)}, ${sqlStr(c.preview)}, ${sqlStr(c.body)}, ${i}, TRUE)
ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title, preview = EXCLUDED.preview, body = EXCLUDED.body, updated_at = NOW();`);
}
w("");

// assistant_replies
const replies = load("assistant_replies");
w("-- assistant_replies");
for (const r of replies) {
  const sid = r.scenario_id ?? r.scenarioId;
  w(`INSERT INTO assistant_replies (scenario_id, user_message, assistant_message, is_active)
VALUES (${sqlStr(sid)}, ${sqlStr(r.user_message ?? r.userMessage)}, ${sqlStr(r.assistant_message ?? r.assistantMessage)}, TRUE)
ON CONFLICT (scenario_id) DO UPDATE SET assistant_message = EXCLUDED.assistant_message, updated_at = NOW();`);
}
w("");

// visa_rules + passport_countries
const visaBundle = load("visa-rules");
w("-- visa_rules");
let pcOrder = 0;
for (const r of visaBundle.rules) {
  const code = r.country_code ?? r.countryCode;
  w(`INSERT INTO visa_rules (country_code, country_name, flag, visa_free, stay_days, headline, details, is_active)
VALUES (${sqlStr(code)}, ${sqlStr(r.country_name ?? r.countryName)}, ${sqlStr(r.flag)}, ${sqlBool(r.visa_free ?? r.visaFree)}, ${r.stay_days ?? r.stayDays ?? "NULL"}, ${sqlStr(r.headline)}, ${sqlJson(r.details)}, TRUE)
ON CONFLICT (country_code) DO UPDATE SET headline = EXCLUDED.headline, details = EXCLUDED.details, updated_at = NOW();`);

  w(`INSERT INTO passport_countries (code, name, flag, display_order, is_active)
VALUES (${sqlStr(code)}, ${sqlStr(r.country_name ?? r.countryName)}, ${sqlStr(r.flag)}, ${pcOrder}, TRUE)
ON CONFLICT (code) DO UPDATE SET name = EXCLUDED.name, flag = EXCLUDED.flag, display_order = EXCLUDED.display_order, updated_at = NOW();`);
  pcOrder++;
}
w("");

// emergency_config
const emergency = load("emergency-data");
w("-- emergency_config");
w(`INSERT INTO emergency_config (id, embassy_note, contacts)
VALUES ('global', ${sqlStr(emergency.embassy_note ?? emergency.embassyNote)}, ${sqlJson(emergency.contacts)})
ON CONFLICT (id) DO UPDATE SET embassy_note = EXCLUDED.embassy_note, contacts = EXCLUDED.contacts, updated_at = NOW();`);
w("");

// content_itineraries
function itineraryInsert(it, kind, sortOrder) {
  w(`INSERT INTO content_itineraries (
  id, kind, title, meta, route_summary, estimated_budget, days, sort_order, is_active
) VALUES (
  ${sqlStr(it.id)}, ${sqlStr(kind)}, ${sqlStr(it.title)}, ${sqlStr(it.meta)},
  ${sqlStr(it.route_summary ?? it.routeSummary)}, ${sqlStr(it.estimated_budget ?? it.estimatedBudget)},
  ${sqlJson(it.days)}, ${sortOrder}, TRUE
) ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title, meta = EXCLUDED.meta, days = EXCLUDED.days, updated_at = NOW();`);
}

const sample = load("sample_itinerary");
w("-- content_itineraries (sample)");
itineraryInsert(sample, "sample", 0);

try {
  const planning = load("planning_itinerary");
  w("-- content_itineraries (planning)");
  itineraryInsert(planning, "planning", 1);
} catch {
  w("-- planning_itinerary.json not found, skipped");
}

w("");
w("COMMIT;");
w("");

writeFileSync(outPath, lines.join("\n"), "utf8");
console.log(`Wrote ${outPath} (${lines.length} lines)`);
