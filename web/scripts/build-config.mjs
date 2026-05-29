import { readFileSync, writeFileSync } from "node:fs";

function readExampleField(name) {
  const raw = readFileSync(new URL("../config.example.js", import.meta.url), "utf8");
  const match = raw.match(new RegExp(`${name}:\\s*"([^"]*)"`));
  return match ? match[1] : "";
}

const supabaseUrl =
  process.env.SUPABASE_URL ||
  readExampleField("supabaseUrl") ||
  "https://edwvrriuwzaaqznklrgi.supabase.co";
const supabaseAnonKey =
  process.env.SUPABASE_ANON_KEY || readExampleField("supabaseAnonKey") || "";
const appStoreUrl =
  process.env.APP_STORE_URL ||
  readExampleField("appStoreUrl") ||
  "https://apps.apple.com/app/id0000000000";
const shareWebBaseUrl =
  process.env.SHARE_WEB_BASE_URL ||
  readExampleField("shareWebBaseUrl") ||
  "https://yolo.cstudiomunger.workers.dev";

if (!supabaseAnonKey) {
  console.error(
    "Missing SUPABASE_ANON_KEY. Set Cloudflare env var or fill web/config.example.js."
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
