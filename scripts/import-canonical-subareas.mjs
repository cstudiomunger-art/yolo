#!/usr/bin/env node
/**
 * Import sub_areas from canonical format: {root}/{主景点}/NN.子景点.md + .jpg
 *
 * Usage:
 *   node scripts/import-canonical-subareas.mjs --root "/path" --city suzhou --dry-run
 *   SUPABASE_SERVICE_ROLE_KEY=... node scripts/import-canonical-subareas.mjs --root "/path" --city suzhou --apply
 */
import { createClient } from "@supabase/supabase-js";
import { existsSync, mkdirSync, readdirSync, readFileSync, statSync, writeFileSync } from "fs";
import { basename, extname, join } from "path";
import {
  buildExpectedItem,
  parseMdContent,
} from "./audit-subareas.mjs";

const ROOT = "/Users/vesperal/Desktop/YOLO";
const OUT_DIR = join(ROOT, "scripts/generated");

const FILE_RE = /^(\d{2})\.(.+)\.md$/i;

/** Folder name on disk → attractions.chinese_name (per city) */
const FOLDER_ALIASES_BY_CITY = {
  suzhou: {
    留园: "留园景区",
    沧浪亭: "沧浪亭景区",
    耦园: "耦园（又称藕园）",
    苏州环秀山庄: "环秀山庄",
  },
  shanghai: {
    徐家汇源: "徐家汇源景区",
  },
  chengdu: {
    成都熊猫基地: "大熊猫基地",
    成都大熊猫繁育研究基地: "大熊猫基地",
    熊猫基地: "大熊猫基地",
  },
};

function folderAliasesFor(cityKey) {
  return FOLDER_ALIASES_BY_CITY[cityKey] || {};
}

const args = process.argv.slice(2);
const dryRun = args.includes("--dry-run") || !args.includes("--apply");

function argValue(flag) {
  const i = args.indexOf(flag);
  return i >= 0 && args[i + 1] ? args[i + 1] : "";
}

const sourceRoot = argValue("--root");
const cityId = argValue("--city");

if (!sourceRoot || !cityId) {
  console.error("Usage: node scripts/import-canonical-subareas.mjs --root <path> --city <city_id> [--dry-run|--apply]");
  process.exit(1);
}

const OUT_CONFIRM = join(OUT_DIR, `${cityId}_canonical_subareas_confirm.md`);
const OUT_REPORT = join(OUT_DIR, `${cityId}_canonical_subareas_report.json`);
const OUT_SQL = join(OUT_DIR, `${cityId}_canonical_subareas.sql`);

function readXcconfigValue(path, key) {
  const text = readFileSync(path, "utf8");
  const line = text.split(/\r?\n/).find((it) => it.trim().startsWith(`${key} =`));
  if (!line) return "";
  return line
    .split("=")
    .slice(1)
    .join("=")
    .replace(/\$\(\)/g, "")
    .trim();
}

function loadServiceKey() {
  if (process.env.SUPABASE_SERVICE_ROLE_KEY) return process.env.SUPABASE_SERVICE_ROLE_KEY;
  const tmp = join(ROOT, ".env.local.tmp");
  try {
    const m = readFileSync(tmp, "utf8").match(/SUPABASE_SERVICE_ROLE_KEY\s*=\s*"?([^"\n]+)"?/);
    if (m?.[1]) return m[1].trim();
  } catch {
    /* optional */
  }
  return "";
}

function getSupabaseConfig() {
  const xcPath = join(ROOT, "Secrets.xcconfig");
  const url = (process.env.SUPABASE_URL || readXcconfigValue(xcPath, "SUPABASE_URL")).replace(/\$\(\)/g, "");
  const key =
    loadServiceKey() ||
    process.env.SUPABASE_ANON_KEY ||
    readXcconfigValue(xcPath, "SUPABASE_ANON_KEY");
  if (!url || !key) throw new Error("缺少 SUPABASE_URL 或 key");
  return { url, key, usesServiceRole: Boolean(loadServiceKey()) };
}

