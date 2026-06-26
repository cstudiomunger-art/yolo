// Client island for /china-visa-free-checker.
//
// Two layers, both running the same engine the app uses (build-time Supabase snapshot):
//   1. Instant — pick your passport → nationality-level verdict (the loved onboarding moment)
//   2. Specific trip — cities/dates/transit → full four-dimension per-trip judgement
//
// All inputs come from our own dataset (countries/cities/ports), so template strings
// below interpolate trusted values only.

import rawData from "../data/visa-data.json";
import countriesRaw from "../data/countries.json";
import { recommend } from "../lib/visa-engine";
import { summarize, type NationalitySummary } from "../lib/visa-summary";
import type { VisaDataSet, VisaQuery } from "../lib/visa-types";

const data = rawData as unknown as VisaDataSet;
const countries = countriesRaw as Array<{ iso2: string; name: string; flag: string; slug: string; hasGrant: boolean }>;

// Escape every value sourced from the Supabase snapshot before it lands in innerHTML.
// Defense-in-depth: these label fields (policy/city/port names) are admin-editable, so
// treat them as untrusted at the HTML sink.
const esc = (s: unknown): string =>
  String(s ?? "").replace(/[&<>"']/g, (c) => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" })[c]!);

const policyName = (id: string) => esc(data.policies.find((p) => p.id === id)?.official_name_en ?? id);
const cityName = (code: string) => esc(data.cities.find((c) => c.city_id === code)?.name_en ?? code);
const portLabel = (code: string) => {
  const p = data.ports.find((x) => x.code === code);
  return p ? `${esc(p.code)} · ${esc(p.name_zh)}` : esc(code);
};
const countryName = (iso2: string) => esc(countries.find((c) => c.iso2 === iso2)?.name ?? iso2);

const $ = <T extends HTMLElement = HTMLElement>(id: string) => document.getElementById(id) as T | null;
const fmtDate = (d: Date | null) =>
  d ? d.toLocaleDateString("en-US", { year: "numeric", month: "short", day: "numeric" }) : "—";

function countryOptions(includeUndecided = false): string {
  const opts = countries.map((c) => `<option value="${esc(c.iso2)}">${esc(c.flag)} ${esc(c.name)}</option>`);
  if (includeUndecided) opts.unshift(`<option value="undecided">Undecided / round-trip</option>`);
  return opts.join("");
}

// ---- instant layer ----

function renderInstant(sum: NationalitySummary): string {
  const cn = countryName(sum.country_code);
  const flag = esc(countries.find((c) => c.iso2 === sum.country_code)?.flag ?? "");
  if (sum.verdict === "visa_free") {
    return `
      <div class="vc-verdict vc-green">
        <span class="badge badge-green">Visa-free</span>
        <h3>${flag} ${cn} passport holders can enter China visa-free</h3>
        <p class="vc-big">Up to <strong>${sum.stay_days ?? "—"} days</strong> · ${esc(sum.headline)}</p>
        ${conditionalNote(sum)}
        <p class="vc-fine">Nationwide, for ordinary passports. A specific trip can still have limits — check yours below.</p>
      </div>`;
  }
  if (sum.verdict === "conditional") {
    const names = sum.conditional.map((p) => esc(p.name_en)).join(", ");
    return `
      <div class="vc-verdict vc-amber">
        <span class="badge badge-amber">Conditional visa-free</span>
        <h3>${flag} ${cn} travelers may qualify without a visa — under conditions</h3>
        <p class="vc-big">Possible via <strong>${names}</strong></p>
        <p class="vc-fine">These depend on your route, ports, and dates. Run your specific trip below for a precise verdict.</p>
      </div>`;
  }
  return `
    <div class="vc-verdict vc-red">
      <span class="badge badge-red">Visa required</span>
      <h3>${flag} ${cn} passport holders currently need a visa for China</h3>
      <p class="vc-big">No nationwide or transit exemption applies to your passport today.</p>
      <p class="vc-fine">A 24-hour airport transit may still apply. Check a specific itinerary below.</p>
    </div>`;
}

function conditionalNote(sum: NationalitySummary): string {
  if (sum.conditional.length === 0) return "";
  const names = sum.conditional.map((p) => p.name_en).join(", ");
  return `<p class="vc-fine">Also eligible for: ${names}.</p>`;
}

// ---- trip layer ----

const tripCities: string[] = [];

