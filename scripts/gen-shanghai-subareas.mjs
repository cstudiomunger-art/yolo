#!/usr/bin/env node
import { readFileSync, readdirSync, statSync, mkdirSync, writeFileSync, existsSync } from "fs";
import { join, basename, extname } from "path";

const ROOT = "/Users/vesperal/Desktop/YOLO";
const MD_ROOT = "/Users/vesperal/Downloads/后台填写信息汇总（照片+文字信息）/上海子景点/上海子景点-文字信息";
const IMG_ROOT = "/Users/vesperal/Downloads/后台填写信息汇总（照片+文字信息）/上海子景点";
const OUT_SQL = join(ROOT, "scripts/generated/shanghai_sub_areas_with_images.sql");
const OUT_REPORT = join(ROOT, "scripts/generated/shanghai_sub_areas_with_images_report.json");

const ATTRACTION_ALIASES = { 苏州十二国色: "苏州河十二国色" };
const IMAGE_DIR_ALIASES = { 苏州十二国色: "苏州河十二国色", 徐家汇源景区: "徐家汇源" };

function readX(k) {
  const t = readFileSync(join(ROOT, "Secrets.xcconfig"), "utf8");
  const l = t.split(/\r?\n/).find((x) => x.trim().startsWith(`${k} =`));
  return l ? l.split("=").slice(1).join("=").replace(/\$\(\)/g, "").trim() : "";
}
const SUPABASE_URL = process.env.SUPABASE_URL || readX("SUPABASE_URL");
const SUPABASE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY || process.env.SUPABASE_ANON_KEY || readX("SUPABASE_ANON_KEY");

