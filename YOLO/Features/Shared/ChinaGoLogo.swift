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
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text("A")
                .font(Theme.FontToken.inter(12, weight: .medium))
                .foregroundStyle(.white)
                .frame(width: 30, height: 30)
                .background(Theme.ColorToken.textPrimary)
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
    }
}
