#!/usr/bin/env python3
"""导出 visa.db → Codable 兼容的 visa_dataset.json（camelCase），供 Swift 引擎回归 harness 用。
键名与 VisaDataSet 的 Swift 属性一一对应，AllowedArea 编码为 "national" 字符串或码数组。"""
import sqlite3, json, os

SRC = os.path.expanduser("~/Desktop/YOLOHAPYY签证检查器/数据/visa.db")
OUT = os.path.expanduser("~/Desktop/YOLO/scripts/visa_dataset.json")
SLUG = {"110000": "beijing", "310000": "shanghai", "610100": "xian",
        "510100": "chengdu", "320500": "suzhou", "330100": "hangzhou"}


def jarr(v):
    return json.loads(v) if v else None


def area(v):
    a = json.loads(v) if v else "national"
    return a  # "national" 或 list


def main():
    con = sqlite3.connect(SRC); con.row_factory = sqlite3.Row
    policies = [{
        "id": p["id"], "policyType": p["policy_type"],
        "nodeKind": "info" if p["id"] == "visa_L" else "computed",
        "universal": bool(p["universal"]),
        "officialNameZh": p["official_name_zh"], "officialNameEn": p["official_name_en"],
        "onwardTicket": bool(p["onward_ticket"]), "onwardThirdCountry": bool(p["onward_third_country"]),
        "groupRequired": bool(p["group_required"]), "entryPortLimited": bool(p["entry_port_limited"]),
        "entryPorts": jarr(p["entry_ports"]), "exitPorts": jarr(p["exit_ports"]), "entryMode": jarr(p["entry_mode"]),
        "maxStayDefault": p["max_stay_default"], "maxStayUnit": p["max_stay_unit"], "clockRule": p["clock_rule"],
        "allowedArea": area(p["allowed_area"]), "passportValidityMonths": p["passport_validity_months"],
        "priority": p["priority"], "sourceUrl": p["source_url"], "lastVerified": p["last_verified"],
    } for p in con.execute("SELECT * FROM policies")]

    grants = [{
        "id": f"{g['policy_id']}_{g['country_code']}".lower(), "policyId": g["policy_id"],
        "countryCode": g["country_code"], "effectiveDate": g["effective_date"] or "1900-01-01",
        "expiryDate": g["expiry_date"], "maxStayOverride": g["max_stay_override"],
    } for g in con.execute("SELECT * FROM policy_grants")]

    cities = [{
        "cityId": c["city_id"], "nameZh": c["name_zh"], "nameEn": c["name_en"],
        "regionType": c["region_type"], "isEntryPort": bool(c["is_entry_port"]),
        "isExitPort": bool(c["is_exit_port"]), "transit240h": bool(c["transit_240h"]),
        "appCitySlug": SLUG.get(c["city_id"]),
    } for c in con.execute("SELECT * FROM cities")]

    matrix = [{"cityId": m["city_id"], "policyId": m["policy_id"], "feasibility": m["feasibility"]}
              for m in con.execute("SELECT * FROM city_policy_matrix")]

    permitZones = [{"adminCode": z["admin_code"], "name": z["name"], "note": z["note"]}
                   for z in con.execute("SELECT * FROM permit_zones")]

    data = {"policies": policies, "grants": grants, "cities": cities,
            "matrix": matrix, "permitZones": permitZones}
    with open(OUT, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False)
    print(f"✓ {OUT}: policies={len(policies)} grants={len(grants)} cities={len(cities)} matrix={len(matrix)}")


if __name__ == "__main__":
    main()
