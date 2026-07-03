import {
  commuteSlots,
  inferVisitOrder,
  buildTravelDayContent,
  travelExperienceItems,
  travelHours,
  type CityMetaRow,
} from "./city-travel-hints.ts";
import {
  calibrateCityDays,
  metaMap,
  regionMap,
} from "./itinerary-city-days.ts";
import { pickAttractionsBySlotBudget } from "./itinerary-pick-attractions.ts";
import {
  daySlotCapacity,
  parseDurationSlots,
} from "./itinerary-duration.ts";
import { isAfternoonArrival, isMorningDeparture } from "./itinerary-flight-times.ts";
import {
  daySlotCapacityForPace,
  defaultPace,
  parsePace,
  type DayScheduleProfile,
  type TripPace,
} from "./itinerary-pace.ts";
import { isClosedOnDate, isEveningOnlyAttraction } from "./itinerary-visit-hours.ts";
import { applyGeographicRepairs } from "./itinerary-geo-repair.ts";
import type {
  AIAssignment,
  AIExperienceDay,
  AIPlanResponse,
  AttractionRow,
} from "./itinerary-assembler.ts";

export type DayPlanDraft = {
  day_index: number;
  city_id: string;
  attraction_ids: string[];
};

export type SchedulerPipelineResult = {
  assignments: AIAssignment[];
  experienceDays: AIExperienceDay[];
  visitOrder: string[];
  droppedAttractionIds: string[];
  adjustments: string[];
  timeHintsByAttractionId: Map<string, "morning" | "afternoon" | "evening">;
};

type TimelineSlot = {
  day_index: number;
  kind: "travel" | "sightseeing";
  city_id: string;
  day_capacity: number;
  evening_capacity: number;
  from_city_id?: string;
};

function priorityRank(p: string | null | undefined): number {
  const v = String(p ?? "P1").toUpperCase();
  if (v === "P0") return 0;
  if (v === "P2") return 2;
  return 1;
}

function buildTimeline(params: {
  tripDays: number;
  visitOrder: string[];
  cityDays: Map<string, number>;
  regionByCity: Map<string, string | null>;
}): TimelineSlot[] {
  const { tripDays, visitOrder, cityDays, regionByCity } = params;
  const slots: TimelineSlot[] = [];
  let dayPtr = 1;

  for (let i = 0; i < visitOrder.length; i++) {
    const cityId = visitOrder[i].toLowerCase();
    if (i > 0) {
      const prev = visitOrder[i - 1].toLowerCase();
      const h = travelHours(prev, cityId, regionByCity);
      if (commuteSlots(h) >= 2 && dayPtr <= tripDays) {
        slots.push({
          day_index: dayPtr,
          kind: "travel",
          city_id: cityId,
          day_capacity: 0,
          evening_capacity: 1,
          from_city_id: prev,
        });
        dayPtr++;
      }
    }

    const budget = cityDays.get(cityId) ?? 1;
    for (let b = 0; b < budget && dayPtr <= tripDays; b++) {
      let capacity = daySlotCapacity("full_day");
      if (i > 0) {
        const prev = visitOrder[i - 1].toLowerCase();
        const h = travelHours(prev, cityId, regionByCity);
        if (commuteSlots(h) === 1 && b === 0) {
          capacity = 1;
        }
      }
      slots.push({
        day_index: dayPtr,
        kind: "sightseeing",
        city_id: cityId,
        day_capacity: capacity,
        evening_capacity: 1,
      });
      dayPtr++;
    }
  }

  while (dayPtr <= tripDays) {
    const cityId = visitOrder[(dayPtr - 1) % visitOrder.length]?.toLowerCase() ?? "beijing";
    slots.push({
      day_index: dayPtr,
      kind: "sightseeing",
      city_id: cityId,
      day_capacity: daySlotCapacity("full_day"),
      evening_capacity: 1,
    });
    dayPtr++;
  }

  return slots.slice(0, tripDays);
}

