import SwiftUI
import UIKit

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

    @State private var loadedImage: UIImage?

    init(avatarUrl: String?, displayName: String? = nil, size: CGFloat = 30, action: @escaping () -> Void) {
        self.avatarUrl = avatarUrl
        self.displayName = displayName
        self.size = size
        self.action = action
        // Seed from the shared memory cache so an already-loaded avatar shows
        // instantly (no flash of initials) and matches every other screen.
        if let avatarUrl, !avatarUrl.isEmpty, let mem = AvatarImageCache.cached(avatarUrl) {
            _loadedImage = State(initialValue: mem)
        }
    }

    var body: some View {
        Button(action: action) {
            avatarContent
                .frame(width: size, height: size)
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
        .task(id: avatarUrl) { await load() }
    }

    @ViewBuilder
    private var avatarContent: some View {
        if let loadedImage {
            Image(uiImage: loadedImage).resizable().scaledToFill()
        } else {
            initialsView
        }
    }

    private func load() async {
        guard let urlString = avatarUrl, !urlString.isEmpty else {
            loadedImage = nil
            return
        }
        if let mem = AvatarImageCache.cached(urlString) {
            loadedImage = mem
            return
        }
        loadedImage = await AvatarImageCache.image(for: urlString)
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