function cityAddOptions(): string {
  const chosen = new Set(tripCities);
  return (
    `<option value="">+ Add a city…</option>` +
    [...data.cities]
      .filter((c) => !chosen.has(c.city_id))
      .sort((a, b) => a.name_en.localeCompare(b.name_en))
      .map((c) => `<option value="${c.city_id}">${c.name_en}</option>`)
      .join("")
  );
}

function renderCityChips() {
  const wrap = $("vc-city-chips");
  const add = $<HTMLSelectElement>("vc-city-add");
  if (!wrap || !add) return;
  wrap.innerHTML = tripCities
    .map((c) => `<span class="vc-chip">${cityName(c)}<button data-city="${c}" aria-label="remove">×</button></span>`)
    .join("");
  wrap.querySelectorAll("button[data-city]").forEach((b) =>
    b.addEventListener("click", () => {
      const i = tripCities.indexOf((b as HTMLElement).dataset.city!);
      if (i >= 0) tripCities.splice(i, 1);
      renderCityChips();
    })
  );
  add.innerHTML = cityAddOptions();
}

function portOptions(): string {
  return (
    `<option value="">Any / not sure</option>` +
    [...data.ports]
      .sort((a, b) => a.display_order - b.display_order)
      .map((p) => `<option value="${p.code}">${portLabel(p.code)}</option>`)
      .join("")
  );
}

function runTrip() {
  const nationality = $<HTMLSelectElement>("vc-nationality")!.value;
  const departure = $<HTMLSelectElement>("vc-departure")!.value || nationality;
  const onwardRaw = $<HTMLSelectElement>("vc-onward")!.value;
  const onward = onwardRaw === "undecided" || onwardRaw === "" ? null : onwardRaw;
  const entryStr = $<HTMLInputElement>("vc-entry-date")!.value;
  const exitStr = $<HTMLInputElement>("vc-exit-date")!.value;
  const out = $("vc-trip-result")!;

  if (!entryStr || !exitStr) {
    out.innerHTML = `<p class="vc-fine vc-warn">Pick an entry and a planned exit date.</p>`;
    return;
  }
  const entry = new Date(`${entryStr}T12:00:00`);
  const exit = new Date(`${exitStr}T12:00:00`);
  if (exit < entry) {
    out.innerHTML = `<p class="vc-fine vc-warn">Your exit date is before your entry date.</p>`;
    return;
  }
  if (tripCities.length === 0) {
    out.innerHTML = `<p class="vc-fine vc-warn">Add at least one city you plan to visit.</p>`;
    return;
  }

  const query: VisaQuery = {
    country_code: nationality,
    departure,
    onward,
    entry_port: $<HTMLSelectElement>("vc-entry-port")!.value || null,
    exit_port: $<HTMLSelectElement>("vc-exit-port")!.value || null,
    entry_at: entry,
    planned_exit_at: exit,
    cities: [...tripCities],
    ticketed: $<HTMLInputElement>("vc-ticket")!.checked,
    group: $<HTMLInputElement>("vc-group")!.checked,
    passport_valid_months: null,
    today: new Date(),
  };

  const rec = recommend(query, data);
  out.innerHTML = renderTrip(rec, query);
}

