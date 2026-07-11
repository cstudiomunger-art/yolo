#!/usr/bin/env node
/** Find duplicate sub_areas per attraction (same name_zh or same sort_order). */
import { readFileSync, writeFileSync, mkdirSync } from "fs";
import { join } from "path";

const ROOT = "/Users/vesperal/Desktop/YOLO";
const OUT = join(ROOT, "scripts/generated/sub_areas_duplicates_report.json");

const CITIES = (process.argv.includes("--city")
  ? [process.argv[process.argv.indexOf("--city") + 1]]
  : ["shanghai", "nanjing", "beijing", "chengdu", "suzhou"]
).filter(Boolean);

function readXc(k) {
  const t = readFileSync(join(ROOT, "Secrets.xcconfig"), "utf8");
  const l = t.split(/\r?\n/).find((x) => x.trim().startsWith(`${k} =`));
  return l.split("=").slice(1).join("=").replace(/\$\(\)/g, "").trim();
}

function loadKey() {
  if (process.env.SUPABASE_SERVICE_ROLE_KEY) return process.env.SUPABASE_SERVICE_ROLE_KEY;
  try {
    const m = readFileSync(join(ROOT, ".env.local.tmp"), "utf8").match(
      /SUPABASE_SERVICE_ROLE_KEY\s*=\s*"?([^"\n]+)"?/
    );
    if (m?.[1]) return m[1].trim();
  } catch {
    /* optional */
  }
  return readXc("SUPABASE_ANON_KEY");
}

const url = readXc("SUPABASE_URL").replace("https:/", "https://");
const key = loadKey();

async function rest(path) {
  const res = await fetch(`${url}${path}`, {
    headers: { apikey: key, Authorization: `Bearer ${key}` },
  });
  if (!res.ok) throw new Error(`${path} -> ${res.status} ${await res.text()}`);
  return res.json();
}

function normName(s) {
  return String(s || "")
    .replace(/\s+/g, "")
    .replace(/[（）()·—\-]/g, "")
    .trim();
}

function scoreRow(row, canonicalIds) {
  let score = 0;
  if (canonicalIds.has(row.id)) score += 100;
  if (row.cover_image_path) score += 10;
  if (row.audio_url) score += 5;
  if ((row.body || "").length > 100) score += 3;
  if ((row.body || "").includes("<p>")) score -= 2;
  if (/[\u4e00-\u9fff]/.test(row.body || "")) score -= 5;
  return score;
}

const attractions = await rest(
  `/rest/v1/attractions?select=id,chinese_name,city_id&city_id=in.(${CITIES.join(",")})`
);
const attractionIds = attractions.map((a) => a.id);
const byAttraction = Object.fromEntries(attractions.map((a) => [a.id, a]));

const canonicalIds = new Set();
for (const city of CITIES) {
  const reportPath = join(ROOT, `scripts/generated/${city}_canonical_subareas_report.json`);
  try {
    const report = JSON.parse(readFileSync(reportPath, "utf8"));
    for (const item of report.items || []) canonicalIds.add(item.id);
  } catch {
    /* no report */
  }
}

const allRows = [];
for (let i = 0; i < attractionIds.length; i += 15) {
  const chunk = attractionIds.slice(i, i + 15);
  const rows = await rest(
    `/rest/v1/sub_areas?attraction_id=in.(${chunk.join(",")})&select=id,attraction_id,name_zh,name_en,sort_order,body,cover_image_path,audio_url,is_active&order=attraction_id,sort_order`
  );
  allRows.push(...rows);
}

const byAttr = new Map();
for (const row of allRows) {
  if (!byAttr.has(row.attraction_id)) byAttr.set(row.attraction_id, []);
  byAttr.get(row.attraction_id).push(row);
}

const duplicateGroups = [];
let totalExtra = 0;

for (const [attractionId, rows] of byAttr) {
  const byName = new Map();
  const bySort = new Map();
  for (const row of rows) {
    const nk = normName(row.name_zh);
    if (!byName.has(nk)) byName.set(nk, []);
    byName.get(nk).push(row);
    const sk = String(row.sort_order);
    if (!bySort.has(sk)) bySort.set(sk, []);
    bySort.get(sk).push(row);
  }

  const dupNames = [...byName.entries()].filter(([, rs]) => rs.length > 1);
  const dupSorts = [...bySort.entries()].filter(([, rs]) => rs.length > 1);

  if (!dupNames.length && !dupSorts.length) continue;

  const toDelete = new Set();
  const keep = new Set();

  for (const [, rs] of dupNames) {
    const ranked = [...rs].sort((a, b) => scoreRow(b, canonicalIds) - scoreRow(a, canonicalIds));
    keep.add(ranked[0].id);
    for (const r of ranked.slice(1)) toDelete.add(r.id);
  }

  duplicateGroups.push({
    attractionId,
    attractionName: byAttraction[attractionId]?.chinese_name || attractionId,
    cityId: byAttraction[attractionId]?.city_id,
    totalRows: rows.length,
    duplicateByName: dupNames.map(([name, rs]) => ({
      nameZh: rs[0].name_zh,
      ids: rs.map((r) => ({
        id: r.id,
        sort_order: r.sort_order,
        canonical: canonicalIds.has(r.id),
        hasCover: Boolean(r.cover_image_path),
        hasAudio: Boolean(r.audio_url),
        bodyLen: (r.body || "").length,
        score: scoreRow(r, canonicalIds),
      })),
    })),
    duplicateBySort: dupSorts.map(([so, rs]) => ({
      sortOrder: Number(so),
      ids: rs.map((r) => r.id),
    })),
    recommendedKeep: [...keep],
    recommendedDelete: [...toDelete].filter((id) => !keep.has(id)),
  });
  totalExtra += [...toDelete].filter((id) => !keep.has(id)).length;
}

const report = {
  generatedAt: new Date().toISOString(),
  cities: CITIES,
  canonicalIdCount: canonicalIds.size,
  attractionsWithDuplicates: duplicateGroups.length,
  rowsToDelete: totalExtra,
  duplicateGroups: duplicateGroups.sort((a, b) => b.recommendedDelete.length - a.recommendedDelete.length),
};

mkdirSync(join(ROOT, "scripts/generated"), { recursive: true });
writeFileSync(OUT, JSON.stringify(report, null, 2));

console.log(
  JSON.stringify(
    {
      attractionsWithDuplicates: report.attractionsWithDuplicates,
      rowsToDelete: report.rowsToDelete,
      top: report.duplicateGroups.slice(0, 8).map((g) => ({
        attraction: g.attractionName,
        city: g.cityId,
        total: g.totalRows,
        delete: g.recommendedDelete.length,
        sampleDelete: g.recommendedDelete.slice(0, 3),
        sampleKeep: g.recommendedKeep.slice(0, 3),
      })),
    },
    null,
    2
  )
);
