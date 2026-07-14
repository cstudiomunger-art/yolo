import { supabase } from "@/lib/supabase";
import { TABLES } from "@/schema/tables";
import {
  IMAGE_BUCKETS,
  normalizeStorageRef,
  storageRefKey,
  getPublicStorageUrl,
  listBucketImages,
} from "@/lib/storage";

const SINGLE_IMAGE_TYPES = new Set(["image_preview", "image_thumb", "image_url"]);
const MD_IMAGE_RE = /!\[[^\]]*\]\(([^)]+)\)/g;

const EXTRA_TEXT_IMAGE_FIELDS = new Set(["image_url", "avatar_url"]);

/**
 * Hub-managed tables absent from TABLES still hold Storage image refs
 * (e.g. App user avatars in profiles).
 */
const EXTRA_TABLE_IMAGE_SCANS = [
  {
    tableKey: "profiles",
    label: "用户资料",
    pk: "id",
    labelKeys: ["email", "display_name", "id"],
    fields: [{ key: "avatar_url", label: "用户头像" }],
  },
];

function recordLabel(row, schema) {
  const cols = schema.listColumns || [];
  for (const c of cols) {
    const v = row[c.key];
    if (v != null && String(v).trim()) return String(v).trim();
  }
  for (const key of ["name", "name_en", "chinese_name", "title_en", "title_zh", "id"]) {
    if (row[key] != null && String(row[key]).trim()) return String(row[key]).trim();
  }
  return String(row[schema.pk || "id"] ?? "");
}

function pushRef(refsMap, raw, ref) {
  const norm = normalizeStorageRef(raw);
  if (!norm || !IMAGE_BUCKETS.includes(norm.bucket)) return;
  const key = storageRefKey(norm.bucket, norm.path);
  if (!refsMap.has(key)) refsMap.set(key, []);
  refsMap.get(key).push(ref);
}

function scanMarkdownImages(md, baseRef) {
  const found = [];
  if (!md || typeof md !== "string") return found;
  let m;
  const re = new RegExp(MD_IMAGE_RE.source, "g");
  while ((m = re.exec(md)) !== null) {
    found.push(m[1].trim());
  }
  return found.map((url) => ({ ...baseRef, sourceType: "markdown", rawUrl: url }));
}

function schemaImageFields(schema) {
  const fields = schema.fields || [];
  const singles = [];
  const lists = [];
  const markdowns = [];
  const textImages = [];

  for (const f of fields) {
    if (SINGLE_IMAGE_TYPES.has(f.type)) singles.push(f);
    else if (f.type === "image_url_list") lists.push(f);
    else if (f.type === "markdown") markdowns.push(f);
    else if (f.type === "text" && EXTRA_TEXT_IMAGE_FIELDS.has(f.key)) textImages.push(f);
  }
  return { singles, lists, markdowns, textImages };
}

async function collectTableRefs(tableKey, schema, refsMap, onProgress) {
  const pk = schema.pk || "id";
  const { singles, lists, markdowns, textImages } = schemaImageFields(schema);
  if (!singles.length && !lists.length && !markdowns.length && !textImages.length) return;

  const selectCols = new Set([pk]);
  for (const f of [...singles, ...lists, ...markdowns, ...textImages]) selectCols.add(f.key);
  for (const c of schema.listColumns || []) selectCols.add(c.key);

  onProgress?.(`扫描 ${schema.label || tableKey}…`);

  const { data, error } = await supabase.from(tableKey).select([...selectCols].join(","));
  if (error) {
    console.warn(`imageRegistry: skip ${tableKey}`, error.message);
    return;
  }

  for (const row of data || []) {
    const rid = row[pk];
    if (rid == null) continue;
    const label = recordLabel(row, schema);

    for (const f of singles) {
      const v = row[f.key];
      if (!v) continue;
      pushRef(refsMap, v, {
        tableKey,
        recordId: rid,
        recordLabel: label,
        fieldKey: f.key,
        fieldLabel: f.label || f.key,
        sourceType: f.type,
      });
    }

    for (const f of lists) {
      const arr = row[f.key];
      if (!Array.isArray(arr)) continue;
      arr.forEach((url, i) => {
        if (!url) return;
        pushRef(refsMap, url, {
          tableKey,
          recordId: rid,
          recordLabel: label,
          fieldKey: f.key,
          fieldLabel: `${f.label || f.key}[${i}]`,
          sourceType: "image_url_list",
        });
      });
    }

    for (const f of textImages) {
      const v = row[f.key];
      if (!v) continue;
      pushRef(refsMap, v, {
        tableKey,
        recordId: rid,
        recordLabel: label,
        fieldKey: f.key,
        fieldLabel: f.label || f.key,
        sourceType: "text_image",
      });
    }

    for (const f of markdowns) {
      const urls = scanMarkdownImages(row[f.key], {
        tableKey,
        recordId: rid,
        recordLabel: label,
        fieldKey: f.key,
        fieldLabel: f.label || f.key,
      });
      for (const item of urls) {
        pushRef(refsMap, item.rawUrl, item);
      }
    }
  }
}

