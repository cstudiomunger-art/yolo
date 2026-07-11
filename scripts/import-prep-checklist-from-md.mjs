#!/usr/bin/env node
/**
 * Import general prep checklist from EN markdown (6 consolidated tasks).
 *
 * Usage:
 *   node scripts/import-prep-checklist-from-md.mjs --file "/path/EN_通用行前准备清单.md" --dry-run
 *   SUPABASE_SERVICE_ROLE_KEY=... node scripts/import-prep-checklist-from-md.mjs --file "..." --apply
 */
import { createClient } from "@supabase/supabase-js";
import { mkdirSync, readFileSync, writeFileSync } from "fs";
import { basename, join } from "path";

const ROOT = "/Users/vesperal/Desktop/YOLO";
const OUT_DIR = join(ROOT, "scripts/generated");
const OUT_SQL = join(OUT_DIR, "prep_checklist_en_upsert.sql");
const OUT_REPORT = join(OUT_DIR, "prep_checklist_en_report.json");

const args = process.argv.slice(2);
const dryRun = args.includes("--dry-run") || !args.includes("--apply");

function argValue(flag) {
  const i = args.indexOf(flag);
  return i >= 0 && args[i + 1] ? args[i + 1] : "";
}

const mdPath =
  argValue("--file") ||
  "/Users/vesperal/Library/Containers/com.tencent.xinWeChat/Data/Documents/xwechat_files/wxid_gc85d9n70ps122_37b7/msg/file/2026-07/EN_通用行前准备清单.md";

const LINK_HINTS = [
  { re: /visa checker/i, label: "Open Visa Checker", url: "app://visa-checker" },
  { re: /payment setup/i, label: "Payment setup guide", url: "app://payment-helper" },
  { re: /connectivity/i, label: "Connectivity options", url: "app://info-hub" },
  { re: /book a hotel/i, label: "Book a hotel", url: "app://plan-hotels" },
  { re: /medication guide/i, label: "Medication guide", url: "app://emergency-medical" },
  { re: /embassy/i, label: "Embassy assistance", url: "app://emergency" },
];

const ITEM_META = [
  { id: "cl_prep_en_01", type: "entry", sort: 10, priority: "required", key: true, reminder: 30 },
  { id: "cl_prep_en_02", type: "entry", sort: 20, priority: "required", key: true, reminder: 45 },
  { id: "cl_prep_en_03", type: "universal", sort: 10, priority: "required", key: true, reminder: 5 },
  { id: "cl_prep_en_04", type: "universal", sort: 20, priority: "required", key: true, reminder: 10 },
  { id: "cl_prep_en_05", type: "universal", sort: 30, priority: "recommended", key: false, reminder: null },
  { id: "cl_prep_en_06", type: "universal", sort: 40, priority: "recommended", key: false, reminder: null },
];

