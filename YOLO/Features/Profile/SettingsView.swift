import SwiftUI
import UIKit

/// App settings — cache, language, notifications, legal, account.
/// Extracted from ProfileSheetView to keep the profile sheet focused on identity and membership.
struct SettingsView: View {
    @Environment(AppEnvironment.self) private var appEnv
    @Environment(\.dismiss) private var dismiss

    @State private var showLanguagePicker = false
    @State private var showCountryPicker = false
    @State private var showAbout = false
    @State private var cacheSizeLabel = "…"
    @State private var cacheClearedMessage: String?
    @State private var showDeleteAccountConfirm = false
    @State private var isDeletingAccount = false
    @State private var deleteAccountError: String?

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                notificationsSection
                preferencesSection
                cacheSection
                legalSection
                accountSection
            }
        }
        .navigationTitle(String(localized: "Settings"))
        .navigationBarTitleDisplayMode(.inline)
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
        .alert(
            String(localized: "Delete account?"),
            isPresented: $showDeleteAccountConfirm
        ) {
            Button(String(localized: "Cancel"), role: .cancel) {}
            Button(String(localized: "Delete"), role: .destructive) {
                Task { await deleteAccount() }
            }
        } message: {
            Text(String(localized: "This permanently removes your account and cloud trips. This cannot be undone."))
        }
        .alert(
            String(localized: "Cache Cleared"),
            isPresented: Binding(
                get: { cacheClearedMessage != nil },
                set: { if !$0 { cacheClearedMessage = nil } }
            )
        ) {
            Button("OK", role: .cancel) { cacheClearedMessage = nil }
        } message: {
            Text(cacheClearedMessage ?? "")
        }
        .task { await refreshCacheSizeLabel() }
    }

    // MARK: - Sections

    private var notificationsSection: some View {
        Toggle(isOn: tripRemindersBinding) {
            VStack(alignment: .leading, spacing: 2) {
                Text(String(localized: "Trip reminders"))
                    .font(Theme.FontToken.inter(13))
                Text(String(localized: "Prep checklist alerts before departure"))
                    .font(Theme.FontToken.inter(11))
                    .foregroundStyle(Theme.ColorToken.textMuted)
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, Theme.screenPadding)
        .overlay(alignment: .bottom) {
            Rectangle().fill(Theme.ColorToken.borderLight).frame(height: 1)
        }
    }

    private var preferencesSection: some View {
        Group {
            Button {
                showLanguagePicker = true
            } label: {
                settingsRow(String(localized: "Language"), value: appEnv.preferences.appLanguage.displayName)
            }
            .buttonStyle(.plain)

            Button {
                showCountryPicker = true
            } label: {
                settingsRow(String(localized: "Nationality"), value: nil)
            }
            .buttonStyle(.plain)

            settingsRow(String(localized: "Content Mode"), value: appEnv.contentMode.contentModeLabel)

            Button {
                Task { await appEnv.refreshContentMode(clearSettingsCache: true) }
            } label: {
                HStack {
                    Text(String(localized: "Refresh from CMS"))
                    Spacer()
                    if appEnv.contentMode.isRefreshing { ProgressView() }
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

    private var cacheSection: some View {
        Group {
            settingsRow(String(localized: "Cache Size"), value: cacheSizeLabel)

            cacheClearButton(
                String(localized: "Clear Temporary Cache"),
                detail: String(localized: "Session temp files and HTTP cache")
            ) {
                await CacheService.clear(.temporary)
                cacheClearedMessage = String(localized: "Temporary files and HTTP cache have been removed.")
            }

            cacheClearButton(
                String(localized: "Clear Offline Content"),
                detail: String(localized: "Cached cities, attractions, tips")
            ) {
                await CacheService.clear(.offlineContent)
                cacheClearedMessage = String(localized: "Offline CMS content cache has been removed.")
            }

            cacheClearButton(
                String(localized: "Clear Cover Images"),
                detail: String(localized: "Cached guide cover photos")
            ) {
                await CacheService.clear(.coverImages)
                cacheClearedMessage = String(localized: "Cached cover images have been removed.")
            }

            cacheClearButton(
                String(localized: "Clear Downloaded Audio"),
                detail: String(localized: "Offline audio guides")
            ) {
                await CacheService.clear(.downloadedAudio)
                cacheClearedMessage = String(localized: "Downloaded audio files have been removed.")
            }
        }
    }

    private var legalSection: some View {
        Group {
            NavigationLink {
                LegalDocumentView(kind: .privacy)
            } label: {
                settingsRow(String(localized: "Privacy Policy"), value: nil)
            }

            NavigationLink {
                LegalDocumentView(kind: .terms)
            } label: {
                settingsRow(String(localized: "Terms of Service"), value: nil)
            }

            Button { openFeedbackEmail() } label: {
                settingsRow(String(localized: "Send Feedback"), value: nil)
            }
            .buttonStyle(.plain)

            Button {
                showAbout = true
            } label: {
                settingsRow(
                    String(localized: "About YOLO HAPPY"),
                    value: "v\(appEnv.contentMode.branding.aboutVersion)"
                )
            }
            .buttonStyle(.plain)
        }
    }

    private var accountSection: some View {
        Group {
            if appEnv.auth.isAuthenticated {
                Button(String(localized: "Sign Out")) {
                    Task { await appEnv.signOutAndReset() }
                }
                .font(Theme.FontToken.inter(14))
                .foregroundStyle(.red)
                .padding(.vertical, 14)
                .padding(.horizontal, Theme.screenPadding)
                .frame(maxWidth: .infinity, alignment: .leading)
                .overlay(alignment: .bottom) {
                    Rectangle().fill(Theme.ColorToken.borderLight).frame(height: 1)
                }

                Button(String(localized: "Delete account")) {
                    showDeleteAccountConfirm = true
                }
                .font(Theme.FontToken.inter(14))
                .foregroundStyle(.red)
                .padding(.vertical, 14)
                .padding(.horizontal, Theme.screenPadding)
                .frame(maxWidth: .infinity, alignment: .leading)
                .disabled(isDeletingAccount)
                .overlay(alignment: .bottom) {
                    Rectangle().fill(Theme.ColorToken.borderLight).frame(height: 1)
                }

                if let err = deleteAccountError {
                    Text(err)
                        .font(Theme.FontToken.inter(11))
                        .foregroundStyle(.red)
                        .padding(.horizontal, Theme.screenPadding)
                }
            }
        }
    }

    // MARK: - Helpers

    private func settingsRow(_ label: String, value: String?) -> some View {
        HStack {
            Text(label).font(Theme.FontToken.inter(14))
            Spacer()
            if let value {
                Text(value).font(Theme.FontToken.inter(13)).foregroundStyle(Theme.ColorToken.textMuted)
            }
            Text("›").foregroundStyle(Theme.ColorToken.textGhost)
        }
        .padding(.vertical, 14)
        .padding(.horizontal, Theme.screenPadding)
        .overlay(alignment: .bottom) {
            Rectangle().fill(Theme.ColorToken.borderLight).frame(height: 1)
        }
    }

    private func cacheClearButton(
        _ label: String,
        detail: String,
        action: @escaping () async -> Void
    ) -> some View {
        Button {
            Task {
                await action()
                await refreshCacheSizeLabel()
            }
        } label: {
            VStack(alignment: .leading, spacing: 2) {
                Text(label).font(Theme.FontToken.inter(14))
                Text(detail).font(Theme.FontToken.inter(10)).foregroundStyle(Theme.ColorToken.textMuted)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 12)
            .padding(.horizontal, Theme.screenPadding)
            .overlay(alignment: .bottom) {
                Rectangle().fill(Theme.ColorToken.borderLight).frame(height: 1)
            }
        }
        .buttonStyle(.plain)
    }

    private func refreshCacheSizeLabel() async {
        cacheSizeLabel = await CacheService.formattedCacheSize()
    }

    private var tripRemindersBinding: Binding<Bool> {
        Binding(
            get: { PrepReminderService.tripRemindersEnabled },
            set: { enabled in
                PrepReminderService.tripRemindersEnabled = enabled
                if !enabled {
                    PrepReminderService.cancelReminder()
                    Task { await TripReminderService.cancelAll() }
                } else {
                    Task { await appEnv.rescheduleTripReminders() }
                }
            }
        )
    }

    private func openFeedbackEmail() {
        let branding = appEnv.contentMode.branding
        var components = URLComponents()
        components.scheme = "mailto"
        components.path = branding.supportEmail
        components.queryItems = [
            URLQueryItem(name: "subject", value: "YOLO HAPPY Feedback"),
            URLQueryItem(name: "body", value: "App version \(branding.aboutVersion)\n\n"),
        ]
        if let url = components.url { UIApplication.shared.open(url) }
    }

    private func deleteAccount() async {
        isDeletingAccount = true
        deleteAccountError = nil
        defer { isDeletingAccount = false }
        do {
            try await appEnv.deleteAccount()
            dismiss()
        } catch {
            deleteAccountError = error.localizedDescription
        }
    }
}
