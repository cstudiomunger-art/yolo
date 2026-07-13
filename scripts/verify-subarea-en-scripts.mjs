#!/usr/bin/env node
/**
 * Verify sub-area narration scripts in DB vs source markdown.
 *
 *   node scripts/verify-subarea-en-scripts.mjs
 */
import { createHash } from "crypto";
import { existsSync, mkdirSync, readFileSync, readdirSync, statSync, writeFileSync } from "fs";
import { join } from "path";
import { getSupabaseConfig, loadServiceKey } from "./lib/supabase-service.mjs";

const ROOT = "/Users/vesperal/Desktop/YOLO";
const OUT = join(ROOT, "scripts/generated/en_scripts_verify.json");
const SOURCE_ROOT = "/Users/vesperal/Desktop/英文解说词原文";

const CITY_FOLDER_TO_ID = {
  上海: "shanghai",
  北京: "beijing",
  南京: "nanjing",
  成都: "chengdu",
  杭州: "hangzhou",
  苏州: "suzhou",
  重庆: "chongqing",
};

function sha16(text) {
  return createHash("sha256").update(String(text || ""), "utf8").digest("hex").slice(0, 16);
}

function onlyDirs(path) {
  return readdirSync(path).filter((name) => {
    try {
      return statSync(join(path, name)).isDirectory();
    } catch {
      return false;
    }
  });
}

function countSourceScripts(root) {
  let count = 0;
  for (const city of onlyDirs(root)) {
    const cityPath = join(root, city);
    for (const attraction of onlyDirs(cityPath)) {
      const attrPath = join(cityPath, attraction);
      for (const sub of onlyDirs(attrPath)) {
        const subPath = join(attrPath, sub);
        const files = readdirSync(subPath).filter((f) => f.startsWith("EN_") && f.endsWith(".md"));
        if (files.length) count += 1;
      }
    }
  }
  return count;
}

async function rest(path) {
  const { url } = getSupabaseConfig();
  const key = loadServiceKey();
  const res = await fetch(`${url}${path}`, {
    headers: { apikey: key, Authorization: `Bearer ${key}` },
  });
  if (!res.ok) throw new Error(`${path} -> ${res.status} ${await res.text()}`);
  return res.json();
}

async function fetchAllSubAreas() {
  const rows = [];
  let offset = 0;
  const page = 1000;
  while (true) {
    const batch = await rest(
      `/rest/v1/sub_areas?select=id,name_zh,body,audio_transcript,audio_url,is_active&is_active=eq.true&order=id&limit=${page}&offset=${offset}`
    );
    rows.push(...batch);
    if (batch.length < page) break;
    offset += page;
  }
  return rows;
}

async function main() {
  mkdirSync(join(ROOT, "scripts/generated"), { recursive: true });
  if (!loadServiceKey()) throw new Error("缺少 SUPABASE_SERVICE_ROLE_KEY");

  const subAreas = await fetchAllSubAreas();
  const withAudio = subAreas.filter((r) => (r.audio_url || "").trim());
  const bodyFilled = subAreas.filter((r) => (r.body || "").trim().length > 200);
  const transcriptFilled = subAreas.filter((r) => (r.audio_transcript || "").trim().length > 200);
  const bodyShort = subAreas.filter((r) => {
    const len = (r.body || "").trim().length;
    return len > 0 && len <= 200;
  });
  const audioNoBody = withAudio.filter((r) => !(r.body || "").trim() || (r.body || "").trim().length <= 200);
  const audioNoTranscript = withAudio.filter(
    (r) => !(r.audio_transcript || "").trim() || (r.audio_transcript || "").trim().length <= 200
  );

  const samples = [
    "beijing_forbidden_city_sa_01",
    "beijing_beihai_park_sa_01",
    "the_bund_shanghai_sa_01",
    "chengdu_panda_base_sa_01",
    "chongqing_dazu_rock_carvings_sa_01",
    "suzhou_creek_twelve_nations_colors_sa_12",
  ];

  const sampleDetails = [];
  for (const id of samples) {
    const row = subAreas.find((r) => r.id === id);
    sampleDetails.push({
      id,
      nameZh: row?.name_zh,
      bodyLen: (row?.body || "").length,
      audioTranscriptLen: (row?.audio_transcript || "").length,
      hasAudio: Boolean((row?.audio_url || "").trim()),
      bodySha: sha16(row?.body),
      audioTranscriptSha: sha16(row?.audio_transcript),
    });
  }

  const report = {
    verifiedAt: new Date().toISOString(),
    sourceRoot: SOURCE_ROOT,
    sourceScriptFolders: existsSync(SOURCE_ROOT) ? countSourceScripts(SOURCE_ROOT) : 0,
    previousImportReport: existsSync(join(ROOT, "scripts/generated/en_scripts_report.json"))
      ? JSON.parse(readFileSync(join(ROOT, "scripts/generated/en_scripts_report.json"), "utf8")).stats
      : null,
    db: {
      activeSubAreas: subAreas.length,
      withAudioUrl: withAudio.length,
      bodyOver200Chars: bodyFilled.length,
      audioTranscriptOver200Chars: transcriptFilled.length,
      bodyShortOrStub: bodyShort.length,
      withAudioButNoLongBody: audioNoBody.length,
      withAudioButNoLongTranscript: audioNoTranscript.length,
    },
    issue:
      transcriptFilled.length === 0
        ? "解说词写在 sub_areas.body，但 App 播放器读 audio_transcript — 需同步字段"
        : bodyFilled.length < withAudio.length * 0.8
          ? "大量子景点 body 仍为空或过短"
          : null,
    samples: sampleDetails,
    audioNoBodyExamples: audioNoBody.slice(0, 15).map((r) => ({
      id: r.id,
      nameZh: r.name_zh,
      bodyLen: (r.body || "").length,
      audioTranscriptLen: (r.audio_transcript || "").length,
    })),
  };

  writeFileSync(OUT, `${JSON.stringify(report, null, 2)}\n`, "utf8");
  console.log(JSON.stringify(report, null, 2));
}

main().catch((err) => {
  console.error(err.message || err);
  process.exit(1);
});
