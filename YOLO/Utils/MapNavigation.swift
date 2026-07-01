import CoreLocation
import MapKit
import UIKit

/// Opens the system map app for an address or coordinate (Apple Maps on iOS).
enum MapNavigation {
    static func open(
        name: String?,
        addressZh: String?,
        addressEn: String?,
        latitude: Double?,
        longitude: Double?
    ) {
        let title = trimmed(name) ?? trimmed(addressZh) ?? trimmed(addressEn) ?? "Destination"

        if let coordinate = coordinate(latitude: latitude, longitude: longitude) {
            if #available(iOS 26.0, *) {
                let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                let item = MKMapItem(location: location, address: nil)
                item.name = title
                item.openInMaps(launchOptions: nil)
            } else {
                let placemark = MKPlacemark(coordinate: coordinate)
                let item = MKMapItem(placemark: placemark)
                item.name = title
                item.openInMaps(launchOptions: nil)
            }
            return
        }

        guard let query = [addressZh, addressEn].compactMap({ trimmed($0) }).first(where: { !$0.isEmpty }) else {
            return
        }

        var components = URLComponents(string: "http://maps.apple.com/")
        components?.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "address", value: query),
        ]
        guard let url = components?.url else { return }
        Task { @MainActor in
            await UIApplication.shared.open(url)
        }
    }

    private static func trimmed(_ value: String?) -> String? {
        guard let value else { return nil }
        let t = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return t.isEmpty ? nil : t
    }

    private static func coordinate(latitude: Double?, longitude: Double?) -> CLLocationCoordinate2D? {
        guard let lat = latitude, let lon = longitude else { return nil }
        guard (-90 ... 90).contains(lat), (-180 ... 180).contains(lon) else { return nil }
        guard abs(lat) > 0.0001 || abs(lon) > 0.0001 else { return nil }
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
}
