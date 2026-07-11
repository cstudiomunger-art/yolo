import { parseDurationSlots, durationSlotsForRow } from "./itinerary-duration.ts";
import { daySlotCapacityForPace, hopDaySlotBudget } from "./itinerary-pace.ts";
import { isEveningOnlyAttraction } from "./itinerary-visit-hours.ts";
import { isIntercityHopKind } from "./city-travel-hints.ts";
import type { AttractionRow } from "./itinerary-assembler.ts";

function priorityRank(p: string | null | undefined): number {
  const v = String(p ?? "P1").toUpperCase();
  if (v === "P0") return 0;
  if (v === "P2") return 2;
  return 1;
}

export type TimelineSlotRef = {
  day_index: number;
  kind: string;
  city_id: string;
  from_city_id?: string;
};

export type PickAttractionsResult = {
  candidatesByCity: Map<string, string[]>;
  preDropped: string[];
  hopReservedByDayIndex: Map<number, string>;
};

/**
 * Step ②: select attraction candidates per city using slot budget.
 */
export function pickAttractionsBySlotBudget(params: {
  catalog: AttractionRow[];
  cityDays: Map<string, number>;
  mustSeeIds?: Set<string>;
  pace?: import("./itinerary-pace.ts").TripPace;
  timeline?: TimelineSlotRef[];
}): PickAttractionsResult {
  const { catalog, cityDays, mustSeeIds = new Set(), pace = "standard", timeline = [] } = params;
  const catalogByCity = new Map<string, AttractionRow[]>();

  for (const row of catalog) {
    const cid = row.city_id.toLowerCase();
    const list = catalogByCity.get(cid) ?? [];
    list.push(row);
    catalogByCity.set(cid, list);
  }

  const hopReservedByDayIndex = new Map<number, string>();
  const reservedIds = new Set<string>();

  for (const slot of timeline) {
    if (!isIntercityHopKind(slot.kind) || slot.kind === "travel") continue;
    const dest = slot.city_id.toLowerCase();
    const pool = [...(catalogByCity.get(dest) ?? [])].sort((a, b) => {
      const pa = priorityRank(a.priority);
      const pb = priorityRank(b.priority);
      if (pa !== pb) return pa - pb;
      return a.display_order - b.display_order;
    });
    const row = pool.find((candidate) =>
      !reservedIds.has(candidate.id)
      && !isEveningOnlyAttraction(candidate)
      && parseDurationSlots(candidate.recommended_duration) <= 1
    );
    if (!row) continue;
    hopReservedByDayIndex.set(slot.day_index, row.id);
    reservedIds.add(row.id);
  }

  const candidatesByCity = new Map<string, string[]>();
  const preDropped: string[] = [];

  const hopSlotsByDest = new Map<string, TimelineSlotRef[]>();
  for (const slot of timeline) {
    if (!isIntercityHopKind(slot.kind) || slot.kind === "travel") continue;
    const dest = slot.city_id.toLowerCase();
    const list = hopSlotsByDest.get(dest) ?? [];
    list.push(slot);
    hopSlotsByDest.set(dest, list);
  }

  const sightseeingOnlyDays = new Map(cityDays);
  for (const [dest, slots] of hopSlotsByDest) {
    sightseeingOnlyDays.set(dest, Math.max(0, (sightseeingOnlyDays.get(dest) ?? 0) - slots.length));
  }

  const orderedCities: string[] = [];
  const seen = new Set<string>();
  for (const slot of timeline) {
    const cid = slot.city_id.toLowerCase();
    if (!seen.has(cid)) {
      seen.add(cid);
      orderedCities.push(cid);
    }
  }
  for (const cid of [...cityDays.keys()].sort()) {
    if (!seen.has(cid)) orderedCities.push(cid);
  }

  for (const cityId of orderedCities) {
    const totalDays = cityDays.get(cityId);
    if (totalDays == null || totalDays <= 0) continue;
    const fullDays = Math.max(0, sightseeingOnlyDays.get(cityId) ?? totalDays);
    const hopDays = hopSlotsByDest.get(cityId)?.length ?? 0;

    const pool = [...(catalogByCity.get(cityId) ?? [])].sort((a, b) => {
      const pa = priorityRank(a.priority);
      const pb = priorityRank(b.priority);
      if (pa !== pb) return pa - pb;
      return a.display_order - b.display_order;
    });

    const slotsPerDay = daySlotCapacityForPace("full_day", pace);
    const hopSlotsPerDay = hopDaySlotBudget(pace);
    const slotBudget = fullDays * slotsPerDay + hopDays * hopSlotsPerDay;
    const dayPool = pool.filter((r) => !isEveningOnlyAttraction(r) && !reservedIds.has(r.id));
    const eveningPool = pool.filter((r) => isEveningOnlyAttraction(r) && !reservedIds.has(r.id));
    const mustIds = new Set(
      dayPool.filter((r) =>
        priorityRank(r.priority) === 0 || mustSeeIds.has(r.id)
      ).map((r) => r.id),
    );

    const picked: string[] = [];
    const pickedSet = new Set<string>();
    let usedSlots = 0;
    let daytimeCount = 0;
    const minDaytime = fullDays + hopDays;

    const tryPick = (row: AttractionRow, force = false): boolean => {
      const slots = durationSlotsForRow(row);
      if (!force && usedSlots + slots > slotBudget && picked.length > 0) return false;
      picked.push(row.id);
      pickedSet.add(row.id);
      usedSlots += slots;
      if (!isEveningOnlyAttraction(row)) daytimeCount++;
      return true;
    };

    for (const row of dayPool) {
      if (pickedSet.has(row.id)) continue;
      if (daytimeCount >= minDaytime) break;
      const slots = durationSlotsForRow(row);
      if (slots > 1) continue;
      if (usedSlots + slots <= slotBudget || daytimeCount === 0) {
        tryPick(row, daytimeCount === 0);
      }
    }

    for (const row of dayPool) {
      if (!mustIds.has(row.id) || pickedSet.has(row.id)) continue;
      const slots = durationSlotsForRow(row);
      if (usedSlots + slots > slotBudget && picked.length > 0) {
        preDropped.push(row.id);
        continue;
      }
      tryPick(row);
    }

    for (const row of dayPool) {
      if (pickedSet.has(row.id)) continue;
      const slots = durationSlotsForRow(row);
      if (usedSlots + slots > slotBudget) {
        preDropped.push(row.id);
        continue;
      }
      tryPick(row);
    }

    if (daytimeCount < minDaytime) {
      const extra = dayPool.find((row) =>
        !pickedSet.has(row.id)
        && priorityRank(row.priority) <= 1
        && durationSlotsForRow(row) <= 1
      );
      if (extra) tryPick(extra, true);
    }

    const eveningBudget = Math.min(1, totalDays);
    for (const row of eveningPool.slice(0, eveningBudget)) {
      if (pickedSet.has(row.id)) continue;
      picked.push(row.id);
      pickedSet.add(row.id);
    }
    for (const row of eveningPool.slice(eveningBudget)) {
      if (!pickedSet.has(row.id)) preDropped.push(row.id);
    }

    for (const id of hopReservedByDayIndex.values()) {
      if (catalogByCity.get(cityId)?.some((r) => r.id === id) && !pickedSet.has(id)) {
        picked.unshift(id);
        pickedSet.add(id);
      }
    }

    candidatesByCity.set(cityId, picked);
  }

  return { candidatesByCity, preDropped, hopReservedByDayIndex };
}
