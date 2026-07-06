import SwiftUI

/// Bookend international arrival/departure card plus linked sightseeing-day activities.
struct InternationalEndpointDaySection<ActivityRows: View, AddButton: View>: View {
    let kind: InternationalEndpointCard.Kind
    let cityId: String
    let cityDisplayName: String
    let calendarDate: Date?
    let flightTime: String?
    let linkedDay: ItineraryDay?
    let onTimeChange: (String?) -> Void
    @ViewBuilder let activityRows: () -> ActivityRows
    @ViewBuilder let addAttractionButton: () -> AddButton

    private var showsLinkedActivities: Bool {
        guard PlanItineraryFlightTimes.hasMeaningfulTime(flightTime) else { return false }
        return linkedDay != nil && !(linkedDay?.activities.isEmpty ?? true)
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

            if showsLinkedActivities {
                VStack(alignment: .leading, spacing: 8) {
                    Text(String(localized: "Planned sights"))
                        .font(Theme.FontToken.inter(11, weight: .semibold))
                        .foregroundStyle(Theme.ColorToken.textSecondary)

                    activityRows()
                    addAttractionButton()
                }
            } else if PlanItineraryFlightTimes.hasMeaningfulTime(flightTime) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(String(localized: "Planned sights"))
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
