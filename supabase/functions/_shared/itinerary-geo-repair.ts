/** Geographic sanity for assignment lists (dedupe + same-day city compatibility). */

import { canVisitSameDay } from "./city-travel-hints.ts";

export type GeoAssignment = {
  day_index: number;
  attraction_ids: string[];
};

export type GeoAttractionRow = {
  id: string;
  city_id: string;
};

export function dedupeAssignmentIds<T extends GeoAssignment>(
  assignments: T[],
  catalogById: Map<string, GeoAttractionRow>,
): T[] {
  const used = new Set<string>();
  return assignments.map((a) => {
    const ids: string[] = [];
    for (const id of a.attraction_ids ?? []) {
      const sid = String(id).trim();
      if (!sid || !catalogById.has(sid) || used.has(sid)) continue;
      used.add(sid);
      ids.push(sid);
    }
    return { ...a, attraction_ids: ids };
  });
}

export function splitIncompatibleSameDay(
  ids: string[],
  catalogById: Map<string, GeoAttractionRow>,
  regionByCity: Map<string, string | null>,
): { keep: string[]; overflow: string[] } {
  if (ids.length <= 1) return { keep: ids, overflow: [] };
  const keep: string[] = [];
  const overflow: string[] = [];
  let anchorCity: string | null = null;

  for (const id of ids) {
    const city = catalogById.get(id)?.city_id;
    if (!city) {
      keep.push(id);
      continue;
    }
    if (!anchorCity) {
      anchorCity = city;
      keep.push(id);
      continue;
    }
    if (city === anchorCity || canVisitSameDay(anchorCity, city, regionByCity)) {
      keep.push(id);
    } else {
      overflow.push(id);
    }
  }
  return { keep, overflow };
}

function citiesOnAssignment(
  ids: string[],
  catalogById: Map<string, GeoAttractionRow>,
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

/** Dedupe globally and split incompatible cities on the same day. */
export function applyGeographicRepairs<T extends GeoAssignment>(params: {
  assignments: T[];
  catalogById: Map<string, GeoAttractionRow>;
  regionByCity: Map<string, string | null>;
  adjustments: string[];
}): { assignments: T[]; dropped: string[] } {
  const { catalogById, regionByCity, adjustments } = params;
  const assignments = dedupeAssignmentIds(params.assignments, catalogById);
  const overflow: string[] = [];
  const dropped: string[] = [];

  for (const assignment of assignments) {
    const split = splitIncompatibleSameDay(
      assignment.attraction_ids,
      catalogById,
      regionByCity,
    );
    if (split.overflow.length) {
      adjustments.push(
        `Split incompatible cities on day ${assignment.day_index}: ${split.overflow.join(", ")}`,
      );
    }
    assignment.attraction_ids = split.keep;
    overflow.push(...split.overflow);
  }

  for (const id of overflow) {
    const city = catalogById.get(id)?.city_id;
    if (!city) continue;
    let placed = false;
    for (const assignment of assignments) {
      const existing = citiesOnAssignment(assignment.attraction_ids, catalogById);
      if (existing.length === 0 || existing.every((c) => canVisitSameDay(c, city, regionByCity))) {
        assignment.attraction_ids.push(id);
        placed = true;
        adjustments.push(`Placed ${id} on day ${assignment.day_index} (geo repair)`);
        break;
      }
    }
    if (!placed) {
      adjustments.push(`Could not place ${id} after geo split`);
      dropped.push(id);
    }
  }

  return { assignments, dropped };
}
