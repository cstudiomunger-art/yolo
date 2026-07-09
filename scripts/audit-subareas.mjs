#!/usr/bin/env node
/**
 * Audit sub_areas against md source files in Downloads backend folder.
 * Usage:
 *   node audit-subareas.mjs [--city shanghai] [--fix-sql]
 */
import { createClient } from "@supabase/supabase-js";
import { existsSync, mkdirSync, readFileSync, readdirSync, statSync, writeFileSync } from "fs";
import { basename, extname, join } from "path";

const ROOT = "/Users/vesperal/Desktop/YOLO";
const SOURCE_ROOT = "/Users/vesperal/Downloads/后台填写信息汇总（照片+文字信息）";
const OUT_DIR = join(ROOT, "scripts/generated");
const OUT_REPORT = join(OUT_DIR, "sub_areas_audit_report.json");
const OUT_SUMMARY = join(OUT_DIR, "sub_areas_audit_summary.md");
const OUT_STATS = join(OUT_DIR, "sub_areas_audit_stats.json");
const OUT_FIX_SQL = join(OUT_DIR, "sub_areas_fix_from_md.sql");
const OUT_FULL_LIST = join(OUT_DIR, "sub_areas_audit_full_list.md");

const CITY_ZH = {
  nanjing: "南京",
  suzhou: "苏州",
  hangzhou: "杭州",
  shanghai: "上海",
  chengdu: "成都",
  chongqing: "重庆",
};

const ATTRACTION_ALIASES = {
  苏州十二国色: "苏州河十二国色",
  徐家汇源景区: "徐家汇源",
  国家博物馆: "国博",
  成都博物院: "成都博物馆",
  成都熊猫基地: "大熊猫基地",
  成都大熊猫繁育研究基地: "大熊猫基地",
  南京博物馆: "南京博物院",
  磁器口古镇: "磁器口",
  解放碑: "解放碑广场",
  洪崖洞: "重庆洪崖洞民俗风貌区",
  重庆洪崖洞: "重庆洪崖洞民俗风貌区",
  磁器口: "磁器口古镇",
  成都武侯祠子景点信息: "武侯祠",
  成都青羊宫子景点信息: "青羊宫",
  成都杜甫草堂景点信息: "杜甫草堂",
  四川博物院子景点信息: "四川博物院",
  成都博物院子景点信息: "四川博物院",
  成都博物馆子景点信息: "成都博物馆",
};

const IMAGE_DIR_ALIASES = {
  苏州十二国色: "苏州河十二国色",
  徐家汇源景区: "徐家汇源",
  洪崖洞: "重庆洪崖洞民俗风貌区",
  磁器口: "磁器口古镇",
  解放碑广场: "解放碑",
  成都熊猫基地: "成都熊猫基地",
  熊猫基地: "成都熊猫基地",
  成都武侯祠: "武侯祠",
  成都青羊宫: "青羊宫",
  成都杜甫草堂: "杜甫草堂",
  四川博物院: "四川博物院",
  博物院: "四川博物院",
  博物馆: "成都博物馆",
  磁器口古镇: "磁器口",
  解放碑: "解放碑广场",
  成都博物馆: "成都博物馆",
};

const TEXT_DIR_ALIASES = {
  洪崖洞: "洪崖洞",
  磁器口古镇: "磁器口",
  解放碑广场: "解放碑",
  大熊猫基地: "成都熊猫基地",
  武侯祠: "成都武侯祠子景点信息",
  青羊宫: "成都青羊宫子景点信息",
  杜甫草堂: "成都杜甫草堂景点信息",
  四川博物院: "成都博物院子景点信息",
  成都博物馆: "成都博物馆子景点信息",
  博物院: "四川博物院",
  熊猫基地: "成都熊猫基地",
};

const args = process.argv.slice(2);
const cityFilter = args.includes("--city") ? args[args.indexOf("--city") + 1] : null;
const fixSql = args.includes("--fix-sql");

function readXcconfigValue(path, key) {
  const text = readFileSync(path, "utf8");
  const line = text.split(/\r?\n/).find((it) => it.trim().startsWith(`${key} =`));
  if (!line) return "";
  return line.split("=").slice(1).join("=").replace(/\$\(\)/g, "").trim();
}

function getSupabaseConfig() {
  const xcPath = join(ROOT, "Secrets.xcconfig");
  const url = process.env.SUPABASE_URL || readXcconfigValue(xcPath, "SUPABASE_URL");
  const key =
    process.env.SUPABASE_SERVICE_ROLE_KEY ||
    process.env.SUPABASE_ANON_KEY ||
    readXcconfigValue(xcPath, "SUPABASE_ANON_KEY");
  if (!url || !key) throw new Error("缺少 SUPABASE_URL 或 key");
  return { url, key };
}

