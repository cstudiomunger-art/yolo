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

export function isClosedOnDate(input: VisitScheduleLike, date: Date): boolean {
  return isClosedOnWeekday(input, weekdayFromDate(date));
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