function createSupabase() {
  const { url, key } = getSupabaseConfig();
  return createClient(url, key, { auth: { persistSession: false, autoRefreshToken: false } });
}

async function rest(path, init = {}) {
  const { url, key } = getSupabaseConfig();
  let lastErr;
  for (let attempt = 0; attempt < 3; attempt += 1) {
    try {
      const res = await fetch(`${url}${path}`, {
        ...init,
        headers: { apikey: key, Authorization: `Bearer ${key}`, ...(init.headers || {}) },
      });
      if (!res.ok) throw new Error(`${path} -> ${res.status} ${await res.text()}`);
      return res;
    } catch (err) {
      lastErr = err;
      if (attempt < 2) await new Promise((r) => setTimeout(r, 1000 * (attempt + 1)));
    }
  }
  throw lastErr;
}

function sqlStr(v) {
  return v == null ? "NULL" : `'${String(v).replace(/'/g, "''")}'`;
}

function stripNameLabel(s) {
  return String(s || "")
    .replace(/^中文\s*[：:]\s*/u, "")
    .replace(/^English\s*[：:]\s*/iu, "")
    .trim();
}

function normalizeParsedNames(parsed, fallbackStem) {
  let nameZh = stripNameLabel(parsed.nameZh);
  let nameEn = stripNameLabel(parsed.nameEn);
  if (!nameZh && fallbackStem) {
    const m = fallbackStem.match(/^\d{2}\.(.+)$/);
    nameZh = m ? m[1] : fallbackStem;
  }
  return { ...parsed, nameZh, nameEn };
}

/** Extract ## 长文描述 — English-only paragraphs for sub_areas.body (Markdown). */
function cjkRatio(s) {
  const t = String(s || "");
  if (!t) return 0;
  return (t.match(/[\u4e00-\u9fff]/g) || []).length / t.length;
}

function englishFromLine(line) {
  const trimmed = String(line || "").trim();
  if (!trimmed) return "";
  let en = "";
  if (cjkRatio(trimmed) < 0.35 && /[A-Za-z]/.test(trimmed)) {
    en = trimmed;
  } else {
    const m = trimmed.match(/[A-Za-z][\s\S]*$/);
    en = m ? m[0].trim() : "";
  }
  if (!en || !/[A-Za-z]/.test(en)) return "";
  // Strip stray CJK even inside otherwise-English lines (source md typos).
  return en
    .replace(/[\u4e00-\u9fff]/g, "")
    .replace(/\s{2,}/g, " ")
    .trim();
}

