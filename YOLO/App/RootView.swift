import SwiftUI

struct RootView: View {
    @Environment(AppEnvironment.self) private var appEnv
    @Environment(\.scenePhase) private var scenePhase

    @State private var showSplash = true
    @State private var lastForegroundRefresh: Date = .distantPast
    @State private var lastMembershipRefresh: Date = .distantPast

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
            await appEnv.purchase.loadPlans()
            if appEnv.auth.isAuthenticated {
                await appEnv.syncAfterSignIn()
            }
        }
        .onChange(of: appEnv.preferences.countryCode) { _, _ in
            Task { await appEnv.refreshVisaRule() }
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                let now = Date()
                if appEnv.auth.isAuthenticated, now.timeIntervalSince(lastMembershipRefresh) > 15 {
                    lastMembershipRefresh = now
                    Task { await appEnv.refreshRemoteMembershipState() }
                }
                guard now.timeIntervalSince(lastForegroundRefresh) > 300 else { return }
                lastForegroundRefresh = now
                Task {
                    await appEnv.refreshContentMode(clearSettingsCache: false)
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
                Task { await appEnv.syncAfterSignIn() }
            }
        }
    }

    @ViewBuilder
    private var mainFlow: some View {
        if AppConfig.useMock {
            mockFlow
        } else if !appEnv.auth.isAuthenticated && !appEnv.preferences.isGuestMode {
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
