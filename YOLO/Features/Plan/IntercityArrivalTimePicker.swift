import SwiftUI

/// HH:mm picker for flight arrival/departure times (Review flow).
struct IntercityArrivalTimePicker: View {
    enum Style {
        case compact
        case expanded
    }

    let arrivalTime: String?
    var style: Style = .compact
    var toggleLabel: LocalizedStringKey = "Set arrival time at destination"
    var pickerLabel: LocalizedStringKey = "Arrival time"
    var setTimeSummaryFormat: LocalizedStringKey = "Arrive at %@"
    let onChange: (String?) -> Void

    @State private var pickerDate: Date = Date()
    @State private var isEnabled = false
    @State private var isExpanded = false

    var body: some View {
        switch style {
        case .expanded:
            expandedBody
        case .compact:
            compactBody
        }
    }

    private var expandedBody: some View {
        VStack(alignment: .leading, spacing: 8) {
            timeControls
        }
        .onAppear { syncFromArrivalTime() }
        .onChange(of: arrivalTime) { _, _ in syncFromArrivalTime() }
    }

    private var compactBody: some View {
        VStack(alignment: .leading, spacing: 6) {
            Button {
                withAnimation(.easeInOut(duration: 0.2)) { isExpanded.toggle() }
            } label: {
                HStack(spacing: 8) {
                    Text(compactHeaderLabel)
                        .font(Theme.FontToken.inter(12, weight: .medium))
                        .foregroundStyle(Theme.ColorToken.textPrimary)
                    Spacer(minLength: 0)
                    Image(systemName: "chevron.down")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            if isExpanded {
                timeControls
            }
        }
        .onAppear {
            syncFromArrivalTime()
            if arrivalTime != nil { isExpanded = false }
        }
        .onChange(of: arrivalTime) { _, newValue in
            syncFromArrivalTime()
            if newValue != nil { isExpanded = false }
        }
    }

    private var compactHeaderLabel: String {
        if let arrivalTime, !arrivalTime.isEmpty {
            return String(format: String(localized: setTimeSummaryFormat), arrivalTime)
        }
        return String(localized: toggleLabel)
    }

    @ViewBuilder
    private var timeControls: some View {
        Toggle(isOn: $isEnabled) {
            Text(toggleLabel)
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
                pickerLabel,
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
