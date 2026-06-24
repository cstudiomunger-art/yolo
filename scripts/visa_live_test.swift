import Foundation

// Live regression harness: decodes the production visa_* tables (fetched to $VISA_DIR)
// and runs the real VisaPolicyEngine / VisaTripChecker / VisaCoarseCheck over scenarios
// that mirror BOTH detector entry paths — the manual selector and the itinerary flow.
// Compile with VisaPolicyModels + VisaPolicyEngine + VisaFreshness + VisaTripChecker
// + VisaCoarseCheck. Not shipped; dev-only.

let dir = ProcessInfo.processInfo.environment["VISA_DIR"]!
func load<T: Decodable>(_ table: String, _ type: T.Type) -> T {
    let url = URL(fileURLWithPath: dir).appendingPathComponent("\(table).json")
    let dec = JSONDecoder(); dec.keyDecodingStrategy = .convertFromSnakeCase
    return try! dec.decode(T.self, from: try! Data(contentsOf: url))
}

let data = VisaDataSet(
    policies: load("visa_policies_v2", [VisaPolicyV2].self),
    grants: load("visa_policy_grants_v2", [VisaGrantV2].self),
    cities: load("visa_cities", [VisaCityRow].self),
    matrix: load("visa_city_policy_matrix", [CityPolicyFeas].self),
    permitZones: load("visa_permit_zones", [PermitZone].self),
    ports: load("visa_ports", [VisaPort].self))

print("loaded: \(data.policies.count) policies · \(data.grants.count) grants · \(data.cities.count) cities · \(data.matrix.count) matrix · \(data.ports.count) ports\n")

func code(_ name: String) -> String {
    data.cities.first { $0.nameZh == name }?.cityId ?? "??\(name)"
}
func dt(_ s: String) -> Date {
    let f = DateFormatter(); f.calendar = Calendar(identifier: .gregorian)
    f.locale = Locale(identifier: "en_US_POSIX"); f.timeZone = .current
    f.dateFormat = "yyyy-MM-dd'T'HH:mm"; return f.date(from: s)!
}
func mk(_ cc: String, dep: String, onward: String?, entry: String, exit: String,
        inAt: String, outAt: String, cities: [String], ticketed: Bool = true,
        group: Bool = false, valid: Int? = nil) -> VisaQuery {
    VisaQuery(countryCode: cc, departure: dep, onward: onward, entryPort: entry, exitPort: exit,
              entryAt: dt(inAt), plannedExitAt: dt(outAt), cities: cities, ticketed: ticketed,
              group: group, passportValidMonths: valid, today: dt("2026-06-23T00:00"))
}

var pass = 0, fail = 0
func check(_ id: String, _ q: VisaQuery, level: VisaLevel, chosen: String? = nil) {
    let r = VisaPolicyEngine.recommend(q, data: data)
    let ok = r.level == level && (chosen == nil || r.chosenPolicyId == chosen)
    ok ? (pass += 1) : (fail += 1)
    let exit = r.latestExitDate.map { ISO8601DateFormatter().string(from: $0).prefix(10) } ?? "—"
    let extra = "stay=\(r.maxStayDays.map(String.init) ?? "—") exit=\(exit) blockers=\(r.blockers.count) fresh=\(r.freshness?.level.rawValue ?? "—")"
    print("\(ok ? "✓" : "✗") \(id)")
    print("    → \(r.level.rawValue) / \(r.chosenPolicyId)  [\(extra)]")
    if !ok { print("    EXPECTED \(level.rawValue)\(chosen.map { " / \($0)" } ?? "")") }
}

let bj = code("北京市"), sh = code("上海市"), cd = code("成都市")
let sanya = data.cities.first { $0.cityId.hasPrefix("46") && $0.nameZh.contains("三亚") }?.cityId
    ?? data.cities.first { $0.cityId.hasPrefix("46") }?.cityId ?? "460300"
let tibet = data.cities.first { $0.cityId.hasPrefix("54") }?.cityId
print("city codes: 北京=\(bj) 上海=\(sh) 成都=\(cd) 三亚区=\(sanya) 西藏区=\(tibet ?? "无")\n")

print("──────── A. 选择器手动输入路径 ────────")
// A1 GB 往返直飞，京沪 12 天 → 绿 单方面30
check("A1 GB 往返 京沪12天", mk("GB", dep: "GB", onward: "GB", entry: "PVG", exit: "PVG",
    inAt: "2026-07-02T12:00", outAt: "2026-07-14T10:00", cities: [bj, sh]), level: .green, chosen: "unilateral_30d")
// A2 US 日本来→韩国去 续程票 7天 → 绿 240h 过境
check("A2 US 日→韩过境 7天", mk("US", dep: "JP", onward: "KR", entry: "PVG", exit: "PVG",
    inAt: "2026-07-02T12:00", outAt: "2026-07-09T10:00", cities: [bj, sh]), level: .green, chosen: "twov_240h")
