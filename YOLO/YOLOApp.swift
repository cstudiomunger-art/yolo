//
//  YOLOApp.swift
//  YOLO
//

import SwiftUI

@main
struct YOLOApp: App {
    @State private var appEnv = AppEnvironment()

    init() {
        OfflineCacheLocations.bootstrap()
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(appEnv)
        }
    }
}
