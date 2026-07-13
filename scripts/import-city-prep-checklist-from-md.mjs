#!/usr/bin/env node
/**
 * Import city-specific prep checklists from Desktop markdown files.
 *
 *   node scripts/import-city-prep-checklist-from-md.mjs --dry-run
 *   node scripts/import-city-prep-checklist-from-md.mjs --apply
 */
import { createClient } from "@supabase/supabase-js";
import { mkdirSync, readFileSync, writeFileSync } from "fs";
import { join } from "path";
import { getSupabaseConfig, loadServiceKey } from "./lib/supabase-service.mjs";

const ROOT = "/Users/vesperal/Desktop/YOLO";
const OUT_DIR = join(ROOT, "scripts/generated");
const OUT_REPORT = join(OUT_DIR, "city_prep_checklist_report.json");

const CITY_SOURCES = [
  { cityId: "shanghai", prefix: "sh", groupTitle: "Shanghai", path: "/Users/vesperal/Desktop/EN_上海行前准备清单（特色版）.md" },
  { cityId: "beijing", prefix: "bj", groupTitle: "Beijing", path: "/Users/vesperal/Desktop/EN_北京行前准备清单（特色版）.md" },
  { cityId: "nanjing", prefix: "nj", groupTitle: "Nanjing", path: "/Users/vesperal/Desktop/EN_南京行前准备清单（特色版）.md" },
  { cityId: "chengdu", prefix: "cd", groupTitle: "Chengdu", path: "/Users/vesperal/Desktop/EN_成都行前准备清单（特色版）.md" },
  { cityId: "hangzhou", prefix: "hz", groupTitle: "Hangzhou", path: "/Users/vesperal/Desktop/EN_杭州行前准备清单（特色版）.md" },
  { cityId: "suzhou", prefix: "sz", groupTitle: "Suzhou", path: "/Users/vesperal/Desktop/EN_苏州行前准备清单（特色版）.md" },
  { cityId: "chongqing", prefix: "cq", groupTitle: "Chongqing", path: "/Users/vesperal/Desktop/EN_重庆行前准备清单（特色版）.md" },
];

const args = process.argv.slice(2);
const dryRun = args.includes("--dry-run") || !args.includes("--apply");

function parseCityItems(mdText, source) {
  const items = [];
  const re = /^- \[ \] \*\*(.+?)\*\* — (.+)$/gm;
  let match;
  let index = 0;
  while ((match = re.exec(mdText))) {
    index += 1;
    const titleEn = match[1].trim();
    const howToComplete = match[2].trim();
    items.push({
      id: `cl_${source.prefix}_${String(index).padStart(2, "0")}`,
      type: "city",
      phase: "before_departure",
      group_title: source.groupTitle,
      title_en: titleEn,
      priority: index <= 2 ? "required" : "recommended",
      why_important: "",
      how_to_complete: howToComplete,
      external_links: [],
      target_nationalities: [],
      target_cities: [source.cityId],
      city_id: source.cityId,
      display_tags: index <= 2 ? ["key"] : [],
      sort_order: index * 10,
      reminder_days_before: null,
      is_active: true,
    });
  }
  if (!items.length) throw new Error(`${source.path}: 未解析到清单条目`);
  return items;
}

async function applyCityRows(source, rows) {
  const supabase = createClient(getSupabaseConfig().url, loadServiceKey(), {
    auth: { persistSession: false, autoRefreshToken: false },
  });

  const keepIds = new Set(rows.map((r) => r.id));
  const { data: existing, error: listErr } = await supabase
    .from("checklist_items")
    .select("id")
    .eq("city_id", source.cityId)
    .eq("type", "city");
  if (listErr) throw new Error(`list ${source.cityId}: ${listErr.message}`);

  const staleIds = (existing || []).map((r) => r.id).filter((id) => !keepIds.has(id));
  if (staleIds.length) {
    const { error: offErr } = await supabase
      .from("checklist_items")
      .update({ is_active: false, updated_at: new Date().toISOString() })
      .in("id", staleIds);
    if (offErr) throw new Error(`deactivate ${source.cityId}: ${offErr.message}`);
  }

  const { error } = await supabase.from("checklist_items").upsert(rows, { onConflict: "id" });
  if (error) throw new Error(`upsert ${source.cityId}: ${error.message}`);
}

async function main() {
  mkdirSync(OUT_DIR, { recursive: true });
  const report = { generatedAt: new Date().toISOString(), mode: dryRun ? "dry-run" : "apply", cities: [] };

  for (const source of CITY_SOURCES) {
    const mdText = readFileSync(source.path, "utf8");
    const rows = parseCityItems(mdText, source);
    report.cities.push({
      cityId: source.cityId,
      source: source.path,
      count: rows.length,
      ids: rows.map((r) => r.id),
      titles: rows.map((r) => r.title_en),
    });
    console.log(`${source.cityId}: ${rows.length} items`);

    if (!dryRun) await applyCityRows(source, rows);
  }

  writeFileSync(OUT_REPORT, `${JSON.stringify(report, null, 2)}\n`, "utf8");
  console.log(`Report: ${OUT_REPORT}`);

  if (dryRun) {
    console.log("\n[dry-run] 未写库。确认后加 --apply");
    return;
  }

  if (!loadServiceKey()) throw new Error("缺少 SUPABASE_SERVICE_ROLE_KEY");
  console.log("[apply] 城市行前清单已 upsert");
}

main().catch((err) => {
  console.error(err.message || err);
  process.exit(1);
});
