import SwiftUI

/// Inline intercity commute card between morning and afternoon sights on a hop day.
struct IntercityHopCard: View {
    let hop: ItineraryIntercityHop
    var onArrivalTimeChange: ((String?) -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Text("🚄")
                Text(String(localized: "Intercity travel"))
                    .font(Theme.FontToken.inter(13, weight: .medium))
                    .foregroundStyle(Theme.ColorToken.textPrimary)
            }
            ForEach(hop.items, id: \.self) { item in
                Text("· \(item)")
                    .font(Theme.FontToken.inter(12))
                    .foregroundStyle(Theme.ColorToken.textSecondary)
            }
            if let onArrivalTimeChange {
                Rectangle()
                    .fill(Theme.ColorToken.borderLight)
                    .frame(height: 1)
                    .padding(.vertical, 4)
                IntercityArrivalTimePicker(
                    arrivalTime: hop.arrivalTimeAtDestination,
                    onChange: onArrivalTimeChange
                )
            }
        }
        .padding(14)
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