function cleanMdMarks(s) {
  return String(s || "")
    .replace(/\*\*/g, "")
    .replace(/\*/g, "")
    .replace(/`/g, "")
    .trim();
}

function stripLeadingOrder(s) {
  return String(s || "")
    .replace(/^\s*[0-9]{1,3}(?:[._-][0-9]{1,3})?\s*[.、:：\-_)\]]*\s*/u, "")
    .trim();
}

function cjkRatio(s) {
  const txt = String(s || "");
  if (!txt) return 0;
  return (txt.match(/[\u4e00-\u9fff]/g) || []).length / txt.length;
}

function norm(s) {
  return String(s || "")
    .replace(/\s+/g, "")
    .replace(/[：:·•，,。.!！?？、“”"'()（）\-—_]/g, "")
    .replace(/[・．·]/g, "")
    .toLowerCase();
}

function extractEnglishFromMixedLine(line) {
  const m = String(line || "").match(/[A-Za-z][\s\S]*$/);
  return m ? cleanMdMarks(m[0]) : "";
}

function splitZhEn(text) {
  const raw = cleanMdMarks(text);
  if (!raw.includes("/")) {
    if (cjkRatio(raw) > 0.2) {
      return { nameZh: stripLeadingOrder(raw), nameEn: extractEnglishFromMixedLine(raw) };
    }
    return { nameZh: "", nameEn: stripLeadingOrder(raw) };
  }
  const idx = raw.indexOf("/");
  const left = raw.slice(0, idx).trim();
  const right = raw.slice(idx + 1).trim();
  const leftIsZh = cjkRatio(left) >= cjkRatio(right);
  return {
    nameZh: stripLeadingOrder(leftIsZh ? left : right),
    nameEn: stripLeadingOrder(leftIsZh ? right : left),
  };
}

function fieldValueFromLine(line, label) {
  const plain = String(line || "");
  const idx = plain.indexOf(label);
  if (idx < 0) return "";
  return plain
    .slice(idx + label.length)
    .replace(/^\s*[:：]\s*/, "")
    .trim();
}

function toHtml(text) {
  const safe = cleanMdMarks(text)
    .replace(/\s+/g, " ")
    .trim()
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;");
  return safe ? `<p>${safe}</p>` : "";
}

function stripHtml(html) {
  return String(html || "")
    .replace(/<[^>]+>/g, " ")
    .replace(/&amp;/g, "&")
    .replace(/&lt;/g, "<")
    .replace(/&gt;/g, ">")
    .replace(/\s+/g, " ")
    .trim();
}

function isPlaceholderNameEn(nameEn, attractionId, sortIndex) {
  const n = String(nameEn || "").trim().toLowerCase();
  if (!n) return true;
  if (/sub area \d+/i.test(n)) return true;
  if (n === `${String(attractionId || "").replace(/_/g, " ")} sub area ${String(sortIndex + 1).padStart(2, "0")}`) return true;
  return false;
}

function textsMatch(a, b) {
  const na = norm(stripHtml(a));
  const nb = norm(stripHtml(b));
  if (!na && !nb) return true;
  if (!na || !nb) return false;
  if (na === nb) return true;
  if (na.includes(nb) || nb.includes(na)) return true;
  const minLen = Math.min(na.length, nb.length);
  if (minLen >= 80) {
    const slice = na.slice(0, 80);
    if (nb.includes(slice) || na.includes(nb.slice(0, 80))) return true;
  }
  return false;
}

function namesMatch(a, b) {
  const na = norm(a);
  const nb = norm(b);
  if (!na || !nb) return false;
  if (na === nb) return true;
  if (na.includes(nb) || nb.includes(na)) return true;
  const sa = na.replace(/\d+米/g, "");
  const sb = nb.replace(/\d+米/g, "");
  return sa.includes(sb) || sb.includes(sa);
}

function sectionBodyByHeading(content, headingPattern) {
  const lines = content.split(/\r?\n/);
  let inSection = false;
  const out = [];
  for (const line of lines) {
    const trimmed = line.trim();
    if (/^##\s+/.test(trimmed)) {
      if (inSection) break;
      const normalized = trimmed.replace(/^##\s*(?:[0-9]+\.\s*)?/, "## ");
      if (headingPattern.test(trimmed) || headingPattern.test(normalized)) {
        inSection = true;
        continue;
      }
    }
    if (inSection) out.push(line);
  }
  return out.join("\n").trim();
}

function stripYamlFrontMatter(content) {
  const trimmed = String(content || "").trimStart();
  if (!trimmed.startsWith("---")) return content;
  const end = trimmed.indexOf("\n---\n", 3);
  if (end < 0) return content;
  return trimmed.slice(end + 5);
}

function splitBilingualParts(content) {
  const text = stripYamlFrontMatter(content);
  const parts = text.split(/\n---\n/);
  if (parts.length <= 1) return { zhPart: text, enPart: "" };
  return { zhPart: parts[0], enPart: parts[parts.length - 1] };
}

function sectionBodyByLabel(text, labelRe) {
  const lines = text.split(/\r?\n/);
  let inSection = false;
  const out = [];
  for (const line of lines) {
    const trimmed = line.trim();
    if (/^##\s+/.test(trimmed)) {
      if (inSection) break;
      if (labelRe.test(trimmed.replace(/^##\s*(?:[0-9]+\.\s*)?/, ""))) {
        inSection = true;
        continue;
      }
    }
    if (inSection) out.push(line);
  }
  return out.join("\n").trim();
}

function collectEnglishFromDescriptionLines(lines, startIdx, mdFieldSources, fieldLabel) {
  const englishParts = [];
  for (let i = startIdx + 1; i < lines.length; i += 1) {
    const trimmed = lines[i].trim();
    if (!trimmed) continue;
    if (/^\*\*[^*]+\*\*\s*$/.test(trimmed)) break;
    if (/^##\s+/.test(trimmed)) break;
    if (/^---+$/.test(trimmed)) break;
    if (/^(?:详细地址|门票|开放|交通|名字|摘要)/.test(cleanMdMarks(trimmed))) break;
    const plain = cleanMdMarks(trimmed);
    if (!plain) continue;
    if (cjkRatio(plain) < 0.35 && /[A-Za-z]/.test(plain)) {
      englishParts.push(plain);
    } else {
      const mixed = extractEnglishFromMixedLine(plain);
      if (mixed) englishParts.push(mixed);
    }
  }
  if (englishParts.length) mdFieldSources.body = `${fieldLabel} @ line ${startIdx + 1}`;
  return englishParts.join(" ").replace(/\s+/g, " ").trim();
}

function extractEnglishDescription(content, mdFieldSources) {
  const lines = content.split(/\r?\n/);
  const labelRes = [
    /(?:长文)?描述\s*\/\s*(?:Long\s+)?Description/i,
    /Long Description/i,
    /Detailed Description/i,
  ];

  for (let i = 0; i < lines.length; i += 1) {
    const line = lines[i];
    const trimmed = line.trim();
    if (/^\*\*(?:长文)?描述\s*\/\s*(?:Long\s+)?Description\*\*\s*$/i.test(trimmed)) {
      const body = collectEnglishFromDescriptionLines(lines, i, mdFieldSources, "长文描述 / Long Description block");
      if (body) return body;
    }
    if (!labelRes.some((re) => re.test(line))) continue;

    const fieldLabel = /长文描述/i.test(line)
      ? "长文描述 / Description"
      : /Long Description/i.test(line)
        ? "Long Description"
        : "描述 / Description";
    const inline =
      fieldValueFromLine(line, "长文描述 / Description") ||
      fieldValueFromLine(line, "长文描述 / Long Description") ||
      fieldValueFromLine(line, "描述 / Description") ||
      fieldValueFromLine(line, "描述 / Long Description");
    const englishParts = [];
    if (inline) {
      const eng = extractEnglishFromMixedLine(inline);
      if (eng) englishParts.push(eng);
    }
    for (let j = i + 1; j < lines.length; j += 1) {
      const t = lines[j].trim();
      if (!t) continue;
      if (/^\*\*[^*]+\*\*\s*$/.test(t)) break;
      if (/^##\s+/.test(t)) break;
      if (/^---+$/.test(t)) break;
      const plain = cleanMdMarks(t);
      if (/^(?:详细地址|门票|开放|交通|名字|摘要)/.test(plain)) break;
      if (cjkRatio(plain) < 0.35 && /[A-Za-z]/.test(plain)) englishParts.push(plain);
      else {
        const mixed = extractEnglishFromMixedLine(plain);
        if (mixed) englishParts.push(mixed);
      }
    }
    if (englishParts.length) {
      mdFieldSources.body = `${fieldLabel} @ line ${i + 1}`;
      return englishParts.join(" ").replace(/\s+/g, " ").trim();
    }
  }

  for (let i = 0; i < lines.length; i += 1) {
    const plain = cleanMdMarks(lines[i]);
    if (/^长文描述\s*[:：]/.test(plain)) {
      const body = collectEnglishFromDescriptionLines(lines, i, mdFieldSources, "长文描述");
      if (body) return body;
      const summaryEng = extractEnglishFromMixedLine(plain.replace(/^长文描述\s*[:：]\s*/, ""));
      if (summaryEng) {
        mdFieldSources.body = `长文描述 inline (English only)`;
        return summaryEng;
      }
    }
  }

  for (let i = 0; i < lines.length; i += 1) {
    const plain = cleanMdMarks(lines[i]);
    if (/^摘要\s*[:：]/.test(plain)) {
      const eng = extractEnglishFromMixedLine(plain.replace(/^摘要\s*[:：]\s*/, ""));
      if (eng) {
        mdFieldSources.body = "摘要 fallback (English)";
        return eng;
      }
    }
  }

  return "";
}

function extractBodyPlainEn(content, mdFieldSources) {
  let bodyPlainEn = extractEnglishDescription(content, mdFieldSources);
  if (bodyPlainEn) return bodyPlainEn;

  for (const re of [
    /\*\*Long Description\*\*\s*[:：]\s*(.+)/i,
    /\*\*Detailed Description\*\*\s*[:：]\s*(.+)/i,
    /Long Description:\s*(.+)/i,
    /Long Description：\s*(.+)/i,
  ]) {
    const m = content.match(re);
    if (m) {
      mdFieldSources.body = "inline Long Description";
      return cleanMdMarks(m[1]).replace(/\s+/g, " ").trim();
    }
  }

  for (const pattern of [
    /^##\s*详细描述/i,
    /^##\s*长文描述/i,
    /^##\s*描述/i,
    /^##\s*长文描述\s*\/\s*Detailed Description/i,
  ]) {
    const detailSection = sectionBodyByHeading(content, pattern);
    if (detailSection) {
      bodyPlainEn = englishFromSectionText(detailSection);
      if (bodyPlainEn) {
        mdFieldSources.body = "## 详细描述 / 长文描述 section";
        return bodyPlainEn;
      }
    }
  }

  const { zhPart, enPart } = splitBilingualParts(content);
  if (enPart) {
    const enSources = {};
    bodyPlainEn = extractEnglishDescription(enPart, enSources);
    if (!bodyPlainEn) {
      const longSec =
        sectionBodyByLabel(enPart, /^Long Description/i) ||
        sectionBodyByLabel(enPart, /^Detailed Description/i);
      if (longSec) {
        bodyPlainEn = englishFromSectionText(longSec);
        if (bodyPlainEn) enSources.body = "## Long Description section (EN doc)";
      }
    }
    if (bodyPlainEn) {
      mdFieldSources.body = enSources.body || "English section after ---";
      return bodyPlainEn;
    }
  }

  if (!/^#\s+/m.test(zhPart) && zhPart.split(/\r?\n/)[0] && /^[^#\n].+\/.+/.test(zhPart.split(/\r?\n/)[0].trim())) {
    const inline = zhPart
      .split(/\r?\n/)
      .map((x) => cleanMdMarks(x))
      .filter(Boolean);
    const longIdx = inline.findIndex((x) => /^长文描述[:：]/.test(x));
    if (longIdx >= 0) {
      const engParts = [];
      for (let i = longIdx; i < inline.length; i += 1) {
        const line = inline[i].replace(/^长文描述[:：]\s*/, "");
        if (i > longIdx && /^(详细地址|门票|开放|交通|摘要)/.test(line)) break;
        if (cjkRatio(line) < 0.35 && /[A-Za-z]/.test(line)) engParts.push(line);
        else {
          const mixed = extractEnglishFromMixedLine(line);
          if (mixed) engParts.push(mixed);
        }
      }
      bodyPlainEn = engParts.join(" ").replace(/\s+/g, " ").trim();
      if (bodyPlainEn) {
        mdFieldSources.body = "inline 长文描述 block";
        return bodyPlainEn;
      }
    }
  }

  return "";
}

function englishFromSectionText(text) {
  return text
    .split(/\r?\n/)
    .map((x) => cleanMdMarks(x))
    .filter(Boolean)
    .map((x) => (cjkRatio(x) < 0.35 ? x : extractEnglishFromMixedLine(x)))
    .filter((x) => /[A-Za-z]/.test(x))
    .join(" ")
    .replace(/\s+/g, " ")
    .trim();
}

function parseMdContent(content, { fallbackStem = "", headingTitle = "" } = {}) {
  const mdFieldSources = {};
  let nameZh = "";
  let nameEn = "";

  const lines = content.split(/\r?\n/);
  const nameFromHeading = headingTitle ? splitZhEn(headingTitle) : { nameZh: "", nameEn: "" };
  nameZh = nameFromHeading.nameZh;
  nameEn = nameFromHeading.nameEn;

  const h1 = lines.find((l) => /^#\s+/.test(l.trim()) && !/^##/.test(l.trim()));
  if (h1) {
    const parsed = splitZhEn(cleanMdMarks(h1.replace(/^#\s+/, "")));
    if (parsed.nameZh) nameZh = parsed.nameZh;
    if (parsed.nameEn) nameEn = parsed.nameEn;
    mdFieldSources.name = `h1: ${h1.trim().slice(0, 100)}`;
    if (!nameEn) {
      const h1Idx = lines.findIndex((l) => l === h1);
      const nextLine = lines.slice(h1Idx + 1).find((l) => l.trim());
      if (nextLine) {
        const bold = nextLine.trim().match(/^\*\*(.+)\*\*$/);
        if (bold) {
          const candidate = stripLeadingOrder(cleanMdMarks(bold[1]));
          if (/[A-Za-z]/.test(candidate) && cjkRatio(candidate) < 0.35) {
            nameEn = candidate;
            mdFieldSources.name = `h1 + subtitle: ${nextLine.trim().slice(0, 100)}`;
          }
        }
      }
    }
  } else if (lines[0]?.trim()) {
    let nameValue = cleanMdMarks(lines[0]);
    if (/^名字\s*[:：]/.test(nameValue)) nameValue = fieldValueFromLine(lines[0], "名字");
    if (nameValue.includes("/") && /^[^#\n]/.test(lines[0].trim())) {
      const parsed = splitZhEn(nameValue);
      if (parsed.nameZh) nameZh = parsed.nameZh;
      if (parsed.nameEn) nameEn = parsed.nameEn;
      mdFieldSources.name = `first line: ${lines[0].trim().slice(0, 100)}`;
    }
  }

  if (!nameZh || !nameEn) {
    for (let i = 0; i < Math.min(lines.length, 20); i += 1) {
      const plain = cleanMdMarks(lines[i]);
      if (!/^名字\s*[:：]/.test(plain)) continue;
      const value = fieldValueFromLine(lines[i], "名字") || plain.replace(/^名字\s*[:：]\s*/, "");
      const parsed = splitZhEn(value);
      if (parsed.nameZh && !nameZh) nameZh = parsed.nameZh;
      if (parsed.nameEn && !nameEn) nameEn = parsed.nameEn;
      if (parsed.nameZh || parsed.nameEn) {
        mdFieldSources.name = `plain 名字: ${lines[i].trim().slice(0, 100)}`;
        break;
      }
    }
  }

  for (let i = 0; i < lines.length; i += 1) {
    const line = lines[i];
    const trimmed = line.trim();
    if (/^\*\*名字\s*\/\s*Name\*\*\s*$/i.test(trimmed)) {
      const next = lines.slice(i + 1).find((l) => l.trim());
      if (next) {
        const parsed = splitZhEn(cleanMdMarks(next));
        if (parsed.nameZh) nameZh = parsed.nameZh;
        if (parsed.nameEn) nameEn = parsed.nameEn;
        mdFieldSources.name = `名字 / Name block: ${next.slice(0, 100)}`;
      }
      break;
    }
    if (/名字\s*\/\s*Name/i.test(trimmed) && /[:：]/.test(trimmed)) {
      let value = fieldValueFromLine(trimmed.replace(/\*\*/g, ""), "名字 / Name");
      if (!value) {
        const m = trimmed.match(/名字\s*\/\s*Name\s*[:：]\s*(.+)/i);
        if (m) value = cleanMdMarks(m[1]);
      }
      value = cleanMdMarks(value).replace(/^[：:]+/, "").trim();
      if (!value) {
        const next = lines.slice(i + 1).find((l) => l.trim());
        value = next ? cleanMdMarks(next) : "";
      }
      if (value && value !== "**") {
        const parsed = splitZhEn(value);
        if (parsed.nameZh) nameZh = parsed.nameZh;
        if (parsed.nameEn) nameEn = parsed.nameEn;
        mdFieldSources.name = `名字 / Name: ${value.slice(0, 100)}`;
      }
      break;
    }
  }

  const nameSection =
    sectionBodyByHeading(content, /^##\s*名字\s*\/\s*Name/i) ||
    sectionBodyByHeading(content, /^##\s*名字\s*$/i) ||
    sectionBodyByHeading(content, /^##\s*名字\b/i);
  if (nameSection) {
    const nameLines = nameSection
      .split(/\r?\n/)
      .map((x) => cleanMdMarks(x))
      .filter(Boolean);
    const zhLine = nameLines.find((x) => cjkRatio(x) > 0.2);
    const enLine = nameLines.find((x) => /[A-Za-z]/.test(x) && cjkRatio(x) < 0.35);
    if (zhLine) nameZh = stripLeadingOrder(zhLine);
    if (enLine) nameEn = stripLeadingOrder(enLine);
    mdFieldSources.name = `## 名字 / Name section`;
  }

  if (!nameZh && fallbackStem) nameZh = stripLeadingOrder(cleanMdMarks(fallbackStem));
  nameZh = stripLeadingOrder(nameZh);
  nameEn = stripLeadingOrder(nameEn);

  let bodyPlainEn = extractBodyPlainEn(content, mdFieldSources);

  if (!nameEn && bodyPlainEn) {
    let m = bodyPlainEn.match(/^((?:The|A|An)\s[^,]{4,80})/);
    if (!m) m = bodyPlainEn.match(/^([A-Z][a-z]+(?:\s[A-Z][a-z]+){0,4})/);
    if (m) {
      nameEn = stripLeadingOrder(m[1]);
      if (!mdFieldSources.name?.includes("body")) {
        mdFieldSources.name = `${mdFieldSources.name || "fallbackStem"} + body opening`;
      }
    }
  }

  const bodyHtml = toHtml(bodyPlainEn);

  return { nameZh, nameEn, bodyPlainEn, bodyHtml, mdFieldSources };
}