// A3 SG 往返 → 绿 互免
check("A3 SG 往返 互免", mk("SG", dep: "SG", onward: "SG", entry: "PVG", exit: "PVG",
    inAt: "2026-07-02T12:00", outAt: "2026-07-14T10:00", cities: [bj, sh]), level: .green, chosen: "mutual_exempt")
// A4 IN 散客往返 北京 → 红 visa_L
check("A4 IN 散客 北京", mk("IN", dep: "IN", onward: "IN", entry: "PEK", exit: "PEK",
    inAt: "2026-07-02T12:00", outAt: "2026-07-10T10:00", cities: [bj], ticketed: false), level: .red, chosen: "visa_L")
// A5 GB 护照有效期 < 6 月 → 红 GATE0
check("A5 GB 护照临期 GATE0", mk("GB", dep: "GB", onward: "GB", entry: "PVG", exit: "PVG",
    inAt: "2026-07-02T12:00", outAt: "2026-07-14T10:00", cities: [bj, sh], valid: 3), level: .red, chosen: "GATE0")
// A6 GB 往返但停留 40 天 → 超 30 天上限 → 黄（时间维度 fail）
check("A6 GB 超期40天", mk("GB", dep: "GB", onward: "GB", entry: "PVG", exit: "PVG",
    inAt: "2026-07-02T12:00", outAt: "2026-08-11T10:00", cities: [bj, sh]), level: .amber)
// A7 US 过境但无续程票 → 240h 条件 fail（续程票）→ 黄牌（补续程票即可，非红）
check("A7 US 过境无续程票", mk("US", dep: "JP", onward: "KR", entry: "PVG", exit: "PVG",
    inAt: "2026-07-02T12:00", outAt: "2026-07-09T10:00", cities: [bj, sh], ticketed: false),
    level: .amber, chosen: "twov_240h")
// A8 邮轮：US 随团 海港进出 沿海城市 15 天内 → 绿 邮轮团免
check("A8 US 邮轮随团 上海", mk("US", dep: "US", onward: "US", entry: "CNSHA", exit: "CNSHA",
    inAt: "2026-07-02T12:00", outAt: "2026-07-10T10:00", cities: [sh], group: true), level: .green, chosen: "cruise_15d")
// A9 海南：GB 从 HAK 进出 三亚 → 绿（hainan 或 单方面，取限制更少者）
check("A9 GB 海南 HAK", mk("GB", dep: "GB", onward: "GB", entry: "HAK", exit: "HAK",
    inAt: "2026-07-02T12:00", outAt: "2026-07-14T10:00", cities: [sanya]), level: .green)

print("\n──────── B. 选行程后·粗判路径（VisaCoarseCheck）────────")
func coarse(_ id: String, slugs: [String], cc: String) {
    let r = VisaCoarseCheck.recommendation(citySlugs: slugs, start: dt("2026-07-02T12:00"),
        end: dt("2026-07-14T10:00"), countryCode: cc, data: data)
    if let r { print("• \(id): \(r.level.rawValue) / \(r.chosenPolicyId) blockers=\(r.blockers.count)") }
    else { print("• \(id): nil（无可判城市）") }
}
coarse("GB 京沪", slugs: ["beijing", "shanghai"], cc: "GB")
coarse("IN 京沪", slugs: ["beijing", "shanghai"], cc: "IN")
coarse("US 京沪蓉", slugs: ["beijing", "shanghai", "chengdu"], cc: "US")

print("\n──────── C. 签证友好路线（VisaTripChecker）────────")
func routes(_ id: String, _ q: VisaQuery, slugs: [String]) {
    let r = VisaPolicyEngine.recommend(q, data: data)
    let rs = VisaTripChecker.routes(query: q, appCities: slugs, data: data, recommendation: r)
    print("• \(id): base=\(r.level.rawValue)/\(r.chosenPolicyId) → \(rs.count) 条路线")
    for route in rs { print("    - \(route.title) [\(route.badge)] +\(route.addedCity ?? "无") 城\(route.cities.count)") }
}
// IN 散客（红）→ 应生成 纯兴趣/友好(加港或删城)/备选
routes("IN 散客 京沪", mk("IN", dep: "IN", onward: "IN", entry: "PEK", exit: "PEK",
    inAt: "2026-07-02T12:00", outAt: "2026-07-10T10:00", cities: [bj, sh], ticketed: false),
    slugs: ["beijing", "shanghai"])

// IN 散客（红，每座城都需签证）→ 换城无绿候选 → swap 应优雅返回 nil（无"换城"卡）
let inCat: [(slug: String, popularity: Int)] = [("beijing", 10), ("shanghai", 9), ("chengdu", 8)]
let inQ = mk("IN", dep: "IN", onward: "IN", entry: "PEK", exit: "PEK",
    inAt: "2026-07-02T12:00", outAt: "2026-07-10T10:00", cities: [bj, sh], ticketed: false)