function renderTrip(rec: ReturnType<typeof recommend>, q: VisaQuery): string {
  const tone = rec.level === "green" ? "vc-green" : rec.level === "amber" ? "vc-amber" : "vc-red";
  const badge =
    rec.level === "green"
      ? `<span class="badge badge-green">Visa-free ✓</span>`
      : rec.level === "amber"
        ? `<span class="badge badge-amber">Almost — needs a tweak</span>`
        : `<span class="badge badge-red">Visa required</span>`;

  if (rec.chosen_policy_id === "GATE0") {
    return `<div class="vc-verdict vc-red"><span class="badge badge-red">Renew passport first</span>
      <h3>Your passport is below the minimum validity</h3>
      <p>China requires enough remaining passport validity before any entry, visa-free or not.</p></div>`;
  }

  let body = "";
  if (rec.level === "green") {
    body = `<p class="vc-big">Enter under <strong>${policyName(rec.chosen_policy_id)}</strong></p>
      <ul class="vc-facts">
        ${rec.max_stay_days ? `<li><span>Max stay</span><strong>${rec.max_stay_days} days</strong></li>` : ""}
        ${rec.latest_exit_date ? `<li><span>Latest legal exit</span><strong>${fmtDate(rec.latest_exit_date)}</strong></li>` : ""}
        ${rec.also_eligible.length ? `<li><span>Also eligible</span><strong>${rec.also_eligible.map(policyName).join(", ")}</strong></li>` : ""}
      </ul>`;
  } else if (rec.level === "amber") {
    const sheet = rec.sheets.find((s) => s.policy_id === rec.chosen_policy_id);
    const issues: string[] = [];
    if (sheet && !sheet.space_ok)
      issues.push(`These cities are outside <strong>${policyName(rec.chosen_policy_id)}</strong>: ${sheet.blockers.map(cityName).join(", ")}`);
    if (sheet && !sheet.time_ok)
      issues.push(`Your stay runs past the latest legal exit (<strong>${fmtDate(sheet.latest_exit_date)}</strong>)`);
    if (sheet && !sheet.port_ok) issues.push(`Your entry/exit port isn't on the approved list for this policy`);
    if (sheet && !sheet.condition_ok) issues.push(sheet.condition_reasons.join("; "));
    const modify = rec.plans.find((p) => p.kind === "modify");
    const swaps =
      modify && modify.kind === "modify"
        ? Object.entries(modify.swaps)
            .filter(([, to]) => to)
            .map(([from, to]) => `${cityName(from)} → ${cityName(to as string)}`)
        : [];
    body = `<p class="vc-big">Closest match: <strong>${policyName(rec.chosen_policy_id)}</strong></p>
      <ul class="vc-issues">${issues.map((i) => `<li>${i}</li>`).join("")}</ul>
      ${swaps.length ? `<p class="vc-fine"><strong>Plan A:</strong> swap ${swaps.join(", ")} to stay visa-free.</p>` : ""}
      <p class="vc-fine"><strong>Plan B:</strong> keep your itinerary and apply for a tourist (L) visa.</p>`;
  } else {
    body = `<p class="vc-big">No visa-free policy covers this itinerary.</p>
      <p class="vc-fine">Apply for a tourist (L) visa, or adjust your route and re-check.</p>`;
  }

  return `<div class="vc-verdict ${tone}">
      ${badge}
      <h3>${countryName(q.country_code)} passport · ${q.cities.map(cityName).join(" + ")}</h3>
      ${body}
      <p class="vc-fine vc-source">Guidance from verified policy data (last synced at build). Confirm against official sources before booking.</p>
    </div>`;
}

// ---- wire up ----

function init() {
  const nat = $<HTMLSelectElement>("vc-nationality");
  if (!nat) return;

  nat.innerHTML = `<option value="">Select your passport…</option>` + countryOptions();
  const dep = $<HTMLSelectElement>("vc-departure");
  const onw = $<HTMLSelectElement>("vc-onward");
  if (dep) dep.innerHTML = `<option value="">Same as passport</option>` + countryOptions();
  if (onw) onw.innerHTML = countryOptions(true);
  $<HTMLSelectElement>("vc-entry-port")!.innerHTML = portOptions();
  $<HTMLSelectElement>("vc-exit-port")!.innerHTML = portOptions();
  renderCityChips();

  // deep link ?country=US or ?country=japan
  const param = new URLSearchParams(location.search).get("country");
  if (param) {
    const hit = countries.find(
      (c) => c.iso2.toLowerCase() === param.toLowerCase() || c.slug === param.toLowerCase()
    );
    if (hit) nat.value = hit.iso2;
  }

  const onNationality = () => {
    const v = nat.value;
    const instant = $("vc-instant-result")!;
    const tripToggle = $("vc-trip-toggle")!;
    if (!v) {
      instant.innerHTML = "";
      tripToggle.classList.add("is-hidden");
      return;
    }
    instant.innerHTML = renderInstant(summarize(v, data));
    tripToggle.classList.remove("is-hidden");
    if (dep && !dep.value) dep.value = v;
  };
  nat.addEventListener("change", onNationality);
  if (param) onNationality();

  $("vc-trip-toggle")!.addEventListener("click", () => {
    const form = $("vc-trip")!;
    const open = form.classList.toggle("open");
    $("vc-trip-toggle")!.setAttribute("aria-expanded", String(open));
  });

  $<HTMLSelectElement>("vc-city-add")!.addEventListener("change", (e) => {
    const v = (e.target as HTMLSelectElement).value;
    if (v && !tripCities.includes(v)) tripCities.push(v);
    renderCityChips();
  });

  $("vc-run")!.addEventListener("click", runTrip);
}

if (document.readyState === "loading") document.addEventListener("DOMContentLoaded", init);
else init();
