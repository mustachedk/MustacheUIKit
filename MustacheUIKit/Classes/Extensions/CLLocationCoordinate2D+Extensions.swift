import Foundation
import CoreLocation

extension CLLocationCoordinate2D: Equatable {

    public static func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return fabs(lhs.latitude - rhs.latitude) <= Double.ulpOfOne &&
                fabs(lhs.longitude - rhs.longitude) <= Double.ulpOfOne
    }

    public static var empty: CLLocationCoordinate2D { return CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0) }

    public var location: CLLocation { return CLLocation(latitude: self.latitude, longitude: self.longitude) }
}
