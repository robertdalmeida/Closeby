import Foundation
import struct CoreLocation.CLLocationCoordinate2D

struct PlaceSearchNetworkRequest: HTTPClientProtocol {
    func fetchPlaces(location: CLLocationCoordinate2D, radius: Int32) async throws -> [Place] {
        let result = await sendRequest(endpoint: NetworkRequest.places(query: "Venue",
                                                                       sort: "DISTANCE",
                                                                       open: true,
                                                                       location: location,
                                                                       radius: radius),
                                       responseModel: PlaceResponse.self)
        AppLogger.logInfo("\(result)")
        return try result.get().results
    }
}
