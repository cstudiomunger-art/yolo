import { parseDurationSlots, daySlotCapacity } from "./itinerary-duration.ts";
import { daySlotCapacityForPace } from "./itinerary-pace.ts";
import { isEveningOnlyAttraction } from "./itinerary-visit-hours.ts";
import type { AttractionRow } from "./itinerary-assembler.ts";

function priorityRank(p: string | null | undefined): number {
  const v = String(p ?? "P1").toUpperCase();
  if (v === "P0") return 0;
  if (v === "P2") return 2;
  return 1;
}

export type PickAttractionsResult = {
  candidatesByCity: Map<string, string[]>;
  preDropped: string[];
};

/**
 * Step ②: select attraction candidates per city using slot budget.
 */
export function pickAttractionsBySlotBudget(params: {
  catalog: AttractionRow[];
  cityDays: Map<string, number>;
  mustSeeIds?: Set<string>;
  pace?: import("./itinerary-pace.ts").TripPace;
}): PickAttractionsResult {
  const { catalog, cityDays, mustSeeIds = new Set(), pace = "standard" } = params;
  const catalogByCity = new Map<string, AttractionRow[]>();

  for (const row of catalog) {
    const cid = row.city_id.toLowerCase();
    const list = catalogByCity.get(cid) ?? [];
    list.push(row);
    catalogByCity.set(cid, list);
  }

  const candidatesByCity = new Map<string, string[]>();
  const preDropped: string[] = [];

  for (const [cityId, days] of cityDays) {
    const D = Math.max(1, days);
    const pool = [...(catalogByCity.get(cityId.toLowerCase()) ?? [])].sort((a, b) => {
      const pa = priorityRank(a.priority);
      const pb = priorityRank(b.priority);
      if (pa !== pb) return pa - pb;
      return a.display_order - b.display_order;
    });

    const slotBudget = D * daySlotCapacityForPace("full_day", pace);
    const dayPool = pool.filter((r) => !isEveningOnlyAttraction(r));
    const eveningPool = pool.filter((r) => isEveningOnlyAttraction(r));
    const mustIds = new Set(
      dayPool.filter((r) =>
        priorityRank(r.priority) === 0 || mustSeeIds.has(r.id)
      ).map((r) => r.id),
    );

    const picked: string[] = [];
    const pickedSet = new Set<string>();
    let usedSlots = 0;
    let daytimeCount = 0;

    for (const row of dayPool) {
      if (pickedSet.has(row.id)) continue;
      if (daytimeCount >= D) break;
      const slots = parseDurationSlots(row.recommended_duration);
      if (slots > 1) continue;
      if (usedSlots + slots <= slotBudget || daytimeCount === 0) {
        picked.push(row.id);
        pickedSet.add(row.id);
        usedSlots += slots;
        daytimeCount++;
      }
    }

    for (const row of dayPool) {
      if (!mustIds.has(row.id) || pickedSet.has(row.id)) continue;
      const slots = parseDurationSlots(row.recommended_duration);
      if (usedSlots + slots > slotBudget && picked.length > 0) {
        preDropped.push(row.id);
        continue;
      }
      picked.push(row.id);
      pickedSet.add(row.id);
      usedSlots += slots;
      if (!isEveningOnlyAttraction(row)) daytimeCount++;
    }

    for (const row of dayPool) {
      if (pickedSet.has(row.id)) continue;
      const slots = parseDurationSlots(row.recommended_duration);
      if (usedSlots + slots > slotBudget) {
        preDropped.push(row.id);
        continue;
      }
      picked.push(row.id);
      pickedSet.add(row.id);
      usedSlots += slots;
      if (!isEveningOnlyAttraction(row)) daytimeCount++;
    }

    if (daytimeCount < D) {
      const extra = dayPool.find((row) =>
        !pickedSet.has(row.id)
        && priorityRank(row.priority) <= 1
        && parseDurationSlots(row.recommended_duration) <= 1
      );
      if (extra) {
        picked.push(extra.id);
        pickedSet.add(extra.id);
      }
    }

    const eveningBudget = Math.min(1, D);
    for (const row of eveningPool.slice(0, eveningBudget)) {
      if (pickedSet.has(row.id)) continue;
      picked.push(row.id);
      pickedSet.add(row.id);
    }
    for (const row of eveningPool.slice(eveningBudget)) {
      if (!pickedSet.has(row.id)) preDropped.push(row.id);
    }

    candidatesByCity.set(cityId.toLowerCase(), picked);
  }

  return { candidatesByCity, preDropped };
}
