/** DB-backed itinerary assembly for ai-complete. */

import {
  cityDisplayName,
  routeLabelFromOrder,
  travelExperienceItems,
  travelHours,
  type CityMetaRow,
} from "./city-travel-hints.ts";
import {
  maxAttractionsPerDayByCatalog,
  parseDurationSlots,
} from "./itinerary-duration.ts";
import { pickVisitTimeSlot, visitTimeSlotLabel } from "./itinerary-visit-hours.ts";
import { runItinerarySchedulerPipeline, type IntercityHopDay } from "./itinerary-scheduler.ts";
import { parsePace, defaultPace } from "./itinerary-pace.ts";
import { seasonHintsForTrip } from "./itinerary-season-hints.ts";
import { fillEmptyItineraryDays } from "./itinerary-day-fill.ts";
import { annotateIntercityHops } from "./annotate-intercity-hops.ts";
import { regionMap } from "./itinerary-city-days.ts";

export type AttractionRow = {
  id: string;
  city_id: string;
  name: string;
  summary: string | null;
  cover_image_path: string | null;
  recommended_duration: string | null;
  ticket_price: string | null;
  audio_guide_count: number;
  display_order: number;
  priority: string;
  planning_zone?: string | null;
  recommended_visit_period?: string | null;
  attraction_kind?: string | null;
  closed_weekdays?: string[] | null;
  open_time?: string | null;
  close_time?: string | null;
  last_entry_time?: string | null;
  opening_hours?: string | null;
  closed_days?: string | null;
};

export type ItineraryActivity = {
  id: string;
  time_slot: string;
  name: string;
  detail: string;
  attraction_id: string | null;
  city_id: string | null;
  has_audio: boolean;
};

export type ItineraryIntercityHop = {
  from_city_id: string;
  to_city_id: string;
  travel_hours: number;
  items: string[];
  arrival_time_at_destination?: string;
};

export type ItineraryDay = {
  id: string;
  day_index: number;
  date_label: string;
  city_name: string;
  cost_estimate: string | null;
  day_kind?: string;
  experience_items?: string[];
  experience_city_id?: string;
  intercity_hop?: ItineraryIntercityHop;
  activities: ItineraryActivity[];
};

export type SampleItinerary = {
  id: string;
  title: string;
  meta: string;
  route_summary: string;
  estimated_budget: string;
  days: ItineraryDay[];
  visit_order?: string[];
  user_edited?: boolean;
  dropped_attraction_ids?: string[];
  scheduling_adjustments?: string[];
  season_hints?: string[];
};

export type AIAssignment = {
  day_index: number;
  attraction_ids: string[];
};

export type AIExperienceDay = {
  day_index: number;
  city_id: string;
  items: string[];
  kind?: "travel" | "rest" | "experience";
  from_city_id?: string;
};

export type AICityPlan = {
  visit_order?: string[];
  city_day_weights?: Record<string, number>;
  must_see_ids?: string[];
  experience_days?: AIExperienceDay[];
};

export type AIDayPlan = {
  day_index: number;
  city_id: string;
  attraction_ids: string[];
  hop_from_city_id?: string;
  theme?: string;
  time_hints?: Record<string, string>;
};

export type AIPlanResponse = {
  assignments?: AIAssignment[];
  experience_days?: AIExperienceDay[];
  visit_order?: string[];
  city_plan?: AICityPlan;
  day_plans?: AIDayPlan[];
  city_day_weights?: Record<string, number>;
  must_see_ids?: string[];
  title?: string;
  estimated_budget?: string;
};

export type DayPlan = {
  /** All calendar activity slots (1…tripDays). */
  attractionDayIndices: number[];
  experienceDaySpecs: { day_index: number; city_id: string }[];
  maxPerDay: number;
};

const EXPERIENCE_TEMPLATES: Record<string, string[]> = {
  beijing: [
    "Street food tasting",
    "Traditional tea ceremony",
    "Hutong walking tour",
    "Night market experience",
    "Local craft workshop",
    "Traditional Chinese massage",
  ],
  shanghai: [
    "Huangpu riverfront walk",
    "Local breakfast crawl",
    "Traditional tea house visit",
    "Night skyline viewing",
    "Calligraphy workshop",
    "French Concession stroll",
  ],
  chengdu: [
    "Hot pot experience",
    "Tea house culture",
    "Spice market visit",
    "Night food street",
    "Sichuan cooking class",
    "Park tai chi observation",
  ],
  default: [
    "Street food tasting",
    "Traditional tea ceremony",
    "Local market visit",
    "Night market experience",
    "Cultural workshop",
    "Neighborhood walking time",
  ],
};

