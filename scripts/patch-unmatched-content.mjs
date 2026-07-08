#!/usr/bin/env node
import { createClient } from "@supabase/supabase-js";
import { mkdirSync, readFileSync, readdirSync, statSync, writeFileSync } from "fs";
import { basename, extname, join } from "path";
import { tmpdir } from "os";
import { execSync } from "child_process";

const ROOT = "/Users/vesperal/Desktop/YOLO";
const SOURCE_BACKEND = "/Users/vesperal/Downloads/后台填写信息汇总（照片+文字信息）";
const SOURCE_BENEDICT = "/Users/vesperal/Downloads/全量英文解说音频_Benedict";
const SOURCE_PHRASES = "/Users/vesperal/Downloads/04_常用语/通用普通话音频_Cherry";
const OUT_DIR = join(ROOT, "scripts/generated");
const BASE_REPORT = join(OUT_DIR, "all_content_patch_unmatched_v2_report.json");
const OUT_SQL = join(OUT_DIR, "all_content_patch_unmatched_v3.sql");
const OUT_REPORT = join(OUT_DIR, "all_content_patch_unmatched_v3_report.json");
const AUDIO_BUCKET = "audio-guides";
const COVER_BUCKET = "cover-images";

const ATTRACTION_ALIASES = {
  国家博物馆: "国博",
  成都博物院: "成都博物馆",
  成都熊猫基地: "大熊猫基地",
  苏州十二国色: "苏州河",
  南京大屠杀纪念馆: "侵华日军南京大屠杀遇难同胞纪念馆",
  南京老门东: "老门东历史文化街区",
  xujiahui_source_scenic_area: "徐家汇源",
  zhujiajiao_ancient_town: "朱家角古镇",
  chongqing_hongya_cave: "洪崖洞民俗风貌区",
  chongqing_ciqikou_old_town: "磁器口古镇",
  chongqing_jiefangbei: "解放碑-八一好吃街",
};

const FIXED_IMAGE_DIR_BY_PREFIX = {
  zhujiajiao_ancient_town: "/Users/vesperal/Downloads/后台填写信息汇总（照片+文字信息）/上海子景点/朱家角古镇",
  chongqing_hongya_cave: "/Users/vesperal/Downloads/后台填写信息汇总（照片+文字信息）/重庆子景点/重庆洪崖洞民俗风貌区",
  chongqing_ciqikou_old_town: "/Users/vesperal/Downloads/后台填写信息汇总（照片+文字信息）/重庆子景点/磁器口",
  chongqing_jiefangbei: "/Users/vesperal/Downloads/后台填写信息汇总（照片+文字信息）/重庆子景点/解放碑广场",
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
  const key = process.env.SUPABASE_SERVICE_ROLE_KEY || process.env.SUPABASE_ANON_KEY || readXcconfigValue(xcPath, "SUPABASE_ANON_KEY");
  if (!url || !key) throw new Error("缺少 SUPABASE_URL 或 key");
  return { url, key };
}

function sqlStr(value) {
  if (value == null) return "NULL";
  return `'${String(value).replace(/'/g, "''")}'`;
}

function onlyDirs(path) {
  return readdirSync(path).filter((n) => statSync(join(path, n)).isDirectory());
}

function parseSeqFromName(name) {
  const stem = basename(name, extname(name)).trim();
  const m = stem.match(/^([0-9]{1,3})(?:[-_.].*)?$/);
  if (!m) return null;
  return Number(m[1]);
}

async function uploadFile(supabase, bucket, storagePath, localPath) {
  const body = readFileSync(localPath);
  const ext = extname(localPath).toLowerCase();
  const contentType = ext === ".mp3" ? "audio/mpeg" : ext === ".png" ? "image/png" : "image/jpeg";
  const { error } = await supabase.storage.from(bucket).upload(storagePath, body, { upsert: true, contentType });
  if (error) throw new Error(`${storagePath}: ${error.message}`);
  const { data } = supabase.storage.from(bucket).getPublicUrl(storagePath);
  return data.publicUrl;
}

