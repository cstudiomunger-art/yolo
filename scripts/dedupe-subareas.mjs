#!/usr/bin/env node
/**
 * Deduplicate sub_areas: keep canonical rows, migrate audio_url, delete legacy duplicates.
 *
 * Usage:
 *   node scripts/dedupe-subareas.mjs --dry-run
 *   node scripts/dedupe-subareas.mjs --apply
 *   node scripts/dedupe-subareas.mjs --apply --city beijing
 */
import { readFileSync, writeFileSync, mkdirSync } from "fs";
import { join } from "path";
import { createClient } from "@supabase/supabase-js";

const ROOT = "/Users/vesperal/Desktop/YOLO";
const REPORT_IN = join(ROOT, "scripts/generated/sub_areas_duplicates_report.json");
const REPORT_OUT = join(ROOT, "scripts/generated/sub_areas_dedupe_result.json");
const SQL_OUT = join(ROOT, "scripts/generated/sub_areas_dedupe.sql");

const args = process.argv.slice(2);
const dryRun = !args.includes("--apply");
const cityFilter = args.includes("--city") ? args[args.indexOf("--city") + 1] : "";

function readXc(k) {
  const t = readFileSync(join(ROOT, "Secrets.xcconfig"), "utf8");
  const l = t.split(/\r?\n/).find((x) => x.trim().startsWith(`${k} =`));
  return l.split("=").slice(1).join("=").replace(/\$\(\)/g, "").trim();
}

function loadKey() {
  if (process.env.SUPABASE_SERVICE_ROLE_KEY) return process.env.SUPABASE_SERVICE_ROLE_KEY;
  const m = readFileSync(join(ROOT, ".env.local.tmp"), "utf8").match(
    /SUPABASE_SERVICE_ROLE_KEY\s*=\s*"?([^"\n]+)"?/
  );
  if (!m?.[1]) throw new Error("缺少 SUPABASE_SERVICE_ROLE_KEY");
  return m[1].trim();
}

const url = readXc("SUPABASE_URL").replace("https:/", "https://");
const key = loadKey();
const supabase = createClient(url, key, { auth: { persistSession: false } });

async function rest(path, init = {}) {
  const res = await fetch(`${url}${path}`, {
    ...init,
    headers: { apikey: key, Authorization: `Bearer ${key}`, ...(init.headers || {}) },
  });
  if (!res.ok) throw new Error(`${path} -> ${res.status} ${await res.text()}`);
  if (res.status === 204) return null;
  const text = await res.text();
  return text ? JSON.parse(text) : null;
}

function sqlStr(v) {
  return v == null ? "NULL" : `'${String(v).replace(/'/g, "''")}'`;
}

const audit = JSON.parse(readFileSync(REPORT_IN, "utf8"));
let groups = audit.duplicateGroups || [];
if (cityFilter) groups = groups.filter((g) => g.cityId === cityFilter);

const audioMigrations = [];
const toDelete = new Set();

for (const g of groups) {
  for (const dup of g.duplicateByName || []) {
    const ranked = [...dup.ids].sort((a, b) => b.score - a.score);
    const keep = ranked[0];
    for (const drop of ranked.slice(1)) {
      if (drop.hasAudio && !keep.hasAudio) {
        audioMigrations.push({
          keepId: keep.id,
          fromId: drop.id,
          attractionName: g.attractionName,
          nameZh: dup.nameZh,
        });
        keep.hasAudio = true;
      }
      toDelete.add(drop.id);
    }
  }
}

// Extra pass: legacy *_bj_sa_* when canonical sibling exists (same attraction + sort_order)
const CITIES = cityFilter
  ? [cityFilter]
  : ["shanghai", "nanjing", "beijing", "chengdu", "suzhou"];
const attractions = await rest(
  `/rest/v1/attractions?select=id,chinese_name,city_id&city_id=in.(${CITIES.join(",")})`
);
const attractionIds = attractions.map((a) => a.id);
const byId = new Map();
for (let i = 0; i < attractionIds.length; i += 15) {
  const chunk = attractionIds.slice(i, i + 15);
  const rows = await rest(
    `/rest/v1/sub_areas?attraction_id=in.(${chunk.join(",")})&select=id,attraction_id,name_zh,sort_order,audio_url,cover_image_path,body`
  );
  for (const r of rows) byId.set(r.id, r);
}

for (const row of byId.values()) {
  const m = row.id.match(/^(.+)_bj_sa_(\d{2})$/);
  if (!m) continue;
  const canonicalId = `${m[1]}_sa_${m[2]}`;
  const canonical = byId.get(canonicalId);
  if (!canonical) continue;
  if (!toDelete.has(row.id)) {
    if (row.audio_url && !canonical.audio_url) {
      audioMigrations.push({
        keepId: canonicalId,
        fromId: row.id,
        attractionName: attractions.find((a) => a.id === row.attraction_id)?.chinese_name,
        nameZh: row.name_zh,
        via: "bj_pattern",
      });
    }
    toDelete.add(row.id);
  }
}

const deleteIds = [...toDelete];
const uniqueMigrations = [];
const seenKeep = new Set();
for (const mig of audioMigrations) {
  if (seenKeep.has(mig.keepId)) continue;
  const keepRow = byId.get(mig.keepId);
  const fromRow = byId.get(mig.fromId);
  if (!keepRow || !fromRow?.audio_url || keepRow.audio_url) continue;
  uniqueMigrations.push({ ...mig, audio_url: fromRow.audio_url });
  seenKeep.add(mig.keepId);
}

const sql = [
  "-- Generated sub_areas dedupe",
  `-- delete=${deleteIds.length} audio_migrate=${uniqueMigrations.length}`,
  "",
  ...uniqueMigrations.map(
    (m) =>
      `UPDATE sub_areas SET audio_url=${sqlStr(m.audio_url)}, updated_at=NOW() WHERE id=${sqlStr(m.keepId)}; -- from ${m.fromId}`
  ),
  "",
  ...deleteIds.map((id) => `DELETE FROM sub_areas WHERE id=${sqlStr(id)};`),
].join("\n");

writeFileSync(SQL_OUT, sql);

const result = {
  generatedAt: new Date().toISOString(),
  mode: dryRun ? "dry-run" : "apply",
  cityFilter: cityFilter || "all",
  audioMigrations: uniqueMigrations.length,
  rowsToDelete: deleteIds.length,
  sampleMigrations: uniqueMigrations.slice(0, 5),
  sampleDeletes: deleteIds.slice(0, 10),
};

if (!dryRun) {
  for (const m of uniqueMigrations) {
    const { error } = await supabase
      .from("sub_areas")
      .update({ audio_url: m.audio_url, updated_at: new Date().toISOString() })
      .eq("id", m.keepId);
    if (error) throw new Error(`audio migrate ${m.keepId}: ${error.message}`);
  }

  for (let i = 0; i < deleteIds.length; i += 50) {
    const batch = deleteIds.slice(i, i + 50);
    const { error } = await supabase.from("sub_areas").delete().in("id", batch);
    if (error) throw new Error(`delete batch: ${error.message}`);
    console.log(`  deleted ${Math.min(i + 50, deleteIds.length)}/${deleteIds.length}`);
  }
}

mkdirSync(join(ROOT, "scripts/generated"), { recursive: true });
writeFileSync(REPORT_OUT, JSON.stringify({ ...result, deleteIds, uniqueMigrations }, null, 2));
console.log(JSON.stringify(result, null, 2));
