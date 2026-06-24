#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Generate Supabase seed SQL for 成都武侯祠 (Wuhou Shrine) attraction + 10 sub_areas.
Body content = EN audio-guide scripts (EN_解说词-武侯祠/). audio_url left empty.
"""
import os, re, html

SRC = "/Users/vesperal/Desktop/武侯祠/EN_解说词-武侯祠"
OUT = "/Users/vesperal/Desktop/YOLO/supabase/migrations/084_seed_wuhou_shrine.sql"

ATTR_ID = "chengdu_wuhou_shrine"
CITY_ID = "chengdu"

# (sort_order, sub_area_id, source filename, name_en, name_zh)
SUBS = [
    (0, "chengdu_wuhou_sa_01", "EN_1.南门与照壁.md",            "South Gate & Spirit Wall",                       "南门与照壁"),
    (1, "chengdu_wuhou_sa_02", "EN_2.大门（汉昭烈庙）.md",        "Main Gate (Han Zhaolie Temple)",                 "大门（汉昭烈庙）"),
    (2, "chengdu_wuhou_sa_03", "EN_3.二门与唐碑（三绝碑）.md",     "Second Gate & the Stele of Three Perfections",   "二门与唐碑（三绝碑）"),
    (3, "chengdu_wuhou_sa_04", "EN_4.刘备殿（汉昭烈庙正殿）.md",    "Liu Bei Hall",                                   "刘备殿（汉昭烈庙正殿）"),
    (4, "chengdu_wuhou_sa_05", "EN_5.过厅（出师表石刻）.md",       "The Passageway (Chu Shi Biao Carvings)",         "过厅（出师表石刻）"),
    (5, "chengdu_wuhou_sa_06", "EN_6.诸葛亮殿（静远堂）.md",       "Zhuge Liang Hall (Jingyuan Hall)",               "诸葛亮殿（静远堂）"),
    (6, "chengdu_wuhou_sa_07", "EN_7.三义庙.md",                "Sanyi Temple (Temple of the Three Oaths)",       "三义庙"),
    (7, "chengdu_wuhou_sa_08", "EN_8.桂荷楼、琴亭与园林区.md",     "Garden: Guihe Tower, Qin & Tingli Pavilions",    "桂荷楼、琴亭与园林区"),
    (8, "chengdu_wuhou_sa_09", "EN_9.惠陵（刘备墓）.md",          "Huiling Mausoleum (Tomb of Liu Bei)",            "惠陵（刘备墓）"),
    (9, "chengdu_wuhou_sa_10", "EN_10.结束语：锦里与水榭.md",      "Jinli Street (Conclusion)",                      "锦里与水榭（结束语）"),
]


def md_to_html(text: str) -> str:
    # strip leading frontmatter block: --- \n {} \n ---
    text = text.strip()
    text = re.sub(r"^---\s*\n.*?\n---\s*\n", "", text, count=1, flags=re.DOTALL)
    lines = text.split("\n")

    blocks = []           # list of ("p"|"ul", payload)
    para_buf = []
    list_buf = []

    def flush_para():
        if para_buf:
            blocks.append(("p", " ".join(para_buf).strip()))
            para_buf.clear()

    def flush_list():
        if list_buf:
            blocks.append(("ul", list_buf[:]))
            list_buf.clear()

    for raw in lines:
        line = raw.rstrip()
        if line.strip() == "":
            flush_para(); flush_list(); continue
        if re.match(r"^\s*-\s+", line):
            flush_para()
            list_buf.append(re.sub(r"^\s*-\s+", "", line).strip())
        else:
            flush_list()
            para_buf.append(line.strip())
    flush_para(); flush_list()

    def inline(s: str) -> str:
        s = html.escape(s, quote=False)
        s = re.sub(r"\*\*(.+?)\*\*", r"<strong>\1</strong>", s)
        return s

    out = []
    for kind, payload in blocks:
        if kind == "p":
            out.append("<p>" + inline(payload) + "</p>")
        else:
            items = "".join("<li>" + inline(it) + "</li>" for it in payload)
            out.append("<ul>" + items + "</ul>")
    return "".join(out)


def sql_str(s: str) -> str:
    if s is None:
        return "NULL"
    return "'" + s.replace("'", "''") + "'"


def main():
    parts = []
    parts.append("""-- Seed: 成都武侯祠 Wuhou Shrine (attraction + 10 sub_areas)
