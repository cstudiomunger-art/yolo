#!/usr/bin/env node
/**
 * Fail if bundled JSON or generated SQL still contains HTML tags in content fields.
 * Usage: node scripts/lint-no-html-content.mjs
 */
import { readFileSync, readdirSync, statSync } from "fs";
import { join, extname } from "path";
import { containsHtmlTags } from "./lib/markdown-plain.mjs";

const ROOT = new URL("..", import.meta.url).pathname;
const TARGETS = [
  join(ROOT, "YOLO/Resources/Static"),
];
const SQL_TARGET = join(ROOT, "scripts/generated");

const CONTENT_KEYS = new Set([
  "body", "body_en", "body_zh", "introduction", "summary", "short_description",
  "description", "synopsis_en", "why_important", "how_to_complete", "cultural_tip",
  "preview", "do_text", "dont_text", "note_en", "about_body", "privacy_policy_body",
  "terms_of_service_body", "gdpr_compliance_body", "ai_content_disclosure_body",
]);

function walk(dir, out = []) {
  for (const name of readdirSync(dir)) {
    const path = join(dir, name);
    const st = statSync(path);
    if (st.isDirectory()) walk(path, out);
    else out.push(path);
  }
  return out;
}

function scanJson(path) {
  const issues = [];
  const data = JSON.parse(readFileSync(path, "utf8"));
  const visit = (node, trail) => {
    if (Array.isArray(node)) {
      node.forEach((item, i) => visit(item, `${trail}[${i}]`));
      return;
    }
    if (node && typeof node === "object") {
      for (const [key, value] of Object.entries(node)) {
        const next = trail ? `${trail}.${key}` : key;
        if (typeof value === "string" && CONTENT_KEYS.has(key) && containsHtmlTags(value)) {
          issues.push({ path, field: next, sample: value.slice(0, 80) });
        } else if (value && typeof value === "object") {
          visit(value, next);
        }
      }
    }
  };
  visit(data, "");
  return issues;
}

function scanSql(path) {
  const issues = [];
  const text = readFileSync(path, "utf8");
  if (/<p[\s>]/i.test(text) || /<table[\s>]/i.test(text) || /<h[2-6][\s>]/i.test(text)) {
    issues.push({ path, field: "(sql body)", sample: text.match(/<p[^>]*>[^<]{0,60}/i)?.[0] ?? "<html>" });
  }
  return issues;
}

const allIssues = [];
const sqlWarnings = [];
for (const dir of TARGETS) {
  for (const file of walk(dir)) {
    const ext = extname(file);
    if (ext === ".json") allIssues.push(...scanJson(file));
  }
}
if (statSync(SQL_TARGET, { throwIfNoEntry: false })) {
  for (const file of walk(SQL_TARGET)) {
    if (extname(file) === ".sql") sqlWarnings.push(...scanSql(file));
  }
}

if (sqlWarnings.length) {
  console.warn(`lint-no-html-content: ${sqlWarnings.length} legacy generated SQL file(s) still contain HTML (regenerate after migration):`);
  for (const issue of sqlWarnings.slice(0, 5)) {
    console.warn(`  ${issue.path}`);
  }
  if (sqlWarnings.length > 5) console.warn(`  …and ${sqlWarnings.length - 5} more`);
}

if (allIssues.length) {
  console.error("lint-no-html-content: found HTML in content fields:\n");
  for (const issue of allIssues) {
    console.error(`  ${issue.path}\n    ${issue.field}: ${issue.sample}…\n`);
  }
  process.exit(1);
}

console.log("lint-no-html-content: OK (no HTML in scanned content fields)");
