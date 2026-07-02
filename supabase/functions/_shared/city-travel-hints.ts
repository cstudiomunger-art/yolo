/** Travel feasibility hints for itinerary planning (mirrors iOS CityTravelHints.swift). */

export type CityMetaRow = {
  id: string;
  name?: string;
  region?: string | null;
  avg_days_recommended?: number | null;
  attraction_count?: number | null;
};

/** Known HSR/flight hours between city pairs (symmetric). */
const PAIR_HOURS: Record<string, number> = {
  "beijing|shanghai": 5.5,
  "beijing|nanjing": 4,
  "beijing|hangzhou": 5,
  "beijing|suzhou": 5.5,
  "beijing|chengdu": 7.5,
  "beijing|chongqing": 8,
  "shanghai|nanjing": 1.5,
  "shanghai|hangzhou": 1,
  "shanghai|suzhou": 0.5,
  "shanghai|chengdu": 12,
  "shanghai|chongqing": 11,
  "nanjing|hangzhou": 2.5,
  "nanjing|suzhou": 2,
  "hangzhou|suzhou": 1.5,
  "chengdu|chongqing": 1.5,
};

const CITY_REGION_FALLBACK: Record<string, string> = {
  beijing: "north_china",
  shanghai: "yangtze_delta",
  nanjing: "yangtze_delta",
  hangzhou: "yangtze_delta",
  suzhou: "yangtze_delta",
  chengdu: "southwest",
  chongqing: "southwest",
};

const NEAR_REGION_PAIRS = new Set([
  "north_china|yangtze_delta",
  "north_china|central_china",
  "yangtze_delta|central_china",
  "yangtze_delta|southwest",
  "central_china|southwest",
  "central_china|pearl_delta",
  "yangtze_delta|pearl_delta",
]);

function pairKey(a: string, b: string): string {
  return [a.toLowerCase(), b.toLowerCase()].sort().join("|");
}

function normalizeRegion(region: string | null | undefined): string | null {
  const v = String(region ?? "").trim().toLowerCase();
  return v || null;
}

function regionPairKey(a: string, b: string): string {
  return [a, b].sort().join("|");
}

export function travelHours(
  a: string,
  b: string,
  regionByCity: Map<string, string | null> = new Map(),
): number {
  const x = a.toLowerCase();
  const y = b.toLowerCase();
  if (x === y) return 0;
  const known = PAIR_HOURS[pairKey(x, y)];
  if (known != null) return known;

  const rx = normalizeRegion(regionByCity.get(x)) ?? CITY_REGION_FALLBACK[x] ?? null;
  const ry = normalizeRegion(regionByCity.get(y)) ?? CITY_REGION_FALLBACK[y] ?? null;
  if (rx && ry) {
    if (rx === ry) return 2;
    if (NEAR_REGION_PAIRS.has(regionPairKey(rx, ry))) return 4;
    return 6;
  }
  return 6;
}

export function commuteSlots(travelHoursValue: number): 0 | 1 | 2 {
  if (travelHoursValue <= 2) return 0;
  if (travelHoursValue <= 4) return 1;
  return 2;
}

/** Same calendar day is realistic only when no dedicated commute slot. */
export function canVisitSameDay(
  a: string,
  b: string,
  regionByCity: Map<string, string | null> = new Map(),
): boolean {
  return commuteSlots(travelHours(a, b, regionByCity)) === 0;
}

/** Intercity move needs a dedicated travel day when commute takes >= 2 slots. */
export function needsTravelDay(
  a: string,
  b: string,
  regionByCity: Map<string, string | null> = new Map(),
): boolean {
  return commuteSlots(travelHours(a, b, regionByCity)) >= 2;
}

export function cityDisplayName(cityId: string): string {
  return cityId.charAt(0).toUpperCase() + cityId.slice(1).replace(/_/g, " ");
}

export function routeLabelFromOrder(cityIds: string[]): string {
  return cityIds.map(cityDisplayName).join(" → ");
}

export async function fetchCitiesMeta(
  cityIds: string[],
  creds: { url: string; key: string } | null,
): Promise<CityMetaRow[]> {
  if (!creds || cityIds.length === 0) return [];
  const ids = cityIds.map((c) => encodeURIComponent(c)).join(",");
  const select = "id,name,region,avg_days_recommended,attraction_count";
  const res = await fetch(
    `${creds.url}/rest/v1/cities?id=in.(${ids})&select=${select}`,
    {
      headers: {
        apikey: creds.key,
        Authorization: `Bearer ${creds.key}`,
      },
    },
  );
  if (!res.ok) return cityIds.map((id) => ({ id }));
  const rows = await res.json();
  if (!Array.isArray(rows)) return cityIds.map((id) => ({ id }));
  return rows.map((r: Record<string, unknown>) => ({
    id: String(r.id),
    name: r.name != null ? String(r.name) : undefined,
    region: r.region != null ? String(r.region) : null,
    avg_days_recommended: r.avg_days_recommended != null
      ? Number(r.avg_days_recommended)
      : null,
    attraction_count: r.attraction_count != null
      ? Number(r.attraction_count)
      : null,
  }));
}

/** Nearest-neighbor visit order using travel hours + avg_days_recommended weight. */
export function inferVisitOrder(
  cityIds: string[],
  catalogByCity: Map<string, number>,
  metaByCity: Map<string, CityMetaRow>,
  opts?: { entryCityId?: string | null; exitCityId?: string | null },
): string[] {
  const unique = [...new Set(cityIds.map((c) => c.toLowerCase()))].filter(Boolean);
  if (unique.length <= 1) return unique.length ? unique : ["beijing"];

  const remaining = new Set(unique);
  const order: string[] = [];

  const weight = (id: string) => {
    const meta = metaByCity.get(id);
    const count = catalogByCity.get(id) ?? meta?.attraction_count ?? 1;
    const avg = meta?.avg_days_recommended ?? 2;
    return count + avg;
  };

  const entry = opts?.entryCityId?.toLowerCase().trim();
  const exit = opts?.exitCityId?.toLowerCase().trim();

  let current = (entry && remaining.has(entry))
    ? entry
    : [...remaining].sort((a, b) => weight(b) - weight(a))[0];
  order.push(current);
  remaining.delete(current);

  while (remaining.size > 0) {
    let best: string | null = null;
    let bestHours = Infinity;
    for (const candidate of remaining) {
      const h = travelHours(current, candidate, new Map(
        [...metaByCity.entries()].map(([k, v]) => [k, v.region ?? null]),
      ));
      if (h < bestHours) {
        bestHours = h;
        best = candidate;
      }
    }
    if (!best) break;
    order.push(best);
    remaining.delete(best);
    current = best;
  }
  if (exit && order.includes(exit) && order[order.length - 1] !== exit) {
    const noExit = order.filter((c) => c !== exit);
    noExit.push(exit);
    return noExit;
  }
  return order;
}

export function travelExperienceItems(toCityId: string): string[] {
  const name = cityDisplayName(toCityId);
  return [
    "Intercity travel",
    `Travel to ${name}`,
    "Rest and check in",
    "Neighborhood walk near hotel",
  ];
}
