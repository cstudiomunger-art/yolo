import Foundation
import UserNotifications

@MainActor
enum TripReminderService {
    private static let d1Prefix = "yolohappy.trip.d1."
    private static let dayPrefix = "yolohappy.trip.day."

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
        let tripStart = calendar.startOfDay(for: departureDate)

        if let d1Date = calendar.date(byAdding: .day, value: -1, to: tripStart),
           d1Date > calendar.startOfDay(for: .now) {
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

        for (index, day) in itinerary.days.enumerated() {
            guard let fireDate = calendar.date(byAdding: .day, value: index, to: tripStart),
                  fireDate >= calendar.startOfDay(for: .now)
            else { continue }

            var components = calendar.dateComponents([.year, .month, .day], from: fireDate)
            components.hour = 7
            components.minute = 30

            let names = day.activities.prefix(3).map(\.name).joined(separator: " · ")
            let content = UNMutableNotificationContent()
            content.title = day.dateLabel
            content.body = names.isEmpty
                ? String(localized: "Check today's plan in YOLO HAPPY")
                : names
            content.sound = .default

            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            let id = dayPrefix + "\(itinerary.id).\(index)"
            try? await center.add(UNNotificationRequest(identifier: id, content: content, trigger: trigger))
        }
    }

    static func cancelAll() async {
        let center = UNUserNotificationCenter.current()
        let pending = await center.pendingNotificationRequests()
        let ids = pending.map(\.identifier).filter {
            $0.hasPrefix(d1Prefix) || $0.hasPrefix(dayPrefix)
        }
        center.removePendingNotificationRequests(withIdentifiers: ids)
    }
}