function applyFlightAndPaceProfiles(
  slots: TimelineSlot[],
  params: {
    tripDays: number;
    pace: TripPace;
    arrivalTime?: string | null;
    departureTime?: string | null;
  },
): TimelineSlot[] {
  const { tripDays, pace, arrivalTime, departureTime } = params;
  const sightseeing = slots.filter((s) => s.kind === "sightseeing");
  const firstSight = sightseeing[0]?.day_index;
  const lastSight = sightseeing[sightseeing.length - 1]?.day_index;

  return slots.map((slot) => {
    if (slot.kind === "travel") return slot;

    let profile: DayScheduleProfile = "full_day";
    if (slot.day_index === firstSight) profile = "arrival_day";
    if (slot.day_index === lastSight && tripDays > 1) profile = "departure_day";

    let dayCapacity = Math.min(
      slot.day_capacity,
      daySlotCapacityForPace(profile, pace),
    );
    let eveningCapacity = slot.evening_capacity;

    if (slot.day_index === firstSight && isAfternoonArrival(arrivalTime)) {
      dayCapacity = 0;
      eveningCapacity = Math.max(eveningCapacity, 1);
    }
    if (slot.day_index === lastSight && isMorningDeparture(departureTime)) {
      dayCapacity = Math.min(dayCapacity, daySlotCapacityForPace("departure_day", pace));
    }

    return {
      ...slot,
      day_capacity: dayCapacity,
      evening_capacity: eveningCapacity,
    };
  });
}

function partitionAttractionIds(
  ids: string[],
  catalogById: Map<string, AttractionRow>,
): { daytime: string[]; evening: string[] } {
  const daytime: string[] = [];
  const evening: string[] = [];
  for (const id of ids) {
    const row = catalogById.get(id);
    if (!row) continue;
    if (isEveningOnlyAttraction(row)) evening.push(id);
    else daytime.push(id);
  }
  return { daytime, evening };
}

export function buildRuleDayPlans(params: {
  timeline: TimelineSlot[];
  candidatesByCity: Map<string, string[]>;
  catalogById: Map<string, AttractionRow>;
}): DayPlanDraft[] {
  const { timeline, candidatesByCity, catalogById } = params;
  const plans: DayPlanDraft[] = [];
  const pools = new Map<string, string[]>();

  for (const [city, ids] of candidatesByCity) {
    pools.set(city, [...ids]);
  }

  for (const slot of timeline) {
    const city = slot.city_id.toLowerCase();
    let pool = [...(pools.get(city) ?? [])];
    const daytimeIds: string[] = [];
    const eveningIds: string[] = [];

    if (slot.day_capacity > 0) {
      let used = 0;
      let i = 0;
      while (i < pool.length && used < slot.day_capacity) {
        const id = pool[i];
        const row = catalogById.get(id);
        if (row && isEveningOnlyAttraction(row)) {
          i++;
          continue;
        }
        const dur = row ? parseDurationSlots(row.recommended_duration) : 1;
        if (used + dur <= slot.day_capacity || daytimeIds.length === 0) {
          daytimeIds.push(id);
          used += dur;
          pool.splice(i, 1);
        } else {
          i++;
        }
      }
    }

    if (slot.evening_capacity > 0) {
      const eveIdx = pool.findIndex((id) => {
        const row = catalogById.get(id);
        return row != null && isEveningOnlyAttraction(row);
      });
      if (eveIdx >= 0) {
        eveningIds.push(pool[eveIdx]);
        pool.splice(eveIdx, 1);
      }
    }

    pools.set(city, pool);
    plans.push({
      day_index: slot.day_index,
      city_id: city,
      attraction_ids: [...daytimeIds, ...eveningIds],
    });
  }

  return plans;
}

function filterDayPlansToCandidates(
  dayPlans: DayPlanDraft[],
  candidatesByCity: Map<string, string[]>,
  adjustments: string[],
): DayPlanDraft[] {
  const allowed = new Map<string, Set<string>>();
  for (const [city, ids] of candidatesByCity) {
    allowed.set(city, new Set(ids));
  }

  return dayPlans.map((plan) => {
    const city = plan.city_id.toLowerCase();
    const set = allowed.get(city) ?? new Set();
    const kept: string[] = [];
    for (const id of plan.attraction_ids) {
      if (set.has(id)) kept.push(id);
      else adjustments.push(`Removed ${id} (not in city candidate set)`);
    }
    return { ...plan, attraction_ids: kept };
  });
}

