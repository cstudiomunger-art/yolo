import {
  buildHopCardContent,
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

/** Inject intercity_hop when adjacent days change city without scheduler hop metadata. */
export function annotateIntercityHops(
  days: ItineraryDay[],
  regionByCity: Map<string, string | null> = new Map(),
): ItineraryDay[] {
  const sorted = [...days].sort((a, b) => a.day_index - b.day_index);
  return sorted.map((day, index) => {
    if (day.intercity_hop) return day;
    if (index === 0) return day;
    const prev = sorted[index - 1];
    const fromCity = trailingCityId(prev);
    const toCity = leadingCityId(day);
    if (!fromCity || !toCity || fromCity === toCity) return day;
    const hours = travelHours(fromCity, toCity, regionByCity);
    return {
      ...day,
      city_name: routeLabelFromOrder([fromCity, toCity]),
      intercity_hop: {
        from_city_id: fromCity,
        to_city_id: toCity,
        travel_hours: hours,
        items: buildHopCardContent(fromCity, toCity, hours),
      },
      experience_city_id: day.experience_city_id ?? toCity,
    };
  });
}
