import {
  arrivalAfternoonExperienceItems,
  cityDisplayName,
  departureMorningExperienceItems,
  flexibleRestDayItems,
} from "./city-travel-hints.ts";
import { isAfternoonArrival, isMorningDeparture } from "./itinerary-flight-times.ts";
import type { ItineraryDay } from "./itinerary-assembler.ts";

function isBlankDay(day: ItineraryDay): boolean {
  if (day.intercity_hop) return false;
  return day.day_kind !== "experience_suggestions"
    && (day.activities?.length ?? 0) === 0
    && (day.experience_items?.length ?? 0) === 0;
}

function resolveCityId(day: ItineraryDay, visitOrder: string[]): string {
  if (day.experience_city_id) return day.experience_city_id.toLowerCase();
  const actCity = day.activities?.find((a) => a.city_id)?.city_id;
  if (actCity) return actCity.toLowerCase();
  const name = String(day.city_name ?? "").trim().toLowerCase();
  if (name) {
    for (const cid of visitOrder) {
      if (cityDisplayName(cid).toLowerCase() === name) return cid.toLowerCase();
    }
  }
  const idx = Math.max(0, day.day_index - 1);
  return visitOrder[idx]?.toLowerCase() ?? visitOrder[0]?.toLowerCase() ?? "beijing";
}

function experienceItemsForBlankDay(params: {
  dayIndex: number;
  cityId: string;
  firstTripDay?: number;
  lastTripDay?: number;
  tripDayCount: number;
  arrivalTime?: string | null;
  departureTime?: string | null;
}): string[] {
  const {
    dayIndex,
    cityId,
    firstTripDay,
    lastTripDay,
    tripDayCount,
    arrivalTime,
    departureTime,
  } = params;
  if (dayIndex === firstTripDay && isAfternoonArrival(arrivalTime)) {
    return arrivalAfternoonExperienceItems(cityId);
  }
  if (dayIndex === lastTripDay && tripDayCount > 1 && isMorningDeparture(departureTime)) {
    return departureMorningExperienceItems(cityId);
  }
  return flexibleRestDayItems(cityId);
}

export function fillEmptyItineraryDays(
  days: ItineraryDay[],
  visitOrder: string[],
  opts?: {
    arrivalTime?: string | null;
    departureTime?: string | null;
  },
): ItineraryDay[] {
  const dayIndices = days.map((d) => d.day_index).sort((a, b) => a - b);
  const firstTripDay = dayIndices[0];
  const lastTripDay = dayIndices[dayIndices.length - 1];

  return days.map((day) => {
    if (day.intercity_hop) return day;
    if (!isBlankDay(day)) return day;
    const cityId = resolveCityId(day, visitOrder);
    const items = experienceItemsForBlankDay({
      dayIndex: day.day_index,
      cityId,
      firstTripDay,
      lastTripDay,
      tripDayCount: dayIndices.length,
      arrivalTime: opts?.arrivalTime,
      departureTime: opts?.departureTime,
    });
    return {
      ...day,
      city_name: day.city_name || cityDisplayName(cityId),
      day_kind: "experience_suggestions",
      experience_items: items,
      experience_city_id: cityId,
      activities: [],
    };
  });
}