function parseAIDayPlans(
  aiPlan: AIPlanResponse | null,
  catalogById: Map<string, AttractionRow>,
): DayPlanDraft[] {
  const fromTyped = aiPlan?.day_plans;
  if (fromTyped?.length) {
    return fromTyped.map((p) => ({
      day_index: p.day_index,
      city_id: p.city_id.toLowerCase(),
      attraction_ids: p.attraction_ids,
    }));
  }
  const raw = (aiPlan as Record<string, unknown> | null)?.day_plans;
  if (Array.isArray(raw)) {
    const plans: DayPlanDraft[] = [];
    for (const item of raw) {
      const row = item as Record<string, unknown>;
      const dayIndex = Number(row.day_index) || 0;
      const cityId = String(row.city_id ?? "").toLowerCase();
      const ids = Array.isArray(row.attraction_ids)
        ? row.attraction_ids.map((id) => String(id).trim()).filter(Boolean)
        : [];
      if (dayIndex >= 1 && cityId) {
        plans.push({ day_index: dayIndex, city_id: cityId, attraction_ids: ids });
      }
    }
    if (plans.length) return plans;
  }

  const legacy = aiPlan?.assignments ?? [];
  if (legacy.length) {
    return legacy
      .filter((a) => a.day_index >= 1)
      .map((a) => {
        const ids = a.attraction_ids ?? [];
        const firstCity = ids.map((id) => catalogById.get(id)?.city_id).find(Boolean);
        return {
          day_index: a.day_index,
          city_id: (firstCity ?? "beijing").toLowerCase(),
          attraction_ids: ids,
        };
      });
  }

  return [];
}

function collectTimeHints(
  aiPlan: AIPlanResponse | null,
): Map<string, "morning" | "afternoon" | "evening"> {
  const hints = new Map<string, "morning" | "afternoon" | "evening">();
  for (const plan of aiPlan?.day_plans ?? []) {
    const raw = plan.time_hints;
    if (!raw || typeof raw !== "object") continue;
    for (const [id, value] of Object.entries(raw)) {
      const v = String(value).trim().toLowerCase();
      if (v === "morning" || v === "afternoon" || v === "evening") {
        hints.set(id, v);
      }
    }
  }
  return hints;
}

function parseAICityWeights(aiPlan: AIPlanResponse | null): Record<string, number> | undefined {
  const weights = aiPlan?.city_day_weights ?? aiPlan?.city_plan?.city_day_weights ??
    (aiPlan as Record<string, unknown> | null)?.city_day_weights;
  if (!weights || typeof weights !== "object") return undefined;
  const out: Record<string, number> = {};
  for (const [k, v] of Object.entries(weights)) {
    const n = Number(v);
    if (Number.isFinite(n)) out[k.toLowerCase()] = n;
  }
  return Object.keys(out).length ? out : undefined;
}

function parseAIMustSee(aiPlan: AIPlanResponse | null): Set<string> {
  const raw = aiPlan?.must_see_ids ?? aiPlan?.city_plan?.must_see_ids ??
    (aiPlan as Record<string, unknown> | null)?.must_see_ids;
  if (!Array.isArray(raw)) return new Set();
  return new Set(raw.map((id) => String(id).trim()).filter(Boolean));
}

