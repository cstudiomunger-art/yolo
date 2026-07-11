/**
 * sanitize-html allowlist for CMS Markdown HTML (site SSG + verify script).
 * Must preserve all tags that marked (gfm: true) emits for supported syntax.
 */

export const MARKDOWN_SANITIZE_OPTIONS = {
  allowedTags: [
    "p", "br", "hr", "strong", "b", "em", "i", "del", "s", "blockquote",
    "ul", "ol", "li", "h2", "h3", "h4", "h5", "h6", "span", "a", "img",
    "figure", "figcaption", "code", "pre",
    "table", "thead", "tbody", "tr", "th", "td",
  ],
  allowedAttributes: {
    a: ["href", "title", "target", "rel"],
    img: ["src", "alt", "title", "loading"],
    span: [],
    th: ["align"],
    td: ["align"],
    code: ["class"],
    pre: ["class"],
  },
  allowedSchemes: ["https", "http", "mailto"],
  transformTags: {
    a: (tagName, attribs) => ({
      tagName,
      attribs: {
        ...attribs,
        rel: "noopener nofollow ugc",
        target: "_blank",
      },
    }),
  },
  disallowedTagsMode: "discard",
};