function normalizeText(s) {
  return String(s || "")
    .replace(/^[0-9]+\s*[.、_-]?\s*/g, "")
    .replace(/[（）()·\s"'“”‘’、，。.\-]/g, "")
    .toLowerCase();
}

function findAttraction(attractions, rawName) {
  const mapped = ATTRACTION_ALIASES[rawName] || rawName;
  return (
    attractions.find((a) => String(a.chinese_name || "").trim() === mapped) ||
    attractions.find((a) => String(a.chinese_name || "").includes(mapped) || mapped.includes(String(a.chinese_name || "")))
  );
}

function resolveCommonPhraseAudio(index) {
  const key = String(index).padStart(2, "0");
  const files = readdirSync(SOURCE_PHRASES).filter((n) => n.toLowerCase().endsWith(".mp3"));
  const exact = files.find((n) => n.startsWith(`${key}_`) || n.startsWith(`${key}-`));
  return exact ? join(SOURCE_PHRASES, exact) : null;
}

function compactImageIfOversize(filePath) {
  const maxBytes = 10 * 1024 * 1024 - 1024;
  const st = statSync(filePath, { throwIfNoEntry: false });
  if (!st || !st.isFile() || st.size <= maxBytes) return filePath;
  const out = join(tmpdir(), `compressed_${Date.now()}_${basename(filePath, extname(filePath))}.jpg`);
  execSync(`sips -Z 2800 --setProperty format jpeg "${filePath}" --out "${out}"`, { stdio: "ignore" });
  const outSt = statSync(out, { throwIfNoEntry: false });
  if (outSt && outSt.isFile() && outSt.size <= maxBytes) return out;
  execSync(`sips -Z 2200 --setProperty format jpeg "${filePath}" --out "${out}"`, { stdio: "ignore" });
  return out;
}

function parseBackendImageCandidates() {
  const index = new Map();
  for (const cityDir of onlyDirs(SOURCE_BACKEND)) {
    const cityPath = join(SOURCE_BACKEND, cityDir);
    for (const attDir of onlyDirs(cityPath)) {
      if (attDir.includes("信息")) continue;
      const fullDir = join(cityPath, attDir);
      const files = readdirSync(fullDir).filter((n) => [".png", ".jpg", ".jpeg", ".JPG"].includes(extname(n)));
      if (!files.length) continue;
      const key = normalizeText(attDir);
      index.set(key, {
        dir: fullDir,
        files,
      });
    }
  }
  return index;
}

async function main() {
  mkdirSync(OUT_DIR, { recursive: true });
  const base = JSON.parse(readFileSync(BASE_REPORT, "utf8"));
  const { url, key } = getSupabaseConfig();
  const supabase = createClient(url, key);
  const { data: attractions, error } = await supabase.from("attractions").select("id,chinese_name");
  if (error) throw new Error(error.message);

  const patchReport = {
    basedOn: BASE_REPORT,
    generatedAt: new Date().toISOString(),
    patched: { attractions: [], images: [], audios: [] },
    stillUnmatched: { attractions: [], images: [], audios: [] },
    confirmedEmptyAudio: [],
  };
  const sqlBlocks = ["-- unmatched patch only"];
  const imageCandidateIndex = parseBackendImageCandidates();

  // A) Patch unmatched attractions -> sub_area audio updates
  for (const item of base.stillUnmatched?.attractions || []) {
    if (!item.startsWith("audio:")) continue;
    const [, cityScenic] = item.split("audio:");
    const [city, scenicRaw] = cityScenic.split("/");
    const parent = findAttraction(attractions, scenicRaw);
    if (!parent) {
      patchReport.stillUnmatched.attractions.push(item);
      continue;
    }
    patchReport.patched.attractions.push(`${item}=>${parent.chinese_name}`);
    const scenicDir = join(SOURCE_BENEDICT, city, scenicRaw);
    if (!statSync(scenicDir, { throwIfNoEntry: false })?.isDirectory?.()) {
      patchReport.stillUnmatched.audios.push(`missingDir:${scenicDir}`);
      continue;
    }
    const files = readdirSync(scenicDir).filter((n) => n.toLowerCase().endsWith(".mp3"));
    for (const f of files) {
      const m = f.match(/_([0-9]{1,3})\./);
      if (!m) continue;
      const seq = Number(m[1]);
      const local = join(scenicDir, f);
      const url = await uploadFile(supabase, AUDIO_BUCKET, `sub-areas/${parent.id}_${String(seq).padStart(3, "0")}.mp3`, local);
      sqlBlocks.push(`UPDATE sub_areas SET audio_url=${sqlStr(url)}, updated_at=NOW() WHERE attraction_id=${sqlStr(parent.id)} AND sort_order=${seq - 1};`);
      patchReport.patched.audios.push(`audio:${parent.id}:${seq}`);
    }
  }

  // B) Patch unmatched common phrase audio
  for (const item of base.stillUnmatched?.audios || []) {
    if (!item.startsWith("common:")) {
      patchReport.stillUnmatched.audios.push(item);
      continue;
    }
    const [, id] = item.split(":");
    sqlBlocks.push(`UPDATE common_phrases SET audio_url='', updated_at=NOW() WHERE id=${sqlStr(id)};`);
    patchReport.confirmedEmptyAudio.push(id);
  }

  // C) Patch unmatched backend image by querying existing sub_area id
  for (const item of base.stillUnmatched?.images || []) {
    if (item.startsWith("oversize:")) {
      const [, id, rawFile] = item.split(":");
      const { data: subArea } = await supabase
        .from("sub_areas")
        .select("id,attraction_id")
        .eq("id", id)
        .maybeSingle();
      if (!subArea) {
        patchReport.stillUnmatched.images.push(item);
        continue;
      }
      const parent = attractions.find((a) => a.id === subArea.attraction_id);
      const mappedName = parent?.chinese_name || "";
      let src = null;
      const key = normalizeText(mappedName);
      const bucket = imageCandidateIndex.get(key);
      if (bucket) {
        const hit = bucket.files.find((f) => f.includes(rawFile) || f.includes("萃秀堂"));
        if (hit) src = join(bucket.dir, hit);
      }
      if (!src) {
        patchReport.stillUnmatched.images.push(item);
        continue;
      }
      try {
        const compressed = compactImageIfOversize(src);
        const url = await uploadFile(supabase, COVER_BUCKET, `sub-areas/patch-v3/${id}.jpg`, compressed);
        sqlBlocks.push(`UPDATE sub_areas SET cover_image_path=${sqlStr(url)}, updated_at=NOW() WHERE id=${sqlStr(id)};`);
        patchReport.patched.images.push(id);
      } catch (e) {
        patchReport.stillUnmatched.images.push(`${item}:${String(e.message)}`);
      }
      continue;
    }
    if (!item.startsWith("backend:")) {
      patchReport.stillUnmatched.images.push(item);
      continue;
    }
    const id = item.replace("backend:", "");
    if (id.startsWith("zhujiajiao_ancient_town_")) {
      patchReport.stillUnmatched.images.push(item);
      continue;
    }
    const { data: subArea, error: saErr } = await supabase
      .from("sub_areas")
      .select("id,attraction_id,name_zh,sort_order")
      .eq("id", id)
      .maybeSingle();
    if (saErr || !subArea) {
      patchReport.stillUnmatched.images.push(item);
      continue;
    }
    const parent = attractions.find((a) => a.id === subArea.attraction_id);
    if (!parent) {
      patchReport.stillUnmatched.images.push(item);
      continue;
    }

    // Search candidate image by fixed mapped directory first.
    let matched = null;
    const idPrefix = id.replace(/_sa_\d+$/, "");
    const fixedDir = FIXED_IMAGE_DIR_BY_PREFIX[idPrefix];
    if (fixedDir && statSync(fixedDir, { throwIfNoEntry: false })?.isDirectory?.()) {
      const files = readdirSync(fixedDir).filter((n) => [".png", ".jpg", ".jpeg", ".JPG"].includes(extname(n)));
      const targetSeq = parseSeqFromName(subArea.name_zh) || (Number(subArea.sort_order) + 1);
      const bySeq = files.find((f) => parseSeqFromName(basename(f, extname(f))) === targetSeq);
      const targetName = normalizeText(subArea.name_zh);
      const byName = files.find((f) => {
        const n = normalizeText(basename(f, extname(f)));
        return n.includes(targetName) || targetName.includes(n);
      });
      const picked = bySeq || byName || files[subArea.sort_order];
      if (picked) matched = join(fixedDir, picked);
    } else {
      const mappedZh = ATTRACTION_ALIASES[idPrefix] || parent.chinese_name;
      const candidateKeys = Array.from(new Set([normalizeText(mappedZh), normalizeText(parent.chinese_name), normalizeText(idPrefix)]));
      for (const k of candidateKeys) {
        const bucket = imageCandidateIndex.get(k);
        if (!bucket) continue;
        const files = bucket.files;
        const bySeq = files.find((f) => parseSeqFromName(basename(f, extname(f))) === Number(subArea.sort_order) + 1);
        const byName = files.find((f) => {
          const n = normalizeText(basename(f, extname(f)));
          const t = normalizeText(subArea.name_zh);
          return n.includes(t) || t.includes(n);
        });
        const picked = bySeq || byName || files[subArea.sort_order];
        if (picked) matched = join(bucket.dir, picked);
        if (matched) break;
      }
    }
    if (!matched) {
      patchReport.stillUnmatched.images.push(item);
      continue;
    }
    try {
      const src = compactImageIfOversize(matched);
      const ext = extname(src).toLowerCase().replace(".", "") || "jpg";
      const url = await uploadFile(supabase, COVER_BUCKET, `sub-areas/patch-v3/${id}.${ext}`, src);
      sqlBlocks.push(`UPDATE sub_areas SET cover_image_path=${sqlStr(url)}, updated_at=NOW() WHERE id=${sqlStr(id)};`);
      patchReport.patched.images.push(id);
    } catch (e) {
      patchReport.stillUnmatched.images.push(`${item}:${String(e.message)}`);
    }
  }

  writeFileSync(OUT_SQL, `${sqlBlocks.join("\n")}\n`, "utf8");
  writeFileSync(OUT_REPORT, JSON.stringify(patchReport, null, 2), "utf8");
  console.log(`sql: ${OUT_SQL}`);
  console.log(`report: ${OUT_REPORT}`);
  console.log(
    `patched: attractions=${patchReport.patched.attractions.length}, images=${patchReport.patched.images.length}, audios=${patchReport.patched.audios.length}`
  );
}

main().catch((err) => {
  console.error(err.message);
  process.exit(1);
});