function splitByHeadingSections(content) {
  const lines = content.split(/\r?\n/);
  const chunks = [];
  let cur = null;

  function pushCur() {
    if (!cur) return;
    chunks.push(cur);
    cur = null;
  }

  for (const line of lines) {
    const h3 = line.match(/^###\s*([0-9]{1,3}(?:[._-][0-9]{1,3})?)\s*[.、\-_)\s]*\s*(.+)\s*$/);
    const h2 = line.match(/^##\s*([0-9]{1,3}(?:[._-][0-9]{1,3})?)\s*[.、\-_)\s]*\s*(.+)\s*$/);
    if (h3 || h2) {
      pushCur();
      const m = h3 || h2;
      cur = { seq: m[1], title: m[2].trim(), lines: [] };
      continue;
    }
    if (cur) cur.lines.push(line);
  }
  pushCur();
  return chunks;
}

function parseImageMeta(filename) {
  const stem = basename(filename, extname(filename));
  const m = stem.match(/^(\d+)\s*[.、:：\-_)\]]*\s*(.+)$/);
  if (m) return { order: Number(m[1]), label: stripLeadingOrder(cleanMdMarks(m[2])) };
  const m2 = stem.match(/^(\d+)[_.-](.+)$/);
  if (m2) return { order: Number(m2[1]), label: stripLeadingOrder(cleanMdMarks(m2[2])) };
  return { order: 9999, label: stripLeadingOrder(cleanMdMarks(stem)) };
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

function findImage(images, ...targets) {
  const cleaned = targets.filter(Boolean).map((t) => stripLeadingOrder(cleanMdMarks(t)));
  const manualAliases = {
    茅屋故居: ["茅草故居"],
    "山门（天王殿）": ["天王殿", "文殊院-天王殿", "文殊院天王殿"],
    "正门（照壁）": ["照壁", "文殊院-照壁"],
    "三大士殿（观音殿）": ["三大士殿", "文殊院-三大士殿"],
    "五楼：重逢 1980·八十年代生活情境街区": ["五楼重逢1980", "重逢1980"],
    "Test Spirit 街巷": ["Test Sprit", "Sprit街巷", "Test_Sprit"],
    "T²国际当代艺术中心": ["T2国际当代艺术中心", "T2"],
  };
  const expanded = [...cleaned];
  for (const t of cleaned) {
    if (manualAliases[t]) expanded.push(...manualAliases[t]);
    const paren = t.split(/[（(]/)[0];
    if (paren && paren !== t) expanded.push(paren);
  }
  for (const img of images) {
    const labels = [
      img.label,
      img.label.replace(/^文殊院[-_]?/i, ""),
      basename(img.name, extname(img.name)).replace(/^文殊院[-_]?/i, ""),
    ];
    for (const lab of labels) {
      if (expanded.some((t) => namesMatch(lab, t))) return img;
      if (expanded.some((t) => namesMatch(lab.split(/[（(]/)[0], t))) return img;
    }
  }
  return null;
}

function isValidAttractionRecord(a) {
  const id = String(a?.id || "");
  if (!id || /https|workers|localhost|\.dev|yoloadmin/i.test(id)) return false;
  const cn = String(a?.chinese_name || "").trim();
  if (!cn || cn.length < 2) return false;
  return true;
}

function resolveAttraction(folderName, attractions, cityKey = null) {
  const pool = attractions.filter(isValidAttractionRecord).filter((a) => !cityKey || a.city_id === cityKey);

  const candidates = [
    folderName,
    ATTRACTION_ALIASES[folderName],
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

function resolveImageDir(cityKey, folderName, imageRoot) {
  const aliases = [folderName, IMAGE_DIR_ALIASES[folderName]].filter(Boolean);
  if (!existsSync(imageRoot)) return "";
  const dirs = readdirSync(imageRoot).filter((n) => {
    try {
      return statSync(join(imageRoot, n)).isDirectory();
    } catch {
      return false;
    }
  });
  for (const c of aliases) {
    const exact = dirs.find((d) => d === c || d.trim() === c);
    if (exact) return join(imageRoot, exact);
    const fuzzy = dirs.find((d) => norm(d.trim()) === norm(c));
    if (fuzzy) return join(imageRoot, fuzzy);
  }
  return join(imageRoot, folderName);
}

function resolveTextDir(cityKey, folderName, textRoot) {
  const aliases = [folderName, TEXT_DIR_ALIASES[folderName]].filter(Boolean);
  if (!existsSync(textRoot)) return "";
  const dirs = readdirSync(textRoot).filter((n) => statSync(join(textRoot, n)).isDirectory());
  for (const c of aliases) {
    const exact = dirs.find((d) => d === c);
    if (exact) return join(textRoot, exact);
    const fuzzy = dirs.find((d) => norm(d) === norm(c) || d.includes(c) || c.includes(d));
    if (fuzzy) return join(textRoot, fuzzy);
  }
  return join(textRoot, folderName);
}

function buildExpectedItem({
  city,
  attractionFolder,
  attractionId,
  sortIndex,
  sourceMdPath,
  parsed,
  localImagePath,
  localImageName,
}) {
  return {
    city,
    attractionFolder,
    attractionId,
    sortIndex,
    id: `${attractionId}_sa_${String(sortIndex + 1).padStart(2, "0")}`,
    nameZh: parsed.nameZh,
    nameEn: parsed.nameEn,
    bodyHtml: parsed.bodyHtml,
    bodyPlainEn: parsed.bodyPlainEn,
    localImagePath: localImagePath || null,
    localImageName: localImageName || null,
    sourceMdPath,
    mdFieldSources: parsed.mdFieldSources,
  };
}

function collectSameDirSingleMd(cityKey, root, attractions, expected, unmatched) {
  if (!existsSync(root)) return;
  for (const folderName of readdirSync(root)) {
    const dir = join(root, folderName);
    if (!statSync(dir).isDirectory()) continue;
    const parent = resolveAttraction(folderName, attractions, cityKey);
    if (!parent) {
      unmatched.push({ city: cityKey, folderName, reason: "attraction_not_found" });
      continue;
    }

    const mdFile =
      readdirSync(dir).find((n) => n.endsWith(".md") && !n.startsWith(".")) ||
      readdirSync(dir).find((n) => n.endsWith(".md"));
    if (!mdFile) {
      unmatched.push({ city: cityKey, folderName, reason: "no_md" });
      continue;
    }

    const content = readFileSync(join(dir, mdFile), "utf8");
    const images = listImages(dir);
    const sections = splitByHeadingSections(content);

    if (sections.length) {
      sections.forEach((sec, idx) => {
        const parsed = parseMdContent(sec.lines.join("\n"), { headingTitle: sec.title });
        const img = findImage(images, sec.title, parsed.nameZh) || images[idx] || null;
        expected.push(
          buildExpectedItem({
            city: cityKey,
            attractionFolder: folderName,
            attractionId: parent.id,
            sortIndex: idx,
            sourceMdPath: join(dir, mdFile),
            parsed,
            localImagePath: img?.file || null,
            localImageName: img?.name || null,
          })
        );
      });
    } else {
      const parsed = parseMdContent(content, { fallbackStem: basename(mdFile, ".md") });
      const img = images[0] || null;
      expected.push(
        buildExpectedItem({
          city: cityKey,
          attractionFolder: folderName,
          attractionId: parent.id,
          sortIndex: 0,
          sourceMdPath: join(dir, mdFile),
          parsed,
          localImagePath: img?.file || null,
          localImageName: img?.name || null,
        })
      );
    }
  }
}

function collectNestedPerFile(cityKey, root, attractions, expected, unmatched) {
  if (!existsSync(root)) return;
  for (const folderName of readdirSync(root)) {
    const outer = join(root, folderName);
    if (!statSync(outer).isDirectory()) continue;
    const parent = resolveAttraction(folderName, attractions, cityKey);
    if (!parent) {
      unmatched.push({ city: cityKey, folderName, reason: "attraction_not_found" });
      continue;
    }

    const inner = existsSync(join(outer, folderName)) ? join(outer, folderName) : outer;
    const images = listImages(outer);
    const mdFiles = readdirSync(inner)
      .filter((n) => n.endsWith(".md"))
      .map((n) => join(inner, n))
      .sort((a, b) => {
        const oa = parseImageMeta(basename(a)).order;
        const ob = parseImageMeta(basename(b)).order;
        return oa - ob || a.localeCompare(b, "zh-Hans-CN");
      });

    mdFiles.forEach((mdPath, idx) => {
      const stem = basename(mdPath, ".md");
      const parsed = parseMdContent(readFileSync(mdPath, "utf8"), { fallbackStem: stem });
      const img = findImage(images, stem, parsed.nameZh) || images[idx] || null;
      expected.push(
        buildExpectedItem({
          city: cityKey,
          attractionFolder: folderName,
          attractionId: parent.id,
          sortIndex: idx,
          sourceMdPath: mdPath,
          parsed,
          localImagePath: img?.file || null,
          localImageName: img?.name || null,
        })
      );
    });
  }
}

function collectSplitCity(cityKey, textRoot, imageRoot, attractions, expected, unmatched) {
  if (!existsSync(textRoot)) return;
  for (const folderName of readdirSync(textRoot)) {
    const mdDir = join(textRoot, folderName);
    if (!statSync(mdDir).isDirectory()) continue;
    const parent = resolveAttraction(folderName, attractions, cityKey);
    if (!parent) {
      unmatched.push({ city: cityKey, folderName, reason: "attraction_not_found" });
      continue;
    }

    const imageDir = resolveImageDir(cityKey, folderName, imageRoot);
    const images = listImages(imageDir);
    const mdFiles = readdirSync(mdDir)
      .filter((n) => n.endsWith(".md"))
      .map((n) => join(mdDir, n));

    const items = mdFiles.map((mdPath) => {
      const stem = basename(mdPath, ".md");
      const parsed = parseMdContent(readFileSync(mdPath, "utf8"), { fallbackStem: stem });
      const img = findImage(images, stem, parsed.nameZh);
      return { mdPath, stem, parsed, img };
    });
    items.sort(
      (a, b) =>
        (a.img ? a.img.order : parseImageMeta(a.stem).order) -
          (b.img ? b.img.order : parseImageMeta(b.stem).order) ||
        a.stem.localeCompare(b.stem, "zh-Hans-CN")
    );

    items.forEach(({ mdPath, parsed, img }, idx) => {
      expected.push(
        buildExpectedItem({
          city: cityKey,
          attractionFolder: folderName,
          attractionId: parent.id,
          sortIndex: idx,
          sourceMdPath: mdPath,
          parsed,
          localImagePath: img?.file || null,
          localImageName: img?.name || null,
        })
      );
    });
  }
}

function collectChongqing(cityKey, root, attractions, expected, unmatched) {
  const textRoot = join(root, "重庆子景点-信息");
  const imageRoot = root;
  if (!existsSync(textRoot)) return;

  for (const folderName of readdirSync(textRoot)) {
    const mdDir = join(textRoot, folderName);
    if (!statSync(mdDir).isDirectory()) continue;
    const parent = resolveAttraction(folderName, attractions, cityKey);
    if (!parent) {
      unmatched.push({ city: cityKey, folderName, reason: "attraction_not_found" });
      continue;
    }

    const imageDir = resolveImageDir(cityKey, folderName, imageRoot);
    const images = listImages(imageDir);
    const mdFiles = readdirSync(mdDir).filter((n) => n.endsWith(".md")).map((n) => join(mdDir, n));

    const items = mdFiles.map((mdPath) => {
      const stem = basename(mdPath, ".md");
      const parsed = parseMdContent(readFileSync(mdPath, "utf8"), { fallbackStem: stem });
      const img = findImage(images, stem, parsed.nameZh) || findImage(images, parseImageMeta(stem).label);
      return { mdPath, stem, parsed, img };
    });
    items.sort(
      (a, b) =>
        (a.img ? a.img.order : parseImageMeta(a.stem).order) -
          (b.img ? b.img.order : parseImageMeta(b.stem).order) ||
        a.stem.localeCompare(b.stem, "zh-Hans-CN")
    );

    items.forEach(({ mdPath, parsed, img }, idx) => {
      expected.push(
        buildExpectedItem({
          city: cityKey,
          attractionFolder: folderName,
          attractionId: parent.id,
          sortIndex: idx,
          sourceMdPath: mdPath,
          parsed,
          localImagePath: img?.file || null,
          localImageName: img?.name || null,
        })
      );
    });
  }
}

function collectChengdu(cityKey, root, attractions, expected, unmatched) {
  const textRoot = join(root, "成都子景点-信息");
  const imageRoot = root;
  if (!existsSync(textRoot)) return;

  for (const infoFolder of readdirSync(textRoot)) {
    const mdDir = join(textRoot, infoFolder);
    if (!statSync(mdDir).isDirectory()) continue;
    const folderName = infoFolder
      .replace(/子景点信息/g, "")
      .replace(/景点信息/g, "")
      .replace(/^成都/, "");
    const parent =
      resolveAttraction(infoFolder, attractions, cityKey) || resolveAttraction(folderName, attractions, cityKey);
    if (!parent) {
      unmatched.push({ city: cityKey, folderName: infoFolder, reason: "attraction_not_found" });
      continue;
    }

    const imageDir = resolveImageDir(cityKey, folderName, imageRoot);
    const images = listImages(imageDir);
    const mdFiles = readdirSync(mdDir).filter((n) => n.endsWith(".md")).map((n) => join(mdDir, n));

    const items = mdFiles.map((mdPath) => {
      const stem = basename(mdPath, ".md");
      const parsed = parseMdContent(readFileSync(mdPath, "utf8"), { fallbackStem: stem });
      const img = findImage(images, stem, parsed.nameZh);
      return { mdPath, stem, parsed, img };
    });
    items.sort(
      (a, b) =>
        (a.img ? a.img.order : parseImageMeta(a.stem).order) -
          (b.img ? b.img.order : parseImageMeta(b.stem).order) ||
        a.stem.localeCompare(b.stem, "zh-Hans-CN")
    );

    items.forEach(({ mdPath, parsed, img }, idx) => {
      expected.push(
        buildExpectedItem({
          city: cityKey,
          attractionFolder: infoFolder,
          attractionId: parent.id,
          sortIndex: idx,
          sourceMdPath: mdPath,
          parsed,
          localImagePath: img?.file || null,
          localImageName: img?.name || null,
        })
      );
    });
  }
}

function loadHistoricalNotes() {
  const notes = new Map();
  const files = [
    "all_content_report.json",
    "all_content_patch_unmatched_report.json",
    "all_content_patch_unmatched_v2_report.json",
    "all_content_patch_unmatched_v3_report.json",
    "shanghai_sub_areas_with_images_report.json",
    "nanjing_sub_areas_with_images_report.json",
    "hangzhou_sub_areas_with_images_report.json",
    "suzhou_sub_areas_with_images_report.json",
    "chongqing_sub_areas_with_images_report.json",
    "chengdu_museum_sub_areas_with_images_report.json",
  ];

  for (const file of files) {
    const path = join(OUT_DIR, file);
    if (!existsSync(path)) continue;
    try {
      const data = JSON.parse(readFileSync(path, "utf8"));
      for (const item of data.unmatched?.images || []) {
        const id = String(item).replace(/^backend:/, "").split(":")[0];
        notes.set(id, `historical unmatched image (${file})`);
      }
      for (const item of data.stillUnmatched?.images || []) {
        const id = String(item).replace(/^backend:/, "").split(":")[0];
        notes.set(id, `still unmatched after patch (${file})`);
      }
      for (const item of data.missingImages || []) {
        if (item.md) notes.set(`${item.attraction}:${item.nameZh}`, `missing image in ${file}`);
      }
    } catch {}
  }
  return notes;
}

function findActualRow(expected, actualById, actualByAttraction) {
  const byId = actualById.get(expected.id);
  if (byId && (namesMatch(byId.name_zh, expected.nameZh) || !expected.nameZh)) {
    return { row: byId, matchMethod: "sort_order_id" };
  }

  const pool = (actualByAttraction.get(expected.attractionId) || []).filter((r) => r.is_active !== false);
  if (byId && pool.length === 1) return { row: byId, matchMethod: "sort_order_id" };

  let best = byId || null;
  let bestScore = byId ? (namesMatch(byId.name_zh, expected.nameZh) ? 2 : 0) : -1;

  for (const row of pool) {
    let score = 0;
    if (namesMatch(row.name_zh, expected.nameZh)) score += 3;
    if (expected.nameEn && namesMatch(row.name_en, expected.nameEn)) score += 2;
    if (row.sort_order === expected.sortIndex) score += 1;
    if (score > bestScore) {
      bestScore = score;
      best = row;
    }
  }

  if (!best) return { row: null, matchMethod: "none" };
  const method =
    best.id === expected.id
      ? "sort_order_id"
      : namesMatch(best.name_zh, expected.nameZh)
        ? "name_fuzzy"
        : "sort_order_fallback";
  return { row: best, matchMethod: method };
}

function compareExpectedActual(expected, actualRow, matchMethod, historicalNotes) {
  const issues = [];
  const statusSet = new Set();

  if (!actualRow) {
    issues.push("missing_in_db");
    statusSet.add("missing_in_db");
    return { issues: [...statusSet], issueDetails: issues, actual: null, status: "missing_in_db", matchMethod };
  }

  const actual = actualRow;

  if (!namesMatch(actual.name_zh, expected.nameZh)) {
    issues.push("name_zh_mismatch");
    statusSet.add("name_zh_mismatch");
  }

  if (
    !expected.nameEn ||
    !actual.name_en ||
    isPlaceholderNameEn(actual.name_en, expected.attractionId, expected.sortIndex) ||
    !namesMatch(actual.name_en, expected.nameEn)
  ) {
    if (expected.nameEn) {
      issues.push("name_en_missing");
      statusSet.add("name_en_missing");
    }
  }

  if (!expected.bodyPlainEn) {
    issues.push("md_body_missing");
    statusSet.add("md_body_missing");
  } else if (!actual.body || !stripHtml(actual.body)) {
    issues.push("body_empty");
    statusSet.add("body_empty");
  } else if (!textsMatch(actual.body, expected.bodyPlainEn)) {
    issues.push("body_not_from_md");
    statusSet.add("body_not_from_md");
  }

  if (!actual.cover_image_path) {
    issues.push("cover_missing");
    statusSet.add("cover_missing");
  } else if (!expected.localImagePath) {
    issues.push("cover_no_local_image");
    statusSet.add("cover_no_local_image");
  }

  const historicalNote = historicalNotes.get(expected.id) || historicalNotes.get(`${expected.attractionFolder}:${expected.nameZh}`) || null;

  const status = statusSet.size === 0 ? "ok" : [...statusSet].sort()[0];
  return { issues: [...statusSet], issueDetails: issues, actual, status, historicalNote, matchMethod };
}

function sqlStr(v) {
  if (v == null) return "NULL";
  return `'${String(v).replace(/'/g, "''")}'`;
}

function buildFixSql(rows) {
  const lines = [
    "-- Fix sub_areas name/body from md source (text fields only)",
    `-- Generated: ${new Date().toISOString()}`,
    `-- Rows: ${rows.length}`,
    "",
  ];
  for (const row of rows) {
    lines.push(`UPDATE sub_areas SET
  name_zh = ${sqlStr(row.nameZh)},
  name_en = ${sqlStr(row.nameEn)},
  body = ${sqlStr(row.bodyHtml)},
  updated_at = NOW()
WHERE id = ${sqlStr(row.id)};`);
    lines.push("");
  }
  return lines.join("\n");
}

function buildSummary(auditRows, stats) {
  const lines = [
    `# 子景点内容核对报告`,
    "",
    `生成时间：${new Date().toISOString()}`,
    "",
    "## 汇总",
    "",
    `- 应有（md）：${stats.totalExpected} 条`,
    `- 已匹配 DB：${stats.matchedInDb} 条`,
    `- 完全一致：${stats.ok} 条`,
    `- 需修复名称/正文：${stats.textIssues} 条`,
    `- 封面问题：${stats.coverIssues} 条`,
    `- DB 缺失：${stats.missingInDb} 条`,
    `- 源文件夹未匹配景点：${stats.unmatchedFolders} 个`,
    "",
  ];

  const byCity = new Map();
  for (const row of auditRows) {
    if (!byCity.has(row.city)) byCity.set(row.city, []);
    byCity.get(row.city).push(row);
  }

  for (const [city, rows] of [...byCity.entries()].sort()) {
    lines.push(`## ${city}`);
    const byAttr = new Map();
    for (const r of rows) {
      const key = `${r.attractionFolder} (${r.attractionId})`;
      if (!byAttr.has(key)) byAttr.set(key, []);
      byAttr.get(key).push(r);
    }
    for (const [attrKey, attrRows] of byAttr) {
      const okCount = attrRows.filter((r) => r.status === "ok").length;
      lines.push(`### ${attrKey} — ${okCount}/${attrRows.length} ok`);
      for (const r of attrRows) {
        const note = r.historicalNote ? ` — ${r.historicalNote}` : "";
        if (r.status === "ok") {
          lines.push(`- [ok] ${r.id} ${r.nameZh}`);
        } else {
          lines.push(`- [${r.status}] ${r.id} ${r.nameZh} (${r.issues.join(", ")})${note}`);
        }
      }
      lines.push("");
    }
  }
  return lines.join("\n");
}

function translateHistoricalNote(note) {
  if (!note) return "";
  return String(note)
    .replace(/^historical unmatched image \((.+)\)$/, "历史导入时图片未匹配（$1）")
    .replace(/^still unmatched after patch \((.+)\)$/, "补丁后仍未匹配（$1）")
    .replace(/^missing image in (.+)$/, "本地图片缺失（$1）");
}

function statusLabelZh(status) {
  const map = {
    ok: "通过",
    name_zh_mismatch: "中文名不符",
    name_en_missing: "英文名问题",
    body_empty: "正文为空",
    body_not_from_md: "正文不符",
    md_body_missing: "md 无英文正文",
    cover_missing: "缺封面",
    cover_no_local_image: "封面无本地图",
    missing_in_db: "DB 缺失",
  };
  return map[status] || status;
}

function describeIssuesZh(row) {
  if (row.status === "ok") return "无问题：中文名、英文名、正文、封面均与 md / 本地图片一致";

  const parts = [];
  const act = row.actual || {};
  const expZh = row.nameZh || "（空）";
  const expEn = row.nameEn || "（空）";
  const actZh = act.name_zh || "（空）";
  const actEn = act.name_en || "（空）";

  for (const issue of row.issues) {
    switch (issue) {
      case "name_zh_mismatch":
        parts.push(`中文名不一致：DB 为「${actZh}」，md 应为「${expZh}」`);
        break;
      case "name_en_missing":
        if (!act.name_en) parts.push(`英文名为空或占位：DB 为「${actEn}」，md 应为「${expEn}」`);
        else parts.push(`英文名不一致：DB 为「${actEn}」，md 应为「${expEn}」`);
        break;
      case "body_empty":
        parts.push(`正文为空：DB 无 body，md 有英文长文描述（约 ${row.expectedBodyLength || 0} 字）`);
        break;
      case "body_not_from_md":
        parts.push(
          `正文与 md 不符：DB 正文约 ${act.bodyLength || 0} 字，md 英文长文约 ${row.expectedBodyLength || 0} 字，需以 md 为准`
        );
        break;
      case "md_body_missing":
        parts.push("md 未提取到英文正文（「长文描述/描述 / Description」无英文段落，或格式暂不支持）");
        break;
      case "cover_missing":
        parts.push("封面缺失：DB 无 cover_image_path");
        break;
      case "cover_no_local_image":
        parts.push(
          row.localImageName
            ? `本地图片未配对：DB 有封面 URL，但素材目录未找到对应图片（期望：${row.localImageName}）`
            : "本地图片未配对：DB 有封面 URL，但素材目录找不到对应图片文件"
        );
        break;
      case "missing_in_db":
        parts.push("DB 缺失：线上 sub_areas 无此子景点记录");
        break;
      default:
        parts.push(issue);
    }
  }

  if (row.dbId && row.dbId !== row.id) {
    parts.push(`（按名称匹配到 DB 记录 ${row.dbId}，非序号 ${row.id}）`);
  }

  return parts.join("；");
}

function buildFullListChinese(auditRows, stats, unmatchedFolders, extraInDb) {
  const esc = (s) => String(s || "").replace(/\|/g, "\\|").replace(/\n/g, " ");
  const lines = [
    "# 子景点核对完整列表",
    "",
    `生成时间：${stats.generatedAt}`,
    "",
    "说明：以 Downloads md 为名称/正文标准，封面以本地图片目录核对。每条「问题说明」用中文描述具体差异。",
    "",
    "| # | 城市 | 景点 | ID | 中文名 | 核对结果 | 问题说明 | 历史备注 |",
    "|---|------|------|----|--------|----------|----------|----------|",
  ];

  let n = 0;
  for (const city of ["nanjing", "suzhou", "hangzhou", "shanghai", "chengdu", "chongqing"]) {
    const cr = auditRows
      .filter((r) => r.city === city)
      .sort((a, b) => a.attractionFolder.localeCompare(b.attractionFolder, "zh-Hans-CN") || a.sortIndex - b.sortIndex);
    for (const row of cr) {
      n += 1;
      lines.push(
        `| ${n} | ${CITY_ZH[city] || city} | ${esc(row.attractionFolder)} | ${esc(row.id)} | ${esc(row.nameZh)} | ${statusLabelZh(row.status)} | ${esc(describeIssuesZh(row))} | ${esc(translateHistoricalNote(row.historicalNote))} |`
      );
    }
  }

  lines.push("");
  lines.push("## 未纳入审计的景点文件夹");
  if (unmatchedFolders.length) {
    for (const u of unmatchedFolders) {
      lines.push(
        `- **${CITY_ZH[u.city] || u.city} / ${u.folderName}**：${u.reason === "attraction_not_found" ? "attractions 表找不到对应主景点，子景点未计入上表" : u.reason}`
      );
    }
  } else {
    lines.push("- 无");
  }

  lines.push("");
  lines.push(`## DB 多余条目（${extraInDb.length} 条，md 源中无对应子景点）`);
  for (const e of extraInDb) {
    lines.push(`- ${e.id}｜${e.attraction_id}｜${e.name_zh}`);
  }

  return lines.join("\n");
}

async function main() {
  mkdirSync(OUT_DIR, { recursive: true });
  const { url, key } = getSupabaseConfig();
  const supabase = createClient(url, key, { auth: { persistSession: false } });

  const { data: attractions, error: attrErr } = await supabase.from("attractions").select("id,chinese_name,city_id");
  if (attrErr) throw new Error(attrErr.message);

  const scopeIds = new Set();
  const expected = [];
  const unmatchedFolders = [];

  const collectors = [
    {
      city: "nanjing",
      run: () => collectSameDirSingleMd("nanjing", join(SOURCE_ROOT, "南京子景点"), attractions, expected, unmatchedFolders),
    },
    {
      city: "suzhou",
      run: () => collectSameDirSingleMd("suzhou", join(SOURCE_ROOT, "苏州子景点"), attractions, expected, unmatchedFolders),
    },
    {
      city: "hangzhou",
      run: () => collectNestedPerFile("hangzhou", join(SOURCE_ROOT, "杭州子景点"), attractions, expected, unmatchedFolders),
    },
    {
      city: "shanghai",
      run: () =>
        collectSplitCity(
          "shanghai",
          join(SOURCE_ROOT, "上海子景点", "上海子景点-文字信息"),
          join(SOURCE_ROOT, "上海子景点"),
          attractions,
          expected,
          unmatchedFolders
        ),
    },
    {
      city: "chengdu",
      run: () => collectChengdu("chengdu", join(SOURCE_ROOT, "成都子景点"), attractions, expected, unmatchedFolders),
    },
    {
      city: "chongqing",
      run: () => collectChongqing("chongqing", join(SOURCE_ROOT, "重庆子景点"), attractions, expected, unmatchedFolders),
    },
  ];

  for (const c of collectors) {
    if (cityFilter && c.city !== cityFilter) continue;
    c.run();
  }

  for (const item of expected) scopeIds.add(item.attractionId);

  const { data: subAreas, error: saErr } = await supabase
    .from("sub_areas")
    .select("id,attraction_id,name_en,name_zh,body,cover_image_path,sort_order,is_active")
    .in("attraction_id", [...scopeIds])
    .order("sort_order");
  if (saErr) throw new Error(saErr.message);

  const actualById = new Map(subAreas.map((r) => [r.id, r]));
  const actualByAttraction = new Map();
  for (const row of subAreas) {
    if (!actualByAttraction.has(row.attraction_id)) actualByAttraction.set(row.attraction_id, []);
    actualByAttraction.get(row.attraction_id).push(row);
  }

  const historicalNotes = loadHistoricalNotes();
  const auditRows = [];
  const fixRowsById = new Map();
  const issueCounts = {};

  for (const exp of expected) {
    const { row: actualRow, matchMethod } = findActualRow(exp, actualById, actualByAttraction);
    const cmp = compareExpectedActual(exp, actualRow, matchMethod, historicalNotes);
    const dbId = actualRow?.id || exp.id;

    const row = {
      city: exp.city,
      attractionFolder: exp.attractionFolder,
      attractionId: exp.attractionId,
      id: exp.id,
      dbId,
      matchMethod,
      sortIndex: exp.sortIndex,
      nameZh: exp.nameZh,
      nameEn: exp.nameEn,
      sourceMdPath: exp.sourceMdPath,
      mdFieldSources: exp.mdFieldSources,
      localImagePath: exp.localImagePath,
      localImageName: exp.localImageName,
      expectedBodyLength: exp.bodyPlainEn.length,
      status: cmp.status,
      issues: cmp.issues,
      historicalNote: cmp.historicalNote,
      actual: actualRow
        ? {
            name_zh: actualRow.name_zh,
            name_en: actualRow.name_en,
            bodyLength: stripHtml(actualRow.body).length,
            cover_image_path: actualRow.cover_image_path,
            sort_order: actualRow.sort_order,
          }
        : null,
    };
    auditRows.push(row);
    for (const issue of cmp.issues) issueCounts[issue] = (issueCounts[issue] || 0) + 1;

    if (
      fixSql &&
      actualRow &&
      exp.nameZh &&
      cmp.issues.some((i) =>
        ["name_zh_mismatch", "name_en_missing", "body_empty", "body_not_from_md"].includes(i)
      )
    ) {
      const needsBody = cmp.issues.some((i) => ["body_empty", "body_not_from_md"].includes(i));
      if (!needsBody || exp.bodyHtml) {
        fixRowsById.set(dbId, {
          id: dbId,
          nameZh: exp.nameZh,
          nameEn: exp.nameEn || actualRow.name_en || exp.nameZh,
          bodyHtml: exp.bodyHtml || actualRow.body || "",
        });
      }
    }
  }

  const fixRows = [...fixRowsById.values()];
  const expectedIds = new Set(expected.map((e) => e.id));
  const extraInDb = subAreas.filter((r) => !expectedIds.has(r.id));

  const stats = {
    generatedAt: new Date().toISOString(),
    cityFilter,
    totalExpected: expected.length,
    matchedInDb: auditRows.filter((r) => r.actual).length,
    ok: auditRows.filter((r) => r.status === "ok").length,
    textIssues: auditRows.filter((r) =>
      r.issues.some((i) =>
        ["name_zh_mismatch", "name_en_missing", "body_empty", "body_not_from_md", "md_body_missing"].includes(i)
      )
    ).length,
    coverIssues: auditRows.filter((r) =>
      r.issues.some((i) => ["cover_missing", "cover_no_local_image"].includes(i))
    ).length,
    missingInDb: auditRows.filter((r) => r.status === "missing_in_db").length,
    extraInDb: extraInDb.length,
    unmatchedFolders: unmatchedFolders.length,
    issueCounts,
    byCity: {},
  };

  for (const city of ["nanjing", "suzhou", "hangzhou", "shanghai", "chengdu", "chongqing"]) {
    const rows = auditRows.filter((r) => r.city === city);
    if (!rows.length) continue;
    stats.byCity[city] = {
      expected: rows.length,
      ok: rows.filter((r) => r.status === "ok").length,
      textIssues: rows.filter((r) =>
        r.issues.some((i) => ["name_zh_mismatch", "name_en_missing", "body_empty", "body_not_from_md"].includes(i))
      ).length,
      coverIssues: rows.filter((r) => r.issues.some((i) => ["cover_missing", "cover_no_local_image"].includes(i))).length,
    };
  }

  writeFileSync(
    OUT_REPORT,
    `${JSON.stringify(
      {
        stats,
        unmatchedFolders,
        extraInDb: extraInDb.map((r) => ({ id: r.id, attraction_id: r.attraction_id, name_zh: r.name_zh })),
        rows: auditRows,
      },
      null,
      2
    )}\n`,
    "utf8"
  );
  writeFileSync(OUT_STATS, `${JSON.stringify(stats, null, 2)}\n`, "utf8");
  writeFileSync(OUT_SUMMARY, buildSummary(auditRows, stats), "utf8");
  writeFileSync(
    OUT_FULL_LIST,
    `${buildFullListChinese(
      auditRows,
      stats,
      unmatchedFolders,
      extraInDb.map((r) => ({ id: r.id, attraction_id: r.attraction_id, name_zh: r.name_zh }))
    )}\n`,
    "utf8"
  );

  if (fixSql || fixRows.length) {
    writeFileSync(OUT_FIX_SQL, buildFixSql(fixRows), "utf8");
  }

  console.log("Audit complete");
  console.log(JSON.stringify(stats, null, 2));
  console.log(`Report: ${OUT_REPORT}`);
  console.log(`Summary: ${OUT_SUMMARY}`);
  if (fixRows.length) console.log(`Fix SQL: ${OUT_FIX_SQL} (${fixRows.length} rows)`);
}

export {
  parseMdContent,
  listImages,
  findImage,
  parseImageMeta,
  resolveAttraction,
  isValidAttractionRecord,
  collectChengdu,
  collectChongqing,
  buildExpectedItem,
  cleanMdMarks,
  stripLeadingOrder,
};

import { fileURLToPath } from "url";

const isMain = process.argv[1] && fileURLToPath(import.meta.url) === process.argv[1];

if (isMain) {
  main().catch((err) => {
    console.error(err.message || err);
    process.exit(1);
  });
}
