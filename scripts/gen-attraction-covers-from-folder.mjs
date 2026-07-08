#!/usr/bin/env node
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

const ROOT = "/Users/vesperal/Desktop/YOLO";
const SOURCE_DIR = "/Users/vesperal/Downloads/需要修改的图 2";
const CONFIG_PATH = join(ROOT, "scripts/city-attractions-config.json");
const OUT_DIR = join(ROOT, "scripts/generated");
const OUT_SQL = join(OUT_DIR, "attractions_cover_update.sql");
const OUT_REPORT = join(OUT_DIR, "attractions_cover_update_report.json");
const COVER_BUCKET = "cover-images";

const CITY_FOLDER_TO_ID = {
  北京: "beijing",
  南京: "nanjing",
  苏州: "suzhou",
  重庆: "chongqing",
};

const FILE_STEM_ALIASES = {
  南京中山陵: "南京中山陵景区",
  南京遇难同胞纪念馆: "侵华日军南京大屠杀遇难同胞纪念馆",
  老门东: "老门东历史文化街区",
  老东门: "老门东历史文化街区",
  藕园: "耦园",
  留园: "留园景区",
};

function readXcconfigValue(path, key) {
  const text = readFileSync(path, "utf8");
  const line = text.split(/\r?\n/).find((it) => it.trim().startsWith(`${key} =`));
  if (!line) return "";
  return line.split("=").slice(1).join("=").replace(/\$\(\)/g, "").trim();
}

function getSupabaseConfig() {
  const xcPath = join(ROOT, "Secrets.xcconfig");
  const url = process.env.SUPABASE_URL || readXcconfigValue(xcPath, "SUPABASE_URL");
  const key =
    process.env.SUPABASE_SERVICE_ROLE_KEY ||
    process.env.SUPABASE_ANON_KEY ||
    readXcconfigValue(xcPath, "SUPABASE_ANON_KEY");
  if (!url || !key) throw new Error("缺少 SUPABASE_URL 或 key");
  return { url, key };
}

function sqlStr(value) {
  if (value == null) return "NULL";
  return `'${String(value).replace(/'/g, "''")}'`;
}

