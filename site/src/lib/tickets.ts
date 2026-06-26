// Curated ticket-pain-point dataset (src/data/ticket-attractions.json). Mirrors the visa
// architecture: a generic tool (/attraction-tickets) + per-attraction SEO pages
// (/attraction-tickets/[slug]). Edit the JSON to add attractions or fill exact figures;
// precise release schedules are optional and only render once verified data is provided.

import raw from "../data/ticket-attractions.json";

export interface TicketAttraction {
  slug: string;
  name: string;
  name_zh: string;
  city: string;
  status: "live" | "coming-soon";
  blurb: string;
  advance_days: number | null;
  release_time: string | null; // e.g. "20:00 Asia/Shanghai"; null → no countdown shown
  closed: string | null;
  official_url: string | null;
  passport_required: boolean;
  rules: string[];
  passport_note: string | null;
}

export const ticketAttractions = raw as TicketAttraction[];

export const ticketBySlug = (slug: string): TicketAttraction | undefined =>
  ticketAttractions.find((t) => t.slug === slug);
