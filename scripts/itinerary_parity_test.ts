/**
 * Edge itinerary parity regression (mirrors Swift `plan_itinerary_golden_test.swift`).
 *
 * Run:
 *   deno run --allow-read scripts/itinerary_parity_test.ts
 *
 * Requires Deno: https://deno.land/
 */
import { runParitySuite } from "../supabase/functions/_shared/itinerary-parity-runner.ts";
import type { ParityVectorV1 } from "../supabase/functions/_shared/itinerary-parity.ts";
import {
  runItinerarySchedulerPipeline,
} from "../supabase/functions/_shared/itinerary-scheduler.ts";
import type { AIPlanResponse, AttractionRow } from "../supabase/functions/_shared/itinerary-assembler.ts";
import type { CityMetaRow } from "../supabase/functions/_shared/city-travel-hints.ts";

const vectorsPath = new URL(
  "../supabase/functions/_shared/itinerary-parity-vectors.json",
  import.meta.url,
);
const vectors = JSON.parse(await Deno.readTextFile(vectorsPath)) as ParityVectorV1[];

function testHopDayPlanKeepsFromCityAttractions(): string[] {
  const catalog: AttractionRow[] = [
    {
      id: "forbidden_city",
      city_id: "beijing",
      name: "Forbidden City",
      summary: null,
      cover_image_path: null,
      recommended_duration: "4 hours",
      ticket_price: null,
      audio_guide_count: 0,
      display_order: 1,
      priority: "P0",
    },
    {
      id: "nanjing_wall",
      city_id: "nanjing",
      name: "City Wall",
      summary: null,
      cover_image_path: null,
      recommended_duration: "4 hours",
      ticket_price: null,
      audio_guide_count: 0,
      display_order: 1,
      priority: "P0",
    },
  ];
  const citiesMeta: CityMetaRow[] = [
    { id: "beijing", region: "north_china" },
    { id: "nanjing", region: "yangtze_delta" },
  ];
  const aiPlan: AIPlanResponse = {
    day_plans: [
      {
        day_index: 2,
        city_id: "nanjing",
        hop_from_city_id: "beijing",
        attraction_ids: ["forbidden_city", "nanjing_wall"],
      },
    ],
  };
  const result = runItinerarySchedulerPipeline({
    cityIds: ["beijing", "nanjing"],
    tripDays: 4,
    catalog,
    citiesMeta,
    aiPlan,
    entryCityId: "beijing",
    exitCityId: "nanjing",
    pace: "standard",
  });
  const day2 = result.assignments.find((a) => a.day_index === 2);
  const ids = day2?.attraction_ids ?? [];
  const errors: string[] = [];
  if (!ids.includes("forbidden_city")) {
    errors.push("beijing morning sight forbidden_city was filtered from hop day");
  }
  if (!ids.includes("nanjing_wall")) {
    errors.push("nanjing afternoon sight nanjing_wall missing from hop day");
  }
  return errors;
}

const { fails, messages } = runParitySuite(vectors);
for (const line of messages) console.log(line);

const hopErrors = testHopDayPlanKeepsFromCityAttractions();
if (hopErrors.length === 0) {
  console.log("✓ AI hop day_plans keep from-city attractions");
} else {
  console.log("✗ AI hop day_plans keep from-city attractions");
  for (const err of hopErrors) console.log(`  - ${err}`);
}

const totalFails = fails + (hopErrors.length > 0 ? 1 : 0);

if (totalFails === 0) {
  console.log(`\n✅ Itinerary parity tests passed (${vectors.length} vectors + hop filter)`);
  Deno.exit(0);
}

console.log(`\n❌ ${totalFails} itinerary parity test(s) failed`);
Deno.exit(1);
