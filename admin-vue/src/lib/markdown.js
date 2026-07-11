import { marked } from "marked";
import { resolveCoverImageUrl } from "@/lib/storage";

/** GFM: tables, strikethrough, task lists, autolinks. Keep in sync with scripts/lib/marked-config.mjs */
export const MARKED_OPTIONS = { gfm: true, breaks: false };

marked.setOptions(MARKED_OPTIONS);

/** Rewrite relative `![](path)` before preview/render (matches site + App). */
export function markdownForDisplay(md) {
  const raw = String(md ?? "").trim();
  if (!raw) return "";
  return raw.replace(/!\[([^\]]*)\]\(([^)]+)\)/g, (_match, alt, src) => {
    const trimmed = String(src ?? "").trim();
    if (/^https?:\/\//i.test(trimmed)) return `![${alt}](${trimmed})`;
    const resolved = resolveCoverImageUrl(trimmed);
    return resolved ? `![${alt}](${resolved})` : `![${alt}](${trimmed})`;
  });
}

export function renderMarkdownHtml(md) {
  const prepared = markdownForDisplay(md);
  if (!prepared) return "";
  return marked.parse(prepared);
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
