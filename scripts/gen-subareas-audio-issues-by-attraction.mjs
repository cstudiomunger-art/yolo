#!/usr/bin/env node
/**
 * 按主景点汇总：尚无音频 / 音频未正确匹配的子景点与源音频。
 */
import { mkdirSync, readFileSync, readdirSync, statSync, writeFileSync } from "fs";
import { join } from "path";

const ROOT = "/Users/vesperal/Desktop/YOLO";
const SOURCE_BENEDICT = "/Users/vesperal/Downloads/全量英文解说音频_Benedict";
const OUT_DIR = join(ROOT, "scripts/generated");
const OUT_MD = join(OUT_DIR, "sub_areas_audio_issues_by_attraction.md");
const OUT_JSON = join(OUT_DIR, "sub_areas_audio_issues_by_attraction.json");
const EXCLUDED = new Set(["chongqing_jiujie"]);

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

function onlyDirs(path) {
  return readdirSync(path).filter((n) => statSync(join(path, n)).isDirectory());
}

function resolveScenicFolder(scenic, attractions) {
  const guess = ATTRACTION_ALIASES[scenic] || scenic;
  const hit =
    attractions.find((a) => String(a.chinese_name || "").trim() === guess) ||
    attractions.find(
      (a) =>
        String(a.chinese_name || "").includes(guess) ||
        guess.includes(String(a.chinese_name || "").trim())
    );
  return hit?.id || null;
}

function buildBenedictFolderMap(attractions) {
  const map = new Map(); // attractionId -> { city, folder }
  if (!statSync(SOURCE_BENEDICT, { throwIfNoEntry: false })) return map;
  for (const city of onlyDirs(SOURCE_BENEDICT)) {
    for (const scenic of onlyDirs(join(SOURCE_BENEDICT, city))) {
      const id = resolveScenicFolder(scenic, attractions);
      if (id) map.set(id, { city, folder: scenic });
    }
  }
  return map;
}

