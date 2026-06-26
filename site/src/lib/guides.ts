// Typed access to the build-time city-guides snapshot (src/data/guides.json).
// Audio fields are already stripped by the fetch script; here we just shape and nest.

import raw from "../data/guides.json";

export interface City {
  id: string;
  name: string;
  chinese_name: string | null;
  description: string | null;
  best_time_to_visit: string | null;
  avg_days_recommended: number | null;
  emoji: string | null;
  cover_image_path: string | null;
  cover_image_url: string | null;
  display_order: number;
}

export interface PracticalInfoItem {
  icon?: string;
  label: string;
  value: string;
}
export interface NearbyPlace {
  name: string;
  distance: string;
}

export interface Attraction {
  id: string;
  city_id: string;
  name: string;
  chinese_name: string | null;
  category: string;
  cover_image_path: string | null;
  cover_images: string[];
  summary: string | null;
  introduction: string | null;
  short_description: string | null;
  ticket_price: string | null;
  recommended_duration: string | null;
  opening_hours: string | null;
  closed_days: string | null;
  metro_access: string | null;
  requires_advance_booking: boolean;
  practical_info: PracticalInfoItem[];
  western_visitor_tips: string[];
  nearby_places: NearbyPlace[];
  address_en: string | null;
  address_zh: string | null;
  audio_guide_count: number;
  display_order: number;
}

export interface ContentBlock {
  type?: string | null;
  title?: string | null;
  body?: string | null;
  image_path?: string | null;
  imagePath?: string | null;
}

export interface SubArea {
  id: string;
  attraction_id: string;
  name_en: string;
  name_zh: string | null;
  cover_image_path: string | null;
  body: string | null;
  content_blocks: ContentBlock[];
  sort_order: number;
  has_audio: boolean;
}

const data = raw as unknown as { cities: City[]; attractions: Attraction[]; sub_areas: SubArea[] };

export const cities = [...data.cities].sort((a, b) => a.display_order - b.display_order);
export const attractions = data.attractions;
export const subAreas = data.sub_areas;

export const cityCover = (c: City) => c.cover_image_path || c.cover_image_url || null;

export function attractionsForCity(cityId: string): Attraction[] {
  return attractions
    .filter((a) => a.city_id === cityId)
    .sort((a, b) => a.display_order - b.display_order);
}

export function subAreasForAttraction(attractionId: string): SubArea[] {
  return subAreas
    .filter((s) => s.attraction_id === attractionId)
    .sort((a, b) => a.sort_order - b.sort_order);
}

export function cityById(id: string): City | undefined {
  return cities.find((c) => c.id === id);
}
export function attractionById(id: string): Attraction | undefined {
  return attractions.find((a) => a.id === id);
}

/** Total audio guides an attraction unlocks in the app (own + sub-areas) — the teaser count. */
export function audioTeaseCount(a: Attraction): number {
  const sub = subAreasForAttraction(a.id).filter((s) => s.has_audio).length;
  return Math.max(a.audio_guide_count, sub);
}

/** Resolve a content block to a normalized {kind, ...} for rendering. */
export function blockKind(b: ContentBlock): "heading" | "image" | "paragraph" {
  const raw = (b.type ?? "").toLowerCase();
  const img = b.image_path ?? b.imagePath ?? null;
  if (raw === "heading" || raw === "image" || raw === "paragraph") return raw as any;
  if (img || (!raw && !b.title && b.body?.startsWith("http"))) return "image";
  if (b.title && !b.body) return "heading";
  return "paragraph";
}
export const blockImage = (b: ContentBlock) => b.image_path ?? b.imagePath ?? (blockKind(b) === "image" ? b.body ?? null : null);
