#!/usr/bin/env node
/** Post dry-run / post-apply spot checks for canonical sub-area import. */
import { readFileSync, writeFileSync } from "fs";
import { join } from "path";

const ROOT = "/Users/vesperal/Desktop/YOLO";
const REPORT = join(ROOT, "scripts/generated/suzhou_canonical_subareas_report.json");
const OUT = join(ROOT, "scripts/generated/suzhou_canonical_subareas_verify.json");

function readXcconfigValue(path, key) {
  const text = readFileSync(path, "utf8");
  const line = text.split(/\r?\n/).find((it) => it.trim().startsWith(`${key} =`));
  if (!line) return "";
  return line.split("=").slice(1).join("=").replace(/\$\(\)/g, "").trim();
}

const url = (process.env.SUPABASE_URL || readXcconfigValue(join(ROOT, "Secrets.xcconfig"), "SUPABASE_URL")).replace(
  /\$\(\)/g,
  ""
);
const key =
  process.env.SUPABASE_SERVICE_ROLE_KEY ||
  process.env.SUPABASE_ANON_KEY ||
  readXcconfigValue(join(ROOT, "Secrets.xcconfig"), "SUPABASE_ANON_KEY");

const report = JSON.parse(readFileSync(REPORT, "utf8"));
const sampleIds = [
  "suzhou_lingering_garden_sa_01",
  "suzhou_pingjiang_road_sa_10",
  "suzhou_canglang_pavilion_sa_01",
  "suzhou_humble_administrators_garden_sa_05",
];

const res = await fetch(
  `${url}/rest/v1/sub_areas?id=in.(${sampleIds.join(",")})&select=id,name_zh,name_en,body,audio_url,cover_image_path`,
  { headers: { apikey: key, Authorization: `Bearer ${key}` } }
);
if (!res.ok) throw new Error(await res.text());
const dbRows = await res.json();
const byId = Object.fromEntries(dbRows.map((r) => [r.id, r]));
const expectedById = Object.fromEntries(report.items.map((i) => [i.id, i]));

const sampleChecks = sampleIds.map((id) => {
  const db = byId[id] || {};
  const exp = expectedById[id] || {};
  return {
    id,
    db_name_zh: db.name_zh,
    exp_name_zh: exp.nameZh,
    names_match: db.name_zh === exp.nameZh,
    db_body_len: (db.body || "").length,
    exp_body_md_len: (exp.bodyHtml || "").length,
    body_is_html: (db.body || "").includes("<p>"),
    body_needs_update:
      (db.body || "").includes("<p>") ||
      /[\u4e00-\u9fff]/.test(db.body || "") ||
      ((db.body || "").length < 50 && (exp.bodyHtml || "").length > 50),
    audio_url_present: Boolean(db.audio_url),
    db_cover_present: Boolean(db.cover_image_path),
    exp_has_local_image: Boolean(exp.localImagePath),
  };
});

const out = {
  verifiedAt: new Date().toISOString(),
  dryRunStats: report.stats,
  sampleChecks,
  note: "apply 需 SUPABASE_SERVICE_ROLE_KEY；upsert 不更新 audio_url",
};
writeFileSync(OUT, JSON.stringify(out, null, 2));
console.log(JSON.stringify(out, null, 2));
