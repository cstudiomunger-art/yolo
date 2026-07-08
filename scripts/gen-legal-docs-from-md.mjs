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
    path: "/Users/vesperal/Desktop/01-Privacy-Policy.md",
    column: "privacy_policy_body",
    id: "privacy",
  },
  {
    path: "/Users/vesperal/Desktop/02-Terms-of-Service.md",
    column: "terms_of_service_body",
    id: "terms",
  },
  {
    path: "/Users/vesperal/Desktop/03-GDPR-Compliance-Framework.md",
    column: "gdpr_compliance_body",
    id: "gdpr",
  },
  {
    path: "/Users/vesperal/Desktop/04-AI-Content-Disclosure.md",
    column: "ai_content_disclosure_body",
    id: "ai_disclosure",
  },
];

function sqlStr(value) {
  if (value == null) return "NULL";
  return `'${String(value).replace(/'/g, "''")}'`;
}

function escapeHtml(s) {
  return String(s || "")
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;");
}

function inlineMd(text) {
  const tokens = [];
  const token = (html) => {
    const id = `\x00T${tokens.length}\x00`;
    tokens.push(html);
    return id;
  };

  let s = String(text || "");
  s = s.replace(/\[([^\]]+)\]\([^)]+\)/g, (_, label) => token(`<strong>${escapeHtml(label)}</strong>`));
  s = s.replace(/\*\*(.+?)\*\*/g, (_, t) => token(`<strong>${escapeHtml(t)}</strong>`));
  s = s.replace(/`([^`]+)`/g, (_, t) => token(`<code>${escapeHtml(t)}</code>`));
  s = escapeHtml(s);
  s = s.replace(/(?<!\*)\*([^*]+)\*(?!\*)/g, (_, t) => token(`<em>${escapeHtml(t)}</em>`));
  for (let i = 0; i < tokens.length; i += 1) {
    s = s.replace(`\x00T${i}\x00`, tokens[i]);
  }
  return s;
}

function isTableRow(line) {
  const t = line.trim();
  return t.startsWith("|") && t.endsWith("|") && t.includes("|");
}

function isTableSeparator(line) {
  const t = line.trim();
  return /^\|[\s:|-]+\|$/.test(t);
}

function parseTableRow(line) {
  return line
    .trim()
    .replace(/^\|/, "")
    .replace(/\|$/, "")
    .split("|")
    .map((cell) => cell.trim());
}

function renderTable(rows) {
  if (!rows.length) return "";
  const [header, ...body] = rows;
  const thead = `<thead><tr>${header.map((c) => `<th>${inlineMd(c)}</th>`).join("")}</tr></thead>`;
  const tbody = body.length
    ? `<tbody>${body.map((row) => `<tr>${row.map((c) => `<td>${inlineMd(c)}</td>`).join("")}</tr>`).join("")}</tbody>`
    : "";
  return `<table>${thead}${tbody}</table>`;
}

function mdLegalToHtml(raw) {
  const lines = String(raw || "").split(/\r?\n/);
  const out = [];
  let paraBuf = [];
  let listBuf = [];
  let listOrdered = false;
  let tableBuf = [];
  let skipUntilHr = true;

  function flushPara() {
    if (!paraBuf.length) return;
    const text = paraBuf.join(" ").trim();
    paraBuf = [];
    if (text) out.push(`<p>${inlineMd(text)}</p>`);
  }

  function flushList() {
    if (!listBuf.length) return;
    const tag = listOrdered ? "ol" : "ul";
    out.push(`<${tag}>${listBuf.map((it) => `<li>${inlineMd(it)}</li>`).join("")}</${tag}>`);
    listBuf = [];
    listOrdered = false;
  }

  function flushTable() {
    if (!tableBuf.length) return;
    out.push(renderTable(tableBuf));
    tableBuf = [];
  }

  for (const rawLine of lines) {
    const line = rawLine.trimEnd();
    const trimmed = line.trim();

    if (!trimmed) {
      flushPara();
      flushList();
      flushTable();
      continue;
    }

    if (/^---+$/.test(trimmed)) {
      flushPara();
      flushList();
      flushTable();
      skipUntilHr = false;
      continue;
    }

    if (skipUntilHr && /^(\*\*Last Updated|\*\*Effective Date|> \*\*|Document Version|Document Type|Generated:|Version:)/i.test(trimmed)) {
      continue;
    }
    if (skipUntilHr && /^#\s+/.test(trimmed)) {
      skipUntilHr = false;
    }

    if (isTableRow(trimmed)) {
      flushPara();
      flushList();
      if (isTableSeparator(trimmed)) continue;
      tableBuf.push(parseTableRow(trimmed));
      continue;
    }
    flushTable();

    if (/^>\s?/.test(trimmed)) {
      flushPara();
      flushList();
      out.push(`<blockquote><p>${inlineMd(trimmed.replace(/^>\s?/, ""))}</p></blockquote>`);
      continue;
    }

    if (/^#\s+/.test(trimmed) && !/^##/.test(trimmed)) {
      flushPara();
      flushList();
      out.push(`<h1>${inlineMd(trimmed.replace(/^#\s+/, ""))}</h1>`);
      continue;
    }
    if (/^##\s+/.test(trimmed)) {
      flushPara();
      flushList();
      out.push(`<h2>${inlineMd(trimmed.replace(/^##\s+/, ""))}</h2>`);
      continue;
    }
    if (/^###\s+/.test(trimmed)) {
      flushPara();
      flushList();
      out.push(`<h3>${inlineMd(trimmed.replace(/^###\s+/, ""))}</h3>`);
      continue;
    }
    if (/^####\s+/.test(trimmed)) {
      flushPara();
      flushList();
      out.push(`<h4>${inlineMd(trimmed.replace(/^####\s+/, ""))}</h4>`);
      continue;
    }

    const olMatch = trimmed.match(/^(\d+)\.\s+(.+)$/);
    if (olMatch) {
      flushPara();
      if (!listOrdered && listBuf.length) flushList();
      listOrdered = true;
      listBuf.push(olMatch[2]);
      continue;
    }

    if (/^\s*-\s+/.test(line)) {
      flushPara();
      if (listOrdered && listBuf.length) flushList();
      listBuf.push(line.replace(/^\s*-\s+/, "").trim());
      continue;
    }

    flushList();
    paraBuf.push(trimmed);
  }

  flushPara();
  flushList();
  flushTable();
  return out.join("");
}

