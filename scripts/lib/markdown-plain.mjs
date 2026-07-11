/**
 * Strip Markdown to plain text (list previews, SEO summaries, paywall snippets).
 * Shared by site, tests, and optional admin validation.
 */

export function plainTextFromMarkdown(raw) {
  let s = String(raw ?? "").trim();
  if (!s) return "";

  // Images: ![alt](url) -> alt or empty
  s = s.replace(/!\[([^\]]*)\]\([^)]+\)/g, "$1");
  // Links: [text](url) -> text
  s = s.replace(/\[([^\]]+)\]\([^)]+\)/g, "$1");
  // Headings
  s = s.replace(/^#{1,6}\s+/gm, "");
  // Blockquote
  s = s.replace(/^>\s?/gm, "");
  // List markers
  s = s.replace(/^[\s]*[-*+]\s+/gm, "");
  s = s.replace(/^[\s]*\d+\.\s+/gm, "");
  // Bold / italic
  s = s.replace(/\*\*([^*]+)\*\*/g, "$1");
  s = s.replace(/\*([^*]+)\*/g, "$1");
  s = s.replace(/__([^_]+)__/g, "$1");
  s = s.replace(/_([^_]+)_/g, "$1");
  // Inline code
  s = s.replace(/`([^`]+)`/g, "$1");
  // Table pipes
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

/** Detect likely HTML (for save guards / lint). */
export function containsHtmlTags(text) {
  return /<[a-z][\s\S]*?>/i.test(String(text ?? ""));
}
