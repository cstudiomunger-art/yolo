import Foundation

// Minimal stand-ins for the app view-model types (real ones live in TravelSafetyModels.swift,
// which pulls in unrelated emergency types). The harness only exercises the engine logic.
struct VisaDetail: Codable { let label: String; let value: String }
struct VisaRule: Codable {
    let countryCode: String; let countryName: String; let flag: String
    let visaFree: Bool; let stayDays: Int?; let headline: String; let details: [VisaDetail]
}

// Standalone regression harness for the Swift VisaPolicyEngine port. Decodes the full
// verified dataset (visa_dataset.json) and asserts the Swift engine matches engine.py
// ground truth on representative cases (captured from engine.py on the same visa.db).
// Compile with VisaPolicyModels.swift + VisaPolicyEngine.swift + VisaFreshness.swift.

func isoUTC(_ s: String) -> Date {
    let f = DateFormatter()
    f.calendar = Calendar(identifier: .gregorian)
    f.locale = Locale(identifier: "en_US_POSIX")
    f.timeZone = TimeZone(identifier: "UTC")
    f.dateFormat = "yyyy-MM-dd'T'HH:mm"
    return f.date(from: s)!
}

let here = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
let jsonURL = here.appendingPathComponent("visa_dataset.json")
let data = try! Data(contentsOf: jsonURL)
let dataset = try! JSONDecoder().decode(VisaDataSet.self, from: data)

struct Case {
    let id: String
    let q: VisaQuery
    let level: VisaLevel
    let chosen: String
}

func q(_ cc: String, _ dep: String, _ onward: String?, entry: String, exit: String,
       entryAt: String, plannedExit: String, cities: [String], ticketed: Bool, group: Bool) -> VisaQuery {
    VisaQuery(countryCode: cc, departure: dep, onward: onward, entryPort: entry, exitPort: exit,
              entryAt: isoUTC(entryAt), plannedExitAt: isoUTC(plannedExit), cities: cities,
              ticketed: ticketed, group: group, passportValidMonths: nil, today: isoUTC("2026-06-22T00:00"))
}

let cases: [Case] = [
    // GT-02 直通：法国人往返同国直飞 → 绿牌单方面（240h 因非第三国被排除，体现资格过滤）
    Case(id: "GT-02 FR direct", q: q("FR", "FR", "FR", entry: "PVG", exit: "PVG",
        entryAt: "2026-07-02T15:00", plannedExit: "2026-07-14T10:00",
        cities: ["110000", "140200", "140800", "310000"], ticketed: true, group: false),
        level: .green, chosen: "unilateral_30d"),
    // GT-01 冲突：美国人含运城超界 → 黄牌（全量库择优落 hainan_30d，与 engine.py 一致）
    Case(id: "GT-01 US transit+运城", q: q("US", "TH", "KR", entry: "PVG", exit: "PVG",
        entryAt: "2026-07-02T15:00", plannedExit: "2026-07-14T10:00",
        cities: ["110000", "140200", "140800", "310000"], ticketed: true, group: false),
        level: .amber, chosen: "hainan_30d"),
    // GT-G 印度散客直飞北京 → 红牌 visa_L（团免随团门槛 + 无单方面 grant）
    Case(id: "GT-G IN solo", q: q("IN", "IN", "IN", entry: "PEK", exit: "PEK",
        entryAt: "2026-07-02T15:00", plannedExit: "2026-07-10T10:00",
        cities: ["110000"], ticketed: false, group: false),
        level: .red, chosen: "visa_L"),
    // 240h 绿牌：美国人从日本来、去韩国、续程票、停留 7 天、城市在区内 → 绿牌 240h
    Case(id: "240h green US", q: q("US", "JP", "KR", entry: "PVG", exit: "PVG",
        entryAt: "2026-07-02T15:00", plannedExit: "2026-07-09T10:00",
        cities: ["110000", "310000"], ticketed: true, group: false),
        level: .green, chosen: "twov_240h"),
    // 互免绿牌：新加坡人直飞 → 绿牌互免
    Case(id: "mutual SG green", q: q("SG", "SG", "SG", entry: "PVG", exit: "PVG",
        entryAt: "2026-07-02T15:00", plannedExit: "2026-07-14T10:00",
        cities: ["110000", "310000"], ticketed: true, group: false),
        level: .green, chosen: "mutual_exempt"),
]

var fails = 0
for c in cases {
    let r = VisaPolicyEngine.recommend(c.q, data: dataset)
    let ok = r.level == c.level && r.chosenPolicyId == c.chosen
    print("\(ok ? "✓" : "✗") \(c.id): level=\(r.level.rawValue) chosen=\(r.chosenPolicyId)"
          + (ok ? "" : "  EXPECTED level=\(c.level.rawValue) chosen=\(c.chosen)"))
    if !ok { fails += 1 }
}

