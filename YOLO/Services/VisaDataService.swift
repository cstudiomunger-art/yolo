import Foundation
import Observation
import Supabase

/// Loads the `VisaDataSet` the on-device `VisaPolicyEngine` evaluates (verified v2
/// delivery-package data). Mirrors `PurchaseService.loadPlans`: Supabase is the source
/// of truth; the last good fetch is cached so offline launches still judge against real
/// config; an in-code bundled subset is the last resort (fresh install, no network).
@Observable
@MainActor
final class VisaDataService {

    private(set) var data: VisaDataSet = .empty
    private(set) var isLoading = false

    private static let cacheKey = "yolohappy.cachedVisaDataSet.v2"

    func load() async {
        guard AppConfig.isSupabaseConfigured, !AppConfig.useMock else {
            data = cached() ?? Self.bundledFallback
            return
        }
        isLoading = true
        defer { isLoading = false }
        do {
            let client = SupabaseManager.shared
            async let policies: [VisaPolicyV2] = client.from("visa_policies_v2").select().eq("is_active", value: true).execute().value
            async let grants: [VisaGrantV2] = client.from("visa_policy_grants_v2").select().eq("is_active", value: true).execute().value
            async let cities: [VisaCityRow] = client.from("visa_cities").select().eq("is_active", value: true).execute().value
            async let matrix: [CityPolicyFeas] = client.from("visa_city_policy_matrix").select().eq("is_active", value: true).execute().value
            async let permits: [PermitZone] = client.from("visa_permit_zones").select().eq("is_active", value: true).execute().value

            let set = try await VisaDataSet(
                policies: policies, grants: grants, cities: cities, matrix: matrix, permitZones: permits)
            if set.policies.isEmpty {
                data = cached() ?? Self.bundledFallback
            } else {
                data = set
                cache(set)
            }
        } catch {
            data = cached() ?? Self.bundledFallback
        }
    }

    /// Run a query against the currently-loaded data.
    func evaluate(_ query: VisaQuery) -> VisaRecommendation {
        VisaPolicyEngine.recommend(query, data: data)
    }

    /// Translate app content-city ids → GB/T 2260 codes (drops cities not in the维表).
    func adminCodes(forAppSlugs slugs: [String]) -> [String] {
        slugs.compactMap { data.adminCode(forAppSlug: $0) ?? (data.city(forAdminCode: $0) != nil ? $0 : nil) }
    }

    // MARK: - Cache

    private func cache(_ set: VisaDataSet) {
        if let encoded = try? JSONEncoder().encode(set) {
            UserDefaults.standard.set(encoded, forKey: Self.cacheKey)
        }
    }

    private func cached() -> VisaDataSet? {
        guard let raw = UserDefaults.standard.data(forKey: Self.cacheKey),
              let set = try? JSONDecoder().decode(VisaDataSet.self, from: raw),
              !set.policies.isEmpty else { return nil }
        return set
    }

    // MARK: - Bundled fallback (verified subset; full set comes from Supabase/cache)

