/** DB-backed itinerary assembly for ai-complete. */

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
};

export type AIAssignment = {
  day_index: number;
  attraction_ids: string[];
};

export type AIExperienceDay = {
  day_index: number;
  city_id: string;
  items: string[];
};

export type AIPlanResponse = {
  assignments?: AIAssignment[];
  experience_days?: AIExperienceDay[];
  title?: string;
  estimated_budget?: string;
};

export type DayPlan = {
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
    "id,city_id,name,summary,cover_image_path,recommended_duration,ticket_price,audio_guide_count,display_order,priority";
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
  }));
}

export function buildDayPlan(tripDays: number, catalog: AttractionRow[]): DayPlan {
  const days = Math.max(1, Math.min(tripDays, 21));
  const attractionCount = catalog.length;
  const attractionDayCount = attractionCount === 0
    ? 0
    : Math.min(days, attractionCount);

  const attractionDayIndices: number[] = [];
  for (let i = 1; i <= attractionDayCount; i++) {
    attractionDayIndices.push(i);
  }

  const experienceDaySpecs: { day_index: number; city_id: string }[] = [];
  for (let i = attractionDayCount + 1; i <= days; i++) {
    experienceDaySpecs.push({ day_index: i, city_id: "" });
  }

  const maxPerDay = attractionCount >= days
    ? Math.min(3, Math.max(1, Math.ceil(attractionCount / days)))
    : attractionCount > 0 && attractionDayCount > 0
    ? Math.min(3, Math.max(1, Math.ceil(attractionCount / attractionDayCount)))
    : 1;

  return { attractionDayIndices, experienceDaySpecs, maxPerDay };
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

function cityDisplayName(cityId: string): string {
  return cityId.charAt(0).toUpperCase() + cityId.slice(1).replace(/_/g, " ");
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

function buildActivity(row: AttractionRow, dayIndex: number, actIndex: number): ItineraryActivity {
  return {
    id: `a_${dayIndex}_${actIndex}_${row.id}`,
    time_slot: "",
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

export function deterministicAssignments(
  plan: DayPlan,
  catalog: AttractionRow[],
): AIAssignment[] {
  const sorted = [...catalog].sort((a, b) => {
    if (a.display_order !== b.display_order) {
      return a.display_order - b.display_order;
    }
    return a.name.localeCompare(b.name);
  });

  const assignments: AIAssignment[] = plan.attractionDayIndices.map((dayIndex) => ({
    day_index: dayIndex,
    attraction_ids: [],
  }));

  let cursor = 0;
  for (const assignment of assignments) {
    while (
      cursor < sorted.length &&
      assignment.attraction_ids.length < plan.maxPerDay
    ) {
      assignment.attraction_ids.push(sorted[cursor].id);
      cursor++;
    }
  }

  // Spread leftovers across attraction days if we have more days than one-per-day
  let dayPtr = 0;
  while (cursor < sorted.length && assignments.length > 0) {
    const day = assignments[dayPtr % assignments.length];
    if (day.attraction_ids.length < plan.maxPerDay) {
      day.attraction_ids.push(sorted[cursor].id);
      cursor++;
    }
    dayPtr++;
    if (dayPtr > assignments.length * plan.maxPerDay * 2) break;
  }

  return assignments;
}

export function assembleItinerary(params: {
  cities: string[];
  tripDays: number;
  catalog: AttractionRow[];
  plan: DayPlan;
  assignments: AIAssignment[];
  experienceDays: AIExperienceDay[];
  userNotes?: string;
  title?: string;
  estimatedBudget?: string;
}): SampleItinerary {
  const {
    cities,
    tripDays,
    catalog,
    plan,
    assignments,
    experienceDays,
    userNotes,
    title,
    estimatedBudget,
  } = params;

  const catalogById = new Map(catalog.map((a) => [a.id, a]));
  const cityLabel = cities.length
    ? cities.map((c) => cityDisplayName(c)).join(" → ")
    : "China";

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
    const isExperience = !plan.attractionDayIndices.includes(dayIndex);
    const exp = experienceByDay.get(dayIndex);

    if (isExperience) {
      const cityId = exp?.city_id ||
        plan.experienceDaySpecs.find((s) => s.day_index === dayIndex)?.city_id ||
        cities[(dayIndex - 1) % Math.max(cities.length, 1)] ||
        "beijing";
      const items = (exp?.items?.length ? exp.items : templateExperienceItems(cityId))
        .map((s) => String(s).trim())
        .filter(Boolean)
        .slice(0, 8);

      days.push({
        id: `day_${dayIndex}`,
        day_index: dayIndex,
        date_label: `Day ${dayIndex}`,
        city_name: "",
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
      if (row) activities.push(buildActivity(row, dayIndex, actIndex));
    });

    const primaryCityId = activities[0]?.city_id ??
      cities[(dayIndex - 1) % Math.max(cities.length, 1)] ??
      "beijing";

    days.push({
      id: `day_${dayIndex}`,
      day_index: dayIndex,
      date_label: `Day ${dayIndex}`,
      city_name: "",
      cost_estimate: null,
      activities,
      experience_city_id: activities.length === 0 ? primaryCityId : undefined,
    });
  }

  return {
    id: `itin_${Date.now()}`,
    title: title?.trim() ||
      `${tripDays}-Day ${cityLabel} Trip`,
    meta: userNotes ? `Generated · ${userNotes.slice(0, 120)}` : "Generated",
    route_summary: cityLabel,
    estimated_budget: estimatedBudget?.trim() || "$800–$1,500",
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
      return {
        day_index: Number(row.day_index) || 0,
        city_id: String(row.city_id ?? "").trim(),
        items,
      };
    }).filter((e) => e.day_index > 0)
    : [];

  return {
    assignments,
    experience_days,
    title: o.title != null ? String(o.title) : undefined,
    estimated_budget: o.estimated_budget != null
      ? String(o.estimated_budget)
      : undefined,
  };
}

export const AI_PLAN_JSON_SCHEMA = `{
  "assignments": [
    { "day_index": 1, "attraction_ids": ["attraction_id_from_catalog"] }
  ],
  "experience_days": [
    { "day_index": 8, "city_id": "beijing", "items": ["Street food tasting", "Traditional tea ceremony"] }
  ],
  "title": "optional string",
  "estimated_budget": "optional string"
}`;
