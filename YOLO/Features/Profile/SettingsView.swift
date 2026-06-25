import SwiftUI
import UIKit

/// App settings — notifications, preferences, content refresh, storage, legal, account.
/// iOS-style grouped cards: each section is a rounded card with a muted header above it.
struct SettingsView: View {
    @Environment(AppEnvironment.self) private var appEnv
    @Environment(\.dismiss) private var dismiss

    @State private var showLanguagePicker = false
    @State private var showCountryPicker = false
    @State private var showAbout = false
    @State private var cacheSizeLabel = "…"
    @State private var isClearingCache = false
    @State private var cacheClearedMessage: String?
    @State private var showDeleteAccountConfirm = false
    @State private var isDeletingAccount = false
    @State private var deleteAccountError: String?

    /// Card geometry shared by headers, rows and dividers so everything lines up.
    private let cardInset: CGFloat = 16
    private let rowPadding: CGFloat = 16

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                notificationsSection
                preferencesSection
                contentSection
                storageSection
                legalSection
                accountSection
            }
            .padding(.bottom, 28)
        }
        .background(Theme.ColorToken.backgroundSubtle)
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
        VStack(spacing: 0) {
            sectionHeader(String(localized: "Notifications"))
            card {
                Toggle(isOn: tripRemindersBinding) {
                    rowLabel(
                        String(localized: "Trip reminders"),
                        subtitle: String(localized: "Prep checklist alerts before departure")
                    )
                }
                .tint(Theme.ColorToken.success)
                .padding(.horizontal, rowPadding)
                .padding(.vertical, 11)
            }
        }
    }

    private var preferencesSection: some View {
        VStack(spacing: 0) {
            sectionHeader(String(localized: "Preferences"))
            card {
                navRow(String(localized: "Language"), value: appEnv.preferences.appLanguage.displayName) {
                    showLanguagePicker = true
                }
                rowDivider
                navRow(String(localized: "Nationality"), value: nationalityLabel) {
                    showCountryPicker = true
                }
            }
        }
    }

    private var contentSection: some View {
        VStack(spacing: 0) {
            sectionHeader(String(localized: "Content"))
            card {
                Button {
                    Task { await appEnv.refreshContentMode(clearSettingsCache: true) }
                } label: {
                    HStack(spacing: 8) {
                        rowLabel(
                            String(localized: "Check for Content Updates"),
                            subtitle: contentUpdateSubtitle
                        )
                        Spacer()
                        if appEnv.contentMode.isRefreshing {
                            ProgressView()
                        } else {
                            chevron
                        }
                    }
                    .padding(.horizontal, rowPadding)
                    .padding(.vertical, 11)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .disabled(appEnv.contentMode.isRefreshing)
            }
            if let error = appEnv.contentMode.lastRefreshError {
                footnote(error, color: .red)
            }
        }
    }

    /// Friendly subtitle; in DEBUG we append the raw content-mode label for diagnostics.
    private var contentUpdateSubtitle: String {
        let base = String(localized: "Get the latest spots, guides & audio")
        #if DEBUG
        return "\(base) · \(appEnv.contentMode.contentModeLabel)"
        #else
        return base
        #endif
    }

    private var storageSection: some View {
        VStack(spacing: 0) {
            sectionHeader(String(localized: "Storage"))
            card {
                Button {
                    Task {
                        isClearingCache = true
                        await CacheService.clear(.all)
                        await refreshCacheSizeLabel()
                        isClearingCache = false
                        cacheClearedMessage = String(localized: "All cached content has been removed.")
                    }
                } label: {
                    HStack(spacing: 8) {
                        rowLabel(
                            String(localized: "Clear Cache"),
                            subtitle: String(localized: "Offline content, cover images & audio")
                        )
                        Spacer()
                        if isClearingCache {
                            ProgressView()
                        } else {
                            Text(cacheSizeLabel)
                                .font(Theme.FontToken.inter(14))
                                .foregroundStyle(Theme.ColorToken.textMuted)
                        }
                    }
                    .padding(.horizontal, rowPadding)
                    .padding(.vertical, 11)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .disabled(isClearingCache)
            }
        }
    }

    private var legalSection: some View {
        VStack(spacing: 0) {
            sectionHeader(String(localized: "Support"))
            card {
                NavigationLink {
                    LegalDocumentView(kind: .privacy)
                } label: {
                    navRowLabel(String(localized: "Privacy Policy"), value: nil)
                }
                .buttonStyle(.plain)
                rowDivider
                NavigationLink {
                    LegalDocumentView(kind: .terms)
                } label: {
                    navRowLabel(String(localized: "Terms of Service"), value: nil)
                }
                .buttonStyle(.plain)
                rowDivider
                navRow(String(localized: "Send Feedback"), value: nil) { openFeedbackEmail() }
                rowDivider
                navRow(
                    String(localized: "About YOLO HAPPY"),
                    value: "v\(appEnv.contentMode.branding.aboutVersion)"
                ) { showAbout = true }
            }
        }
    }

    private var accountSection: some View {
        Group {
            if appEnv.auth.isAuthenticated {
                VStack(spacing: 0) {
                    sectionHeader(String(localized: "Account"))
                    card {
                        Button {
                            Task { await appEnv.signOutAndReset() }
                        } label: {
                            destructiveRowLabel(String(localized: "Sign Out"))
                        }
                        .buttonStyle(.plain)
                        rowDivider
                        Button {
                            showDeleteAccountConfirm = true
                        } label: {
                            destructiveRowLabel(String(localized: "Delete account"))
                        }
                        .buttonStyle(.plain)
                        .disabled(isDeletingAccount)
                    }
                    if let err = deleteAccountError {
                        footnote(err, color: .red)
                    }
                }
            }
        }
    }

    // MARK: - Row builders

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(Theme.FontToken.inter(12, weight: .medium))
            .foregroundStyle(Theme.ColorToken.textMuted)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, cardInset + rowPadding)
            .padding(.top, 24)
            .padding(.bottom, 8)
    }

    private func card<Content: View>(@ViewBuilder _ content: () -> Content) -> some View {
        VStack(spacing: 0) { content() }
            .background(Theme.ColorToken.background)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .strokeBorder(Theme.ColorToken.borderLight, lineWidth: 1)
            )
            .padding(.horizontal, cardInset)
    }

    private var rowDivider: some View {
        Rectangle()
            .fill(Theme.ColorToken.borderLight)
            .frame(height: 1)
            .padding(.leading, rowPadding)
    }

    private var chevron: some View {
        Image(systemName: "chevron.right")
            .font(.system(size: 13, weight: .semibold))
            .foregroundStyle(Theme.ColorToken.textGhost)
    }

    /// Title with optional muted subtitle, used inside toggles and action rows.
    private func rowLabel(_ title: String, subtitle: String?) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title).font(Theme.FontToken.inter(15))
            if let subtitle {
                Text(subtitle)
                    .font(Theme.FontToken.inter(11))
                    .foregroundStyle(Theme.ColorToken.textMuted)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    /// A tappable navigation row: label, optional trailing value, chevron.
    private func navRow(_ label: String, value: String?, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            navRowLabel(label, value: value)
        }
        .buttonStyle(.plain)
    }

    private func navRowLabel(_ label: String, value: String?) -> some View {
        HStack(spacing: 8) {
            Text(label).font(Theme.FontToken.inter(15))
            Spacer()
            if let value {
                Text(value)
                    .font(Theme.FontToken.inter(14))
                    .foregroundStyle(Theme.ColorToken.textMuted)
            }
            chevron
        }
        .padding(.horizontal, rowPadding)
        .padding(.vertical, 14)
        .contentShape(Rectangle())
    }

    private func destructiveRowLabel(_ label: String) -> some View {
        Text(label)
            .font(Theme.FontToken.inter(15))
            .foregroundStyle(.red)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, rowPadding)
            .padding(.vertical, 14)
            .contentShape(Rectangle())
    }

    private func footnote(_ text: String, color: Color) -> some View {
        Text(text)
            .font(Theme.FontToken.inter(11))
            .foregroundStyle(color)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, cardInset + rowPadding)
            .padding(.top, 6)
    }

    // MARK: - Helpers

    /// Current nationality as flag + localized name (from the global ISO list).
    private var nationalityLabel: String? {
        let cc = appEnv.preferences.countryCode.uppercased()
        guard !cc.isEmpty else { return nil }
        if let c = ISO3166.all.first(where: { $0.code == cc }) { return "\(c.flag) \(c.name)" }
        return "\(ISO3166.flag(cc)) \(cc)"
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
                    Task {
                        await PrepReminderService.cancelItemReminders()
                        await TripReminderService.cancelAll()
                    }
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
