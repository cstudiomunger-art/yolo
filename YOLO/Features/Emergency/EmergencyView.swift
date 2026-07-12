import SwiftUI

/// Emergency hub — one-tap 110/120, CMS help & medical guides, per-city hospitals.
struct EmergencyView: View {
    @Environment(AppEnvironment.self) private var appEnv
    @Environment(\.dismiss) private var dismiss

    @State private var data: EmergencyData?
    @State private var helpItems: [EmergencyContentItem] = []
    @State private var medicalItems: [EmergencyContentItem] = []
    @State private var hospitals: [CityHospital] = []
    @State private var allCities: [City] = []
    @State private var cityNames: [String: String] = [:]
    @State private var selectedCityId = ""

    private var tripCityIds: [String] {
        if let trip = appEnv.visibleActiveItinerary {
            let ordered = SampleItinerary.orderedCityIds(from: trip)
            if !ordered.isEmpty { return ordered }
        }
        let selected = appEnv.preferences.selectedCityIds
        if !selected.isEmpty { return selected }
        return ["beijing"]
    }

    private var pickerCityIds: [String] {
        if !allCities.isEmpty { return allCities.map(\.id) }
        return tripCityIds
    }

    private var emergencyContacts: [EmergencyContact] {
        let fromData = data?.contacts.filter {
            !$0.number.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        } ?? []
        if !fromData.isEmpty { return fromData }
        return [
            EmergencyContact(label: "Police", number: "110", note: "24/7 emergency"),
            EmergencyContact(label: "Ambulance", number: "120", note: "Medical emergency"),
        ]
    }

