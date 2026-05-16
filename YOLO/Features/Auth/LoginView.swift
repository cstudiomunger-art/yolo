import Supabase
import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        Form {
            Section {
                TextField("邮箱", text: $email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()

                SecureField("密码", text: $password)
                    .textContentType(.password)
            }

            Section {
                Button("登录") {
                    signIn()
                }
                .disabled(email.isEmpty || password.isEmpty || isLoading)

                Button("注册") {
                    signUp()
                }
                .disabled(email.isEmpty || password.isEmpty || isLoading)
            }

            if isLoading {
                Section {
                    ProgressView()
                }
            }

            if let errorMessage {
                Section {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                }
            }
        }
        .navigationTitle("登录")
    }

    private func signIn() {
        runAuth {
            try await SupabaseManager.shared.auth.signIn(email: email, password: password)
        }
    }

    private func signUp() {
        runAuth {
            try await SupabaseManager.shared.auth.signUp(email: email, password: password)
        }
    }

    private func runAuth(_ action: @escaping () async throws -> Void) {
        Task {
            isLoading = true
            errorMessage = nil
            defer { isLoading = false }

            do {
                try await action()
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}

#Preview {
    NavigationStack {
        LoginView()
    }
}
