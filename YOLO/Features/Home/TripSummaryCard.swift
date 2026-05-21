import SwiftUI

struct TripSummaryCard: View {
    let title: String
    let subtitle: String
    let detail: String?
    let progress: Double?
    let progressLabel: String?
    let primaryAction: (title: String, action: () -> Void)?
    let secondaryAction: (title: String, action: () -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(Theme.FontToken.playfair(18, weight: .semibold))
                .foregroundStyle(Theme.ColorToken.textPrimary)
            Text(subtitle)
                .font(Theme.FontToken.inter(12))
                .foregroundStyle(Theme.ColorToken.textMuted)
            if let detail, !detail.isEmpty {
                Text(detail)
                    .font(Theme.FontToken.inter(13))
                    .foregroundStyle(Theme.ColorToken.textSecondary)
            }
            if let progress, let progressLabel {
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Rectangle().fill(Theme.ColorToken.border).frame(height: 2)
                        Rectangle()
                            .fill(Theme.ColorToken.accent)
                            .frame(width: geo.size.width * progress, height: 2)
                    }
                }
                .frame(height: 2)
                Text(progressLabel)
                    .font(Theme.FontToken.inter(11))
                    .foregroundStyle(Theme.ColorToken.textMuted)
            }
            if primaryAction != nil || secondaryAction != nil {
                HStack(spacing: 12) {
                    if let primaryAction {
                        Button(primaryAction.title, action: primaryAction.action)
                            .font(Theme.FontToken.inter(11, weight: .medium))
                            .foregroundStyle(Theme.ColorToken.accent)
                            .textCase(.uppercase)
                    }
                    if let secondaryAction {
                        Button(secondaryAction.title, action: secondaryAction.action)
                            .font(Theme.FontToken.inter(11, weight: .medium))
                            .foregroundStyle(Theme.ColorToken.textMuted)
                            .textCase(.uppercase)
                    }
                }
                .padding(.top, 4)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.ColorToken.background)
        .overlay(
            RoundedRectangle(cornerRadius: 4, style: .continuous)
                .stroke(Theme.ColorToken.border, lineWidth: 1)
        )
    }
}
