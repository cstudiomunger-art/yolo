import SwiftUI

/// Bookend international arrival/departure card plus optional manual bookend activities.
struct InternationalEndpointDaySection<ActivityRows: View, AddButton: View>: View {
    let kind: InternationalEndpointCard.Kind
    let cityId: String
    let cityDisplayName: String
    let calendarDate: Date?
    let flightTime: String?
    let activities: [ItineraryActivity]
    let onTimeChange: (String?) -> Void
    @ViewBuilder let activityRows: () -> ActivityRows
    @ViewBuilder let addAttractionButton: () -> AddButton

    private var hasFlightTime: Bool {
        PlanItineraryFlightTimes.hasMeaningfulTime(flightTime)
    }

    private var showsLinkedActivities: Bool {
        hasFlightTime && !activities.isEmpty
    }

    private var activitySectionTitle: LocalizedStringKey {
        kind == .inbound ? "Post-arrival itinerary" : "Planned sights"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            InternationalEndpointCard(
                kind: kind,
                cityId: cityId,
                cityDisplayName: cityDisplayName,
                calendarDate: calendarDate,
                flightTime: flightTime,
                onTimeChange: onTimeChange
            )

            if kind == .inbound, !hasFlightTime {
                Text(String(localized: "Set your landing time to plan sights for the arrival window."))
                    .font(Theme.FontToken.inter(11))
                    .foregroundStyle(Theme.ColorToken.textMuted)
            } else if showsLinkedActivities {
                VStack(alignment: .leading, spacing: 8) {
                    Text(activitySectionTitle)
                        .font(Theme.FontToken.inter(11, weight: .semibold))
                        .foregroundStyle(Theme.ColorToken.textSecondary)

                    activityRows()
                    addAttractionButton()
                }
            } else if hasFlightTime {
                VStack(alignment: .leading, spacing: 8) {
                    Text(activitySectionTitle)
                        .font(Theme.FontToken.inter(11, weight: .semibold))
                        .foregroundStyle(Theme.ColorToken.textSecondary)
                    Text(String(localized: "Tap + Add attraction to schedule a specific sight."))
                        .font(Theme.FontToken.inter(11))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                    addAttractionButton()
                }
            }
        }
    }
}
