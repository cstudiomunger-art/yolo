import { defineConfig } from "astro/config";
import sitemap from "@astrojs/sitemap";

// Acquisition-funnel marketing site for the YOLO HAPPY iOS app.
// Static output (SSG): every page is crawlable HTML; the visa checker hydrates
// client-side from a build-time Supabase snapshot.
//
// `site` (used for canonical URLs + sitemap) is read from the SITE_URL env / repo
// variable so a custom domain needs no code change; falls back to a placeholder.
const SITE_URL = process.env.SITE_URL || process.env.CF_PAGES_URL || "https://yolohappy.app";

export default defineConfig({
  site: SITE_URL,
  integrations: [sitemap()],
  build: { inlineStylesheets: "auto" },
  // Content-Security-Policy via <meta>: Astro auto-hashes its own inline scripts/styles
  // (the visa widget, ticket countdown, passport checker, scoped styles), so we get a
  // strict script-src without 'unsafe-inline'. frame-ancestors lives in _headers (X-Frame
  // -Options) since meta CSP ignores it.
  experimental: {
    csp: {
      directives: [
        "default-src 'self'",
        "base-uri 'self'",
        "object-src 'none'",
        "form-action 'self'",
        "img-src 'self' https://*.supabase.co data:",
        "font-src https://fonts.gstatic.com",
        "connect-src 'self'",
      ],
      scriptDirective: { resources: ["'self'"] },
      styleDirective: { resources: ["'self'", "https://fonts.googleapis.com"] },
    },
  },
});
