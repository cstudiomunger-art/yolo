#!/usr/bin/env node
/**
 * 列出 DB 中尚无解说音频（audio_url 为空）的活跃子景点。
 */
import { mkdirSync, readFileSync, writeFileSync } from "fs";
import { join } from "path";

const ROOT = "/Users/vesperal/Desktop/YOLO";
const OUT_DIR = join(ROOT, "scripts/generated");
const OUT_MD = join(OUT_DIR, "sub_areas_missing_audio.md");
const OUT_JSON = join(OUT_DIR, "sub_areas_missing_audio.json");
const EXCLUDED_ATTRACTION_IDS = new Set(["chongqing_jiujie"]);

function readXc(k) {
  const t = readFileSync(join(ROOT, "Secrets.xcconfig"), "utf8");
  const line = t.split(/\r?\n/).find((it) => it.trim().startsWith(`${k} =`));
  return line ? line.split("=").slice(1).join("=").replace(/\$\(\)/g, "").trim() : "";
}

async function rest(path) {
  const url = process.env.SUPABASE_URL || readXc("SUPABASE_URL");
  const key =
    process.env.SUPABASE_SERVICE_ROLE_KEY ||
    process.env.SUPABASE_ANON_KEY ||
    readXc("SUPABASE_ANON_KEY");
  const res = await fetch(`${url}${path}`, {
    headers: { apikey: key, Authorization: `Bearer ${key}` },
  });
  if (!res.ok) throw new Error(`${path} -> ${res.status} ${await res.text()}`);
  return res.json();
}

async function main() {
  mkdirSync(OUT_DIR, { recursive: true });

  const attractions = await rest("/rest/v1/attractions?select=id,chinese_name,city_id");
  const cities = await rest("/rest/v1/cities?select=id,name");
  const cityById = new Map(cities.map((c) => [c.id, c.name]));
  const attrById = new Map(
    attractions.map((a) => [
      a.id,
      {
        name: a.chinese_name,
        city: cityById.get(a.city_id) || a.city_id || "未知",
      },
    ])
  );

  const subAreas = await rest(
    "/rest/v1/sub_areas?select=id,attraction_id,name_zh,name_en,sort_order,audio_url,is_active&is_active=eq.true&order=attraction_id,sort_order"
  );

  const missing = [];
  for (const row of subAreas) {
    if (EXCLUDED_ATTRACTION_IDS.has(row.attraction_id)) continue;
    const audioUrl = String(row.audio_url || "").trim();
    if (audioUrl) continue;

    const attr = attrById.get(row.attraction_id) || { name: row.attraction_id, city: "未知" };
    missing.push({
      city: attr.city,
      attractionId: row.attraction_id,
      attractionName: attr.name,
      subAreaId: row.id,
      nameZh: row.name_zh,
      nameEn: row.name_en,
      sortOrder: row.sort_order,
    });
  }

  missing.sort(
    (a, b) =>
      a.city.localeCompare(b.city, "zh-Hans-CN") ||
      a.attractionName.localeCompare(b.attractionName, "zh-Hans-CN") ||
      a.sortOrder - b.sortOrder
  );

  const byAttr = new Map();
  for (const m of missing) {
    const k = `${m.city} / ${m.attractionName}`;
    if (!byAttr.has(k)) byAttr.set(k, []);
    byAttr.get(k).push(m);
  }

  const lines = [
    "# 当前尚无解说音频的子景点",
    "",
    `生成时间：${new Date().toISOString()}`,
    "",
    `共 **${missing.length}** 条活跃子景点 \`audio_url\` 为空（已排除 chongqing_jiujie）。`,
    "",
    "## 汇总表",
    "",
    "| # | 城市 | 主景点 | 子景点 | sort |",
    "| --- | --- | --- | --- | --- |",
  ];

  missing.forEach((m, i) => {
    lines.push(`| ${i + 1} | ${m.city} | ${m.attractionName} | ${m.nameZh} | ${m.sortOrder} |`);
  });

  lines.push("", "## 按主景点分组", "");

  for (const [k, list] of [...byAttr.entries()].sort()) {
    lines.push(`### ${k}（${list.length}）`, "");
    for (const m of list) {
      lines.push(`- ${m.nameZh}${m.nameEn ? ` (${m.nameEn})` : ""}`);
    }
    lines.push("");
  }

  writeFileSync(
    OUT_JSON,
    JSON.stringify(
      {
        generatedAt: new Date().toISOString(),
        totalMissing: missing.length,
        attractionCount: byAttr.size,
        items: missing,
      },
      null,
      2
    ),
    "utf8"
  );
  writeFileSync(OUT_MD, `${lines.join("\n")}\n`, "utf8");

  console.log(`missing: ${missing.length} sub_areas across ${byAttr.size} attractions`);
  console.log(`md: ${OUT_MD}`);
  console.log(`json: ${OUT_JSON}`);
}

main().catch((e) => {
  console.error(e.message);
  process.exit(1);
});
