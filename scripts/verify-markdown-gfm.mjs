#!/usr/bin/env node
/**
 * Smoke test: CMS Markdown spec syntax survives marked → sanitize-html.
 * Usage: node scripts/verify-markdown-gfm.mjs
 */
import { createRequire } from "module";
import { fileURLToPath } from "url";
import { dirname, join } from "path";

const here = dirname(fileURLToPath(import.meta.url));
const siteDir = join(here, "..", "site");
const require = createRequire(join(siteDir, "package.json"));
const { marked } = require("marked");
const sanitizeHtml = require("sanitize-html");

const { MARKED_OPTIONS } = await import("./lib/marked-config.mjs");
const { MARKDOWN_SANITIZE_OPTIONS } = await import("./lib/markdown-sanitize.mjs");

marked.setOptions(MARKED_OPTIONS);

const SAMPLE = [
  "## Section title",
  "",
  "### Subsection",
  "",
  "Paragraph with **bold**, *italic*, `inline code`, and ~~strikethrough~~.",
  "",
  "- Bullet one",
  "- Bullet two",
  "",
  "1. Step one",
  "2. Step two",
  "",
  "> Visitor note in a blockquote.",
  "",
  "```",
  "fenced code block",
  "```",
  "",
  "[Booking link](https://example.com/book)",
  "",
  "| Service | Number |",
  "| --- | --- |",
  "| Police | 110 |",
  "| Ambulance | 120 |",
  "",
  "![](cover-images/emergency/police.jpg)",
  "",
  "---",
  "",
  "Final paragraph after rule.",
].join("\n");

function render(md) {
  const normalized = md.replace(/^# (?!#)/gm, "## ");
  const resolved = normalized.replace(
    /!\[([^\]]*)\]\(([^)]+)\)/g,
    (_m, alt, src) => `![${alt}](https://example.supabase.co/storage/v1/object/public/${src})`
  );
  const html = marked.parse(resolved);
  return sanitizeHtml(html, MARKDOWN_SANITIZE_OPTIONS);
}

const out = render(SAMPLE);

const checks = [
  ["h1 normalized to h2", (() => {
    const h1 = render("# Lone H1");
    return /<h2[^>]*>Lone H1<\/h2>/.test(h1) && !/<h1/.test(h1);
  })()],
  ["h2 heading", /<h2[^>]*>Section title<\/h2>/.test(out)],
  ["h3 heading", /<h3[^>]*>Subsection<\/h3>/.test(out)],
  ["bold", /<strong>bold<\/strong>/.test(out)],
  ["italic", /<em>italic<\/em>/.test(out)],
  ["inline code", /<code>inline code<\/code>/.test(out)],
  ["strikethrough", /<del>strikethrough<\/del>/.test(out)],
  ["fenced code block", /<pre><code[^>]*>fenced code block/.test(out)],
  ["unordered list", /<ul>[\s\S]*<li>Bullet one<\/li>/.test(out)],
  ["ordered list", /<ol>[\s\S]*<li>Step one<\/li>/.test(out)],
  ["blockquote", /<blockquote>[\s\S]*Visitor note/.test(out)],
  ["link + rel", /<a[^>]+href="https:\/\/example.com\/book"[^>]+rel="noopener nofollow ugc"/.test(out)],
  ["GFM table", /<table>[\s\S]*<th>Service<\/th>[\s\S]*<td>110<\/td>/.test(out)],
  ["image", /<img[^>]+src="https:\/\/example.supabase.co[^"]+police\.jpg"/.test(out)],
  ["horizontal rule", /<hr\s*\/?>/.test(out)],
  ["paragraph preserved", /<p>Final paragraph/.test(out)],
];

let failed = false;
for (const [name, ok] of checks) {
  if (!ok) {
    console.error(`FAIL: ${name}`);
    failed = true;
  } else {
    console.log(`OK: ${name}`);
  }
}

if (failed) {
  console.error("\nverify-markdown-gfm: FAILED\n", out);
  process.exit(1);
}

console.log("\nverify-markdown-gfm: all CMS Markdown spec checks passed");
