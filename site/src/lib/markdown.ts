import { marked } from "marked";
import sanitizeHtml from "sanitize-html";
import { MARKED_OPTIONS } from "../../../scripts/lib/marked-config.mjs";
import { plainTextFromMarkdown as stripMarkdown } from "../../../scripts/lib/markdown-plain.mjs";
import { resolveCoverImageUrl } from "./guides";

marked.setOptions(MARKED_OPTIONS);

const SANITIZE_OPTIONS: sanitizeHtml.IOptions = {
  allowedTags: [
    "p", "br", "hr", "strong", "b", "em", "i", "u", "s", "blockquote",
    "ul", "ol", "li", "h2", "h3", "h4", "h5", "span", "a", "img", "figure", "figcaption",
    "table", "thead", "tbody", "tr", "th", "td",
  ],
  allowedAttributes: {
    a: ["href", "title", "target", "rel"],
    img: ["src", "alt", "title", "loading"],
    span: [],
    th: ["align"],
    td: ["align"],
  },
  allowedSchemes: ["https", "http", "mailto"],
  transformTags: {
    a: sanitizeHtml.simpleTransform("a", { rel: "noopener nofollow ugc", target: "_blank" }),
  },
  disallowedTagsMode: "discard",
};

/** Rewrite relative `![](path)` image URLs before rendering. */
export function markdownForDisplay(md: string | null | undefined): string {
  const raw = String(md ?? "").trim();
  if (!raw) return "";
  return raw.replace(/!\[([^\]]*)\]\(([^)]+)\)/g, (_match, alt: string, src: string) => {
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
  return sanitizeHtml(html, SANITIZE_OPTIONS);
}

/** Plain text for SEO summaries and list previews. */
export function plainTextFromMarkdown(md: string | null | undefined): string {
  return stripMarkdown(md);
}
