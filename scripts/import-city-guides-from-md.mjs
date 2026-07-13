#!/usr/bin/env node
/**
 * Import city guides from Desktop markdown folders into city_guides.
 *
 *   node scripts/import-city-guides-from-md.mjs --dry-run
 *   node scripts/import-city-guides-from-md.mjs --apply
 */
import { createClient } from "@supabase/supabase-js";
import { mkdirSync, writeFileSync } from "fs";
import { join } from "path";
import { buildCityGuideRows } from "./gen-city-guides-from-md.mjs";
import { getSupabaseConfig, loadServiceKey } from "./lib/supabase-service.mjs";

const ROOT = "/Users/vesperal/Desktop/YOLO";
const OUT_REPORT = join(ROOT, "scripts/generated/city_guides_import_report.json");

const args = process.argv.slice(2);
const dryRun = args.includes("--dry-run") || !args.includes("--apply");

function toPayload(row) {
  return {
    id: row.id,
    city_id: row.city_id,
    title_en: row.title_en,
    title_zh: row.title_zh,
    subtitle: row.subtitle,
    icon: row.icon,
    badge: row.badge,
    cover_images: [],
    body: row.body,
    meta_items: row.meta_items,
    display_order: row.display_order,
    is_published: true,
  };
}

async function applyRows(rows) {
  const supabase = createClient(getSupabaseConfig().url, loadServiceKey(), {
    auth: { persistSession: false, autoRefreshToken: false },
  });

  const byCity = new Map();
  for (const row of rows) {
    if (!byCity.has(row.city_id)) byCity.set(row.city_id, []);
    byCity.get(row.city_id).push(row);
  }

  for (const [cityId, cityRows] of [...byCity.entries()].sort()) {
    const keepIds = new Set(cityRows.map((r) => r.id));
    const { data: existing, error: listErr } = await supabase
      .from("city_guides")
      .select("id")
      .eq("city_id", cityId);
    if (listErr) throw new Error(`list ${cityId}: ${listErr.message}`);

    const staleIds = (existing || []).map((r) => r.id).filter((id) => !keepIds.has(id));
    if (staleIds.length) {
      const { error: delErr } = await supabase.from("city_guides").delete().in("id", staleIds);
      if (delErr) throw new Error(`delete stale ${cityId}: ${delErr.message}`);
    }

    const payload = cityRows.map(toPayload);
    const { error } = await supabase.from("city_guides").upsert(payload, { onConflict: "id" });
    if (error) throw new Error(`upsert ${cityId}: ${error.message}`);
    console.log(`[apply] ${cityId}: ${payload.length} guides`);
  }
}

async function main() {
  mkdirSync(join(ROOT, "scripts/generated"), { recursive: true });
  const rows = buildCityGuideRows();

  const byCity = Object.fromEntries(
    [...new Set(rows.map((r) => r.city_id))].sort().map((cityId) => [
      cityId,
      rows
        .filter((r) => r.city_id === cityId)
        .map((r) => ({
          id: r.id,
          title_en: r.title_en,
          body_length: r.body_length,
          warnings: r.warnings,
        })),
    ])
  );

  writeFileSync(
    OUT_REPORT,
    JSON.stringify(
      {
        generatedAt: new Date().toISOString(),
        mode: dryRun ? "dry-run" : "apply",
        total: rows.length,
        byCity,
      },
      null,
      2
    ),
    "utf8"
  );

  console.log(`parsed ${rows.length} city guides`);
  for (const [cityId, guides] of Object.entries(byCity)) {
    console.log(`  ${cityId}: ${guides.length}`);
  }
  console.log(`Report: ${OUT_REPORT}`);

  if (dryRun) {
    console.log("\n[dry-run] 未写库。确认后加 --apply");
    return;
  }

  if (!loadServiceKey()) throw new Error("缺少 SUPABASE_SERVICE_ROLE_KEY");
  await applyRows(rows);
  console.log("Done.");
}

main().catch((err) => {
  console.error(err.message || err);
  process.exit(1);
});
