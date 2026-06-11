import Foundation
import UserNotifications

@MainActor
enum TripReminderService {
    private static let d1Prefix = "yolohappy.trip.d1."
    private static let dayPrefix = "yolohappy.trip.day."
    private static let endPrefix = "yolohappy.trip.end."

    static func reschedule(
        itinerary: SampleItinerary?,
        departureDate: Date,
        remindersEnabled: Bool
    ) async {
        await cancelAll()
        guard remindersEnabled, let itinerary, !itinerary.days.isEmpty else { return }

        let center = UNUserNotificationCenter.current()
        let settings = await center.notificationSettings()
        guard settings.authorizationStatus == .authorized else { return }

        let calendar = Calendar.current
        // 优先用行程自身的起止日期；老行程（无结构化日期）回退到全局出发日。
        let range = itinerary.resolvedDateRange
        let tripStart = calendar.startOfDay(for: range?.start ?? departureDate)
        let tripEnd = calendar.startOfDay(for: max(range?.end ?? tripStart, tripStart))
        let today = calendar.startOfDay(for: .now)

        // 出发前一天 9:00：行程明天开始。
        if let d1Date = calendar.date(byAdding: .day, value: -1, to: tripStart),
           d1Date > today {
            var components = calendar.dateComponents([.year, .month, .day], from: d1Date)
            components.hour = 9
            components.minute = 0
            let content = UNMutableNotificationContent()
            content.title = String(localized: "Your trip starts tomorrow")
            content.body = String(
                format: String(localized: "%@ — %lld days planned. Open YOLO HAPPY to review."),
                itinerary.title,
                itinerary.days.count
            )
            content.sound = .default
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            let id = d1Prefix + itinerary.id
            try? await center.add(UNNotificationRequest(identifier: id, content: content, trigger: trigger))
        }

        // 每天 7:30：当日计划。
        for (index, day) in itinerary.days.enumerated() {
            guard let fireDate = calendar.date(byAdding: .day, value: index, to: tripStart) else { continue }
            let fireDay = calendar.startOfDay(for: fireDate)
            guard fireDay >= today else { continue }

            var components = calendar.dateComponents([.year, .month, .day], from: fireDate)
            components.hour = 7
            components.minute = 30
            let scheduled = calendar.date(from: components) ?? fireDate

            let names = day.activities.prefix(3).map(\.name).joined(separator: " · ")
            let content = UNMutableNotificationContent()
            content.title = day.dateLabel
            content.body = names.isEmpty
                ? String(localized: "Check today's plan in YOLO HAPPY")
                : names
            content.sound = .default

            let trigger: UNNotificationTrigger
            if scheduled > .now {
                trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            } else if calendar.isDateInToday(fireDate) {
                // 出发当天才创建行程、且已过 7:30 → 立即补发一次「今天开始」提醒。
                trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            } else {
                continue // 过去的日子不补发。
            }

            let id = dayPrefix + "\(itinerary.id).\(index)"
            try? await center.add(UNNotificationRequest(identifier: id, content: content, trigger: trigger))
        }

        // 行程结束次日 10:00：欢迎回家 + 回顾行程。
        if let endNotify = calendar.date(byAdding: .day, value: 1, to: tripEnd) {
            var components = calendar.dateComponents([.year, .month, .day], from: endNotify)
            components.hour = 10
            components.minute = 0
            if let scheduled = calendar.date(from: components), scheduled > .now {
                let content = UNMutableNotificationContent()
                content.title = String(localized: "Welcome back!")
                content.body = String(
                    format: String(localized: "Your trip “%@” has ended. Tap to revisit your itinerary."),
                    itinerary.title
                )
                content.sound = .default
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
                let id = endPrefix + itinerary.id
                try? await center.add(UNNotificationRequest(identifier: id, content: content, trigger: trigger))
            }
        }
    }

    static func cancelAll() async {
        let center = UNUserNotificationCenter.current()
        let pending = await center.pendingNotificationRequests()
        let ids = pending.map(\.identifier).filter {
            $0.hasPrefix(d1Prefix) || $0.hasPrefix(dayPrefix) || $0.hasPrefix(endPrefix)
        }
        center.removePendingNotificationRequests(withIdentifiers: ids)
    }
}
