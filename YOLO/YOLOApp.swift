//
//  YOLOApp.swift
//  YOLO
//

import SwiftUI

@main
struct YOLOApp: App {
    @State private var appEnv = AppEnvironment()
    @UIApplicationDelegateAdaptor(YOLOAppDelegate.self) private var appDelegate

    init() {
        UserDefaultsKeys.migrateLegacyKeysIfNeeded()
        OfflineCacheLocations.bootstrap()
        _ = TelemetryService.shared
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(appEnv)
                .onOpenURL { url in
                    Task { await appEnv.handleIncomingURL(url) }
                }
        }
    }
}
