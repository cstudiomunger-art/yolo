// Faithful TypeScript port of the app's VisaPolicyEngine.swift (itself a port of the
// verified delivery-package engine.py). Pure function over a VisaDataSet:
//   collect ALL eligible candidates → run a four-dimension health sheet on each →
//   pick the least-restrictive PASS via scorePolicy (NOT a priority short-circuit).
//
//   pass exists  → green, scorePolicy picks the winner, rest are also-eligible
//   no pass, fail → amber, smallest-gap candidate + plan A (modify) / plan B (visa)
//   only L left  → red, visa_L fallback
//
// Keep this in lock-step with VisaPolicyEngine.swift. Dates use the browser's local
// wall clock to match the policy clock ("入境次日 0 时" etc.).

import type {
  VisaDataSet,
  VisaGrant,
  VisaPolicy,
  VisaQuery,
  VisaRecommendation,
  VisaSheet,
} from "./visa-types";

const CN = "CN";

// ---- date helpers (local wall clock) ----

function startOfDay(d: Date): Date {
  return new Date(d.getFullYear(), d.getMonth(), d.getDate());
}
function addDays(d: Date, n: number): Date {
  return new Date(d.getFullYear(), d.getMonth(), d.getDate() + n, d.getHours(), d.getMinutes(), d.getSeconds());
}
function addHours(d: Date, n: number): Date {
  return new Date(d.getTime() + n * 3600_000);
}
function dayString(d: Date): string {
  const y = d.getFullYear();
  const m = String(d.getMonth() + 1).padStart(2, "0");
  const day = String(d.getDate()).padStart(2, "0");
  return `${y}-${m}-${day}`;
}

// ---- small derivations ----

export function conditionsCount(p: VisaPolicy): number {
  return (
    (p.onward_ticket ? 1 : 0) +
    (p.onward_third_country ? 1 : 0) +
    (p.group_required ? 1 : 0) +
    (p.entry_port_limited ? 1 : 0)
  );
}
function isNational(p: VisaPolicy): boolean {
  return p.allowed_area === "national";
}
function minPassportValidityMonths(data: VisaDataSet): number {
  return data.config.find((c) => c.key === "passport_validity_months")?.value_int ?? 3;
}

// ---- predicates / math (engine.py parity) ----

/** HK/MO are third places; round-trip / to-CN / undecided are not. */
export function isThirdCountryTransit(departure: string, onward: string | null): boolean | null {
  if (!onward || onward === "undecided") return null;
  if (onward.toUpperCase() === departure.toUpperCase()) return false;
  if (onward.toUpperCase() === CN) return false;
  return true;
}

function effectiveStay(p: VisaPolicy, grant: VisaGrant | null): number {
  return grant?.max_stay_override ?? p.max_stay_default ?? 0;
}

/** Latest legal exit (exclusive cutoff). Three clock-rule branches. */
function computeLatestExit(p: VisaPolicy, entryAt: Date, grant: VisaGrant | null): { at: Date; date: Date } {
  const midnight = startOfDay(entryAt);
  const nextMidnight = addDays(midnight, 1);
  const stay = effectiveStay(p, grant);
  const rule = p.clock_rule ?? "next_day_0000";

  let latest: Date;
  if (p.max_stay_unit === "hours") {
    let start: Date;
    if (rule === "next_day_0000") start = nextMidnight;
    else if (rule === "by_hour") start = entryAt;
    else start = midnight;
    latest = addHours(start, stay);
  } else {
    const start = rule === "next_day_0000" ? nextMidnight : midnight;
    latest = addDays(start, stay);
  }
  const lastDay = startOfDay(new Date(latest.getTime() - 1000));
  return { at: latest, date: lastDay };
}

export function activeGrant(
  policyId: string,
  country: string,
  onDate: string,
  data: VisaDataSet
): VisaGrant | null {
  const cc = country.toUpperCase();
  const matches = data.grants.filter(
    (g) =>
      g.policy_id === policyId &&
      g.country_code.toUpperCase() === cc &&
      (g.effective_date ?? "1900-01-01") <= onDate &&
      (g.expiry_date == null || g.expiry_date >= onDate)
  );
  if (matches.length === 0) return null;
  return matches.reduce((best, g) =>
    (g.effective_date ?? "") > (best.effective_date ?? "") ? g : best
  );
}

