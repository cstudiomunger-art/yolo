#!/usr/bin/env node
/**
 * 校验主景点内容是否符合 docs/attraction-content-spec.md
 *
 * Usage:
 *   node scripts/validate-attraction-content-format.mjs 杭州
 *   node scripts/validate-attraction-content-format.mjs --scan-known
 */
import { existsSync, mkdirSync, readFileSync, readdirSync, statSync, writeFileSync } from "fs";
import { basename, extname, join } from "path";

const ROOT = "/Users/vesperal/Desktop/YOLO";
const CONFIG_PATH = join(ROOT, "scripts/city-attractions-config.json");
const OUT_DIR = join(ROOT, "scripts/generated");
const OUT_MD = join(OUT_DIR, "attraction_format_validation_report.md");
const OUT_JSON = join(OUT_DIR, "attraction_format_validation_report.json");

const REQUIRED_SECTIONS = ["名字", "一句话", "300字描述", "详细地址", "门票", "开放时间", "交通"];

function cjkRatio(s) {
  const t = String(s || "");
  if (!t) return 0;
  return (t.match(/[\u4e00-\u9fff]/g) || []).length / t.length;
}

function sectionBody(text, name) {
  const re = new RegExp(`^##\\s+${name.replace(/[.*+?^${}()|[\]\\]/g, "\\$&")}\\s*$`, "m");
  const m = text.match(re);
  if (!m) return null;
  const start = m.index + m[0].length;
  const rest = text.slice(start);
  const next = rest.search(/^##\s+/m);
  return (next >= 0 ? rest.slice(0, next) : rest).trim();
}

function parseMd(text) {
  const issues = [];
  const sections = [];
  for (const line of text.split(/\r?\n/)) {
    const m = line.match(/^##\s+(.+?)\s*$/);
    if (m) sections.push(m[1].trim());
  }

  if (sections.length !== REQUIRED_SECTIONS.length) {
    issues.push(`应有 ${REQUIRED_SECTIONS.length} 个 ## 节，实际: ${sections.join("、") || "无"}`);
  }
  REQUIRED_SECTIONS.forEach((name, i) => {
    if (sections[i] !== name) issues.push(`第 ${i + 1} 节应为「${name}」，实际「${sections[i] || "缺失"}」`);
  });

  const nameZhM = text.match(/中文[：:]\s*(.+)/);
  const nameEnM = text.match(/English[：:]\s*(.+)/i);
  if (!nameZhM?.[1]?.trim()) issues.push("缺少「中文：」");
  if (!nameEnM?.[1]?.trim()) issues.push("缺少「English:」");

  const enOnlySections = ["一句话", "300字描述", "门票", "开放时间", "交通"];
  for (const sec of enOnlySections) {
    const body = sectionBody(text, sec);
    if (!body) {
      issues.push(`缺少「## ${sec}」内容`);
      continue;
    }
    const lines = body.split(/\r?\n/).map((l) => l.trim()).filter(Boolean);
    const enLines = lines.filter((l) => cjkRatio(l) < 0.35 && /[A-Za-z]/.test(l));
    if (!enLines.length) issues.push(`「${sec}」无有效英文内容`);
    const zhLines = lines.filter((l) => cjkRatio(l) > 0.35);
    if (zhLines.length) issues.push(`「${sec}」含中文行（应仅英文）`);
  }

  const addr = sectionBody(text, "详细地址");
  if (addr) {
    if (!/中文[：:]\s*\S/.test(addr)) issues.push("详细地址缺少中文");
    if (!/English[：:]\s*\S/i.test(addr)) issues.push("详细地址缺少 English");
  }

  return { nameZh: nameZhM?.[1]?.trim() || "", issues, ok: issues.length === 0 };
}

function validateCityDir(cityPath, cityLabel) {
  const results = [];
  if (!existsSync(cityPath)) return results;

  const entries = readdirSync(cityPath).filter((n) => !n.startsWith("."));
  const mdFiles = entries.filter((n) => n.endsWith(".md") && statSync(join(cityPath, n)).isFile());

  for (const md of mdFiles) {
    const stem = basename(md, ".md");
    const jpg = `${stem}.jpg`;
    const issues = [];
    const mdPath = join(cityPath, md);

    if (!entries.includes(jpg)) issues.push(`缺配对封面 ${jpg}`);
    if (entries.includes(jpg) && !statSync(join(cityPath, jpg)).isFile()) issues.push(`${jpg} 不是文件`);

    const parsed = parseMd(readFileSync(mdPath, "utf8"));
    issues.push(...parsed.issues);

    if (parsed.nameZh && parsed.nameZh !== stem) {
      issues.push(`文件名「${stem}」与 md 中文名「${parsed.nameZh}」不一致`);
    }

    results.push({
      city: cityLabel,
      attraction: stem,
      path: mdPath,
      ok: issues.length === 0,
      issues,
    });
  }

  return results;
}

function loadKnownCityDirs() {
  const config = JSON.parse(readFileSync(CONFIG_PATH, "utf8"));
  return Object.entries(config.cities || {}).map(([key, c]) => ({
    key,
    label: c.city_id || key,
    path: c.folder,
  }));
}

function buildMarkdown(report) {
  const lines = [
    "# 主景点格式校验报告",
    "",
    `生成时间：${report.generatedAt}`,
    "",
    `- 扫描：${report.scanned} 个主景点`,
    `- 合规：${report.passed}`,
    `- 不合规：${report.failed}`,
    "",
  ];

  if (report.failed) {
    lines.push("## 不合规", "");
    for (const r of report.results.filter((x) => !x.ok)) {
      lines.push(`### ${r.city} / ${r.attraction}`, "");
      lines.push(`- 路径：\`${r.path}\``);
      for (const iss of r.issues) lines.push(`- ${iss}`);
      lines.push("");
    }
  }

  if (report.passed) {
    lines.push("## 合规", "");
    for (const r of report.results.filter((x) => x.ok)) {
      lines.push(`- ${r.city} / ${r.attraction}`);
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

  let dirs = [];
  if (scanKnown) {
    dirs = loadKnownCityDirs();
  } else if (targets.length) {
    dirs = targets.map((t) => {
      const p = t.startsWith("/") ? t : join(process.cwd(), t);
      return { label: basename(p), path: p };
    });
  } else {
    console.error("用法: node scripts/validate-attraction-content-format.mjs <城市目录> | --scan-known");
    process.exit(1);
  }

  const results = [];
  for (const d of dirs) {
    results.push(...validateCityDir(d.path, d.label || d.key));
  }

  const passed = results.filter((r) => r.ok).length;
  const report = {
    generatedAt: new Date().toISOString(),
    spec: "docs/attraction-content-spec.md",
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
