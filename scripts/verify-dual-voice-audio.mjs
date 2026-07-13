#!/usr/bin/env node
import { readFileSync, writeFileSync } from "fs";
import { join } from "path";

const ROOT = "/Users/vesperal/Desktop/YOLO";
const OUT = join(ROOT, "scripts/generated/dual_voice_audio_verify.json");

const SAMPLES = [
  "beijing_forbidden_city_sa_01",
  "the_bund_shanghai_sa_01",
  "suzhou_creek_twelve_nations_colors_sa_12",
  "https_yoloadmin_vue_cstudiomunger_workers_dev_sa_01",
  "chongqing_dazu_rock_carvings_sa_01",
];

function readXc(k) {
  const t = readFileSync(join(ROOT, "Secrets.xcconfig"), "utf8");
  const l = t.split(/\r?\n/).find((x) => x.trim().startsWith(`${k} =`));
  return l.split("=").slice(1).join("=").replace(/\$\(\)/g, "").trim();
}

function loadKey() {
  if (process.env.SUPABASE_SERVICE_ROLE_KEY) return process.env.SUPABASE_SERVICE_ROLE_KEY;
  try {
    const m = readFileSync(join(ROOT, ".env.local.tmp"), "utf8").match(
      /SUPABASE_SERVICE_ROLE_KEY\s*=\s*"?([^"\n]+)"?/
    );
    if (m?.[1]) return m[1].trim();
  } catch {
    /* optional */
  }
  return readXc("SUPABASE_ANON_KEY");
}

const url = readXc("SUPABASE_URL").replace("https:/", "https://");
const key = loadKey();

async function rest(path) {
  const res = await fetch(`${url}${path}`, {
    headers: { apikey: key, Authorization: `Bearer ${key}` },
  });
  if (!res.ok) throw new Error(`${path} -> ${res.status} ${await res.text()}`);
  return res.json();
}

const checks = [];
for (const id of SAMPLES) {
  const [sa] = await rest(`/rest/v1/sub_areas?id=eq.${id}&select=id,name_zh,audio_url`);
  const vars = await rest(
    `/rest/v1/audio_voice_variants?owner_type=eq.sub_area&owner_id=eq.${id}&select=voice_label,audio_url,is_default,sort_order&order=sort_order`
  );
  const labels = vars.map((v) => v.voice_label);
  checks.push({
    id,
    nameZh: sa?.name_zh,
    hasAudioUrl: Boolean(sa?.audio_url),
    audioUsesVoicesPath: (sa?.audio_url || "").includes("/voices/sub_area/"),
    variantLabels: labels,
    hasCleo: labels.includes("Cleo"),
    hasMilo: labels.includes("Milo"),
    cleoIsDefault: vars.find((v) => v.voice_label === "Cleo")?.is_default === true,
    allVariantsUseVoicesPath: vars.every((v) => (v.audio_url || "").includes("/voices/sub_area/")),
  });
}

const out = { verifiedAt: new Date().toISOString(), checks };
writeFileSync(OUT, JSON.stringify(out, null, 2));
console.log(JSON.stringify(out, null, 2));
