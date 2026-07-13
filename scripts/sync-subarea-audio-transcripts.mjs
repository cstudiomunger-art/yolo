#!/usr/bin/env node
/**
 * Copy sub_areas.body → audio_transcript where transcript is empty.
 *
 *   node scripts/sync-subarea-audio-transcripts.mjs --dry-run
 *   node scripts/sync-subarea-audio-transcripts.mjs --apply
 */
import { createClient } from "@supabase/supabase-js";
import { mkdirSync, writeFileSync } from "fs";
import { join } from "path";
import { getSupabaseConfig, loadServiceKey } from "./lib/supabase-service.mjs";

const ROOT = "/Users/vesperal/Desktop/YOLO";
const OUT = join(ROOT, "scripts/generated/audio_transcript_sync_report.json");
const MIN_LEN = 200;

const args = process.argv.slice(2);
const dryRun = args.includes("--dry-run") || !args.includes("--apply");

async function main() {
  mkdirSync(join(ROOT, "scripts/generated"), { recursive: true });
  if (!loadServiceKey() && !dryRun) throw new Error("缺少 SUPABASE_SERVICE_ROLE_KEY");

  const supabase = createClient(getSupabaseConfig().url, loadServiceKey(), {
    auth: { persistSession: false, autoRefreshToken: false },
  });

  const { data, error } = await supabase
    .from("sub_areas")
    .select("id,name_zh,body,audio_transcript,audio_url,is_active")
    .eq("is_active", true);
  if (error) throw error;

  const toSync = (data || []).filter((row) => {
    const body = (row.body || "").trim();
    const transcript = (row.audio_transcript || "").trim();
    return body.length >= MIN_LEN && transcript.length < MIN_LEN;
  });

  console.log(`candidates: ${toSync.length} / ${data?.length ?? 0} active sub_areas`);

  if (!dryRun) {
    const batchSize = 40;
    for (let i = 0; i < toSync.length; i += batchSize) {
      const batch = toSync.slice(i, i + batchSize);
      await Promise.all(
        batch.map(async (row) => {
          const { error: upErr } = await supabase
            .from("sub_areas")
            .update({
              audio_transcript: row.body,
              updated_at: new Date().toISOString(),
            })
            .eq("id", row.id);
          if (upErr) throw new Error(`${row.id}: ${upErr.message}`);
        })
      );
      console.log(`  synced ${Math.min(i + batchSize, toSync.length)}/${toSync.length}`);
    }
  }

  const report = {
    generatedAt: new Date().toISOString(),
    mode: dryRun ? "dry-run" : "apply",
    synced: toSync.length,
    examples: toSync.slice(0, 10).map((r) => ({
      id: r.id,
      nameZh: r.name_zh,
      bodyLen: (r.body || "").length,
      hasAudio: Boolean((r.audio_url || "").trim()),
    })),
  };
  writeFileSync(OUT, `${JSON.stringify(report, null, 2)}\n`, "utf8");
  console.log(`Report: ${OUT}`);

  if (dryRun) {
    console.log("\n[dry-run] 未写库。确认后加 --apply");
  }
}

main().catch((err) => {
  console.error(err.message || err);
  process.exit(1);
});
