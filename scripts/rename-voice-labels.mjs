#!/usr/bin/env node
/**
 * Rename voice_label in audio_voice_variants: Benedict → Cleo, Blanchett → Milo
 *
 *   node scripts/rename-voice-labels.mjs --dry-run
 *   node scripts/rename-voice-labels.mjs --apply
 */
import { createClient } from "@supabase/supabase-js";
import { getSupabaseConfig, loadServiceKey } from "./lib/supabase-service.mjs";

const RENAMES = [
  { from: "Benedict", to: "Cleo" },
  { from: "Blanchett", to: "Milo" },
];

const args = process.argv.slice(2);
const dryRun = args.includes("--dry-run") || !args.includes("--apply");

async function main() {
  if (!loadServiceKey() && !dryRun) throw new Error("缺少 SUPABASE_SERVICE_ROLE_KEY");

  const supabase = createClient(getSupabaseConfig().url, loadServiceKey() || "dry-run", {
    auth: { persistSession: false, autoRefreshToken: false },
  });

  for (const { from, to } of RENAMES) {
    const { data, error: countErr } = await supabase
      .from("audio_voice_variants")
      .select("id", { count: "exact", head: false })
      .eq("voice_label", from);
    if (countErr) throw new Error(`count ${from}: ${countErr.message}`);
    console.log(`${from} → ${to}: ${data?.length ?? 0} rows`);

    if (dryRun) continue;

    const { error } = await supabase
      .from("audio_voice_variants")
      .update({ voice_label: to, updated_at: new Date().toISOString() })
      .eq("voice_label", from);
    if (error) throw new Error(`update ${from}: ${error.message}`);
    console.log(`  [apply] updated`);
  }

  if (dryRun) {
    console.log("\n[dry-run] 未写库。确认后加 --apply");
    return;
  }

  for (const label of ["Cleo", "Milo"]) {
    const { count, error } = await supabase
      .from("audio_voice_variants")
      .select("id", { count: "exact", head: true })
      .eq("voice_label", label);
    if (error) throw error;
    console.log(`verify ${label}: ${count ?? 0}`);
  }
}

main().catch((err) => {
  console.error(err.message || err);
  process.exit(1);
});
