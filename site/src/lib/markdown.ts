import { marked } from "marked";
import sanitizeHtml from "sanitize-html";
import { MARKED_OPTIONS } from "../../../scripts/lib/marked-config.mjs";
import { MARKDOWN_SANITIZE_OPTIONS } from "../../../scripts/lib/markdown-sanitize.mjs";
import { plainTextFromMarkdown as stripMarkdown } from "../../../scripts/lib/markdown-plain.mjs";
import { resolveCoverImageUrl } from "./guides";

marked.setOptions(MARKED_OPTIONS);

/** Rewrite relative `![](path)` image URLs; normalize lone `#` → `##` per CMS spec. */
export function markdownForDisplay(md: string | null | undefined): string {
  const raw = String(md ?? "").trim();
  if (!raw) return "";
  const normalized = raw.replace(/^# (?!#)/gm, "## ");
  return normalized.replace(/!\[([^\]]*)\]\(([^)]+)\)/g, (_match, alt: string, src: string) => {
    const trimmed = src.trim();
    if (/^https?:\/\//i.test(trimmed)) return `![${alt}](${trimmed})`;
    const resolved = resolveCoverImageUrl(trimmed);
    return resolved ? `![${alt}](${resolved})` : `![${alt}](${trimmed})`;
  });
}

/** marked → sanitize-html (build-time only). */
export function renderMarkdown(md: string | null | undefined): string {
  const prepared = markdownForDisplay(md);
  if (!prepared) return "";
  const html = marked.parse(prepared) as string;
  return sanitizeHtml(html, MARKDOWN_SANITIZE_OPTIONS as sanitizeHtml.IOptions);
}

/** Plain text for SEO summaries and list previews. */
export function plainTextFromMarkdown(md: string | null | undefined): string {
  return stripMarkdown(md);
}
