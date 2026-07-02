#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Generate Supabase seed SQL for five-city attractions from Desktop Markdown folders."""
from __future__ import annotations

import json
import os
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
CONFIG_PATH = Path(__file__).resolve().parent / "city-attractions-config.json"
MIGRATIONS_DIR = ROOT / "supabase" / "migrations"

SECTION_PATTERNS = {
    "name": re.compile(r"名字|^\s*name\s*$", re.I),
    "summary": re.compile(r"一句话"),
    "desc300": re.compile(r"300"),
    "address": re.compile(r"详细地址|detailed\s+address", re.I),
    "ticket": re.compile(r"门票|ticket", re.I),
    "hours": re.compile(r"开放时间|opening\s+hours", re.I),
    "transport": re.compile(r"交通|transport", re.I),
}

CJK_RE = re.compile(r"[\u4e00-\u9fff]")


def load_config() -> dict:
    with open(CONFIG_PATH, encoding="utf-8") as f:
        return json.load(f)


def sql_str(value: str | None) -> str:
    if value is None:
        return "NULL"
    return "'" + value.replace("'", "''") + "'"


def sql_bool(value: bool) -> str:
    return "TRUE" if value else "FALSE"


def cjk_ratio(text: str) -> float:
    if not text.strip():
        return 0.0
    return len(CJK_RE.findall(text)) / max(len(text), 1)


def split_sections(text: str) -> list[tuple[str, str]]:
    parts = re.split(r"(?m)^##\s+", text)
    sections: list[tuple[str, str]] = []
    for part in parts[1:]:
        if not part.strip():
            continue
        lines = part.split("\n", 1)
        header = lines[0].strip()
        body = lines[1] if len(lines) > 1 else ""
        sections.append((header, body))
    return sections


def find_section(sections: list[tuple[str, str]], key: str) -> str:
    pattern = SECTION_PATTERNS[key]
    for header, body in sections:
        if pattern.search(header):
            return body
    return ""


def strip_rules(text: str) -> str:
    return re.sub(r"(?m)^---+\s*$", "", text).strip()


def extract_marked_block(body: str, markers: tuple[str, ...]) -> str | None:
    for marker in markers:
        idx = body.find(marker)
        if idx < 0:
            continue
        rest = body[idx + len(marker) :]
        rest = re.split(r"\*\*中文", rest, maxsplit=1)[0]
        return rest.strip()
    return None


def extract_zh_block(body: str) -> str | None:
    m = re.search(r"\*\*中文[^*]*\*\*\s*\n?(.*)", body, re.DOTALL)
    if not m:
        return None
    chunk = m.group(1)
    chunk = re.split(r"\*\*(?:English|EN)", chunk, maxsplit=1)[0]
    return chunk.strip()


def extract_en_block(body: str) -> str:
    body = strip_rules(body)
    marked = extract_marked_block(
        body,
        (
            "**English:**",
            "**English: **",
            "**EN:**",
            "**EN: **",
        ),
    )
    if marked:
        return marked.strip()

    # Hangzhou-style inline EN label on same line as content
    m = re.search(
        r"\*\*(?:English|EN)(?:\s*/[^*]*)?:\*\*\s*(.+?)(?:\n\n|\Z)",
        body,
        re.DOTALL | re.IGNORECASE,
    )
    if m:
        return m.group(1).strip()

    # Beijing/Chongqing style: English lines follow Chinese lines (often single newlines)
    english_lines: list[str] = []
    for raw in body.splitlines():
        line = raw.strip()
        if not line:
            continue
        if line.startswith("**中文"):
            continue
        if re.match(r"^\*\*(?:English|EN)", line, re.I):
            line = re.sub(r"^\*\*(?:English|EN)[^*]*\*\*\s*", "", line).strip()
        if line and cjk_ratio(line) < 0.2:
            english_lines.append(line)

    if english_lines:
        return "\n".join(english_lines).strip()

    # Fallback: paragraph blocks that are mostly English
    chunks = re.split(r"\n\s*\n", body)
    english_chunks: list[str] = []
    for chunk in chunks:
        chunk = chunk.strip()
        if not chunk or chunk.startswith("**中文"):
            continue
        if re.match(r"^\*\*(?:English|EN)", chunk, re.I):
            english_chunks.append(re.sub(r"^\*\*(?:English|EN)[^*]*\*\*\s*", "", chunk).strip())
            continue
        if cjk_ratio(chunk) < 0.2:
            english_chunks.append(chunk)

    if english_chunks:
        return "\n\n".join(english_chunks).strip()

    return ""


