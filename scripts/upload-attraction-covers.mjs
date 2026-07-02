#!/usr/bin/env node
/**
 * Upload Desktop city-folder PNG covers to Supabase Storage.
 *
 * Usage:
 *   SUPABASE_URL=... SUPABASE_SERVICE_ROLE_KEY=... node scripts/upload-attraction-covers.mjs
 */
import { createClient } from "@supabase/supabase-js";
import { readFileSync } from "fs";
import { join, dirname } from "path";
import { fileURLToPath } from "url";

const __dirname = dirname(fileURLToPath(import.meta.url));
const config = JSON.parse(
  readFileSync(join(__dirname, "city-attractions-config.json"), "utf8")
);

const url = process.env.SUPABASE_URL;
const key = process.env.SUPABASE_SERVICE_ROLE_KEY;
if (!url || !key) {
  console.error("Set SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY");
  process.exit(1);
}

const supabase = createClient(url, key);
const BUCKET = "cover-images";

function resolvePngBasename(mdBasename) {
  return config.png_aliases?.[mdBasename] ?? mdBasename;
}

async function uploadFile(storagePath, filePath) {
  const body = readFileSync(filePath);
  const { error } = await supabase.storage.from(BUCKET).upload(storagePath, body, {
    upsert: true,
    contentType: "image/png",
  });
  if (error) throw new Error(`${storagePath}: ${error.message}`);
  const { data } = supabase.storage.from(BUCKET).getPublicUrl(storagePath);
  return data.publicUrl;
}

async function main() {
  let uploaded = 0;
  let skipped = 0;

  for (const item of config.attractions) {
    if (config.no_cover?.includes(item.md)) {
      console.log(`  skip (no cover): ${item.md}`);
      skipped += 1;
      continue;
    }

    const folder = config.cities[item.city].folder;
    const pngBase = resolvePngBasename(item.md);
    const localPath = join(folder, `${pngBase}.png`);
    const storagePath = `attractions/${item.id}.png`;

    try {
      const publicUrl = await uploadFile(storagePath, localPath);
      console.log(`  ✓ ${item.md} → ${storagePath}`);
      console.log(`    ${publicUrl}`);
      uploaded += 1;
    } catch (err) {
      console.error(`  ✗ ${item.md}: ${err.message}`);
      process.exitCode = 1;
    }
  }

  console.log(`\nDone: ${uploaded} uploaded, ${skipped} skipped`);
}

main();
