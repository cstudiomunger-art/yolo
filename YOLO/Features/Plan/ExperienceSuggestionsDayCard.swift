import SwiftUI

struct ExperienceSuggestionsDayCard: View {
    let day: ItineraryDay
    let cityDisplayName: String
    var showsActivities: Bool = true
    var onArrivalTimeChange: ((String?) -> Void)? = nil

    private var isTravelDay: Bool {
        day.intercityHop != nil
            || day.experienceItems.contains { $0.localizedCaseInsensitiveContains("travel from") }
            || day.experienceItems.contains { $0.localizedCaseInsensitiveContains("intercity travel") }
    }

    private var isArrivalDay: Bool {
        day.experienceItems.first?.localizedCaseInsensitiveContains("Afternoon arrival") == true
    }

    private var isDepartureDay: Bool {
        day.experienceItems.first?.localizedCaseInsensitiveContains("Morning departure") == true
    }

    private var cardTitle: String {
        if isTravelDay { return String(localized: "Travel day") }
        if isArrivalDay { return String(localized: "Arrival day") }
        if isDepartureDay { return String(localized: "Departure day") }
        return String(localized: "Local Experiences to Try")
    }

    private var cardEmoji: String {
        if isTravelDay { return "🚄" }
        if isArrivalDay { return "✈️" }
        if isDepartureDay { return "🧳" }
        return "💡"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 6) {
                Text(cardEmoji)
                Text(cardTitle)
                    .font(Theme.FontToken.inter(13, weight: .medium))
                    .foregroundStyle(Theme.ColorToken.textPrimary)
            }

            if !cityDisplayName.isEmpty {
                Text(cityDisplayName)
                    .font(Theme.FontToken.inter(11))
                    .foregroundStyle(Theme.ColorToken.textMuted)
            }

            VStack(alignment: .leading, spacing: 8) {
                ForEach(day.experienceItems, id: \.self) { item in
                    Text("· \(item)")
                        .font(Theme.FontToken.inter(12))
                        .foregroundStyle(Theme.ColorToken.textSecondary)
                }
            }

            if let hop = day.intercityHop, let onArrivalTimeChange {
                Rectangle()
                    .fill(Theme.ColorToken.borderLight)
                    .frame(height: 1)
                IntercityArrivalTimePicker(
                    arrivalTime: hop.arrivalTimeAtDestination,
                    onChange: onArrivalTimeChange
                )
            }

            if showsActivities, !day.activities.isEmpty {
                Rectangle()
                    .fill(Theme.ColorToken.borderLight)
                    .frame(height: 1)

                Text(String(localized: "Evening plans"))
                    .font(Theme.FontToken.inter(11, weight: .semibold))
                    .foregroundStyle(Theme.ColorToken.textSecondary)

                ForEach(day.activities) { activity in
                    Text(activity.name)
                        .font(Theme.FontToken.inter(12, weight: .medium))
                        .foregroundStyle(Theme.ColorToken.textPrimary)
                }
            }

            if !isTravelDay && !isArrivalDay && !isDepartureDay {
                Rectangle()
                    .fill(Theme.ColorToken.borderLight)
                    .frame(height: 1)

                Text(String(localized: "These are experience ideas — no specific venues."))
                    .font(Theme.FontToken.inter(10))
                    .foregroundStyle(Theme.ColorToken.textMuted)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.ColorToken.backgroundSubtle)
        .overlay {
            RoundedRectangle(cornerRadius: 4, style: .continuous)
                .strokeBorder(
                    Theme.ColorToken.border,
                    style: StrokeStyle(lineWidth: 1, dash: isTravelDay ? [] : [5, 4])
                )
        }
    }
}
