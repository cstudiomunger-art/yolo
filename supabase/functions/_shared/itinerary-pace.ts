export type TripPace = "relaxed" | "standard" | "intense";
export type DayScheduleProfile = "full_day" | "arrival_day" | "departure_day";

export function defaultPace(tripDays: number, cityCount: number): TripPace {
  if (cityCount <= 0) return "standard";
  return tripDays / cityCount >= 3 ? "standard" : "relaxed";
}

/** Daytime slot budget for a profile + pace (evening is separate). */
export function daySlotCapacityForPace(
  profile: DayScheduleProfile,
  pace: TripPace,
): number {
  if (profile === "departure_day") return 1;
  if (profile === "arrival_day") {
    return pace === "relaxed" ? 1 : 1;
  }
  switch (pace) {
    case "relaxed":
      return 1;
    case "intense":
      return 2.5;
    case "standard":
    default:
      return 2;
  }
}

export function parsePace(raw: string | null | undefined): TripPace {
  const v = String(raw ?? "standard").trim().toLowerCase();
  if (v === "relaxed" || v === "intense") return v;
  return "standard";
}
