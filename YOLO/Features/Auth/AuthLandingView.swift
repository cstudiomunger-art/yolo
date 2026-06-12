import SwiftUI

/// Full-screen login gate shown before nationality onboarding or main tabs.
struct AuthLandingView: View {
    @Environment(AppEnvironment.self) private var appEnv

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                VStack(spacing: 8) {
                    ChinaGoLogo()
                    Text("Sign in to plan your China trip")
                        .font(Theme.FontToken.inter(13))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 80)

                Spacer(minLength: 24)

                LoginView()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Theme.ColorToken.background)
        }
    }
}

#Preview {
    AuthLandingView()
        .environment(AppEnvironment())
}
