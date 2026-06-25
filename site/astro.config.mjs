import { defineConfig } from "astro/config";
import sitemap from "@astrojs/sitemap";

// Acquisition-funnel marketing site for the YOLO HAPPY iOS app.
// Static output (SSG): every page is crawlable HTML; the visa checker hydrates
// client-side from a build-time Supabase snapshot. Update `site` to the final domain.
export default defineConfig({
  site: "https://yolohappy.app",
  integrations: [sitemap()],
  build: { inlineStylesheets: "auto" },
});
