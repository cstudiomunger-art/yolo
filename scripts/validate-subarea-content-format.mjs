#!/usr/bin/env node
/**
 * 校验子景点内容是否符合 docs/sub-area-content-spec.md 唯一固定格式。
 *
 * Usage:
 *   node scripts/validate-subarea-content-format.mjs 杭州/西湖
 *   node scripts/validate-subarea-content-format.mjs /absolute/path/to/attraction
 *   node scripts/validate-subarea-content-format.mjs --scan-known
 */
import { existsSync, mkdirSync, readFileSync, readdirSync, statSync, writeFileSync } from "fs";
import { basename, extname, join } from "path";

const ROOT = "/Users/vesperal/Desktop/YOLO";
const OUT_DIR = join(ROOT, "scripts/generated");
const OUT_MD = join(OUT_DIR, "sub_area_format_validation_report.md");
const OUT_JSON = join(OUT_DIR, "sub_area_format_validation_report.json");

const KNOWN_ROOTS = [
  "/Users/vesperal/Downloads/后台填写信息汇总（照片+文字信息）",
  "/Users/vesperal/Desktop/成都子景点",
  "/Users/vesperal/Desktop/重庆子景点",
  "/Users/vesperal/Desktop/新子景点信息",
  "/Users/vesperal/Desktop/新上海子景点信息",
  "/Users/vesperal/Desktop/新南京子景点信息",
  "/Users/vesperal/Desktop/北京",
  "/Users/vesperal/Desktop/成都",
];

const FILE_RE = /^(\d{2})\.(.+)\.(md|jpg)$/i;
const FORBIDDEN_SECTIONS = ["摘要", "详细地址", "门票", "开放时间", "交通"];

function cjkRatio(s) {
  const t = String(s || "");
  if (!t) return 0;
  return (t.match(/[\u4e00-\u9fff]/g) || []).length / t.length;
}

