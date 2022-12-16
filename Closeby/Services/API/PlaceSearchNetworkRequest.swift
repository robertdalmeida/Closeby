import Foundation
import struct CoreLocation.CLLocationCoordinate2D

struct PlaceSearchNetworkRequest: HTTPClientProtocol {
    func fetchPlaces(query: String, location: CLLocationCoordinate2D, radius: Int32) async throws -> [Place] {
        let result = await sendRequest(endpoint: NetworkRequest.places(query: query,
                                                                       sort: "DISTANCE",
                                                                       open: true,
                                                                       location: location,
                                                                       radius: radius,
                                                                       limit: 50),
                                       responseModel: PlaceResponse.self)
        return try result.get().results
    }
}
