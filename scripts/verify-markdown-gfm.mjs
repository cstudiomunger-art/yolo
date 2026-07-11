#!/usr/bin/env node
/**
 * Smoke test: GFM tables + images render on admin-vue/site marked stack.
 * Usage: node scripts/verify-markdown-gfm.mjs
 * (uses site/node_modules for marked + sanitize-html)
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

marked.setOptions(MARKED_OPTIONS);

const SAMPLE = [
  "## Emergency numbers",
  "",
  "| Service | Number |",
  "| --- | --- |",
  "| Police | 110 |",
  "| Ambulance | 120 |",
  "",
  "![](cover-images/emergency/police.jpg)",
  "",
  "Call **110** for police.",
].join("\n");

const resolved = SAMPLE.replace(
  /!\[([^\]]*)\]\(([^)]+)\)/g,
  (_m, alt, src) => `![${alt}](https://example.supabase.co/storage/v1/object/public/${src})`
);

const html = marked.parse(resolved);
const sanitized = sanitizeHtml(html, {
  allowedTags: [
    "p", "h2", "strong", "table", "thead", "tbody", "tr", "th", "td", "img",
  ],
  allowedAttributes: {
    img: ["src", "alt"],
    th: ["align"],
    td: ["align"],
  },
});

const checks = [
  ["GFM table <table>", /<table>/.test(sanitized)],
  ["table header <th>", /<th>/.test(sanitized)],
  ["table cell <td>", /<td>/.test(sanitized)],
  ["image <img>", /<img[^>]+src=/.test(sanitized)],
  ["heading <h2>", /<h2>/.test(sanitized)],
  ["bold <strong>", /<strong>/.test(sanitized)],
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
  console.error("\nverify-markdown-gfm: FAILED\n", sanitized);
  process.exit(1);
}

console.log("\nverify-markdown-gfm: all checks passed (marked gfm + sanitize-html)");
