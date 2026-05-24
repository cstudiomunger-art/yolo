import Foundation
import MetricKit
import os.log

/// Lightweight analytics + crash diagnostics. Events are logged locally; MetricKit delivers crash payloads.
@MainActor
final class TelemetryService: NSObject, MXMetricManagerSubscriber {
    static let shared = TelemetryService()

    private let log = Logger(subsystem: Bundle.main.bundleIdentifier ?? "YOLO", category: "Telemetry")

    private override init() {
        super.init()
        MXMetricManager.shared.add(self)
    }

    func logEvent(_ name: String, parameters: [String: String] = [:]) {
        if parameters.isEmpty {
            log.info("event \(name, privacy: .public)")
        } else {
            log.info("event \(name, privacy: .public) params \(parameters.description, privacy: .private)")
        }
    }

    func recordError(_ error: Error, context: String) {
        log.error("error \(context, privacy: .public): \(error.localizedDescription, privacy: .public)")
    }

    nonisolated func didReceive(_ payloads: [MXDiagnosticPayload]) {
        Task { @MainActor in
            for payload in payloads {
                let data = payload.jsonRepresentation()
                self.log.info("metric diagnostic \(String(data: data, encoding: .utf8) ?? "payload", privacy: .private)")
            }
        }
    }
}
