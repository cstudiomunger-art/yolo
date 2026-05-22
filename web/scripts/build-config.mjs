import { writeFileSync } from "node:fs";

const supabaseUrl =
  process.env.SUPABASE_URL || "https://edwvrriuwzaaqznklrgi.supabase.co";
const supabaseAnonKey = process.env.SUPABASE_ANON_KEY || "";
const appStoreUrl =
  process.env.APP_STORE_URL || "https://apps.apple.com/app/id0000000000";
const shareWebBaseUrl =
  process.env.SHARE_WEB_BASE_URL || "https://yolo.cstudiomunger.workers.dev";

if (!supabaseAnonKey) {
  console.error(
    "Missing SUPABASE_ANON_KEY. Set it in Cloudflare/Vercel → Environment Variables."
  );
  process.exit(1);
}

const config = `window.YOLO_WEB_CONFIG = ${JSON.stringify(
  { supabaseUrl, supabaseAnonKey, appStoreUrl, shareWebBaseUrl },
  null,
  2
)};\n`;

writeFileSync(new URL("../config.js", import.meta.url), config);
console.log("Wrote web/config.js");
