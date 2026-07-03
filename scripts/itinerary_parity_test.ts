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

const vectorsPath = new URL(
  "../supabase/functions/_shared/itinerary-parity-vectors.json",
  import.meta.url,
);
const vectors = JSON.parse(await Deno.readTextFile(vectorsPath)) as ParityVectorV1[];

const { fails, messages } = runParitySuite(vectors);
for (const line of messages) console.log(line);

if (fails === 0) {
  console.log(`\n✅ Itinerary parity tests passed (${vectors.length} vectors)`);
  Deno.exit(0);
}

console.log(`\n❌ ${fails} itinerary parity test(s) failed`);
Deno.exit(1);
