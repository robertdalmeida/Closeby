import Foundation

final class PlaceStore: ObservableObject {
    var userLocation = UserLocationService.shared
    
    init() {
        initialize()
    }
    
    func initialize() {
        Task {
            let request = PlaceSearchNetworkRequest()
            do {
                let userLocation = try await userLocation.requestCurrentLocation()
                let places = try await request.fetchPlaces(location: userLocation.coordinate, radius: 1000)
                AppLogger.logInfo("Places: \(places)")

            } catch {
                AppLogger.logInfo("Places")
            }
        }
    }
}