    static let bundledFallback: VisaDataSet = {
        func pol(_ id: String, _ type: String, _ nameZh: String, universal: Bool = false,
                 onwardTicket: Bool = false, onwardThird: Bool = false, group: Bool = false,
                 portLimited: Bool = false, entryPorts: [String]? = nil, exitPorts: [String]? = nil,
                 stay: Int?, unit: String, clock: String, area: AllowedArea, priority: Int,
                 nodeKind: String = "computed") -> VisaPolicyV2 {
            VisaPolicyV2(
                id: id, policyType: type, nodeKind: nodeKind, universal: universal,
                officialNameZh: nameZh, officialNameEn: id,
                onwardTicket: onwardTicket, onwardThirdCountry: onwardThird, groupRequired: group,
                entryPortLimited: portLimited, entryPorts: entryPorts, exitPorts: exitPorts, entryMode: nil,
                maxStayDefault: stay, maxStayUnit: unit, clockRule: clock, allowedArea: area,
                passportValidityMonths: 6, priority: priority,
                sourceUrl: nil, lastVerified: "2026-06-22")
        }
        // 240h open ports (subset covering the bundled cities) + nationwide省/地级 area subset.
        let p240Ports = ["PEK", "PKX", "PVG", "SHA", "HGH", "CTU", "TFU", "XIY", "CAN", "SZX"]
        let p240Area = AllowedArea.codes(["110000", "310000", "320000", "330000", "510100", "610000"])
        let policies: [VisaPolicyV2] = [
            pol("mutual_exempt", "互免", "互免签证", stay: 30, unit: "days", clock: "next_day_0000", area: .national, priority: 10),
            pol("hainan_30d", "区域免签", "海南免签", portLimited: true, entryPorts: ["HAK", "SYX"], exitPorts: ["HAK", "SYX"], stay: 30, unit: "days", clock: "next_day_0000", area: .codes(["460000"]), priority: 15),
            pol("unilateral_30d", "单方面免签", "单方面免签", stay: 30, unit: "days", clock: "next_day_0000", area: .national, priority: 20),
            pol("twov_24h", "过境免签", "24小时过境免签", universal: true, onwardTicket: true, onwardThird: true, stay: 24, unit: "hours", clock: "by_hour", area: .codes([]), priority: 25),
            pol("twov_240h", "过境免签", "240小时过境免签", onwardTicket: true, onwardThird: true, portLimited: true, entryPorts: p240Ports, exitPorts: p240Ports, stay: 240, unit: "hours", clock: "next_day_0000", area: p240Area, priority: 30),
            pol("group_asean_xsbn", "团体免签", "东盟旅游团西双版纳免签", group: true, portLimited: true, entryPorts: ["JHG", "CNMHN", "MOHAN"], exitPorts: ["JHG", "CNMHN", "MOHAN"], stay: 6, unit: "days", clock: "next_day_0000", area: .codes(["532800"]), priority: 35),
            pol("cruise_15d", "团体免签", "邮轮团免签", universal: true, group: true, portLimited: true, entryPorts: ["PVG", "SHA", "TSN"], exitPorts: ["PVG", "SHA", "TSN"], stay: 15, unit: "days", clock: "next_day_0000", area: .codes(["110000", "310000", "320000", "330000"]), priority: 36),
            pol("visa_L", "普通签证", "普通旅游签证（L签）", stay: 30, unit: "days", clock: "next_day_0000", area: .national, priority: 99, nodeKind: "info"),
        ]

        func grant(_ policy: String, _ cc: String, exp: String? = nil) -> VisaGrantV2 {
            VisaGrantV2(id: "\(policy)_\(cc)".lowercased(), policyId: policy, countryCode: cc,
                        effectiveDate: "1900-01-01", expiryDate: exp, maxStayOverride: nil)
        }
        // Common unilateral-30d nationalities (expiry 2026-12-31, 临期) + 240h transit list.
        let uni = ["FR", "DE", "IT", "NL", "ES", "JP", "GB", "AU", "NZ", "KR", "CH", "IE", "AT", "BE", "LU", "PT", "HU", "NO", "FI", "DK", "PL"]
        let p240 = ["US", "CA", "GB", "FR", "DE", "JP", "AU", "BR", "MX", "RU", "UA", "QA", "NL", "IT", "ES"]
        var grants: [VisaGrantV2] = []
        grants += uni.map { grant("unilateral_30d", $0, exp: "2026-12-31") }
        grants += p240.map { grant("twov_240h", $0) }
        grants += ["SG"].map { grant("mutual_exempt", $0) }   // 互免示例

        // Bundled app content cities (GB/T 2260) with slug mapping.
        let cities: [VisaCityRow] = [
            VisaCityRow(cityId: "110000", nameZh: "北京市", nameEn: "Beijing", regionType: "mainland", isEntryPort: true, isExitPort: true, transit240h: true, appCitySlug: "beijing"),
            VisaCityRow(cityId: "310000", nameZh: "上海市", nameEn: "Shanghai", regionType: "mainland", isEntryPort: true, isExitPort: true, transit240h: true, appCitySlug: "shanghai"),
            VisaCityRow(cityId: "610100", nameZh: "西安市", nameEn: "Xi'an", regionType: "mainland", isEntryPort: true, isExitPort: true, transit240h: true, appCitySlug: "xian"),
            VisaCityRow(cityId: "510100", nameZh: "成都市", nameEn: "Chengdu", regionType: "mainland", isEntryPort: true, isExitPort: true, transit240h: true, appCitySlug: "chengdu"),
            VisaCityRow(cityId: "320500", nameZh: "苏州市", nameEn: "Suzhou", regionType: "mainland", isEntryPort: false, isExitPort: false, transit240h: true, appCitySlug: "suzhou"),
            VisaCityRow(cityId: "330100", nameZh: "杭州市", nameEn: "Hangzhou", regionType: "mainland", isEntryPort: true, isExitPort: true, transit240h: true, appCitySlug: "hangzhou"),
        ]

        // Matrix for the bundled cities (national policies = ok; 240h/cruise per area).
        let national = ["mutual_exempt", "unilateral_30d", "visa_L"]
        let cruiseOk: Set<String> = ["110000", "310000", "320500", "330100"]   // coastal provinces
        var matrix: [CityPolicyFeas] = []
        for c in cities {
            for p in national { matrix.append(CityPolicyFeas(cityId: c.cityId, policyId: p, feasibility: "ok")) }
            matrix.append(CityPolicyFeas(cityId: c.cityId, policyId: "twov_240h", feasibility: "ok"))
            matrix.append(CityPolicyFeas(cityId: c.cityId, policyId: "twov_24h", feasibility: "no"))
            matrix.append(CityPolicyFeas(cityId: c.cityId, policyId: "hainan_30d", feasibility: "no"))
            matrix.append(CityPolicyFeas(cityId: c.cityId, policyId: "group_asean_xsbn", feasibility: "no"))
            matrix.append(CityPolicyFeas(cityId: c.cityId, policyId: "cruise_15d", feasibility: cruiseOk.contains(c.cityId) ? "ok" : "no"))
        }

        let permits = [PermitZone(adminCode: "540000", name: "西藏自治区", note: "需入藏许可，覆盖所有政策")]
        return VisaDataSet(policies: policies, grants: grants, cities: cities, matrix: matrix, permitZones: permits)
    }()
}