export function supabaseHeaders(): { url: string; key: string } | null {
  const url = Deno.env.get("SUPABASE_URL");
  const key =
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? Deno.env.get("SUPABASE_ANON_KEY");
  if (!url || !key) return null;
  return { url, key };
}

export async function fetchAttractionsForCities(
  cityIds: string[],
): Promise<AttractionRow[]> {
  const creds = supabaseHeaders();
  if (!creds || cityIds.length === 0) return [];

  const ids = cityIds.map((c) => encodeURIComponent(c)).join(",");
  const select =
    "id,city_id,name,summary,cover_image_path,recommended_duration,ticket_price,audio_guide_count,display_order,priority,planning_zone,recommended_visit_period,attraction_kind,closed_weekdays,open_time,close_time,last_entry_time,opening_hours,closed_days";
  const res = await fetch(
    `${creds.url}/rest/v1/attractions?city_id=in.(${ids})&is_published=eq.true&select=${select}&order=display_order.asc`,
    {
      headers: {
        apikey: creds.key,
        Authorization: `Bearer ${creds.key}`,
      },
    },
  );
  if (!res.ok) {
    console.warn("fetchAttractionsForCities failed", res.status);
    return [];
  }
  const rows = await res.json();
  if (!Array.isArray(rows)) return [];
  return rows.map((r: Record<string, unknown>) => ({
    id: String(r.id),
    city_id: String(r.city_id),
    name: String(r.name),
    summary: r.summary != null ? String(r.summary) : null,
    cover_image_path: r.cover_image_path != null
      ? String(r.cover_image_path)
      : null,
    recommended_duration: r.recommended_duration != null
      ? String(r.recommended_duration)
      : null,
    ticket_price: r.ticket_price != null ? String(r.ticket_price) : null,
    audio_guide_count: Number(r.audio_guide_count) || 0,
    display_order: Number(r.display_order) || 0,
    priority: String(r.priority ?? "P1"),
    planning_zone: r.planning_zone != null ? String(r.planning_zone) : null,
    recommended_visit_period: r.recommended_visit_period != null
      ? String(r.recommended_visit_period)
      : null,
    attraction_kind: r.attraction_kind != null ? String(r.attraction_kind) : null,
    closed_weekdays: Array.isArray(r.closed_weekdays)
      ? r.closed_weekdays.map((v) => String(v).toLowerCase())
      : null,
    open_time: r.open_time != null ? String(r.open_time) : null,
    close_time: r.close_time != null ? String(r.close_time) : null,
    last_entry_time: r.last_entry_time != null ? String(r.last_entry_time) : null,
    opening_hours: r.opening_hours != null ? String(r.opening_hours) : null,
    closed_days: r.closed_days != null ? String(r.closed_days) : null,
  }));
}

/** Every trip day is a slot; experience vs attraction decided by scheduler / AI. */
export function buildDayPlan(tripDays: number, catalog: AttractionRow[]): DayPlan {
  const days = Math.max(1, Math.min(tripDays, 21));
  const attractionDayIndices = Array.from({ length: days }, (_, i) => i + 1);
  const maxPerDay = maxAttractionsPerDayByCatalog(
    catalog.map((a) => parseDurationSlots(a.recommended_duration)),
    days,
    3,
  );

  return { attractionDayIndices, experienceDaySpecs: [], maxPerDay };
}

