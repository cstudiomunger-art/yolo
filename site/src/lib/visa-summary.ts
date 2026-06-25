// Nationality-level visa summary — the instant "just pick your passport" verdict that
// powers the app's most-loved onboarding moment and our per-country SEO pages.
// Ported from VisaNationalitySummary.swift, extended to surface WHICH policies apply
// (with stay + conditions) so each /china-visa-free/[country] page has real content.

import { activeGrant, conditionsCount } from "./visa-engine";
import type { VisaDataSet, VisaGrant, VisaPolicy } from "./visa-types";

const NATIONWIDE = ["mutual_exempt", "unilateral_30d"];
const CONDITIONAL = ["twov_240h", "hainan_30d", "group_asean_xsbn"];

export type VisaVerdict = "visa_free" | "conditional" | "visa_required";

export interface AppliedPolicy {
  id: string;
  name_en: string;
  name_zh: string;
  type: string;
  stay_days: number | null;
  stay_hours: number | null;
  conditions: string[]; // human-readable restriction labels
  source_url: string | null;
  last_verified: string | null;
  expiry_date: string | null;
}

export interface NationalitySummary {
  country_code: string;
  verdict: VisaVerdict;
  headline: string;
  stay_days: number | null; // for the clean nationwide badge
  nationwide: AppliedPolicy[];
  conditional: AppliedPolicy[];
}

function todayString(today: Date): string {
  return today.toISOString().slice(0, 10);
}

function conditionLabels(p: VisaPolicy): string[] {
  const out: string[] = [];
  if (p.entry_port_limited) out.push("Only via designated entry/exit ports");
  if (p.onward_ticket) out.push("Confirmed onward ticket required");
  if (p.onward_third_country) out.push("Must be transiting to a third country/region");
  if (p.group_required) out.push("Must enter with an approved tour group");
  if (p.allowed_area !== "national") out.push("Limited to specific regions");
  return out;
}

function toApplied(p: VisaPolicy, grant: VisaGrant | null): AppliedPolicy {
  const stay = grant?.max_stay_override ?? p.max_stay_default ?? null;
  return {
    id: p.id,
    name_en: p.official_name_en,
    name_zh: p.official_name_zh,
    type: p.policy_type,
    stay_days: p.max_stay_unit === "days" ? stay : null,
    stay_hours: p.max_stay_unit === "hours" ? stay : null,
    conditions: conditionLabels(p),
    source_url: p.source_url,
    last_verified: p.last_verified,
    expiry_date: grant?.expiry_date ?? null,
  };
}

export function summarize(countryCode: string, data: VisaDataSet, today: Date = new Date()): NationalitySummary {
  const cc = countryCode.toUpperCase();
  const onDate = todayString(today);
  const sorted = [...data.policies].sort((a, b) => a.priority - b.priority);

  const nationwide: AppliedPolicy[] = [];
  for (const p of sorted) {
    if (!NATIONWIDE.includes(p.id)) continue;
    const grant = activeGrant(p.id, cc, onDate, data);
    if (grant) nationwide.push(toApplied(p, grant));
  }

  const conditional: AppliedPolicy[] = [];
  for (const p of sorted) {
    if (!CONDITIONAL.includes(p.id)) continue;
    const grant = activeGrant(p.id, cc, onDate, data);
    if (grant) conditional.push(toApplied(p, grant));
  }

  if (nationwide.length > 0) {
    const best = nationwide.reduce((a, b) => ((b.stay_days ?? 0) > (a.stay_days ?? 0) ? b : a));
    return {
      country_code: cc,
      verdict: "visa_free",
      headline: best.name_en,
      stay_days: best.stay_days,
      nationwide,
      conditional,
    };
  }
  if (conditional.length > 0) {
    return {
      country_code: cc,
      verdict: "conditional",
      headline: "Conditional visa-free",
      stay_days: null,
      nationwide,
      conditional,
    };
  }
  return {
    country_code: cc,
    verdict: "visa_required",
    headline: "Visa required",
    stay_days: null,
    nationwide,
    conditional,
  };
}

// Sort helper so policy condition chips stay stable on the page.
export function sortConditions(p: AppliedPolicy): AppliedPolicy {
  return { ...p, conditions: [...p.conditions].sort() };
}

export { conditionsCount };
