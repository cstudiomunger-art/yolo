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
    @State private var draftCountryCode = ""

    private var filtered: [PassportCountry] {
        guard !search.isEmpty else { return countries }
        return countries.filter {
            $0.name.localizedCaseInsensitiveContains(search) || $0.code.localizedCaseInsensitiveContains(search)
        }
    }

    private var highlightedCode: String {
        switch mode {
        case .onboarding:
            draftCountryCode
        case .profileEdit:
            appEnv.preferences.countryCode
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header

            if let loadError {
                Text(loadError)
                    .font(Theme.FontToken.inter(11))
                    .foregroundStyle(.red)
                    .padding(.horizontal, Theme.screenPadding)
                    .padding(.bottom, 8)
            }

            searchField

            if countries.isEmpty && loadError == nil {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                countryList
            }

            if mode == .onboarding {
                continueBar
            }
        }
        .background(Theme.ColorToken.background)
        .navigationTitle(mode == .profileEdit ? "Nationality" : "")
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

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            if mode == .onboarding {
                ChinaGoLogo()
                    .padding(.bottom, 4)
                Text("Select your nationality")
                    .font(Theme.FontToken.playfair(24, weight: .bold))
                    .foregroundStyle(Theme.ColorToken.textPrimary)
            }
            if mode == .onboarding {
                Text("We'll show visa rules and travel tips for your country")
                    .font(Theme.FontToken.inter(12))
                    .foregroundStyle(Theme.ColorToken.textMuted)
            }
        }
        .padding(.horizontal, Theme.screenPadding)
        .padding(.top, mode == .onboarding ? 48 : 16)
        .padding(.bottom, mode == .onboarding ? 20 : 12)
    }

    private var searchField: some View {
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
    }

    private var countryList: some View {
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
                            if highlightedCode == country.code {
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

    private var continueBar: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Theme.ColorToken.borderLight)
                .frame(height: 1)
            Button {
                completeOnboarding()
            } label: {
                Text("Continue")
                    .font(Theme.FontToken.inter(14, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .foregroundStyle(.white)
                    .background(
                        draftCountryCode.isEmpty
                            ? Theme.ColorToken.textDisabled
                            : Theme.ColorToken.accent
                    )
            }
            .disabled(draftCountryCode.isEmpty)
            .buttonStyle(.plain)
            .padding(.horizontal, Theme.screenPadding)
            .padding(.vertical, 12)
        }
        .background(Theme.ColorToken.background)
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
        switch mode {
        case .onboarding:
            draftCountryCode = code
        case .profileEdit:
            appEnv.preferences.countryCode = code
            Task {
                await appEnv.refreshVisaRule()
                await appEnv.profileSync.pushToRemote()
                dismiss()
            }
        }
    }

    private func completeOnboarding() {
        guard !draftCountryCode.isEmpty else { return }
        appEnv.preferences.countryCode = draftCountryCode
        appEnv.preferences.markNationalityOnboardingCompleted()
        Task {
            await appEnv.refreshVisaRule()
            await appEnv.profileSync.pushToRemote()
        }
    }
}
