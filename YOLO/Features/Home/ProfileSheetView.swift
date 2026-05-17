import SwiftUI
import UIKit

struct ProfileSheetView: View {
    @Environment(AppEnvironment.self) private var appEnv
    @Environment(\.dismiss) private var dismiss
    @State private var showLogin = false
    @State private var showLanguagePicker = false
    @State private var showCountryPicker = false
    @State private var showAbout = false
    @State private var cacheSizeLabel = CacheService.formattedCacheSize()
    @State private var showCacheCleared = false
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    userSection
                    subscriptionSection
                    settingsSection
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
            .sheet(isPresented: $showLogin) {
                NavigationStack {
                    LoginView()
                        .environment(appEnv)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Close") { showLogin = false }
                            }
                        }
                }
            }
            .onChange(of: appEnv.auth.isAuthenticated) { _, isAuthenticated in
                if isAuthenticated {
                    showLogin = false
                    Task { await appEnv.profileSync.syncAfterSignIn() }
                }
            }
            .sheet(isPresented: $showLanguagePicker) {
                LanguagePickerView()
            }
            .sheet(isPresented: $showCountryPicker) {
                NavigationStack {
                    CountryPickerView(mode: .profileEdit)
                        .environment(appEnv)
                }
            }
            .sheet(isPresented: $showAbout) {
                AboutChinaGoView()
            }
            .onDisappear {
                if appEnv.auth.isAuthenticated {
                    Task { await appEnv.profileSync.pushToRemote() }
                }
            }
            .task {
                cacheSizeLabel = CacheService.formattedCacheSize()
            }
            .alert("Cache Cleared", isPresented: $showCacheCleared) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Temporary files and network cache have been removed.")
            }
        }
    }

    private var userSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                ProfileAvatarButton {}
                VStack(alignment: .leading, spacing: 4) {
                    if let email = appEnv.auth.userEmail {
                        Text(email)
                            .font(Theme.FontToken.playfair(16, weight: .semibold))
                            .lineLimit(1)
                    } else {
                        Text("Guest")
                            .font(Theme.FontToken.playfair(16, weight: .semibold))
                    }
                    if let visa = appEnv.preferences.visaRule() {
                        Text("\(visa.flag) \(visa.countryName) Passport · \(appEnv.preferences.selectedCityIds.joined(separator: ", "))")
                            .font(Theme.FontToken.inter(11))
                            .foregroundStyle(Theme.ColorToken.textMuted)
                    }
                }
            }

            Button {
                showCountryPicker = true
            } label: {
                HStack {
                    Text("Change passport country")
                        .font(Theme.FontToken.inter(11, weight: .medium))
                    Spacer()
                    Text("›")
                        .foregroundStyle(Theme.ColorToken.textGhost)
                }
                .foregroundStyle(Theme.ColorToken.accent)
            }
            .buttonStyle(.plain)

            if appEnv.auth.isAuthenticated {
                Button("退出登录") {
                    Task {
                        await appEnv.profileSync.pushToRemote()
                        try? await appEnv.auth.signOut()
                    }
                }
                .font(Theme.FontToken.inter(11, weight: .medium))
                .foregroundStyle(.red)
            } else {
                Button("登录 / 注册 →") {
                    showLogin = true
                }
                .font(Theme.FontToken.inter(11, weight: .medium))
                .foregroundStyle(Theme.ColorToken.accent)
            }

            if appEnv.profileSync.isSyncing {
                HStack(spacing: 8) {
                    ProgressView()
                    Text("Syncing profile…")
                        .font(Theme.FontToken.inter(10))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                }
            } else if let syncError = appEnv.profileSync.lastSyncError {
                Text(syncError)
                    .font(Theme.FontToken.inter(10))
                    .foregroundStyle(.red)
            }
        }
        .padding(Theme.screenPadding)
    }

    private var subscriptionSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                if appEnv.preferences.simulateProPurchase || appEnv.contentMode.useRemoteIAP {
                    Text("✨ Active")
                        .font(Theme.FontToken.inter(9, weight: .medium))
                        .foregroundStyle(Theme.ColorToken.accent)
                }
                Text(appEnv.preferences.simulateProPurchase ? "ChinaGo Pro (demo)" : "Free")
                    .font(Theme.FontToken.inter(14, weight: .medium))
                Text("Content: \(appEnv.contentMode.contentModeLabel)")
                    .font(Theme.FontToken.inter(11))
                    .foregroundStyle(Theme.ColorToken.textMuted)
                Text(appEnv.contentMode.useRemoteContent
                    ? "CMS 远程内容已开启"
                    : "CMS 远程内容未开启（仍为内置 JSON）")
                    .font(Theme.FontToken.inter(10))
                    .foregroundStyle(appEnv.contentMode.useRemoteContent
                        ? Theme.ColorToken.accent
                        : Theme.ColorToken.warning)
            }
            Spacer()
            Button("Manage →") {
                appEnv.preferences.simulateProPurchase.toggle()
                Task { await appEnv.profileSync.pushToRemote() }
            }
            .font(Theme.FontToken.inter(11, weight: .medium))
            .foregroundStyle(Theme.ColorToken.accent)
        }
        .padding(16)
        .background(Theme.ColorToken.backgroundSubtle)
        .padding(.horizontal, Theme.screenPadding)
        .padding(.bottom, 20)
    }

    private var settingsSection: some View {
        VStack(spacing: 0) {
            Button {
                showLanguagePicker = true
            } label: {
                settingsRow("Language", value: appEnv.preferences.appLanguage.displayName)
            }
            .buttonStyle(.plain)

            Button {
                CacheService.clearCache()
                cacheSizeLabel = CacheService.formattedCacheSize()
                showCacheCleared = true
            } label: {
                settingsRow("Clear Cache", value: cacheSizeLabel)
            }
            .buttonStyle(.plain)

            Button {
                openFeedbackEmail()
            } label: {
                settingsRow("Send Feedback", value: nil)
            }
            .buttonStyle(.plain)

            Button {
                showAbout = true
            } label: {
                settingsRow("About ChinaGo", value: "v\(appEnv.contentMode.branding.aboutVersion)")
            }
            .buttonStyle(.plain)

            settingsRow("Content Mode", value: appEnv.contentMode.contentModeLabel)

            Button {
                Task { await appEnv.refreshContentMode(clearSettingsCache: true) }
            } label: {
                HStack {
                    Text("Refresh from CMS")
                    Spacer()
                    if appEnv.contentMode.isRefreshing {
                        ProgressView()
                    }
                }
                .padding(.vertical, 14)
                .padding(.horizontal, Theme.screenPadding)
            }
            .buttonStyle(.plain)

            if let error = appEnv.contentMode.lastRefreshError {
                Text(error)
                    .font(Theme.FontToken.inter(11))
                    .foregroundStyle(.red)
                    .padding(.horizontal, Theme.screenPadding)
            }
        }
    }

    private func settingsRow(_ label: String, value: String?) -> some View {
        HStack {
            Text(label)
                .font(Theme.FontToken.inter(14))
            Spacer()
            if let value {
                Text(value)
                    .font(Theme.FontToken.inter(13))
                    .foregroundStyle(Theme.ColorToken.textMuted)
            }
            Text("›")
                .foregroundStyle(Theme.ColorToken.textGhost)
        }
        .padding(.vertical, 14)
        .padding(.horizontal, Theme.screenPadding)
        .overlay(alignment: .bottom) {
            Rectangle().fill(Theme.ColorToken.borderLight).frame(height: 1)
        }
    }

    private func openFeedbackEmail() {
        let branding = appEnv.contentMode.branding
        let subject = "ChinaGo Feedback"
        let body = "App version \(branding.aboutVersion)\n\n"
        var components = URLComponents()
        components.scheme = "mailto"
        components.path = branding.supportEmail
        components.queryItems = [
            URLQueryItem(name: "subject", value: subject),
            URLQueryItem(name: "body", value: body)
        ]
        if let url = components.url {
            UIApplication.shared.open(url)
        }
    }
}
