import UIKit
import UserNotifications

/// Holds the latest APNs device token and notifies when it arrives. Registration
/// degrades gracefully: without the Push Notifications capability + an APNs key,
/// `registerForRemoteNotifications()` simply never yields a token (no crash).
final class PushTokenStore {
    static let shared = PushTokenStore()
    private(set) var token: String?
    var onToken: ((String) -> Void)?

    func set(_ t: String) {
        token = t
        onToken?(t)
    }
}

/// Routes a tapped support notification to the chat. Set by AppEnvironment.
final class PushRouter {
    static let shared = PushRouter()
    var onOpenChat: (() -> Void)?
}

final class YOLOAppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }

    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        let hex = deviceToken.map { String(format: "%02x", $0) }.joined()
        PushTokenStore.shared.set(hex)
    }

    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        // No APNs entitlement yet (or simulator) — push stays disabled, chat still works.
    }

    // Foreground: show the banner + sound even while the app is open.
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound, .badge])
    }

    // Tap a support notification → open Genius Bar.
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        Task { @MainActor in PushRouter.shared.onOpenChat?() }
        completionHandler()
    }
}
