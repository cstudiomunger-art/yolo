// Typed access to the build-time city-guides snapshot (src/data/guides.json).
// Audio fields are already stripped by the fetch script; here we just shape and nest.

import raw from "../data/guides.json";
import sanitizeHtml from "sanitize-html";

const DEFAULT_SUPABASE_URL = "https://edwvrriuwzaaqznklrgi.supabase.co";
const SUPABASE_URL = (import.meta.env.PUBLIC_SUPABASE_URL || DEFAULT_SUPABASE_URL).replace(/\/+$/, "");
const COVER_BUCKET = "cover-images";

/** Full URL passthrough; relative storage path -> Supabase public URL. */
export function resolveCoverImageUrl(raw: string | null | undefined, bucket = COVER_BUCKET): string | null {
  const trimmed = String(raw ?? "").trim();
  if (!trimmed) return null;
  if (/^https?:\/\//i.test(trimmed)) return trimmed;

  let path = trimmed.replace(/^\/+/, "");
  const storagePrefix = "storage/v1/object/public/";
  if (path.startsWith(storagePrefix)) {
    const rest = path.slice(storagePrefix.length);
    if (rest.startsWith(`${bucket}/`)) return `${SUPABASE_URL}/storage/v1/object/public/${rest}`;
  }

  const prefix = `${bucket}/`;
  if (path.startsWith(prefix)) path = path.slice(prefix.length);
  if (!path) return null;
  return `${SUPABASE_URL}/storage/v1/object/public/${bucket}/${path}`;
}

// CMS body fields (introduction / description / sub-area body / content blocks) are
// rendered with set:html, so they must be sanitized. This runs at BUILD only (SSG) —
// sanitize-html never reaches the client bundle. Defense-in-depth against stored XSS
// even though CMS writes are admin-only (RLS is_admin()).
export function clean(html: string | null | undefined): string {
  if (!html) return "";
  return sanitizeHtml(html, {
    allowedTags: [
      "p", "br", "hr", "strong", "b", "em", "i", "u", "s", "blockquote",
      "ul", "ol", "li", "h2", "h3", "h4", "h5", "span", "a", "img", "figure", "figcaption",
    ],
    allowedAttributes: {
      a: ["href", "title", "target", "rel"],
      img: ["src", "alt", "title", "loading"],
      span: [],
    },
    allowedSchemes: ["https", "http", "mailto"],
    // Force safe link behavior; strip on* handlers / style / class via allowlist above.
    transformTags: {
      a: sanitizeHtml.simpleTransform("a", { rel: "noopener nofollow ugc", target: "_blank" }),
    },
    disallowedTagsMode: "discard",
  });
}

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

export const cities = data.cities
  .map((c) => ({ ...c, cover_image_path: resolveCoverImageUrl(c.cover_image_path) }))
  .sort((a, b) => a.display_order - b.display_order);

export const attractions = data.attractions.map((a) => ({
  ...a,
  cover_image_path: resolveCoverImageUrl(a.cover_image_path),
  cover_images: (a.cover_images || []).map((img) => resolveCoverImageUrl(img) || "").filter(Boolean),
}));

export const subAreas = data.sub_areas.map((s) => ({
  ...s,
  cover_image_path: resolveCoverImageUrl(s.cover_image_path),
  content_blocks: (s.content_blocks || []).map((b) => ({
    ...b,
    image_path: resolveCoverImageUrl(b.image_path),
    imagePath: resolveCoverImageUrl(b.imagePath),
  })),
}));

export const cityCover = (c: City) => c.cover_image_path || c.cover_image_url || null;

export function attractionsForCity(cityId: string): Attraction[] {
  const list = attractions.filter((a) => a.city_id === cityId);
  const byKey = new Map<string, Attraction>();
  for (const item of list) {
    const key = (item.chinese_name || item.name || item.id).trim().toLowerCase();
    const prev = byKey.get(key);
    if (!prev) {
      byKey.set(key, item);
      continue;
    }
    const score = (a: Attraction) =>
      (a.cover_image_path ? 100 : 0) +
      ((a.practical_info?.length || 0) > 0 ? 40 : 0) +
      ((a.summary?.length || 0) > 0 ? 20 : 0) -
      (a.display_order ?? 0);
    if (score(item) > score(prev)) byKey.set(key, item);
  }
  return [...byKey.values()].sort((a, b) => a.display_order - b.display_order);
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
