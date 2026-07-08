#!/usr/bin/env node
import { mkdirSync, readFileSync, readdirSync, statSync, writeFileSync } from "fs";
import { basename, extname, join } from "path";

const ROOT = "/Users/vesperal/Desktop/YOLO";
const SOURCE_BENEDICT = "/Users/vesperal/Downloads/全量英文解说音频_Benedict";
const OUT_DIR = join(ROOT, "scripts/generated");
const OUT_SQL = join(OUT_DIR, "sub_areas_audio_benedict.sql");
const OUT_REPORT = join(OUT_DIR, "sub_areas_audio_benedict_report.json");
const AUDIO_BUCKET = "audio-guides";

const ATTRACTION_ALIASES = {
  南京大屠杀纪念馆: "侵华日军南京大屠杀遇难同胞纪念馆",
  南京老门东: "老门东历史文化街区",
  熊猫基地: "大熊猫基地",
  成都熊猫基地: "大熊猫基地",
  成都博物院: "成都博物馆",
  南京博物馆: "南京博物院",
  夫子庙: "南京夫子庙-秦淮河风光带",
  耦园: "耦园（又称藕园）",
  苏州环秀山庄: "环秀山庄",
  浙江省博物馆之江馆区: "浙江省博物馆",
  "浙江省博物馆（之江馆区）": "浙江省博物馆",
  丝绸博物馆: "中国丝绸博物馆",
  良渚古城: "良渚古城遗址公园",
  河坊街: "河坊街（清河坊历史街区）",
  大运河拱宸桥景区: "大运河拱宸桥",
  磁器口古镇: "磁器口",
  解放碑: "解放碑广场",
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

function onlyDirs(path) {
  return readdirSync(path).filter((n) => statSync(join(path, n)).isDirectory());
}

function collectAudioFiles(scenicPath) {
  const results = [];
  function walk(dir, rel = "") {
    for (const name of readdirSync(dir)) {
      const full = join(dir, name);
      const st = statSync(full);
      if (st.isDirectory()) {
        walk(full, rel ? `${rel}/${name}` : name);
        continue;
      }
      if (!name.toLowerCase().endsWith(".mp3")) continue;
      const seq = parseAudioSeq(name);
      results.push({ file: name, localPath: full, relDir: rel, fileSeq: seq });
    }
  }
  walk(scenicPath);
  const nested = results.some((r) => r.relDir);
  if (nested) {
    results.sort(
      (a, b) =>
        a.relDir.localeCompare(b.relDir, "zh-Hans-CN") ||
        a.fileSeq - b.fileSeq ||
        a.file.localeCompare(b.file)
    );
    return results.map((r, idx) => ({ ...r, seq: idx + 1 }));
  }
  return results
    .sort((a, b) => a.fileSeq - b.fileSeq || a.file.localeCompare(b.file))
    .map((r) => ({ ...r, seq: r.fileSeq }));
}

function parseAudioSeq(filename) {
  const m = filename.match(/_([0-9]{1,3})\./);
  return m ? Number(m[1]) : 0;
}

function storageKey(attractionId, seq) {
  return `sub-areas/${attractionId}_${String(seq).padStart(3, "0")}.mp3`;
}

function loadAudioUrlIndexFromSql() {
  const index = new Map();
  for (const f of readdirSync(OUT_DIR).filter((n) => n.endsWith(".sql"))) {
    const text = readFileSync(join(OUT_DIR, f), "utf8");
    const re =
      /'(https:[^']*audio-guides\/sub-areas\/([a-z0-9_]+_\d{3}\.mp3))'/gi;
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

async function uploadAudio(storagePath, localPath) {
  const { url } = getSupabaseConfig();
  const body = readFileSync(localPath);
  await rest(`/storage/v1/object/${AUDIO_BUCKET}/${storagePath}`, {
    method: "POST",
    headers: { "x-upsert": "true", "content-type": "audio/mpeg" },
    body,
  });
  return `${url}/storage/v1/object/public/${AUDIO_BUCKET}/${storagePath}`;
}

function resolveAttraction(scenic, attractions) {
  const guess = ATTRACTION_ALIASES[scenic] || scenic;
  return (
    attractions.find((a) => String(a.chinese_name || "").trim() === guess) ||
    attractions.find(
      (a) =>
        String(a.chinese_name || "").includes(guess) ||
        guess.includes(String(a.chinese_name || "").trim())
    )
  );
}

async function main() {
  mkdirSync(OUT_DIR, { recursive: true });
  const { url } = getSupabaseConfig();

  const attractions = await (await rest("/rest/v1/attractions?select=id,chinese_name")).json();
  const subAreas = await (
    await rest("/rest/v1/sub_areas?select=id,attraction_id,sort_order,audio_url,name_zh&audio_url=not.is.null")
  ).json();

  const sqlAudioIndex = loadAudioUrlIndexFromSql();
  const dbByAttrSort = new Map();
  for (const row of subAreas) {
    dbByAttrSort.set(`${row.attraction_id}:${row.sort_order}`, row.audio_url);
  }

  const report = {
    generatedAt: new Date().toISOString(),
    sourceRoot: SOURCE_BENEDICT,
    stats: {
      totalAudioFiles: 0,
      reusedFromSql: 0,
      reusedFromDb: 0,
      newlyUploaded: 0,
      sqlUpdates: 0,
      unmatchedAttractions: 0,
      skippedNoSeq: 0,
    },
    unmatchedAttractions: [],
    cities: [],
    missingUpload: [],
  };

  const sqlBlocks = ["-- Generated Benedict sub-area audio updates (reuse existing URLs where possible)"];
  const seenUpdates = new Set();

  for (const city of onlyDirs(SOURCE_BENEDICT).sort()) {
    const cityPath = join(SOURCE_BENEDICT, city);
    const cityReport = { city, attractions: [] };

    for (const scenic of onlyDirs(cityPath).sort((a, b) => a.localeCompare(b, "zh-Hans-CN"))) {
      const parent = resolveAttraction(scenic, attractions);
      if (!parent) {
        report.stats.unmatchedAttractions += 1;
        report.unmatchedAttractions.push(`${city}/${scenic}`);
        continue;
      }

      const scenicPath = join(cityPath, scenic);
      const files = collectAudioFiles(scenicPath);

      const attrReport = {
        folder: scenic,
        attractionId: parent.id,
        attractionNameZh: String(parent.chinese_name || "").trim(),
        nested: files.some((f) => f.relDir),
        count: 0,
        reused: 0,
        uploaded: 0,
        items: [],
      };

      for (const entry of files) {
        report.stats.totalAudioFiles += 1;
        const seq = entry.seq;
        if (!seq) {
          report.stats.skippedNoSeq += 1;
          continue;
        }
        const sortOrder = seq - 1;
        const key = `${parent.id}_${String(seq).padStart(3, "0")}.mp3`;
        const storagePath = storageKey(parent.id, seq);
        const updateKey = `${parent.id}:${sortOrder}`;

        let audioUrl = "";
        let source = "";

        if (sqlAudioIndex.get(key)) {
          audioUrl = sqlAudioIndex.get(key);
          source = "sql";
          report.stats.reusedFromSql += 1;
          attrReport.reused += 1;
        } else if (dbByAttrSort.get(`${parent.id}:${sortOrder}`)) {
          audioUrl = dbByAttrSort.get(`${parent.id}:${sortOrder}`);
          source = "db";
          report.stats.reusedFromDb += 1;
          attrReport.reused += 1;
        } else {
          audioUrl = await uploadAudio(storagePath, entry.localPath);
          source = "upload";
          report.stats.newlyUploaded += 1;
          attrReport.uploaded += 1;
          sqlAudioIndex.set(key, audioUrl);
        }

        if (!seenUpdates.has(updateKey)) {
          seenUpdates.add(updateKey);
          sqlBlocks.push(
            `UPDATE sub_areas\nSET audio_url=${sqlStr(audioUrl)}, updated_at=NOW()\nWHERE attraction_id=${sqlStr(parent.id)} AND sort_order=${sortOrder};`
          );
          report.stats.sqlUpdates += 1;
        }

        attrReport.count += 1;
        attrReport.items.push({
          file: entry.relDir ? `${entry.relDir}/${entry.file}` : entry.file,
          seq,
          sortOrder,
          storageKey: key,
          audioSource: source,
        });
      }

      cityReport.attractions.push(attrReport);
    }

    report.cities.push(cityReport);
  }

  writeFileSync(OUT_SQL, `${sqlBlocks.join("\n\n")}\n`, "utf8");
  writeFileSync(OUT_REPORT, JSON.stringify(report, null, 2), "utf8");

  console.log(`sql: ${OUT_SQL}`);
  console.log(`report: ${OUT_REPORT}`);
  console.log(JSON.stringify(report.stats, null, 2));
  if (report.unmatchedAttractions.length) {
    console.log("unmatched:", report.unmatchedAttractions);
  }
}

main().catch((err) => {
  console.error(err.message);
  process.exit(1);
});
