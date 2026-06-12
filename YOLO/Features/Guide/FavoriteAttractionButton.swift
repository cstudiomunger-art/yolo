import SwiftUI

struct FavoriteAttractionButton: View {
    @Environment(AppEnvironment.self) private var appEnv

    let attraction: Attraction

    private var isFavorite: Bool {
        appEnv.preferences.isFavorite(attractionId: attraction.id)
    }

    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                appEnv.preferences.toggleFavorite(attraction: attraction)
            }
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        } label: {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(isFavorite ? Theme.ColorToken.accent : Theme.ColorToken.textMuted)
                .frame(width: 32, height: 32)
                .contentShape(Rectangle())
        }
        .buttonStyle(.borderless)
        .accessibilityLabel(
            isFavorite
                ? String(localized: "Remove from favorites")
                : String(localized: "Add to favorites")
        )
    }
}
