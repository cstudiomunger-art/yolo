#!/usr/bin/env node
import { createHash } from "crypto";
import { mkdirSync, readFileSync, writeFileSync } from "fs";
import { join } from "path";

const ROOT = "/Users/vesperal/Desktop/YOLO";
const OUT_DIR = join(ROOT, "scripts/generated");
const OUT_SQL = join(OUT_DIR, "legal_docs_upsert.sql");
const OUT_REPORT = join(OUT_DIR, "legal_docs_report.json");

const SOURCES = [
  {
    path: "/Users/vesperal/Desktop/01-Privacy-Policy(1).md",
    column: "privacy_policy_body",
    id: "privacy",
  },
  {
    path: "/Users/vesperal/Desktop/02-Terms-of-Service(1).md",
    column: "terms_of_service_body",
    id: "terms",
  },
  {
    path: "/Users/vesperal/Desktop/03-GDPR-Compliance-Framework(1).md",
    column: "gdpr_compliance_body",
    id: "gdpr",
  },
  {
    path: "/Users/vesperal/Desktop/04-AI-Content-Disclosure(1).md",
    column: "ai_content_disclosure_body",
    id: "ai_disclosure",
  },
];

function dollarQuote(value, tag) {
  const marker = `$yolo_legal_${tag}$`;
  const text = String(value ?? "");
  if (text.includes(marker)) {
    throw new Error(`Dollar-quote tag collision for ${tag}`);
  }
  return `${marker}${text}${marker}`;
}

function sha256(text) {
  return createHash("sha256").update(text, "utf8").digest("hex").slice(0, 16);
}

export function loadLegalDocuments() {
  const docs = [];
  for (const source of SOURCES) {
    const markdown = readFileSync(source.path, "utf8").trim();
    if (!markdown) throw new Error(`Empty Markdown for ${source.path}`);
    docs.push({
      id: source.id,
      column: source.column,
      sourcePath: source.path,
      markdownChars: markdown.length,
      markdownSha256Prefix: sha256(markdown),
      markdownPreview: markdown.slice(0, 200),
      markdown,
    });
  }
  return docs;
}

function buildLegalDocsSql(docs) {
  const statements = docs.map((doc, index) => {
    const quoted = dollarQuote(doc.markdown, doc.column);
    return `-- ${index + 1}/${docs.length} ${doc.column} (${doc.markdownChars} chars)
UPDATE app_settings
SET ${doc.column} = ${quoted},
    updated_at = NOW()
WHERE id = 'global';`;
  });

  return `-- Generated legal documents for app_settings (id=global) — Markdown
-- Sources: Privacy Policy, Terms of Service, GDPR Framework, AI Content Disclosure
-- Generated: ${new Date().toISOString()}

${statements.join("\n\n")}
`;
}

function main() {
  mkdirSync(OUT_DIR, { recursive: true });

  const docs = loadLegalDocuments();
  const sql = buildLegalDocsSql(docs);

  writeFileSync(OUT_SQL, sql, "utf8");
  writeFileSync(
    OUT_REPORT,
    `${JSON.stringify(
      {
        generatedAt: new Date().toISOString(),
        sqlPath: OUT_SQL,
        docs,
        stats: {
          documents: docs.length,
          totalMarkdownChars: docs.reduce((n, d) => n + d.markdownChars, 0),
        },
      },
      null,
      2
    )}\n`,
    "utf8"
  );

  console.log("Generated legal docs SQL:", OUT_SQL);
  console.log("Report:", OUT_REPORT);
  for (const doc of docs) {
    console.log(`  ${doc.id}: ${doc.markdownChars} chars (${doc.column})`);
  }
}

import { fileURLToPath } from "url";

if (process.argv[1] && fileURLToPath(import.meta.url) === process.argv[1]) {
  main();
}
