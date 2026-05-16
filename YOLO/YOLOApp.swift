//
//  YOLOApp.swift
//  YOLO
//
//  Created by vesperal on 2026/4/26.
//

import Auth
import Supabase
import SwiftUI

@main
struct YOLOApp: App {
    @State private var isAuthenticated = false

    var body: some Scene {
        WindowGroup {
            Group {
                if AppConfig.useMock {
                    ContentView()
                } else if isAuthenticated {
                    ContentView()
                } else {
                    NavigationStack {
                        LoginView()
                    }
                }
            }
            .task {
                guard AppConfig.isSupabaseConfigured, !AppConfig.useMock else { return }

                for await state in SupabaseManager.shared.auth.authStateChanges {
                    if [.initialSession, .signedIn, .signedOut].contains(state.event) {
                        isAuthenticated = state.session != nil
                    }
                }
            }
        }
    }
}
