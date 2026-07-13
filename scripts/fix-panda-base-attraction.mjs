#!/usr/bin/env node
/**
 * Fix Chengdu panda base: migrate bogus attraction id to chengdu_panda_base,
 * remap sub_areas + audio_voice_variants, delete legacy rows.
 *
 * Usage:
 *   node scripts/fix-panda-base-attraction.mjs --dry-run
 *   node scripts/fix-panda-base-attraction.mjs --apply
 */
import { createClient } from "@supabase/supabase-js";
import { mkdirSync, readFileSync, writeFileSync } from "fs";
import { join } from "path";

const ROOT = "/Users/vesperal/Desktop/YOLO";
const OUT_DIR = join(ROOT, "scripts/generated");
const OLD_ATTRACTION_ID = "https_yoloadmin_vue_cstudiomunger_workers_dev";
const NEW_ATTRACTION_ID = "chengdu_panda_base";

const args = process.argv.slice(2);
const dryRun = args.includes("--dry-run") || !args.includes("--apply");

function readXcconfigValue(path, key) {
  const text = readFileSync(path, "utf8");
  const line = text.split(/\r?\n/).find((it) => it.trim().startsWith(`${key} =`));
  if (!line) return "";
  return line.split("=").slice(1).join("=").replace(/\$\(\)/g, "").trim();
}

function loadServiceKey() {
  if (process.env.SUPABASE_SERVICE_ROLE_KEY) return process.env.SUPABASE_SERVICE_ROLE_KEY;
  const tmp = join(ROOT, ".env.local.tmp");
  const m = readFileSync(tmp, "utf8").match(/SUPABASE_SERVICE_ROLE_KEY\s*=\s*"?([^"\n]+)"?/);
  if (!m?.[1]) throw new Error("缺少 SUPABASE_SERVICE_ROLE_KEY");
  return m[1].trim();
}

const url = readXcconfigValue(join(ROOT, "Secrets.xcconfig"), "SUPABASE_URL").replace(/\$\(\)/g, "");
const key = loadServiceKey();
const supabase = createClient(url, key, { auth: { persistSession: false, autoRefreshToken: false } });

async function rest(path, init = {}) {
  const res = await fetch(`${url}${path}`, {
    ...init,
    headers: { apikey: key, Authorization: `Bearer ${key}`, Prefer: "return=representation", ...(init.headers || {}) },
  });
  if (!res.ok) throw new Error(`${path} -> ${res.status} ${await res.text()}`);
  const text = await res.text();
  return text ? JSON.parse(text) : null;
}

function newSubAreaId(sortIndex) {
  return `${NEW_ATTRACTION_ID}_sa_${String(sortIndex + 1).padStart(2, "0")}`;
}

function oldSubAreaId(sortIndex) {
  return `${OLD_ATTRACTION_ID}_sa_${String(sortIndex + 1).padStart(2, "0")}`;
}

function variantId(subAreaId, suffix) {
  return `avv_sa_${subAreaId}_${suffix}`;
}