function sha256(text) {
  return createHash("sha256").update(text, "utf8").digest("hex").slice(0, 16);
}

function main() {
  mkdirSync(OUT_DIR, { recursive: true });

  const docs = [];
  const setClauses = [];

  for (const source of SOURCES) {
    const markdown = readFileSync(source.path, "utf8");
    const html = mdLegalToHtml(markdown);
    if (!html.trim()) throw new Error(`Empty HTML for ${source.path}`);

    docs.push({
      id: source.id,
      column: source.column,
      sourcePath: source.path,
      markdownChars: markdown.length,
      htmlChars: html.length,
      htmlSha256Prefix: sha256(html),
      htmlPreview: html.slice(0, 200),
    });
    setClauses.push(`  ${source.column} = ${sqlStr(html)}`);
  }

  const sql = `-- Generated legal documents for app_settings (id=global)
-- Sources: Privacy Policy, Terms of Service, GDPR Framework, AI Content Disclosure
-- Generated: ${new Date().toISOString()}

UPDATE app_settings SET
${setClauses.join(",\n")},
  updated_at = NOW()
WHERE id = 'global';
`;

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
          totalHtmlChars: docs.reduce((n, d) => n + d.htmlChars, 0),
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
    console.log(`  ${doc.id}: ${doc.htmlChars} chars (${doc.column})`);
  }
}

main();
