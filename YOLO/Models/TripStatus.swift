import Foundation

/// 行程相对「今天」的状态（按日历天判断，与具体时分无关）。
enum TripStatus: Equatable {
    /// 尚未开始，距开始还有 `daysUntilStart` 天（0 = 明天之内的今天稍后，已并入 ongoing）。
    case upcoming(daysUntilStart: Int)
    /// 进行中：今天是第 `day` 天，共 `total` 天。
    case ongoing(day: Int, total: Int)
    /// 已结束。
    case ended

    /// 用起止日期与「现在」推导状态（含端点：开始日与结束日都算进行中）。
    static func make(start: Date, end: Date, now: Date = .now) -> TripStatus {
        let cal = Calendar.current
        let today = cal.startOfDay(for: now)
        let s = cal.startOfDay(for: start)
        let e = cal.startOfDay(for: max(end, start))

        if today < s {
            let d = cal.dateComponents([.day], from: today, to: s).day ?? 0
            return .upcoming(daysUntilStart: max(d, 0))
        }
        if today > e {
            return .ended
        }
        let day = (cal.dateComponents([.day], from: s, to: today).day ?? 0) + 1
        let total = (cal.dateComponents([.day], from: s, to: e).day ?? 0) + 1
        return .ongoing(day: day, total: max(total, day))
    }
}

extension SampleItinerary {
    /// 优先用结构化起止日期；老行程尝试从 `meta` 的「日期 – 日期」回填。
    var resolvedDateRange: (start: Date, end: Date)? {
        if let start = startDate, let end = endDate { return (start, end) }
        return Self.parseMetaDateRange(meta)
    }

    /// 行程状态。无可用日期（如纯 AI 生成、meta 非日期范围）时返回 nil → 界面回退到原展示。
    func tripStatus(now: Date = .now) -> TripStatus? {
        guard let range = resolvedDateRange else { return nil }
        return TripStatus.make(start: range.start, end: range.end, now: now)
    }

    /// 解析 `PlanTripDateMath.formatTripMeta` 产出的 "Jun 20, 2026 – Jun 27, 2026"。
    static func parseMetaDateRange(_ meta: String) -> (start: Date, end: Date)? {
        let parts = meta.components(separatedBy: " – ")
        guard parts.count == 2 else { return nil }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        guard let start = formatter.date(from: parts[0].trimmingCharacters(in: .whitespaces)),
              let end = formatter.date(from: parts[1].trimmingCharacters(in: .whitespaces))
        else { return nil }
        return (start, end)
    }
}
