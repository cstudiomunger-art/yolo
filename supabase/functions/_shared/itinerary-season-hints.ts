import type { CityMetaRow } from "./city-travel-hints.ts";

const MONTHS: Record<string, number> = {
  jan: 1, feb: 2, mar: 3, apr: 4, may: 5, jun: 6,
  jul: 7, aug: 8, sep: 9, oct: 10, nov: 11, dec: 12,
};

function parseMonthToken(token: string): number | null {
  const t = token.trim().toLowerCase().slice(0, 3);
  return MONTHS[t] ?? null;
}

/** Parse strings like "Apr–May, Sep–Oct" into month ranges. */
export function parseBestTimeMonths(text: string | null | undefined): Array<[number, number]> {
  const raw = String(text ?? "").trim();
  if (!raw) return [];

  const ranges: Array<[number, number]> = [];
  const parts = raw.split(/[,;]/);
  for (const part of parts) {
    const chunk = part.trim();
    if (!chunk) continue;
    const span = chunk.split(/[–\-—]/);
    if (span.length >= 2) {
      const a = parseMonthToken(span[0]);
      const b = parseMonthToken(span[span.length - 1]);
      if (a && b) ranges.push(a <= b ? [a, b] : [b, a]);
      continue;
    }
    const single = parseMonthToken(chunk);
    if (single) ranges.push([single, single]);
  }
  return ranges;
}

export function monthInRanges(month: number, ranges: Array<[number, number]>): boolean {
  if (ranges.length === 0) return true;
  return ranges.some(([a, b]) => month >= a && month <= b);
}

export function seasonHintsForTrip(params: {
  cityIds: string[];
  citiesMeta: CityMetaRow[];
  tripMonth: number;
}): string[] {
  const { cityIds, citiesMeta, tripMonth } = params;
  const metaById = new Map(citiesMeta.map((c) => [c.id.toLowerCase(), c]));
  const hints: string[] = [];

  for (const cityId of cityIds) {
    const meta = metaById.get(cityId.toLowerCase());
    const best = meta?.best_time_to_visit;
    const ranges = parseBestTimeMonths(best ?? null);
    if (ranges.length === 0) continue;
    if (!monthInRanges(tripMonth, ranges)) {
      const label = meta?.name ?? cityId;
      hints.push(
        `${label}: best months are ${best}; your trip may be off-peak (weather/crowds).`,
      );
    }
  }
  return hints;
}