function norm(s) {
  return String(s || "")
    .replace(/\s+/g, "")
    .replace(/[：:·•，,。.!！?？、“”"'()（）\-—_]/g, "")
    .toLowerCase();
}

function buildFilenameLookup(config) {
  const byFilename = new Map();
  const reverseAliases = new Map();
  for (const [md, png] of Object.entries(config.png_aliases || {})) {
    reverseAliases.set(norm(png), md);
  }
  for (const [stem, md] of Object.entries(FILE_STEM_ALIASES)) {
    reverseAliases.set(norm(stem), md);
  }

  for (const item of config.attractions || []) {
    const md = item.md;
    byFilename.set(norm(md), item);
    const alias = config.png_aliases?.[md];
    if (alias) byFilename.set(norm(alias), item);
  }
  for (const [filenameNorm, md] of reverseAliases.entries()) {
    const item = (config.attractions || []).find((a) => a.md === md);
    if (item) byFilename.set(filenameNorm, item);
  }
  return byFilename;
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
  if (e === ".heic") return "image/heic";
  return "image/jpeg";
}

const MAX_UPLOAD_BYTES = 5 * 1024 * 1024;
const MAX_DIMENSION = 2048;

function convertHeicTo(localPath, targetExt) {
  const tmpDir = join(OUT_DIR, ".tmp-heic");
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

  const tmpDir = join(OUT_DIR, ".tmp-heic");
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

function resolveStoragePath(attractionId, existingCoverPath) {
  const parsed = parseCoverPath(existingCoverPath);
  if (parsed && parsed.startsWith("attractions/")) return parsed;
  return `attractions/${attractionId}.png`;
}

function resolveRelativeCoverPath(storagePath) {
  return storagePath.replace(/^\/+/, "");
}

function findAttraction(stem, cityId, filenameLookup, attractions) {
  const aliasMd = FILE_STEM_ALIASES[stem];
  if (aliasMd) {
    const fromAlias = attractions.find((a) => a.chinese_name === aliasMd && a.city_id === cityId);
    if (fromAlias) return fromAlias;
  }

  const fromLookup = filenameLookup.get(norm(stem));
  if (fromLookup) {
    const hit = attractions.find((a) => a.id === fromLookup.id);
    if (hit) return hit;
  }

  const cityAttractions = attractions.filter((a) => a.city_id === cityId);
  const nStem = norm(stem);
  const exact = cityAttractions.find((a) => norm(a.chinese_name) === nStem);
  if (exact) return exact;

  const contains = cityAttractions.filter(
    (a) => norm(a.chinese_name).includes(nStem) || nStem.includes(norm(a.chinese_name))
  );
  if (contains.length === 1) return contains[0];
  if (contains.length > 1) {
    const best = contains.sort(
      (a, b) => norm(a.chinese_name).length - norm(b.chinese_name).length
    )[0];
    return best;
  }
  return null;
}

function listImageFiles(dir) {
  return readdirSync(dir).filter((n) => /\.(png|jpg|jpeg|webp|heic|heif)$/i.test(n));
}

async function main() {
  mkdirSync(OUT_DIR, { recursive: true });
  const config = JSON.parse(readFileSync(CONFIG_PATH, "utf8"));
  const filenameLookup = buildFilenameLookup(config);

  const attractions = await (
    await rest("/rest/v1/attractions?select=id,city_id,chinese_name,cover_image_path")
  ).json();

  const report = {
    generatedAt: new Date().toISOString(),
    sourceDir: SOURCE_DIR,
    stats: {
      totalFiles: 0,
      matched: 0,
      uploaded: 0,
      reusedPath: 0,
      heicConverted: 0,
      compressed: 0,
      unmatched: 0,
      sqlUpdates: 0,
    },
    items: [],
    unmatched: [],
  };

  const sqlBlocks = ["-- Generated attraction cover updates (relative paths, reuse existing storage keys)"];
  const seenIds = new Set();

  for (const cityFolder of readdirSync(SOURCE_DIR).sort()) {
    const cityPath = join(SOURCE_DIR, cityFolder);
    if (!statSync(cityPath).isDirectory()) continue;
    const cityId = CITY_FOLDER_TO_ID[cityFolder];
    if (!cityId) {
      report.unmatched.push({ file: cityFolder, reason: "unknown city folder" });
      continue;
    }

    for (const file of listImageFiles(cityPath).sort()) {
      report.stats.totalFiles += 1;
      const localPath = join(cityPath, file);
      const stem = basename(file, extname(file));
      const attraction = findAttraction(stem, cityId, filenameLookup, attractions);

      if (!attraction) {
        report.stats.unmatched += 1;
        report.unmatched.push({ city: cityFolder, file, stem });
        continue;
      }

      if (seenIds.has(attraction.id)) {
        report.unmatched.push({ city: cityFolder, file, stem, reason: `duplicate for ${attraction.id}` });
        continue;
      }
      seenIds.add(attraction.id);

      const storagePath = resolveStoragePath(attraction.id, attraction.cover_image_path);
      let targetExt = extname(storagePath).toLowerCase() || ".png";
      let prepared = prepareUploadFile(localPath, targetExt);

      if (statSync(prepared.uploadPath).size > MAX_UPLOAD_BYTES && targetExt === ".png") {
        prepared.cleanup();
        targetExt = ".jpg";
        prepared = prepareUploadFile(localPath, targetExt);
      }

      const finalStoragePath =
        targetExt === extname(storagePath).toLowerCase()
          ? storagePath
          : `attractions/${attraction.id}${targetExt}`;
      const relativePath = resolveRelativeCoverPath(finalStoragePath);

      try {
        await uploadCover(finalStoragePath, prepared.uploadPath);
        report.stats.uploaded += 1;
        if (prepared.heicConverted) report.stats.heicConverted += 1;
        if (prepared.compressed) report.stats.compressed += 1;
        if (attraction.cover_image_path && parseCoverPath(attraction.cover_image_path) === finalStoragePath) {
          report.stats.reusedPath += 1;
        }

        sqlBlocks.push(
          `UPDATE attractions\nSET cover_image_path = ${sqlStr(relativePath)},\n    cover_images = ARRAY[${sqlStr(relativePath)}]::text[],\n    updated_at = NOW()\nWHERE id = ${sqlStr(attraction.id)};`
        );
        report.stats.sqlUpdates += 1;
        report.stats.matched += 1;
        report.items.push({
          city: cityFolder,
          file,
          stem,
          attractionId: attraction.id,
          chineseName: attraction.chinese_name,
          storagePath: finalStoragePath,
          relativePath,
          previousCoverPath: attraction.cover_image_path || "",
          heicConverted: prepared.heicConverted,
          compressed: prepared.compressed,
          reusedPath: Boolean(
            attraction.cover_image_path && parseCoverPath(attraction.cover_image_path) === finalStoragePath
          ),
        });
      } finally {
        prepared.cleanup();
      }
    }
  }

  writeFileSync(OUT_SQL, `${sqlBlocks.join("\n\n")}\n`, "utf8");
  writeFileSync(OUT_REPORT, JSON.stringify(report, null, 2), "utf8");

  console.log(`sql: ${OUT_SQL}`);
  console.log(`report: ${OUT_REPORT}`);
  console.log(JSON.stringify(report.stats, null, 2));
  if (report.unmatched.length) {
    console.log("unmatched:", report.unmatched);
  }
}

main().catch((err) => {
  console.error(err.message);
  process.exit(1);
});
