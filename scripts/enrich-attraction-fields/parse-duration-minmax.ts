/** Parse recommended_duration text → duration_slots_min/max drafts for CMS review. */
import { parseDurationSlots } from "../../supabase/functions/_shared/itinerary-duration.ts";

export function durationMinMaxDraft(recommendedDuration: string | null | undefined): {
  duration_slots_min: number;
  duration_slots_max: number;
} {
  const slots = parseDurationSlots(recommendedDuration);
  return { duration_slots_min: slots, duration_slots_max: slots };
}

if (import.meta.main) {
  console.log("parse-duration-minmax: stub — export SQL via output/p0-upsert.sql after batch");
}