export function validateAndRepair(params: {
  tripDays: number;
  dayPlans: DayPlanDraft[];
  timeline: TimelineSlot[];
  catalogById: Map<string, AttractionRow>;
  startDate: Date | null;
}): {
  assignments: AIAssignment[];
  dropped: string[];
  adjustments: string[];
} {
  const { tripDays, dayPlans, timeline, catalogById, startDate } = params;
  const adjustments: string[] = [];
  const dropped: string[] = [];
  const planByDay = new Map(dayPlans.map((p) => [p.day_index, p]));
  const capacityByDay = new Map(timeline.map((t) => [t.day_index, t.day_capacity]));
  const eveningCapByDay = new Map(timeline.map((t) => [t.day_index, t.evening_capacity]));
  const assignments: AIAssignment[] = [];
  const overflow: { id: string; priority: number }[] = [];

  for (let day = 1; day <= tripDays; day++) {
    const plan = planByDay.get(day);
    const capacity = capacityByDay.get(day) ?? daySlotCapacity("full_day");
    const eveningCap = eveningCapByDay.get(day) ?? 0;
    const date = startDate
      ? new Date(startDate.getTime() + (day - 1) * 86400000)
      : null;

    const { daytime, evening } = partitionAttractionIds(plan?.attraction_ids ?? [], catalogById);
    let used = 0;
    const keptDaytime: string[] = [];
    const keptEvening: string[] = [];

    for (const id of daytime) {
      const row = catalogById.get(id);
      if (!row) continue;
      const dur = parseDurationSlots(row.recommended_duration);
      if (date && isClosedOnDate(row, date)) {
        overflow.push({ id, priority: priorityRank(row.priority) });
        adjustments.push(`Moved ${id} (closed on day ${day})`);
        continue;
      }
      if (used + dur > capacity) {
        overflow.push({ id, priority: priorityRank(row.priority) });
        adjustments.push(`Moved ${id} (exceeds day ${day} slot budget)`);
        continue;
      }
      keptDaytime.push(id);
      used += dur;
    }

    for (const id of evening) {
      const row = catalogById.get(id);
      if (!row) continue;
      if (!isEveningOnlyAttraction(row)) {
        overflow.push({ id, priority: priorityRank(row.priority) });
        adjustments.push(`Moved ${id} (not an evening-only sight)`);
        continue;
      }
      if (keptEvening.length >= eveningCap) {
        overflow.push({ id, priority: priorityRank(row.priority) });
        adjustments.push(`Moved ${id} (evening slot full on day ${day})`);
        continue;
      }
      keptEvening.push(id);
    }

    assignments.push({ day_index: day, attraction_ids: [...keptDaytime, ...keptEvening] });
  }

  overflow.sort((a, b) => a.priority - b.priority);

  for (const item of overflow) {
    let placed = false;
    const row = catalogById.get(item.id);
    if (!row) continue;

    if (isEveningOnlyAttraction(row)) {
      for (const assignment of assignments) {
        const eveCap = eveningCapByDay.get(assignment.day_index) ?? 0;
        if (eveCap < 1) continue;
        const eveningCount = assignment.attraction_ids.filter((id) => {
          const r = catalogById.get(id);
          return r != null && isEveningOnlyAttraction(r);
        }).length;
        if (eveningCount >= eveCap) continue;
        assignment.attraction_ids.push(item.id);
        placed = true;
        adjustments.push(`Placed ${item.id} on day ${assignment.day_index} (evening)`);
        break;
      }
    } else {
      for (const assignment of assignments) {
        const cap = capacityByDay.get(assignment.day_index) ?? daySlotCapacity("full_day");
        const date = startDate
          ? new Date(startDate.getTime() + (assignment.day_index - 1) * 86400000)
          : null;
        if (date && isClosedOnDate(row, date)) continue;
        const dur = parseDurationSlots(row.recommended_duration);
        let used = 0;
        for (const id of assignment.attraction_ids) {
          const r = catalogById.get(id);
          if (r && isEveningOnlyAttraction(r)) continue;
          used += r ? parseDurationSlots(r.recommended_duration) : 1;
        }
        if (used + dur <= cap) {
          assignment.attraction_ids.push(item.id);
          placed = true;
          adjustments.push(`Placed ${item.id} on day ${assignment.day_index}`);
          break;
        }
      }
    }
    if (!placed) dropped.push(item.id);
  }

  return { assignments, dropped, adjustments };
}

