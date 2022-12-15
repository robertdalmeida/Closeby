import Foundation
import CoreLocation

protocol UserLocationServiceProtocol {
    func requestCurrentLocation() async throws -> CLLocation
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
        
    private var requestLocationContinuation: CheckedContinuation<CLLocation, Error>?
    private var lastLocation: CLLocation?
    
    func requestCurrentLocation() async throws -> CLLocation {
        if let lastLocation {
            return lastLocation
        }
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
        case .denied, .restricted:
            requestLocationContinuation?.resume(throwing: UserLocationServiceError.noPermission)
            requestLocationContinuation = nil
        @unknown default:
            requestLocationContinuation?.resume(throwing: UserLocationServiceError.noPermission)
            requestLocationContinuation = nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        AppLogger.logInfo("\(#function)")
        requestLocationContinuation?.resume(throwing: error)
        requestLocationContinuation = nil

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        AppLogger.logInfo("\(#function) locations:\(locations)")
        guard let location = locations.first else {
            requestLocationContinuation?.resume(throwing: UserLocationServiceError.unableToRetrieveLocation)
            requestLocationContinuation = nil
            return
        }
        lastLocation = location
        requestLocationContinuation?.resume(returning: location)
        requestLocationContinuation = nil
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
