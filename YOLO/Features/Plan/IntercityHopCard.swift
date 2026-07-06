import SwiftUI

/// Inline intercity commute card between morning and afternoon sights on a hop day.
struct IntercityHopCard: View {
    let hop: ItineraryIntercityHop
    var isFullTravelDay: Bool = false
    var onArrivalTimeChange: ((String?) -> Void)? = nil

    private var summary: CityTravelHints.IntercityCardSummary {
        CityTravelHints.intercityCardSummary(
            fromCityId: hop.fromCityId,
            toCityId: hop.toCityId,
            travelHours: hop.travelHours,
            arrivalTime: hop.arrivalTimeAtDestination,
            isFullTravelDay: isFullTravelDay
        )
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text("🚄")
                Text(summary.routeTitle)
                    .font(Theme.FontToken.inter(13, weight: .medium))
                    .foregroundStyle(Theme.ColorToken.textPrimary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            if let contextLine = summary.contextLine {
                Text(contextLine)
                    .font(Theme.FontToken.inter(11))
                    .foregroundStyle(Theme.ColorToken.textMuted)
                    .fixedSize(horizontal: false, vertical: true)
            }

            if let onArrivalTimeChange {
                Rectangle()
                    .fill(Theme.ColorToken.borderLight)
                    .frame(height: 1)
                    .padding(.vertical, 2)
                IntercityArrivalTimePicker(
                    arrivalTime: hop.arrivalTimeAtDestination,
                    onChange: onArrivalTimeChange
                )
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.ColorToken.backgroundSubtle)
        .overlay(Rectangle().stroke(Theme.ColorToken.borderLight, lineWidth: 1))
    }
}

enum PlanItineraryHopUI {
    static func splitActivities(_ day: ItineraryDay) -> (morning: [ItineraryActivity], afternoon: [ItineraryActivity]) {
        guard let hop = day.intercityHop else {
            let morning = day.activities.filter { $0.timeSlot == "Morning" }
            let afternoon = day.activities.filter { $0.timeSlot != "Morning" }
            return (morning, afternoon)
        }
        let from = hop.fromCityId.lowercased()
        var morning: [ItineraryActivity] = []
        var afternoon: [ItineraryActivity] = []
        for act in day.activities {
            if act.cityId?.lowercased() == from {
                morning.append(act)
            } else {
                afternoon.append(act)
            }
        }
        return (morning, afternoon)
    }
}
