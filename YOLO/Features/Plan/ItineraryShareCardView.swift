import SwiftUI
import UIKit

/// Card layout rendered to a bitmap for system share (WeChat, Messages, Save Image, etc.).
struct ItineraryShareCardView: View {
    let itinerary: SampleItinerary

    private let cardWidth: CGFloat = 390
    private let maxDays = 8
    private let maxActivitiesPerDay = 6

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            header
            ForEach(Array(itinerary.days.prefix(maxDays))) { day in
                daySection(day)
            }
            if itinerary.days.count > maxDays {
                Text(String(format: String(localized: "+%lld more days"), itinerary.days.count - maxDays))
                    .font(Theme.FontToken.inter(11))
                    .foregroundStyle(Theme.ColorToken.textMuted)
            }
            footer
        }
        .padding(24)
        .frame(width: cardWidth, alignment: .leading)
        .background(
            LinearGradient(
                colors: [Color(hex: 0xFFFCF8), Theme.ColorToken.backgroundSubtle],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .overlay(
            Rectangle()
                .stroke(Theme.ColorToken.border, lineWidth: 1)
        )
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("🇨🇳 \(itinerary.title)")
                .font(Theme.FontToken.playfair(22, weight: .semibold))
                .foregroundStyle(Theme.ColorToken.textPrimary)
            if !itinerary.meta.isEmpty {
                Text(itinerary.meta)
                    .font(Theme.FontToken.inter(12))
                    .foregroundStyle(Theme.ColorToken.textSecondary)
            }
            if !itinerary.routeSummary.isEmpty {
                Text(itinerary.routeSummary)
                    .font(Theme.FontToken.inter(11, weight: .medium))
                    .foregroundStyle(Theme.ColorToken.accent)
            }
            if !itinerary.estimatedBudget.isEmpty {
                Text(itinerary.estimatedBudget)
                    .font(Theme.FontToken.inter(11))
                    .foregroundStyle(Theme.ColorToken.textMuted)
            }
        }
    }

    private func daySection(_ day: ItineraryDay) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(day.dateLabel)
                .font(Theme.FontToken.inter(11, weight: .semibold))
                .foregroundStyle(Theme.ColorToken.textMuted)
                .textCase(.uppercase)
            ForEach(Array(day.activities.prefix(maxActivitiesPerDay))) { act in
                HStack(alignment: .top, spacing: 8) {
                    Text("•")
                        .font(Theme.FontToken.inter(12))
                        .foregroundStyle(Theme.ColorToken.accent)
                    Text(act.name)
                        .font(Theme.FontToken.inter(13))
                        .foregroundStyle(Theme.ColorToken.textPrimary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            if day.activities.count > maxActivitiesPerDay {
                Text(String(format: String(localized: "  +%lld more"), day.activities.count - maxActivitiesPerDay))
                    .font(Theme.FontToken.inter(10))
                    .foregroundStyle(Theme.ColorToken.textMuted)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.85))
        .overlay(Rectangle().stroke(Theme.ColorToken.borderLight, lineWidth: 1))
    }

    private var footer: some View {
        HStack {
            Text("YOLO HAPPY")
                .font(Theme.FontToken.playfair(14, weight: .semibold))
                .foregroundStyle(Theme.ColorToken.textPrimary)
            Spacer()
            Text(String(localized: "China travel companion"))
                .font(Theme.FontToken.inter(10))
                .foregroundStyle(Theme.ColorToken.textMuted)
        }
        .padding(.top, 4)
    }
}

@MainActor
enum ItineraryShareImageRenderer {
    static func render(itinerary: SampleItinerary, scale: CGFloat? = nil) -> UIImage? {
        let card = ItineraryShareCardView(itinerary: itinerary)
        let renderer = ImageRenderer(content: card)
        renderer.scale = scale ?? Theme.DisplayScale.primary
        return renderer.uiImage
    }
}
