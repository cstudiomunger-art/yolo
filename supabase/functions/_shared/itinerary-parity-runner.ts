import {
  buildItineraryPipeline,
  type AttractionRow,
  type SampleItinerary,
} from "./itinerary-assembler.ts";
import type { CityMetaRow } from "./city-travel-hints.ts";
import { weekdayFromDate, type Weekday } from "./itinerary-visit-hours.ts";
import type { ParityExpectV1, ParityInputV1, ParityVectorV1 } from "./itinerary-parity.ts";

type ParityAttractionInput = ParityInputV1["attractions"][number];

function durationLabel(slots: number | null | undefined): string | null {
  if (slots == null) return null;
  if (slots >= 2) return "full day";
  if (slots <= 0.5) return "2 hours";
  return "4 hours";
}

export function parityInputToCatalog(
  attractions: ParityAttractionInput[],
): AttractionRow[] {
  return attractions.map((raw) => ({
    id: raw.id,
    city_id: raw.city_id,
    name: raw.id,
    summary: null,
    cover_image_path: null,
    recommended_duration: durationLabel(raw.duration_slots),
    ticket_price: null,
    audio_guide_count: 0,
    display_order: raw.display_order ?? 0,
    priority: raw.priority ?? "P1",
    planning_zone: raw.planning_zone ?? null,
    recommended_visit_period: raw.recommended_visit_period ?? null,
    closed_weekdays: raw.closed_weekdays ?? null,
    open_time: raw.open_time ?? null,
    close_time: raw.close_time ?? null,
    last_entry_time: raw.last_entry_time ?? null,
    closed_days: raw.closed_days ?? null,
  }));
}

export function parityInputToCitiesMeta(
  cities: ParityInputV1["cities"],
): CityMetaRow[] {
  return cities.map((c) => ({
    id: c.id,
    region: c.region ?? null,
  }));
}

export function runParityVector(vector: ParityVectorV1): SampleItinerary {
  const { input } = vector;
  const tripDays = Math.max(1, input.trip.trip_days ?? 1);
  const cityIds = input.cities.map((c) => c.id);
  const catalog = parityInputToCatalog(input.attractions);

  return buildItineraryPipeline({
    cityIds,
    tripDays,
    catalog,
    citiesMeta: parityInputToCitiesMeta(input.cities),
    aiPlan: null,
    entryCityId: input.trip.entry_city_id ?? null,
    exitCityId: input.trip.exit_city_id ?? null,
    startDateLocal: input.trip.start_date_local ?? null,
    pace: input.trip.pace ?? null,
  });
}

function activitySlots(trip: SampleItinerary): Map<string, Set<string>> {
  const out = new Map<string, Set<string>>();
  for (const day of trip.days) {
    for (const act of day.activities) {
      const id = act.attraction_id;
      if (!id) continue;
      const slots = out.get(id) ?? new Set<string>();
      slots.add(act.time_slot.toLowerCase());
      out.set(id, slots);
    }
  }
  return out;
}

function scheduledOnWeekday(
  trip: SampleItinerary,
  attractionId: string,
  weekday: Weekday,
  startDateLocal: string | null | undefined,
): boolean {
  if (!startDateLocal) return false;
  const start = new Date(`${startDateLocal}T00:00:00`);
  if (Number.isNaN(start.getTime())) return false;

  for (const day of trip.days) {
    const date = new Date(start);
    date.setDate(date.getDate() + (day.day_index - 1));
    if (weekdayFromDate(date) !== weekday) continue;
    if (day.activities.some((a) => a.attraction_id === attractionId)) return true;
  }
  return false;
}

export function assertParityExpect(
  trip: SampleItinerary,
  expect: ParityExpectV1,
  input: ParityInputV1,
): string[] {
  const errors: string[] = [];
  const slotsById = activitySlots(trip);

  if (expect.trip_days != null && trip.days.length !== expect.trip_days) {
    errors.push(`expected ${expect.trip_days} days, got ${trip.days.length}`);
  }

  if (expect.no_duplicate_ids !== false) {
    const seen = new Set<string>();
    for (const day of trip.days) {
      for (const act of day.activities) {
        const id = act.attraction_id;
        if (!id) continue;
        if (seen.has(id)) errors.push(`duplicate attraction id scheduled: ${id}`);
        seen.add(id);
      }
    }
  }

  for (const id of expect.evening_slot_ids ?? []) {
    const slots = slotsById.get(id) ?? new Set();
    if (!slots.has("evening")) {
      errors.push(`${id} expected Evening slot, got ${[...slots].join(", ") || "none"}`);
    }
  }

  for (const id of expect.afternoon_slot_ids ?? []) {
    const slots = slotsById.get(id) ?? new Set();
    if (!slots.has("afternoon")) {
      errors.push(`${id} expected Afternoon slot, got ${[...slots].join(", ") || "none"}`);
    }
  }

  for (const id of expect.no_daytime_ids ?? []) {
    const slots = slotsById.get(id) ?? new Set();
    if (slots.has("morning") || slots.has("afternoon")) {
      errors.push(`${id} should not use daytime slots, got ${[...slots].join(", ")}`);
    }
  }

  for (const rule of expect.not_on_weekday ?? []) {
    if (scheduledOnWeekday(trip, rule.id, rule.weekday, input.trip.start_date_local)) {
      errors.push(`${rule.id} should not appear on ${rule.weekday}`);
    }
  }

  for (const id of expect.dropped_ids ?? []) {
    const scheduled = trip.days.some((d) =>
      d.activities.some((a) => a.attraction_id === id)
    );
    const dropped = trip.dropped_attraction_ids?.includes(id) ?? false;
    if (scheduled && !dropped) {
      errors.push(`${id} expected dropped or unscheduled, but appears in itinerary`);
    }
  }

  return errors;
}

export function runParitySuite(vectors: ParityVectorV1[]): { fails: number; messages: string[] } {
  let fails = 0;
  const messages: string[] = [];

  for (const vector of vectors) {
    const trip = runParityVector(vector);
    const expect = vector.expect ?? { no_duplicate_ids: true };
    const errors = assertParityExpect(trip, expect, vector.input);

    if (errors.length === 0) {
      messages.push(`✓ ${vector.name}`);
    } else {
      fails += 1;
      messages.push(`✗ ${vector.name}`);
      for (const err of errors) messages.push(`  - ${err}`);
    }
  }

  return { fails, messages };
}
