import { marked } from "marked";
import sanitizeHtml from "sanitize-html";
import { resolveCoverImageUrl } from "@/lib/storage";
import { MARKED_OPTIONS as SHARED_MARKED_OPTIONS } from "../../../scripts/lib/marked-config.mjs";
import { MARKDOWN_SANITIZE_OPTIONS } from "../../../scripts/lib/markdown-sanitize.mjs";

/** GFM: tables, strikethrough, autolinks. Keep in sync with scripts/lib/marked-config.mjs */
export const MARKED_OPTIONS = SHARED_MARKED_OPTIONS;

marked.setOptions(MARKED_OPTIONS);

/** Rewrite relative `![](path)` before preview/render; normalize lone `#` → `##` per CMS spec. */
export function markdownForDisplay(md) {
  const raw = String(md ?? "").trim();
  if (!raw) return "";
  const normalized = raw.replace(/^# (?!#)/gm, "## ");
  return normalized.replace(/!\[([^\]]*)\]\(([^)]+)\)/g, (_match, alt, src) => {
    const trimmed = String(src ?? "").trim();
    if (/^https?:\/\//i.test(trimmed)) return `![${alt}](${trimmed})`;
    const resolved = resolveCoverImageUrl(trimmed);
    return resolved ? `![${alt}](${resolved})` : `![${alt}](${trimmed})`;
  });
}

export function renderMarkdownHtml(md) {
  const prepared = markdownForDisplay(md);
  if (!prepared) return "";
  const html = marked.parse(prepared);
  return sanitizeHtml(html, MARKDOWN_SANITIZE_OPTIONS);
}

/** @param {string} raw */
export function plainTextFromMarkdown(raw) {
  let s = String(raw ?? "").trim();
  if (!s) return "";
  s = s.replace(/!\[([^\]]*)\]\([^)]+\)/g, "$1");
  s = s.replace(/\[([^\]]+)\]\([^)]+\)/g, "$1");
  s = s.replace(/^#{1,6}\s+/gm, "");
  s = s.replace(/^>\s?/gm, "");
  s = s.replace(/^[\s]*[-*+]\s+/gm, "");
  s = s.replace(/^[\s]*\d+\.\s+/gm, "");
  s = s.replace(/\*\*([^*]+)\*\*/g, "$1");
  s = s.replace(/\*([^*]+)\*/g, "$1");
  s = s.replace(/__([^_]+)__/g, "$1");
  s = s.replace(/_([^_]+)_/g, "$1");
  s = s.replace(/`([^`]+)`/g, "$1");
  s = s.replace(/^\|.*\|$/gm, (line) =>
    line
      .replace(/^\|/, "")
      .replace(/\|$/, "")
      .split("|")
      .map((c) => c.trim())
      .filter(Boolean)
      .join(" ")
  );
  s = s.replace(/^\|[-:\s|]+\|$/gm, "");
  while (s.includes("\n\n\n")) s = s.replace("\n\n\n", "\n\n");
  return s.trim();
}

export function containsHtmlTags(text) {
  return /<[a-z][\s\S]*?>/i.test(String(text ?? ""));
}
