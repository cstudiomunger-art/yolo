import Foundation
import UserNotifications

struct ChecklistSettings: Codable, Sendable {
    let id: String
    let reminderDays: Int
    let pushTitle: String
    let pushBody: String
    let homeBannerEnabled: Bool
    let homeBannerTemplate: String

    // camelCase keys — Supabase decoder uses .convertFromSnakeCase, which maps
    // reminder_days → reminderDays automatically. Snake_case raw values would
    // break decoding (fetch fails → always falls back to .fallback).
    enum CodingKeys: String, CodingKey {
        case id
        case reminderDays
        case pushTitle
        case pushBody
        case homeBannerEnabled
        case homeBannerTemplate
    }

    static let fallback = ChecklistSettings(
        id: "global",
        reminderDays: 3,
        pushTitle: "Your China trip is in {days} days!",
        pushBody: "You still have {count} prep items to complete. Don't miss them!",
        homeBannerEnabled: true,
        homeBannerTemplate: "{count} items still need attention · Trip starts in {days} days"
    )
}

@MainActor
enum PrepReminderService {
    private static let notificationId = "yolohappy.prep.reminder"
    private static let tripRemindersKey = UserDefaultsKeys.tripPrepRemindersEnabled

    static var tripRemindersEnabled: Bool {
        get {
            if UserDefaults.standard.object(forKey: tripRemindersKey) == nil { return true }
            return UserDefaults.standard.bool(forKey: tripRemindersKey)
        }
        set { UserDefaults.standard.set(newValue, forKey: tripRemindersKey) }
    }

    static func scheduleIfNeeded(
        settings: ChecklistSettings,
        daysUntilDeparture: Int,
        pendingCount: Int
    ) {
        guard tripRemindersEnabled else {
            cancelReminder()
            return
        }
        guard pendingCount > 0, daysUntilDeparture <= settings.reminderDays, daysUntilDeparture >= 0 else {
            cancelReminder()
            return
        }

        let title = settings.pushTitle
            .replacingOccurrences(of: "{days}", with: "\(daysUntilDeparture)")
        let body = settings.pushBody
            .replacingOccurrences(of: "{days}", with: "\(daysUntilDeparture)")
            .replacingOccurrences(of: "{count}", with: "\(pendingCount)")

        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        var date = DateComponents()
        date.hour = 9
        date.minute = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
        let request = UNNotificationRequest(identifier: notificationId, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }

    static func cancelReminder() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationId])
    }

    static func bannerText(
        settings: ChecklistSettings,
        daysUntilDeparture: Int,
        pendingCount: Int
    ) -> String? {
        guard settings.homeBannerEnabled else { return nil }
        guard pendingCount > 0, daysUntilDeparture <= settings.reminderDays, daysUntilDeparture >= 0 else {
            return nil
        }
        return settings.homeBannerTemplate
            .replacingOccurrences(of: "{days}", with: "\(daysUntilDeparture)")
            .replacingOccurrences(of: "{count}", with: "\(pendingCount)")
    }
}
