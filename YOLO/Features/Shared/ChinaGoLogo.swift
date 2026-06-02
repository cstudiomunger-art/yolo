import SwiftUI

struct ChinaGoLogo: View {
    var lightOnDark: Bool = false

    var body: some View {
        HStack(spacing: 4) {
            Text("YOLO")
                .font(Theme.FontToken.playfair(20, weight: .bold))
                .foregroundStyle(lightOnDark ? .white : Theme.ColorToken.textPrimary)
            Text("HAPPY")
                .font(Theme.FontToken.playfair(20, weight: .bold))
                .foregroundStyle(Theme.ColorToken.accent)
        }
    }
}

struct ProfileAvatarButton: View {
    var avatarUrl: String?
    var displayName: String?
    var size: CGFloat = 30
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            avatarContent
                .frame(width: size, height: size)
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private var avatarContent: some View {
        if let urlString = avatarUrl,
           !urlString.isEmpty,
           let url = URL(string: urlString) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFill()
                default:
                    initialsView
                }
            }
        } else {
            initialsView
        }
    }

    private var initialsView: some View {
        Text(initials)
            .font(Theme.FontToken.inter(size * 0.4, weight: .medium))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Theme.ColorToken.textPrimary)
    }

    private var initials: String {
        displayName?.first.map(String.init)?.uppercased() ?? "A"
    }
}
