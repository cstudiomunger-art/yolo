import {
  commuteSlots,
  travelHours,
  type CityMetaRow,
} from "./city-travel-hints.ts";
import { parseDurationSlots } from "./itinerary-duration.ts";
import type { AttractionRow } from "./itinerary-assembler.ts";

export function metaMap(rows: CityMetaRow[]): Map<string, CityMetaRow> {
  return new Map(rows.map((r) => [r.id.toLowerCase(), r]));
}

export function regionMap(metaByCity: Map<string, CityMetaRow>): Map<string, string | null> {
  return new Map([...metaByCity.entries()].map(([k, v]) => [k, v.region ?? null]));
}

export function slotDemandForCity(catalog: AttractionRow[], cityId: string): number {
  const cid = cityId.toLowerCase();
  return catalog
    .filter((a) => a.city_id.toLowerCase() === cid)
    .reduce((sum, a) => sum + parseDurationSlots(a.recommended_duration), 0);
}

export function cityDayWeights(
  cities: string[],
  catalog: AttractionRow[],
  metaByCity: Map<string, CityMetaRow>,
): Map<string, number> {
  const weights = new Map<string, number>();
  for (const city of cities) {
    const cid = city.toLowerCase();
    const meta = metaByCity.get(cid);
    const avg = meta?.avg_days_recommended != null
      ? Math.max(1, Number(meta.avg_days_recommended))
      : 2;
    const slotDemand = slotDemandForCity(catalog, cid);
    const w = avg + 0.25 * Math.ceil(slotDemand / 2);
    weights.set(cid, Math.max(1, w));
  }
  return weights;
}

export function countLongTravelDays(
  visitOrder: string[],
  regionByCity: Map<string, string | null>,
): number {
  let count = 0;
  for (let i = 1; i < visitOrder.length; i++) {
    const h = travelHours(visitOrder[i - 1], visitOrder[i], regionByCity);
    if (commuteSlots(h) >= 2) count++;
  }
  return count;
}

export function distributeDaysAcrossCitiesV2(
  tripDays: number,
  visitOrder: string[],
  catalog: AttractionRow[],
  citiesMeta: CityMetaRow[],
  regionByCity: Map<string, string | null>,
): Map<string, number> {
  if (visitOrder.length === 0) return new Map();

  const metaByCity = metaMap(citiesMeta);
  const travelReserved = countLongTravelDays(visitOrder, regionByCity);
  const available = Math.max(visitOrder.length, tripDays - travelReserved);

  const weights = cityDayWeights(visitOrder, catalog, metaByCity);
  const totalWeight = [...weights.values()].reduce((a, b) => a + b, 0) || 1;

  const map = new Map<string, number>();
  let assigned = 0;

  for (let i = 0; i < visitOrder.length; i++) {
    const city = visitOrder[i].toLowerCase();
    const w = weights.get(city) ?? 1;
    const share = i === visitOrder.length - 1
      ? Math.max(1, available - assigned)
      : Math.max(1, Math.round((available * w) / totalWeight));
    map.set(city, share);
    assigned += share;
  }

  while (assigned > available) {
    const richest = visitOrder.reduce((best, c) =>
      (map.get(c.toLowerCase()) ?? 0) > (map.get(best.toLowerCase()) ?? 0) ? c : best
    );
    const cur = map.get(richest.toLowerCase()) ?? 1;
    if (cur <= 1) break;
    map.set(richest.toLowerCase(), cur - 1);
    assigned--;
  }

  return map;
}

export function calibrateCityDays(
  visitOrder: string[],
  aiWeights: Record<string, number> | undefined,
  catalog: AttractionRow[],
  citiesMeta: CityMetaRow[],
  tripDays: number,
  regionByCity: Map<string, string | null>,
): Map<string, number> {
  const ruleWeights = distributeDaysAcrossCitiesV2(
    tripDays,
    visitOrder,
    catalog,
    citiesMeta,
    regionByCity,
  );

  if (!aiWeights || Object.keys(aiWeights).length === 0) {
    return ruleWeights;
  }

  const merged = new Map<string, number>();
  for (const city of visitOrder) {
    const cid = city.toLowerCase();
    const ai = aiWeights[cid] ?? aiWeights[city];
    const rule = ruleWeights.get(cid) ?? 1;
    if (ai != null && Number.isFinite(Number(ai))) {
      merged.set(cid, Math.max(1, Math.round(0.6 * Number(ai) + 0.4 * rule)));
    } else {
      merged.set(cid, rule);
    }
  }

  const travelReserved = countLongTravelDays(visitOrder, regionByCity);
  const available = Math.max(visitOrder.length, tripDays - travelReserved);
  let assigned = [...merged.values()].reduce((a, b) => a + b, 0);
  while (assigned > available) {
    const richest = visitOrder.reduce((best, c) =>
      (merged.get(c.toLowerCase()) ?? 0) > (merged.get(best.toLowerCase()) ?? 0) ? c : best
    );
    const cur = merged.get(richest.toLowerCase()) ?? 1;
    if (cur <= 1) break;
    merged.set(richest.toLowerCase(), cur - 1);
    assigned--;
  }
  return merged;
}