function readXcconfigValue(path, key) {
  const text = readFileSync(path, "utf8");
  const line = text.split(/\r?\n/).find((it) => it.trim().startsWith(`${key} =`));
  if (!line) return "";
  return line.split("=").slice(1).join("=").replace(/\$\(\)/g, "").trim();
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

function sqlStr(v) {
  return v == null ? "NULL" : `'${String(v).replace(/'/g, "''")}'`;
}

function sqlJsonb(obj) {
  return `${sqlStr(JSON.stringify(obj))}::jsonb`;
}

function sqlTextArray(arr) {
  if (!arr?.length) return "ARRAY[]::text[]";
  return `ARRAY[${arr.map((x) => sqlStr(x)).join(", ")}]::text[]`;
}

function stripBullet(line) {
  return String(line || "")
    .trim()
    .replace(/^[-*]\s+/, "");
}

function fieldValue(line, label) {
  const plain = stripBullet(line);
  const re = new RegExp(`\\*\\*${label}\\*\\*\\s*[:：]\\s*(.*)$`, "i");
  const m = plain.match(re);
  return m ? m[1].trim() : "";
}

function parseTasks(mdText) {
  const chunks = mdText.split(/^###\s+/m).slice(1);
  const tasks = [];

  for (const chunk of chunks) {
    const lines = chunk.split(/\r?\n/);
    const header = lines[0]?.trim() || "";
    const hm = header.match(/^(\d+)\.\s+(.+)$/);
    if (!hm) continue;

    const seq = parseInt(hm[1], 10);
    const titleEn = hm[2].trim();
    let why = "";
    let howLines = [];
    let appLinkRaw = "";
    let inHow = false;

    for (let i = 1; i < lines.length; i += 1) {
      const line = lines[i];
      const trimmed = line.trim();
      const plain = stripBullet(trimmed);
      if (!trimmed) {
        if (inHow && howLines.length && howLines[howLines.length - 1] !== "") howLines.push("");
        continue;
      }
      if (/^---/.test(trimmed) || trimmed.startsWith("**Info verified")) break;

      const whyVal = fieldValue(plain, "Why This Matters");
      if (whyVal) {
        why = whyVal;
        inHow = false;
        continue;
      }
      if (/^\*\*How To Complete\*\*/i.test(plain)) {
        inHow = true;
        const inline = fieldValue(plain, "How To Complete");
        if (inline) howLines.push(inline);
        continue;
      }
      const linkVal = fieldValue(plain, "App link");
      if (linkVal) {
        appLinkRaw = linkVal;
        inHow = false;
        continue;
      }
      if (inHow) {
        howLines.push(trimmed);
      }
    }

    const howToComplete = howLines
      .join("\n")
      .replace(/\n{3,}/g, "\n\n")
      .trim();

    tasks.push({ seq, titleEn, whyImportant: why, howToComplete, appLinkRaw });
  }

  return tasks.sort((a, b) => a.seq - b.seq);
}

function resolveExternalLinks(appLinkRaw) {
  if (!appLinkRaw?.trim()) return [];
  const parts = appLinkRaw.split(/[,，]/).map((s) => s.trim()).filter(Boolean);
  const links = [];
  const seen = new Set();
  for (const part of parts) {
    for (const hint of LINK_HINTS) {
      if (!hint.re.test(part)) continue;
      const key = hint.url;
      if (seen.has(key)) break;
      seen.add(key);
      links.push({ label: hint.label, url: hint.url });
      break;
    }
  }
  return links;
}

function buildRows(tasks) {
  if (tasks.length !== ITEM_META.length) {
    throw new Error(`期望 ${ITEM_META.length} 条任务，解析到 ${tasks.length} 条`);
  }
  return tasks.map((task, i) => {
    const meta = ITEM_META[i];
    const groupTitle = meta.type === "entry" ? "Entry Requirements" : "Essential Prep";
    return {
      id: meta.id,
      type: meta.type,
      phase: "before_departure",
      group_title: groupTitle,
      title_en: task.titleEn,
      priority: meta.priority,
      why_important: task.whyImportant,
      how_to_complete: task.howToComplete,
      external_links: resolveExternalLinks(task.appLinkRaw),
      target_nationalities: meta.type === "entry" ? [] : [],
      target_cities: [],
      city_id: null,
      display_tags: meta.key ? ["key"] : [],
      sort_order: meta.sort,
      reminder_days_before: meta.reminder,
      is_active: true,
    };
  });
}

function buildSql(rows) {
  const deactivate = `-- Deactivate legacy entry/universal items (keep city-specific)
UPDATE checklist_items
SET is_active = FALSE, updated_at = NOW()
WHERE type IN ('entry', 'universal')
  AND id NOT IN (${rows.map((r) => sqlStr(r.id)).join(", ")});

`;

  const values = rows
    .map(
      (r) => `(${sqlStr(r.id)}, ${sqlStr(r.type)}, ${sqlStr(r.phase)}, ${sqlStr(r.group_title)}, ${sqlStr(r.title_en)}, ${sqlStr(r.priority)}, ${sqlStr(r.why_important)}, ${sqlStr(r.how_to_complete)}, ${sqlJsonb(r.external_links)}, ${sqlTextArray(r.target_nationalities)}, ${sqlTextArray(r.target_cities)}, NULL, ${sqlTextArray(r.display_tags)}, ${r.sort_order}, ${r.reminder_days_before ?? "NULL"}, TRUE)`
    )
    .join(",\n  ");

  const upsert = `INSERT INTO checklist_items (
  id, type, phase, group_title, title_en, priority,
  why_important, how_to_complete, external_links,
  target_nationalities, target_cities, city_id, display_tags, sort_order, reminder_days_before, is_active
) VALUES
  ${values}
ON CONFLICT (id) DO UPDATE SET
  type = EXCLUDED.type,
  phase = EXCLUDED.phase,
  group_title = EXCLUDED.group_title,
  title_en = EXCLUDED.title_en,
  priority = EXCLUDED.priority,
  why_important = EXCLUDED.why_important,
  how_to_complete = EXCLUDED.how_to_complete,
  external_links = EXCLUDED.external_links,
  target_nationalities = EXCLUDED.target_nationalities,
  target_cities = EXCLUDED.target_cities,
  city_id = EXCLUDED.city_id,
  display_tags = EXCLUDED.display_tags,
  sort_order = EXCLUDED.sort_order,
  reminder_days_before = EXCLUDED.reminder_days_before,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();
`;

  return deactivate + upsert;
}

async function applyRows(rows) {
  const supabase = createClient(getSupabaseConfig().url, loadServiceKey(), {
    auth: { persistSession: false, autoRefreshToken: false },
  });

  const keepIds = new Set(rows.map((r) => r.id));
  const { data: legacy, error: listErr } = await supabase
    .from("checklist_items")
    .select("id")
    .in("type", ["entry", "universal"]);
  if (listErr) throw new Error(`list legacy: ${listErr.message}`);

  const deactivateIds = (legacy || []).map((r) => r.id).filter((id) => !keepIds.has(id));
  if (deactivateIds.length) {
    const { error: offErr } = await supabase
      .from("checklist_items")
      .update({ is_active: false, updated_at: new Date().toISOString() })
      .in("id", deactivateIds);
    if (offErr) throw new Error(`deactivate: ${offErr.message}`);
  }

  const payload = rows.map((r) => ({
    id: r.id,
    type: r.type,
    phase: r.phase,
    group_title: r.group_title,
    title_en: r.title_en,
    priority: r.priority,
    why_important: r.why_important,
    how_to_complete: r.how_to_complete,
    external_links: r.external_links,
    target_nationalities: r.target_nationalities,
    target_cities: r.target_cities,
    city_id: r.city_id,
    display_tags: r.display_tags,
    sort_order: r.sort_order,
    reminder_days_before: r.reminder_days_before,
    is_active: true,
  }));

  const { error } = await supabase.from("checklist_items").upsert(payload, { onConflict: "id" });
  if (error) throw new Error(`upsert: ${error.message}`);
}

async function main() {
  mkdirSync(OUT_DIR, { recursive: true });
  const mdText = readFileSync(mdPath, "utf8");
  const tasks = parseTasks(mdText);
  const rows = buildRows(tasks);
  const sql = buildSql(rows);

  writeFileSync(OUT_SQL, sql, "utf8");
  writeFileSync(
    OUT_REPORT,
    JSON.stringify(
      {
        generatedAt: new Date().toISOString(),
        source: mdPath,
        mode: dryRun ? "dry-run" : "apply",
        tasks: rows.map((r) => ({
          id: r.id,
          type: r.type,
          title_en: r.title_en,
          why_len: r.why_important.length,
          how_len: r.how_to_complete.length,
          external_links: r.external_links,
        })),
      },
      null,
      2
    ),
    "utf8"
  );

  console.log(`parsed ${tasks.length} tasks from ${basename(mdPath)}`);
  console.log(`SQL: ${OUT_SQL}`);
  console.log(`Report: ${OUT_REPORT}`);

  if (dryRun) {
    console.log("\n[dry-run] 未写库。确认后加 --apply");
    return;
  }

  if (!loadServiceKey()) {
    throw new Error("缺少 SUPABASE_SERVICE_ROLE_KEY");
  }

  await applyRows(rows);
  console.log("[apply] 已停用旧 entry/universal 并 upsert 6 条英文清单");
}

main().catch((err) => {
  console.error(err.message || err);
  process.exit(1);
});
