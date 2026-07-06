import {
  commuteSlots,
  inferVisitOrder,
  buildTravelDayContent,
  buildHopCardContent,
  canIntenseSameDayHop,
  isIntercityHopKind,
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
import { destinationWindows, hopDaySightBudget, isAfternoonArrival, isMorningDeparture } from "./itinerary-flight-times.ts";
import {
  daySlotCapacityForPace,
  defaultPace,
  hopDaySlotCapacity,
  parsePace,
  type DayScheduleProfile,
  type TripPace,
} from "./itinerary-pace.ts";
import { isClosedOnDate, isEveningOnlyAttraction } from "./itinerary-visit-hours.ts";
import { applyGeographicRepairs, allowedCitiesFromTimeline } from "./itinerary-geo-repair.ts";
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
  hop_from_city_id?: string;
};

export type IntercityHopDay = {
  day_index: number;
  from_city_id: string;
  to_city_id: string;
  travel_hours: number;
  items: string[];
};

export type SchedulerPipelineResult = {
  assignments: AIAssignment[];
  experienceDays: AIExperienceDay[];
  hopDays: IntercityHopDay[];
  visitOrder: string[];
  droppedAttractionIds: string[];
  adjustments: string[];
  timeHintsByAttractionId: Map<string, "morning" | "afternoon" | "evening">;
  cityIdByDayIndex: Record<number, string>;
};

type TimelineSlot = {
  day_index: number;
  kind: "travel" | "sightseeing" | "hop" | "travel_lite" | "short_hop";
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
  pace: TripPace;
}): TimelineSlot[] {
  const { tripDays, visitOrder, cityDays, regionByCity, pace } = params;
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
      if (i > 0 && b === 0 && pace === "intense" &&
        canIntenseSameDayHop(visitOrder[i - 1], cityId, regionByCity)) {
        slots.push({
          day_index: dayPtr,
          kind: "hop",
          city_id: cityId,
          day_capacity: hopDaySlotCapacity,
          evening_capacity: 1,
          from_city_id: visitOrder[i - 1].toLowerCase(),
        });
        dayPtr++;
        continue;
      }
      if (i > 0 && b === 0 && pace !== "intense") {
        const prev = visitOrder[i - 1].toLowerCase();
        const h = travelHours(prev, cityId, regionByCity);
        if (commuteSlots(h) === 1) {
          slots.push({
            day_index: dayPtr,
            kind: "travel_lite",
            city_id: cityId,
            day_capacity: 1,
            evening_capacity: 1,
            from_city_id: prev,
          });
          dayPtr++;
          continue;
        }
        if (commuteSlots(h) === 0) {
          slots.push({
            day_index: dayPtr,
            kind: "short_hop",
            city_id: cityId,
            day_capacity: daySlotCapacity("full_day"),
            evening_capacity: 1,
            from_city_id: prev,
          });
          dayPtr++;
          continue;
        }
      }
      const capacity = daySlotCapacity("full_day");
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

  return slots.slice(0, tripDays);
}

function sightseeingDaysPerCity(timeline: TimelineSlot[]): Map<string, number> {
  const counts = new Map<string, number>();
  for (const slot of timeline) {
    if (slot.day_capacity <= 0 && slot.evening_capacity <= 0) continue;
    if (slot.kind !== "sightseeing" && !isIntercityHopKind(slot.kind)) continue;
    const cid = slot.city_id.toLowerCase();
    counts.set(cid, (counts.get(cid) ?? 0) + 1);
  }
  return counts;
}

