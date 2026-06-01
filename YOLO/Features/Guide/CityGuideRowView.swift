import SwiftUI

struct CityGuideRowView: View {
    let guide: CityGuide

    var body: some View {
        HStack(spacing: 12) {
            Text(guide.icon ?? "✦")
                .font(.system(size: 17))
                .frame(width: 38, height: 38)
                .background(Theme.ColorToken.backgroundSubtle)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Theme.ColorToken.borderLight, lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 4))

            VStack(alignment: .leading, spacing: 2) {
                Text(guide.listTitle)
                    .font(Theme.FontToken.playfair(14, weight: .semibold))
                    .foregroundStyle(Theme.ColorToken.textPrimary)
                    .lineLimit(2)
                if let subtitle = guide.listSubtitle {
                    Text(subtitle)
                        .font(Theme.FontToken.inter(11))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                        .lineLimit(2)
                }
            }

            Spacer(minLength: 0)

            Text("›")
                .font(Theme.FontToken.inter(14))
                .foregroundStyle(Theme.ColorToken.textMuted.opacity(0.6))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 11)
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(Theme.ColorToken.borderLight, lineWidth: 1)
        )
    }
}