function sqlStr(v) {
  return v == null ? "NULL" : `'${String(v).replace(/'/g, "''")}'`;
}
function clean(s) {
  return String(s || "").replace(/\*\*/g, "").replace(/\*/g, "").replace(/`/g, "").trim();
}
function cjkRatio(s) {
  const t = String(s || "");
  if (!t) return 0;
  return ((t.match(/[\u4e00-\u9fff]/g) || []).length) / t.length;
}
function norm(s) {
  return String(s || "")
    .replace(/\s+/g, "")
    .replace(/[：:·•，,。.!！?？、“”"'()（）\-—_]/g, "")
    .toLowerCase();
}
function stripLeadingOrder(s) {
  return String(s || "").replace(/^\s*[0-9]{1,3}(?:[._-][0-9]{1,3})?\s*[.、:：\-_)\]]*\s*/u, "").trim();
}
function cleanNameEn(s) {
  return stripLeadingOrder(clean(s).replace(/^(?:English|Name|英文名)\s*[:：]\s*/i, ""));
}
function toHtml(s) {
  const t = clean(s).replace(/\s+/g, " ").trim();
  return t ? `<p>${t.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;")}</p>` : "";
}
function extractEnglishFromMixedLine(line) {
  const m = String(line || "").match(/[A-Za-z][\s\S]*$/);
  return m ? clean(m[0]) : "";
}
function sectionBody(content, headingRegex) {
  const lines = content.split(/\r?\n/);
  let inSection = false;
  const out = [];
  for (const line of lines) {
    if (/^##\s+/.test(line)) {
      if (inSection) break;
      if (headingRegex.test(line)) {
        inSection = true;
        continue;
      }
    }
    if (inSection) out.push(line);
  }
  return out.join("\n").trim();
}
function parseTitle(line) {
  const t = clean(line.replace(/^#+\s*/, ""));
  if (t.includes("/")) {
    const [zh, en] = t.split("/").map((x) => x.trim());
    return { nameZh: clean(zh), nameEn: cleanNameEn(en) };
  }
  return { nameZh: t, nameEn: "" };
}
function englishFromSection(text) {
  return text
    .split(/\r?\n/)
    .map((x) => clean(x))
    .filter(Boolean)
    .map((x) => (cjkRatio(x) < 0.35 ? x : extractEnglishFromMixedLine(x)))
    .filter((x) => /[A-Za-z]/.test(x) && cjkRatio(x) < 0.35)
    .join(" ");
}
function parseMd(content, fallbackStem) {
  const parts = content.split(/\n---\n/);
  const zhPart = parts[0];
  const enPart = parts.length > 1 ? parts[parts.length - 1] : content;
  const zhLines = zhPart.split(/\r?\n/);
  let nameZh = stripLeadingOrder(clean(fallbackStem));
  let nameEn = "";
  const h1 = zhLines.find((l) => /^#\s+/.test(l));
  if (h1) {
    const t = parseTitle(h1);
    nameZh = t.nameZh || nameZh;
    nameEn = t.nameEn || nameEn;
  }
  if (!h1 && /^[^#\n].+\/.+/.test(zhLines[0] || "")) {
    const t = parseTitle(zhLines[0]);
    nameZh = t.nameZh || nameZh;
    nameEn = t.nameEn || nameEn;
  }

  const nameSection = sectionBody(zhPart, /^##\s*(?:[0-9]+\.\s*)?名字/i) || sectionBody(enPart, /^##\s*(?:[0-9]+\.\s*)?Name/i);
  if (nameSection) {
    for (const ln of nameSection.split(/\r?\n/).map((x) => clean(x)).filter(Boolean)) {
      const enM = ln.match(/^(?:English|Name|英文名)\s*[:：]\s*(.+)$/i);
      if (enM) {
        nameEn = cleanNameEn(enM[1]);
        continue;
      }
      const zhM = ln.match(/^(?:中文|Chinese)\s*[:：]\s*(.+)$/i);
      if (zhM) {
        nameZh = clean(zhM[1]);
        continue;
      }
      if (ln.includes("/") && cjkRatio(ln) > 0.2) {
        const [zh, en] = ln.split("/").map((x) => x.trim());
        if (zh) nameZh = clean(zh);
        if (en) nameEn = cleanNameEn(en);
        continue;
      }
      if (!nameEn && /[A-Za-z]/.test(ln) && cjkRatio(ln) < 0.2) nameEn = cleanNameEn(ln);
    }
  }
  if (!nameEn && enPart !== zhPart) {
    const star = sectionBody(enPart, /^##\s*(?:[0-9]+\.\s*)?Name/i)
      .split(/\r?\n/)
      .map((x) => clean(x))
      .find((x) => /[A-Za-z]/.test(x) && cjkRatio(x) < 0.2);
    if (star) nameEn = cleanNameEn(star);
  }
  nameZh = stripLeadingOrder(clean((nameZh || fallbackStem).split("/")[0]));
  nameEn = cleanNameEn(nameEn || "");

  let bodyEn = "";
  for (const re of [/\*\*Long Description\*\*\s*[:：]\s*(.+)/i, /\*\*Detailed Description\*\*\s*[:：]\s*(.+)/i, /Long Description:\s*(.+)/i]) {
    const m = content.match(re);
    if (m) {
      bodyEn = clean(m[1]);
      break;
    }
  }
  if (!bodyEn) bodyEn = englishFromSection(sectionBody(enPart, /^##\s*(?:[0-9]+\.\s*)?Long Description/i));
  if (!bodyEn) {
    for (const sec of [/^##\s*(?:[0-9]+\.\s*)?长文描述/i, /^##\s*(?:[0-9]+\.\s*)?详细描述/i]) {
      const t = englishFromSection(sectionBody(zhPart, sec));
      if (t) {
        bodyEn = t;
        break;
      }
    }
  }
  if (!bodyEn) bodyEn = englishFromSection(sectionBody(enPart, /^##\s*(?:[0-9]+\.\s*)?Summary/i) || sectionBody(zhPart, /^##\s*(?:[0-9]+\.\s*)?摘要/i));
  if (!bodyEn) {
    const sm = content.match(/\*\*Summary\*\*\s*[:：]\s*(.+)/i);
    if (sm) bodyEn = clean(sm[1]);
  }
  return { nameZh, nameEn, body: toHtml(bodyEn) };
}

function parseImageMeta(filename) {
  const stem = basename(filename, extname(filename));
  const m = stem.match(/^(\d+)\s*[.、:：\-_)\]]*\s*(.+)$/);
  if (m) return { order: Number(m[1]), label: stripLeadingOrder(clean(m[2])) };
  return { order: 9999, label: stripLeadingOrder(clean(stem)) };
}
function nameMatch(a, b) {
  const na = norm(a);
  const nb = norm(b);
  if (!na || !nb) return false;
  if (na === nb || na.includes(nb) || nb.includes(na)) return true;
  const sa = na.replace(/\d+米/g, "");
  const sb = nb.replace(/\d+米/g, "");
  return sa.includes(sb) || sb.includes(sa);
}
function listImages(dir) {
  if (!existsSync(dir)) return [];
  return readdirSync(dir)
    .filter((n) => /\.(jpg|jpeg|png|webp)$/i.test(n))
    .map((n) => {
      const meta = parseImageMeta(n);
      return { file: join(dir, n), name: n, ...meta };
    })
    .sort((a, b) => a.order - b.order || a.label.localeCompare(b.label, "zh-Hans-CN"));
}
function findImage(images, mdStem, parsedNameZh) {
  const targets = [stripLeadingOrder(mdStem), parsedNameZh].filter(Boolean);
  for (const img of images) if (targets.some((t) => nameMatch(img.label, t))) return img;
  for (const img of images) if (targets.some((t) => nameMatch(img.label.split(/[（(]/)[0], t))) return img;
  return null;
}
function resolveImageDir(folderName) {
  const candidates = [folderName, IMAGE_DIR_ALIASES[folderName]].filter(Boolean);
  const dirs = readdirSync(IMG_ROOT).filter((n) => statSync(join(IMG_ROOT, n)).isDirectory());
  for (const c of candidates) {
    const exact = dirs.find((d) => d === c || d.trim() === c);
    if (exact) return join(IMG_ROOT, exact);
    const fuzzy = dirs.find((d) => norm(d.trim()) === norm(c));
    if (fuzzy) return join(IMG_ROOT, fuzzy);
  }
  return join(IMG_ROOT, folderName);
}
function loadCoverIndexFromSql() {
  const index = new Map();
  for (const f of readdirSync(join(ROOT, "scripts/generated")).filter((n) => n.endsWith(".sql"))) {
    const text = readFileSync(join(ROOT, "scripts/generated", f), "utf8");
    const re = /'(https:[^']*cover-images\/sub-areas\/all\/([a-z0-9_]+_sa_\d+)\.[a-z]+)'/gi;
    let m;
    while ((m = re.exec(text))) index.set(m[2], m[1]);
  }
  return index;
}
async function rest(path, init = {}) {
  const res = await fetch(`${SUPABASE_URL}${path}`, {
    ...init,
    headers: { apikey: SUPABASE_KEY, Authorization: `Bearer ${SUPABASE_KEY}`, ...(init.headers || {}) },
  });
  if (!res.ok) throw new Error(`${path} -> ${res.status} ${await res.text()}`);
  return res;
}
async function upload(storagePath, localPath) {
  const ext = extname(localPath).toLowerCase();
  const ct = ext === ".png" ? "image/png" : ext === ".webp" ? "image/webp" : "image/jpeg";
  await rest(`/storage/v1/object/cover-images/${storagePath}`, {
    method: "POST",
    headers: { "x-upsert": "true", "content-type": ct },
    body: readFileSync(localPath),
  });
  return `${SUPABASE_URL}/storage/v1/object/public/cover-images/${storagePath}`;
}

const attractions = await (await rest("/rest/v1/attractions?select=id,chinese_name")).json();
const allSubAreas = await (await rest("/rest/v1/sub_areas?select=id,attraction_id,name_zh,cover_image_path,sort_order&cover_image_path=not.is.null")).json();
const sqlCoverIndex = loadCoverIndexFromSql();

function resolveAttraction(folderName) {
  const guess = ATTRACTION_ALIASES[folderName] || folderName;
  return (
    attractions.find((a) => String(a.chinese_name || "").trim() === guess) ||
    attractions.find((a) => String(a.chinese_name || "").includes(guess) || guess.includes(String(a.chinese_name || "")))
  );
}
function findCoverUrl(attractionId, sortOrder, nameZh, saId) {
  if (sqlCoverIndex.get(saId)) return { url: sqlCoverIndex.get(saId), source: "sql" };
  const dbBySa = allSubAreas.find((x) => x.id === saId && x.cover_image_path);
  if (dbBySa) return { url: dbBySa.cover_image_path, source: "db-id" };
  const dbByName = allSubAreas.find((x) => x.attraction_id === attractionId && norm(x.name_zh) === norm(nameZh) && x.cover_image_path);
  if (dbByName) return { url: dbByName.cover_image_path, source: "db-name" };
  const dbBySort = allSubAreas.find((x) => x.attraction_id === attractionId && Number(x.sort_order) === Number(sortOrder) && x.cover_image_path);
  if (dbBySort) return { url: dbBySort.cover_image_path, source: "db-sort" };
  return { url: "", source: "" };
}

const rows = [];
const report = {
  generatedAt: new Date().toISOString(),
  sourceMdRoot: MD_ROOT,
  imageRoot: IMG_ROOT,
  attractions: [],
  unmatchedAttractions: [],
  missingImages: [],
  stats: { totalRows: 0, reusedCoverUrls: 0, newlyUploadedImages: 0, missingImages: 0, emptyBody: 0 },
};

const attractionDirs = readdirSync(MD_ROOT)
  .map((n) => join(MD_ROOT, n))
  .filter((p) => statSync(p).isDirectory())
  .sort((a, b) => a.localeCompare(b, "zh-Hans-CN"));

for (const mdDir of attractionDirs) {
  const folderName = basename(mdDir);
  const parent = resolveAttraction(folderName);
  if (!parent) {
    report.unmatchedAttractions.push({ folderName });
    continue;
  }
  const imageDir = resolveImageDir(folderName);
  const images = listImages(imageDir);
  const mdFiles = readdirSync(mdDir).filter((n) => n.endsWith(".md")).map((n) => join(mdDir, n));
  const parsedItems = mdFiles.map((mdPath) => {
    const stem = basename(mdPath, ".md");
    const parsed = parseMd(readFileSync(mdPath, "utf8"), stem);
    const img = findImage(images, stem, parsed.nameZh);
    return { mdPath, stem, parsed, img };
  });
  parsedItems.sort((a, b) => (a.img ? a.img.order : 9999) - (b.img ? b.img.order : 9999) || a.stem.localeCompare(b.stem, "zh-Hans-CN"));

  const attrReport = { folderName, imageDir, attractionId: parent.id, attractionNameZh: parent.chinese_name, count: 0, items: [] };
  let reused = 0;
  let uploaded = 0;
  let missing = 0;
  for (let i = 0; i < parsedItems.length; i++) {
    const { mdPath, stem, parsed, img } = parsedItems[i];
    const saId = `${parent.id}_sa_${String(i + 1).padStart(2, "0")}`;
    let cover = "";
    let coverSource = "";
    const found = findCoverUrl(parent.id, i, parsed.nameZh, saId);
    if (found.url) {
      cover = found.url;
      coverSource = found.source;
      reused++;
    } else if (img) {
      cover = await upload(`sub-areas/all/${saId}${extname(img.file).toLowerCase()}`, img.file);
      coverSource = "upload";
      uploaded++;
    } else {
      missing++;
      report.missingImages.push({ attraction: parent.chinese_name, md: basename(mdPath), nameZh: parsed.nameZh });
    }
    if (!parsed.body) report.stats.emptyBody++;
    rows.push({ attractionNameZh: parent.chinese_name, sortOrder: i, nameEn: parsed.nameEn, nameZh: parsed.nameZh, body: parsed.body, cover });
    attrReport.items.push({ sortOrder: i, file: basename(mdPath), image: img?.name || "", nameZh: parsed.nameZh, nameEn: parsed.nameEn, coverSource, hasBody: !!parsed.body });
    attrReport.count++;
  }
  attrReport.reused = reused;
  attrReport.uploaded = uploaded;
  attrReport.missing = missing;
  report.attractions.push(attrReport);
  report.stats.reusedCoverUrls += reused;
  report.stats.newlyUploadedImages += uploaded;
  report.stats.missingImages += missing;
}

report.stats.totalRows = rows.length;
rows.sort((a, b) => a.attractionNameZh.localeCompare(b.attractionNameZh, "zh-Hans-CN") || a.sortOrder - b.sortOrder);
const values = rows.map((r) => `(${sqlStr(r.attractionNameZh)}, ${r.sortOrder}, ${sqlStr(r.nameEn || "")}, ${sqlStr(r.nameZh)}, ${sqlStr(r.body)}, ${sqlStr(r.cover)})`);
const sql = `-- Generated from Shanghai sub-area markdown files (with cover images)
WITH input_rows(attraction_name_zh, sort_order, name_en, name_zh, body, cover_image_path) AS (
  VALUES
  ${values.join(",\n  ")}
), mapped_rows AS (
  SELECT CONCAT(a.id, '_sa_', LPAD((i.sort_order + 1)::text, 2, '0')) AS id, a.id AS attraction_id, i.name_en, i.name_zh, i.body, i.cover_image_path, i.sort_order
  FROM input_rows i JOIN attractions a ON a.chinese_name = i.attraction_name_zh
)
INSERT INTO sub_areas (id, attraction_id, name_en, name_zh, body, cover_image_path, sort_order, is_active)
SELECT id, attraction_id, name_en, name_zh, body, cover_image_path, sort_order, TRUE FROM mapped_rows
ON CONFLICT (id) DO UPDATE SET name_en=EXCLUDED.name_en, name_zh=EXCLUDED.name_zh, body=EXCLUDED.body, cover_image_path=EXCLUDED.cover_image_path, sort_order=EXCLUDED.sort_order, is_active=EXCLUDED.is_active, updated_at=NOW();
`;
mkdirSync(join(ROOT, "scripts/generated"), { recursive: true });
writeFileSync(OUT_SQL, sql, "utf8");
writeFileSync(OUT_REPORT, JSON.stringify(report, null, 2), "utf8");
console.log(JSON.stringify(report.stats, null, 2));
console.log("missing:", report.missingImages);
