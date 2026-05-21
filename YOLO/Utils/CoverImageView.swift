import SwiftUI

/// Loads CMS cover paths via `MediaURLResolver`, with disk cache for offline viewing.
struct CoverImageView: View {
    let path: String?
    var height: CGFloat = 120
    var cornerRadius: CGFloat = 4

    @State private var loadedImage: UIImage?

    var body: some View {
        Group {
            if let loadedImage {
                Image(uiImage: loadedImage)
                    .resizable()
                    .scaledToFill()
            } else if let path, MediaURLResolver.coverImageURL(from: path) != nil {
                ZStack {
                    placeholder
                    ProgressView()
                }
            } else {
                placeholder
            }
        }
        .frame(height: height)
        .frame(maxWidth: .infinity)
        .clipped()
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .task(id: path) {
            await loadImage()
        }
    }

    private func loadImage() async {
        guard let path else {
            loadedImage = nil
            return
        }
        if let cached = await ImageCacheService.shared.image(coverPath: path) {
            loadedImage = cached
        }
    }

    private var placeholder: some View {
        Rectangle()
            .fill(Theme.ColorToken.backgroundSubtle)
            .overlay {
                Image(systemName: "photo")
                    .foregroundStyle(Theme.ColorToken.textGhost)
            }
    }
}
