import CoreLocation
import MapKit
import UIKit

struct MapDestination: Equatable {
    let name: String?
    let addressZh: String?
    let addressEn: String?
    let latitude: Double?
    let longitude: Double?

    var displayAddressLine: String? {
        let zh = addressZh?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let en = addressEn?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if !zh.isEmpty, !en.isEmpty, zh != en { return "\(en) · \(zh)" }
        if !en.isEmpty { return en }
        if !zh.isEmpty { return zh }
        return nil
    }

    var canOpenInMaps: Bool {
        if coordinate != nil { return true }
        let zh = addressZh?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let en = addressEn?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return !zh.isEmpty || !en.isEmpty
    }

    var title: String {
        trimmed(name) ?? trimmed(addressZh) ?? trimmed(addressEn) ?? String(localized: "Destination")
    }

    var primaryAddressQuery: String? {
        [addressZh, addressEn].compactMap { trimmed($0) }.first(where: { !$0.isEmpty })
    }

    var coordinate: CLLocationCoordinate2D? {
        guard let lat = latitude, let lon = longitude else { return nil }
        guard (-90 ... 90).contains(lat), (-180 ... 180).contains(lon) else { return nil }
        guard abs(lat) > 0.0001 || abs(lon) > 0.0001 else { return nil }
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }

    private func trimmed(_ value: String?) -> String? {
        guard let value else { return nil }
        let t = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return t.isEmpty ? nil : t
    }
}

enum MapNavigationProvider: String, CaseIterable, Identifiable {
    case appleMaps
    case amap
    case baiduMaps
    case googleMaps

    var id: String { rawValue }

    var localizedName: String {
        switch self {
        case .appleMaps: String(localized: "Apple Maps")
        case .amap: String(localized: "Amap")
        case .baiduMaps: String(localized: "Baidu Maps")
        case .googleMaps: String(localized: "Google Maps")
        }
    }

    var probeURL: URL? {
        switch self {
        case .appleMaps: URL(string: "maps://")
        case .amap: URL(string: "iosamap://")
        case .baiduMaps: URL(string: "baidumap://")
        case .googleMaps: URL(string: "comgooglemaps://")
        }
    }
}

enum MapNavigationOutcome: Equatable {
    case chooseFrom([MapNavigationProvider])
    case unavailable
}

/// Opens installed map apps for an address or coordinate.
@MainActor
enum MapNavigation {
    private static let sourceApplication = "YOLO"

    /// Map apps detected on this device (Apple Maps + any installed third-party apps).
    static func installedProviders() -> [MapNavigationProvider] {
        MapNavigationProvider.allCases.filter(isInstalled)
    }

    static func isInstalled(_ provider: MapNavigationProvider) -> Bool {
        guard let url = provider.probeURL else { return false }
        return UIApplication.shared.canOpenURL(url)
    }

    /// Always returns installed providers for the user to choose — never opens automatically.
    static func navigationChoice(for destination: MapDestination) -> MapNavigationOutcome {
        guard destination.canOpenInMaps else { return .unavailable }
        let providers = installedProviders()
        return providers.isEmpty ? .unavailable : .chooseFrom(providers)
    }

    static func open(destination: MapDestination, provider: MapNavigationProvider) {
        guard destination.canOpenInMaps else { return }
        switch provider {
        case .appleMaps:
            openAppleMaps(destination)
        case .amap:
            openThirdParty(url: amapURL(for: destination))
        case .baiduMaps:
            openThirdParty(url: baiduURL(for: destination))
        case .googleMaps:
            openThirdParty(url: googleURL(for: destination))
        }
    }

    /// Legacy entry point — opens Apple Maps when available.
    static func open(
        name: String?,
        addressZh: String?,
        addressEn: String?,
        latitude: Double?,
        longitude: Double?
    ) {
        let destination = MapDestination(
            name: name,
            addressZh: addressZh,
            addressEn: addressEn,
            latitude: latitude,
            longitude: longitude
        )
        guard isInstalled(.appleMaps) else { return }
        open(destination: destination, provider: .appleMaps)
    }

    // MARK: - Apple Maps

    private static func openAppleMaps(_ destination: MapDestination) {
        let title = destination.title
        if let coordinate = destination.coordinate {
            if #available(iOS 26.0, *) {
                let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                let item = MKMapItem(location: location, address: nil)
                item.name = title
                item.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
            } else {
                let placemark = MKPlacemark(coordinate: coordinate)
                let item = MKMapItem(placemark: placemark)
                item.name = title
                item.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
            }
            return
        }

        guard let query = destination.primaryAddressQuery else { return }
        var components = URLComponents(string: "http://maps.apple.com/")
        components?.queryItems = [
            URLQueryItem(name: "daddr", value: query),
            URLQueryItem(name: "dirflg", value: "d"),
        ]
        guard let url = components?.url else { return }
        UIApplication.shared.open(url)
    }

    // MARK: - Third-party URL builders

    private static func amapURL(for destination: MapDestination) -> URL? {
        if let coordinate = destination.coordinate {
            var components = URLComponents(string: "iosamap://path")
            components?.queryItems = [
                URLQueryItem(name: "sourceApplication", value: sourceApplication),
                URLQueryItem(name: "dlat", value: format(coordinate.latitude)),
                URLQueryItem(name: "dlon", value: format(coordinate.longitude)),
                URLQueryItem(name: "dname", value: destination.title),
                URLQueryItem(name: "dev", value: "0"),
                URLQueryItem(name: "t", value: "0"),
            ]
            return components?.url
        }
        guard let query = destination.primaryAddressQuery else { return nil }
        var components = URLComponents(string: "iosamap://poi")
        components?.queryItems = [
            URLQueryItem(name: "sourceApplication", value: sourceApplication),
            URLQueryItem(name: "name", value: query),
        ]
        return components?.url
    }

    private static func baiduURL(for destination: MapDestination) -> URL? {
        var components = URLComponents(string: "baidumap://map/direction")
        var destinationValue: String
        if let coordinate = destination.coordinate {
            destinationValue = "latlng:\(format(coordinate.latitude)),\(format(coordinate.longitude))|name:\(destination.title)"
        } else if let query = destination.primaryAddressQuery {
            destinationValue = "name:\(query)"
        } else {
            return nil
        }
        components?.queryItems = [
            URLQueryItem(name: "destination", value: destinationValue),
            URLQueryItem(name: "mode", value: "driving"),
            URLQueryItem(name: "src", value: sourceApplication),
        ]
        return components?.url
    }

    private static func googleURL(for destination: MapDestination) -> URL? {
        var components = URLComponents(string: "comgooglemaps://")
        if let coordinate = destination.coordinate {
            components?.queryItems = [
                URLQueryItem(name: "daddr", value: "\(format(coordinate.latitude)),\(format(coordinate.longitude))"),
                URLQueryItem(name: "directionsmode", value: "driving"),
            ]
        } else if let query = destination.primaryAddressQuery {
            components?.queryItems = [
                URLQueryItem(name: "q", value: query),
                URLQueryItem(name: "directionsmode", value: "driving"),
            ]
        } else {
            return nil
        }
        return components?.url
    }

    private static func openThirdParty(url: URL?) {
        guard let url else { return }
        UIApplication.shared.open(url)
    }

    private static func format(_ value: Double) -> String {
        String(format: "%.6f", value)
    }
}
