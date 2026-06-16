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

if (!supabaseAnonKey) {
  console.error("Missing SUPABASE_ANON_KEY. Set Cloudflare env var or fill web/support/config.example.js.");
  process.exit(1);
}

const config = `window.YOLO_SUPPORT_CONFIG = ${JSON.stringify(
  { supabaseUrl, supabaseAnonKey },
  null,
  2
)};\n`;

writeFileSync(new URL("../config.js", import.meta.url), config);
console.log("Wrote web/support/config.js");
