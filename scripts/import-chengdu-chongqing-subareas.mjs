#!/usr/bin/env node
/**
 * Import Chengdu + Chongqing sub_areas from Desktop folders.
 * Usage:
 *   node import-chengdu-chongqing-subareas.mjs --dry-run
 *   node import-chengdu-chongqing-subareas.mjs --apply
 */
import { createClient } from "@supabase/supabase-js";
import { existsSync, mkdirSync, readdirSync, readFileSync, writeFileSync } from "fs";
import { basename, extname, join } from "path";
import {
  buildExpectedItem,
  collectChengdu,
  collectChongqing,
  findImage,
  isValidAttractionRecord,
  listImages,
  parseImageMeta,
  parseMdContent,
  resolveAttraction,
} from "./audit-subareas.mjs";

const ROOT = "/Users/vesperal/Desktop/YOLO";
const CHENGDU_ROOT = "/Users/vesperal/Desktop/成都子景点";
const CHONGQING_ROOT = "/Users/vesperal/Desktop/重庆子景点";
const OUT_DIR = join(ROOT, "scripts/generated");
const OUT_CONFIRM = join(OUT_DIR, "chengdu_chongqing_sub_areas_confirm_list.md");
const OUT_REPORT = join(OUT_DIR, "chengdu_chongqing_sub_areas_report.json");
const OUT_SQL = join(OUT_DIR, "chengdu_chongqing_sub_areas_upsert.sql");
const OUT_DELETE_SQL = join(OUT_DIR, "chengdu_chongqing_sub_areas_delete_extra.sql");

const SKIP_ATTRACTION_IDS = new Set(["chongqing_jiujie"]);

const args = process.argv.slice(2);
const dryRun = args.includes("--dry-run") || !args.includes("--apply");

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

function getSupabaseConfig() {
  const xcPath = join(ROOT, "Secrets.xcconfig");
  const url = (process.env.SUPABASE_URL || readXcconfigValue(xcPath, "SUPABASE_URL")).replace(/\$\(\)/g, "");
  const key =
    process.env.SUPABASE_SERVICE_ROLE_KEY ||
    process.env.SUPABASE_ANON_KEY ||
    readXcconfigValue(xcPath, "SUPABASE_ANON_KEY");
  if (!url || !key) throw new Error("缺少 SUPABASE_URL 或 key");
  return { url, key, usesServiceRole: Boolean(process.env.SUPABASE_SERVICE_ROLE_KEY) };
}

