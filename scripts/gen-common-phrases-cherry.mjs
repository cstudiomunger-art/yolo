#!/usr/bin/env node
import { mkdirSync, readFileSync, readdirSync, writeFileSync } from "fs";
import { basename, extname, join } from "path";

const ROOT = "/Users/vesperal/Desktop/YOLO";
const SOURCE_DIR = "/Users/vesperal/Downloads/通用普通话音频_Cherry";
const OUT_DIR = join(ROOT, "scripts/generated");
const OUT_SQL = join(OUT_DIR, "common_phrases_cherry.sql");
const OUT_REPORT = join(OUT_DIR, "common_phrases_cherry_report.json");
const AUDIO_BUCKET = "audio-guides";

const PHRASE_EN_BY_INDEX = {
  1: "Hello",
  2: "Thank you",
  3: "Excuse me / Sorry",
  4: "I don't understand",
  5: "I don't speak Chinese",
  6: "Please write it down for me",
  7: "Do you speak English?",
  8: "I want to go to this address",
  9: "Please tell me when we arrive",
  10: "Which way should I go?",
  11: "Where is the nearest restroom?",
  12: "Which exit is closest to this place?",
  13: "Do you have an English menu?",
  14: "Do you have a picture menu?",
  15: "One of these, please",
  16: "Not spicy, please",
  17: "The bill, please",
  18: "Is this melon ripe (sweet)?",
  19: "Can I pay with Alipay or WeChat?",
  20: "Please help me",
  21: "Please call 110",
  22: "Please call 120 for me",
  23: "I lost my passport",
};

const LEGACY_SEED_IDS = ["hello", "thanks", "howmuch", "nospicy", "toilet"];

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

function phraseId(index) {
  return `phrase_common_${String(index).padStart(3, "0")}`;
}

function storagePath(index) {
  return `phrases/${phraseId(index)}.mp3`;
}

function publicUrl(supabaseUrl, path) {
  return `${supabaseUrl}/storage/v1/object/public/${AUDIO_BUCKET}/${path}`;
}

function parseMp3Entries(sourceDir) {
  const files = readdirSync(sourceDir)
    .filter((name) => name.toLowerCase().endsWith(".mp3"))
    .sort((a, b) => a.localeCompare(b, "zh-Hans-CN"));

  return files.map((file) => {
    const stem = basename(file, extname(file));
    const m = stem.match(/^(\d{1,3})[_-](.+)$/);
    if (!m) throw new Error(`无法解析文件名: ${file}`);
    const index = Number(m[1]);
    const cn = m[2].trim();
    return {
      file,
      index,
      cn,
      id: phraseId(index),
      localPath: join(sourceDir, file),
      sortOrder: index - 1,
    };
  });
}

function loadSqlAudioIndex() {
  const index = new Map();
  for (const name of readdirSync(OUT_DIR).filter((n) => n.endsWith(".sql"))) {
    const text = readFileSync(join(OUT_DIR, name), "utf8");
    const re = /'(https:[^']*audio-guides\/phrases\/(phrase_common_\d{3}\.mp3))'/gi;
    let m;
    while ((m = re.exec(text))) index.set(m[2], m[1]);
  }
  return index;
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

async function storageObjectExists(storagePathValue) {
  try {
    const res = await rest(`/storage/v1/object/info/${AUDIO_BUCKET}/${storagePathValue}`, { method: "GET" });
    return res.ok;
  } catch {
    return false;
  }
}

async function uploadAudio(storagePathValue, localPath) {
  const body = readFileSync(localPath);
  await rest(`/storage/v1/object/${AUDIO_BUCKET}/${storagePathValue}`, {
    method: "POST",
    headers: { "x-upsert": "true", "content-type": "audio/mpeg" },
    body,
  });
}

function buildInsert(row) {
  return `INSERT INTO common_phrases (id, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES (
  ${sqlStr(row.id)},
  ${sqlStr(row.cn)},
  ${sqlStr("")},
  ${sqlStr(row.en)},
  ${sqlStr(row.audioUrl)},
  ${row.sortOrder},
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  cn = EXCLUDED.cn,
  pinyin = EXCLUDED.pinyin,
  en = EXCLUDED.en,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();`;
}

