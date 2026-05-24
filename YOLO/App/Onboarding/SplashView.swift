import SwiftUI

struct SplashView: View {
    var onFinished: () -> Void

    var body: some View {
        ZStack {
            Color(hex: 0x1A1614).ignoresSafeArea()
            VStack(spacing: 12) {
                ChinaGoLogo(lightOnDark: true)
                Text(String(localized: "YOLO HAPPY"))
                    .font(Theme.FontToken.playfair(28, weight: .semibold))
                    .foregroundStyle(.white)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                onFinished()
            }
        }
    }
}
