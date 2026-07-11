/**
 * Shared marked options for admin-vue preview and site SSG.
 * gfm: true enables GFM tables + images via standard pipe/hyphen syntax.
 * Keep in sync — preview should match production rendering.
 */

export const MARKED_OPTIONS = {
  gfm: true,
  breaks: false,
};