function parseCanonicalMd(text) {
  const issues = [];
  const lines = text.split(/\r?\n/);

  const h1 = lines.find((l) => /^#\s+/.test(l));
  if (!h1) issues.push("缺少 # 标题行");

  const sections = [];
  for (const line of lines) {
    const m = line.match(/^##\s+(.+?)\s*$/);
    if (m) sections.push(m[1].trim());
  }

  if (sections.length !== 2) {
    issues.push(`应仅有 2 个 ## 节（名字、长文描述），实际: ${sections.join("、") || "无"}`);
  } else {
    if (sections[0] !== "名字") issues.push(`第 1 节应为「名字」，实际「${sections[0]}」`);
    if (sections[1] !== "长文描述") issues.push(`第 2 节应为「长文描述」，实际「${sections[1]}」`);
  }

  for (const s of sections) {
    if (FORBIDDEN_SECTIONS.some((f) => s.includes(f))) {
      issues.push(`含禁止章节「${s}」`);
    }
  }

  const nameZhM = text.match(/中文[：:]\s*(.+)/);
  const nameEnM = text.match(/English[：:]\s*(.+)/i);
  if (!nameZhM?.[1]?.trim()) issues.push("缺少「中文：」");
  if (!nameEnM?.[1]?.trim()) issues.push("缺少「English:」");

  const descStart = text.search(/^##\s+长文描述\s*$/m);
  let bodyText = "";
  if (descStart >= 0) {
    bodyText = text.slice(descStart).replace(/^##\s+长文描述\s*[\r\n]*/m, "");
  } else {
    issues.push("缺少「## 长文描述」节");
  }

  const bodyLines = bodyText
    .split(/\r?\n/)
    .map((l) => l.trim())
    .filter((l) => l && !l.startsWith("##"));

  const enLines = bodyLines.filter((l) => cjkRatio(l) < 0.35 && /[A-Za-z]/.test(l));
  if (!enLines.length) issues.push("长文描述无有效英文段落");

  const zhInBody = bodyLines.filter((l) => cjkRatio(l) > 0.35);
  if (zhInBody.length) issues.push("长文描述含中文行（应仅英文）");

  return {
    nameZh: nameZhM?.[1]?.trim() || "",
    nameEn: nameEnM?.[1]?.trim() || "",
    issues,
    ok: issues.length === 0,
  };
}

function validateAttractionFolder(dirPath, meta = {}) {
  const result = {
    path: dirPath,
    city: meta.city || "",
    attraction: meta.attraction || basename(dirPath),
    ok: true,
    pairs: [],
    issues: [],
  };

  if (!existsSync(dirPath)) {
    result.ok = false;
    result.issues.push({ level: "error", message: "目录不存在" });
    return result;
  }

  const entries = readdirSync(dirPath).filter((n) => !n.startsWith("."));
  const mds = new Map();
  const jpgs = new Map();

  for (const name of entries) {
    const full = join(dirPath, name);
    if (statSync(full).isDirectory()) {
      result.ok = false;
      result.issues.push({ level: "error", message: `不允许子目录: ${name}` });
      continue;
    }

    const m = name.match(FILE_RE);
    if (!m) {
      result.ok = false;
      result.issues.push({ level: "error", message: `非法文件名: ${name}（应为 NN.中文名.md/jpg）` });
      continue;
    }

    const stem = `${m[1]}.${m[2]}`;
    if (m[3].toLowerCase() === "md") mds.set(stem, name);
    else jpgs.set(stem, name);
  }

  const allStems = new Set([...mds.keys(), ...jpgs.keys()]);
  for (const stem of [...allStems].sort()) {
    const mdFile = mds.get(stem);
    const jpgFile = jpgs.get(stem);
    const pair = { stem, md: mdFile || null, jpg: jpgFile || null, issues: [] };

    if (!mdFile) pair.issues.push("缺 .md");
    if (!jpgFile) pair.issues.push("缺 .jpg");

    if (mdFile) {
      const parsed = parseCanonicalMd(readFileSync(join(dirPath, mdFile), "utf8"));
      pair.nameZh = parsed.nameZh;
      pair.nameEn = parsed.nameEn;
      pair.issues.push(...parsed.issues);

      const fileZh = stem.replace(/^\d{2}\./, "");
      if (parsed.nameZh && parsed.nameZh !== fileZh) {
        pair.issues.push(`文件名中文「${fileZh}」与 md 中文「${parsed.nameZh}」不一致`);
      }
    }

    if (pair.issues.length) result.ok = false;
    result.pairs.push(pair);
  }

  if (!result.pairs.length) {
    result.ok = false;
    result.issues.push({ level: "error", message: "目录内无合法子景点文件对" });
  }

  return result;
}

function discoverAttractionDirs(root) {
  const out = [];
  if (!existsSync(root)) return out;

  const cityName = basename(root).replace(/子景点.*/, "").replace(/子景点$/, "") || basename(root);

  function walk(dir, depth, city) {
    const entries = readdirSync(dir).filter((n) => !n.startsWith("."));
    const hasMd = entries.some((n) => n.endsWith(".md"));
    const hasImg = entries.some((n) => /\.(jpg|jpeg|png|webp)$/i.test(n));

    if (hasMd || hasImg) {
      out.push({ path: dir, city, attraction: basename(dir) });
      return;
    }

    if (depth >= 4) return;
    for (const name of entries) {
      const full = join(dir, name);
      if (statSync(full).isDirectory()) {
        const nextCity = depth === 0 ? name.replace(/子景点.*/, "").replace(/子景点$/, "") || name : city;
        walk(full, depth + 1, nextCity);
      }
    }
  }

  walk(root, 0, cityName);
  return out;
}

function buildMarkdown(report) {
  const lines = [
    "# 子景点格式校验报告",
    "",
    `生成时间：${report.generatedAt}`,
    "",
    `- 扫描目录数：${report.scanned}`,
    `- 合规：${report.passed}`,
    `- 不合规：${report.failed}`,
    "",
  ];

  if (report.failed) {
    lines.push("## 不合规主景点", "");
    for (const r of report.results.filter((x) => !x.ok)) {
      lines.push(`### ${r.city} / ${r.attraction}`, "");
      lines.push(`- 路径：\`${r.path}\``);
      for (const iss of r.issues) {
        lines.push(`- ${iss.message}`);
      }
      for (const p of r.pairs) {
        if (!p.issues.length) continue;
        lines.push(`- **${p.stem}**：${p.issues.join("；")}`);
      }
      lines.push("");
    }
  }

  if (report.passed) {
    lines.push("## 合规主景点", "");
    for (const r of report.results.filter((x) => x.ok)) {
      lines.push(`- ${r.city} / ${r.attraction}（${r.pairs.length} 个子景点）`);
    }
    lines.push("");
  }

  return `${lines.join("\n")}\n`;
}

function main() {
  mkdirSync(OUT_DIR, { recursive: true });
  const args = process.argv.slice(2);
  const scanKnown = args.includes("--scan-known");
  const targets = args.filter((a) => !a.startsWith("--"));

  const dirs = [];
  if (scanKnown) {
    for (const root of KNOWN_ROOTS) {
      dirs.push(...discoverAttractionDirs(root));
    }
  } else if (targets.length) {
    for (const t of targets) {
      const p = t.startsWith("/") ? t : join(process.cwd(), t);
      dirs.push({ path: p, city: basename(join(p, "..")), attraction: basename(p) });
    }
  } else {
    console.error("用法: node scripts/validate-subarea-content-format.mjs <景点目录> | --scan-known");
    process.exit(1);
  }

  const results = dirs.map((d) => validateAttractionFolder(d.path, d));
  const passed = results.filter((r) => r.ok).length;
  const report = {
    generatedAt: new Date().toISOString(),
    spec: "docs/sub-area-content-spec.md",
    scanned: results.length,
    passed,
    failed: results.length - passed,
    results,
  };

  writeFileSync(OUT_JSON, JSON.stringify(report, null, 2), "utf8");
  writeFileSync(OUT_MD, buildMarkdown(report), "utf8");

  console.log(`scanned: ${report.scanned}, passed: ${passed}, failed: ${report.failed}`);
  console.log(`report: ${OUT_MD}`);
  process.exit(report.failed ? 1 : 0);
}

main();
