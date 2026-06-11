import SwiftUI

/// Tappable departure countdown column (left side of hero card).
struct HomeDepartureCountdownBlock: View {
    let daysUntilDeparture: Int
    /// 当前卡片对应行程的状态。nil（如空状态卡）时回退为出发倒计时。
    var status: TripStatus?
    var onTap: () -> Void = {}

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 4) {
                Text(bigText)
                    .font(Theme.FontToken.playfair(56, weight: .bold))
                    .foregroundStyle(Theme.ColorToken.textPrimary)
                    .lineSpacing(0)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)

                Text(caption)
                    .font(Theme.FontToken.inter(11))
                    .foregroundStyle(Theme.ColorToken.textSecondary)
                    .textCase(.uppercase)
                    .kerning(0.5)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(caption)
        .accessibilityValue(bigText)
        .accessibilityHint(String(localized: "Double tap to change departure date"))
    }

    private var bigText: String {
        switch status {
        case .ongoing(let day, _): return "\(day)"
        case .ended: return "✓"
        case .upcoming(let days): return "\(days)"
        case nil: return "\(daysUntilDeparture)"
        }
    }

    private var caption: String {
        switch status {
        case .ongoing: return String(localized: "Day · in progress")
        case .ended: return String(localized: "Trip ended")
        case .upcoming: return String(localized: "Days until start")
        case nil: return String(localized: "Days until departure")
        }
    }
}

/// Country + visa strip across the top of the hero card.
struct HomeHeroCountryVisaRow: View {
    let visa: VisaRule?

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            countryLine
                .frame(maxWidth: .infinity, alignment: .leading)

            if let visa {
                visaSummary(visa)
            }
        }
    }

    @ViewBuilder
    private var countryLine: some View {
        if let visa {
            Text("\(visa.flag)  \(visa.countryName)")
                .font(Theme.FontToken.inter(12, weight: .regular))
                .foregroundStyle(Theme.ColorToken.textMuted)
                .textCase(.uppercase)
                .kerning(0.6)
                .lineLimit(2)
        } else {
            Text(String(localized: "Set your nationality in Profile"))
                .font(Theme.FontToken.inter(12))
                .foregroundStyle(Theme.ColorToken.textMuted)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private func visaSummary(_ visa: VisaRule) -> some View {
        VStack(alignment: .trailing, spacing: 4) {
            Text(visaBadgeText(visa))
                .font(Theme.FontToken.inter(11, weight: .medium))
                .foregroundStyle(visaBadgeColor(visa))
                .textCase(.uppercase)
                .kerning(0.44)
                .padding(.horizontal, 8)
                .padding(.vertical, 2)
                .overlay(
                    RoundedRectangle(cornerRadius: 2, style: .continuous)
                        .stroke(visaBadgeColor(visa), lineWidth: 1)
                )

            if let stayText = stayPermittedText(visa) {
                Text(stayText)
                    .font(Theme.FontToken.inter(10))
                    .foregroundStyle(Theme.ColorToken.textMuted)
                    .multilineTextAlignment(.trailing)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private func visaBadgeText(_ visa: VisaRule) -> String {
        if visa.visaFree {
            return String(localized: "Visa-free")
        }
        if !visa.headline.isEmpty {
            return visa.headline
        }
        return String(localized: "Visa required")
    }

    private func visaBadgeColor(_ visa: VisaRule) -> Color {
        visa.visaFree ? Theme.ColorToken.success : Theme.ColorToken.textMuted
    }

    private func stayPermittedText(_ visa: VisaRule) -> String? {
        guard let days = visa.stayDays, days > 0 else { return nil }
        return String(format: String(localized: "%lld-day stay permitted"), days)
    }
}
