import SwiftUI

/// HH:mm picker for intercity arrival at the destination city (Review flow).
struct IntercityArrivalTimePicker: View {
    let arrivalTime: String?
    let onChange: (String?) -> Void

    @State private var pickerDate: Date = Date()
    @State private var isEnabled = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Toggle(isOn: $isEnabled) {
                Text(String(localized: "Set arrival time at destination"))
                    .font(Theme.FontToken.inter(12, weight: .medium))
                    .foregroundStyle(Theme.ColorToken.textPrimary)
            }
            .toggleStyle(.switch)
            .tint(Theme.ColorToken.accent)
            .onChange(of: isEnabled) { _, enabled in
                if enabled {
                    onChange(PlanItineraryFlightTimes.formatHHMM(from: pickerDate))
                } else {
                    onChange(nil)
                }
            }

            if isEnabled {
                DatePicker(
                    String(localized: "Arrival time"),
                    selection: $pickerDate,
                    displayedComponents: .hourAndMinute
                )
                .datePickerStyle(.compact)
                .font(Theme.FontToken.inter(12))
                .onChange(of: pickerDate) { _, date in
                    onChange(PlanItineraryFlightTimes.formatHHMM(from: date))
                }
            }
        }
        .onAppear { syncFromArrivalTime() }
        .onChange(of: arrivalTime) { _, _ in syncFromArrivalTime() }
    }

    private func syncFromArrivalTime() {
        if let arrivalTime, let mins = PlanItineraryFlightTimes.parseMinuteOfDay(arrivalTime) {
            isEnabled = true
            let h = mins / 60
            let m = mins % 60
            pickerDate = Calendar.current.date(bySettingHour: h, minute: m, second: 0, of: Date()) ?? pickerDate
        } else {
            isEnabled = false
        }
    }
}