function createSupabase() {
  const { url, key } = getSupabaseConfig();
  return createClient(url, key, { auth: { persistSession: false, autoRefreshToken: false } });
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

function sqlStr(v) {
  return v == null ? "NULL" : `'${String(v).replace(/'/g, "''")}'`;
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

const PANDA_ATTRACTION_NAME_ZH = "大熊猫基地";

function collectPandaFallback(expected, unmatchedFolders, allAttractions) {
  const idx = unmatchedFolders.findIndex((u) => u.folderName === "成都熊猫基地");
  if (idx < 0) return;

  const panda = allAttractions.find((a) => String(a.chinese_name || "").trim() === PANDA_ATTRACTION_NAME_ZH);
  if (!panda) return;

  unmatchedFolders.splice(idx, 1);

  const mdDir = join(CHENGDU_ROOT, "成都子景点-信息", "成都熊猫基地");
  const imageDir = join(CHENGDU_ROOT, "成都熊猫基地");
  if (!existsSync(mdDir)) return;

  const images = listImages(imageDir);
  const mdFiles = readdirSync(mdDir).filter((n) => n.endsWith(".md")).map((n) => join(mdDir, n));
  const items = mdFiles.map((mdPath) => {
    const stem = basename(mdPath, ".md");
    const parsed = parseMdContent(readFileSync(mdPath, "utf8"), { fallbackStem: stem });
    const img = findImage(images, stem, parsed.nameZh);
    return { mdPath, parsed, img };
  });
  items.sort(
    (a, b) =>
      (a.img ? a.img.order : parseImageMeta(basename(a.mdPath, ".md")).order) -
        (b.img ? b.img.order : parseImageMeta(basename(b.mdPath, ".md")).order) ||
      basename(a.mdPath).localeCompare(basename(b.mdPath), "zh-Hans-CN")
  );

  items.forEach(({ mdPath, parsed, img }, sortIndex) => {
    expected.push(
      buildExpectedItem({
        city: "chengdu",
        attractionFolder: "成都熊猫基地",
        attractionId: panda.id,
        sortIndex,
        sourceMdPath: mdPath,
        parsed,
        localImagePath: img?.file || null,
        localImageName: img?.name || null,
      })
    );
  });
}

function collectExpected(allAttractions) {
  const validAttractions = allAttractions.filter(isValidAttractionRecord);
  const expected = [];
  const unmatchedFolders = [];
  collectChengdu("chengdu", CHENGDU_ROOT, validAttractions, expected, unmatchedFolders);
  collectChongqing("chongqing", CHONGQING_ROOT, validAttractions, expected, unmatchedFolders);
  collectPandaFallback(expected, unmatchedFolders, allAttractions);
  return {
    expected: expected.filter((e) => !SKIP_ATTRACTION_IDS.has(e.attractionId)),
    unmatchedFolders,
  };
}

function buildConfirmListMarkdown(items, attractionsById) {
  const lines = [
    "# 成都/重庆子景点 md 内容确认清单",
    "",
    `生成时间：${new Date().toISOString()}`,
    `总条数：${items.length}`,
    "",
    "> 请核对每条的中文名、英文名、正文（英文长文）及解析来源。确认无误后回复「内容确认无误」。",
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
    }
    seq += 1;
    const srcRel = item.sourceMdPath.replace(/^\/Users\/vesperal\/Desktop\//, "");
    lines.push(`### ${seq}. ${item.nameZh}`);
    lines.push(`- 来源 md：\`${srcRel}\``);
    lines.push(`- 配对图片：${item.localImageName ? `\`${item.localImageName}\`` : "（无）"}`);
    lines.push(`- sub_area id：\`${item.id}\``);
    lines.push(`- 解析来源（名称）：${item.mdFieldSources?.name || "—"}`);
    lines.push(`- 解析来源（正文）：${item.mdFieldSources?.body || "—"}`);
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
      lines.push("（空 — 需确认 md 是否缺少英文长文）");
    }
    lines.push("");
  }
  return lines.join("\n");
}

