/** Travel feasibility hints for itinerary planning (mirrors iOS CityTravelHints.swift). */

export type CityMetaRow = {
  id: string;
  name?: string;
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

const DELTA_CITIES = new Set(["shanghai", "nanjing", "hangzhou", "suzhou"]);
const SW_CITIES = new Set(["chengdu", "chongqing"]);

function pairKey(a: string, b: string): string {
  return [a.toLowerCase(), b.toLowerCase()].sort().join("|");
}

export function travelHours(a: string, b: string): number {
  const x = a.toLowerCase();
  const y = b.toLowerCase();
  if (x === y) return 0;
  const known = PAIR_HOURS[pairKey(x, y)];
  if (known != null) return known;
  if (DELTA_CITIES.has(x) && DELTA_CITIES.has(y)) return 2;
  if (SW_CITIES.has(x) && SW_CITIES.has(y)) return 2;
  return 6;
}

/** Same calendar day is realistic only for short hops (≤2h). */
export function canVisitSameDay(a: string, b: string): boolean {
  return travelHours(a, b) <= 2;
}

/** Intercity move typically needs a dedicated travel/rest slot (>2.5h). */
export function needsTravelDay(a: string, b: string): boolean {
  return travelHours(a, b) > 2.5;
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
  const select = "id,name,avg_days_recommended,attraction_count";
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

  let current = [...remaining].sort((a, b) => weight(b) - weight(a))[0];
  order.push(current);
  remaining.delete(current);

  while (remaining.size > 0) {
    let best: string | null = null;
    let bestHours = Infinity;
    for (const candidate of remaining) {
      const h = travelHours(current, candidate);
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
