export type Weekday = "mon" | "tue" | "wed" | "thu" | "fri" | "sat" | "sun";
export type HalfDaySlot = "morning" | "afternoon";

export type VisitScheduleLike = {
  closed_weekdays?: string[] | null;
  open_time?: string | null;
  close_time?: string | null;
  last_entry_time?: string | null;
};

function parseMinute(hhmm: string | null | undefined): number | null {
  const raw = String(hhmm ?? "").trim();
  if (!raw) return null;
  const m = raw.match(/^(\d{1,2}):(\d{2})$/);
  if (!m) return null;
  const h = Number(m[1]);
  const min = Number(m[2]);
  if (!Number.isFinite(h) || !Number.isFinite(min) || h < 0 || h > 23 || min < 0 || min > 59) {
    return null;
  }
  return h * 60 + min;
}

function normalizeWeekday(value: string): Weekday | null {
  const raw = value.trim().toLowerCase();
  if (raw.startsWith("mon")) return "mon";
  if (raw.startsWith("tue")) return "tue";
  if (raw.startsWith("wed")) return "wed";
  if (raw.startsWith("thu")) return "thu";
  if (raw.startsWith("fri")) return "fri";
  if (raw.startsWith("sat")) return "sat";
  if (raw.startsWith("sun")) return "sun";
  return null;
}

export function weekdayFromDate(date: Date): Weekday {
  const n = date.getDay();
  return (["sun", "mon", "tue", "wed", "thu", "fri", "sat"][n] as Weekday);
}

export function isClosedOnWeekday(input: VisitScheduleLike, weekday: Weekday): boolean {
  const list = Array.isArray(input.closed_weekdays) ? input.closed_weekdays : [];
  return list.some((v) => normalizeWeekday(String(v)) === weekday);
}

export function parseWeekdaysFromClosedDays(text: string | null | undefined): Weekday[] {
  const raw = String(text ?? "").trim().toLowerCase();
  if (!raw) return [];
  const out = new Set<Weekday>();
  const map: [string, Weekday][] = [
    ["monday", "mon"], ["mon", "mon"],
    ["tuesday", "tue"], ["tue", "tue"],
    ["wednesday", "wed"], ["wed", "wed"],
    ["thursday", "thu"], ["thu", "thu"],
    ["friday", "fri"], ["fri", "fri"],
    ["saturday", "sat"], ["sat", "sat"],
    ["sunday", "sun"], ["sun", "sun"],
  ];
  for (const [token, key] of map) {
    if (raw.includes(token)) out.add(key);
  }
  return [...out];
}

export function isClosedOnDate(
  input: VisitScheduleLike & { closed_days?: string | null },
  date: Date,
): boolean {
  const weekday = weekdayFromDate(date);
  if (isClosedOnWeekday(input, weekday)) return true;
  return parseWeekdaysFromClosedDays(input.closed_days).includes(weekday);
}

export function allowedHalfDaySlots(input: VisitScheduleLike): HalfDaySlot[] {
  const open = parseMinute(input.open_time);
  const close = parseMinute(input.close_time);
  const lastEntry = parseMinute(input.last_entry_time);

  if (open == null || close == null) return ["morning", "afternoon"];

  const effectiveLastEntry = lastEntry ?? Math.max(open, close - 30);
  const morningOk = open <= (10 * 60 + 30) && (effectiveLastEntry >= 12 * 60 || close >= 13 * 60);
  const afternoonOk = open <= 14 * 60 && close >= 16 * 60;

  if (morningOk && afternoonOk) return ["morning", "afternoon"];
  if (morningOk) return ["morning"];
  if (afternoonOk) return ["afternoon"];
  return [];
}

export function pickTimeSlot(
  input: VisitScheduleLike,
  preferred: HalfDaySlot | null,
): HalfDaySlot | null {
  const allowed = allowedHalfDaySlots(input);
  if (allowed.length === 0) return null;
  if (preferred && allowed.includes(preferred)) return preferred;
  return allowed[0];
}

export type VisitTimeSlot = "morning" | "afternoon" | "evening";

export type VisitScheduleWithPeriod = VisitScheduleLike & {
  recommended_visit_period?: string | null;
};

function normalizeVisitPeriod(raw: string | null | undefined): VisitTimeSlot | "flexible" {
  const v = String(raw ?? "flexible").trim().toLowerCase();
  if (v === "morning") return "morning";
  if (v === "afternoon") return "afternoon";
  if (v === "evening") return "evening";
  return "flexible";
}

export function isEveningOnlyAttraction(input: VisitScheduleWithPeriod): boolean {
  return normalizeVisitPeriod(input.recommended_visit_period) === "evening";
}

export function visitTimeSlotLabel(slot: VisitTimeSlot | null | undefined): string {
  switch (slot) {
    case "morning":
      return "Morning";
    case "afternoon":
      return "Afternoon";
    case "evening":
      return "Evening";
    default:
      return "";
  }
}

export function pickVisitTimeSlot(
  input: VisitScheduleWithPeriod,
  preferred: VisitTimeSlot | null = null,
): VisitTimeSlot | null {
  switch (normalizeVisitPeriod(input.recommended_visit_period)) {
    case "evening":
      return "evening";
    case "morning":
      return pickTimeSlot(input, "morning") === "morning" ? "morning" : null;
    case "afternoon":
      return pickTimeSlot(input, "afternoon") === "afternoon" ? "afternoon" : null;
    case "flexible": {
      if (preferred === "evening") return null;
      const halfPreferred: HalfDaySlot | null = preferred === "afternoon"
        ? "afternoon"
        : preferred === "morning"
        ? "morning"
        : null;
      const half = pickTimeSlot(input, halfPreferred);
      if (half === "morning") return "morning";
      if (half === "afternoon") return "afternoon";
      return null;
    }
  }
}
