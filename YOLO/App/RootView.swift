import SwiftUI

struct RootView: View {
    @Environment(AppEnvironment.self) private var appEnv
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        Group {
            if appEnv.preferences.hasCompletedOnboarding {
                MainTabView()
            } else {
                CountryPickerView()
            }
        }
        .environment(\.locale, appEnv.preferences.appLanguage.locale)
        .task {
            await appEnv.refreshContentMode(clearSettingsCache: true)
        }
        .onChange(of: appEnv.preferences.countryCode) { _, _ in
            Task { await appEnv.refreshVisaRule() }
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                Task { await appEnv.refreshContentMode(clearSettingsCache: true) }
            }
        }
        .onChange(of: appEnv.auth.isAuthenticated) { _, isAuthenticated in
            if isAuthenticated {
                Task { await appEnv.profileSync.syncAfterSignIn() }
            }
        }
    }
}