async function main() {
  mkdirSync(OUT_DIR, { recursive: true });

  const attractions = await rest("/rest/v1/attractions?select=id,chinese_name,city_id");
  const cities = await rest("/rest/v1/cities?select=id,name");
  const cityById = new Map(cities.map((c) => [c.id, c.name]));
  const attrById = new Map(
    attractions.map((a) => [a.id, { name: a.chinese_name, city: cityById.get(a.city_id) || "未知" }])
  );

  const subAreas = await rest(
    "/rest/v1/sub_areas?select=id,attraction_id,name_zh,audio_url,sort_order,is_active&is_active=eq.true&order=attraction_id,sort_order"
  );

  const finalReportPath = join(OUT_DIR, "sub_areas_audio_final_report.json");
  const finalReport = JSON.parse(readFileSync(finalReportPath, "utf8"));
  const bindingsById = new Map((finalReport.bindings || []).map((b) => [b.subAreaId, b]));

  const benedictMap = buildBenedictFolderMap(attractions);

  const byAttr = new Map();

  function ensure(attrId) {
    if (!byAttr.has(attrId)) {
      const a = attrById.get(attrId) || { name: attrId, city: "未知" };
      const ben = benedictMap.get(attrId);
      byAttr.set(attrId, {
        city: a.city,
        attractionId: attrId,
        attractionName: a.name,
        benedictFolder: ben ? `${ben.city}/${ben.folder}` : null,
        missingSubAreas: [],
        wrongBindingSubAreas: [],
        unmatchedAudio: [],
        ambiguousAudio: [],
      });
    }
    return byAttr.get(attrId);
  }

  for (const row of subAreas) {
    if (EXCLUDED.has(row.attraction_id)) continue;
    const audioUrl = String(row.audio_url || "").trim();
    const entry = ensure(row.attraction_id);

    if (!audioUrl) {
      entry.missingSubAreas.push(row.name_zh);
      continue;
    }

    const expected = bindingsById.get(row.id);
    if (expected && expected.audioUrl !== audioUrl) {
      entry.wrongBindingSubAreas.push({
        nameZh: row.name_zh,
        current: audioUrl.split("/").pop(),
        expected: expected.fileKey,
      });
    }
  }

  for (const u of finalReport.unmatched || []) {
    const id = resolveScenicFolder(u.scenic, attractions);
    if (!id || EXCLUDED.has(id)) continue;
    ensure(id).unmatchedAudio.push({
      type: "未匹配",
      file: u.sourceFile,
      title: u.hint,
      storageKey: u.fileKey,
    });
  }

  for (const u of finalReport.ambiguous || []) {
    const id = resolveScenicFolder(u.scenic, attractions);
    if (!id || EXCLUDED.has(id)) continue;
    ensure(id).ambiguousAudio.push({
      type: "歧义",
      file: u.sourceFile,
      title: u.hint,
      storageKey: u.fileKey,
      candidates: (u.candidates || []).map((c) => c.nameZh),
    });
  }

  const issues = [...byAttr.values()]
    .filter(
      (a) =>
        a.missingSubAreas.length ||
        a.wrongBindingSubAreas.length ||
        a.unmatchedAudio.length ||
        a.ambiguousAudio.length
    )
    .sort(
      (a, b) =>
        a.city.localeCompare(b.city, "zh-Hans-CN") ||
        a.attractionName.localeCompare(b.attractionName, "zh-Hans-CN")
    );

  const lines = [
    "# 音频未正确匹配 / 缺失 — 按主景点汇总",
    "",
    `生成时间：${new Date().toISOString()}`,
    "",
    "包含三类问题：",
    "1. **缺音频** — DB 子景点 `audio_url` 为空",
    "2. **未匹配** — Benedict 源音频未能绑定到子景点",
    "3. **歧义** — 有多个候选子景点，未自动写入",
    "",
    `共 **${issues.length}** 个主景点存在问题。`,
    "",
    "## 主景点一览",
    "",
    "| # | 城市 | 主景点 | 缺音频 | 未匹配音频 | 歧义音频 | DB与脚本不一致 |",
    "| --- | --- | --- | --- | --- | --- | --- |",
  ];

  issues.forEach((a, i) => {
    lines.push(
      `| ${i + 1} | ${a.city} | ${a.attractionName} | ${a.missingSubAreas.length} | ${a.unmatchedAudio.length} | ${a.ambiguousAudio.length} | ${a.wrongBindingSubAreas.length} |`
    );
  });

  lines.push("", "## 详情", "");

  for (const a of issues) {
    const parts = [];
    if (a.missingSubAreas.length) parts.push(`缺音频 ${a.missingSubAreas.length}`);
    if (a.unmatchedAudio.length) parts.push(`未匹配 ${a.unmatchedAudio.length}`);
    if (a.ambiguousAudio.length) parts.push(`歧义 ${a.ambiguousAudio.length}`);
    if (a.wrongBindingSubAreas.length) parts.push(`绑定不一致 ${a.wrongBindingSubAreas.length}`);

    lines.push(`### ${a.city} / ${a.attractionName}`, "");
    lines.push(`- attraction_id: \`${a.attractionId}\``);
    if (a.benedictFolder) lines.push(`- Benedict 目录: \`${a.benedictFolder}\``);
    lines.push(`- 问题: ${parts.join("，")}`);
    lines.push("");

    if (a.missingSubAreas.length) {
      lines.push("**缺音频的子景点：**", "");
      for (const n of a.missingSubAreas) lines.push(`- ${n}`);
      lines.push("");
    }

    if (a.unmatchedAudio.length) {
      lines.push("**未正确匹配的源音频：**", "");
      for (const u of a.unmatchedAudio) {
        lines.push(`- \`${u.file}\` — ${u.title}`);
      }
      lines.push("");
    }

    if (a.ambiguousAudio.length) {
      lines.push("**歧义源音频（需人工选子景点）：**", "");
      for (const u of a.ambiguousAudio) {
        lines.push(`- \`${u.file}\` — ${u.title}`);
        lines.push(`  - 候选: ${u.candidates.join(" / ")}`);
      }
      lines.push("");
    }

    if (a.wrongBindingSubAreas.length) {
      lines.push("**DB 与脚本绑定不一致的子景点：**", "");
      for (const w of a.wrongBindingSubAreas) {
        lines.push(`- ${w.nameZh}：当前 \`${w.current}\`，脚本期望 \`${w.expected}\``);
      }
      lines.push("");
    }
  }

  writeFileSync(
    OUT_JSON,
    JSON.stringify({ generatedAt: new Date().toISOString(), count: issues.length, attractions: issues }, null, 2),
    "utf8"
  );
  writeFileSync(OUT_MD, `${lines.join("\n")}\n`, "utf8");

  console.log(`attractions with issues: ${issues.length}`);
  console.log(`md: ${OUT_MD}`);
  console.log(`json: ${OUT_JSON}`);
}

main().catch((e) => {
  console.error(e.message);
  process.exit(1);
});