function feasibility(city: string, policyId: string, data: VisaDataSet): string {
  return data.matrix.find((m) => m.city_id === city && m.policy_id === policyId)?.feasibility ?? "no";
}

// ---- S1 eligibility — list ALL candidates, don't short-circuit ----

type CandStatus = "candidate" | "excluded" | "fallback";
interface Candidate {
  policy_id: string;
  status: CandStatus;
  reason: string;
}

export function checkEligibility(query: VisaQuery, data: VisaDataSet): Candidate[] {
  const onDate = dayString(query.entry_at);
  const third = isThirdCountryTransit(query.departure, query.onward);
  const out: Candidate[] = [];
  for (const p of [...data.policies].sort((a, b) => a.priority - b.priority)) {
    if (p.id === "visa_L") {
      out.push({ policy_id: p.id, status: "fallback", reason: "always available, cost = time + fee" });
      continue;
    }
    const grant = activeGrant(p.id, query.country_code, onDate, data);
    if (grant == null && !p.universal) {
      out.push({ policy_id: p.id, status: "excluded", reason: `no active ${p.id} grant for ${query.country_code}` });
      continue;
    }
    if (p.onward_third_country && third !== true) {
      out.push({ policy_id: p.id, status: "excluded", reason: "not a third-country transit" });
      continue;
    }
    if (p.group_required && !query.group) {
      out.push({ policy_id: p.id, status: "excluded", reason: "group exemption requires a tour group" });
      continue;
    }
    out.push({ policy_id: p.id, status: "candidate", reason: "eligible" });
  }
  return out;
}

// ---- S3 health sheet — four dims × gap ----

export function runSheet(
  query: VisaQuery,
  policy: VisaPolicy,
  grant: VisaGrant | null,
  data: VisaDataSet
): VisaSheet {
  // ① space
  const blockers: string[] = [];
  for (const c of query.cities) {
    const feas = feasibility(c, policy.id, data);
    if (!(feas === "ok" || feas === "permit_required")) blockers.push(c);
  }
  const spaceOk = blockers.length === 0;

  // ② time
  const { at: latestAt, date: latestDate } = computeLatestExit(policy, query.entry_at, grant);
  const timeOk = query.planned_exit_at <= latestAt;
  const overstay = Math.max(0, (query.planned_exit_at.getTime() - latestAt.getTime()) / 3600_000);

  // ③ port (entry + exit both restricted)
  const portOk =
    (policy.entry_ports == null || (query.entry_port != null && policy.entry_ports.includes(query.entry_port))) &&
    (policy.exit_ports == null || (query.exit_port != null && policy.exit_ports.includes(query.exit_port)));

  // ④ condition (onward ticket / third country / group)
  const third = isThirdCountryTransit(query.departure, query.onward);
  let condOk = true;
  const reasons: string[] = [];
  if (policy.onward_ticket && !query.ticketed) {
    condOk = false;
    reasons.push("requires an onward ticket");
  }
  if (policy.onward_third_country && third !== true) {
    condOk = false;
    reasons.push("requires travel to a third country/region");
  }
  if (policy.group_required && !query.group) {
    condOk = false;
    reasons.push("requires entering with a tour group");
  }

  return {
    policy_id: policy.id,
    pass: spaceOk && timeOk && portOk && condOk,
    space_ok: spaceOk,
    blockers,
    time_ok: timeOk,
    latest_exit_at: latestAt,
    latest_exit_date: latestDate,
    overstay_hours: overstay,
    port_ok: portOk,
    condition_ok: condOk,
    condition_reasons: reasons,
  };
}

// ---- scoring / gap ----

/** Smaller = preferred: conditions → spatial → -margin (margin is only a tiebreak). */
function scoreTuple(p: VisaPolicy, latestExitAt: Date | null, plannedExitAt: Date): [number, number, number] {
  const margin = ((latestExitAt ?? plannedExitAt).getTime() - plannedExitAt.getTime()) / 1000;
  return [conditionsCount(p), isNational(p) ? 0 : 1, -margin];
}
function gapTuple(s: VisaSheet): [number, number, number] {
  const nfail = (s.space_ok ? 0 : 1) + (s.time_ok ? 0 : 1) + (s.port_ok ? 0 : 1) + (s.condition_ok ? 0 : 1);
  return [nfail, s.overstay_hours, s.blockers.length];
}
function lessTuple(a: [number, number, number], b: [number, number, number]): boolean {
  for (let i = 0; i < a.length; i++) {
    if (a[i] !== b[i]) return a[i] < b[i];
  }
  return false;
}

