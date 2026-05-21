import SwiftUI

struct ExperienceSuggestionsDayCard: View {
    let day: ItineraryDay
    let cityDisplayName: String
    var onAskAssistant: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 6) {
                Text("💡")
                Text(String(localized: "Local Experiences to Try"))
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

            Rectangle()
                .fill(Theme.ColorToken.borderLight)
                .frame(height: 1)

            Text(String(localized: "These are experience ideas — no specific venues. Ask Assistant for details."))
                .font(Theme.FontToken.inter(10))
                .foregroundStyle(Theme.ColorToken.textMuted)
                .fixedSize(horizontal: false, vertical: true)

            Button(action: onAskAssistant) {
                Text(String(localized: "Ask Assistant →"))
                    .font(Theme.FontToken.inter(11, weight: .medium))
                    .foregroundStyle(Theme.ColorToken.accent)
            }
            .buttonStyle(.plain)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.ColorToken.backgroundSubtle)
        .overlay {
            RoundedRectangle(cornerRadius: 4, style: .continuous)
                .strokeBorder(
                    Theme.ColorToken.border,
                    style: StrokeStyle(lineWidth: 1, dash: [5, 4])
                )
        }
    }
}
