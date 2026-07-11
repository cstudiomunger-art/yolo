import SwiftUI

struct MembershipPriceLabel: View {
    let plan: MembershipPlan
    let comparePriceEnabled: Bool
    var priceFont: Font = Theme.FontToken.playfair(17, weight: .semibold)
    var compareFont: Font = Theme.FontToken.inter(12)

    private var showsCompare: Bool {
        comparePriceEnabled
            && plan.showComparePrice
            && !(plan.comparePriceLabel ?? "").isEmpty
            && plan.comparePriceLabel != plan.priceLabel
    }

    var body: some View {
        HStack(spacing: 6) {
            if showsCompare, let compare = plan.comparePriceLabel {
                Text(compare)
                    .font(compareFont)
                    .foregroundStyle(Theme.ColorToken.textMuted)
                    .strikethrough()
            }
            Text(plan.priceLabel)
                .font(priceFont)
                .foregroundStyle(Theme.ColorToken.textPrimary)
        }
    }
}
