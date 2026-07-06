import SwiftUI

/// Bookend card for international arrival or departure at the top/bottom of the Review itinerary list.
struct InternationalEndpointCard: View {
    enum Kind {
        case inbound
        case outbound

        var emoji: String {
            switch self {
            case .inbound: return "✈️"
            case .outbound: return "🧳"
            }
        }

        var title: LocalizedStringKey {
            switch self {
            case .inbound: return "International arrival"
            case .outbound: return "International departure"
            }
        }

        var toggleLabel: LocalizedStringKey {
            switch self {
            case .inbound: return "Set landing time"
            case .outbound: return "Set departure time"
            }
        }

        var pickerLabel: LocalizedStringKey {
            switch self {
            case .inbound: return "Landing time"
            case .outbound: return "Departure time"
            }
        }
    }

    let kind: Kind
    let cityId: String
    let cityDisplayName: String
    /// Calendar arrival/departure date (startDate / endDate).
    var calendarDate: Date? = nil
    let flightTime: String?
    let onTimeChange: (String?) -> Void

    private var calendarDateLabel: String? {
        guard let calendarDate else { return nil }
        return PlanTripDateMath.formatDisplayDate(calendarDate)
    }

    private var cardItems: [String] {
        switch kind {
        case .inbound:
            if let flightTime, !flightTime.isEmpty {
                return CityTravelHints.internationalArrivalItems(cityId: cityId, arrivalTime: flightTime)
            }
            return CityTravelHints.internationalArrivalPlaceholder(cityId: cityId)
        case .outbound:
            if let flightTime, !flightTime.isEmpty {
                return CityTravelHints.internationalDepartureItems(cityId: cityId, departureTime: flightTime)
            }
            return CityTravelHints.internationalDeparturePlaceholder(cityId: cityId)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Text(kind.emoji)
                Text(kind.title)
                    .font(Theme.FontToken.inter(13, weight: .medium))
                    .foregroundStyle(Theme.ColorToken.textPrimary)
            }

            if let calendarDateLabel {
                HStack(spacing: 4) {
                    Text(calendarDateLabel)
                        .font(Theme.FontToken.inter(12, weight: .medium))
                        .foregroundStyle(Theme.ColorToken.textPrimary)
                    if !cityDisplayName.isEmpty {
                        Text("·")
                            .foregroundStyle(Theme.ColorToken.textDisabled)
                        Text(cityDisplayName)
                            .font(Theme.FontToken.inter(12))
                            .foregroundStyle(Theme.ColorToken.textMuted)
                    }
                }
            } else if !cityDisplayName.isEmpty {
                Text(cityDisplayName)
                    .font(Theme.FontToken.inter(11))
                    .foregroundStyle(Theme.ColorToken.textMuted)
            }

            ForEach(cardItems, id: \.self) { item in
                Text("· \(item)")
                    .font(Theme.FontToken.inter(12))
                    .foregroundStyle(Theme.ColorToken.textSecondary)
            }

            Rectangle()
                .fill(Theme.ColorToken.borderLight)
                .frame(height: 1)
                .padding(.vertical, 4)

            IntercityArrivalTimePicker(
                arrivalTime: flightTime,
                style: .compact,
                toggleLabel: kind.toggleLabel,
                pickerLabel: kind.pickerLabel,
                setTimeSummaryFormat: kind == .inbound ? "Land at %@" : "Depart at %@",
                onChange: onTimeChange
            )
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.ColorToken.backgroundSubtle)
        .overlay(Rectangle().stroke(Theme.ColorToken.borderLight, lineWidth: 1))
    }
}
