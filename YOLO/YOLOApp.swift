//
//  YOLOApp.swift
//  YOLO
//

import RevenueCat
import SwiftUI

@main
struct YOLOApp: App {
    @State private var appEnv = AppEnvironment()
    @UIApplicationDelegateAdaptor(YOLOAppDelegate.self) private var appDelegate

    init() {
        UserDefaultsKeys.migrateLegacyKeysIfNeeded()
        OfflineCacheLocations.bootstrap()
        _ = TelemetryService.shared

        if let key = AppConfig.revenueCatApiKey {
            #if DEBUG
            Purchases.logLevel = .debug
            #endif
            Purchases.configure(with: .builder(withAPIKey: key).build())
        }
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
