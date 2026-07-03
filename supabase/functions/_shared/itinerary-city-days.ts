import {
  commuteSlots,
  travelHours,
  type CityMetaRow,
} from "./city-travel-hints.ts";
import { parseDurationSlots } from "./itinerary-duration.ts";
import { daySlotCapacityForPace, type TripPace } from "./itinerary-pace.ts";
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

export function reservedFullTravelDays(
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

export function countLongTravelDays(
  visitOrder: string[],
  regionByCity: Map<string, string | null>,
): number {
  return reservedFullTravelDays(visitOrder, regionByCity);
}

function clampCityDaysSum(
  map: Map<string, number>,
  visitOrder: string[],
  available: number,
): Map<string, number> {
  const result = new Map(map);
  let assigned = [...result.values()].reduce((a, b) => a + b, 0);
  while (assigned > available) {
    const richest = visitOrder.reduce((best, c) =>
      (result.get(c.toLowerCase()) ?? 0) > (result.get(best.toLowerCase()) ?? 0) ? c : best
    );
    const cur = result.get(richest.toLowerCase()) ?? 1;
    if (cur <= 1) break;
    result.set(richest.toLowerCase(), cur - 1);
    assigned--;
  }
  while (assigned < available) {
    const last = visitOrder[visitOrder.length - 1]?.toLowerCase();
    if (!last) break;
    result.set(last, (result.get(last) ?? 1) + 1);
    assigned++;
  }
  return result;
}

export function distributeDaysAcrossCitiesV2(
  tripDays: number,
  visitOrder: string[],
  catalog: AttractionRow[],
  citiesMeta: CityMetaRow[],
  regionByCity: Map<string, string | null>,
): Map<string, number> {
  if (visitOrder.length === 0) return new Map();

  const travelReserved = reservedFullTravelDays(visitOrder, regionByCity);
  const available = Math.max(visitOrder.length, tripDays - travelReserved);
  return distributeDaysWithAvailable(available, visitOrder, catalog, citiesMeta);
}

function distributeDaysWithAvailable(
  availableCityDays: number,
  visitOrder: string[],
  catalog: AttractionRow[],
  citiesMeta: CityMetaRow[],
): Map<string, number> {
  const metaByCity = metaMap(citiesMeta);
  const weights = cityDayWeights(visitOrder, catalog, metaByCity);
  const totalWeight = [...weights.values()].reduce((a, b) => a + b, 0) || 1;

  const map = new Map<string, number>();
  let assigned = 0;

  for (let i = 0; i < visitOrder.length; i++) {
    const city = visitOrder[i].toLowerCase();
    const w = weights.get(city) ?? 1;
    const share = i === visitOrder.length - 1
      ? Math.max(1, availableCityDays - assigned)
      : Math.max(1, Math.round((availableCityDays * w) / totalWeight));
    map.set(city, share);
    assigned += share;
  }

  return clampCityDaysSum(map, visitOrder, availableCityDays);
}

export type CityDaysCalibration = {
  cityDays: Map<string, number>;
  availableCityDays: number;
  reservedTravelDays: number;
  tightTripHints: string[];
  schedulingAdjustments: string[];
};

function assessTightTrip(params: {
  visitOrder: string[];
  cityDays: Map<string, number>;
  catalog: AttractionRow[];
  tripDays: number;
  availableCityDays: number;
  pace: TripPace;
  regionByCity: Map<string, string | null>;
}): { hints: string[]; adjustments: string[] } {
  const { visitOrder, cityDays, catalog, tripDays, availableCityDays, pace, regionByCity } = params;
  const hints: string[] = [];
  const adjustments: string[] = [];
  const slotsPerDay = daySlotCapacityForPace("full_day", pace);

  let minDemandDays = 0;
  for (const city of visitOrder) {
    const demand = slotDemandForCity(catalog, city);
    minDemandDays += Math.ceil(demand / slotsPerDay);
  }

  const calendarNeed = [...cityDays.values()].reduce((a, b) => a + b, 0)
    + reservedFullTravelDays(visitOrder, regionByCity);
  if (calendarNeed > tripDays) {
    const msg = `行程 ${tripDays} 天偏紧：按景点体量建议至少 ${minDemandDays} 个观光日，已压缩分配。`;
    hints.push(msg);
    adjustments.push(msg);
  } else if (minDemandDays > availableCityDays + 0.5) {
    const msg = `景点较多，${availableCityDays} 个观光日可能装不下全部推荐景点，部分将自动取舍。`;
    hints.push(msg);
    adjustments.push(msg);
  }

  return { hints, adjustments };
}

function applyEntryCityMinDays(
  map: Map<string, number>,
  visitOrder: string[],
  tripDays: number,
): Map<string, number> {
  if (tripDays < 8 || visitOrder.length < 3) return map;
  const entry = visitOrder[0]?.toLowerCase();
  const last = visitOrder[visitOrder.length - 1]?.toLowerCase();
  if (!entry || !last || entry === last) return map;
  const result = new Map(map);
  const minEntry = 2;
  const current = result.get(entry) ?? 1;
  const lastDays = result.get(last) ?? 1;
  if (current >= minEntry || lastDays <= 1) return map;
  const take = Math.min(minEntry - current, lastDays - 1);
  result.set(entry, current + take);
  result.set(last, lastDays - take);
  return result;
}

export function calibrateCityDays(
  visitOrder: string[],
  aiWeights: Record<string, number> | undefined,
  catalog: AttractionRow[],
  citiesMeta: CityMetaRow[],
  tripDays: number,
  regionByCity: Map<string, string | null>,
  pace: TripPace = "standard",
): CityDaysCalibration {
  const travelReserved = reservedFullTravelDays(visitOrder, regionByCity);
  const available = Math.max(visitOrder.length, tripDays - travelReserved);

  const ruleWeights = distributeDaysWithAvailable(available, visitOrder, catalog, citiesMeta);

  let cityDays: Map<string, number>;
  if (!aiWeights || Object.keys(aiWeights).length === 0) {
    cityDays = ruleWeights;
  } else {
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
    cityDays = clampCityDaysSum(merged, visitOrder, available);
  }

  cityDays = applyEntryCityMinDays(cityDays, visitOrder, tripDays);

  const { hints, adjustments } = assessTightTrip({
    visitOrder,
    cityDays,
    catalog,
    tripDays,
    availableCityDays: available,
    pace,
    regionByCity,
  });

  return {
    cityDays,
    availableCityDays: available,
    reservedTravelDays: travelReserved,
    tightTripHints: hints,
    schedulingAdjustments: adjustments,
  };
}