let inRec = VisaPolicyEngine.recommend(inQ, data: data)
let inRoutes = VisaTripChecker.routes(query: inQ, appCities: ["beijing", "shanghai"], data: data, recommendation: inRec, catalog: inCat)
let inNoSwap = !inRoutes.contains { $0.title.contains("换城") }
inNoSwap ? (pass += 1) : (fail += 1)
print("\(inNoSwap ? "✓" : "✗") C2 IN 无绿候选→无换城卡: \(inRoutes.count) 条 \(inRoutes.map { $0.title }.joined(separator: " / "))")

print("\n──────── D. 换城策略 + 静默放行（合成数据集，验证新算法）────────")
func pol(_ id: String, priority: Int) -> VisaPolicyV2 {
    VisaPolicyV2(id: id, policyType: "test", nodeKind: id == "visa_L" ? "info" : "computed",
        universal: false, officialNameZh: id, officialNameEn: id,
        onwardTicket: false, onwardThirdCountry: false, groupRequired: false, entryPortLimited: false,
        entryPorts: nil, exitPorts: nil, entryMode: nil, maxStayDefault: 30, maxStayUnit: "days",
        clockRule: "next_day_0000", entryCount: nil, allowedArea: .national, passportOrdinaryOnly: nil,
        purpose: nil, passportValidityMonths: nil, priority: priority, sourceUrl: nil, lastVerified: nil)
}
func city(_ code: String, _ zh: String, _ slug: String) -> VisaCityRow {
    VisaCityRow(cityId: code, nameZh: zh, nameEn: slug, regionType: "mainland",
        isEntryPort: true, isExitPort: true, transit240h: false, appCitySlug: slug)
}
let synth = VisaDataSet(
    policies: [pol("uni", priority: 1), pol("visa_L", priority: 99)],
    grants: [VisaGrantV2(id: "g1", policyId: "uni", countryCode: "XX", effectiveDate: nil,
        expiryDate: nil, maxStayOverride: nil, entryCountOverride: nil, announcedDate: nil, evidenceQuote: nil)],
    cities: [city("110000", "甲市", "acity"), city("990000", "乙市", "bcity"), city("120000", "丙市", "ccity")],
    matrix: [CityPolicyFeas(cityId: "110000", policyId: "uni", feasibility: "ok"),
             CityPolicyFeas(cityId: "990000", policyId: "uni", feasibility: "no"),
             CityPolicyFeas(cityId: "120000", policyId: "uni", feasibility: "ok")],
    permitZones: [], ports: [])
func synthQ(_ codes: [String]) -> VisaQuery {
    VisaQuery(countryCode: "XX", departure: "XX", onward: "XX", entryPort: nil, exitPort: nil,
        entryAt: dt("2026-07-02T12:00"), plannedExitAt: dt("2026-07-10T10:00"), cities: codes,
        ticketed: true, group: false, passportValidMonths: nil, today: dt("2026-06-23T00:00"))
}
let synthCat: [(slug: String, popularity: Int)] = [("acity", 10), ("bcity", 5), ("ccity", 8)]

// D1: 含拖累城（乙市不可达）→ 引擎复核应把乙市换成丙市，城数不变且全程绿
let q1 = synthQ(["110000", "990000"])
let r1 = VisaPolicyEngine.recommend(q1, data: synth)
let routes1 = VisaTripChecker.routes(query: q1, appCities: ["acity", "bcity"], data: synth, recommendation: r1, catalog: synthCat)
let swap = routes1.first { $0.title.contains("换城") }
let d1 = r1.level == .amber && !r1.blockers.isEmpty && swap?.cities == ["acity", "ccity"]
d1 ? (pass += 1) : (fail += 1)
print("\(d1 ? "✓" : "✗") D1 换城: base=\(r1.level.rawValue) blockers=\(r1.blockers.count) → swap=\(swap?.cities.joined(separator: "+") ?? "无")")

// D2: 全可达（甲+丙）→ isEnough → routes 为空（静默放行）
let q2 = synthQ(["110000", "120000"])
let r2 = VisaPolicyEngine.recommend(q2, data: synth)
let routes2 = VisaTripChecker.routes(query: q2, appCities: ["acity", "ccity"], data: synth, recommendation: r2, catalog: synthCat)
let d2 = r2.level == .green && r2.isEnough && routes2.isEmpty
d2 ? (pass += 1) : (fail += 1)
print("\(d2 ? "✓" : "✗") D2 全免签静默放行: base=\(r2.level.rawValue) isEnough=\(r2.isEnough) routes=\(routes2.count)")

print("\n════════ 结果：\(pass) 通过 / \(fail) 失败 ════════")
exit(fail == 0 ? 0 : 1)
