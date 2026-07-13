#!/usr/bin/env node
/**
 * Match hotel cover images from Desktop folder → Supabase Storage + hotels.cover_image_path
 *
 *   node scripts/import-hotel-covers-from-folder.mjs --dry-run
 *   node scripts/import-hotel-covers-from-folder.mjs --apply
 */
import { execFileSync } from "child_process";
import {
  mkdirSync,
  readFileSync,
  readdirSync,
  statSync,
  unlinkSync,
  writeFileSync,
} from "fs";
import { basename, extname, join } from "path";
import { getSupabaseConfig } from "./lib/supabase-service.mjs";
import { CITY_SOURCES, processCity } from "./gen-hotels-from-md.mjs";

const ROOT = "/Users/vesperal/Desktop/YOLO";
const SOURCE_DIR = "/Users/vesperal/Desktop/酒店照片";
const OUT_DIR = join(ROOT, "scripts/generated");
const OUT_REPORT = join(OUT_DIR, "hotels_cover_update_report.json");
const COVER_BUCKET = "cover-images";

const CITY_FOLDER_TO_ID = {
  北京酒店照片: "beijing",
  上海酒店照片: "shanghai",
  南京酒店照片: "nanjing",
  成都酒店照片: "chengdu",
  杭州酒店照片: "hangzhou",
  苏州酒店照片: "suzhou",
  重庆酒店照片: "chongqing",
};

/** Filename stem → tier code when MD chinese_name differs from photo label */
const STEM_TIER_ALIASES = {
  杭州凯悦酒店: "H1-6",
  杭州诺富特酒店: "H2-3",
  "杭州国际青年旅舍（明堂）": "H3-1",
};

const args = process.argv.slice(2);
const dryRun = args.includes("--dry-run") || !args.includes("--apply");

