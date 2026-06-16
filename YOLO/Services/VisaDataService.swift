import Foundation
import Observation
import Supabase

/// Loads the `VisaDataSet` the on-device `VisaPolicyEngine` evaluates. Mirrors
/// `PurchaseService.loadPlans`: Supabase is the source of truth; the last good fetch
/// is cached so offline launches still judge against real config; an in-code bundled
/// fallback is the last resort (fresh install, no network).
@Observable
@MainActor
final class VisaDataService {

    private(set) var data: VisaDataSet = .empty
    private(set) var isLoading = false

    private static let cacheKey = "yolohappy.cachedVisaDataSet.v1"

    func load() async {
        guard AppConfig.isSupabaseConfigured, !AppConfig.useMock else {
            data = cached() ?? Self.bundledFallback
            return
        }
        isLoading = true
        defer { isLoading = false }
        do {
            let client = SupabaseManager.shared
            async let policies: [VisaPolicy] = client.from("visa_policies").select().eq("is_active", value: true).execute().value
            async let grants: [VisaPolicyGrant] = client.from("visa_policy_grants").select().eq("is_active", value: true).execute().value
            async let cityTags: [CityVisaTag] = client.from("city_visa_tags").select().eq("is_active", value: true).execute().value
            async let ports: [EntryPort] = client.from("entry_ports").select().eq("is_active", value: true).execute().value
            async let overrides: [VisaRuleOverride] = client.from("visa_rule_overrides").select().eq("is_active", value: true).execute().value

            let set = try await VisaDataSet(
                policies: policies, grants: grants, cityTags: cityTags, ports: ports, overrides: overrides
            )
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

    /// Convenience: run a query against the currently-loaded data.
    func evaluate(_ query: VisaQuery) -> VisaVerdict {
        VisaPolicyEngine.evaluate(query, data: data)
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

    // MARK: - Bundled fallback (mirrors migration 062 seed; verify with legal)

    static let bundledFallback: VisaDataSet = {
        let policies: [VisaPolicy] = [
            VisaPolicy(policyKey: "P1", priority: 1, verdict: "green", maxStayDays: 30, areaScope: "nationwide", clockRule: "entry_plus_30d", headlineEn: "Mutual visa exemption", headlineZh: "互免协定 · 全程免签"),
            VisaPolicy(policyKey: "P2", priority: 2, verdict: "green", maxStayDays: 30, areaScope: "nationwide", clockRule: "entry_plus_30d", headlineEn: "Unilateral 30-day visa-free", headlineZh: "单方面免签 30 天"),
            VisaPolicy(policyKey: "P3", priority: 3, verdict: "amber", maxStayDays: 10, areaScope: "transit_ports", clockRule: "entry_plus_10d", headlineEn: "240h transit visa-free", headlineZh: "240 小时过境免签"),
            VisaPolicy(policyKey: "P4", priority: 4, verdict: "amber", maxStayDays: 30, areaScope: "hainan", clockRule: "entry_plus_30d", headlineEn: "Hainan visa-free", headlineZh: "海南区域免签"),
            VisaPolicy(policyKey: "P5", priority: 5, verdict: "amber", maxStayDays: nil, areaScope: "group", clockRule: nil, headlineEn: "Group tour visa-free", headlineZh: "团体免签"),
            VisaPolicy(policyKey: "L", priority: 9, verdict: "red", maxStayDays: nil, areaScope: "none", clockRule: nil, headlineEn: "Tourist (L) visa required", headlineZh: "默认需办 L 旅游签证"),
        ]
        func grant(_ id: String, _ key: String, _ cc: String, _ eff: String? = nil, _ exp: String? = nil) -> VisaPolicyGrant {
            VisaPolicyGrant(id: id, policyKey: key, countryCode: cc, effectiveDate: eff, expiryDate: exp, maxStayOverride: nil)
        }
        let grants: [VisaPolicyGrant] = [
            grant("p1_sg", "P1", "SG"),
            grant("p2_gb", "P2", "GB", "2024-11-30", "2025-12-31"),
            grant("p2_fr", "P2", "FR", "2024-11-30", "2025-12-31"),
            grant("p2_de", "P2", "DE", "2024-11-30", "2025-12-31"),
            grant("p2_jp", "P2", "JP", "2024-11-30", "2025-12-31"),
            grant("p3_us", "P3", "US"), grant("p3_gb", "P3", "GB"), grant("p3_fr", "P3", "FR"),
            grant("p3_de", "P3", "DE"), grant("p3_jp", "P3", "JP"), grant("p3_sg", "P3", "SG"),
            grant("p4_us", "P4", "US"), grant("p4_gb", "P4", "GB"), grant("p4_fr", "P4", "FR"),
            grant("p4_de", "P4", "DE"), grant("p4_jp", "P4", "JP"), grant("p4_sg", "P4", "SG"),
        ]
        let cityTags: [CityVisaTag] = [
            CityVisaTag(cityId: "beijing", regionType: "mainland", isPortOfEntry: true),
            CityVisaTag(cityId: "shanghai", regionType: "mainland", isPortOfEntry: true),
            CityVisaTag(cityId: "xian", regionType: "mainland", isPortOfEntry: true),
            CityVisaTag(cityId: "chengdu", regionType: "mainland", isPortOfEntry: true),
            CityVisaTag(cityId: "suzhou", regionType: "mainland", isPortOfEntry: false),
            CityVisaTag(cityId: "hangzhou", regionType: "mainland", isPortOfEntry: true),
        ]
        let ports: [EntryPort] = [
            EntryPort(portId: "pek", nameEn: "Beijing Capital Intl", nameZh: "北京首都机场", cityId: "beijing", transit240h: true, isHainan: false),
            EntryPort(portId: "pvg", nameEn: "Shanghai Pudong Intl", nameZh: "上海浦东机场", cityId: "shanghai", transit240h: true, isHainan: false),
            EntryPort(portId: "xiy", nameEn: "Xi'an Xianyang Intl", nameZh: "西安咸阳机场", cityId: "xian", transit240h: true, isHainan: false),
            EntryPort(portId: "ctu", nameEn: "Chengdu Tianfu Intl", nameZh: "成都天府机场", cityId: "chengdu", transit240h: true, isHainan: false),
            EntryPort(portId: "hgh", nameEn: "Hangzhou Xiaoshan Intl", nameZh: "杭州萧山机场", cityId: "hangzhou", transit240h: true, isHainan: false),
            EntryPort(portId: "can", nameEn: "Guangzhou Baiyun Intl", nameZh: "广州白云机场", cityId: nil, transit240h: true, isHainan: false),
            EntryPort(portId: "szx", nameEn: "Shenzhen Bao'an Intl", nameZh: "深圳宝安机场", cityId: nil, transit240h: true, isHainan: false),
            EntryPort(portId: "hak", nameEn: "Haikou Meilan Intl", nameZh: "海口美兰机场", cityId: nil, transit240h: false, isHainan: true),
        ]
        return VisaDataSet(policies: policies, grants: grants, cityTags: cityTags, ports: ports, overrides: [])
    }()
}
