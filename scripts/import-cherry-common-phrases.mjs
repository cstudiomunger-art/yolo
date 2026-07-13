#!/usr/bin/env node
/**
 * Upload Cherry Mandarin common_phrases from folder + _manifest.json
 *
 * Usage:
 *   node scripts/import-cherry-common-phrases.mjs --root "/path/通用普通话音频_Cherry" --dry-run
 *   node scripts/import-cherry-common-phrases.mjs --root "/path" --apply
 */
import { createClient } from "@supabase/supabase-js";
import { existsSync, mkdirSync, readFileSync, writeFileSync } from "fs";
import { join } from "path";

const ROOT = "/Users/vesperal/Desktop/YOLO";
const OUT_DIR = join(ROOT, "scripts/generated");
const AUDIO_BUCKET = "audio-guides";
const LEGACY_SEED_IDS = ["hello", "thanks", "howmuch", "nospicy", "toilet"];

const args = process.argv.slice(2);
const dryRun = args.includes("--dry-run") || !args.includes("--apply");

function argValue(flag) {
  const i = args.indexOf(flag);
  return i >= 0 && args[i + 1] ? args[i + 1] : "";
}

const sourceRoot = argValue("--root") || "/Users/vesperal/Desktop/通用普通话音频_Cherry";

function readXcconfigValue(path, key) {
  const text = readFileSync(path, "utf8");
  const line = text.split(/\r?\n/).find((it) => it.trim().startsWith(`${key} =`));
  if (!line) return "";
  return line.split("=").slice(1).join("=").replace(/\$\(\)/g, "").trim();
}

function loadServiceKey() {
  if (process.env.SUPABASE_SERVICE_ROLE_KEY) return process.env.SUPABASE_SERVICE_ROLE_KEY;
  const tmp = join(ROOT, ".env.local.tmp");
  try {
    const m = readFileSync(tmp, "utf8").match(/SUPABASE_SERVICE_ROLE_KEY\s*=\s*"?([^"\n]+)"?/);
    if (m?.[1]) return m[1].trim();
  } catch {
    /* optional */
  }
  return "";
}

function getSupabaseConfig() {
  const xcPath = join(ROOT, "Secrets.xcconfig");
  const url = (process.env.SUPABASE_URL || readXcconfigValue(xcPath, "SUPABASE_URL")).replace(/\$\(\)/g, "");
  const key =
    loadServiceKey() ||
    process.env.SUPABASE_ANON_KEY ||
    readXcconfigValue(xcPath, "SUPABASE_ANON_KEY");
  if (!url || !key) throw new Error("缺少 SUPABASE_URL 或 key");
  return { url, key, usesServiceRole: Boolean(loadServiceKey()) };
}

function createSupabase() {
  const { url, key } = getSupabaseConfig();
  return createClient(url, key, { auth: { persistSession: false, autoRefreshToken: false } });
}

function phraseId(index) {
  return `phrase_common_${String(index).padStart(3, "0")}`;
}

function publicUrl(supabaseUrl, path) {
  return `${supabaseUrl}/storage/v1/object/public/${AUDIO_BUCKET}/${path}`;
}

async function main() {
  mkdirSync(OUT_DIR, { recursive: true });
  if (!existsSync(sourceRoot)) throw new Error(`源目录不存在: ${sourceRoot}`);

  const manifestPath = join(sourceRoot, "_manifest.json");
  const manifest = JSON.parse(readFileSync(manifestPath, "utf8"));
  const items = manifest
    .filter((it) => it.ok !== false && it.file)
    .sort((a, b) => a.index - b.index);

  const { url: supabaseUrl, key, usesServiceRole } = getSupabaseConfig();
  if (!dryRun && !usesServiceRole) {
    throw new Error("缺少 SUPABASE_SERVICE_ROLE_KEY，--apply 需要 service role");
  }
  const supabase = createSupabase();

  const rows = [];
  for (const item of items) {
    const localPath = join(sourceRoot, item.file);
    if (!existsSync(localPath)) throw new Error(`缺少音频: ${localPath}`);
    const id = phraseId(item.index);
    const storagePath = `phrases/${id}.mp3`;
    let audioUrl = publicUrl(supabaseUrl, storagePath);
    let uploaded = false;

    if (!dryRun) {
      const body = readFileSync(localPath);
      const { error } = await supabase.storage.from(AUDIO_BUCKET).upload(storagePath, body, {
        upsert: true,
        contentType: "audio/mpeg",
      });
      if (error) throw new Error(`upload ${storagePath}: ${error.message}`);
      uploaded = true;
    }

    rows.push({
      id,
      cn: item.zh || "",
      pinyin: item.read || "",
      en: item.en || "",
      audio_url: audioUrl,
      sort_order: item.index - 1,
      is_active: true,
      file: item.file,
      uploaded,
    });
  }

  const newIds = rows.map((r) => r.id);
  const deleteIds = [...new Set([...LEGACY_SEED_IDS])];

  if (!dryRun) {
    const { data: existing } = await supabase.from("common_phrases").select("id");
    for (const row of existing || []) {
      if (!newIds.includes(row.id)) deleteIds.push(row.id);
    }

    if (deleteIds.length) {
      const { error } = await supabase.from("common_phrases").delete().in("id", deleteIds);
      if (error) throw new Error(`delete old phrases: ${error.message}`);
    }

    const { error: upsertErr } = await supabase.from("common_phrases").upsert(
      rows.map(({ id, cn, pinyin, en, audio_url, sort_order, is_active }) => ({
        id,
        cn,
        pinyin,
        en,
        audio_url,
        sort_order,
        is_active,
      })),
      { onConflict: "id" }
    );
    if (upsertErr) throw new Error(`upsert phrases: ${upsertErr.message}`);
  }

  const report = {
    generatedAt: new Date().toISOString(),
    mode: dryRun ? "dry-run" : "apply",
    sourceRoot,
    stats: { phrases: rows.length, deletedIds: deleteIds.length },
    phrases: rows,
    deleteIds,
  };
  const outPath = join(OUT_DIR, "cherry_common_phrases_report.json");
  writeFileSync(outPath, JSON.stringify(report, null, 2), "utf8");

  console.log(JSON.stringify(report.stats, null, 2));
  console.log(`Report: ${outPath}`);
  if (dryRun) console.log("\n[dry-run] 未上传、未写库。确认后运行 --apply");
  else console.log(`\n[apply] 完成：${rows.length} 条常用语`);
}

main().catch((err) => {
  console.error(err.message);
  process.exit(1);
});