def strip_frontmatter(text: str) -> str:
    text = text.strip()
    if text.startswith("---"):
        m = re.match(r"^---\s*\r?\n.*?\r?\n---\s*\r?\n", text, re.DOTALL)
        if m:
            return text[m.end() :].strip()
    return text


def parse_title(text: str) -> tuple[str | None, str | None]:
    text = strip_frontmatter(text)
    lines = [ln.strip() for ln in text.splitlines() if ln.strip()]
    if not lines:
        return None, None

    title_line = lines[0]
    if title_line.startswith("#"):
        title_line = title_line.lstrip("#").strip()

    if "/" in title_line:
        left, right = title_line.split("/", 1)
        return left.strip(), right.strip()

    chinese = title_line.strip("* ").strip()
    english = None
    if len(lines) > 1:
        nxt = lines[1].strip()
        if nxt.startswith("**") and nxt.endswith("**"):
            english = nxt.strip("* ").strip()
    return chinese, english


def parse_name_section(section_body: str) -> tuple[str | None, str | None]:
    zh = extract_zh_block(section_body)
    en = extract_en_block(section_body)
    if zh:
        zh = re.sub(r"^\*\*中文[^*]*\*\*\s*", "", zh).strip()
        zh = zh.split("\n")[0].strip("* ").strip()
    if en:
        en = en.split("\n")[0].strip("* ").strip()

    lines = [ln.strip() for ln in section_body.splitlines() if ln.strip()]
    if lines:
        first = lines[0].strip("* ").strip()
        second = lines[1].strip("* ").strip() if len(lines) > 1 else None
        if not zh and cjk_ratio(first) >= 0.2:
            zh = first
        if not en and second and cjk_ratio(second) < 0.2:
            en = second

    return zh, en


def extract_closed_days(opening_en: str) -> str | None:
    for line in opening_en.splitlines():
        line = line.strip()
        if re.match(r"^-?\s*Closed\b", line, re.I):
            return line.lstrip("- ").strip()
    return None


def extract_recommended_duration(opening_en: str) -> str | None:
    for line in opening_en.splitlines():
        line = line.strip()
        if re.search(r"\bhours\b", line, re.I) and re.search(r"\bNote\b", line, re.I):
            return line.lstrip("- ").strip()
    return None


def requires_advance_booking(ticket_en: str) -> bool:
    lower = ticket_en.lower()
    return "reservation" in lower or "预约" in ticket_en


def build_practical_info(parsed: dict) -> list[dict]:
    """Build practical_info rows from ticket / hours / transport EN sections (verbatim)."""
    rows: list[tuple[str, str, str]] = [
        ("🎫", "Ticket", parsed.get("ticket_price") or ""),
        ("🕐", "Duration", parsed.get("recommended_duration") or ""),
        ("🕘", "Opening Hours", parsed.get("opening_hours") or ""),
        ("❌", "Closed", parsed.get("closed_days") or ""),
        ("🚇", "Metro", parsed.get("metro_access") or ""),
    ]
    return [
        {"icon": icon, "label": label, "value": value.strip()}
        for icon, label, value in rows
        if value and value.strip()
    ]


def sql_jsonb(value) -> str:
    return sql_str(json.dumps(value, ensure_ascii=False)) + "::jsonb"


