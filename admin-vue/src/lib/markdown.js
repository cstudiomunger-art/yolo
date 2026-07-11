import { marked } from "marked";

export const MARKED_OPTIONS = { gfm: true, breaks: false };

marked.setOptions(MARKED_OPTIONS);

export function renderMarkdownHtml(md) {
  const text = String(md ?? "").trim();
  if (!text) return "";
  return marked.parse(text);
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