async function main() {
  mkdirSync(OUT_DIR, { recursive: true });
  const { url: supabaseUrl } = getSupabaseConfig();
  const entries = parseMp3Entries(SOURCE_DIR);
  const newIds = entries.map((e) => e.id);
  const sqlAudioIndex = loadSqlAudioIndex();

  let dbRows = [];
  try {
    dbRows = await (await rest("/rest/v1/common_phrases?select=id,audio_url")).json();
  } catch {
    dbRows = [];
  }
  const dbById = new Map(dbRows.map((row) => [row.id, row.audio_url]));

  const report = {
    generatedAt: new Date().toISOString(),
    sourceDir: SOURCE_DIR,
    stats: {
      phrases: entries.length,
      reusedFromSql: 0,
      reusedFromDb: 0,
      reusedFromStorage: 0,
      newlyUploaded: 0,
      uploaded: 0,
    },
    phrases: [],
    newIds,
    deletedIds: [],
    legacySeedIds: LEGACY_SEED_IDS,
  };

  const rows = [];
  for (const entry of entries) {
    const path = storagePath(entry.index);
    const key = `${phraseId(entry.index)}.mp3`;
    let audioUrl = "";
    let audioSource = "";

    if (sqlAudioIndex.get(key)) {
      audioUrl = sqlAudioIndex.get(key);
      audioSource = "sql";
      report.stats.reusedFromSql += 1;
    } else if (dbById.get(entry.id)) {
      audioUrl = dbById.get(entry.id);
      audioSource = "db";
      report.stats.reusedFromDb += 1;
    } else if (await storageObjectExists(path)) {
      audioUrl = publicUrl(supabaseUrl, path);
      audioSource = "storage";
      report.stats.reusedFromStorage += 1;
    } else {
      audioUrl = publicUrl(supabaseUrl, path);
      audioSource = "upload";
    }

    try {
      await uploadAudio(path, entry.localPath);
      report.stats.uploaded += 1;
      if (audioSource === "upload") report.stats.newlyUploaded += 1;
    } catch (err) {
      if (!audioUrl) throw err;
    }

    if (!audioUrl) audioUrl = publicUrl(supabaseUrl, path);

    const en = PHRASE_EN_BY_INDEX[entry.index];
    if (!en) throw new Error(`缺少英文映射: index ${entry.index}`);

    rows.push({
      id: entry.id,
      cn: entry.cn,
      en,
      audioUrl,
      sortOrder: entry.sortOrder,
      file: entry.file,
      audioSource,
      storagePath: path,
    });
  }

  const deletedFromDb = dbRows
    .map((row) => row.id)
    .filter((id) => !newIds.includes(id));
  report.deletedIds = [...new Set([...deletedFromDb, ...LEGACY_SEED_IDS.filter((id) => !newIds.includes(id))])].sort();

  const deleteSql = `-- Remove common phrases not in the Cherry 23-audio set
DELETE FROM common_phrases
WHERE id NOT IN (${newIds.map((id) => sqlStr(id)).join(", ")});

`;

  const sql = `-- Generated common_phrases from Cherry Mandarin audio
-- Source: ${SOURCE_DIR}
-- Total phrases: ${rows.length}

${deleteSql}${rows.map(buildInsert).join("\n\n")}
`;
  writeFileSync(OUT_SQL, sql, "utf8");

  report.phrases = rows.map((row) => ({
    id: row.id,
    cn: row.cn,
    en: row.en,
    file: row.file,
    sortOrder: row.sortOrder,
    storagePath: row.storagePath,
    audioUrl: row.audioUrl,
    audioSource: row.audioSource,
  }));
  writeFileSync(OUT_REPORT, JSON.stringify(report, null, 2), "utf8");

  console.log(`Generated ${rows.length} common phrases`);
  console.log(`SQL: ${OUT_SQL}`);
  console.log(`Report: ${OUT_REPORT}`);
  console.log(JSON.stringify(report.stats, null, 2));
  console.log(`deletedIds (${report.deletedIds.length}):`, report.deletedIds.join(", "));
}

main().catch((err) => {
  console.error(err.message);
  process.exit(1);
});
