import SwiftUI

struct SubAreaRowView: View {
    let area: SubArea
    let audioGuide: AudioGuide?
    let hasAccess: Bool

    var body: some View {
        HStack(spacing: 12) {
            if let path = area.coverImagePath {
                CoverImageView(path: path, height: 48, cornerRadius: 4)
                    .frame(width: 48, height: 48)
                    .clipped()
            } else {
                Rectangle()
                    .fill(Theme.ColorToken.backgroundSubtle)
                    .frame(width: 48, height: 48)
            }
            Text(area.nameEn)
                .font(Theme.FontToken.inter(14))
                .foregroundStyle(Theme.ColorToken.textPrimary)
            Spacer()
            if let guide = audioGuide {
                Text("\(max(guide.durationSeconds / 60, 1)) min")
                    .font(Theme.FontToken.inter(11))
                    .foregroundStyle(Theme.ColorToken.textMuted)
            }
            Text(hasAccess ? "🎧" : "🔒")
                .font(Theme.FontToken.inter(12))
        }
        .padding(.vertical, 10)
        .overlay(alignment: .bottom) {
            Rectangle().fill(Theme.ColorToken.borderLight).frame(height: 1)
        }
    }
}
