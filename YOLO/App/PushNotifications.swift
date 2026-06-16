import UIKit

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

final class YOLOAppDelegate: NSObject, UIApplicationDelegate {
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
}
