import SwiftUI

/// Membership price display with optional CMS compare-at (strikethrough) reference price.
struct MembershipPriceLabel: View {
    enum Style {
        /// Stacked compare-above / price-below, trailing — paywall plan cards.
        case stacked
        /// Compare left, price right on one line — compact rows.
        case inline
    }

    let plan: MembershipPlan
    let comparePriceEnabled: Bool
    var style: Style = .stacked
    var priceFont: Font = Theme.FontToken.playfair(17, weight: .semibold)
    var compareFont: Font = Theme.FontToken.inter(11)

    private var showsCompare: Bool {
        comparePriceEnabled
            && plan.showComparePrice
            && !(plan.comparePriceLabel ?? "").isEmpty
            && plan.comparePriceLabel != plan.priceLabel
    }

    var body: some View {
        Group {
            switch style {
            case .stacked:
                stackedLayout
            case .inline:
                inlineLayout
            }
        }
        .fixedSize(horizontal: true, vertical: false)
    }

    // MARK: - Stacked (paywall)

    private var stackedLayout: some View {
        VStack(alignment: .trailing, spacing: 3) {
            if showsCompare, let compare = plan.comparePriceLabel {
                Text(compare)
                    .font(compareFont)
                    .foregroundStyle(Theme.ColorToken.textDisabled)
                    .strikethrough(true, color: Theme.ColorToken.textGhost)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
            }
            Text(plan.priceLabel)
                .font(priceFont)
                .foregroundStyle(Theme.ColorToken.textPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.9)
            if showsCompare {
                Text(String(localized: "Introductory price"))
                    .font(Theme.FontToken.inter(8, weight: .medium))
                    .tracking(0.4)
                    .foregroundStyle(Theme.ColorToken.accent)
                    .textCase(.uppercase)
            }
        }
        .multilineTextAlignment(.trailing)
    }

    // MARK: - Inline (compact)

    private var inlineLayout: some View {
        HStack(alignment: .firstTextBaseline, spacing: 5) {
            if showsCompare, let compare = plan.comparePriceLabel {
                Text(compare)
                    .font(compareFont)
                    .foregroundStyle(Theme.ColorToken.textDisabled)
                    .strikethrough(true, color: Theme.ColorToken.textGhost)
                    .lineLimit(1)
            }
            Text(plan.priceLabel)
                .font(priceFont)
                .foregroundStyle(Theme.ColorToken.textPrimary)
                .lineLimit(1)
        }
    }
}
