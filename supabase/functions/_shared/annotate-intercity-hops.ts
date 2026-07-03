import { buildHopCardContent, travelHours } from "./city-travel-hints.ts";
import type { ItineraryDay } from "./itinerary-assembler.ts";

function trailingCityId(day: ItineraryDay): string | null {
  if (day.intercity_hop) return day.intercity_hop.to_city_id.toLowerCase();
  if (day.experience_city_id) return day.experience_city_id.toLowerCase();
  const acts = day.activities ?? [];
  for (let i = acts.length - 1; i >= 0; i--) {
    const c = acts[i].city_id?.toLowerCase();
    if (c) return c;
  }
  return null;
}

function leadingCityId(day: ItineraryDay): string | null {
  if (day.intercity_hop) return day.intercity_hop.to_city_id.toLowerCase();
  if (day.experience_city_id) return day.experience_city_id.toLowerCase();
  const acts = day.activities ?? [];
  for (const act of acts) {
    const c = act.city_id?.toLowerCase();
    if (c) return c;
  }
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
