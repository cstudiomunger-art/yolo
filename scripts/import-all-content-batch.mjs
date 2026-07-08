#!/usr/bin/env node
import { createClient } from "@supabase/supabase-js";
import { mkdirSync, readFileSync, readdirSync, statSync, writeFileSync } from "fs";
import { basename, extname, join } from "path";

const ROOT = "/Users/vesperal/Desktop/YOLO";
const SOURCE_BEIJING = "/Users/vesperal/Desktop/北京子景点内容";
const SOURCE_BACKEND = "/Users/vesperal/Downloads/后台填写信息汇总（照片+文字信息）";
const SOURCE_PHRASES = "/Users/vesperal/Downloads/04_常用语";
const SOURCE_BENEDICT = "/Users/vesperal/Downloads/全量英文解说音频_Benedict";

const OUT_DIR = join(ROOT, "scripts/generated");
const OUT_SQL = join(OUT_DIR, "all_content_upsert.sql");
const OUT_REPORT = join(OUT_DIR, "all_content_report.json");

const COVER_BUCKET = "cover-images";
const AUDIO_BUCKET = "audio-guides";

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
  return { url, key, usesServiceRole: Boolean(process.env.SUPABASE_SERVICE_ROLE_KEY) };
}

function sqlStr(value) {
  if (value == null) return "NULL";
  return `'${String(value).replace(/'/g, "''")}'`;
}

function toSafeSlug(text) {
  return String(text || "")
    .toLowerCase()
    .normalize("NFD")
    .replace(/[̀-ͯ]/g, "")
    .replace(/[^a-z0-9]+/g, "_")
    .replace(/^_+|_+$/g, "");
}

function parseSeqFromName(name) {
  const stem = basename(name, extname(name)).trim();
  const m = stem.match(/^([0-9]{1,2}(?:[-_.][0-9]{1,2})?)/);
  if (!m) return "";
  return m[1]
    .replace(/[_.]/g, "-")
    .split("-")
    .map((p) => String(parseInt(p, 10)))
    .join("-");
}

function onlyDirs(path) {
  return readdirSync(path).filter((n) => statSync(join(path, n)).isDirectory());
}

function resolvePhraseAudioByIndex(dirPath, preferredFile, index) {
  const preferred = join(dirPath, preferredFile || "");
  if (preferredFile) {
    try {
      if (statSync(preferred).isFile()) return preferred;
    } catch {}
  }
  const files = readdirSync(dirPath).filter((n) => n.toLowerCase().endsWith(".mp3"));
  const key = String(index).padStart(2, "0");
  const byPrefix = files.find((n) => n.startsWith(`${key}_`) || n.startsWith(`${key}-`));
  if (byPrefix) return join(dirPath, byPrefix);
  return null;
}

function extractEnglishLongDescriptionMixed(line) {
  const marker = "长文描述 / Description";
  const idx = line.indexOf(marker);
  if (idx < 0) return "";
  const after = line.slice(idx + marker.length).replace(/^[:：*\s-]+/, "").trim();
  const match = after.match(/[A-Za-z][\s\S]*$/);
  return (match ? match[0] : "").trim();
}

