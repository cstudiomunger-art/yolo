//
//  ContentView.swift
//  YOLO
//
//  Created by vesperal on 2026/4/26.
//

import Supabase
import SwiftUI

struct ContentView: View {
    @State private var userEmail: String?

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)

            if AppConfig.useMock {
                Text("Mock mode (Supabase not connected)")
            } else if let userEmail {
                Text("Signed in: \(userEmail)")
            } else {
                Text("Hello, world!")
            }

            if !AppConfig.useMock {
                Button("Sign out", role: .destructive) {
                    signOut()
                }
            }
        }
        .padding()
        .task {
            guard !AppConfig.useMock else { return }
            userEmail = try? await SupabaseManager.shared.auth.session.user.email
        }
    }

    private func signOut() {
        Task {
            try? await SupabaseManager.shared.auth.signOut()
        }
    }
}

#Preview {
    ContentView()
}
