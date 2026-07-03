/** Parse HH:mm and classify arrival/departure windows for slot shaping. */

export function parseMinuteOfDay(hhmm: string | null | undefined): number | null {
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

/** Arrival at or after 14:00 → first activity day is evening-only for daytime sights. */
export function isAfternoonArrival(arrivalTime: string | null | undefined): boolean {
  const mins = parseMinuteOfDay(arrivalTime);
  return mins != null && mins >= 14 * 60;
}

/** Departure before 12:00 → last activity day has reduced daytime budget. */
export function isMorningDeparture(departureTime: string | null | undefined): boolean {
  const mins = parseMinuteOfDay(departureTime);
  return mins != null && mins < 12 * 60;
}

export function formatTimeLabel(hhmm: string | null | undefined): string {
  const mins = parseMinuteOfDay(hhmm);
  if (mins == null) return "";
  const h = Math.floor(mins / 60);
  const m = mins % 60;
  return `${String(h).padStart(2, "0")}:${String(m).padStart(2, "0")}`;
}