def parse_markdown(path: Path) -> dict:
    text = strip_frontmatter(path.read_text(encoding="utf-8"))
    sections = split_sections(text)

    name_section = find_section(sections, "name")
    if name_section:
        chinese_name, english_name = parse_name_section(name_section)
    else:
        chinese_name, english_name = parse_title(text)

    if chinese_name in ("---", "{}"):
        chinese_name = None
    if english_name in ("---", "{}"):
        english_name = None

    summary = extract_en_block(find_section(sections, "summary"))
    introduction = extract_en_block(find_section(sections, "desc300"))
    address_section = find_section(sections, "address")
    address_zh = extract_zh_block(address_section)
    if address_zh:
        address_zh = address_zh.strip()
    address_en = extract_en_block(address_section)
    ticket_en = extract_en_block(find_section(sections, "ticket"))
    opening_en = extract_en_block(find_section(sections, "hours"))
    transport_en = extract_en_block(find_section(sections, "transport"))

    return {
        "name": english_name or chinese_name or "",
        "chinese_name": chinese_name or "",
        "summary": summary,
        "introduction": introduction,
        "address_zh": address_zh,
        "address_en": address_en,
        "ticket_price": ticket_en,
        "opening_hours": opening_en,
        "metro_access": transport_en,
        "closed_days": extract_closed_days(opening_en),
        "recommended_duration": extract_recommended_duration(opening_en),
        "requires_advance_booking": requires_advance_booking(ticket_en),
    }


def render_attraction_insert(entry: dict, parsed: dict, cover_path: str | None) -> str:
    attr_id = entry["id"]
    iap = f"com.chinago.travel.attraction.{attr_id}"
    practical_info = build_practical_info(parsed)
    return f"""INSERT INTO attractions (
  id, city_id, name, chinese_name, category, cover_image_path, summary, introduction,
  priority, ticket_price, recommended_duration, opening_hours, closed_days,
  requires_advance_booking, metro_access, practical_info, western_visitor_tips, nearby_places,
  address_en, address_zh, audio_guide_count, iap_product_id, display_order, is_published
) VALUES (
  {sql_str(attr_id)}, {sql_str(entry['city_id'])}, {sql_str(parsed['name'])}, {sql_str(parsed['chinese_name'])},
  {sql_str(entry['category'])}, {sql_str(cover_path)}, {sql_str(parsed['summary'])}, {sql_str(parsed['introduction'])},
  {sql_str(entry['priority'])}, {sql_str(parsed['ticket_price'])}, {sql_str(parsed['recommended_duration'])},
  {sql_str(parsed['opening_hours'])}, {sql_str(parsed['closed_days'])},
  {sql_bool(parsed['requires_advance_booking'])}, {sql_str(parsed['metro_access'])},
  {sql_jsonb(practical_info)}, '[]'::jsonb, '[]'::jsonb,
  {sql_str(parsed['address_en'])}, {sql_str(parsed['address_zh'])},
  0, {sql_str(iap)}, {entry['order']}, TRUE
) ON CONFLICT (id) DO UPDATE SET
  city_id = EXCLUDED.city_id, name = EXCLUDED.name, chinese_name = EXCLUDED.chinese_name,
  category = EXCLUDED.category, cover_image_path = EXCLUDED.cover_image_path,
  summary = EXCLUDED.summary, introduction = EXCLUDED.introduction,
  priority = EXCLUDED.priority, ticket_price = EXCLUDED.ticket_price,
  recommended_duration = EXCLUDED.recommended_duration, opening_hours = EXCLUDED.opening_hours,
  closed_days = EXCLUDED.closed_days, requires_advance_booking = EXCLUDED.requires_advance_booking,
  metro_access = EXCLUDED.metro_access, practical_info = EXCLUDED.practical_info,
  western_visitor_tips = EXCLUDED.western_visitor_tips, nearby_places = EXCLUDED.nearby_places,
  address_en = EXCLUDED.address_en, address_zh = EXCLUDED.address_zh,
  audio_guide_count = EXCLUDED.audio_guide_count, iap_product_id = EXCLUDED.iap_product_id,
  display_order = EXCLUDED.display_order, is_published = EXCLUDED.is_published, updated_at = NOW();
"""


