import {
  canIntenseSameDayHop,
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

export function minDemandDaysForCity(
  catalog: AttractionRow[],
  cityId: string,
  pace: TripPace,
): number {
  const slotsPerDay = daySlotCapacityForPace("full_day", pace);
  const demand = slotDemandForCity(catalog, cityId);
  return Math.max(1, Math.ceil(demand / slotsPerDay));
}

export function cityDayWeights(
  cities: string[],
  catalog: AttractionRow[],
  metaByCity: Map<string, CityMetaRow>,
  pace: TripPace = "standard",
): Map<string, number> {
  const weights = new Map<string, number>();
  for (const city of cities) {
    const cid = city.toLowerCase();
    const meta = metaByCity.get(cid);
    const avg = meta?.avg_days_recommended != null
      ? Math.max(1, Number(meta.avg_days_recommended))
      : 2;
    const minD = minDemandDaysForCity(catalog, cid, pace);
    weights.set(cid, Math.max(1, minD, avg));
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

export function reservedHopTransitionDays(
  visitOrder: string[],
  regionByCity: Map<string, string | null>,
  pace: TripPace = "standard",
): number {
  let count = 0;
  for (let i = 1; i < visitOrder.length; i++) {
    const a = visitOrder[i - 1].toLowerCase();
    const b = visitOrder[i].toLowerCase();
    const slots = commuteSlots(travelHours(a, b, regionByCity));
    if (slots >= 2) continue;
    if (pace === "intense" && canIntenseSameDayHop(a, b, regionByCity)) {
      count++;
      continue;
    }
    if (slots <= 1) count++;
  }
  return count;
}

export function reservedIntercityDays(
  visitOrder: string[],
  regionByCity: Map<string, string | null>,
  pace: TripPace = "standard",
): number {
  return reservedFullTravelDays(visitOrder, regionByCity)
    + reservedHopTransitionDays(visitOrder, regionByCity, pace);
}

export function countLongTravelDays(
  visitOrder: string[],
  regionByCity: Map<string, string | null>,
): number {
  return reservedFullTravelDays(visitOrder, regionByCity);
}

function rebalanceCityDaysSum(
  map: Map<string, number>,
  visitOrder: string[],
  catalog: AttractionRow[],
  pace: TripPace,
  available: number,
): Map<string, number> {
  const result = new Map(map);
  let assigned = [...result.values()].reduce((a, b) => a + b, 0);
  const exit = visitOrder[visitOrder.length - 1]?.toLowerCase();

  while (assigned > available) {
    const donor = visitOrder
      .map((c) => c.toLowerCase())
      .filter((c) => (result.get(c) ?? 0) > 1)
      .sort((a, b) => {
        const surplusA = (result.get(a) ?? 0) - minDemandDaysForCity(catalog, a, pace);
        const surplusB = (result.get(b) ?? 0) - minDemandDaysForCity(catalog, b, pace);
        if (surplusA !== surplusB) return surplusB - surplusA;
        if (a === exit) return 1;
        if (b === exit) return -1;
        return (result.get(b) ?? 0) - (result.get(a) ?? 0);
      })[0];
    if (!donor) break;
    result.set(donor, (result.get(donor) ?? 1) - 1);
    assigned--;
  }

  while (assigned < available) {
    const recipient = visitOrder
      .map((c) => c.toLowerCase())
      .sort((a, b) => {
        const gapA = minDemandDaysForCity(catalog, a, pace) - (result.get(a) ?? 0);
        const gapB = minDemandDaysForCity(catalog, b, pace) - (result.get(b) ?? 0);
        if (gapA !== gapB) return gapB - gapA;
        if (a === exit && gapA <= 0) return 1;
        if (b === exit && gapB <= 0) return -1;
        return slotDemandForCity(catalog, b) - slotDemandForCity(catalog, a);
      })[0];
    if (!recipient) break;
    const gap = minDemandDaysForCity(catalog, recipient, pace) - (result.get(recipient) ?? 0);
    if (gap <= 0 && recipient === exit) break;
    result.set(recipient, (result.get(recipient) ?? 1) + 1);
    assigned++;
  }

  return result;
}

export function simulateTimelineSlotCount(
  tripDays: number,
  visitOrder: string[],
  cityDays: Map<string, number>,
  regionByCity: Map<string, string | null>,
  pace: TripPace = "standard",
): number {
  let dayPtr = 1;
  let count = 0;

  for (let i = 0; i < visitOrder.length; i++) {
    const cityId = visitOrder[i].toLowerCase();
    if (i > 0) {
      const prev = visitOrder[i - 1].toLowerCase();
      const h = travelHours(prev, cityId, regionByCity);
      if (commuteSlots(h) >= 2 && dayPtr <= tripDays) {
        count++;
        dayPtr++;
      }
    }

    const budget = cityDays.get(cityId) ?? 1;
    for (let b = 0; b < budget && dayPtr <= tripDays; b++) {
      count++;
      dayPtr++;
    }
  }

  return Math.min(count, tripDays);
}

export function closeTimelineSlotCount(
  cityDays: Map<string, number>,
  visitOrder: string[],
  catalog: AttractionRow[],
  tripDays: number,
  regionByCity: Map<string, string | null>,
  pace: TripPace,
): Map<string, number> {
  const result = new Map(cityDays);
  const exit = visitOrder[visitOrder.length - 1]?.toLowerCase();

  const slotCount = () => simulateTimelineSlotCount(
    tripDays,
    visitOrder,
    result,
    regionByCity,
    pace,
  );

  let guardLoops = 0;
  while (slotCount() < tripDays && guardLoops < 64) {
    guardLoops++;
    const recipient = visitOrder
      .map((c) => c.toLowerCase())
      .sort((a, b) => {
        const gapA = minDemandDaysForCity(catalog, a, pace) - (result.get(a) ?? 0);
        const gapB = minDemandDaysForCity(catalog, b, pace) - (result.get(b) ?? 0);
        if (gapA !== gapB) return gapB - gapA;
        if (a === exit && gapA <= 0) return 1;
        if (b === exit && gapB <= 0) return -1;
        return slotDemandForCity(catalog, b) - slotDemandForCity(catalog, a);
      })[0];
    if (!recipient) break;
    result.set(recipient, (result.get(recipient) ?? 1) + 1);
  }

  guardLoops = 0;
  while (slotCount() > tripDays && guardLoops < 64) {
    guardLoops++;
    const donor = visitOrder
      .map((c) => c.toLowerCase())
      .filter((c) => (result.get(c) ?? 0) > 1)
      .sort((a, b) => {
        const surplusA = (result.get(a) ?? 0) - minDemandDaysForCity(catalog, a, pace);
        const surplusB = (result.get(b) ?? 0) - minDemandDaysForCity(catalog, b, pace);
        if (surplusA !== surplusB) return surplusB - surplusA;
        if (a === exit) return 1;
        if (b === exit) return -1;
        return (result.get(b) ?? 0) - (result.get(a) ?? 0);
      })[0];
    if (!donor) break;
    result.set(donor, (result.get(donor) ?? 1) - 1);
  }

  return result;
}

export function distributeDaysAcrossCitiesV2(
  tripDays: number,
  visitOrder: string[],
  catalog: AttractionRow[],
  citiesMeta: CityMetaRow[],
  regionByCity: Map<string, string | null>,
  pace: TripPace = "standard",
): Map<string, number> {
  if (visitOrder.length === 0) return new Map();

  const travelReserved = reservedFullTravelDays(visitOrder, regionByCity);
  const available = Math.max(visitOrder.length, tripDays - travelReserved);
  return distributeDaysWithAvailable(available, visitOrder, catalog, citiesMeta, pace);
}

function distributeDaysWithAvailable(
  availableCityDays: number,
  visitOrder: string[],
  catalog: AttractionRow[],
  citiesMeta: CityMetaRow[],
  pace: TripPace,
): Map<string, number> {
  const metaByCity = metaMap(citiesMeta);
  const weights = cityDayWeights(visitOrder, catalog, metaByCity, pace);
  const totalWeight = [...weights.values()].reduce((a, b) => a + b, 0) || 1;

  const map = new Map<string, number>();
  for (const city of visitOrder) {
    const cid = city.toLowerCase();
    const w = weights.get(cid) ?? 1;
    map.set(cid, Math.max(1, Math.round((availableCityDays * w) / totalWeight)));
  }

  return rebalanceCityDaysSum(map, visitOrder, catalog, pace, availableCityDays);
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
    minDemandDays += minDemandDaysForCity(catalog, city, pace);
  }

  const calendarNeed = simulateTimelineSlotCount(
    tripDays,
    visitOrder,
    cityDays,
    regionByCity,
    pace,
  );
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
  catalog: AttractionRow[],
): Map<string, number> {
  if (tripDays < 8 || visitOrder.length < 3) return map;
  const entry = visitOrder[0]?.toLowerCase();
  if (!entry) return map;
  const exit = visitOrder[visitOrder.length - 1]?.toLowerCase();
  const result = new Map(map);
  const minEntry = 2;
  let current = result.get(entry) ?? 1;
  if (current >= minEntry) return map;

  const donors = visitOrder
    .slice(1)
    .map((c) => c.toLowerCase())
    .sort((a, b) => {
      const demandA = slotDemandForCity(catalog, a);
      const demandB = slotDemandForCity(catalog, b);
      if (demandA !== demandB) return demandA - demandB;
      return (result.get(b) ?? 1) - (result.get(a) ?? 1);
    });

  for (const donor of donors) {
    if (current >= minEntry) break;
    if (donor === exit && (result.get(donor) ?? 1) <= minDemandDaysForCity(catalog, donor, "standard")) {
      continue;
    }
    const spare = (result.get(donor) ?? 1) - 1;
    if (spare <= 0) continue;
    const take = Math.min(minEntry - current, spare);
    result.set(entry, current + take);
    result.set(donor, (result.get(donor) ?? 1) - take);
    current += take;
  }
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

  const ruleWeights = distributeDaysWithAvailable(available, visitOrder, catalog, citiesMeta, pace);

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
    cityDays = rebalanceCityDaysSum(merged, visitOrder, catalog, pace, available);
  }

  cityDays = applyEntryCityMinDays(cityDays, visitOrder, tripDays, catalog);
  cityDays = closeTimelineSlotCount(cityDays, visitOrder, catalog, tripDays, regionByCity, pace);

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
