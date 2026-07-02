export type DayScheduleProfile = "full_day" | "arrival_day" | "departure_day";

export function parseDurationSlots(
  recommendedDuration: string | null | undefined,
): number {
  const raw = String(recommendedDuration ?? "").trim().toLowerCase();
  if (!raw) return 1;

  if (
    raw.includes("full day") ||
    raw.includes("all day") ||
    raw.includes("whole day")
  ) return 2;

  const hourMatch = raw.match(/(\d+(?:\.\d+)?)\s*(h|hour)/);
  if (hourMatch) {
    const hours = Number(hourMatch[1]);
    if (Number.isFinite(hours)) {
      if (hours <= 3) return 0.5;
      if (hours >= 5) return 2;
      return 1;
    }
  }

  if (raw.includes("half day")) return 1;
  return 1;
}

export function daySlotCapacity(profile: DayScheduleProfile): number {
  switch (profile) {
    case "arrival_day":
    case "departure_day":
      return 1;
    case "full_day":
    default:
      return 2;
  }
}

export function maxAttractionsPerDayByCatalog(
  catalogDurations: number[],
  tripDays: number,
  hardMax = 3,
): number {
  const days = Math.max(1, tripDays);
  if (catalogDurations.length === 0) return 1;
  const totalSlots = catalogDurations.reduce((sum, v) => sum + (v || 1), 0);
  const avgSlotsPerDay = totalSlots / days;
  if (avgSlotsPerDay <= 1) return 1;
  if (avgSlotsPerDay <= 1.5) return Math.min(2, hardMax);
  return Math.min(3, hardMax);
}
