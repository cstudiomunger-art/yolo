import SwiftUI

struct ChinaGoLogo: View {
    var body: some View {
        HStack(spacing: 0) {
            Text("China")
                .font(Theme.FontToken.playfair(20, weight: .bold))
                .foregroundStyle(Theme.ColorToken.textPrimary)
            Text("Go")
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
