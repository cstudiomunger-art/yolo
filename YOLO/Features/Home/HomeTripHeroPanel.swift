import SwiftUI

/// Home hero carousel: departure countdown + per-trip summary in one card (style D).
struct HomeTripHeroPanel: View {
    let trips: [SampleItinerary]
    let citiesLine: String
    let prepCompleted: Int
    let prepTotal: Int
    let daysUntilDeparture: Int
    let departureDate: Date
    let visa: VisaRule?
    var onSetDeparture: () -> Void = {}
    var onPlanTrip: () -> Void = {}
    var onViewItinerary: (SampleItinerary) -> Void = { _ in }
    var onOpenPrepare: () -> Void = {}

    @State private var page = 0

    private let carouselHeight: CGFloat = 340
    private let countdownColumnWidth: CGFloat = 76

    var body: some View {
        VStack(spacing: 10) {
            if trips.isEmpty {
                heroCard(emptyStateContent)
                    .padding(.horizontal, Theme.screenPadding)
            } else {
                let displayTrips = trips
                let multi = displayTrips.count > 1
                ZStack(alignment: .bottom) {
                    TabView(selection: $page) {
                        ForEach(Array(displayTrips.enumerated()), id: \.element.id) { index, trip in
                            heroCard(tripContent(trip))
                                .padding(.horizontal, Theme.screenPadding)
                                .padding(.bottom, multi ? 22 : 0)
                                .tag(index)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))

                    if multi {
                        pageIndicator
                            .padding(.bottom, 28)
                    }
                }
                .frame(height: multi ? carouselHeight : 300)
            }
        }
        .padding(.top, 8)
    }

    private var pageIndicator: some View {
        HStack(spacing: 6) {
            ForEach(0..<trips.count, id: \.self) { i in
                Circle()
                    .fill(i == page ? Theme.ColorToken.textPrimary : Theme.ColorToken.border)
                    .frame(width: 6, height: 6)
            }
        }
    }

    // MARK: - Card content builders

    private var emptyStateContent: HeroCardContent {
        HeroCardContent(
            citiesLine: citiesLine,
            title: String(localized: "Your China adventure starts here"),
            datesLine: Self.formatDepartureDateOnly(departureDate),
            budgetLine: nil,
            status: nil,
            prepCompleted: prepCompleted,
            prepTotal: prepTotal,
            primaryTitle: String(localized: "Plan My First Trip"),
            secondaryTitle: String(localized: "Prep List →"),
            onPrimary: onPlanTrip,
            onSecondary: onOpenPrepare
        )
    }

    private func tripContent(_ trip: SampleItinerary) -> HeroCardContent {
        let budget = trip.estimatedBudget.trimmingCharacters(in: .whitespacesAndNewlines)
        return HeroCardContent(
            citiesLine: trip.routeSummary.isEmpty ? citiesLine : "📍 \(trip.routeSummary)",
            title: trip.title,
            datesLine: trip.meta,
            budgetLine: budget.isEmpty ? nil : budget,
            status: trip.tripStatus(),
            prepCompleted: prepCompleted,
            prepTotal: prepTotal,
            primaryTitle: String(localized: "View Itinerary"),
            secondaryTitle: String(localized: "Prep List →"),
            onPrimary: { onViewItinerary(trip) },
            onSecondary: onOpenPrepare
        )
    }

    private static func formatDepartureDateOnly(_ departureDate: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: departureDate)
    }

    // MARK: - Card UI

    private struct HeroCardContent {
        let citiesLine: String
        let title: String
        let datesLine: String?
        let budgetLine: String?
        let status: TripStatus?
        let prepCompleted: Int
        let prepTotal: Int
        let primaryTitle: String
        let secondaryTitle: String
        let onPrimary: () -> Void
        let onSecondary: () -> Void
    }

    @ViewBuilder
    private func heroCard(_ content: HeroCardContent) -> some View {
        let total = max(content.prepTotal, 1)
        let ratio = CGFloat(content.prepCompleted) / CGFloat(total)

        VStack(alignment: .leading, spacing: 16) {
            HomeHeroCountryVisaRow(visa: visa)

            HStack(alignment: .top, spacing: 16) {
                HomeDepartureCountdownBlock(
                    daysUntilDeparture: daysUntilDeparture,
                    status: content.status,
                    onTap: onSetDeparture
                )
                .frame(width: countdownColumnWidth, alignment: .leading)

                tripSummaryColumn(content)
            }

            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(String(localized: "Preparation"))
                        .font(Theme.FontToken.inter(11))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                    Spacer()
                    Text("\(content.prepCompleted) / \(total) \(String(localized: "complete"))")
                        .font(Theme.FontToken.inter(11))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                }

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Rectangle().fill(Theme.ColorToken.border).frame(height: 2)
                        Rectangle()
                            .fill(Theme.ColorToken.accent)
                            .frame(width: geo.size.width * ratio, height: 2)
                    }
                }
                .frame(height: 2)

                HStack(spacing: 12) {
                    Button(content.primaryTitle, action: content.onPrimary)
                        .font(Theme.FontToken.inter(11, weight: .medium))
                        .foregroundStyle(Theme.ColorToken.accent)
                        .textCase(.uppercase)
                    Button(content.secondaryTitle, action: content.onSecondary)
                        .font(Theme.FontToken.inter(11, weight: .medium))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                        .textCase(.uppercase)
                }
            }
            .padding(.top, 4)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.ColorToken.background)
        .cardBorderStyle(radius: Theme.CornerRadius.large)
    }

    private func tripSummaryColumn(_ content: HeroCardContent) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(content.citiesLine)
                .font(Theme.FontToken.inter(10, weight: .medium))
                .foregroundStyle(Theme.ColorToken.textMuted)
                .textCase(.uppercase)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)

            Text(content.title)
                .font(Theme.FontToken.playfair(17, weight: .semibold))
                .foregroundStyle(Theme.ColorToken.textPrimary)
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(3)

            if let dates = content.datesLine, !dates.isEmpty {
                Text(dates)
                    .font(Theme.FontToken.inter(12))
                    .foregroundStyle(Theme.ColorToken.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            if let budget = content.budgetLine {
                Text(budget)
                    .font(Theme.FontToken.inter(11))
                    .foregroundStyle(Theme.ColorToken.textMuted)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