async function main() {
  mkdirSync(OUT_DIR, { recursive: true });

  const attractions = await rest(
    `/rest/v1/attractions?select=*&or=(id.eq.${OLD_ATTRACTION_ID},id.eq.${NEW_ATTRACTION_ID})`
  );
  const oldAttr = attractions.find((a) => a.id === OLD_ATTRACTION_ID);
  const newAttr = attractions.find((a) => a.id === NEW_ATTRACTION_ID);

  const oldSubAreas = oldAttr
    ? await rest(
        `/rest/v1/sub_areas?select=*&attraction_id=eq.${OLD_ATTRACTION_ID}&order=sort_order`
      )
    : [];
  const newSubAreas = newAttr
    ? await rest(
        `/rest/v1/sub_areas?select=id,sort_order&attraction_id=eq.${NEW_ATTRACTION_ID}&order=sort_order`
      )
    : [];

  const oldVariants = oldSubAreas.length
    ? await rest(
        `/rest/v1/audio_voice_variants?select=*&owner_type=eq.sub_area&owner_id=in.(${oldSubAreas.map((s) => s.id).join(",")})`
      )
    : [];

  const plan = {
    createAttraction: Boolean(oldAttr && !newAttr),
    updateAttractionCoords: Boolean(newAttr || oldAttr),
    subAreaMigrations: oldSubAreas.map((row) => ({
      fromId: row.id,
      toId: newSubAreaId(row.sort_order),
      sortOrder: row.sort_order,
      nameZh: row.name_zh,
      audioUrl: row.audio_url,
    })),
    variantMigrations: [],
    deleteOldSubAreaIds: oldSubAreas.map((s) => s.id),
    deleteOldVariantIds: oldVariants.map((v) => v.id),
    deleteOldAttractionId: oldAttr ? OLD_ATTRACTION_ID : null,
  };

  for (const v of oldVariants) {
    const oldOwner = v.owner_id;
    const m = oldOwner.match(/_sa_(\d{2})$/);
    if (!m) continue;
    const sortIndex = Number(m[1]) - 1;
    const newOwner = newSubAreaId(sortIndex);
    const suffix = ["Milo", "Blanchett"].includes(v.voice_label) ? "blanchett" : "benedict";
    plan.variantMigrations.push({
      fromId: v.id,
      toId: variantId(newOwner, suffix),
      fromOwner: oldOwner,
      toOwner: newOwner,
      voiceLabel: v.voice_label,
      audioUrl: v.audio_url,
      sortOrder: v.sort_order,
      isDefault: v.is_default,
    });
  }

  const reportPath = join(OUT_DIR, "fix_panda_base_report.json");
  writeFileSync(
    reportPath,
    JSON.stringify({ generatedAt: new Date().toISOString(), mode: dryRun ? "dry-run" : "apply", plan }, null, 2),
    "utf8"
  );

  console.log(JSON.stringify({
    oldAttraction: Boolean(oldAttr),
    newAttraction: Boolean(newAttr),
    oldSubAreas: oldSubAreas.length,
    variants: oldVariants.length,
    migrations: plan.subAreaMigrations.length,
  }, null, 2));
  console.log(`Report: ${reportPath}`);

  if (dryRun) {
    console.log("\n[dry-run] 未写库。确认后运行 --apply");
    return;
  }

  if (oldAttr && !newAttr) {
    const { id, created_at, updated_at, ...restFields } = oldAttr;
    const payload = { ...restFields, id: NEW_ATTRACTION_ID, chinese_name: "大熊猫基地", name: restFields.name || "Giant Panda Base" };
    const { error } = await supabase.from("attractions").upsert(payload, { onConflict: "id" });
    if (error) throw new Error(`create attraction: ${error.message}`);
  }

  for (const mig of plan.subAreaMigrations) {
    const oldRow = oldSubAreas.find((s) => s.id === mig.fromId);
    if (!oldRow) continue;
    const { id, created_at, updated_at, ...rest } = oldRow;
    const payload = { ...rest, id: mig.toId, attraction_id: NEW_ATTRACTION_ID };
    const { error: upsertErr } = await supabase.from("sub_areas").upsert(payload, { onConflict: "id" });
    if (upsertErr) throw new Error(`upsert ${mig.toId}: ${upsertErr.message}`);
  }

  for (const vm of plan.variantMigrations) {
    const { error: delErr } = await supabase.from("audio_voice_variants").delete().eq("id", vm.toId);
    if (delErr) throw new Error(`delete variant ${vm.toId}: ${delErr.message}`);
    const { error: insErr } = await supabase.from("audio_voice_variants").insert({
      id: vm.toId,
      owner_type: "sub_area",
      owner_id: vm.toOwner,
      voice_label: vm.voiceLabel,
      audio_url: vm.audioUrl,
      sort_order: vm.sortOrder,
      is_default: vm.isDefault,
    });
    if (insErr) throw new Error(`insert variant ${vm.toId}: ${insErr.message}`);
  }

  if (plan.deleteOldVariantIds.length) {
    const { error } = await supabase.from("audio_voice_variants").delete().in("id", plan.deleteOldVariantIds);
    if (error) throw new Error(`delete old variants: ${error.message}`);
  }
  if (plan.deleteOldSubAreaIds.length) {
    const { error } = await supabase.from("sub_areas").delete().in("id", plan.deleteOldSubAreaIds);
    if (error) throw new Error(`delete old sub_areas: ${error.message}`);
  }
  if (plan.deleteOldAttractionId) {
    const { error } = await supabase.from("attractions").delete().eq("id", plan.deleteOldAttractionId);
    if (error) throw new Error(`delete old attraction: ${error.message}`);
  }

  console.log("\n[apply] 大熊猫基地已迁移至 chengdu_panda_base");
}

main().catch((err) => {
  console.error(err.message);
  process.exit(1);
});
