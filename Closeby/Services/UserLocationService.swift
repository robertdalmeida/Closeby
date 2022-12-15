import Foundation
import CoreLocation

protocol UserLocationServiceProtocol {
    var lastKnownLocation: CLLocation? { get }
}

/// This type ges the user's location and keeps it.
@MainActor
final class UserLocationService: NSObject, UserLocationServiceProtocol {
    static let shared = UserLocationService()
    
    enum UserLocationServiceError: Error {
        case noPermission
        case unableToRetrieveLocation
    }
    
    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        return manager
    }()
        
    var lastKnownLocation: CLLocation?
    var requestLocationContinuation: CheckedContinuation<CLLocation, Error>?
    
    func requestCurrentLocation() async throws -> CLLocation {
        locationManager.requestWhenInUseAuthorization()
        return try await withCheckedThrowingContinuation { continuation in
            requestLocationContinuation = continuation
        }
    }
}

extension UserLocationService: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        AppLogger.logInfo("\(#function): status: \(manager.authorizationStatus.debugString)")
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .denied:
            requestLocationContinuation?.resume(throwing: UserLocationServiceError.noPermission)
        case .restricted:
            requestLocationContinuation?.resume(throwing: UserLocationServiceError.noPermission)
        @unknown default:
            requestLocationContinuation?.resume(throwing: UserLocationServiceError.noPermission)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        AppLogger.logInfo("\(#function)")
        requestLocationContinuation?.resume(throwing: error)

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        AppLogger.logInfo("\(#function) locations:\(locations)")
        guard let location = locations.first else {
            requestLocationContinuation?.resume(throwing: UserLocationServiceError.unableToRetrieveLocation)
            return
        }
        requestLocationContinuation?.resume(returning: location)
    }
}


extension CLAuthorizationStatus {
    var debugString: String {
        switch self {
        case .denied: return "denied"
        case .notDetermined: return "not determined"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        case .authorizedAlways: return "authorizedAlways"
        case .restricted: return "restricted"
        @unknown default:
            return "possibly a newly added auth status"
        }
    }
}
