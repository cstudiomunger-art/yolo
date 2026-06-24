import SwiftUI

/// Loads CMS cover paths via `MediaURLResolver`, with disk cache for offline viewing.
struct CoverImageView: View {
    let path: String?
    var height: CGFloat = 120
    var width: CGFloat?
    var cornerRadius: CGFloat = 4

    @State private var loadedImage: UIImage?

    var body: some View {
        // A fixed-size box drives the layout so any source aspect ratio (portrait or
        // landscape) renders at the same width/height; the image fills + crops into it.
        Color.clear
            .frame(width: width, height: height)
            .frame(maxWidth: width == nil ? .infinity : nil)
            .overlay {
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
