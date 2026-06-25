// TypeScript shapes for the visa engine — snake_case to match the Supabase snapshot
// (visa-data.json) verbatim, so no key transform is needed between fetch and engine.
// These mirror the app's VisaPolicyModels.swift (VisaPolicyV2 / VisaGrantV2 / ...).

export type AllowedArea = "national" | string[];

export interface VisaPolicy {
  id: string;
  policy_type: string;
  node_kind: string; // "computed" | "info" (visa_L fallback)
  universal: boolean; // true → skip grant requirement (24h transit / cruise)
  official_name_zh: string;
  official_name_en: string;
  onward_ticket: boolean;
  onward_third_country: boolean;
  group_required: boolean;
  entry_port_limited: boolean;
  entry_ports: string[] | null;
  exit_ports: string[] | null;
  entry_mode: string[] | null;
  max_stay_default: number | null;
  max_stay_unit: "days" | "hours" | null;
  clock_rule: string | null; // next_day_0000 | by_hour | entry_day
  entry_count: string | null;
  allowed_area: AllowedArea;
  passport_ordinary_only: boolean | null;
  purpose: string[] | null;
  passport_validity_months: number | null;
  priority: number;
  source_url: string | null;
  last_verified: string | null;
}

export interface VisaGrant {
  id: string;
  policy_id: string;
  country_code: string;
  effective_date: string | null; // "yyyy-MM-dd"
  expiry_date: string | null;
  max_stay_override: number | null;
  entry_count_override?: string | null;
  announced_date?: string | null;
  evidence_quote?: string | null;
  source_url?: string | null;
  last_verified?: string | null;
}

export interface VisaCity {
  city_id: string;
  name_zh: string;
  name_en: string;
  region_type: string;
  is_entry_port: boolean;
  is_exit_port: boolean;
  transit_240h: boolean;
  app_city_slug: string | null;
}

export interface CityPolicyFeas {
  city_id: string;
  policy_id: string;
  feasibility: "ok" | "no" | "permit_required" | string;
}

export interface PermitZone {
  admin_code: string;
  name: string;
  note: string | null;
}

export interface VisaPort {
  code: string;
  name_zh: string;
  display_order: number;
}

export interface VisaConfigRow {
  key: string;
  value_int: number | null;
  value_text: string | null;
}

export interface VisaDataSet {
  policies: VisaPolicy[];
  grants: VisaGrant[];
  cities: VisaCity[];
  matrix: CityPolicyFeas[];
  permit_zones: PermitZone[];
  ports: VisaPort[];
  config: VisaConfigRow[];
}

export interface VisaQuery {
  country_code: string; // passport nationality (ISO-2)
  departure: string; // departure country
  onward: string | null; // next leg; null/"undecided" = undecided
  entry_port: string | null;
  exit_port: string | null;
  entry_at: Date; // precise entry datetime (clock start)
  planned_exit_at: Date;
  cities: string[]; // GB/T 2260 admin codes
  ticketed: boolean; // has an onward ticket
  group: boolean; // entering with a tour group
  passport_valid_months: number | null; // GATE0 pre-check; null = skip
  today: Date; // freshness baseline
}

export type VisaLevel = "green" | "amber" | "red";

export interface VisaSheet {
  policy_id: string;
  pass: boolean;
  space_ok: boolean;
  blockers: string[];
  time_ok: boolean;
  latest_exit_at: Date | null;
  latest_exit_date: Date | null;
  overstay_hours: number;
  port_ok: boolean;
  condition_ok: boolean;
  condition_reasons: string[];
}

export type VisaPlan =
  | { kind: "modify"; policy_id: string; swaps: Record<string, string | null>; new_planned_exit_max: Date | null }
  | { kind: "apply_visa" };

export interface VisaRecommendation {
  level: VisaLevel;
  chosen_policy_id: string; // "GATE0" if passport too short
  also_eligible: string[];
  sheets: VisaSheet[];
  plans: VisaPlan[];
  blockers: string[];
  latest_exit_date: Date | null;
  max_stay_days: number | null;
}