function stripHtmlToPlainText(content: string): string {
  const trimmed = content.trim();
  if (!/<[a-z][\s\S]*?>/i.test(trimmed)) return trimmed;
  return trimmed
    .replace(/<(br|hr)\s*\/?>/gi, "\n")
    .replace(/<\/(p|div|h[1-6]|li|tr)>/gi, "\n")
    .replace(/<[^>]+>/g, "")
    .replace(/&nbsp;/g, " ")
    .replace(/&amp;/g, "&")
    .replace(/&lt;/g, "<")
    .replace(/&gt;/g, ">")
    .replace(/&quot;/g, '"')
    .replace(/&#39;/g, "'")
    .replace(/\n{3,}/g, "\n\n")
    .trim();
}

function activityDetail(row: AttractionRow): string {
  const parts: string[] = [];
  if (row.recommended_duration) parts.push(row.recommended_duration);
  if (row.summary) parts.push(stripHtmlToPlainText(row.summary));
  else if (row.ticket_price) parts.push(row.ticket_price);
  return parts.join(" · ") || "Explore at your own pace";
}

function buildActivity(
  row: AttractionRow,
  dayIndex: number,
  actIndex: number,
  preferredSlot: "morning" | "afternoon" | "evening" | null = null,
): ItineraryActivity {
  const slot = pickVisitTimeSlot(
    row,
    preferredSlot ?? (actIndex % 2 === 0 ? "morning" : "afternoon"),
  );
  return {
    id: `a_${dayIndex}_${actIndex}_${row.id}`,
    time_slot: visitTimeSlotLabel(slot),
    name: row.name,
    detail: activityDetail(row),
    attraction_id: row.id,
    city_id: row.city_id,
    has_audio: row.audio_guide_count > 0,
  };
}

function templateExperienceItems(cityId: string): string[] {
  const key = cityId.toLowerCase();
  return [...(EXPERIENCE_TEMPLATES[key] ?? EXPERIENCE_TEMPLATES.default)];
}

function isExperienceSlot(exp: AIExperienceDay | undefined): boolean {
  if (!exp) return false;
  if (exp.kind === "travel" || exp.kind === "rest") return true;
  return (exp.items?.length ?? 0) > 0;
}

function dayCityLabel(
  day: ItineraryDay,
): string {
  if (day.day_kind === "experience_suggestions") {
    return day.experience_city_id ? cityDisplayName(day.experience_city_id) : "";
  }
  const seen: string[] = [];
  for (const act of day.activities) {
    const cid = act.city_id;
    if (!cid) continue;
    const name = cityDisplayName(cid);
    if (!seen.includes(name)) seen.push(name);
  }
  return seen.join(" · ");
}

export function assembleItinerary(params: {
  cities: string[];
  tripDays: number;
  catalog: AttractionRow[];
  plan: DayPlan;
  assignments: AIAssignment[];
  experienceDays: AIExperienceDay[];
  hopDays?: IntercityHopDay[];
  visitOrder?: string[];
  userNotes?: string;
  title?: string;
  estimatedBudget?: string;
  startDate?: Date | null;
  timeHintsByAttractionId?: Map<string, "morning" | "afternoon" | "evening">;
  cityIdByDayIndex?: Record<number, string>;
}): SampleItinerary {
  const {
    tripDays,
    catalog,
    assignments,
    experienceDays,
    userNotes,
    title,
    estimatedBudget,
  } = params;
  void params.startDate;

  const visitOrder = params.visitOrder?.length
    ? params.visitOrder
    : params.cities;
  const cityLabel = routeLabelFromOrder(visitOrder);

  const catalogById = new Map(catalog.map((a) => [a.id, a]));
  const timeHints = params.timeHintsByAttractionId ?? new Map();
  const assignmentByDay = new Map<number, string[]>();
  for (const a of assignments) {
    assignmentByDay.set(a.day_index, a.attraction_ids ?? []);
  }

  const experienceByDay = new Map<number, AIExperienceDay>();
  for (const e of experienceDays) {
    experienceByDay.set(e.day_index, e);
  }

  const hopByDay = new Map<number, IntercityHopDay>();
  for (const hop of params.hopDays ?? []) {
    hopByDay.set(hop.day_index, hop);
  }

  const days: ItineraryDay[] = [];

  for (let dayIndex = 1; dayIndex <= tripDays; dayIndex++) {
    const exp = experienceByDay.get(dayIndex);
    const hop = hopByDay.get(dayIndex);

    if (hop) {
      const ids = assignmentByDay.get(dayIndex) ?? [];
      const activities: ItineraryActivity[] = [];
      ids.forEach((aid, actIndex) => {
        const row = catalogById.get(aid);
        if (!row) return;
        const fromLower = hop.from_city_id.toLowerCase();
        const hinted = timeHints.get(aid);
        let preferred: "morning" | "afternoon" | "evening";
        if (hinted) {
          preferred = hinted;
        } else if (row.city_id.toLowerCase() === fromLower) {
          preferred = "morning";
        } else {
          preferred = row.recommended_visit_period === "evening" ? "evening" : "afternoon";
        }
        activities.push(buildActivity(row, dayIndex, actIndex, preferred));
      });
      days.push({
        id: `day_${dayIndex}`,
        day_index: dayIndex,
        date_label: `Day ${dayIndex}`,
        city_name: routeLabelFromOrder([hop.from_city_id, hop.to_city_id]),
        cost_estimate: null,
        experience_city_id: hop.to_city_id,
        intercity_hop: {
          from_city_id: hop.from_city_id,
          to_city_id: hop.to_city_id,
          travel_hours: hop.travel_hours,
          items: hop.items,
        },
        activities,
      });
      continue;
    }

    if (isExperienceSlot(exp)) {
      const cityId = exp?.city_id || visitOrder[(dayIndex - 1) % visitOrder.length] || "beijing";
      const items = (exp?.items?.length ? exp.items : exp?.kind === "travel"
        ? travelExperienceItems(cityId)
        : templateExperienceItems(cityId))
        .map((s) => String(s).trim())
        .filter(Boolean)
        .slice(0, 8);

      const ids = assignmentByDay.get(dayIndex) ?? [];
      const activities: ItineraryActivity[] = [];
      ids.forEach((aid, actIndex) => {
        const row = catalogById.get(aid);
        if (row) {
          activities.push(buildActivity(row, dayIndex, actIndex, "evening"));
        }
      });

      const travelHop = exp?.kind === "travel" && exp.from_city_id
        ? {
          from_city_id: exp.from_city_id.toLowerCase(),
          to_city_id: cityId.toLowerCase(),
          travel_hours: travelHours(exp.from_city_id, cityId),
          items,
        }
        : undefined;

      days.push({
        id: `day_${dayIndex}`,
        day_index: dayIndex,
        date_label: `Day ${dayIndex}`,
        city_name: cityDisplayName(cityId),
        cost_estimate: null,
        day_kind: "experience_suggestions",
        experience_items: items,
        experience_city_id: cityId,
        intercity_hop: travelHop,
        activities,
      });
      continue;
    }

    const ids = assignmentByDay.get(dayIndex) ?? [];
    const activities: ItineraryActivity[] = [];
    ids.forEach((aid, actIndex) => {
      const row = catalogById.get(aid);
      if (!row) return;
      const hinted = timeHints.get(aid);
      const preferred = hinted ?? (actIndex % 2 === 0 ? "morning" : "afternoon");
      activities.push(buildActivity(row, dayIndex, actIndex, preferred));
    });

    const timelineCity = params.cityIdByDayIndex?.[dayIndex];
    const day: ItineraryDay = {
      id: `day_${dayIndex}`,
      day_index: dayIndex,
      date_label: `Day ${dayIndex}`,
      city_name: timelineCity ? cityDisplayName(timelineCity) : "",
      cost_estimate: null,
      activities,
      experience_city_id: timelineCity,
    };
    if (!timelineCity) {
      day.city_name = dayCityLabel(day);
    }
    days.push(day);
  }

  const resolvedTitle = title?.trim() ||
    `${tripDays}-Day ${cityLabel} Trip`;

  return {
    id: `itin_${Date.now()}`,
    title: resolvedTitle,
    meta: userNotes ? `Generated · ${userNotes.slice(0, 120)}` : "Generated",
    route_summary: cityLabel,
    estimated_budget: estimatedBudget?.trim() || "$800–$1,500",
    visit_order: visitOrder,
    days,
  };
}

export function parseAIPlanResponse(raw: unknown): AIPlanResponse | null {
  if (!raw || typeof raw !== "object") return null;
  const o = raw as Record<string, unknown>;

  const parseExperienceDays = (items: unknown): AIExperienceDay[] =>
    Array.isArray(items)
      ? items.map((item) => {
        const row = item as Record<string, unknown>;
        const expItems = Array.isArray(row.items)
          ? row.items.map((s) => String(s).trim()).filter(Boolean)
          : [];
        const kindRaw = row.kind != null ? String(row.kind).trim() : "";
        const kind = kindRaw === "travel" || kindRaw === "rest" || kindRaw === "experience"
          ? kindRaw
          : undefined;
        const fromCity = row.from_city_id != null
          ? String(row.from_city_id).trim().toLowerCase()
          : undefined;
        return {
          day_index: Number(row.day_index) || 0,
          city_id: String(row.city_id ?? "").trim(),
          items: expItems,
          kind,
          from_city_id: fromCity,
        };
      }).filter((e) => e.day_index > 0)
      : [];

  const parseVisitOrder = (items: unknown): string[] | undefined =>
    Array.isArray(items)
      ? items.map((c) => String(c).trim().toLowerCase()).filter(Boolean)
      : undefined;

  const parseWeights = (weights: unknown): Record<string, number> | undefined => {
    if (!weights || typeof weights !== "object") return undefined;
    const out: Record<string, number> = {};
    for (const [k, v] of Object.entries(weights as Record<string, unknown>)) {
      const n = Number(v);
      if (Number.isFinite(n)) out[k.toLowerCase()] = n;
    }
    return Object.keys(out).length ? out : undefined;
  };

  const parseMustSee = (items: unknown): string[] | undefined =>
    Array.isArray(items)
      ? items.map((id) => String(id).trim()).filter(Boolean)
      : undefined;

  const cityPlanRaw = o.city_plan;
  let city_plan: AICityPlan | undefined;
  if (cityPlanRaw && typeof cityPlanRaw === "object") {
    const cp = cityPlanRaw as Record<string, unknown>;
    city_plan = {
      visit_order: parseVisitOrder(cp.visit_order),
      city_day_weights: parseWeights(cp.city_day_weights),
      must_see_ids: parseMustSee(cp.must_see_ids),
      experience_days: parseExperienceDays(cp.experience_days),
    };
  }

  const day_plans: AIDayPlan[] = Array.isArray(o.day_plans)
    ? o.day_plans.map((item) => {
      const row = item as Record<string, unknown>;
      const ids = Array.isArray(row.attraction_ids)
        ? row.attraction_ids.map((id) => String(id).trim()).filter(Boolean)
        : [];
      const hintsRaw = row.time_hints;
      let time_hints: Record<string, string> | undefined;
      if (hintsRaw && typeof hintsRaw === "object") {
        time_hints = {};
        for (const [k, v] of Object.entries(hintsRaw as Record<string, unknown>)) {
          time_hints[k] = String(v);
        }
      }
      return {
        day_index: Number(row.day_index) || 0,
        city_id: String(row.city_id ?? "").trim().toLowerCase(),
        attraction_ids: ids,
        theme: row.theme != null ? String(row.theme) : undefined,
        time_hints,
        hop_from_city_id: row.hop_from_city_id != null
          ? String(row.hop_from_city_id).trim().toLowerCase()
          : undefined,
      };
    }).filter((p) => p.day_index > 0 && p.city_id)
    : [];

  const assignments: AIAssignment[] = Array.isArray(o.assignments)
    ? o.assignments.map((item) => {
      const row = item as Record<string, unknown>;
      const ids = Array.isArray(row.attraction_ids)
        ? row.attraction_ids.map((id) => String(id).trim()).filter(Boolean)
        : [];
      return {
        day_index: Number(row.day_index) || 0,
        attraction_ids: ids,
      };
    }).filter((a) => a.day_index > 0)
    : [];

  const experience_days = parseExperienceDays(o.experience_days);
  const visit_order = parseVisitOrder(o.visit_order) ?? city_plan?.visit_order;
  const city_day_weights = parseWeights(o.city_day_weights) ?? city_plan?.city_day_weights;
  const must_see_ids = parseMustSee(o.must_see_ids) ?? city_plan?.must_see_ids;
  const mergedExperience = experience_days.length
    ? experience_days
    : city_plan?.experience_days ?? [];

  return {
    assignments,
    experience_days: mergedExperience,
    visit_order,
    city_plan,
    day_plans: day_plans.length ? day_plans : undefined,
    city_day_weights,
    must_see_ids,
    title: o.title != null ? String(o.title) : undefined,
    estimated_budget: o.estimated_budget != null
      ? String(o.estimated_budget)
      : undefined,
  };
}

export const AI_PLAN_JSON_SCHEMA = `{
  "city_plan": {
    "city_day_weights": { "beijing": 3, "shanghai": 2 },
    "must_see_ids": ["attraction_id_from_catalog"],
    "experience_days": [
      { "day_index": 3, "city_id": "shanghai", "kind": "travel", "from_city_id": "beijing" }
    ]
  },
  "day_plans": [
    {
      "day_index": 1,
      "city_id": "beijing",
      "hop_from_city_id": "optional — morning city for intense same-day hop (≤4h travel only)",
      "attraction_ids": ["attraction_id_from_catalog"],
      "theme": "optional",
      "time_hints": { "attraction_id": "morning" }
    }
  ],
  "title": "optional string",
  "estimated_budget": "optional string"
}`;

export const ITINERARY_HARD_CONSTRAINTS =
  "HARD CONSTRAINTS (never violate): Use only catalog attraction_ids; each id once globally; " +
  "respect per-day duration_slots budget until full (short sights may share a day; full-day sights may fill it alone); " +
  "do not put distant cities on the same day unless pace is intense AND travel is ≤4h using hop_from_city_id + city_id on day_plans; " +
  "respect closed_weekdays/open_time/close_time when present; " +
  "use experience_days with kind travel ONLY for intercity moves >4h within the fixed day budget; " +
  "for standard pace do NOT use experience_days for 2-4h moves (scheduler assigns travel-lite + intercity_hop); " +
  "visit_order is computed by the engine from entry/exit — provide city_day_weights only; " +
  "output JSON only.";
export function buildItineraryPipeline(params: {
  cityIds: string[];
  tripDays: number;
  catalog: AttractionRow[];
  citiesMeta: CityMetaRow[];
  aiPlan: AIPlanResponse | null;
  userNotes?: string;
  entryCityId?: string | null;
  exitCityId?: string | null;
  startDateLocal?: string | null;
  pace?: string | null;
  arrivalTime?: string | null;
  departureTime?: string | null;
}): SampleItinerary {
  const parsedStartDate = parseExplicitOrNotesStartDate(params.startDateLocal, params.userNotes);
  const cityIds = params.cityIds.length ? params.cityIds : ["beijing"];
  const catalog = params.catalog;
  const plan = buildDayPlan(params.tripDays, catalog);

  const scheduled = runItinerarySchedulerPipeline({
    cityIds,
    tripDays: params.tripDays,
    catalog,
    citiesMeta: params.citiesMeta,
    aiPlan: params.aiPlan,
    entryCityId: params.entryCityId,
    exitCityId: params.exitCityId,
    startDate: parsedStartDate,
    pace: parsePace(params.pace ?? defaultPace(tripDays, cityIds.length)),
    arrivalTime: params.arrivalTime,
    departureTime: params.departureTime,
  });

  const title = params.aiPlan?.title;
  const estimatedBudget = params.aiPlan?.estimated_budget;

  const itinerary = assembleItinerary({
    cities: scheduled.visitOrder,
    tripDays: params.tripDays,
    catalog,
    plan,
    assignments: scheduled.assignments,
    experienceDays: scheduled.experienceDays,
    hopDays: scheduled.hopDays,
    visitOrder: scheduled.visitOrder,
    userNotes: params.userNotes,
    title,
    estimatedBudget,
    startDate: parsedStartDate,
    timeHintsByAttractionId: scheduled.timeHintsByAttractionId,
    cityIdByDayIndex: scheduled.cityIdByDayIndex,
  });

  const regionByCity = regionMap(params.citiesMeta);
  const annotatedDays = annotateIntercityHops(itinerary.days, regionByCity);
  const filledDays = fillEmptyItineraryDays(annotatedDays, scheduled.visitOrder, {
    arrivalTime: params.arrivalTime,
    departureTime: params.departureTime,
    cityIdByDayIndex: scheduled.cityIdByDayIndex,
    activityDaysExcludeCalendarEndpoints: true,
  });

  const tripMonth = parsedStartDate ? parsedStartDate.getMonth() + 1 : new Date().getMonth() + 1;
  const seasonHints = seasonHintsForTrip({
    cityIds: scheduled.visitOrder,
    citiesMeta: params.citiesMeta,
    tripMonth,
  });

  return {
    ...itinerary,
    days: filledDays,
    dropped_attraction_ids: scheduled.droppedAttractionIds.length
      ? scheduled.droppedAttractionIds
      : undefined,
    scheduling_adjustments: scheduled.adjustments.length
      ? scheduled.adjustments
      : undefined,
    season_hints: seasonHints.length ? seasonHints : undefined,
  };
}

function parseExplicitOrNotesStartDate(startDateLocal?: string | null, notes?: string): Date | null {
  const explicit = String(startDateLocal ?? "").trim();
  if (/^20\d{2}-\d{2}-\d{2}$/.test(explicit)) {
    const date = new Date(`${explicit}T00:00:00`);
    if (!Number.isNaN(date.getTime())) return date;
  }
  const text = String(notes ?? "");
  const match = text.match(/\b(20\d{2})-(\d{2})-(\d{2})\b/);
  if (!match) return null;
  const date = new Date(`${match[1]}-${match[2]}-${match[3]}T00:00:00`);
  return Number.isNaN(date.getTime()) ? null : date;
}