function buildUpsertSql(rows) {
  const values = rows.map(
    (r) =>
      `(${sqlStr(r.attractionId)}, ${r.sortOrder}, ${sqlStr(r.nameEn || "")}, ${sqlStr(r.nameZh)}, ${sqlStr(r.bodyHtml)}, ${sqlStr(r.cover || "")})`
  );
  return `-- Generated from Desktop 成都/重庆子景点 folders
WITH input_rows(attraction_id, sort_order, name_en, name_zh, body, cover_image_path) AS (
  VALUES
  ${values.join(",\n  ")}
), mapped_rows AS (
  SELECT
    CONCAT(i.attraction_id, '_sa_', LPAD((i.sort_order + 1)::text, 2, '0')) AS id,
    i.attraction_id,
    i.name_en,
    i.name_zh,
    i.body,
    NULLIF(i.cover_image_path, '') AS cover_image_path,
    i.sort_order
  FROM input_rows i
)
INSERT INTO sub_areas (id, attraction_id, name_en, name_zh, body, cover_image_path, sort_order, is_active)
SELECT id, attraction_id, name_en, name_zh, body, cover_image_path, sort_order, TRUE FROM mapped_rows
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

function buildDeleteSql(scopeAttractionIds, keepIds) {
  const ids = [...keepIds].map((id) => sqlStr(id)).join(", ");
  const attrs = [...scopeAttractionIds]
    .filter((id) => id !== "chongqing_jiujie")
    .map((id) => sqlStr(id))
    .join(", ");
  return `-- Delete sub_areas not in the new import set (九街 excluded from scope)
DELETE FROM sub_areas
WHERE attraction_id IN (${attrs})
  AND id NOT IN (${ids});
`;
}

async function main() {
  mkdirSync(OUT_DIR, { recursive: true });

  const attractions = await (await rest("/rest/v1/attractions?select=id,chinese_name,city_id")).json();
  const validAttractions = attractions.filter(isValidAttractionRecord);

  const { expected, unmatchedFolders } = collectExpected(attractions);

  const scopeAttractionIds = new Set(expected.map((e) => e.attractionId));
  const keepIds = new Set(expected.map((e) => e.id));

  let existingSubAreas = [];
  if (scopeAttractionIds.size) {
    const ids = [...scopeAttractionIds].join(",");
    existingSubAreas = await (
      await rest(`/rest/v1/sub_areas?select=id,attraction_id,name_zh&attraction_id=in.(${ids})`)
    ).json();
  }

  const toDelete = existingSubAreas.filter(
    (r) => !keepIds.has(r.id) && r.attraction_id !== "chongqing_jiujie"
  );

  const warnings = [];
  const rows = [];
  const reportItems = [];

  const supabase = createSupabase();
  const { usesServiceRole } = getSupabaseConfig();
  if (!dryRun && !usesServiceRole) {
    console.warn("警告: 未设置 SUPABASE_SERVICE_ROLE_KEY，上传/写库可能因 RLS 失败");
  }

  for (const exp of expected) {
    if (!exp.nameZh) warnings.push({ type: "empty_name_zh", id: exp.id, md: exp.sourceMdPath });
    if (!exp.nameEn) warnings.push({ type: "empty_name_en", id: exp.id, md: exp.sourceMdPath, nameZh: exp.nameZh });
    if (!exp.bodyPlainEn) warnings.push({ type: "empty_body", id: exp.id, md: exp.sourceMdPath, nameZh: exp.nameZh });
    if (!exp.localImagePath) warnings.push({ type: "missing_image", id: exp.id, md: exp.sourceMdPath, nameZh: exp.nameZh });

    let cover = "";
    let coverSource = "";
    if (!dryRun && exp.localImagePath) {
      const storagePath = `sub-areas/all/${exp.id}${extname(exp.localImagePath).toLowerCase()}`;
      cover = await uploadCover(supabase, storagePath, exp.localImagePath);
      coverSource = "uploaded";
    }

    rows.push({
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
    sources: { chengdu: CHENGDU_ROOT, chongqing: CHONGQING_ROOT },
    stats: {
      totalRows: expected.length,
      chengduRows: expected.filter((e) => e.city === "chengdu").length,
      chongqingRows: expected.filter((e) => e.city === "chongqing").length,
      missingImages: warnings.filter((w) => w.type === "missing_image").length,
      emptyBody: warnings.filter((w) => w.type === "empty_body").length,
      emptyNameEn: warnings.filter((w) => w.type === "empty_name_en").length,
      toDeleteCount: toDelete.length,
    },
    unmatchedFolders,
    warnings,
    toDelete,
    items: reportItems,
  };

  writeFileSync(OUT_CONFIRM, confirmMd, "utf8");
  writeFileSync(OUT_REPORT, JSON.stringify(report, null, 2), "utf8");
  writeFileSync(OUT_SQL, buildUpsertSql(rows), "utf8");
  writeFileSync(OUT_DELETE_SQL, buildDeleteSql(scopeAttractionIds, keepIds), "utf8");

  console.log(JSON.stringify(report.stats, null, 2));
  if (unmatchedFolders.length) console.log("unmatchedFolders:", unmatchedFolders);
  console.log(`Confirm list: ${OUT_CONFIRM}`);
  console.log(`Report: ${OUT_REPORT}`);
  console.log(`Upsert SQL: ${OUT_SQL}`);
  console.log(`Delete SQL: ${OUT_DELETE_SQL}`);
  if (dryRun) {
    console.log("\n[dry-run] 未上传图片、未写库。请核对 confirm_list 后运行 --apply");
  } else {
    console.log("\n[apply] 图片已上传，开始写库…");
    await applyDatabase(rows, toDelete);
    console.log("[apply] 完成：UPSERT + DELETE 已执行");
  }
}

async function applyDatabase(rows, toDelete) {
  const supabase = createSupabase();
  const payload = rows.map((r) => ({
    id: `${r.attractionId}_sa_${String(r.sortOrder + 1).padStart(2, "0")}`,
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

  if (toDelete.length) {
    const deleteIds = toDelete.map((r) => r.id);
    for (let i = 0; i < deleteIds.length; i += batchSize) {
      const batch = deleteIds.slice(i, i + batchSize);
      const { error } = await supabase.from("sub_areas").delete().in("id", batch);
      if (error) throw new Error(`delete batch ${i}: ${error.message}`);
      console.log(`  deleted ${Math.min(i + batchSize, deleteIds.length)}/${deleteIds.length}`);
    }
  }
}

main().catch((err) => {
  console.error(err.message || err);
  process.exit(1);
});
