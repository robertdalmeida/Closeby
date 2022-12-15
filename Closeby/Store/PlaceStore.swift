import Foundation

/// Purpose of this type is to get the places from the service. 
struct PlaceStore: PlaceStoreProtocol {
    let userLocationService: UserLocationServiceProtocol
    
    func fetch(radiusInMeters: Double, query: String) async throws -> [Place] {
        let request = PlaceSearchNetworkRequest()
        do {
            let userLocation = try await userLocationService.requestCurrentLocation()
            
            let places = try await request.fetchPlaces(query: query,
                                                       location: userLocation.coordinate,
                                                       radius: Int32(radiusInMeters))
            AppLogger.logInfo("Places: \(places.count)")
            return places
        } catch {
            AppLogger.logInfo("Places:\(error)")
            throw error
        }
    }
}
