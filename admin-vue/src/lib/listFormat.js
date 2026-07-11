import {
  CHECKLIST_TYPE_LABELS,
  CHECKLIST_PHASE_LABELS,
  CHECKLIST_PRIORITY_LABELS,
} from "@/schema/tables";

/**
 * Format a list cell for TableList — mirrors legacy admin formatListCell.
 * Returns { kind: 'text'|'tag'|'img', text?, on?, src? }
 */
export function formatListCell(col, row, refCache) {
  const key = typeof col === "string" ? col : col.key;
  const v = row[key];

  if (typeof col === "object" && col.format === "checklist_type") {
    return { kind: "text", text: CHECKLIST_TYPE_LABELS[v] || v || "—" };
  }
  if (typeof col === "object" && col.format === "checklist_phase") {
    return { kind: "text", text: CHECKLIST_PHASE_LABELS[v] || v || "—" };
  }
  if (typeof col === "object" && col.format === "checklist_priority") {
    return { kind: "text", text: CHECKLIST_PRIORITY_LABELS[v] || v || "—" };
  }
  if (typeof col === "object" && col.ref === "city") {
    return { kind: "text", text: refCache.cityLabel(v) };
  }
  if (typeof col === "object" && col.ref === "countries") {
    const ids = Array.isArray(v) ? v : [];
    if (!ids.length) return { kind: "text", text: "全部", muted: true };
    return { kind: "text", text: ids.map((id) => refCache.countryLabel(id)).join(", ") };
  }
  if (typeof col === "object" && col.ref === "cities") {
    const ids = Array.isArray(v) ? v : [];
    if (!ids.length) return { kind: "text", text: "—", muted: true };
    return { kind: "text", text: ids.map((id) => refCache.cityLabel(id)).join(", ") };
  }
  if (typeof col === "object" && col.format === "has_audio") {
    const url = (v || "").trim();
    return { kind: "tag", text: url ? "有音频" : "无音频", on: !!url };
  }
  if (typeof col === "object" && col.format === "user_email") {
    return { kind: "text", text: refCache.userLabel(v) };
  }
  if (typeof col === "object" && col.format === "purchased_count") {
    const n = Array.isArray(v) ? v.length : 0;
    return { kind: "tag", text: String(n), on: n > 0 };
  }
  if (typeof col === "object" && col.format === "duration_mmss") {
    const sec = Number(v);
    if (!Number.isFinite(sec) || sec <= 0) return { kind: "text", text: "—" };
    const m = Math.floor(sec / 60);
    const s = sec % 60;
    return { kind: "text", text: `${m}:${String(s).padStart(2, "0")}` };
  }
  if (typeof col === "object" && col.format === "duration_slot") {
    const n = Number(v);
    if (!Number.isFinite(n)) return { kind: "text", text: "—", muted: true };
    const labels = { 0.5: "0.5 半日", 1: "1 标准", 2: "2 全日", 3: "3+ 远郊" };
    return { kind: "tag", text: labels[n] || String(n), on: n >= 1 };
  }
  if (typeof col === "object" && col.ref === "attraction") {
    return { kind: "text", text: refCache.attractionLabel(v) };
  }
  if (typeof col === "object" && col.ref === "scenario") {
    return { kind: "text", text: refCache.scenarioLabel(v) };
  }
  if (typeof col === "object" && col.ref === "country") {
    return { kind: "text", text: refCache.countryLabel(v) };
  }
  if (typeof col === "object" && col.ref === "visa_country") {
    return { kind: "text", text: refCache.visaCountryLabel(v) };
  }
  if (typeof col === "object" && col.type === "image_thumb") {
    if (!v) return { kind: "text", text: "—" };
    return { kind: "img", src: String(v) };
  }
  if (typeof v === "boolean") {
    return { kind: "tag", text: v ? "是" : "否", on: v };
  }
  if (v === null || v === undefined || v === "") {
    return { kind: "text", text: "—", muted: true };
  }
  if (Array.isArray(v)) return { kind: "text", text: v.join(", ") };
  return { kind: "text", text: String(v) };
}