function applyFlightAndPaceProfiles(
  slots: TimelineSlot[],
  params: {
    tripDays: number;
    visitOrder: string[];
    pace: TripPace;
    arrivalTime?: string | null;
    departureTime?: string | null;
    activityDaysExcludeCalendarEndpoints?: boolean;
    regionByCity: Map<string, string | null>;
  },
): TimelineSlot[] {
  const {
    tripDays,
    visitOrder,
    pace,
    arrivalTime,
    departureTime,
    activityDaysExcludeCalendarEndpoints = true,
    regionByCity,
  } = params;
  const activeSlots = slots.filter((s) => s.kind !== "travel");
  const firstActive = activeSlots[0]?.day_index;
  const lastActive = activeSlots[activeSlots.length - 1]?.day_index;
  const sightseeing = slots.filter((s) => s.kind === "sightseeing");
  const firstSight = sightseeing[0]?.day_index;
  const lastSight = sightseeing[sightseeing.length - 1]?.day_index;
  const entryCity = visitOrder[0]?.toLowerCase();
  const firstEntrySight = sightseeing.find((s) => s.city_id.toLowerCase() === entryCity)?.day_index;

  return slots.map((slot) => {
    const isSightseeing = slot.kind === "sightseeing";
    const isHopLike = isIntercityHopKind(slot.kind);
    if (!isSightseeing && !isHopLike) return slot;

    const anchorFirst = isHopLike ? firstActive : firstSight;
    const anchorLast = isHopLike ? lastActive : lastSight;

    let profile: DayScheduleProfile = "full_day";
    if (!activityDaysExcludeCalendarEndpoints && slot.day_index === anchorFirst) {
      profile = "arrival_day";
    }
    if (slot.day_index === anchorLast && tripDays > 1) {
      if (!activityDaysExcludeCalendarEndpoints || isMorningDeparture(departureTime)) {
        profile = "departure_day";
      }
    }

    let dayCapacity = Math.min(
      slot.day_capacity,
      daySlotCapacityForPace(profile, pace),
    );
    let eveningCapacity = slot.evening_capacity;

    if (
      !activityDaysExcludeCalendarEndpoints &&
      slot.day_index === anchorFirst &&
      isAfternoonArrival(arrivalTime)
    ) {
      if (isSightseeing) {
        dayCapacity = 0;
        eveningCapacity = Math.max(eveningCapacity, 1);
      }
    }
    if (
      activityDaysExcludeCalendarEndpoints &&
      slot.day_index === firstEntrySight &&
      isAfternoonArrival(arrivalTime) &&
      isSightseeing
    ) {
      dayCapacity = 0;
      eveningCapacity = Math.max(eveningCapacity, 1);
    }
    if (slot.day_index === anchorLast && isMorningDeparture(departureTime)) {
      dayCapacity = Math.min(dayCapacity, daySlotCapacityForPace("departure_day", pace));
    }

    if (isHopLike && slot.from_city_id) {
      const hours = travelHours(slot.from_city_id, slot.city_id, regionByCity);
      const hopBudget = hopDaySightBudget({
        hopKind: slot.kind,
        pace,
        arrivalAtDestination: null,
        travelHours: hours,
        slotDayCapacity: dayCapacity,
      });
      dayCapacity = Math.min(dayCapacity, hopBudget.destDaytimeCap + hopBudget.commuteCost);
      eveningCapacity = Math.max(eveningCapacity, hopBudget.eveningCap);
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
  pace?: TripPace;
  regionByCity?: Map<string, string | null>;
  hopReservedByDayIndex?: Map<number, string>;
}): DayPlanDraft[] {
  const { timeline, candidatesByCity, catalogById } = params;
  const pace = params.pace ?? "standard";
  const regionByCity = params.regionByCity ?? new Map<string, string | null>();
  const hopReservedByDayIndex = params.hopReservedByDayIndex ?? new Map<number, string>();
  const plans: DayPlanDraft[] = [];
  const pools = new Map<string, string[]>();

  for (const [city, ids] of candidatesByCity) {
    pools.set(city, [...ids]);
  }

  for (const slot of timeline) {
    if (isIntercityHopKind(slot.kind) && slot.from_city_id) {
      const fromCity = slot.from_city_id.toLowerCase();
      const toCity = slot.city_id.toLowerCase();
      let fromPool = [...(pools.get(fromCity) ?? [])];
      let toPool = [...(pools.get(toCity) ?? [])];
      const hours = travelHours(fromCity, toCity, regionByCity);
      const hopBudget = hopDaySightBudget({
        hopKind: slot.kind,
        pace,
        arrivalAtDestination: null,
        travelHours: hours,
        slotDayCapacity: slot.day_capacity,
      });
      const amIds: string[] = [];
      const pmIds: string[] = [];
      const eveningIds: string[] = [];

      if (hopBudget.allowsMorningOrigin) {
        const amIdx = fromPool.findIndex((id) => {
          const row = catalogById.get(id);
          return row != null && !isEveningOnlyAttraction(row) &&
            parseDurationSlots(row.recommended_duration) <= 1;
        });
        if (amIdx >= 0) {
          amIds.push(fromPool.splice(amIdx, 1)[0]);
        } else if (amIds.length === 0 && slot.kind !== "short_hop") {
          for (let d = slot.day_index - 1; d >= 1; d--) {
            const prev = plans.find((p) => p.day_index === d && p.city_id === fromCity);
            if (!prev?.attraction_ids.length) continue;
            const stealIdx = prev.attraction_ids.findIndex((id) => {
              const row = catalogById.get(id);
              return row != null && !isEveningOnlyAttraction(row) &&
                parseDurationSlots(row.recommended_duration) <= 1;
            });
            if (stealIdx < 0) continue;
            const remainingDaytime = prev.attraction_ids.filter((id, idx) => {
              if (idx === stealIdx) return false;
              const row = catalogById.get(id);
              return row != null && !isEveningOnlyAttraction(row);
            });
            if (remainingDaytime.length === 0) continue;
            amIds.push(prev.attraction_ids.splice(stealIdx, 1)[0]);
            break;
          }
        }
      }

      const destDayCap = hopBudget.destDaytimeCap;
      const sightBudget = Math.max(
        0,
        Math.min(
          slot.day_capacity - (hopBudget.allowsMorningOrigin ? hopBudget.commuteCost : 0),
          destDayCap,
        ),
      );
      let used = 0;
      const reserved = hopReservedByDayIndex.get(slot.day_index);
      if (reserved && toPool.includes(reserved) && !isEveningOnlyAttraction(catalogById.get(reserved)!)) {
        pmIds.push(reserved);
        used += parseDurationSlots(catalogById.get(reserved)?.recommended_duration);
        toPool = toPool.filter((id) => id !== reserved);
      }
      for (const id of amIds) {
        const row = catalogById.get(id);
        used += row ? parseDurationSlots(row.recommended_duration) : 1;
      }
      let i = 0;
      while (i < toPool.length && used < sightBudget) {
        const id = toPool[i];
        const row = catalogById.get(id);
        if (row && isEveningOnlyAttraction(row)) {
          i++;
          continue;
        }
        const dur = row ? parseDurationSlots(row.recommended_duration) : 1;
        if (used + dur <= sightBudget || pmIds.length === 0) {
          pmIds.push(id);
          used += dur;
          toPool.splice(i, 1);
        } else {
          i++;
        }
      }

      if (hopBudget.eveningCap > 0) {
        const eveIdx = toPool.findIndex((id) => {
          const row = catalogById.get(id);
          return row != null && isEveningOnlyAttraction(row);
        });
        if (eveIdx >= 0) {
          eveningIds.push(toPool.splice(eveIdx, 1)[0]);
        }
      }

      if (pmIds.length === 0 && hopBudget.destDaytimeCap > 0 && toPool.length > 0) {
        const pmIdx = toPool.findIndex((id) => {
          const row = catalogById.get(id);
          return row != null && !isEveningOnlyAttraction(row);
        });
        if (pmIdx >= 0) {
          pmIds.push(toPool.splice(pmIdx, 1)[0]);
        }
      }

      pools.set(fromCity, fromPool);
      pools.set(toCity, toPool);
      plans.push({
        day_index: slot.day_index,
        city_id: toCity,
        attraction_ids: [...amIds, ...pmIds, ...eveningIds],
        hop_from_city_id: fromCity,
      });
      continue;
    }

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

function alignDayPlansToTimeline(
  dayPlans: DayPlanDraft[],
  timeline: TimelineSlot[],
  adjustments: string[],
): DayPlanDraft[] {
  const hopSlots = new Map(
    timeline
      .filter((s) => isIntercityHopKind(s.kind) && s.from_city_id)
      .map((s) => [s.day_index, s]),
  );
  return dayPlans.map((plan) => {
    const slot = hopSlots.get(plan.day_index);
    if (!slot?.from_city_id) return plan;
    const from = slot.from_city_id.toLowerCase();
    if (!plan.hop_from_city_id) {
      adjustments.push(`Inferred hop_from_city_id ${from} for day ${plan.day_index}`);
      return { ...plan, hop_from_city_id: from, city_id: slot.city_id.toLowerCase() };
    }
    if (plan.city_id.toLowerCase() !== slot.city_id.toLowerCase()) {
      adjustments.push(`Aligned day ${plan.day_index} city to timeline destination ${slot.city_id}`);
      return { ...plan, city_id: slot.city_id.toLowerCase() };
    }
    return plan;
  });
}

function filterDayPlansToCandidates(
  dayPlans: DayPlanDraft[],
  timeline: TimelineSlot[],
  candidatesByCity: Map<string, string[]>,
  catalogById: Map<string, AttractionRow>,
  adjustments: string[],
): DayPlanDraft[] {
  const hopSlotByDay = new Map(
    timeline
      .filter((s) => isIntercityHopKind(s.kind) && s.from_city_id)
      .map((s) => [s.day_index, s]),
  );

  return dayPlans.map((plan) => {
    const slot = hopSlotByDay.get(plan.day_index);
    const fromCity = plan.hop_from_city_id?.toLowerCase()
      ?? slot?.from_city_id?.toLowerCase();
    const toCity = plan.city_id.toLowerCase();

    const allowedIds = new Set<string>();
    for (const id of candidatesByCity.get(toCity) ?? []) allowedIds.add(id);
    if (fromCity) {
      for (const id of candidatesByCity.get(fromCity) ?? []) allowedIds.add(id);
    }

    const kept: string[] = [];
    for (const id of plan.attraction_ids) {
      if (allowedIds.has(id)) {
        kept.push(id);
        continue;
      }
      const attrCity = catalogById.get(id)?.city_id?.toLowerCase();
      if (attrCity && (attrCity === toCity || attrCity === fromCity)) {
        const pool = candidatesByCity.get(attrCity) ?? [];
        if (pool.includes(id)) {
          kept.push(id);
          continue;
        }
      }
      adjustments.push(`Removed ${id} (not in city candidate set)`);
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
      hop_from_city_id: p.hop_from_city_id?.toLowerCase(),
    }));
  }
  const raw = (aiPlan as Record<string, unknown> | null)?.day_plans;
  if (Array.isArray(raw)) {
    const plans: DayPlanDraft[] = [];
    for (const item of raw) {
      const row = item as Record<string, unknown>;
      const dayIndex = Number(row.day_index) || 0;
      const cityId = String(row.city_id ?? "").toLowerCase();
      const hopFrom = row.hop_from_city_id != null
        ? String(row.hop_from_city_id).trim().toLowerCase()
        : undefined;
      const ids = Array.isArray(row.attraction_ids)
        ? row.attraction_ids.map((id) => String(id).trim()).filter(Boolean)
        : [];
      if (dayIndex >= 1 && cityId) {
        plans.push({
          day_index: dayIndex,
          city_id: cityId,
          attraction_ids: ids,
          hop_from_city_id: hopFrom,
        });
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

function hopDaysFromPlans(
  dayPlans: DayPlanDraft[],
  pace: TripPace,
  regionByCity: Map<string, string | null>,
): IntercityHopDay[] {
  if (pace !== "intense") return [];
  const hops: IntercityHopDay[] = [];
  for (const plan of dayPlans) {
    const from = plan.hop_from_city_id?.toLowerCase();
    const to = plan.city_id.toLowerCase();
    if (!from || from === to) continue;
    if (!canIntenseSameDayHop(from, to, regionByCity)) continue;
    const hours = travelHours(from, to, regionByCity);
    hops.push({
      day_index: plan.day_index,
      from_city_id: from,
      to_city_id: to,
      travel_hours: hours,
      items: buildHopCardContent(from, to, hours),
    });
  }
  return hops;
}

function mergeAllowedCitiesForHops(
  timeline: TimelineSlot[],
  dayPlans: DayPlanDraft[],
  pace: TripPace,
  regionByCity: Map<string, string | null>,
): Map<number, Set<string>> {
  const allowed = allowedCitiesFromTimeline(timeline);
  if (pace !== "intense") return allowed;
  for (const plan of dayPlans) {
    const from = plan.hop_from_city_id?.toLowerCase();
    const to = plan.city_id.toLowerCase();
    if (!from || from === to) continue;
    if (!canIntenseSameDayHop(from, to, regionByCity)) continue;
    allowed.set(plan.day_index, new Set([from, to]));
  }
  return allowed;
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

function buildTimelineExperienceDays(
  timeline: TimelineSlot[],
  regionByCity: Map<string, string | null>,
): AIExperienceDay[] {
  const days: AIExperienceDay[] = [];
  for (const slot of timeline) {
    if (slot.kind !== "travel") continue;
    const from = slot.from_city_id ?? "";
    const hours = from
      ? travelHours(from, slot.city_id, regionByCity)
      : 6;
    days.push({
      day_index: slot.day_index,
      city_id: slot.city_id,
      from_city_id: from || undefined,
      items: from
        ? buildTravelDayContent(from, slot.city_id, hours)
        : travelExperienceItems(slot.city_id),
      kind: "travel",
    });
  }
  return days;
}

function mergeExperienceDaysWithTimeline(params: {
  timeline: TimelineSlot[];
  regionByCity: Map<string, string | null>;
  aiExperienceDays?: AIExperienceDay[];
  adjustments: string[];
}): AIExperienceDay[] {
  const { timeline, regionByCity, aiExperienceDays, adjustments } = params;
  const reservedHopDays = new Set(
    timeline
      .filter((s) => isIntercityHopKind(s.kind))
      .map((s) => s.day_index),
  );
  const byDay = new Map<number, AIExperienceDay>();
  for (const exp of buildTimelineExperienceDays(timeline, regionByCity)) {
    byDay.set(exp.day_index, exp);
  }
  for (const exp of aiExperienceDays ?? []) {
    if (exp.day_index < 1) continue;
    if (reservedHopDays.has(exp.day_index)) {
      adjustments.push(`Dropped AI experience on day ${exp.day_index} (reserved for intercity hop/travel-lite)`);
      continue;
    }
    const mandatory = byDay.get(exp.day_index);
    if (mandatory?.kind === "travel") {
      adjustments.push(`Dropped AI experience on day ${exp.day_index} (reserved for intercity travel)`);
      continue;
    }
    if (!byDay.has(exp.day_index)) {
      byDay.set(exp.day_index, exp);
    }
  }
  return [...byDay.values()].sort((a, b) => a.day_index - b.day_index);
}

function sightseeingBudgetForDay(
  day: number,
  timeline: TimelineSlot[],
  regionByCity: Map<string, string | null>,
  pace: TripPace,
): { dayCapacity: number; eveningCap: number } {
  const slot = timeline.find((t) => t.day_index === day);
  if (!slot) {
    return { dayCapacity: daySlotCapacity("full_day"), eveningCap: 0 };
  }
  if (isIntercityHopKind(slot.kind) && slot.from_city_id) {
    const hours = travelHours(slot.from_city_id, slot.city_id, regionByCity);
    const hopBudget = hopDaySightBudget({
      hopKind: slot.kind,
      pace,
      arrivalAtDestination: null,
      travelHours: hours,
      slotDayCapacity: slot.day_capacity,
    });
    if (slot.kind === "short_hop") {
      return { dayCapacity: hopBudget.destDaytimeCap, eveningCap: hopBudget.eveningCap };
    }
    if (hopBudget.allowsMorningOrigin) {
      return { dayCapacity: Math.max(0, hopBudget.destDaytimeCap), eveningCap: hopBudget.eveningCap };
    }
    return { dayCapacity: hopBudget.destDaytimeCap, eveningCap: hopBudget.eveningCap };
  }
  return { dayCapacity: slot.day_capacity, eveningCap: slot.evening_capacity };
}

function hopDayBackfillCandidate(
  destCityId: string,
  preDropped: string[],
  catalog: AttractionRow[],
  catalogById: Map<string, AttractionRow>,
  excludeIds: Set<string>,
): string | null {
  for (const id of preDropped) {
    const row = catalogById.get(id);
    if (
      excludeIds.has(id)
      || row?.city_id.toLowerCase() !== destCityId
      || (row && isEveningOnlyAttraction(row))
      || parseDurationSlots(row?.recommended_duration) > 1
    ) continue;
    return id;
  }
  const pool = catalog
    .filter((r) => r.city_id.toLowerCase() === destCityId)
    .sort((a, b) => a.display_order - b.display_order);
  const row = pool.find((r) =>
    !excludeIds.has(r.id)
    && !isEveningOnlyAttraction(r)
    && parseDurationSlots(r.recommended_duration) <= 1
  );
  return row?.id ?? null;
}

function backfillHopDaysAndScanUnassigned(params: {
  assignments: AIAssignment[];
  dropped: string[];
  timeline: TimelineSlot[];
  candidatesByCity: Map<string, string[]>;
  preDropped: string[];
  catalogById: Map<string, AttractionRow>;
  catalog: AttractionRow[];
  pace: TripPace;
  regionByCity: Map<string, string | null>;
}): { assignments: AIAssignment[]; dropped: string[]; adjustments: string[] } {
  const {
    assignments,
    dropped,
    timeline,
    candidatesByCity,
    preDropped,
    catalogById,
    catalog,
    pace,
    regionByCity,
  } = params;
  const adjustments: string[] = [];
  const assignedIds = new Set(assignments.flatMap((a) => a.attraction_ids));

  for (const slot of timeline) {
    if (!isIntercityHopKind(slot.kind) || slot.kind === "travel" || !slot.from_city_id) continue;
    const dest = slot.city_id.toLowerCase();
    const hopBudget = hopDaySightBudget({
      hopKind: slot.kind,
      pace,
      arrivalAtDestination: null,
      travelHours: travelHours(slot.from_city_id, dest, regionByCity),
      slotDayCapacity: slot.day_capacity,
    });
    if (hopBudget.destDaytimeCap <= 0) continue;

    const assignment = assignments.find((a) => a.day_index === slot.day_index);
    const daytimeOnDest = (assignment?.attraction_ids ?? []).filter((id) => {
      const row = catalogById.get(id);
      return row && !isEveningOnlyAttraction(row) && row.city_id.toLowerCase() === dest;
    });
    if (daytimeOnDest.length > 0) continue;

    const backfill = hopDayBackfillCandidate(
      dest,
      [...preDropped, ...dropped],
      catalog,
      catalogById,
      assignedIds,
    );
    if (!backfill) {
      adjustments.push(`Hop day ${slot.day_index} (${dest}): no afternoon sight could be scheduled.`);
      continue;
    }
    if (assignment) {
      assignment.attraction_ids.push(backfill);
    } else {
      assignments.push({ day_index: slot.day_index, attraction_ids: [backfill] });
    }
    assignedIds.add(backfill);
    adjustments.push(`Backfilled hop day ${slot.day_index} with ${backfill}`);
  }

  for (const [cityId, ids] of candidatesByCity) {
    for (const id of ids) {
      if (assignedIds.has(id)) continue;
      const name = catalogById.get(id)?.name ?? id;
      adjustments.push(`未能排入行程：${name}（${cityId}）`);
      if (!dropped.includes(id)) dropped.push(id);
    }
  }

  return { assignments, dropped, adjustments };
}

export function validateAndRepair(params: {
  tripDays: number;
  dayPlans: DayPlanDraft[];
  timeline: TimelineSlot[];
  catalogById: Map<string, AttractionRow>;
  startDate: Date | null;
  regionByCity?: Map<string, string | null>;
  pace?: TripPace;
}): {
  assignments: AIAssignment[];
  dropped: string[];
  adjustments: string[];
} {
  const { tripDays, dayPlans, timeline, catalogById, startDate } = params;
  const regionByCity = params.regionByCity ?? new Map<string, string | null>();
  const pace = params.pace ?? "standard";
  const adjustments: string[] = [];
  const dropped: string[] = [];
  const planByDay = new Map(dayPlans.map((p) => [p.day_index, p]));
  const capacityByDay = new Map(
    timeline.map((t) => [t.day_index, sightseeingBudgetForDay(t.day_index, timeline, regionByCity, pace).dayCapacity]),
  );
  const eveningCapByDay = new Map(
    timeline.map((t) => [t.day_index, sightseeingBudgetForDay(t.day_index, timeline, regionByCity, pace).eveningCap]),
  );
  const allowedCitiesByDay = allowedCitiesFromTimeline(timeline);
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
        const allowed = allowedCitiesByDay.get(assignment.day_index);
        if (!allowed?.has(row.city_id.toLowerCase())) continue;
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
        const allowed = allowedCitiesByDay.get(assignment.day_index);
        if (!allowed?.has(row.city_id.toLowerCase())) continue;
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

  const visitOrder = inferVisitOrder(cityIds, catalogCounts, metaByCity, {
    entryCityId: params.entryCityId,
    exitCityId: params.exitCityId,
  });

  const cityDaysCalibration = calibrateCityDays(
    visitOrder,
    parseAICityWeights(aiPlan),
    catalog,
    citiesMeta,
    tripDays,
    regionByCity,
    pace,
  );
  const cityDays = cityDaysCalibration.cityDays;
  const adjustments: string[] = [...cityDaysCalibration.schedulingAdjustments];

  let timeline = buildTimeline({
    tripDays,
    visitOrder,
    cityDays,
    regionByCity,
    pace,
  });
  timeline = applyFlightAndPaceProfiles(timeline, {
    tripDays,
    visitOrder,
    pace,
    arrivalTime: params.arrivalTime,
    departureTime: params.departureTime,
    activityDaysExcludeCalendarEndpoints: true,
    regionByCity,
  });

  const sightseeingDays = sightseeingDaysPerCity(timeline);
  const timelineRefs = timeline.map((s) => ({
    day_index: s.day_index,
    kind: s.kind,
    city_id: s.city_id,
    from_city_id: s.from_city_id,
  }));
  const { candidatesByCity, preDropped, hopReservedByDayIndex } = pickAttractionsBySlotBudget({
    catalog,
    cityDays: sightseeingDays,
    mustSeeIds: parseAIMustSee(aiPlan),
    pace,
    timeline: timelineRefs,
  });

  let dayPlans = parseAIDayPlans(aiPlan, catalogById);
  if (dayPlans.length === 0) {
    dayPlans = buildRuleDayPlans({
      timeline,
      candidatesByCity,
      catalogById,
      pace,
      regionByCity,
      hopReservedByDayIndex,
    });
  } else {
    dayPlans = alignDayPlansToTimeline(dayPlans, timeline, adjustments);
    dayPlans = filterDayPlansToCandidates(
      dayPlans,
      timeline,
      candidatesByCity,
      catalogById,
      adjustments,
    );
  }

  let { assignments, dropped, adjustments: repairAdj } = validateAndRepair({
    tripDays,
    dayPlans,
    timeline,
    catalogById,
    startDate,
    regionByCity,
    pace,
  });

  const backfill = backfillHopDaysAndScanUnassigned({
    assignments,
    dropped,
    timeline,
    candidatesByCity,
    preDropped,
    catalogById,
    catalog,
    pace,
    regionByCity,
  });
  assignments = backfill.assignments;
  dropped = backfill.dropped;
  adjustments.push(...backfill.adjustments);

  const geoAdj: string[] = [];
  const allowedForGeo = mergeAllowedCitiesForHops(timeline, dayPlans, pace, regionByCity);
  const geo = applyGeographicRepairs({
    assignments,
    catalogById,
    regionByCity,
    allowedCitiesByDay: allowedForGeo,
    adjustments: geoAdj,
  });
  assignments = geo.assignments;
  dropped.push(...geo.dropped);
  adjustments.push(...geoAdj);

  const experienceDays = mergeExperienceDaysWithTimeline({
    timeline,
    regionByCity,
    aiExperienceDays: aiPlan?.experience_days,
    adjustments,
  });

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

  const hopDays: IntercityHopDay[] = timeline
    .filter((s) => isIntercityHopKind(s.kind) && s.from_city_id)
    .map((slot) => {
      const from = slot.from_city_id!;
      const hours = travelHours(from, slot.city_id, regionByCity);
      return {
        day_index: slot.day_index,
        from_city_id: from,
        to_city_id: slot.city_id,
        travel_hours: hours,
        items: buildHopCardContent(from, slot.city_id, hours),
      };
    });

  const hopByDay = new Map(hopDays.map((h) => [h.day_index, h]));
  for (const hop of hopDaysFromPlans(dayPlans, pace, regionByCity)) {
    if (!hopByDay.has(hop.day_index)) {
      hopByDay.set(hop.day_index, hop);
      hopDays.push(hop);
    }
  }

  const cityIdByDayIndex: Record<number, string> = {};
  for (const slot of timeline) {
    cityIdByDayIndex[slot.day_index] = slot.city_id.toLowerCase();
  }

  return {
    assignments,
    experienceDays,
    hopDays: [...hopByDay.values()],
    visitOrder,
    droppedAttractionIds: [...preDropped, ...dropped],
    adjustments: [...adjustments, ...repairAdj],
    timeHintsByAttractionId: collectTimeHints(aiPlan),
    cityIdByDayIndex,
  };
}
