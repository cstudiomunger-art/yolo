import SwiftUI
import UserNotifications

struct NotificationPermissionView: View {
    @Environment(AppEnvironment.self) private var appEnv

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            Text("🔔")
                .font(.system(size: 48))
            Text("Don't miss important reminders")
                .font(Theme.FontToken.playfair(24, weight: .semibold))
                .multilineTextAlignment(.center)
            Text("We'll remind you when your trip is approaching and key prep items are overdue.")
                .font(Theme.FontToken.inter(14))
                .foregroundStyle(Theme.ColorToken.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            Spacer()
            Button("Enable Notifications") {
                Task { await requestPermission() }
            }
            .font(Theme.FontToken.inter(14, weight: .medium))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Theme.ColorToken.textPrimary)
            Button("Maybe Later") { complete() }
                .font(Theme.FontToken.inter(13))
                .foregroundStyle(Theme.ColorToken.textMuted)
        }
        .padding(.horizontal, Theme.screenPadding)
        .padding(.bottom, 40)
        .background(Theme.ColorToken.background)
    }

    private func requestPermission() async {
        _ = try? await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
        complete()
    }

    private func complete() {
        appEnv.preferences.markNotificationOnboardingCompleted()
    }
}
