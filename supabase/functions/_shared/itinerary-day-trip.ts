/** Full-day / far-suburb attractions that must not share a day with urban sights. */

import { durationSlotsForRow } from "./itinerary-duration.ts";

export type DayTripAttractionRow = {
  id: string;
  recommended_duration?: string | null;
  planning_zone?: string | null;
  is_day_trip?: boolean | null;
  duration_slots_min?: number | null;
};

const KNOWN_DAY_TRIP_IDS = new Set([
  "chongqing_wulong_karst",
  "beijing_mutianyu_great_wall",
  "chongqing_dazu_rock_carvings",
]);

export function isDayTripAttraction(
  id: string,
  catalogById: Map<string, DayTripAttractionRow>,
): boolean {
  const sid = id.trim().toLowerCase();
  if (KNOWN_DAY_TRIP_IDS.has(sid)) return true;
  const row = catalogById.get(id) ?? catalogById.get(sid);
  if (!row) return false;
  if (row.is_day_trip) return true;
  const zone = row.planning_zone?.trim().toLowerCase() ?? "";
  if (zone.startsWith("daytrip")) return true;
  return durationSlotsForRow(row) >= 3;
}

export function splitDayTripFromUrban(
  ids: string[],
  catalogById: Map<string, DayTripAttractionRow>,
): { keep: string[]; overflow: string[] } {
  if (ids.length <= 1) return { keep: ids, overflow: [] };
  const dayTrips: string[] = [];
  const urban: string[] = [];
  for (const id of ids) {
    if (isDayTripAttraction(id, catalogById)) dayTrips.push(id);
    else urban.push(id);
  }
  if (dayTrips.length === 0 || urban.length === 0) return { keep: ids, overflow: [] };
  if (dayTrips.length === ids.length) return { keep: ids, overflow: [] };
  return { keep: urban, overflow: dayTrips };
}
