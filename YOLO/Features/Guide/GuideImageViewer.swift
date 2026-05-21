import SwiftUI
import UIKit

struct GuideFullScreenImage: View {
    let path: String
    @Environment(\.dismiss) private var dismiss
    @State private var loadedImage: UIImage?

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.black.ignoresSafeArea()
            if let loadedImage {
                Image(uiImage: loadedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if MediaURLResolver.coverImageURL(from: path) != nil {
                ProgressView().tint(.white)
            }
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .foregroundStyle(.white.opacity(0.9))
                    .padding()
            }
        }
        .task(id: path) {
            loadedImage = await ImageCacheService.shared.image(coverPath: path)
        }
    }
}
