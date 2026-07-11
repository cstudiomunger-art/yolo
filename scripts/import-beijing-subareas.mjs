#!/usr/bin/env node
import { createClient } from "@supabase/supabase-js";
import { mkdirSync, readFileSync, readdirSync, statSync, writeFileSync } from "fs";
import { join, extname, basename } from "path";

const SOURCE_ROOT = "/Users/vesperal/Desktop/北京子景点内容";
const OUTPUT_SQL = "/Users/vesperal/Desktop/YOLO/scripts/generated/beijing_sub_areas_upsert.sql";
const OUTPUT_REPORT = "/Users/vesperal/Desktop/YOLO/scripts/generated/beijing_sub_areas_report.json";
const BUCKET = "cover-images";
const NAME_ALIASES = {
  国家博物馆: "国博",
};

function readXcconfigValue(path, key) {
  const text = readFileSync(path, "utf8");
  const line = text
    .split(/\r?\n/)
    .find((it) => it.trim().startsWith(`${key} =`));
  if (!line) return "";
  return line
    .split("=")
    .slice(1)
    .join("=")
    .replace(/\$\(\)/g, "")
    .trim();
}

function getSupabaseConfig() {
  const xcPath = "/Users/vesperal/Desktop/YOLO/Secrets.xcconfig";
  const url = process.env.SUPABASE_URL || readXcconfigValue(xcPath, "SUPABASE_URL");
  const key =
    process.env.SUPABASE_SERVICE_ROLE_KEY ||
    process.env.SUPABASE_ANON_KEY ||
    readXcconfigValue(xcPath, "SUPABASE_ANON_KEY");
  if (!url || !key) {
    throw new Error("缺少 SUPABASE_URL 或可用 key（建议提供 SUPABASE_SERVICE_ROLE_KEY）");
  }
  const usesServiceRole = Boolean(process.env.SUPABASE_SERVICE_ROLE_KEY);
  return { url, key, usesServiceRole };
}

function sqlStr(value) {
  if (value == null) return "NULL";
  return `'${String(value).replace(/'/g, "''")}'`;
}

function toMarkdown(content) {
  return String(content || "").trim();
}

function normalizeSeq(raw) {
  if (!raw) return "";
  const parts = String(raw)
    .replace(/[_.]/g, "-")
    .split("-")
    .map((it) => it.trim())
    .filter(Boolean)
    .map((it) => String(parseInt(it, 10)));
  return parts.join("-");
}