function extractEnglishBodyMarkdown(mdText) {
  const start = mdText.search(/^##\s+长文描述\s*$/m);
  if (start < 0) return "";
  let section = mdText.slice(start).replace(/^##\s+长文描述\s*[\r\n]*/m, "");
  const nextSection = section.search(/^##\s+/m);
  if (nextSection >= 0) section = section.slice(0, nextSection);

  const paragraphs = [];
  let current = [];

  const flush = () => {
    if (!current.length) return;
    paragraphs.push(current.join(" "));
    current = [];
  };

  for (const raw of section.split(/\r?\n/)) {
    const en = englishFromLine(raw);
    if (!en) {
      flush();
      continue;
    }
    current.push(en);
  }
  flush();

  return paragraphs.join("\n\n").trim();
}

function toBodyMarkdown(_plainEn, mdSource = "") {
  const fromSection = extractEnglishBodyMarkdown(mdSource);
  if (fromSection) return fromSection;
  return englishFromLine(_plainEn);
}

async function uploadCover(supabase, storagePath, localPath) {
  const ext = extname(localPath).toLowerCase();
  const contentType = ext === ".png" ? "image/png" : ext === ".webp" ? "image/webp" : "image/jpeg";
  const body = readFileSync(localPath);
  let lastErr;
  for (let attempt = 0; attempt < 4; attempt += 1) {
    const { error } = await supabase.storage.from("cover-images").upload(storagePath, body, {
      upsert: true,
      contentType,
    });
    if (!error) {
      const { data } = supabase.storage.from("cover-images").getPublicUrl(storagePath);
      return data.publicUrl;
    }
    lastErr = error;
    if (attempt < 3) await new Promise((r) => setTimeout(r, 1500 * (attempt + 1)));
  }
  throw new Error(`${storagePath}: ${lastErr.message}`);
}

function listAttractionDirs(root) {
  if (!existsSync(root)) throw new Error(`源目录不存在: ${root}`);
  return readdirSync(root)
    .filter((n) => {
      try {
        return statSync(join(root, n)).isDirectory() && !n.startsWith(".");
      } catch {
        return false;
      }
    })
    .sort((a, b) => a.localeCompare(b, "zh-Hans-CN"));
}

function resolveAttractionForImport(folderName, attractions, cityKey) {
  const pool = attractions.filter((a) => !cityKey || a.city_id === cityKey);
  const candidates = [
    folderName,
    folderName.replace(/子景点信息/g, "").replace(/景点信息/g, ""),
    folderName.replace(/^成都|^上海|^重庆|^南京|^杭州|^苏州/g, ""),
  ].filter(Boolean);

  for (const guess of candidates) {
    const exact = pool.find((a) => String(a.chinese_name || "").trim() === guess);
    if (exact) return exact;
  }
  for (const guess of candidates) {
    const fuzzy = pool
      .filter((a) => {
        const cn = String(a.chinese_name || "").trim();
        return cn.includes(guess) || guess.includes(cn);
      })
      .sort((a, b) => String(b.chinese_name || "").length - String(a.chinese_name || "").length);
    if (fuzzy.length) return fuzzy[0];
  }
  return null;
}

function collectCanonical(root, cityKey, attractions) {
  const expected = [];
  const unmatchedFolders = [];
  const warnings = [];

  for (const folderName of listAttractionDirs(root)) {
    const lookupName = folderAliasesFor(cityKey)[folderName] || folderName;
    const attraction = resolveAttractionForImport(lookupName, attractions, cityKey);
    if (!attraction) {
      unmatchedFolders.push({ folderName, lookupName });
      continue;
    }

    const dirPath = join(root, folderName);
    const mdFiles = readdirSync(dirPath)
      .filter((n) => FILE_RE.test(n))
      .map((n) => {
        const m = n.match(FILE_RE);
        return { name: n, seq: parseInt(m[1], 10), stem: `${m[1]}.${m[2]}` };
      })
      .sort((a, b) => a.seq - b.seq || a.name.localeCompare(b.name, "zh-Hans-CN"));

    for (const { name: mdName, seq, stem } of mdFiles) {
      const mdPath = join(dirPath, mdName);
      const jpgPath = join(dirPath, `${stem}.jpg`);
      const hasJpg = existsSync(jpgPath);
      const localImagePath = hasJpg ? jpgPath : null;

      const mdRaw = readFileSync(mdPath, "utf8");
      const parsed = normalizeParsedNames(parseMdContent(mdRaw, { fallbackStem: stem }), stem);
      const bodyMd = toBodyMarkdown(parsed.bodyPlainEn, mdRaw);
      const sortIndex = seq - 1;

      if (!hasJpg) {
        warnings.push({ type: "missing_image", folderName, md: mdPath, nameZh: parsed.nameZh });
      }
      if (!parsed.bodyPlainEn && !extractEnglishBodyMarkdown(mdRaw)) {
        warnings.push({ type: "empty_body", folderName, md: mdPath, nameZh: parsed.nameZh });
      }

      expected.push(
        buildExpectedItem({
          city: cityKey,
          attractionFolder: folderName,
          attractionId: attraction.id,
          sortIndex,
          sourceMdPath: mdPath,
          parsed: { ...parsed, bodyHtml: bodyMd },
          localImagePath,
          localImageName: hasJpg ? `${stem}.jpg` : null,
        })
      );
    }
  }

  return { expected, unmatchedFolders, warnings };
}

function buildConfirmListMarkdown(items, attractionsById) {
  const lines = [
    `# ${cityId} 子景点 canonical 导入确认清单`,
    "",
    `生成时间：${new Date().toISOString()}`,
    `源目录：\`${sourceRoot}\``,
    `总条数：${items.length}`,
    "",
    "> 请核对主景点映射、中英文名、正文与图片配对。确认无误后运行 `--apply`。",
    "",
  ];

  let seq = 0;
  let lastAttraction = "";
  for (const item of items) {
    const attr = attractionsById.get(item.attractionId);
    const attrName = attr?.chinese_name || item.attractionId;
    if (attrName !== lastAttraction) {
      lastAttraction = attrName;
      lines.push(`## ${attrName}（${item.attractionId}）`, "");
      if (item.attractionFolder !== attrName) {
        lines.push(`- 文件夹名：\`${item.attractionFolder}\` → DB：\`${attrName}\``, "");
      }
    }
    seq += 1;
    const srcRel = item.sourceMdPath.replace(/^\/Users\/vesperal\/Desktop\//, "");
    lines.push(`### ${seq}. ${item.nameZh}`);
    lines.push(`- 来源 md：\`${srcRel}\``);
    lines.push(`- 配对图片：${item.localImageName ? `\`${item.localImageName}\`` : "（无）"}`);
    lines.push(`- sub_area id：\`${item.id}\``);
    lines.push(`- sort_order：${item.sortIndex}`);
    lines.push(`- **中文名**：${item.nameZh}`);
    lines.push(`- **英文名**：${item.nameEn || "（空）"}`);
    lines.push(`- **正文（英文）**：`);
    if (item.bodyPlainEn) {
      lines.push("");
      lines.push("```");
      lines.push(item.bodyPlainEn);
      lines.push("```");
    } else {
      lines.push("");
      lines.push("（空）");
    }
    lines.push("");
  }
  return lines.join("\n");
}

function buildUpsertSql(rows) {
  const values = rows.map(
    (r) =>
      `(${sqlStr(r.id)}, ${sqlStr(r.attractionId)}, ${sqlStr(r.nameEn || "")}, ${sqlStr(r.nameZh)}, ${sqlStr(r.bodyHtml)}, ${sqlStr(r.cover || "")}, ${r.sortOrder})`
  );
  return `-- Generated from canonical sub-area folders (${cityId})
-- audio_url is intentionally NOT updated
-- body is English-only Markdown from ## 长文描述 (no HTML, no Chinese)
INSERT INTO sub_areas (id, attraction_id, name_en, name_zh, body, cover_image_path, sort_order, is_active)
VALUES
  ${values.join(",\n  ")}
ON CONFLICT (id) DO UPDATE SET
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  cover_image_path = COALESCE(NULLIF(EXCLUDED.cover_image_path, ''), sub_areas.cover_image_path),
  sort_order = EXCLUDED.sort_order,
  is_active = TRUE,
  updated_at = NOW();
`;
}

async function applyDatabase(rows) {
  const supabase = createSupabase();
  const payload = rows.map((r) => ({
    id: r.id,
    attraction_id: r.attractionId,
    name_en: r.nameEn || "",
    name_zh: r.nameZh,
    body: r.bodyHtml || "",
    cover_image_path: r.cover || null,
    sort_order: r.sortOrder,
    is_active: true,
  }));

  const batchSize = 50;
  for (let i = 0; i < payload.length; i += batchSize) {
    const batch = payload.slice(i, i + batchSize);
    const { error } = await supabase.from("sub_areas").upsert(batch, { onConflict: "id" });
    if (error) throw new Error(`upsert batch ${i}: ${error.message}`);
    console.log(`  upserted ${Math.min(i + batchSize, payload.length)}/${payload.length}`);
  }
}

async function main() {
  mkdirSync(OUT_DIR, { recursive: true });

  const attractions = await (await rest(`/rest/v1/attractions?select=id,chinese_name,city_id&city_id=eq.${cityId}`)).json();

  const { expected, unmatchedFolders, warnings: collectWarnings } = collectCanonical(
    sourceRoot,
    cityId,
    attractions
  );

  const warnings = [...collectWarnings];
  const rows = [];
  const reportItems = [];

  const supabase = createSupabase();
  const { usesServiceRole } = getSupabaseConfig();
  if (!dryRun && !usesServiceRole) {
    throw new Error(
      "缺少 SUPABASE_SERVICE_ROLE_KEY：--apply 需 service role 才能上传封面并写库（anon key 会因 RLS 失败）"
    );
  }

  for (const exp of expected) {
    if (!exp.nameZh) warnings.push({ type: "empty_name_zh", id: exp.id, md: exp.sourceMdPath });
    if (!exp.nameEn) warnings.push({ type: "empty_name_en", id: exp.id, md: exp.sourceMdPath, nameZh: exp.nameZh });

    let cover = "";
    let coverSource = "";
    if (!dryRun && exp.localImagePath) {
      const storagePath = `sub-areas/all/${exp.id}${extname(exp.localImagePath).toLowerCase()}`;
      cover = await uploadCover(supabase, storagePath, exp.localImagePath);
      coverSource = "uploaded";
    }

    rows.push({
      id: exp.id,
      attractionId: exp.attractionId,
      sortOrder: exp.sortIndex,
      nameEn: exp.nameEn,
      nameZh: exp.nameZh,
      bodyHtml: exp.bodyHtml,
      cover,
    });

    reportItems.push({
      id: exp.id,
      city: exp.city,
      attractionId: exp.attractionId,
      attractionFolder: exp.attractionFolder,
      sortOrder: exp.sortIndex,
      nameZh: exp.nameZh,
      nameEn: exp.nameEn,
      bodyPlainEn: exp.bodyPlainEn,
      bodyHtml: exp.bodyHtml,
      mdFieldSources: exp.mdFieldSources,
      sourceMdPath: exp.sourceMdPath,
      localImageName: exp.localImageName,
      localImagePath: exp.localImagePath,
      coverSource,
    });
  }

  const attractionsById = new Map(attractions.map((a) => [a.id, a]));
  const confirmMd = buildConfirmListMarkdown(expected, attractionsById);

  const report = {
    generatedAt: new Date().toISOString(),
    mode: dryRun ? "dry-run" : "apply",
    sourceRoot,
    cityId,
    folderAliases: folderAliasesFor(cityId),
    stats: {
      totalRows: expected.length,
      attractionFolders: new Set(expected.map((e) => e.attractionFolder)).size,
      missingImages: warnings.filter((w) => w.type === "missing_image").length,
      emptyBody: warnings.filter((w) => w.type === "empty_body").length,
      emptyNameEn: warnings.filter((w) => w.type === "empty_name_en").length,
      unmatchedFolders: unmatchedFolders.length,
    },
    unmatchedFolders,
    warnings,
    items: reportItems,
  };

  writeFileSync(OUT_CONFIRM, confirmMd, "utf8");
  writeFileSync(OUT_REPORT, JSON.stringify(report, null, 2), "utf8");
  writeFileSync(OUT_SQL, buildUpsertSql(rows), "utf8");

  console.log(JSON.stringify(report.stats, null, 2));
  if (unmatchedFolders.length) console.log("unmatchedFolders:", unmatchedFolders);
  console.log(`Confirm list: ${OUT_CONFIRM}`);
  console.log(`Report: ${OUT_REPORT}`);
  console.log(`Upsert SQL: ${OUT_SQL}`);

  if (dryRun) {
    console.log("\n[dry-run] 未上传图片、未写库。核对 confirm 后运行 --apply");
  } else {
    console.log("\n[apply] 图片已上传，开始写库…");
    await applyDatabase(rows);
    console.log(`[apply] 完成：UPSERT ${rows.length} 条（audio_url 未触碰）`);
  }
}

main().catch((err) => {
  console.error(err.message || err);
  process.exit(1);
});