function norm(s) {
  return String(s || "")
    .replace(/\s+/g, "")
    .replace(/[：:·•，,。.!！?？、“”"'()（）\-—_｜|]/g, "")
    .toLowerCase();
}

function parseTierFromStem(stem) {
  const m = String(stem || "").match(/^([A-Z]\d+-\d+)/);
  return m ? m[1] : null;
}

function parseCoverPath(raw) {
  const trimmed = String(raw || "").trim();
  if (!trimmed) return "";
  if (/^https?:\/\//i.test(trimmed)) {
    const marker = "/cover-images/";
    const idx = trimmed.indexOf(marker);
    if (idx >= 0) return trimmed.slice(idx + marker.length);
    return "";
  }
  let path = trimmed;
  if (path.startsWith("cover-images/")) path = path.slice("cover-images/".length);
  return path.replace(/^\/+/, "");
}

function contentTypeForExt(ext) {
  const e = ext.toLowerCase();
  if (e === ".png") return "image/png";
  if (e === ".webp") return "image/webp";
  return "image/jpeg";
}

const MAX_UPLOAD_BYTES = 5 * 1024 * 1024;
const MAX_DIMENSION = 2048;

function convertHeicTo(localPath, targetExt) {
  const tmpDir = join(OUT_DIR, ".tmp-hotel-covers");
  mkdirSync(tmpDir, { recursive: true });
  const outPath = join(tmpDir, `${basename(localPath, extname(localPath))}${targetExt}`);
  const format = targetExt === ".png" ? "png" : "jpeg";
  const args = ["-Z", String(MAX_DIMENSION), "-s", "format", format];
  if (format === "jpeg") args.push("-s", "formatOptions", "85");
  execFileSync("sips", [...args, localPath, "--out", outPath], { stdio: "pipe" });
  return {
    outPath,
    cleanup: () => {
      try {
        unlinkSync(outPath);
      } catch {}
    },
  };
}

function maybeCompressForUpload(localPath, targetExt) {
  const size = statSync(localPath).size;
  if (size <= MAX_UPLOAD_BYTES) return { uploadPath: localPath, compressed: false, cleanup: () => {} };

  const tmpDir = join(OUT_DIR, ".tmp-hotel-covers");
  mkdirSync(tmpDir, { recursive: true });
  const ext = targetExt || extname(localPath).toLowerCase() || ".jpg";
  const outPath = join(tmpDir, `${basename(localPath, extname(localPath))}-compressed${ext}`);
  const format = ext === ".png" ? "png" : "jpeg";
  const args = ["-Z", String(MAX_DIMENSION), "-s", "format", format];
  if (format === "jpeg") args.push("-s", "formatOptions", "85");
  execFileSync("sips", [...args, localPath, "--out", outPath], { stdio: "pipe" });
  return {
    uploadPath: outPath,
    compressed: true,
    cleanup: () => {
      try {
        unlinkSync(outPath);
      } catch {}
    },
  };
}

function prepareUploadFile(localPath, targetExt) {
  const ext = extname(localPath).toLowerCase();
  if (ext === ".heic" || ext === ".heif") {
    const converted = convertHeicTo(localPath, targetExt);
    return { uploadPath: converted.outPath, heicConverted: true, compressed: true, cleanup: converted.cleanup };
  }
  const compressed = maybeCompressForUpload(localPath, targetExt);
  return {
    uploadPath: compressed.uploadPath,
    heicConverted: false,
    compressed: compressed.compressed,
    cleanup: compressed.cleanup,
  };
}

async function rest(path, init = {}) {
  const { url, key } = getSupabaseConfig();
  const res = await fetch(`${url}${path}`, {
    ...init,
    headers: { apikey: key, Authorization: `Bearer ${key}`, ...(init.headers || {}) },
  });
  if (!res.ok) throw new Error(`${path} -> ${res.status} ${await res.text()}`);
  return res;
}

async function uploadCover(storagePath, localPath) {
  const body = readFileSync(localPath);
  const ext = extname(storagePath).toLowerCase();
  await rest(`/storage/v1/object/${COVER_BUCKET}/${storagePath}`, {
    method: "POST",
    headers: { "x-upsert": "true", "content-type": contentTypeForExt(ext) },
    body,
  });
}

async function patchHotelCover(hotelId, relativePath) {
  await rest(`/rest/v1/hotels?id=eq.${encodeURIComponent(hotelId)}`, {
    method: "PATCH",
    headers: { "Content-Type": "application/json", Prefer: "return=minimal" },
    body: JSON.stringify({ cover_image_path: relativePath, updated_at: new Date().toISOString() }),
  });
}

function buildTierMaps() {
  const byCity = {};
  for (const source of CITY_SOURCES) {
    const result = processCity(source);
    byCity[source.cityId] = {
      byTier: new Map(result.imported.map((h) => [h.tierCode, h])),
      byChineseNorm: new Map(result.imported.map((h) => [norm(h.chineseName), h])),
      hotels: result.imported,
    };
  }
  return byCity;
}

function chineseLabelFromStem(stem) {
  const withoutTier = stem.replace(/^[A-Z]\d+-\d+[｜|]?/, "");
  return withoutTier.trim() || stem;
}

function findHotel(stem, cityId, tierMaps) {
  const city = tierMaps[cityId];
  if (!city) return null;

  const aliasTier = STEM_TIER_ALIASES[stem] || STEM_TIER_ALIASES[chineseLabelFromStem(stem)];
  if (aliasTier) {
    const hit = city.byTier.get(aliasTier);
    if (hit) return { hotel: hit, matchBy: `alias:${aliasTier}` };
  }

  const tier = parseTierFromStem(stem);
  if (tier) {
    const hit = city.byTier.get(tier);
    if (hit) return { hotel: hit, matchBy: `tier:${tier}` };
  }

  const label = chineseLabelFromStem(stem);
  const exact = city.byChineseNorm.get(norm(label));
  if (exact) return { hotel: exact, matchBy: "chinese:exact" };

  const nLabel = norm(label);
  const contains = city.hotels.filter((h) => {
    const n = norm(h.chineseName);
    return n.includes(nLabel) || nLabel.includes(n);
  });
  if (contains.length === 1) return { hotel: contains[0], matchBy: "chinese:contains" };
  if (contains.length > 1) {
    const best = contains.sort((a, b) => norm(a.chineseName).length - norm(b.chineseName).length)[0];
    return { hotel: best, matchBy: "chinese:contains-best" };
  }

  return null;
}

function listImageFiles(dir) {
  return readdirSync(dir).filter((n) => /\.(png|jpg|jpeg|webp|heic|heif)$/i.test(n));
}

function resolveStoragePath(hotelId, existingCoverPath) {
  const parsed = parseCoverPath(existingCoverPath);
  if (parsed && parsed.startsWith("hotels/")) return parsed;
  return `hotels/${hotelId}.jpg`;
}

async function main() {
  mkdirSync(OUT_DIR, { recursive: true });
  const tierMaps = buildTierMaps();

  const dbHotels = await (
    await rest("/rest/v1/hotels?select=id,city_id,chinese_name,cover_image_path")
  ).json();
  const coverById = new Map(dbHotels.map((h) => [h.id, h.cover_image_path || ""]));

  const report = {
    generatedAt: new Date().toISOString(),
    mode: dryRun ? "dry-run" : "apply",
    sourceDir: SOURCE_DIR,
    stats: {
      totalFiles: 0,
      matched: 0,
      uploaded: 0,
      dbUpdated: 0,
      heicConverted: 0,
      compressed: 0,
      unmatched: 0,
      duplicateHotel: 0,
    },
    items: [],
    unmatched: [],
  };

  const seenHotelIds = new Set();

  for (const folder of readdirSync(SOURCE_DIR).sort()) {
    const cityPath = join(SOURCE_DIR, folder);
    if (!statSync(cityPath).isDirectory()) continue;
    const cityId = CITY_FOLDER_TO_ID[folder];
    if (!cityId) {
      report.unmatched.push({ folder, reason: "unknown city folder" });
      continue;
    }

    for (const file of listImageFiles(cityPath).sort()) {
      report.stats.totalFiles += 1;
      const localPath = join(cityPath, file);
      const stem = basename(file, extname(file));
      const match = findHotel(stem, cityId, tierMaps);

      if (!match) {
        report.stats.unmatched += 1;
        report.unmatched.push({ city: folder, file, stem });
        continue;
      }

      const { hotel, matchBy } = match;
      if (seenHotelIds.has(hotel.id)) {
        report.stats.duplicateHotel += 1;
        report.unmatched.push({ city: folder, file, stem, reason: `duplicate for ${hotel.id}` });
        continue;
      }
      seenHotelIds.add(hotel.id);

      const existingCover = coverById.get(hotel.id) || "";
      let storagePath = resolveStoragePath(hotel.id, existingCover);
      let targetExt = extname(storagePath).toLowerCase() || ".jpg";
      let prepared = prepareUploadFile(localPath, targetExt);

      if (statSync(prepared.uploadPath).size > MAX_UPLOAD_BYTES && targetExt === ".png") {
        prepared.cleanup();
        targetExt = ".jpg";
        prepared = prepareUploadFile(localPath, targetExt);
      }

      const finalStoragePath =
        targetExt === extname(storagePath).toLowerCase()
          ? storagePath
          : `hotels/${hotel.id}${targetExt}`;
      const relativePath = finalStoragePath.replace(/^\/+/, "");

      report.stats.matched += 1;
      const item = {
        city: folder,
        file,
        stem,
        matchBy,
        hotelId: hotel.id,
        chineseName: hotel.chineseName,
        tierCode: hotel.tierCode,
        storagePath: finalStoragePath,
        relativePath,
        previousCoverPath: existingCover,
      };

      if (dryRun) {
        report.items.push({ ...item, uploaded: false, dbUpdated: false });
        continue;
      }

      try {
        await uploadCover(finalStoragePath, prepared.uploadPath);
        report.stats.uploaded += 1;
        if (prepared.heicConverted) report.stats.heicConverted += 1;
        if (prepared.compressed) report.stats.compressed += 1;

        await patchHotelCover(hotel.id, relativePath);
        report.stats.dbUpdated += 1;
        report.items.push({ ...item, uploaded: true, dbUpdated: true, heicConverted: prepared.heicConverted, compressed: prepared.compressed });
      } finally {
        prepared.cleanup();
      }
    }
  }

  writeFileSync(OUT_REPORT, JSON.stringify(report, null, 2), "utf8");
  console.log(`report: ${OUT_REPORT}`);
  console.log(JSON.stringify(report.stats, null, 2));
  if (report.unmatched.length) console.log("unmatched:", JSON.stringify(report.unmatched, null, 2));
}

main().catch((err) => {
  console.error(err.message);
  process.exit(1);
});
