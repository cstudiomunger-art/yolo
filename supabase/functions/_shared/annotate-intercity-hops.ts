import {
  buildHopCardContent,
  buildTravelDayContent,
  commuteSlots,
  routeLabelFromOrder,
  travelHours,
} from "./city-travel-hints.ts";
import type { ItineraryDay } from "./itinerary-assembler.ts";

function activityCityIds(day: ItineraryDay): string[] {
  const out: string[] = [];
  for (const act of day.activities ?? []) {
    const c = act.city_id?.toLowerCase();
    if (c && !out.includes(c)) out.push(c);
  }
  return out;
}

function trailingCityId(day: ItineraryDay): string | null {
  const acts = day.activities ?? [];
  for (let i = acts.length - 1; i >= 0; i--) {
    const c = acts[i].city_id?.toLowerCase();
    if (c) return c;
  }
  if (day.intercity_hop) return day.intercity_hop.to_city_id.toLowerCase();
  if (day.experience_city_id) return day.experience_city_id.toLowerCase();
  return null;
}

function leadingCityId(day: ItineraryDay): string | null {
  const actCities = activityCityIds(day);
  if (actCities.length > 0) return actCities[0];
  if (day.intercity_hop) return day.intercity_hop.to_city_id.toLowerCase();
  if (day.experience_city_id) return day.experience_city_id.toLowerCase();
  return null;
}

/** Scheduler timeline city per day (prefer experience_city_id over misplaced activities). */
export function inferCityIdByDayIndex(
  days: ItineraryDay[],
  visitOrder: string[] = [],
): Record<number, string> {
  const map: Record<number, string> = {};
  const sorted = [...days].sort((a, b) => a.day_index - b.day_index);
  for (const day of sorted) {
    if (day.intercity_hop) {
      map[day.day_index] = day.intercity_hop.to_city_id.toLowerCase();
    } else if (day.experience_city_id) {
      map[day.day_index] = day.experience_city_id.toLowerCase();
    } else {
      const act = (day.activities ?? []).find((a) => a.city_id);
      if (act?.city_id) map[day.day_index] = act.city_id.toLowerCase();
    }
  }
  if (Object.keys(map).length === 0 && visitOrder.length > 0) {
    sorted.forEach((day, i) => {
      map[day.day_index] = visitOrder[Math.min(i, visitOrder.length - 1)].toLowerCase();
    });
  }
  return map;
}

function hopCardItems(fromCity: string, toCity: string, hours: number): string[] {
  if (commuteSlots(hours) >= 2) {
    return buildTravelDayContent(fromCity, toCity, hours);
  }
  return buildHopCardContent(fromCity, toCity, hours);
}

/** Inject intercity_hop when adjacent days change city without scheduler hop metadata. */
export function annotateIntercityHops(
  days: ItineraryDay[],
  regionByCity: Map<string, string | null> = new Map(),
  opts?: { visitOrder?: string[]; cityIdByDayIndex?: Record<number, string> },
): ItineraryDay[] {
  const visitOrder = opts?.visitOrder ?? [];
  const baselineMap = opts?.cityIdByDayIndex ?? inferCityIdByDayIndex(days, visitOrder);
  const sorted = [...days].sort((a, b) => a.day_index - b.day_index);
  return sorted.map((day, index) => {
    if (day.intercity_hop) return day;
    if (index === 0) return day;
    const prev = sorted[index - 1];

    const activityFrom = trailingCityId(prev);
    const activityTo = leadingCityId(day);
    const timelineFrom = baselineMap[prev.day_index];
    const timelineTo = baselineMap[day.day_index];

    let fromCity: string | null = null;
    let toCity: string | null = null;
    if (activityFrom && activityTo && activityFrom !== activityTo) {
      fromCity = activityFrom;
      toCity = activityTo;
    } else if (timelineFrom && timelineTo && timelineFrom !== timelineTo) {
      fromCity = timelineFrom;
      toCity = timelineTo;
    } else {
      return day;
    }

    const hours = travelHours(fromCity, toCity, regionByCity);
    return {
      ...day,
      city_name: routeLabelFromOrder([fromCity, toCity]),
      intercity_hop: {
        from_city_id: fromCity,
        to_city_id: toCity,
        travel_hours: hours,
        items: hopCardItems(fromCity, toCity, hours),
      },
      experience_city_id: day.experience_city_id ?? toCity,
    };
  });
}