    private func cityLabel(_ cityId: String) -> String {
        if let city = allCities.first(where: { $0.id == cityId }) {
            let emoji = city.emoji ?? ""
            let label = "\(emoji) \(city.name)".trimmingCharacters(in: .whitespaces)
            return label.isEmpty ? city.name : label
        }
        return cityNames[cityId] ?? cityId.capitalized
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    geniusCard
                    callBlock
                    helpSection
                    medicalSection
                }
                .padding(Theme.screenPadding)
            }
            .navigationTitle("Emergency")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .confirmationAction) { Button("Done") { dismiss() } } }
            .task { await loadContent() }
            .onChange(of: selectedCityId) { _, _ in
                Task { await loadCityResources() }
            }
        }
    }

    // MARK: - Genius Bar

    private var geniusCard: some View {
        Button { appEnv.navigation.presentGeniusBar() } label: {
            HStack(spacing: 12) {
                Text("💬").font(.system(size: 22))
                VStack(alignment: .leading, spacing: 2) {
                    Text("Need a real person? Genius Bar").font(Theme.FontToken.inter(13, weight: .semibold)).foregroundStyle(Theme.ColorToken.onSurfaceEmphasis)
                    Text("Emergency situations — reach our team directly").font(Theme.FontToken.inter(10)).foregroundStyle(Theme.ColorToken.onSurfaceEmphasis.opacity(0.6))
                }
                Spacer()
                Image(systemName: "chevron.right").foregroundStyle(Theme.ColorToken.onSurfaceEmphasis.opacity(0.5))
            }
            .padding(15)
            .background(Theme.ColorToken.surfaceEmphasis)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }

    // MARK: - One-tap call

    private var callBlock: some View {
        VStack(alignment: .leading, spacing: 12) {
            blockLabel("🚨 Emergency numbers · tap to call")
            Text("Tap a number to call. Your phone will ask you to confirm.")
                .font(Theme.FontToken.inter(10))
                .foregroundStyle(Theme.ColorToken.textMuted)
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                ForEach(emergencyContacts) { contact in
                    callButton(contact: contact)
                }
            }
        }
        .padding(16)
        .background(Theme.ColorToken.warningBackground)
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.ColorToken.warning.opacity(0.35), lineWidth: 1))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private func callButton(contact: EmergencyContact) -> some View {
        Link(destination: telURL(contact.number)) {
            VStack(spacing: 4) {
                Text(contact.number).font(Theme.FontToken.playfair(26, weight: .bold)).foregroundStyle(Theme.ColorToken.warning)
                Text(contact.label).font(Theme.FontToken.inter(10)).foregroundStyle(Theme.ColorToken.textMuted)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(Theme.ColorToken.background)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.ColorToken.warning.opacity(0.4), lineWidth: 1))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    // MARK: - Help (no section title)

    @ViewBuilder
    private var helpSection: some View {
        if !helpItems.isEmpty {
            VStack(spacing: 8) {
                ForEach(helpItems) { item in
                    contentRow(item)
                }
            }
        }
    }

    // MARK: - Medical & meds

    private var medicalSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            blockLabel("🏥 Medical & medication")
            if !medicalItems.isEmpty {
                VStack(spacing: 8) {
                    ForEach(medicalItems) { item in
                        contentRow(item)
                    }
                }
            }
            hospitalsSection
        }
    }

    private func contentRow(_ item: EmergencyContentItem) -> some View {
        NavigationLink {
            EmergencyContentDetailView(item: item)
        } label: {
            HStack(spacing: 12) {
                Text(item.displayIcon).font(.system(size: 22))
                VStack(alignment: .leading, spacing: 3) {
                    Text(item.displayTitle)
                        .font(Theme.FontToken.inter(13, weight: .semibold))
                        .foregroundStyle(Theme.ColorToken.textPrimary)
                    if !item.displaySubtitle.isEmpty {
                        Text(item.displaySubtitle)
                            .font(Theme.FontToken.inter(10))
                            .foregroundStyle(Theme.ColorToken.textMuted)
                            .multilineTextAlignment(.leading)
                    }
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Theme.ColorToken.textMuted)
            }
            .padding(14)
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.ColorToken.border, lineWidth: 1))
        }
        .buttonStyle(.plain)
    }

    // MARK: - City hospitals

    private var hospitalsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Recommended hospitals · \(cityLabel(selectedCityId))")
                .font(Theme.FontToken.inter(13, weight: .semibold))
            cityPickerCard
            if !hospitals.isEmpty {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(hospitals) { hospital in
                        hospitalRow(hospital)
                    }
                }
                .padding(12)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.ColorToken.border, lineWidth: 1))
            } else {
                Text("No recommended hospitals for \(cityLabel(selectedCityId)) yet. Try another city or call 120.")
                    .font(Theme.FontToken.inter(11))
                    .foregroundStyle(Theme.ColorToken.textMuted)
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.ColorToken.border, lineWidth: 1))
            }
        }
        .padding(.top, 4)
    }

    private func hospitalRow(_ hospital: CityHospital) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(hospital.displayName)
                        .font(Theme.FontToken.inter(12, weight: .medium))
                    if hospital.hasInternationalDept {
                        Text("International department")
                            .font(Theme.FontToken.inter(10))
                            .foregroundStyle(Theme.ColorToken.accent)
                    }
                    if let address = hospital.displayAddress {
                        Text(address)
                            .font(Theme.FontToken.inter(10))
                            .foregroundStyle(Theme.ColorToken.textMuted)
                    }
                    if !hospital.note.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        Text(hospital.note)
                            .font(Theme.FontToken.inter(10))
                            .foregroundStyle(Theme.ColorToken.textSecondary)
                    }
                }
                Spacer(minLength: 8)
                if !hospital.phone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    Link(hospital.phone, destination: telURL(hospital.phone))
                        .font(Theme.FontToken.playfair(13, weight: .semibold))
                        .foregroundStyle(Theme.ColorToken.textPrimary)
                }
            }
        }
        .padding(.top, 8)
        .overlay(alignment: .top) { Rectangle().fill(Theme.ColorToken.borderLight).frame(height: 1) }
    }

    private var cityPickerCard: some View {
        cityPickerRow
            .padding(12)
            .background(Theme.ColorToken.backgroundSubtle)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    private var cityPickerRow: some View {
        HStack {
            Text("View city").font(Theme.FontToken.inter(11)).foregroundStyle(Theme.ColorToken.textMuted)
            Spacer()
            Menu {
                ForEach(pickerCityIds, id: \.self) { cityId in
                    Button(cityLabel(cityId)) { selectedCityId = cityId }
                }
            } label: {
                Text("\(cityLabel(selectedCityId)) ⌄")
                    .font(Theme.FontToken.inter(12, weight: .medium))
                    .foregroundStyle(Theme.ColorToken.accent)
            }
        }
    }

    private func telURL(_ phone: String) -> URL {
        URL(string: "tel://\(phone.filter { $0.isNumber || $0 == "+" })")!
    }

    @MainActor
    private func loadContent() async {
        data = try? await appEnv.content.fetchEmergencyData()
        helpItems = (try? await appEnv.content.fetchEmergencyHelpItems()) ?? []
        medicalItems = (try? await appEnv.content.fetchEmergencyMedicalItems()) ?? []
        if let cities = try? await appEnv.content.fetchCities() {
            allCities = cities
            cityNames = Dictionary(uniqueKeysWithValues: cities.map { ($0.id, $0.name) })
        }
        if selectedCityId.isEmpty {
            let preferred = tripCityIds.first { pickerCityIds.contains($0) }
                ?? pickerCityIds.first
                ?? "beijing"
            selectedCityId = preferred
        }
        await loadCityResources()
    }

    @MainActor
    private func loadCityResources() async {
        guard !selectedCityId.isEmpty else { return }
        hospitals = (try? await appEnv.content.fetchCityHospitals(cityId: selectedCityId)) ?? []
    }

    // MARK: - Shared pieces

    private func blockLabel(_ text: String) -> some View {
        Text(text).font(Theme.FontToken.playfair(15, weight: .semibold))
    }
}