function parseSections(mdText) {
  const lines = mdText.split(/\r?\n/);
  const sections = [];
  let current = null;
  for (const line of lines) {
    const m = line.match(/^###\s*([0-9]{1,2}(?:[-_.][0-9]{1,2})?)\s*[.、\-_)\s]*\s*(.+)\s*$/);
    if (m) {
      if (current) sections.push(current);
      current = {
        seqRaw: m[1],
        seq: normalizeSeq(m[1]),
        title: m[2].trim(),
        bodyLines: [],
      };
      continue;
    }
    if (current) current.bodyLines.push(line);
  }
  if (current) sections.push(current);
  return sections.map((s, index) => ({
    ...s,
    order: index,
    bodyMarkdown: s.bodyLines.join("\n").trim(),
    bodyHtml: toMarkdown(s.bodyLines.join("\n")),
  }));
}

function parseImageSeq(fileName) {
  const stem = basename(fileName, extname(fileName)).trim();
  const m = stem.match(/^([0-9]{1,2}(?:[-_.][0-9]{1,2})?)/);
  if (!m) return "";
  return normalizeSeq(m[1]);
}

function sanitizeNameEn(nameZh, index) {
  const ascii = String(nameZh)
    .toLowerCase()
    .normalize("NFD")
    .replace(/[̀-ͯ]/g, "")
    .replace(/[^a-z0-9]+/g, " ")
    .trim();
  if (ascii) return ascii.replace(/\s+/g, " ");
  return `Sub Area ${index + 1}`;
}

function buildSql(rows) {
  const lines = [
    "-- Beijing sub_areas seed (generated)",
    "-- cover_image_path is full public URL from Supabase Storage",
    "",
  ];
  for (const row of rows) {
    lines.push(`INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  ${sqlStr(row.id)},
  ${sqlStr(row.attraction_id)},
  ${sqlStr(row.name_en)},
  ${sqlStr(row.name_zh)},
  ${sqlStr(row.cover_image_path)},
  ${sqlStr(row.body)},
  '',
  ${row.sort_order},
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();
`);
  }
  return lines.join("\n");
}

async function main() {
  const { url, key, usesServiceRole } = getSupabaseConfig();
  const supabase = createClient(url, key);

  const folders = readdirSync(SOURCE_ROOT).filter((name) => {
    const full = join(SOURCE_ROOT, name);
    return statSync(full).isDirectory();
  });

  const { data: attractions, error: attractionsError } = await supabase
    .from("attractions")
    .select("id,chinese_name");
  if (attractionsError) throw new Error(`读取 attractions 失败: ${attractionsError.message}`);

  const attractionMap = new Map(attractions.map((a) => [String(a.chinese_name || "").trim(), a]));
  const missingParents = [];
  const unmatchedImages = [];
  const rows = [];
  const reportItems = [];

  for (const folderName of folders) {
    const folderPath = join(SOURCE_ROOT, folderName);
    const mdFile = readdirSync(folderPath).find((n) => n.toLowerCase().endsWith(".md"));
    if (!mdFile) {
      reportItems.push({ folderName, skipped: true, reason: "缺少 md 文件" });
      continue;
    }

    const folderKey = folderName.trim();
    let parent = attractionMap.get(folderKey);
    if (!parent && NAME_ALIASES[folderKey]) {
      parent = attractionMap.get(NAME_ALIASES[folderKey]);
    }
    if (!parent) {
      parent = attractions.find((a) => {
        const target = String(a.chinese_name || "").trim();
        return target.includes(folderKey) || folderKey.includes(target);
      });
    }
    if (!parent) {
      missingParents.push(folderName);
      continue;
    }

    const mdText = readFileSync(join(folderPath, mdFile), "utf8");
    const sections = parseSections(mdText);
    const imageFiles = readdirSync(folderPath).filter((n) => {
      const e = extname(n).toLowerCase();
      return e === ".png" || e === ".jpg" || e === ".jpeg" || e === ".webp";
    });
    const imageBySeq = new Map();
    for (const img of imageFiles) {
      const seq = parseImageSeq(img);
      if (seq && !imageBySeq.has(seq)) imageBySeq.set(seq, img);
    }

    const folderReport = { folderName, attractionId: parent.id, subAreas: [] };

    for (const section of sections) {
      const subAreaId = `${parent.id}_bj_sa_${String(section.order + 1).padStart(2, "0")}`;
      let imageFile = imageBySeq.get(section.seq) || imageFiles[section.order] || "";
      let coverUrl = "";

      if (!imageFile) {
        unmatchedImages.push(`${folderName}#${section.seqRaw}-${section.title}`);
      } else {
        const imagePath = join(folderPath, imageFile);
        const body = readFileSync(imagePath);
        const ext = extname(imageFile).toLowerCase().replace(".", "") || "jpg";
        const storagePath = `sub-areas/beijing/${subAreaId}.${ext}`;
        const contentType = ext === "png" ? "image/png" : ext === "webp" ? "image/webp" : "image/jpeg";
        const { error: upErr } = await supabase.storage.from(BUCKET).upload(storagePath, body, {
          upsert: true,
          contentType,
        });
        if (upErr) throw new Error(`上传失败 ${imageFile}: ${upErr.message}`);
        const { data } = supabase.storage.from(BUCKET).getPublicUrl(storagePath);
        coverUrl = data.publicUrl;
      }

      const row = {
        id: subAreaId,
        attraction_id: parent.id,
        name_en: sanitizeNameEn(section.title, section.order),
        name_zh: section.title,
        cover_image_path: coverUrl || null,
        body: section.bodyHtml,
        sort_order: section.order,
      };
      rows.push(row);
      folderReport.subAreas.push({
        id: subAreaId,
        seq: section.seqRaw,
        title: section.title,
        imageFile: imageFile || null,
        coverUrl: coverUrl || null,
      });
    }

    reportItems.push(folderReport);
  }

  if (missingParents.length) {
    throw new Error(`以下目录未匹配到 attractions.chinese_name: ${missingParents.join(", ")}`);
  }

  const sql = buildSql(rows);
  mkdirSync("/Users/vesperal/Desktop/YOLO/scripts/generated", { recursive: true });
  writeFileSync(OUTPUT_SQL, sql, "utf8");
  writeFileSync(
    OUTPUT_REPORT,
    JSON.stringify(
      {
        generatedAt: new Date().toISOString(),
        sourceRoot: SOURCE_ROOT,
        sqlPath: OUTPUT_SQL,
        totalSubAreas: rows.length,
        unmatchedImages,
        usesServiceRole,
        folders: reportItems,
      },
      null,
      2
    ),
    "utf8"
  );

  console.log(`done: ${rows.length} sub_areas`);
  console.log(`sql: ${OUTPUT_SQL}`);
  console.log(`report: ${OUTPUT_REPORT}`);
  if (unmatchedImages.length) {
    console.log(`unmatched images: ${unmatchedImages.length}`);
  }
}

main().catch((err) => {
  console.error(err.message);
  process.exit(1);
});
