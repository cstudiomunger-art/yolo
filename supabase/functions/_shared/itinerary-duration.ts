export type DayScheduleProfile = "full_day" | "arrival_day" | "departure_day";

export function durationSlotsForRow(row: {
  recommended_duration?: string | null;
  duration_slots_min?: number | null;
}): number {
  if (row.duration_slots_min != null && Number.isFinite(Number(row.duration_slots_min))) {
    return Number(row.duration_slots_min);
  }
  return parseDurationSlots(row.recommended_duration);
}

export function parseDurationSlots(
  recommendedDuration: string | null | undefined,
): number {
  const raw = String(recommendedDuration ?? "").trim().toLowerCase();
  if (!raw) return 1;

  if (
    raw.includes("full day") ||
    raw.includes("all day") ||
    raw.includes("whole day") ||
    raw.includes("全天") ||
    raw.includes("一整天")
  ) return 2;

  const hourMatch = raw.match(/(\d+(?:\.\d+)?)\s*(h|hour|hrs?|小时)/);
  if (hourMatch) {
    const hours = Number(hourMatch[1]);
    if (Number.isFinite(hours)) {
      if (hours <= 3) return 0.5;
      if (hours >= 5) return 2;
      return 1;
    }
  }

  if (raw.includes("half day") || raw.includes("半天")) return 1;
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