/** Swap each blocker for a same-province reachable city under the policy. */
function replaceBlockers(policyId: string, blockers: string[], data: VisaDataSet): Record<string, string | null> {
  const swaps: Record<string, string | null> = {};
  const okCities = data.matrix
    .filter((m) => m.policy_id === policyId && m.feasibility === "ok")
    .map((m) => m.city_id)
    .sort();
  for (const b of blockers) {
    const prov = b.slice(0, 2);
    swaps[b] = okCities.find((c) => c.startsWith(prov) && c !== b) ?? null;
  }
  return swaps;
}

// ---- public entry ----

export function recommend(query: VisaQuery, data: VisaDataSet): VisaRecommendation {
  // GATE 0 — passport validity floor.
  if (query.passport_valid_months != null && query.passport_valid_months < minPassportValidityMonths(data)) {
    return {
      level: "red",
      chosen_policy_id: "GATE0",
      also_eligible: [],
      sheets: [],
      plans: [],
      blockers: query.cities,
      latest_exit_date: null,
      max_stay_days: null,
    };
  }

  const candidates = checkEligibility(query, data);
  const policyMap = new Map(data.policies.map((p) => [p.id, p]));
  const onDate = dayString(query.entry_at);

  const sheets: VisaSheet[] = [];
  for (const c of candidates) {
    if (c.status !== "candidate") continue;
    const p = policyMap.get(c.policy_id);
    if (!p) continue;
    const grant = activeGrant(p.id, query.country_code, onDate, data);
    sheets.push(runSheet(query, p, grant, data));
  }

  const passed = sheets.filter((s) => s.pass);

  const displayStay = (p: VisaPolicy): number | null =>
    p.max_stay_unit === "days"
      ? effectiveStay(p, activeGrant(p.id, query.country_code, onDate, data))
      : null;

  // 🟢 Green
  if (passed.length > 0) {
    const chosen = passed.reduce((best, s) =>
      lessTuple(
        scoreTuple(policyMap.get(s.policy_id)!, s.latest_exit_at, query.planned_exit_at),
        scoreTuple(policyMap.get(best.policy_id)!, best.latest_exit_at, query.planned_exit_at)
      )
        ? s
        : best
    );
    return {
      level: "green",
      chosen_policy_id: chosen.policy_id,
      also_eligible: passed.filter((s) => s.policy_id !== chosen.policy_id).map((s) => s.policy_id),
      sheets,
      plans: [],
      blockers: chosen.blockers,
      latest_exit_date: chosen.latest_exit_date,
      max_stay_days: displayStay(policyMap.get(chosen.policy_id)!),
    };
  }

  // 🔴 Red — only L visa remains
  const failing = sheets.filter((s) => !s.pass);
  if (failing.length === 0) {
    return {
      level: "red",
      chosen_policy_id: "visa_L",
      also_eligible: [],
      sheets,
      plans: [{ kind: "apply_visa" }],
      blockers: query.cities,
      latest_exit_date: null,
      max_stay_days: null,
    };
  }

  // 🟡 Amber — smallest-gap candidate
  const chosen = failing.reduce((best, s) => (lessTuple(gapTuple(s), gapTuple(best)) ? s : best));
  const swaps = replaceBlockers(chosen.policy_id, chosen.blockers, data);
  return {
    level: "amber",
    chosen_policy_id: chosen.policy_id,
    also_eligible: [],
    sheets,
    plans: [
      { kind: "modify", policy_id: chosen.policy_id, swaps, new_planned_exit_max: chosen.time_ok ? null : chosen.latest_exit_at },
      { kind: "apply_visa" },
    ],
    blockers: chosen.blockers,
    latest_exit_date: chosen.latest_exit_date,
    max_stay_days: displayStay(policyMap.get(chosen.policy_id)!),
  };
}