function toHtmlParagraphs(text) {
  const normalized = String(text || "")
    .replace(/\*\*/g, "")
    .replace(/\*/g, "")
    .replace(/`/g, "")
    .replace(/\s+/g, " ");
  const safe = normalized
    .trim()
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;");
  if (!safe) return "";
  return safe
    .split(/\n{2,}/)
    .map((p) => `<p>${p.replace(/\n/g, "<br>")}</p>`)
    .join("");
}

function parseBeijingSections(mdText) {
  const lines = mdText.split(/\r?\n/);
  const sections = [];
  let cur = null;
  for (const line of lines) {
    const m = line.match(/^###\s*([0-9]{1,2}(?:[-_.][0-9]{1,2})?)\s*[.、\-_)\s]*\s*(.+)\s*$/);
    if (m) {
      if (cur) sections.push(cur);
      cur = { seq: parseSeqFromName(m[1]), title: m[2].trim(), englishLong: "", order: sections.length };
      continue;
    }
    if (cur && line.includes("长文描述 / Description")) {
      cur.englishLong = extractEnglishLongDescriptionMixed(line);
    }
  }
  if (cur) sections.push(cur);
  return sections;
}

function parseBackendMarkdown(mdText) {
  const sections = {};
  const parts = mdText.split(/\n##\s+/);
  const first = parts.shift() || "";
  if (first.startsWith("# ")) sections.title = first.replace(/^#\s*/, "").trim();
  for (const raw of parts) {
    const idx = raw.indexOf("\n");
    const header = (idx >= 0 ? raw.slice(0, idx) : raw).trim();
    const body = (idx >= 0 ? raw.slice(idx + 1) : "").trim();
    sections[header] = body;
  }
  const detailKey = Object.keys(sections).find((k) => k.includes("长文描述"));
  const nameKey = Object.keys(sections).find((k) => k.includes("名字"));
  let nameZh = "";
  let nameEn = "";
  if (nameKey) {
    const ls = sections[nameKey].split(/\r?\n/).map((x) => x.trim()).filter(Boolean);
    nameZh = ls[0] || "";
    nameEn = ls.find((x) => /[A-Za-z]/.test(x)) || "";
  }
  let englishLong = "";
  if (detailKey) {
    const ls = sections[detailKey].split(/\r?\n/).map((x) => x.trim()).filter(Boolean);
    englishLong = ls.filter((x) => /[A-Za-z]/.test(x)).join(" ");
  }
  return { nameZh, nameEn, englishLong };
}

async function uploadFile(supabase, bucket, storagePath, localPath) {
  const body = readFileSync(localPath);
  const ext = extname(localPath).toLowerCase();
  const contentType =
    ext === ".png" ? "image/png" : ext === ".webp" ? "image/webp" : ext === ".m4a" ? "audio/mp4" : ext === ".wav" ? "audio/wav" : ext === ".mp3" ? "audio/mpeg" : "image/jpeg";
  const { error } = await supabase.storage.from(bucket).upload(storagePath, body, { upsert: true, contentType });
  if (error) throw new Error(`${storagePath}: ${error.message}`);
  const { data } = supabase.storage.from(bucket).getPublicUrl(storagePath);
  return data.publicUrl;
}

function isObjectTooLargeError(err) {
  return /exceeded the maximum allowed size/i.test(String(err?.message || err || ""));
}

async function main() {
  const { url, key, usesServiceRole } = getSupabaseConfig();
  const supabase = createClient(url, key);
  mkdirSync(OUT_DIR, { recursive: true });

  const { data: attractions, error: attErr } = await supabase.from("attractions").select("id,chinese_name");
  if (attErr) throw new Error(`读取 attractions 失败: ${attErr.message}`);
  const attMap = new Map(attractions.map((a) => [String(a.chinese_name || "").trim(), a]));

  const report = {
    generatedAt: new Date().toISOString(),
    usesServiceRole,
    totals: { subAreas: 0, commonPhrases: 0, dialectPhrases: 0, subAreaAudios: 0 },
    unmatched: { attractions: [], images: [], audios: [] },
  };
  const sqlBlocks = ["-- Generated content batch upsert"];

  // 1) 北京回改（英文长文 only）
  for (const folder of onlyDirs(SOURCE_BEIJING)) {
    const parent = attMap.get(folder) || attractions.find((a) => String(a.chinese_name || "").includes(folder));
    if (!parent) {
      report.unmatched.attractions.push(`beijing:${folder}`);
      continue;
    }
    const dir = join(SOURCE_BEIJING, folder);
    const md = readdirSync(dir).find((n) => n.endsWith(".md"));
    if (!md) continue;
    const sections = parseBeijingSections(readFileSync(join(dir, md), "utf8"));
    const images = readdirSync(dir).filter((n) => [".png", ".jpg", ".jpeg", ".webp", ".JPG"].includes(extname(n)));
    for (const sec of sections) {
      const id = `${parent.id}_bj_sa_${String(sec.order + 1).padStart(2, "0")}`;
      const img = images.find((x) => parseSeqFromName(x) === sec.seq) || images[sec.order];
      let coverUrl = null;
      if (img) {
        const ext = extname(img).toLowerCase().replace(".", "") || "jpg";
        try {
          coverUrl = await uploadFile(supabase, COVER_BUCKET, `sub-areas/all/${id}.${ext}`, join(dir, img));
        } catch (e) {
          if (isObjectTooLargeError(e)) {
            report.unmatched.images.push(`oversize:${id}:${img}`);
            coverUrl = null;
          } else {
            throw e;
          }
        }
      } else {
        report.unmatched.images.push(`beijing:${id}`);
      }
      const nameParts = sec.title.split("/").map((x) => x.trim());
      const nameZh = nameParts[0] || sec.title;
      const nameEn = nameParts[1] || toSafeSlug(sec.title).replace(/_/g, " ") || `Sub Area ${sec.order + 1}`;
      sqlBlocks.push(`INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  ${sqlStr(id)}, ${sqlStr(parent.id)}, ${sqlStr(nameEn)}, ${sqlStr(nameZh)},
  ${sqlStr(coverUrl)}, ${sqlStr(toHtmlParagraphs(sec.englishLong))}, ${sec.order}, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();`);
      report.totals.subAreas += 1;
    }
  }

  // 2) 后台图文子景点（多城市）
  for (const cityDir of onlyDirs(SOURCE_BACKEND)) {
    const cityPath = join(SOURCE_BACKEND, cityDir);
    const infoDirs = onlyDirs(cityPath).filter((x) => x.includes("信息"));
    for (const infoDir of infoDirs) {
      const infoRoot = join(cityPath, infoDir);
      for (const attractionInfoDir of onlyDirs(infoRoot)) {
        const attName = attractionInfoDir.replace(/子景点信息/g, "").trim();
        const parent = attMap.get(attName) || attractions.find((a) => String(a.chinese_name || "").includes(attName) || attName.includes(String(a.chinese_name || "")));
        if (!parent) {
          report.unmatched.attractions.push(`backend:${cityDir}/${attName}`);
          continue;
        }
        const textDir = join(infoRoot, attractionInfoDir);
        const imageDirCandidate = join(cityPath, attName);
        const hasImageDir = statSync(imageDirCandidate, { throwIfNoEntry: false })?.isDirectory?.() || false;
        const imageDir = hasImageDir ? imageDirCandidate : null;
        const imageFiles = imageDir ? readdirSync(imageDir).filter((n) => [".png", ".jpg", ".jpeg", ".webp", ".JPG"].includes(extname(n))) : [];

        const mdFiles = readdirSync(textDir).filter((n) => n.endsWith(".md"));
        mdFiles.sort();
        for (let i = 0; i < mdFiles.length; i += 1) {
          const mdFile = mdFiles[i];
          const parsed = parseBackendMarkdown(readFileSync(join(textDir, mdFile), "utf8"));
          const seq = parseSeqFromName(mdFile) || String(i + 1);
          const id = `${parent.id}_sa_${String(i + 1).padStart(2, "0")}`;
          const img = imageFiles.find((x) => basename(x, extname(x)).includes(basename(mdFile, ".md"))) || imageFiles.find((x) => parseSeqFromName(x) === seq) || imageFiles[i];
          let coverUrl = null;
          if (img) {
            const ext = extname(img).toLowerCase().replace(".", "") || "jpg";
            try {
              coverUrl = await uploadFile(supabase, COVER_BUCKET, `sub-areas/all/${id}.${ext}`, join(imageDir, img));
            } catch (e) {
              if (isObjectTooLargeError(e)) {
                report.unmatched.images.push(`oversize:${id}:${img}`);
                coverUrl = null;
              } else {
                throw e;
              }
            }
          } else {
            report.unmatched.images.push(`backend:${id}`);
          }
          const nameZh = parsed.nameZh || basename(mdFile, ".md");
          const nameEn = parsed.nameEn || toSafeSlug(nameZh).replace(/_/g, " ");
          sqlBlocks.push(`INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  ${sqlStr(id)}, ${sqlStr(parent.id)}, ${sqlStr(nameEn)}, ${sqlStr(nameZh)},
  ${sqlStr(coverUrl)}, ${sqlStr(toHtmlParagraphs(parsed.englishLong))}, ${i}, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();`);
          report.totals.subAreas += 1;
        }
      }
    }
  }

  // 3) 常用语 + 方言
  const normalManifest = JSON.parse(readFileSync(join(SOURCE_PHRASES, "通用普通话音频_Cherry/_manifest.json"), "utf8"));
  const normalDir = join(SOURCE_PHRASES, "通用普通话音频_Cherry");
  for (const item of normalManifest) {
    const id = `phrase_common_${String(item.index).padStart(3, "0")}`;
    const local = resolvePhraseAudioByIndex(normalDir, item.file, item.index);
    if (!local) {
      report.unmatched.audios.push(`common:${id}:${item.file || ""}`);
      continue;
    }
    const audioUrl = await uploadFile(supabase, AUDIO_BUCKET, `phrases/${id}.mp3`, local);
    sqlBlocks.push(`INSERT INTO common_phrases (id, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES (${sqlStr(id)}, ${sqlStr(item.zh || "")}, ${sqlStr(item.read || "")}, ${sqlStr(item.en || "")}, ${sqlStr(audioUrl)}, ${Number(item.index) - 1}, TRUE)
ON CONFLICT (id) DO UPDATE SET
  cn=EXCLUDED.cn,pinyin=EXCLUDED.pinyin,en=EXCLUDED.en,audio_url=EXCLUDED.audio_url,sort_order=EXCLUDED.sort_order,is_active=EXCLUDED.is_active,updated_at=NOW();`);
    report.totals.commonPhrases += 1;
  }
  const dialectManifest = JSON.parse(readFileSync(join(SOURCE_PHRASES, "各城市-趣味方言与常用语/趣味方言合集/_manifest.json"), "utf8"));
  const dialectDir = join(SOURCE_PHRASES, "各城市-趣味方言与常用语/趣味方言合集");
  for (const item of dialectManifest) {
    const dialectSlug = toSafeSlug(item.方言 || "dialect");
    const id = `phrase_dialect_${dialectSlug}_${String(item.编号).padStart(3, "0")}`;
    const local = resolvePhraseAudioByIndex(dialectDir, item.文件, item.编号);
    if (!local) {
      report.unmatched.audios.push(`dialect:${id}:${item.文件 || ""}`);
      continue;
    }
    const audioUrl = await uploadFile(supabase, AUDIO_BUCKET, `phrases/${id}.mp3`, local);
    sqlBlocks.push(`INSERT INTO dialect_phrases (id, dialect, emoji, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES (${sqlStr(id)}, ${sqlStr(item.方言 || "")}, '', ${sqlStr(item.中文 || "")}, '', ${sqlStr(item.English || "")}, ${sqlStr(audioUrl)}, ${Number(item.编号) - 1}, TRUE)
ON CONFLICT (id) DO UPDATE SET
  dialect=EXCLUDED.dialect,cn=EXCLUDED.cn,en=EXCLUDED.en,audio_url=EXCLUDED.audio_url,sort_order=EXCLUDED.sort_order,is_active=EXCLUDED.is_active,updated_at=NOW();`);
    report.totals.dialectPhrases += 1;
  }

  // 4) Benedict 英文解说音频 -> 回填已存在 sub_areas.audio_url（按 attraction + 序号）
  const benCities = onlyDirs(SOURCE_BENEDICT);
  for (const city of benCities) {
    const cityPath = join(SOURCE_BENEDICT, city);
    for (const scenic of onlyDirs(cityPath)) {
      const parent = attMap.get(scenic) || attractions.find((a) => String(a.chinese_name || "").includes(scenic) || scenic.includes(String(a.chinese_name || "")));
      if (!parent) {
        report.unmatched.attractions.push(`audio:${city}/${scenic}`);
        continue;
      }
      const files = readdirSync(join(cityPath, scenic)).filter((n) => n.toLowerCase().endsWith(".mp3"));
      for (const f of files) {
        const seqMatch = f.match(/_([0-9]{1,3})\./);
        if (!seqMatch) continue;
        const seq = Number(seqMatch[1]);
        const audioPath = join(cityPath, scenic, f);
        const storagePath = `sub-areas/${parent.id}_${String(seq).padStart(3, "0")}.mp3`;
        const audioUrl = await uploadFile(supabase, AUDIO_BUCKET, storagePath, audioPath);
        sqlBlocks.push(`UPDATE sub_areas
SET audio_url=${sqlStr(audioUrl)}, updated_at=NOW()
WHERE attraction_id=${sqlStr(parent.id)} AND sort_order=${seq - 1};`);
        report.totals.subAreaAudios += 1;
      }
    }
  }

  writeFileSync(OUT_SQL, `${sqlBlocks.join("\n\n")}\n`, "utf8");
  writeFileSync(OUT_REPORT, JSON.stringify(report, null, 2), "utf8");
  console.log(`sql: ${OUT_SQL}`);
  console.log(`report: ${OUT_REPORT}`);
  console.log(`totals: ${JSON.stringify(report.totals)}`);
}

main().catch((err) => {
  console.error(err.message);
  process.exit(1);
});
