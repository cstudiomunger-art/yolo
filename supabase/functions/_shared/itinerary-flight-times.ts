/** Parse HH:mm and classify arrival/departure windows for slot shaping. */

import { commuteSlots } from "./city-travel-hints.ts";
import { daySlotCapacityForPace, type TripPace } from "./itinerary-pace.ts";

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

export function isEveningArrival(arrivalTime: string | null | undefined): boolean {
  const mins = parseMinuteOfDay(arrivalTime);
  return mins != null && mins >= 17 * 60;
}

export function formatTimeLabel(hhmm: string | null | undefined): string {
  const mins = parseMinuteOfDay(hhmm);
  if (mins == null) return "";
  const h = Math.floor(mins / 60);
  const m = mins % 60;
  return `${String(h).padStart(2, "0")}:${String(m).padStart(2, "0")}`;
}

export function suggestedArrivalAtDestination(travelHours: number): string {
  const depart = 9 * 60;
  const arrive = depart + Math.round(travelHours * 60);
  const h = Math.min(23, Math.floor(arrive / 60));
  const m = arrive % 60;
  return `${String(h).padStart(2, "0")}:${String(m).padStart(2, "0")}`;
}

export type DestinationWindows = {
  daytimeCap: number;
  eveningCap: number;
  allowsMorningOrigin: boolean;
  resolvedArrival: string | null;
};

export function destinationWindows(params: {
  arrivalAtDestination?: string | null;
  travelHours?: number | null;
  pace: TripPace;
  isTravelDay: boolean;
  hopKind?: string | null;
}): DestinationWindows {
  const { arrivalAtDestination, travelHours, pace, isTravelDay, hopKind } = params;
  const trimmed = String(arrivalAtDestination ?? "").trim();
  const arrival = trimmed.length > 0
    ? trimmed
    : (travelHours != null ? suggestedArrivalAtDestination(travelHours) : null);

  const mins = parseMinuteOfDay(arrival);
  if (mins == null) {
    const base = daySlotCapacityForPace("full_day", pace);
    const allowsMorning = travelHours != null
      ? destinationWindows({
        arrivalAtDestination: suggestedArrivalAtDestination(travelHours),
        travelHours: null,
        pace,
        isTravelDay: false,
      }).allowsMorningOrigin
      : true;
    return { daytimeCap: base, eveningCap: 1, allowsMorningOrigin: allowsMorning, resolvedArrival: arrival };
  }

  if (mins >= 17 * 60) {
    return { daytimeCap: 0, eveningCap: 1, allowsMorningOrigin: false, resolvedArrival: arrival };
  }
  if (mins >= 14 * 60) {
    return {
      daytimeCap: isTravelDay ? 0 : 1,
      eveningCap: 1,
      allowsMorningOrigin: false,
      resolvedArrival: arrival,
    };
  }
  if (mins >= 12 * 60) {
    return { daytimeCap: 1, eveningCap: 0, allowsMorningOrigin: false, resolvedArrival: arrival };
  }

  const base = daySlotCapacityForPace("full_day", pace);
  let daytimeCap = isTravelDay ? Math.max(1, base - 1) : Math.max(0, base - 1);
  if (
    hopKind
    && ["hop", "travel_lite", "short_hop"].includes(hopKind)
    && mins < 17 * 60
  ) {
    daytimeCap = Math.max(1, daytimeCap);
  }
  return { daytimeCap, eveningCap: 1, allowsMorningOrigin: true, resolvedArrival: arrival };
}

export function hopDaySightBudget(params: {
  hopKind: string;
  pace: TripPace;
  arrivalAtDestination?: string | null;
  travelHours?: number | null;
  slotDayCapacity: number;
}): {
  destDaytimeCap: number;
  eveningCap: number;
  allowsMorningOrigin: boolean;
  commuteCost: number;
} {
  const { hopKind, pace, arrivalAtDestination, travelHours, slotDayCapacity } = params;
  const windows = destinationWindows({
    arrivalAtDestination,
    travelHours,
    pace,
    isTravelDay: hopKind === "travel",
    hopKind,
  });
  const commuteCost = travelHours != null ? commuteSlots(travelHours) : 0;
  if (hopKind === "travel") {
    return {
      destDaytimeCap: 0,
      eveningCap: windows.eveningCap,
      allowsMorningOrigin: windows.allowsMorningOrigin,
      commuteCost,
    };
  }
  if (hopKind === "short_hop") {
    return {
      destDaytimeCap: Math.min(slotDayCapacity, windows.daytimeCap),
      eveningCap: windows.eveningCap,
      allowsMorningOrigin: windows.allowsMorningOrigin,
      commuteCost: 0,
    };
  }
  return {
    destDaytimeCap: Math.min(slotDayCapacity, windows.daytimeCap),
    eveningCap: windows.eveningCap,
    allowsMorningOrigin: windows.allowsMorningOrigin,
    commuteCost,
  };
}

export function remainingDaytimeCapacity(params: {
  arrivalAtDestination?: string | null;
  pace: TripPace;
  isTravelDay: boolean;
}): number {
  return destinationWindows({
    arrivalAtDestination: params.arrivalAtDestination,
    travelHours: null,
    pace: params.pace,
    isTravelDay: params.isTravelDay,
  }).daytimeCap;
}

export function allowsMorningInOriginCity(
  travelHours: number,
  arrivalAtDestination?: string | null,
): boolean {
  return destinationWindows({
    arrivalAtDestination,
    travelHours,
    pace: "standard",
    isTravelDay: false,
  }).allowsMorningOrigin;
}
