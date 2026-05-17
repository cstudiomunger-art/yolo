import SwiftUI

struct CountryPickerView: View {
    enum Mode {
        case onboarding
        case profileEdit
    }

    @Environment(AppEnvironment.self) private var appEnv
    @Environment(\.dismiss) private var dismiss

    var mode: Mode = .onboarding
    @State private var search = ""
    @State private var countries: [PassportCountry] = []
    @State private var loadError: String?

    private var filtered: [PassportCountry] {
        guard !search.isEmpty else { return countries }
        return countries.filter {
            $0.name.localizedCaseInsensitiveContains(search) || $0.code.localizedCaseInsensitiveContains(search)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                Text(mode == .onboarding ? "ChinaGo" : "Passport Country")
                    .font(Theme.FontToken.playfair(22, weight: .bold))
                    .foregroundStyle(Theme.ColorToken.textPrimary)
                Text("Select your passport country")
                    .font(Theme.FontToken.inter(12))
                    .foregroundStyle(Theme.ColorToken.textMuted)
            }
            .padding(.horizontal, Theme.screenPadding)
            .padding(.top, mode == .onboarding ? 48 : 24)
            .padding(.bottom, 20)

            if let loadError {
                Text(loadError)
                    .font(Theme.FontToken.inter(11))
                    .foregroundStyle(.red)
                    .padding(.horizontal, Theme.screenPadding)
                    .padding(.bottom, 8)
            }

            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(Theme.ColorToken.textDisabled)
                TextField("Search country...", text: $search)
                    .font(Theme.FontToken.inter(12))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 9)
            .background(Theme.ColorToken.backgroundSubtle)
            .overlay(
                Rectangle()
                    .stroke(Theme.ColorToken.border, lineWidth: 1)
            )
            .padding(.horizontal, Theme.screenPadding)
            .padding(.bottom, 16)

            if countries.isEmpty && loadError == nil {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding()
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(filtered) { country in
                            Button {
                                selectCountry(country.code)
                            } label: {
                                HStack(spacing: 12) {
                                    Text(country.flag)
                                        .font(.title2)
                                    Text(country.name)
                                        .font(Theme.FontToken.inter(14))
                                        .foregroundStyle(Theme.ColorToken.textPrimary)
                                    Spacer()
                                    if appEnv.preferences.countryCode == country.code {
                                        Image(systemName: "checkmark")
                                            .foregroundStyle(Theme.ColorToken.accent)
                                    }
                                }
                                .padding(.vertical, 14)
                                .padding(.horizontal, Theme.screenPadding)
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)

                            Rectangle()
                                .fill(Theme.ColorToken.borderLight)
                                .frame(height: 1)
                                .padding(.leading, Theme.screenPadding)
                        }
                    }
                }
            }
        }
        .background(Theme.ColorToken.background)
        .navigationTitle(mode == .profileEdit ? "Passport" : "")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if mode == .profileEdit {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
        .task { await loadCountries() }
    }

    private func loadCountries() async {
        do {
            countries = try await appEnv.content.fetchPassportCountries()
            loadError = nil
        } catch {
            loadError = error.localizedDescription
            countries = []
        }
    }

    private func selectCountry(_ code: String) {
        appEnv.preferences.countryCode = code
        Task { await appEnv.refreshVisaRule() }
        switch mode {
        case .onboarding:
            appEnv.preferences.hasCompletedOnboarding = true
        case .profileEdit:
            Task {
                await appEnv.profileSync.pushToRemote()
                dismiss()
            }
        }
    }
}
