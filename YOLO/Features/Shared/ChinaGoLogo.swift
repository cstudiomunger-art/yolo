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

/// Loads a remote avatar through the shared `AvatarImageCache` (memory + disk)
/// so the same image shows instantly and identically across every screen, with
/// no flash of the `placeholder`. Reused by the user avatar, agent avatars, etc.
struct CachedAvatarImage<Placeholder: View>: View {
    let urlString: String?
    @ViewBuilder let placeholder: () -> Placeholder

    @State private var image: UIImage?

    init(urlString: String?, @ViewBuilder placeholder: @escaping () -> Placeholder) {
        self.urlString = urlString
        self.placeholder = placeholder
        // Seed synchronously from memory to avoid a one-frame flash of the placeholder.
        if let urlString, !urlString.isEmpty, let mem = AvatarImageCache.cached(urlString) {
            _image = State(initialValue: mem)
        }
    }

    var body: some View {
        Group {
            if let image {
                Image(uiImage: image).resizable().scaledToFill()
            } else {
                placeholder()
            }
        }
        .task(id: urlString) {
            guard let urlString, !urlString.isEmpty else { image = nil; return }
            if let mem = AvatarImageCache.cached(urlString) { image = mem; return }
            image = await AvatarImageCache.image(for: urlString)
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
            CachedAvatarImage(urlString: avatarUrl) { initialsView }
                .frame(width: size, height: size)
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
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
