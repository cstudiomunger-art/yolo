// Build-time data pipeline for the city guides (cities → attractions → sub-areas).
//
// Pulls published CMS content from Supabase and writes src/data/guides.json. Audio is
// intentionally excluded from the web (it stays the app's paid moat): we drop sub-area
// audio_url / audio_guide_id and keep only a `has_audio` flag + attraction
// audio_guide_count so the page can tease "N audio guides in the app".
//
// Content is rendered as-is (whatever language the CMS holds). Cover images are already
// stored as full public URLs, so no resolution is needed.

import { writeFile, readFile, mkdir } from "node:fs/promises";
import { fileURLToPath } from "node:url";
import { dirname, resolve } from "node:path";

const __dirname = dirname(fileURLToPath(import.meta.url));
const DATA_DIR = resolve(__dirname, "..", "src/data");

const SUPABASE_URL = process.env.SUPABASE_URL || "https://edwvrriuwzaaqznklrgi.supabase.co";
const SUPABASE_ANON_KEY =
  process.env.SUPABASE_ANON_KEY || "sb_publishable_b4CZMaImh7KsCVx_uufaGw_h3-HEZPZ";

async function fetchTable(path) {
  const res = await fetch(`${SUPABASE_URL}/rest/v1/${path}`, {
    headers: { apikey: SUPABASE_ANON_KEY, Authorization: `Bearer ${SUPABASE_ANON_KEY}` },
  });
  if (!res.ok) throw new Error(`Fetch ${path} failed: ${res.status} ${await res.text()}`);
  return res.json();
}

async function main() {
  await mkdir(DATA_DIR, { recursive: true });

  const [cities, attractions, subAreasRaw] = await Promise.all([
    fetchTable("cities?select=*&is_published=eq.true&order=display_order"),
    fetchTable("attractions?select=*&is_published=eq.true&order=display_order"),
    fetchTable("sub_areas?select=*&is_active=eq.true&order=sort_order"),
  ]);

  // Strip every audio field before it leaves the build. The web never ships audio URLs.
  const subAreas = subAreasRaw.map(({ audio_url, audio_guide_id, ...rest }) => ({
    ...rest,
    has_audio: Boolean((audio_url && audio_url.trim()) || audio_guide_id),
  }));

  const data = { cities, attractions, sub_areas: subAreas };
  await writeFile(resolve(DATA_DIR, "guides.json"), JSON.stringify(data) + "\n");

  const withAudio = subAreas.filter((s) => s.has_audio).length;
  console.log(
    `[fetch:content] cities=${cities.length} attractions=${attractions.length} ` +
      `sub_areas=${subAreas.length} (with audio teaser=${withAudio})`
  );

  // Ticket attractions — CMS-managed (ticket_attractions table). Falls back to the
  // committed seed if the table isn't there yet (migration not applied) or is empty,
  // so the build never breaks during rollout.
  const ticketCols =
    "slug,name,name_zh,city,status,blurb,advance_days,release_time,release_note," +
    "closed,official_url,passport_required,rules,passport_note";
  let tickets = [];
  let ticketSource = "supabase";
  try {
    tickets = await fetchTable(`ticket_attractions?select=${ticketCols}&is_active=eq.true&order=display_order`);
  } catch {
    tickets = [];
  }
  if (!Array.isArray(tickets) || tickets.length === 0) {
    const seed = await readFile(resolve(DATA_DIR, "ticket-attractions.seed.json"), "utf8");
    tickets = JSON.parse(seed);
    ticketSource = "seed (table missing/empty)";
  }
  await writeFile(resolve(DATA_DIR, "ticket-attractions.json"), JSON.stringify(tickets) + "\n");
  console.log(`[fetch:content] ticket_attractions=${tickets.length} (source: ${ticketSource})`);
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
