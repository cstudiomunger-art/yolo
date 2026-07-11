import SwiftUI

struct IntercityHopEditorSheet: View {
    let cityIds: [String]
    let cityNameById: [String: String]
    let defaultFromCityId: String?
    let defaultToCityId: String?
    let onConfirm: (String, String) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var fromCityId: String = ""
    @State private var toCityId: String = ""

    private var previewSummary: CityTravelHints.IntercityCardSummary? {
        guard !fromCityId.isEmpty, !toCityId.isEmpty, fromCityId != toCityId else { return nil }
        let hours = CityTravelHints.travelHours(fromCityId, toCityId)
        return CityTravelHints.intercityCardSummary(
            fromCityId: fromCityId,
            toCityId: toCityId,
            travelHours: hours,
            arrivalTime: nil,
            isFullTravelDay: CityTravelHints.commuteSlots(hours) >= 2
        )
    }

    private var canConfirm: Bool {
        !fromCityId.isEmpty && !toCityId.isEmpty && fromCityId != toCityId
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker(String(localized: "From city"), selection: $fromCityId) {
                        Text(String(localized: "Select city")).tag("")
                        ForEach(cityIds, id: \.self) { cityId in
                            Text(displayName(for: cityId)).tag(cityId)
                        }
                    }

                    Picker(String(localized: "To city"), selection: $toCityId) {
                        Text(String(localized: "Select city")).tag("")
                        ForEach(cityIds, id: \.self) { cityId in
                            Text(displayName(for: cityId)).tag(cityId)
                        }
                    }
                }

                if let preview = previewSummary {
                    Section(String(localized: "Preview")) {
                        Text(preview.routeTitle)
                            .font(Theme.FontToken.inter(13, weight: .medium))
                        if let line = preview.contextLine {
                            Text(line)
                                .font(Theme.FontToken.inter(11))
                                .foregroundStyle(Theme.ColorToken.textMuted)
                        }
                    }
                } else if !fromCityId.isEmpty && fromCityId == toCityId {
                    Section {
                        Text(String(localized: "From and To must be different cities."))
                            .font(Theme.FontToken.inter(12))
                            .foregroundStyle(Theme.ColorToken.textMuted)
                    }
                }
            }
            .navigationTitle(String(localized: "Add intercity travel"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "Cancel")) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(String(localized: "Add")) {
                        onConfirm(fromCityId, toCityId)
                        dismiss()
                    }
                    .disabled(!canConfirm)
                }
            }
            .onAppear {
                if fromCityId.isEmpty, let defaultFromCityId {
                    fromCityId = defaultFromCityId
                }
                if toCityId.isEmpty, let defaultToCityId {
                    toCityId = defaultToCityId
                }
            }
        }
    }

    private func displayName(for cityId: String) -> String {
        cityNameById[cityId] ?? CityTravelHints.displayName(for: cityId)
    }
}