-- Body = EN audio-guide scripts. audio_url left empty (upload mp3 in CMS later).
-- Idempotent: ON CONFLICT (id) DO UPDATE. Assumes city 'chengdu' already exists.
""")

    # ---- attraction ----
    intro = ("The Wuhou Shrine Museum is China's only shrine jointly dedicated to a ruler "
             "and his minister, honoring the heroes of the Shu Han kingdom — Liu Bei, Zhuge Liang, "
             "Guan Yu and Zhang Fei. Founded in 223 AD and standing for over 1,780 years, it is the "
             "most globally influential museum of Three Kingdoms culture, known as the “Sacred "
             "Ground of the Three Kingdoms.” The 153,300 m² grounds bring together historical "
             "relics, classical gardens and the lively Jinli folk-culture street.")
    summary = ("China's only shrine jointly honoring a ruler and his minister — the holy ground of "
               "Three Kingdoms culture.")
    tips = ('["Admission is ¥50 per person; students and visitors over 60 pay half price (¥25).",'
            '"Open 9 AM–6 PM with last entry at 5 PM; come on a weekday right at opening to beat the crowds.",'
            '"Walk the Red Wall Passage by Huiling for the shrine’s most photogenic bamboo-shaded corridor.",'
            '"Exit south into Jinli Ancient Street for Sichuan street food and Three Kingdoms souvenirs."]')
    nearby = ('[{"name":"Jinli Ancient Street","distance":"Adjacent (south exit)"},'
              '{"name":"Sichuan Provincial Library","distance":"10 min walk"}]')

    parts.append(f"""INSERT INTO attractions (
  id, city_id, name, chinese_name, category, cover_image_path, summary, introduction,
  priority, ticket_price, recommended_duration, opening_hours, closed_days,
  requires_advance_booking, metro_access, western_visitor_tips, nearby_places,
  address_en, address_zh, audio_guide_count, iap_product_id, display_order, is_published
) VALUES (
  {sql_str(ATTR_ID)}, {sql_str(CITY_ID)}, {sql_str('Wuhou Shrine')}, {sql_str('武侯祠')},
  {sql_str('temple')}, NULL, {sql_str(summary)}, {sql_str(intro)},
  {sql_str('P0')}, {sql_str('¥50 (~$7)')}, {sql_str('2–3 hours')},
  {sql_str('9:00 AM – 6:00 PM (last entry 5:00 PM)')}, NULL,
  FALSE, {sql_str('Line 3 · Gaoshengqiao')},
  {sql_str(tips)}::jsonb, {sql_str(nearby)}::jsonb,
  {sql_str('231 Wuhou Ci Street, Wuhou District, Chengdu')}, {sql_str('四川省成都市武侯区武侯祠大街231号')},
  10, NULL, 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  city_id = EXCLUDED.city_id, name = EXCLUDED.name, chinese_name = EXCLUDED.chinese_name,
  category = EXCLUDED.category, summary = EXCLUDED.summary, introduction = EXCLUDED.introduction,
  priority = EXCLUDED.priority, ticket_price = EXCLUDED.ticket_price,
  recommended_duration = EXCLUDED.recommended_duration, opening_hours = EXCLUDED.opening_hours,
  metro_access = EXCLUDED.metro_access, western_visitor_tips = EXCLUDED.western_visitor_tips,
  nearby_places = EXCLUDED.nearby_places, address_en = EXCLUDED.address_en,
  address_zh = EXCLUDED.address_zh, audio_guide_count = EXCLUDED.audio_guide_count,
  is_published = EXCLUDED.is_published, updated_at = NOW();
""")

    # ---- sub_areas ----
    parts.append("\n-- sub_areas (子景点) — body = EN audio-guide script, audio_url empty\n")
    for order, sid, fname, name_en, name_zh in SUBS:
        with open(os.path.join(SRC, fname), encoding="utf-8") as f:
            body_html = md_to_html(f.read())
        parts.append(f"""INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active
) VALUES (
  {sql_str(sid)}, {sql_str(ATTR_ID)}, {sql_str(name_en)}, {sql_str(name_zh)},
  NULL, {sql_str(body_html)}, '', {order}, TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id, name_en = EXCLUDED.name_en, name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body, sort_order = EXCLUDED.sort_order, is_active = EXCLUDED.is_active,
  updated_at = NOW();
""")

    with open(OUT, "w", encoding="utf-8") as f:
        f.write("\n".join(parts))
    print("written:", OUT)


if __name__ == "__main__":
    main()
