#!/usr/bin/env node
import { existsSync, mkdirSync, readFileSync, readdirSync, writeFileSync } from "fs";
import { join } from "path";

const ROOT = "/Users/vesperal/Desktop/YOLO";
const SOURCE_DIR = "/Users/vesperal/Downloads/04_常用语/各城市-趣味方言与常用语/趣味方言合集";
const MANIFEST_PATH = join(SOURCE_DIR, "_manifest.json");
const OUT_DIR = join(ROOT, "scripts/generated");
const OUT_SQL = join(OUT_DIR, "dialect_phrases_upsert.sql");
const OUT_REPORT = join(OUT_DIR, "dialect_phrases_report.json");
const AUDIO_BUCKET = "audio-guides";

const DIALECT_SLUG = {
  四川话: "sichuan",
  北京话: "beijing",
  南京话: "nanjing",
  上海话: "shanghai",
};

const DIALECT_EMOJI = {
  四川话: "🌶️",
  北京话: "🫖",
  南京话: "🏯",
  上海话: "🏙️",
};

const LEGACY_SEED_IDS = ["sc_1", "sc_2", "sc_3", "bj_1", "bj_2", "sx_1", "sx_2"];

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

function dialectSlug(name) {
  const slug = DIALECT_SLUG[name];
  if (!slug) throw new Error(`缺少方言 slug 映射: ${name}`);
  return slug;
}

function phraseId(dialectName, number) {
  return `phrase_dialect_${dialectSlug(dialectName)}_${String(number).padStart(3, "0")}`;
}

function storagePathForId(id) {
  return `phrases/${id}.mp3`;
}

function publicUrl(supabaseUrl, path) {
  return `${supabaseUrl}/storage/v1/object/public/${AUDIO_BUCKET}/${path}`;
}

function loadManifestEntries() {
  const manifest = JSON.parse(readFileSync(MANIFEST_PATH, "utf8"));
  return manifest.map((item, sortOrder) => {
    const dialect = String(item.方言 || "").trim();
    const number = Number(item.编号);
    const file = String(item.文件 || "").trim();
    const id = phraseId(dialect, number);
    const localPath = join(SOURCE_DIR, file);
    const warnings = [];
    if (!existsSync(localPath)) warnings.push("missing_audio_file");
    return {
      id,
      dialect,
      emoji: DIALECT_EMOJI[dialect] || "",
      cn: String(item.中文 || "").trim(),
      en: String(item.English || "").trim(),
      file,
      localPath,
      sortOrder,
      storagePath: storagePathForId(id),
      warnings,
    };
  });
}

function loadSqlAudioIndex() {
  const index = new Map();
  for (const name of readdirSync(OUT_DIR).filter((n) => n.endsWith(".sql"))) {
    const text = readFileSync(join(OUT_DIR, name), "utf8");
    const re = /'(https:[^']*audio-guides\/phrases\/(phrase_dialect_[a-z]+_\d{3}\.mp3))'/gi;
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

async function uploadAudio(storagePathValue, localPath) {
  const body = readFileSync(localPath);
  await rest(`/storage/v1/object/${AUDIO_BUCKET}/${storagePathValue}`, {
    method: "POST",
    headers: { "x-upsert": "true", "content-type": "audio/mpeg" },
    body,
  });
}

function buildInsert(row) {
  return `INSERT INTO dialect_phrases (id, dialect, emoji, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES (
  ${sqlStr(row.id)},
  ${sqlStr(row.dialect)},
  ${sqlStr(row.emoji)},
  ${sqlStr(row.cn)},
  ${sqlStr("")},
  ${sqlStr(row.en)},
  ${sqlStr(row.audioUrl)},
  ${row.sortOrder},
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  dialect = EXCLUDED.dialect,
  emoji = EXCLUDED.emoji,
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
  const entries = loadManifestEntries();
  const newIds = entries.map((e) => e.id);
  const sqlAudioIndex = loadSqlAudioIndex();

  let dbRows = [];
  try {
    dbRows = await (await rest("/rest/v1/dialect_phrases?select=id,audio_url")).json();
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
      reusedFromDefault: 0,
      uploaded: 0,
    },
    unmatchedAudios: [],
    phrases: [],
    newIds,
    deletedIds: [],
    legacySeedIds: LEGACY_SEED_IDS,
  };

  const rows = [];
  for (const entry of entries) {
    if (entry.warnings.includes("missing_audio_file")) {
      report.unmatchedAudios.push(`${entry.id}:${entry.file}`);
      continue;
    }

    const storageKey = `${entry.id}.mp3`;
    let audioUrl = "";
    let audioSource = "";

    if (sqlAudioIndex.get(storageKey)) {
      audioUrl = sqlAudioIndex.get(storageKey);
      audioSource = "sql";
      report.stats.reusedFromSql += 1;
    } else if (dbById.get(entry.id)) {
      audioUrl = dbById.get(entry.id);
      audioSource = "db";
      report.stats.reusedFromDb += 1;
    } else {
      audioUrl = publicUrl(supabaseUrl, entry.storagePath);
      audioSource = "default";
      report.stats.reusedFromDefault += 1;
    }

    await uploadAudio(entry.storagePath, entry.localPath);
    report.stats.uploaded += 1;

    rows.push({
      ...entry,
      audioUrl,
      audioSource,
    });
  }

  if (rows.length !== entries.length) {
    throw new Error(`仅匹配 ${rows.length}/${entries.length} 条音频`);
  }

  const deletedFromDb = dbRows.map((row) => row.id).filter((id) => !newIds.includes(id));
  report.deletedIds = [
    ...new Set([...deletedFromDb, ...LEGACY_SEED_IDS.filter((id) => !newIds.includes(id))]),
  ].sort();

  const deleteSql = `-- Remove dialect phrases not in the new 26-item manifest set
DELETE FROM dialect_phrases
WHERE id NOT IN (${newIds.map((id) => sqlStr(id)).join(", ")});

`;

  const sql = `-- Generated dialect_phrases from 趣味方言合集 manifest + audio
-- Source: ${SOURCE_DIR}
-- Total phrases: ${rows.length}

${deleteSql}${rows.map(buildInsert).join("\n\n")}
`;
  writeFileSync(OUT_SQL, sql, "utf8");

  report.phrases = rows.map((row) => ({
    id: row.id,
    dialect: row.dialect,
    emoji: row.emoji,
    cn: row.cn,
    en: row.en,
    file: row.file,
    sortOrder: row.sortOrder,
    storagePath: row.storagePath,
    audioUrl: row.audioUrl,
    audioSource: row.audioSource,
    warnings: row.warnings,
  }));
  writeFileSync(OUT_REPORT, JSON.stringify(report, null, 2), "utf8");

  console.log(`Generated ${rows.length} dialect phrases`);
  console.log(`SQL: ${OUT_SQL}`);
  console.log(`Report: ${OUT_REPORT}`);
  console.log(JSON.stringify(report.stats, null, 2));
  console.log(`deletedIds (${report.deletedIds.length}):`, report.deletedIds.join(", "));
}

main().catch((err) => {
  console.error(err.message);
  process.exit(1);
});
