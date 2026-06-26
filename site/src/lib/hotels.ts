// Typed access to the build-time hotels snapshot (src/data/hotels.json), grouped by city.
// Powers the filterable foreigner-friendly hotel directory.

import raw from "../data/hotels.json";
import { cities as guideCities } from "./guides";

export interface BookingLink {
  url: string;
  label: string;
}

export interface Hotel {
  id: string;
  city_id: string;
  name: string;
  chinese_name: string | null;
  cover_image_path: string | null;
  address_en: string | null;
  address_zh: string | null;
  latitude: number | null;
  longitude: number | null;
  stars: number;
  price_min_usd: number;
  has_english_staff: boolean;
  english_staff_note: string | null;
  language_tip: string | null;
  location_note: string | null;
  booking_platforms: string[];
  booking_links: BookingLink[];
  accepts_foreigners: boolean;
  sort_order: number;
}

export const hotels = raw as unknown as Hotel[];

/** Notes are richtext in the CMS — render as plain text (strip tags) on cards. */
export const text = (s: string | null | undefined): string =>
  s ? s.replace(/<[^>]+>/g, " ").replace(/\s+/g, " ").trim() : "";

const cityName = (id: string): string =>
  guideCities.find((c) => c.id === id)?.name ?? id.charAt(0).toUpperCase() + id.slice(1).replace(/[-_]/g, " ");

export interface CityHotels {
  city_id: string;
  name: string;
  hotels: Hotel[];
}

export const hotelsByCity: CityHotels[] = (() => {
  const map = new Map<string, Hotel[]>();
  for (const h of hotels) {
    if (!map.has(h.city_id)) map.set(h.city_id, []);
    map.get(h.city_id)!.push(h);
  }
  return [...map.entries()]
    .map(([city_id, list]) => ({
      city_id,
      name: cityName(city_id),
      hotels: list.sort((a, b) => a.sort_order - b.sort_order || b.stars - a.stars),
    }))
    .sort((a, b) => b.hotels.length - a.hotels.length || a.name.localeCompare(b.name));
})();

export const totalHotels = hotels.length;
export const cityCount = hotelsByCity.length;
export const mapHref = (h: Hotel): string | null => {
  if (h.latitude != null && h.longitude != null) return `https://maps.google.com/?q=${h.latitude},${h.longitude}`;
  const addr = h.address_en || h.address_zh;
  return addr ? `https://maps.google.com/?q=${encodeURIComponent(addr)}` : null;
};
