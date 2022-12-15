import Foundation

final class PlaceStore: ObservableObject {
    var userLocation = UserLocationService.shared
    
    func fetch(radius: Double, query: String) async throws -> [Place] {
        let request = PlaceSearchNetworkRequest()
        do {
            let userLocation = try await userLocation.requestCurrentLocation()
            let places = try await request.fetchPlaces(query: query,
                                                       location: userLocation.coordinate,
                                                       radius: Int32(radius))
            AppLogger.logInfo("Places: \(places.count)")
            return places
        } catch {
            AppLogger.logInfo("Places:\(error)")
            throw error
        }
    }
}