def render_cities_migration(config: dict) -> str:
    lines = [
        "-- Seed: Nanjing + Chongqing cities and attraction_count updates",
        "-- Idempotent: ON CONFLICT (id) DO UPDATE",
        "",
    ]
    for city in config["new_cities"]:
        best_for = "ARRAY[" + ", ".join(sql_str(x) for x in city["best_for"]) + "]::TEXT[]"
        lines.append(
            f"""INSERT INTO cities (
  id, name, chinese_name, emoji, cover_image_path, description, best_for,
  season_note, best_time_to_visit, avg_days_recommended, attraction_count,
  display_order, is_published
) VALUES (
  {sql_str(city['id'])}, {sql_str(city['name'])}, {sql_str(city['chinese_name'])}, {sql_str(city['emoji'])},
  NULL, {sql_str(city['description'])}, {best_for},
  {sql_str(city.get('season_note'))}, {sql_str(city['best_time_to_visit'])}, {city['avg_days_recommended']}, 0,
  {city['display_order']}, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name, chinese_name = EXCLUDED.chinese_name, emoji = EXCLUDED.emoji,
  description = EXCLUDED.description, best_for = EXCLUDED.best_for,
  season_note = EXCLUDED.season_note, best_time_to_visit = EXCLUDED.best_time_to_visit,
  avg_days_recommended = EXCLUDED.avg_days_recommended, display_order = EXCLUDED.display_order,
  is_published = EXCLUDED.is_published, updated_at = NOW();
"""
        )

    for city_key, meta in config["cities"].items():
        lines.append(
            f"UPDATE cities SET attraction_count = {meta['attraction_count']}, updated_at = NOW() "
            f"WHERE id = {sql_str(meta['city_id'])};"
        )
    return "\n".join(lines) + "\n"


def resolve_cover_path(entry: dict, config: dict) -> str | None:
    if entry["md"] in config.get("no_cover", []):
        return None
    return f"attractions/{entry['id']}.png"


def resolve_png_path(folder: Path, md_basename: str, config: dict) -> Path | None:
    png_name = config.get("png_aliases", {}).get(md_basename, md_basename)
    candidate = folder / f"{png_name}.png"
    if candidate.exists():
        return candidate
    return None


def main() -> None:
    config = load_config()
    MIGRATIONS_DIR.mkdir(parents=True, exist_ok=True)

    cities_out = MIGRATIONS_DIR / "113_seed_cities_nanjing_chongqing.sql"
    cities_out.write_text(render_cities_migration(config), encoding="utf-8")
    print("written:", cities_out)

    by_city: dict[str, list] = {}
    for item in config["attractions"]:
        by_city.setdefault(item["city"], []).append(item)

    for city_key, entries in by_city.items():
        meta = config["cities"][city_key]
        folder = Path(meta["folder"])
        parts = [
            f"-- Seed: {meta['city_id']} attractions from Desktop Markdown",
            "-- Text fields = verbatim English sections from source docs.",
            "-- practical_info = Ticket / Duration / Opening Hours / Closed / Metro from MD sections.",
            "-- Idempotent: ON CONFLICT (id) DO UPDATE",
            "",
        ]
        for entry in sorted(entries, key=lambda x: x["order"]):
            md_path = folder / f"{entry['md']}.md"
            if not md_path.exists():
                raise FileNotFoundError(md_path)
            parsed = parse_markdown(md_path)
            entry_with_city = {
                **entry,
                "city_id": meta["city_id"],
            }
            cover = resolve_cover_path(entry, config)
            if cover and not resolve_png_path(folder, entry["md"], config):
                print(f"warning: missing PNG for {entry['md']} ({city_key}), cover set NULL")
                cover = None
            parts.append(render_attraction_insert(entry_with_city, parsed, cover))

        out_path = MIGRATIONS_DIR / meta["migration"]
        out_path.write_text("\n".join(parts), encoding="utf-8")
        print("written:", out_path, f"({len(entries)} attractions)")


if __name__ == "__main__":
    main()
