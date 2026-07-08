import SwiftUI

enum CoverImageRounding {
    case all
    case topOnly
}

extension View {
    @ViewBuilder
    func coverClipShape(radius: CGFloat, rounding: CoverImageRounding = .all) -> some View {
        switch rounding {
        case .all:
            clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
        case .topOnly:
            clipShape(
                UnevenRoundedRectangle(
                    topLeadingRadius: radius,
                    bottomLeadingRadius: 0,
                    bottomTrailingRadius: 0,
                    topTrailingRadius: radius,
                    style: .continuous
                )
            )
        }
    }
}

/// Loads CMS cover paths via `MediaURLResolver`, with disk cache for offline viewing.
struct CoverImageView: View {
    let path: String?
    var height: CGFloat = 120
    var width: CGFloat?
    var cornerRadius: CGFloat = Theme.CornerRadius.medium
    var rounding: CoverImageRounding = .all

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
            .coverClipShape(radius: cornerRadius, rounding: rounding)
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