// Timing 纠正：单方面 30 天 next_day_0000 → 入境 7/2 → 次日 0 时 +30 天 = 8/2 00:00（不是 8/1）。
let uni = dataset.policy("unilateral_30d")!
let (latest, _) = VisaPolicyEngine.computeLatestExit(policy: uni, entryAt: isoUTC("2026-07-02T15:00"), grant: nil)
let expected = isoUTC("2026-08-02T00:00")
let timeOk = abs(latest.timeIntervalSince(expected)) < 1
print("\(timeOk ? "✓" : "✗") timing next_day_0000: latest=\(ISO8601DateFormatter().string(from: latest))")
if !timeOk { fails += 1 }

// 24h by_hour：入境精确时刻 7/2 15:00 +24h = 7/3 15:00。
let twov24 = dataset.policy("twov_24h")!
let (l24, _) = VisaPolicyEngine.computeLatestExit(policy: twov24, entryAt: isoUTC("2026-07-02T15:00"), grant: nil)
let exp24 = isoUTC("2026-07-03T15:00")
let t24Ok = abs(l24.timeIntervalSince(exp24)) < 1
print("\(t24Ok ? "✓" : "✗") timing by_hour(24h): latest=\(ISO8601DateFormatter().string(from: l24))")
if !t24Ok { fails += 1 }

// Phase 2 路线推荐：美国人往返日本 8 天（基线 amber，不够用）→ 路线层加香港作过境出口
// → 引擎复核应激活 240h 绿牌（加城 = 二期亮点，引擎验证非猜测）。
let baseQ = q("US", "JP", "JP", entry: "PVG", exit: "PVG",
              entryAt: "2026-07-02T15:00", plannedExit: "2026-07-09T10:00",
              cities: ["110000", "310000"], ticketed: true, group: false)
let baseRec = VisaPolicyEngine.recommend(baseQ, data: dataset)
let p2routes = VisaTripChecker.routes(query: baseQ, appCities: ["beijing", "shanghai"],
                                      data: dataset, recommendation: baseRec)
let friendly = p2routes.first { $0.kind == .friendly }
let p2ok = !baseRec.isEnough && friendly?.addedCity?.contains("香港") == true
print("\(p2ok ? "✓" : "✗") Phase2 加城激活240h: base=\(baseRec.level.rawValue) friendly=\(friendly?.addedCity ?? "无")")
if !p2ok { fails += 1 }

// Phase 2 §1 粗判：法国人行程(北京+上海)默认往返 → 绿牌单方面；美国人同行程 → 非绿(需进检测器细调)。
let frCoarse = VisaCoarseCheck.recommendation(citySlugs: ["beijing", "shanghai"], start: nil, end: nil,
                                              countryCode: "FR", data: dataset)
let usCoarse = VisaCoarseCheck.recommendation(citySlugs: ["beijing", "shanghai"], start: nil, end: nil,
                                              countryCode: "US", data: dataset)
let coarseOk = frCoarse?.level == .green && usCoarse != nil && usCoarse?.isEnough == false
print("\(coarseOk ? "✓" : "✗") Phase2 粗判: FR=\(frCoarse?.level.rawValue ?? "nil") US=\(usCoarse?.level.rawValue ?? "nil")")
if !coarseOk { fails += 1 }

// 国籍级摘要（替代旧 visa_rules 单国卡）：法国→免签30天；美国→非免签但有条件(240h/海南)；冷门国→需签证。
let frSum = VisaNationalitySummary.rule(countryCode: "FR", countryName: "France", flag: "🇫🇷", data: dataset)
let usSum = VisaNationalitySummary.rule(countryCode: "US", countryName: "United States", flag: "🇺🇸", data: dataset)
let zzSum = VisaNationalitySummary.rule(countryCode: "ZZ", countryName: "Nowhere", flag: "🏳️", data: dataset)
let sumOk = frSum.visaFree && frSum.stayDays == 30
    && !usSum.visaFree && !usSum.headline.isEmpty
    && !zzSum.visaFree && zzSum.headline.isEmpty
print("\(sumOk ? "✓" : "✗") 国籍摘要: FR=免签\(frSum.stayDays ?? 0)天 US=\(usSum.headline) ZZ=\(zzSum.headline.isEmpty ? "需签证" : zzSum.headline)")
if !sumOk { fails += 1 }

print(fails == 0 ? "\n✅ Golden 全过（与 engine.py 全量基准一致）" : "\n❌ \(fails) 项不符")
exit(fails == 0 ? 0 : 1)