export function runItinerarySchedulerPipeline(params: {
  cityIds: string[];
  tripDays: number;
  catalog: AttractionRow[];
  citiesMeta: CityMetaRow[];
  aiPlan: AIPlanResponse | null;
  entryCityId?: string | null;
  exitCityId?: string | null;
  startDate?: Date | null;
  pace?: TripPace | string | null;
  arrivalTime?: string | null;
  departureTime?: string | null;
}): SchedulerPipelineResult {
  const {
    cityIds,
    tripDays,
    catalog,
    citiesMeta,
    aiPlan,
    startDate = null,
  } = params;

  const pace = parsePace(params.pace ?? defaultPace(tripDays, cityIds.length));

  const metaByCity = metaMap(citiesMeta);
  const regionByCity = regionMap(citiesMeta);
  const catalogById = new Map(catalog.map((a) => [a.id, a]));
  const catalogCounts = new Map<string, number>();
  for (const row of catalog) {
    const c = row.city_id.toLowerCase();
    catalogCounts.set(c, (catalogCounts.get(c) ?? 0) + 1);
  }

  const visitOrder = aiPlan?.visit_order?.length
    ? aiPlan.visit_order.map((c) => c.toLowerCase())
    : inferVisitOrder(cityIds, catalogCounts, metaByCity, {
      entryCityId: params.entryCityId,
      exitCityId: params.exitCityId,
    });

  const cityDays = calibrateCityDays(
    visitOrder,
    parseAICityWeights(aiPlan),
    catalog,
    citiesMeta,
    tripDays,
    regionByCity,
  );

  const { candidatesByCity, preDropped } = pickAttractionsBySlotBudget({
    catalog,
    cityDays,
    mustSeeIds: parseAIMustSee(aiPlan),
    pace,
  });

  let timeline = buildTimeline({
    tripDays,
    visitOrder,
    cityDays,
    regionByCity,
  });
  timeline = applyFlightAndPaceProfiles(timeline, {
    tripDays,
    pace,
    arrivalTime: params.arrivalTime,
    departureTime: params.departureTime,
  });

  const adjustments: string[] = [];
  let dayPlans = parseAIDayPlans(aiPlan, catalogById);
  if (dayPlans.length === 0) {
    dayPlans = buildRuleDayPlans({ timeline, candidatesByCity, catalogById });
  } else {
    dayPlans = filterDayPlansToCandidates(dayPlans, candidatesByCity, adjustments);
  }

  let { assignments, dropped, adjustments: repairAdj } = validateAndRepair({
    tripDays,
    dayPlans,
    timeline,
    catalogById,
    startDate,
  });

  const geoAdj: string[] = [];
  const geo = applyGeographicRepairs({
    assignments,
    catalogById,
    regionByCity,
    adjustments: geoAdj,
  });
  assignments = geo.assignments;
  dropped.push(...geo.dropped);
  adjustments.push(...geoAdj);

  const experienceDays: AIExperienceDay[] = [];
  if (aiPlan?.experience_days?.length) {
    for (const exp of aiPlan.experience_days) {
      if (exp.day_index >= 1 && exp.day_index <= tripDays) {
        experienceDays.push(exp);
      }
    }
  } else {
    for (const slot of timeline) {
      if (slot.kind === "travel") {
        const from = slot.from_city_id ?? "";
        const hours = from
          ? travelHours(from, slot.city_id, regionByCity)
          : 6;
        experienceDays.push({
          day_index: slot.day_index,
          city_id: slot.city_id,
          items: from
            ? buildTravelDayContent(from, slot.city_id, hours)
            : travelExperienceItems(slot.city_id),
          kind: "travel",
        });
      }
    }
  }

  const expByDay = new Map(experienceDays.map((e) => [e.day_index, e]));
  for (const assignment of assignments) {
    const exp = expByDay.get(assignment.day_index);
    if (exp?.kind === "travel") {
      assignment.attraction_ids = assignment.attraction_ids.filter((id) => {
        const row = catalogById.get(id);
        return row != null && isEveningOnlyAttraction(row);
      });
    }
  }

  return {
    assignments,
    experienceDays,
    visitOrder,
    droppedAttractionIds: [...preDropped, ...dropped],
    adjustments: [...adjustments, ...repairAdj],
    timeHintsByAttractionId: collectTimeHints(aiPlan),
  };
}
