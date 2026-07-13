#!/usr/bin/env node
/**
 * Generate + upsert hotels from Desktop markdown reports.
 *
 *   node scripts/import-hotels-from-md.mjs --dry-run
 *   node scripts/import-hotels-from-md.mjs --apply
 */
import { createClient } from "@supabase/supabase-js";
import { mkdirSync, writeFileSync } from "fs";
import { join } from "path";
import { getSupabaseConfig, loadServiceKey } from "./lib/supabase-service.mjs";

const ROOT = "/Users/vesperal/Desktop/YOLO";
const OUT_REPORT = join(ROOT, "scripts/generated/hotels_import_report.json");

const args = process.argv.slice(2);
const dryRun = args.includes("--dry-run") || !args.includes("--apply");

async function main() {
  const { processCity, CITY_SOURCES } = await import("./gen-hotels-from-md.mjs");
  mkdirSync(join(ROOT, "scripts/generated"), { recursive: true });

  const cityResults = [];
  const allHotels = [];

  for (const source of CITY_SOURCES) {
    const result = processCity(source);
    cityResults.push({
      cityId: result.cityId,
      imported: result.imported.length,
      skipped: result.skipped.length,
    });
    allHotels.push(...result.imported);
  }

  writeFileSync(
    OUT_REPORT,
    JSON.stringify({ generatedAt: new Date().toISOString(), mode: dryRun ? "dry-run" : "apply", cityResults, total: allHotels.length }, null, 2),
    "utf8"
  );

  console.log(`parsed ${allHotels.length} hotels across ${CITY_SOURCES.length} cities`);
  for (const c of cityResults) console.log(`  ${c.cityId}: ${c.imported} imported, ${c.skipped} skipped`);

  if (dryRun) {
    console.log("\n[dry-run] 未写库。确认后加 --apply");
    return;
  }

  if (!loadServiceKey()) throw new Error("缺少 SUPABASE_SERVICE_ROLE_KEY");

  const supabase = createClient(getSupabaseConfig().url, loadServiceKey(), {
    auth: { persistSession: false, autoRefreshToken: false },
  });

  for (const source of CITY_SOURCES) {
    const { imported } = processCity(source);
    const keepIds = new Set(imported.map((h) => h.id));
    const { data: existing, error: listErr } = await supabase
      .from("hotels")
      .select("id")
      .eq("city_id", source.cityId);
    if (listErr) throw new Error(`list ${source.cityId}: ${listErr.message}`);

    const staleIds = (existing || []).map((r) => r.id).filter((id) => !keepIds.has(id));
    if (staleIds.length) {
      const { error: delErr } = await supabase.from("hotels").delete().in("id", staleIds);
      if (delErr) throw new Error(`delete stale ${source.cityId}: ${delErr.message}`);
    }

    const payload = imported.map((h) => ({
      id: h.id,
      city_id: h.cityId,
      name: h.name,
      chinese_name: h.chineseName,
      stars: h.stars,
      price_min_usd: h.priceMinUsd,
      has_english_staff: h.hasEnglishStaff,
      english_staff_note: h.englishStaffNote,
      language_tip: h.languageTip,
      location_note: h.locationNote,
      address_zh: h.addressZh,
      address_en: h.addressEn,
      booking_platforms: h.bookingPlatforms,
      booking_links: h.bookingLinks,
      accepts_foreigners: h.acceptsForeigners,
      sort_order: h.sortOrder,
      is_active: h.isActive,
    }));

    const { error } = await supabase.from("hotels").upsert(payload, { onConflict: "id" });
    if (error) throw new Error(`upsert ${source.cityId}: ${error.message}`);
    console.log(`[apply] ${source.cityId}: ${payload.length} hotels`);
  }

  console.log("Done.");
}

main().catch((err) => {
  console.error(err.message || err);
  process.exit(1);
});
