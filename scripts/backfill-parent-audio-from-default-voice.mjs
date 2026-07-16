#!/usr/bin/env node
/**
 * Mirror default voice variant audio_url onto parent rows when parent audio_url is empty/stale.
 *
 * Covers: sub_areas, city_guides, audio_guides
 *
 *   node scripts/backfill-parent-audio-from-default-voice.mjs
 *   node scripts/backfill-parent-audio-from-default-voice.mjs --apply
 */
import { createClient } from "@supabase/supabase-js";
import { getSupabaseConfig, loadServiceKey } from "./lib/supabase-service.mjs";

const args = process.argv.slice(2);
const apply = args.includes("--apply");
const dryRun = !apply;

const OWNER_TABLE = {
  sub_area: { table: "sub_areas", audioField: "audio_url", extra: () => ({}) },
  city_guide: {
    table: "city_guides",
    audioField: "audio_url",
    extra: (def) => ({ audio_duration_seconds: def.duration_seconds || 0 }),
  },
  audio_guide: {
    table: "audio_guides",
    audioField: "audio_url",
    extra: (def) => ({
      duration_seconds: def.duration_seconds || 0,
      segments: def.segments || [],
    }),
  },
};

function pickDefault(variants) {
  const active = variants.filter((v) => v.is_active !== false && String(v.audio_url || "").trim());
  if (!active.length) return null;
  return (
    active.find((v) => v.is_default) ||
    [...active].sort((a, b) => (a.sort_order ?? 0) - (b.sort_order ?? 0))[0]
  );
}

async function fetchAll(supabase, table, select) {
  const pageSize = 1000;
  let from = 0;
  const rows = [];
  for (;;) {
    const { data, error } = await supabase.from(table).select(select).range(from, from + pageSize - 1);
    if (error) throw new Error(`${table}: ${error.message}`);
    rows.push(...(data || []));
    if (!data || data.length < pageSize) break;
    from += pageSize;
  }
  return rows;
}

async function main() {
  const serviceKey = loadServiceKey();
  if (!serviceKey && apply) throw new Error("缺少 SUPABASE_SERVICE_ROLE_KEY（--apply 需要）");

  const cfg = getSupabaseConfig();
  console.log(`url: ${cfg.url}`);
  console.log(`auth: ${serviceKey ? "service_role" : "anon/fallback"}`);

  const supabase = createClient(cfg.url, serviceKey || cfg.key, {
    auth: { persistSession: false, autoRefreshToken: false },
  });

  console.log("loading voice variants…");
  const variants = await fetchAll(
    supabase,
    "audio_voice_variants",
    "id,owner_type,owner_id,voice_label,audio_url,duration_seconds,segments,sort_order,is_default,is_active"
  );
  const activeVariants = variants.filter((v) => v.is_active !== false);

  const byOwner = new Map();
  for (const v of activeVariants) {
    const keyOwner = `${v.owner_type}::${v.owner_id}`;
    if (!byOwner.has(keyOwner)) byOwner.set(keyOwner, []);
    byOwner.get(keyOwner).push(v);
  }

  console.log("loading parent rows…");
  const parentsByType = {};
  for (const [ownerType, meta] of Object.entries(OWNER_TABLE)) {
    const rows = await fetchAll(supabase, meta.table, `id,${meta.audioField}`);
    parentsByType[ownerType] = new Map(rows.map((r) => [r.id, r]));
  }

  const planned = [];
  for (const [keyOwner, list] of byOwner) {
    const [ownerType, ownerId] = keyOwner.split("::");
    const meta = OWNER_TABLE[ownerType];
    if (!meta) continue;
    const def = pickDefault(list);
    if (!def) continue;
    const defaultUrl = String(def.audio_url || "").trim();
    if (!defaultUrl) continue;

    const parent = parentsByType[ownerType]?.get(ownerId);
    if (!parent) continue;

    const parentUrl = String(parent[meta.audioField] || "").trim();
    if (parentUrl === defaultUrl) continue;

    planned.push({
      ownerType,
      ownerId,
      table: meta.table,
      voiceLabel: def.voice_label,
      from: parentUrl || "(empty)",
      to: defaultUrl,
      patch: {
        [meta.audioField]: defaultUrl,
        updated_at: new Date().toISOString(),
        ...meta.extra(def),
      },
    });
  }

  console.log(`variants: ${activeVariants.length}`);
  console.log(`owners with voice: ${byOwner.size}`);
  console.log(`need update: ${planned.length}`);
  for (const row of planned.slice(0, 50)) {
    console.log(
      `  ${row.ownerType}\t${row.ownerId}\t${row.voiceLabel}\t${row.from.slice(0, 32)} → …${row.to.slice(-48)}`
    );
  }
  if (planned.length > 50) console.log(`  … +${planned.length - 50} more`);

  const sample = planned.find((p) => p.ownerId === "hangzhou_west_lake_sa_01");
  console.log(
    `\nincludes hangzhou_west_lake_sa_01 (断桥残雪): ${sample ? "yes" : "no (already synced or no voice)"}`
  );

  if (dryRun) {
    console.log("\n[dry-run] 未写库。确认后加 --apply");
    return;
  }

  let ok = 0;
  for (const row of planned) {
    const { error: uErr } = await supabase.from(row.table).update(row.patch).eq("id", row.ownerId);
    if (uErr) {
      console.error(`FAIL ${row.ownerId}: ${uErr.message}`);
      continue;
    }
    ok += 1;
  }
  console.log(`\n[apply] updated ${ok}/${planned.length}`);
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
