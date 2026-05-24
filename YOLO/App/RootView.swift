import SwiftUI

struct RootView: View {
    @Environment(AppEnvironment.self) private var appEnv
    @Environment(\.scenePhase) private var scenePhase

    @State private var showSplash = true

    var body: some View {
        Group {
            if showSplash && !AppConfig.useMock {
                SplashView { showSplash = false }
            } else {
                mainFlow
            }
        }
        .environment(\.locale, appEnv.preferences.appLanguage.locale)
        .task {
            await appEnv.refreshContentMode(clearSettingsCache: true)
            if appEnv.auth.isAuthenticated {
                await appEnv.profileSync.syncAfterSignIn()
            }
        }
        .onChange(of: appEnv.preferences.countryCode) { _, _ in
            Task { await appEnv.refreshVisaRule() }
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                Task {
                    await appEnv.refreshContentMode(clearSettingsCache: true)
                    await appEnv.rescheduleTripReminders()
                }
            }
        }
        .onChange(of: appEnv.preferences.departureDate) { _, _ in
            Task { await appEnv.rescheduleTripReminders() }
        }
        .sheet(isPresented: Binding(
            get: { appEnv.auth.passwordRecoveryPending },
            set: { if !$0 { appEnv.auth.clearPasswordRecoveryPending() } }
        )) {
            SetNewPasswordView()
                .environment(appEnv)
        }
        .onChange(of: appEnv.auth.isAuthenticated) { _, isAuthenticated in
            if isAuthenticated {
                Task { await appEnv.profileSync.syncAfterSignIn() }
            }
        }
    }

    @ViewBuilder
    private var mainFlow: some View {
        if AppConfig.useMock {
            mockFlow
        } else if !appEnv.auth.isAuthenticated {
            AuthLandingView()
        } else if appEnv.preferences.needsIntroOnboarding {
            OnboardingPagerView()
        } else if appEnv.preferences.needsNationalityOnboarding {
            CountryPickerView()
        } else if appEnv.preferences.needsNotificationOnboarding {
            NotificationPermissionView()
        } else {
            MainTabView()
        }
    }

    @ViewBuilder
    private var mockFlow: some View {
        if appEnv.preferences.needsIntroOnboarding {
            OnboardingPagerView()
        } else if appEnv.preferences.needsNationalityOnboarding {
            CountryPickerView()
        } else {
            MainTabView()
        }
    }
}
