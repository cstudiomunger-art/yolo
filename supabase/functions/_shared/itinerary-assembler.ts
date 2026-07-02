/** DB-backed itinerary assembly for ai-complete. */

import {
  canVisitSameDay,
  cityDisplayName,
  inferVisitOrder,
  needsTravelDay,
  routeLabelFromOrder,
  travelExperienceItems,
  type CityMetaRow,
} from "./city-travel-hints.ts";
import {
  maxAttractionsPerDayByCatalog,
  parseDurationSlots,
} from "./itinerary-duration.ts";
import {
  isClosedOnDate,
  pickTimeSlot,
} from "./itinerary-visit-hours.ts";

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

export type ItineraryDay = {
  id: string;
  day_index: number;
  date_label: string;
  city_name: string;
  cost_estimate: string | null;
  day_kind?: string;
  experience_items?: string[];
  experience_city_id?: string;
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
};

export type AIPlanResponse = {
  assignments?: AIAssignment[];
  experience_days?: AIExperienceDay[];
  visit_order?: string[];
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

function regionMap(metaByCity: Map<string, CityMetaRow>): Map<string, string | null> {
  return new Map([...metaByCity.entries()].map(([k, v]) => [k, v.region ?? null]));
}

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
    "id,city_id,name,summary,cover_image_path,recommended_duration,ticket_price,audio_guide_count,display_order,priority,planning_zone,closed_weekdays,open_time,close_time,last_entry_time,opening_hours,closed_days";
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

/** Every trip day is a slot; experience vs attraction decided by normalize / AI. */
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

export function assignExperienceCities(
  specs: { day_index: number; city_id: string }[],
  cityIds: string[],
): { day_index: number; city_id: string }[] {
  if (cityIds.length === 0) cityIds = ["beijing"];
  return specs.map((spec, idx) => ({
    day_index: spec.day_index,
    city_id: cityIds[(spec.day_index - 1) % cityIds.length] ?? cityIds[idx % cityIds.length],
  }));
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
  preferredSlot: "morning" | "afternoon" | null = null,
): ItineraryActivity {
  const slot = pickTimeSlot(row, preferredSlot);
  return {
    id: `a_${dayIndex}_${actIndex}_${row.id}`,
    time_slot: slot === "afternoon" ? "Afternoon" : slot === "morning" ? "Morning" : "",
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

function catalogCountByCity(catalog: AttractionRow[]): Map<string, number> {
  const map = new Map<string, number>();
  for (const row of catalog) {
    map.set(row.city_id, (map.get(row.city_id) ?? 0) + 1);
  }
  return map;
}

function metaMap(rows: CityMetaRow[]): Map<string, CityMetaRow> {
  return new Map(rows.map((r) => [r.id.toLowerCase(), r]));
}

export function dedupeAssignmentIds(
  assignments: AIAssignment[],
  catalogById: Map<string, AttractionRow>,
): AIAssignment[] {
  const used = new Set<string>();
  return assignments.map((a) => {
    const ids: string[] = [];
    for (const id of a.attraction_ids ?? []) {
      const sid = String(id).trim();
      if (!sid || !catalogById.has(sid) || used.has(sid)) continue;
      used.add(sid);
      ids.push(sid);
    }
    return { day_index: a.day_index, attraction_ids: ids };
  });
}

function primaryCityForAssignment(
  ids: string[],
  catalogById: Map<string, AttractionRow>,
): string | null {
  const counts = new Map<string, number>();
  for (const id of ids) {
    const row = catalogById.get(id);
    if (!row) continue;
    counts.set(row.city_id, (counts.get(row.city_id) ?? 0) + 1);
  }
  let best: string | null = null;
  let bestCount = 0;
  for (const [city, count] of counts) {
    if (count > bestCount) {
      bestCount = count;
      best = city;
    }
  }
  return best;
}

function citiesOnAssignment(
  ids: string[],
  catalogById: Map<string, AttractionRow>,
): string[] {
  const seen = new Set<string>();
  const out: string[] = [];
  for (const id of ids) {
    const cid = catalogById.get(id)?.city_id;
    if (!cid || seen.has(cid)) continue;
    seen.add(cid);
    out.push(cid);
  }
  return out;
}

function splitIncompatibleSameDay(
  ids: string[],
  catalogById: Map<string, AttractionRow>,
): { keep: string[]; overflow: string[] } {
  if (ids.length <= 1) return { keep: ids, overflow: [] };
  const keep: string[] = [];
  const overflow: string[] = [];
  let anchorCity: string | null = null;

  for (const id of ids) {
    const city = catalogById.get(id)?.city_id;
    if (!city) continue;
    if (!anchorCity) {
      anchorCity = city;
      keep.push(id);
      continue;
    }
    if (city === anchorCity || canVisitSameDay(anchorCity, city)) {
      keep.push(id);
    } else {
      overflow.push(id);
    }
  }
  return { keep, overflow };
}

/** City-block deterministic fill following visit order. */
export function deterministicAssignments(
  plan: DayPlan,
  catalog: AttractionRow[],
  visitOrder: string[],
): { assignments: AIAssignment[]; experienceDays: AIExperienceDay[] } {
  const tripDays = plan.attractionDayIndices.length;
  const catalogByCity = new Map<string, AttractionRow[]>();
  for (const row of catalog) {
    const list = catalogByCity.get(row.city_id) ?? [];
    list.push(row);
    catalogByCity.set(row.city_id, list);
  }
  for (const list of catalogByCity.values()) {
    list.sort((a, b) =>
      a.display_order !== b.display_order
        ? a.display_order - b.display_order
        : a.name.localeCompare(b.name)
    );
  }

  const assignments: AIAssignment[] = plan.attractionDayIndices.map((dayIndex) => ({
    day_index: dayIndex,
    attraction_ids: [],
  }));
  const experienceDays: AIExperienceDay[] = [];
  const experienceDaySet = new Set<number>();

  const citiesInTrip = visitOrder.filter((c) => (catalogByCity.get(c)?.length ?? 0) > 0);
  const activeCities = citiesInTrip.length ? citiesInTrip : visitOrder;

  const dayBudget = distributeDaysAcrossCities(tripDays, activeCities, catalogByCity);
  let dayPtr = 1;

  for (let i = 0; i < activeCities.length; i++) {
    const cityId = activeCities[i];
    const prevCity = i > 0 ? activeCities[i - 1] : null;
    if (prevCity && needsTravelDay(prevCity, cityId) && dayPtr <= tripDays) {
      experienceDays.push({
        day_index: dayPtr,
        city_id: cityId,
        items: travelExperienceItems(cityId),
        kind: "travel",
      });
      experienceDaySet.add(dayPtr);
      dayPtr++;
    }

    const budget = dayBudget.get(cityId) ?? 1;
    const pool = [...(catalogByCity.get(cityId) ?? [])];
    const zoneBuckets = new Map<string, AttractionRow[]>();
    for (const row of pool) {
      const key = (row.planning_zone || "default").trim() || "default";
      const list = zoneBuckets.get(key) ?? [];
      list.push(row);
      zoneBuckets.set(key, list);
    }
    const zoneOrder = [...zoneBuckets.keys()];
    let zoneCursor = 0;

    for (let b = 0; b < budget && dayPtr <= tripDays; b++) {
      while (experienceDaySet.has(dayPtr) && dayPtr <= tripDays) dayPtr++;
      if (dayPtr > tripDays) break;

      const slot = assignments.find((a) => a.day_index === dayPtr)!;
      while (slot.attraction_ids.length < plan.maxPerDay && zoneCursor < zoneOrder.length) {
        const zoneKey = zoneOrder[zoneCursor];
        const zoneList = zoneBuckets.get(zoneKey) ?? [];
        if (zoneList.length === 0) {
          zoneCursor++;
          continue;
        }
        const row = zoneList.shift()!;
        slot.attraction_ids.push(row.id);
        zoneBuckets.set(zoneKey, zoneList);
        if (zoneList.length === 0) zoneCursor++;
      }
      dayPtr++;
    }
  }

  return { assignments, experienceDays };
}

function distributeDaysAcrossCities(
  tripDays: number,
  cities: string[],
  catalogByCity: Map<string, AttractionRow[]>,
): Map<string, number> {
  if (cities.length === 0) return new Map();
  const weights = cities.map((c) => Math.max(1, catalogByCity.get(c)?.length ?? 1));
  const totalWeight = weights.reduce((a, b) => a + b, 0);
  const map = new Map<string, number>();
  let assigned = 0;

  for (let i = 0; i < cities.length; i++) {
    const share = i === cities.length - 1
      ? Math.max(1, tripDays - assigned)
      : Math.max(1, Math.round((tripDays * weights[i]) / totalWeight));
    map.set(cities[i], share);
    assigned += share;
  }

  while (assigned > tripDays) {
    const richest = cities.reduce((best, c) =>
      (map.get(c) ?? 0) > (map.get(best) ?? 0) ? c : best
    );
    if ((map.get(richest) ?? 0) <= 1) break;
    map.set(richest, (map.get(richest) ?? 1) - 1);
    assigned--;
  }
  return map;
}

export function deriveVisitOrderFromTimeline(
  tripDays: number,
  assignments: AIAssignment[],
  experienceDays: AIExperienceDay[],
  catalogById: Map<string, AttractionRow>,
): string[] {
  const experienceByDay = new Map(experienceDays.map((e) => [e.day_index, e]));
  const assignmentByDay = new Map(assignments.map((a) => [a.day_index, a]));
  const order: string[] = [];
  const seen = new Set<string>();

  for (let day = 1; day <= tripDays; day++) {
    const exp = experienceByDay.get(day);
    if (isExperienceSlot(exp) && exp?.city_id) {
      const cid = exp.city_id.toLowerCase();
      if (!seen.has(cid)) {
        seen.add(cid);
        order.push(cid);
      }
      continue;
    }
    const ids = assignmentByDay.get(day)?.attraction_ids ?? [];
    for (const id of ids) {
      const cid = catalogById.get(id)?.city_id?.toLowerCase();
      if (!cid || seen.has(cid)) continue;
      seen.add(cid);
      order.push(cid);
    }
  }
  return order;
}

export function normalizeItineraryPlan(params: {
  cityIds: string[];
  tripDays: number;
  catalog: AttractionRow[];
  plan: DayPlan;
  assignments: AIAssignment[];
  experienceDays: AIExperienceDay[];
  visitOrderHint?: string[];
  citiesMeta?: CityMetaRow[];
  startDate?: Date | null;
}): {
  assignments: AIAssignment[];
  experienceDays: AIExperienceDay[];
  visitOrder: string[];
  routeSummary: string;
} {
  const {
    cityIds,
    tripDays,
    catalog,
    plan,
    citiesMeta = [],
  } = params;
  const regionByCity = regionMap(metaMap(citiesMeta));

  const catalogById = new Map(catalog.map((a) => [a.id, a]));
  const experienceByDay = new Map<number, AIExperienceDay>();

  for (const exp of params.experienceDays) {
    if (exp.day_index >= 1 && exp.day_index <= tripDays) {
      experienceByDay.set(exp.day_index, { ...exp });
    }
  }

  let assignments = plan.attractionDayIndices.map((dayIndex) => {
    const existing = params.assignments.find((a) => a.day_index === dayIndex);
    return {
      day_index: dayIndex,
      attraction_ids: [...(existing?.attraction_ids ?? [])],
    };
  });

  assignments = dedupeAssignmentIds(assignments, catalogById);

  const overflow: string[] = [];
  for (const assignment of assignments) {
    if (experienceByDay.has(assignment.day_index) &&
      isExperienceSlot(experienceByDay.get(assignment.day_index))) {
      overflow.push(...assignment.attraction_ids);
      assignment.attraction_ids = [];
      continue;
    }
    if (assignment.attraction_ids.length > plan.maxPerDay) {
      overflow.push(...assignment.attraction_ids.splice(plan.maxPerDay));
    }
    const split = splitIncompatibleSameDay(assignment.attraction_ids, catalogById);
    assignment.attraction_ids = split.keep;
    overflow.push(...split.overflow);
  }

  for (const id of overflow) {
    let placed = false;
    for (const assignment of assignments) {
      if (experienceByDay.has(assignment.day_index) &&
        isExperienceSlot(experienceByDay.get(assignment.day_index))) continue;
      if (assignment.attraction_ids.length >= plan.maxPerDay) continue;
      const city = catalogById.get(id)?.city_id;
      if (!city) continue;
      const existingCities = citiesOnAssignment(assignment.attraction_ids, catalogById);
      if (existingCities.every((c) => canVisitSameDay(c, city, regionByCity))) {
        assignment.attraction_ids.push(id);
        placed = true;
        break;
      }
    }
    if (!placed) {
      for (const assignment of assignments) {
        if (experienceByDay.has(assignment.day_index) &&
          isExperienceSlot(experienceByDay.get(assignment.day_index))) continue;
        if (assignment.attraction_ids.length < plan.maxPerDay) {
          assignment.attraction_ids.push(id);
          break;
        }
      }
    }
  }

  let prevCity: string | null = null;
  for (let day = 1; day <= tripDays; day++) {
    const exp = experienceByDay.get(day);
    if (isExperienceSlot(exp)) {
      prevCity = exp?.city_id?.toLowerCase() ?? prevCity;
      continue;
    }
    const assignment = assignments.find((a) => a.day_index === day);
    const ids = assignment?.attraction_ids ?? [];
    const city = primaryCityForAssignment(ids, catalogById);
    if (city && prevCity && needsTravelDay(prevCity, city, regionByCity) && !isExperienceSlot(exp)) {
      experienceByDay.set(day, {
        day_index: day,
        city_id: city,
        items: travelExperienceItems(city),
        kind: "travel",
      });
      if (assignment) overflow.push(...assignment.attraction_ids);
      if (assignment) assignment.attraction_ids = [];
    }
    if (city) prevCity = city;
  }

  for (const id of overflow) {
    for (let day = tripDays; day >= 1; day--) {
      const exp = experienceByDay.get(day);
      if (isExperienceSlot(exp)) continue;
      const assignment = assignments.find((a) => a.day_index === day)!;
      if (assignment.attraction_ids.length >= plan.maxPerDay) continue;
      assignment.attraction_ids.push(id);
      break;
    }
  }

  if (params.startDate) {
    for (const assignment of assignments) {
      const date = new Date(params.startDate);
      date.setDate(date.getDate() + (assignment.day_index - 1));
      const kept: string[] = [];
      for (const id of assignment.attraction_ids) {
        const row = catalogById.get(id);
        if (!row) continue;
        if (isClosedOnDate(row, date)) {
          overflow.push(id);
          continue;
        }
        kept.push(id);
      }
      assignment.attraction_ids = kept;
    }
  }

  const metaByCity = metaMap(citiesMeta);
  let visitOrder = deriveVisitOrderFromTimeline(
    tripDays,
    assignments,
    [...experienceByDay.values()],
    catalogById,
  );

  if (visitOrder.length === 0) {
    visitOrder = params.visitOrderHint?.length
      ? params.visitOrderHint
      : inferVisitOrder(cityIds, catalogCountByCity(catalog), metaByCity);
  }

  const routeSummary = routeLabelFromOrder(visitOrder);
  return {
    assignments,
    experienceDays: [...experienceByDay.values()],
    visitOrder,
    routeSummary,
  };
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
  visitOrder?: string[];
  userNotes?: string;
  title?: string;
  estimatedBudget?: string;
  startDate?: Date | null;
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
  const assignmentByDay = new Map<number, string[]>();
  for (const a of assignments) {
    assignmentByDay.set(a.day_index, a.attraction_ids ?? []);
  }

  const experienceByDay = new Map<number, AIExperienceDay>();
  for (const e of experienceDays) {
    experienceByDay.set(e.day_index, e);
  }

  const days: ItineraryDay[] = [];

  for (let dayIndex = 1; dayIndex <= tripDays; dayIndex++) {
    const exp = experienceByDay.get(dayIndex);

    if (isExperienceSlot(exp)) {
      const cityId = exp?.city_id || visitOrder[(dayIndex - 1) % visitOrder.length] || "beijing";
      const items = exp?.kind === "travel"
        ? travelExperienceItems(cityId)
        : (exp?.items?.length ? exp.items : templateExperienceItems(cityId))
          .map((s) => String(s).trim())
          .filter(Boolean)
          .slice(0, 8);

      days.push({
        id: `day_${dayIndex}`,
        day_index: dayIndex,
        date_label: `Day ${dayIndex}`,
        city_name: cityDisplayName(cityId),
        cost_estimate: null,
        day_kind: "experience_suggestions",
        experience_items: items,
        experience_city_id: cityId,
        activities: [],
      });
      continue;
    }

    const ids = assignmentByDay.get(dayIndex) ?? [];
      const activities: ItineraryActivity[] = [];
    ids.forEach((aid, actIndex) => {
      const row = catalogById.get(aid);
      if (row) {
        const preferred = actIndex % 2 === 0 ? "morning" : "afternoon";
        activities.push(buildActivity(row, dayIndex, actIndex, preferred));
      }
    });

    const day: ItineraryDay = {
      id: `day_${dayIndex}`,
      day_index: dayIndex,
      date_label: `Day ${dayIndex}`,
      city_name: "",
      cost_estimate: null,
      activities,
    };
    day.city_name = dayCityLabel(day);
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

  const experience_days: AIExperienceDay[] = Array.isArray(o.experience_days)
    ? o.experience_days.map((item) => {
      const row = item as Record<string, unknown>;
      const items = Array.isArray(row.items)
        ? row.items.map((s) => String(s).trim()).filter(Boolean)
        : [];
      const kindRaw = row.kind != null ? String(row.kind).trim() : "";
      const kind = kindRaw === "travel" || kindRaw === "rest" || kindRaw === "experience"
        ? kindRaw
        : undefined;
      return {
        day_index: Number(row.day_index) || 0,
        city_id: String(row.city_id ?? "").trim(),
        items,
        kind,
      };
    }).filter((e) => e.day_index > 0)
    : [];

  const visit_order = Array.isArray(o.visit_order)
    ? o.visit_order.map((c) => String(c).trim().toLowerCase()).filter(Boolean)
    : undefined;

  return {
    assignments,
    experience_days,
    visit_order,
    title: o.title != null ? String(o.title) : undefined,
    estimated_budget: o.estimated_budget != null
      ? String(o.estimated_budget)
      : undefined,
  };
}

export const AI_PLAN_JSON_SCHEMA = `{
  "visit_order": ["city_id_in_optimized_order"],
  "assignments": [
    { "day_index": 1, "attraction_ids": ["attraction_id_from_catalog"] }
  ],
  "experience_days": [
    { "day_index": 3, "city_id": "shanghai", "kind": "travel", "items": ["Intercity travel", "Travel to Shanghai"] }
  ],
  "title": "optional string",
  "estimated_budget": "optional string"
}`;

export const ITINERARY_HARD_CONSTRAINTS =
  "HARD CONSTRAINTS (never violate): Use only catalog attraction_ids; each id once globally; " +
  "max attractions per day as given; do not put distant cities on the same day (e.g. Beijing+Shanghai+Chengdu); " +
  "respect closed_weekdays/open_time/close_time when present; " +
  "use experience_days with kind travel/rest for intercity moves within the fixed day budget; " +
  "optimize visit_order for minimal travel; output JSON only.";

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
}): SampleItinerary {
  const parsedStartDate = parseExplicitOrNotesStartDate(params.startDateLocal, params.userNotes);
  const cityIds = params.cityIds.length ? params.cityIds : ["beijing"];
  const catalog = params.catalog;
  const plan = buildDayPlan(params.tripDays, catalog);
  const metaByCity = metaMap(params.citiesMeta);
  const catalogCounts = catalogCountByCity(catalog);

  const visitOrderDefault = inferVisitOrder(cityIds, catalogCounts, metaByCity, {
    entryCityId: params.entryCityId,
    exitCityId: params.exitCityId,
  });
  const det = deterministicAssignments(plan, catalog, visitOrderDefault);

  let assignments = det.assignments;
  let experienceDays = det.experienceDays;
  let title = params.aiPlan?.title;
  let estimatedBudget = params.aiPlan?.estimated_budget;
  let visitOrderHint = params.aiPlan?.visit_order;

  if (params.aiPlan?.assignments?.length) {
    const catalogById = new Map(catalog.map((a) => [a.id, a]));
    const aiAssignments = dedupeAssignmentIds(params.aiPlan.assignments, catalogById);
    assignments = plan.attractionDayIndices.map((dayIndex) => {
      const ai = aiAssignments.find((a) => a.day_index === dayIndex);
      const fallback = det.assignments.find((a) => a.day_index === dayIndex);
      const ids = (ai?.attraction_ids?.length
        ? ai.attraction_ids
        : fallback?.attraction_ids) ?? [];
      return { day_index: dayIndex, attraction_ids: ids };
    });
  }

  if (params.aiPlan?.experience_days?.length) {
    const byDay = new Map(experienceDays.map((e) => [e.day_index, e]));
    for (const aiExp of params.aiPlan.experience_days) {
      if (aiExp.day_index >= 1 && aiExp.day_index <= params.tripDays) {
        byDay.set(aiExp.day_index, aiExp);
      }
    }
    experienceDays = [...byDay.values()];
  }

  const normalized = normalizeItineraryPlan({
    cityIds,
    tripDays: params.tripDays,
    catalog,
    plan,
    assignments,
    experienceDays,
    visitOrderHint,
    citiesMeta: params.citiesMeta,
    startDate: parsedStartDate,
  });

  return assembleItinerary({
    cities: normalized.visitOrder,
    tripDays: params.tripDays,
    catalog,
    plan,
    assignments: normalized.assignments,
    experienceDays: normalized.experienceDays,
    visitOrder: normalized.visitOrder,
    userNotes: params.userNotes,
    title,
    estimatedBudget,
    startDate: parsedStartDate,
  });
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