async function collectExtraTableRefs(scan, refsMap, onProgress) {
  const pk = scan.pk || "id";
  const fieldKeys = (scan.fields || []).map((f) => f.key);
  if (!fieldKeys.length) return;

  const selectCols = new Set([pk, ...fieldKeys, ...(scan.labelKeys || [])]);
  onProgress?.(`扫描 ${scan.label || scan.tableKey}…`);

  const { data, error } = await supabase
    .from(scan.tableKey)
    .select([...selectCols].join(","));
  if (error) {
    console.warn(`imageRegistry: skip ${scan.tableKey}`, error.message);
    return;
  }

  for (const row of data || []) {
    const rid = row[pk];
    if (rid == null) continue;
    let label = "";
    for (const key of scan.labelKeys || []) {
      if (row[key] != null && String(row[key]).trim()) {
        label = String(row[key]).trim();
        break;
      }
    }
    if (!label) label = String(rid);

    for (const f of scan.fields) {
      const v = row[f.key];
      if (!v) continue;
      pushRef(refsMap, v, {
        tableKey: scan.tableKey,
        recordId: rid,
        recordLabel: label,
        fieldKey: f.key,
        fieldLabel: f.label || f.key,
        sourceType: "extra_table",
      });
    }
  }
}

export async function collectDbImageRefs(onProgress) {
  const refsMap = new Map();

  for (const [tableKey, schema] of Object.entries(TABLES)) {
    if (!schema?.fields) continue;
    try {
      await collectTableRefs(tableKey, schema, refsMap, onProgress);
    } catch (e) {
      console.warn(`imageRegistry: ${tableKey}`, e);
    }
  }

  for (const scan of EXTRA_TABLE_IMAGE_SCANS) {
    try {
      await collectExtraTableRefs(scan, refsMap, onProgress);
    } catch (e) {
      console.warn(`imageRegistry: ${scan.tableKey}`, e);
    }
  }

  return refsMap;
}

export async function collectStorageImages(onProgress) {
  const files = [];
  for (const bucket of IMAGE_BUCKETS) {
    onProgress?.(`列出 Storage：${bucket}…`);
    try {
      const listed = await listBucketImages(bucket);
      files.push(...listed);
    } catch (e) {
      console.warn(`imageRegistry list ${bucket}:`, e);
    }
  }
  return files;
}

function folderFromPath(path) {
  const seg = String(path || "").split("/")[0];
  return seg || "root";
}

/**
 * @returns {Array<{
 *   id: string,
 *   bucket: string,
 *   path: string,
 *   folder: string,
 *   publicUrl: string,
 *   status: 'used'|'unused'|'orphan',
 *   refs: object[],
 *   inStorage: boolean,
 * }>}
 */
export function mergeImageIndex(refsMap, storageFiles) {
  const fileSet = new Set(storageFiles.map((f) => storageRefKey(f.bucket, f.path)));
  const entries = new Map();

  for (const { bucket, path } of storageFiles) {
    const id = storageRefKey(bucket, path);
    const refs = refsMap.get(id) || [];
    entries.set(id, {
      id,
      bucket,
      path,
      folder: folderFromPath(path),
      publicUrl: bucket === "chat-images" ? "" : getPublicStorageUrl(bucket, path),
      status: refs.length ? "used" : "unused",
      refs,
      inStorage: true,
    });
  }

  for (const [id, refs] of refsMap.entries()) {
    if (entries.has(id)) continue;
    const [bucket, ...rest] = id.split(":");
    const path = rest.join(":");
    entries.set(id, {
      id,
      bucket,
      path,
      folder: folderFromPath(path),
      publicUrl: bucket === "chat-images" ? "" : getPublicStorageUrl(bucket, path),
      status: "orphan",
      refs,
      inStorage: false,
    });
  }

  return [...entries.values()].sort((a, b) => {
    if (a.bucket !== b.bucket) return a.bucket.localeCompare(b.bucket);
    return a.path.localeCompare(b.path);
  });
}

export async function buildImageIndex({ onProgress } = {}) {
  onProgress?.("扫描数据库引用…");
  const refsMap = await collectDbImageRefs(onProgress);
  const storageFiles = await collectStorageImages(onProgress);
  onProgress?.("合并索引…");
  const entries = mergeImageIndex(refsMap, storageFiles);
  const unused = entries.filter((e) => e.status === "unused").length;
  const orphan = entries.filter((e) => e.status === "orphan").length;
  return { entries, stats: { total: entries.length, unused, orphan, used: entries.length - unused - orphan } };
}
