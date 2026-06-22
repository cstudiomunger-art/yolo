import Foundation

/// Swift port of the delivery-package `freshness.py` UI badge (铁律：只告警不改库).
/// Derives a freshness level + copy from a policy's expiry / last_verified dates so the
/// result card can flag near-expiry policies (单方面 48 国 2026-12-31 临期).
struct VisaFreshness: Equatable {
    enum Level: String { case fresh, stale, expiring, expired }

    let level: Level
    let lastVerified: String?
    let expiryDate: String?
    let message: String

    /// Rules baseline (delivery-package VERSION + verification round).
    static let rulesVersion = "phase1 · 2026-06-22 verified"

    private static let dayFormatter: DateFormatter = {
        let f = DateFormatter()
        f.calendar = Calendar(identifier: .gregorian)
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = TimeZone(identifier: "UTC")
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()

    private static func parse(_ s: String?) -> Date? {
        guard let s, !s.isEmpty else { return nil }
        return dayFormatter.date(from: s)
    }

    private static func days(from a: Date, to b: Date) -> Int {
        Calendar(identifier: .gregorian).dateComponents([.day], from: a, to: b).day ?? 0
    }

    /// Pure badge function — mirrors `freshness.badge`. `hasHistory` flags policies that
    /// have been extended before (app ships no change_log, so callers pass false).
    static func badge(expiryDate: String?, lastVerified: String?, today: Date,
                      hasHistory: Bool = false, within: Int = 30, staleAfter: Int = 30) -> VisaFreshness {
        let exp = parse(expiryDate)
        let lv = parse(lastVerified)

        if let exp, exp < today {
            let tail = hasHistory ? "；历史上曾多次延期，请关注官方公告" : "，请关注官方公告"
            return VisaFreshness(
                level: .expired, lastVerified: lastVerified, expiryDate: expiryDate,
                message: "按现行公告该政策已于 \(expiryDate ?? "") 到期\(tail)。以边检最终判定为准。")
        }
        if let exp, days(from: today, to: exp) <= within {
            return VisaFreshness(
                level: .expiring, lastVerified: lastVerified, expiryDate: expiryDate,
                message: "现行公布的截止日为 \(expiryDate ?? "")，行程在有效期内，建议出发前复查是否延期。以边检最终判定为准。")
        }
        if let lv, days(from: lv, to: today) > staleAfter {
            return VisaFreshness(
                level: .stale, lastVerified: lastVerified, expiryDate: expiryDate,
                message: "规则核验于 \(lastVerified ?? "")，已超 \(staleAfter) 天，建议复查官方公告。以边检最终判定为准。")
        }
        return VisaFreshness(
            level: .fresh, lastVerified: lastVerified, expiryDate: expiryDate,
            message: "规则版本 \(rulesVersion) · 核验于 \(lastVerified ?? "—")。以边检最终判定为准。")
    }

    /// UI display badge for a nationality × policy: takes the active grant's expiry and the
    /// older of (grant, policy) last_verified, mirroring `freshness.policy_freshness`.
    static func forPolicy(_ policyId: String, country: String, data: VisaDataSet,
                          today: Date) -> VisaFreshness {
        let policy = data.policy(policyId)
        let grant = data.grants
            .filter { $0.policyId == policyId && $0.countryCode.caseInsensitiveCompare(country) == .orderedSame }
            .max { ($0.effectiveDate ?? "") < ($1.effectiveDate ?? "") }

        // Grant last_verified isn't shipped to the app; the policy framework carries it.
        return badge(expiryDate: grant?.expiryDate, lastVerified: policy?.lastVerified, today: today)
    }
}
