/** Derive planning_zone, distance_from_center_km, is_day_trip from lat/lng + city center. */
import { durationSlotsForRow } from "../../supabase/functions/_shared/itinerary-duration.ts";

export function deriveDayTripDraft(row: {
  id: string;
  latitude?: number | null;
  longitude?: number | null;
  distance_from_center_km?: number | null;
  recommended_duration?: string | null;
  duration_slots_min?: number | null;
}): { is_day_trip: boolean; planning_zone: string | null } {
  const distance = row.distance_from_center_km;
  const far = distance != null && distance >= 40;
  const longVisit = durationSlotsForRow(row) >= 3;
  const isDayTrip = far || longVisit;
  return {
    is_day_trip: isDayTrip,
    planning_zone: isDayTrip ? "daytrip" : null,
  };
}

if (import.meta.main) {
  console.log("derive-zone-daytrip: stub — batch over attractions after geocode");
}
