import Foundation

@MainActor
final class PlaceStore: ObservableObject {
    var userLocation = UserLocationService.shared
    
    typealias StoredData = ServicedData<[Place], Error>
    
    enum State {
        case processing
        case dataLoaded
        case error
    }
    
    @Published var places: [Place] = []
    @Published var radius: Double = 1000
    @Published var state: State = .dataLoaded
    @Published var query: String = "Venues"

    func fetch() async {
        let request = PlaceSearchNetworkRequest()
        do {
            state = .processing
            let userLocation = try await userLocation.requestCurrentLocation()
            let places = try await request.fetchPlaces(query: query,
                                                       location: userLocation.coordinate,
                                                       radius: Int32(radius))
            AppLogger.logInfo("Places: \(places.count)")
            self.places = places
            state = .dataLoaded
        } catch {
            AppLogger.logInfo("Places:\(error)")
            state = .error
        }
    }
}
