// Build-time data pipeline for the visa checker.
//
// Pulls the verified visa-engine tables from Supabase (anon/publishable key, RLS
// allows reading active rows) and writes two JSON snapshots into src/data:
//   - visa-data.json   the raw VisaDataSet the ported TS engine evaluates
//   - countries.json   the full ISO-3166 list (English names + flag emoji + slug)
//
// Runs before every `astro build` / `astro dev` (see package.json), so each deploy
// ships a fresh snapshot. No secrets here: the publishable key is read-only.

import { readFile, writeFile, mkdir } from "node:fs/promises";
import { fileURLToPath } from "node:url";
import { dirname, resolve } from "node:path";

const __dirname = dirname(fileURLToPath(import.meta.url));
const ROOT = resolve(__dirname, "..");
const DATA_DIR = resolve(ROOT, "src/data");

const SUPABASE_URL =
  process.env.SUPABASE_URL || "https://edwvrriuwzaaqznklrgi.supabase.co";
const SUPABASE_ANON_KEY =
  process.env.SUPABASE_ANON_KEY ||
  "sb_publishable_b4CZMaImh7KsCVx_uufaGw_h3-HEZPZ";

const TABLES = {
  policies: "visa_policies_v2",
  grants: "visa_policy_grants_v2",
  cities: "visa_cities",
  matrix: "visa_city_policy_matrix",
  permit_zones: "visa_permit_zones",
  ports: "visa_ports",
  config: "visa_config",
};

async function fetchTable(table) {
  const url = `${SUPABASE_URL}/rest/v1/${table}?select=*&is_active=eq.true`;
  const res = await fetch(url, {
    headers: {
      apikey: SUPABASE_ANON_KEY,
      Authorization: `Bearer ${SUPABASE_ANON_KEY}`,
    },
  });
  if (!res.ok) {
    throw new Error(`Fetch ${table} failed: ${res.status} ${await res.text()}`);
  }
  return res.json();
}

// Reuse the app's canonical ISO-3166 alpha-2 list (single source of truth) so the
// picker covers every territory, not just the ~90 visa-relevant nationalities.
async function isoCodesFromApp() {
  const swift = resolve(ROOT, "../YOLO/Models/ISO3166Countries.swift");
  try {
    const text = await readFile(swift, "utf8");
    const codes = [...text.matchAll(/\("([A-Z]{2})",/g)].map((m) => m[1]);
    return [...new Set(codes)];
  } catch {
    return [];
  }
}

function flagEmoji(code) {
  const A = 0x1f1e6;
  const cps = [...code.toUpperCase()]
    .filter((c) => c >= "A" && c <= "Z")
    .map((c) => A + (c.charCodeAt(0) - 65));
  return cps.length === 2 ? String.fromCodePoint(...cps) : "🏳️";
}

function slugify(s) {
  return s
    .normalize("NFKD") // strip diacritics: Türkiye → Turkiye, Côte → Cote
    .replace(/[\u0300-\u036f]/g, "")
    .toLowerCase()
    .replace(/[''`.()]/g, "")
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-+|-+$/g, "");
}

async function main() {
  await mkdir(DATA_DIR, { recursive: true });

  const entries = await Promise.all(
    Object.entries(TABLES).map(async ([key, table]) => [
      key,
      await fetchTable(table),
    ])
  );
  const data = Object.fromEntries(entries);

  await writeFile(
    resolve(DATA_DIR, "visa-data.json"),
    JSON.stringify(data) + "\n"
  );

  // Country directory. English names via Intl.DisplayNames; skip codes it can't name.
  const region = new Intl.DisplayNames(["en"], { type: "region" });
  const codes = await isoCodesFromApp();
  const grantCountries = new Set(
    data.grants.map((g) => String(g.country_code).toUpperCase())
  );
  const seenSlug = new Set();
  const countries = [];
  for (const code of codes) {
    if (code === "CN") continue; // destination, not a passport option here
    let name;
    try {
      name = region.of(code);
    } catch {
      name = undefined;
    }
    if (!name || name === code) continue;
    let slug = slugify(name);
    while (seenSlug.has(slug)) slug = `${slug}-${code.toLowerCase()}`;
    seenSlug.add(slug);
    countries.push({
      iso2: code,
      name,
      flag: flagEmoji(code),
      slug,
      hasGrant: grantCountries.has(code),
    });
  }
  countries.sort((a, b) => a.name.localeCompare(b.name));

  await writeFile(
    resolve(DATA_DIR, "countries.json"),
    JSON.stringify(countries) + "\n"
  );

  console.log(
    `[fetch:visa] policies=${data.policies.length} grants=${data.grants.length} ` +
      `cities=${data.cities.length} matrix=${data.matrix.length} ports=${data.ports.length} ` +
      `| countries=${countries.length} (withGrant=${countries.filter((c) => c.hasGrant).length})`
  );
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
