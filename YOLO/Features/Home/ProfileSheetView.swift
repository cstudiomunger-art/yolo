import SwiftUI
import UIKit

struct ProfileSheetView: View {
    @Environment(AppEnvironment.self) private var appEnv
    @Environment(\.dismiss) private var dismiss

    @State private var showLogin = false
    @State private var showEditProfile = false
    @State private var showMembership = false
    @State private var showSettings = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    identitySection
                    membershipSummarySection
                    navigationButtons
                }
            }
            .navigationTitle(String(localized: "Profile"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(String(localized: "Done")) { dismiss() }
                }
            }
            // Login sheet
            .sheet(isPresented: $showLogin) {
                NavigationStack {
                    LoginView()
                        .environment(appEnv)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button(String(localized: "Close")) { showLogin = false }
                            }
                        }
                }
            }
            .onChange(of: appEnv.auth.isAuthenticated) { _, isAuthenticated in
                if isAuthenticated {
                    showLogin = false
                    Task { await appEnv.syncAfterSignIn() }
                }
            }
            // Edit profile sheet
            .sheet(isPresented: $showEditProfile) {
                EditProfileView()
                    .environment(appEnv)
            }
            // Membership center (pushed)
            .navigationDestination(isPresented: $showMembership) {
                MembershipCenterView()
                    .environment(appEnv)
            }
            // Settings (pushed)
            .navigationDestination(isPresented: $showSettings) {
                SettingsView()
                    .environment(appEnv)
            }
            .onDisappear {
                if appEnv.auth.isAuthenticated {
                    Task { await appEnv.profileSync.pushToRemote() }
                }
            }
        }
    }

    // MARK: - Identity section

    private var identitySection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 14) {
                Button {
                    if appEnv.auth.isAuthenticated { showEditProfile = true }
                } label: {
                    ProfileAvatarButton(
                        avatarUrl: appEnv.visibleProfileAvatarUrl,
                        displayName: appEnv.visibleProfileName,
                        size: 56,
                        action: {}
                    )
                    .allowsHitTesting(false)
                }
                .buttonStyle(.plain)
                .disabled(!appEnv.auth.isAuthenticated)

                VStack(alignment: .leading, spacing: 3) {
                    if let name = appEnv.visibleProfileName {
                        Text(name)
                            .font(Theme.FontToken.playfair(16, weight: .semibold))
                    } else if let email = appEnv.auth.userEmail {
                        Text(email)
                            .font(Theme.FontToken.inter(13))
                            .lineLimit(1)
                    } else {
                        Text(String(localized: "Guest"))
                            .font(Theme.FontToken.playfair(16, weight: .semibold))
                    }
                    if let visa = appEnv.preferences.visaRule() {
                        Text("\(visa.flag) \(visa.countryName) Passport")
                            .font(Theme.FontToken.inter(11))
                            .foregroundStyle(Theme.ColorToken.textMuted)
                    }
                }

                Spacer()

                if appEnv.auth.isAuthenticated {
                    Button {
                        showEditProfile = true
                    } label: {
                        Text(String(localized: "Edit"))
                            .font(Theme.FontToken.inter(11, weight: .medium))
                            .foregroundStyle(Theme.ColorToken.accent)
                    }
                    .buttonStyle(.plain)
                }
            }

            if !appEnv.auth.isAuthenticated, !AppConfig.useMock {
                Button(String(localized: "Sign in / Register →")) {
                    showLogin = true
                }
                .font(Theme.FontToken.inter(12, weight: .medium))
                .foregroundStyle(Theme.ColorToken.accent)
            }

            if appEnv.profileSync.isSyncing {
                HStack(spacing: 6) {
                    ProgressView()
                    Text(String(localized: "Syncing…"))
                        .font(Theme.FontToken.inter(10))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                }
            }
        }
        .padding(Theme.screenPadding)
    }

    // MARK: - Membership summary

    private var membershipSummarySection: some View {
        Button {
            showMembership = true
        } label: {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 3) {
                    if appEnv.purchase.isMembershipBanned {
                        Text(String(localized: "Membership suspended"))
                            .font(Theme.FontToken.inter(13, weight: .medium))
                            .foregroundStyle(Theme.ColorToken.warning)
                        Text(String(localized: "Contact support"))
                            .font(Theme.FontToken.inter(11))
                            .foregroundStyle(Theme.ColorToken.textMuted)
                    } else if appEnv.purchase.isProActive {
                        Text("✨ " + appEnv.purchase.displayMembershipPlanName())
                            .font(Theme.FontToken.inter(13, weight: .medium))
                        if let expires = appEnv.preferences.effectiveMembershipExpiry {
                            Text(String(localized: "Valid until: ") + expires.formatted(date: .abbreviated, time: .omitted))
                                .font(Theme.FontToken.inter(11))
                                .foregroundStyle(Theme.ColorToken.textMuted)
                        }
                    } else {
                        Text(String(localized: "Free"))
                            .font(Theme.FontToken.inter(13, weight: .medium))
                        Text(String(localized: "Upgrade to unlock all content"))
                            .font(Theme.FontToken.inter(11))
                            .foregroundStyle(Theme.ColorToken.textMuted)
                    }
                }
                Spacer()
                Text("›")
                    .foregroundStyle(Theme.ColorToken.textGhost)
                    .font(.system(size: 18))
            }
            .padding(16)
            .background(Theme.ColorToken.backgroundSubtle)
            .padding(.horizontal, Theme.screenPadding)
        }
        .buttonStyle(.plain)
        .onChange(of: appEnv.membershipRevision) { _, _ in }
    }

    // MARK: - Navigation buttons

    private var navigationButtons: some View {
        VStack(spacing: 0) {
            navRow(String(localized: "Membership & Purchases"), icon: "crown") {
                showMembership = true
            }
            navRow(String(localized: "Settings"), icon: "gearshape") {
                showSettings = true
            }
        }
        .padding(.top, 20)
    }

    private func navRow(_ label: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .frame(width: 20)
                    .foregroundStyle(Theme.ColorToken.textSecondary)
                Text(label)
                    .font(Theme.FontToken.inter(14))
                Spacer()
                Text("›")
                    .foregroundStyle(Theme.ColorToken.textGhost)
            }
            .padding(.vertical, 14)
            .padding(.horizontal, Theme.screenPadding)
            .overlay(alignment: .bottom) {
                Rectangle().fill(Theme.ColorToken.borderLight).frame(height: 1)
            }
        }
        .buttonStyle(.plain)
    }
}

