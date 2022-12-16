import Foundation

struct PlaceDetailNetworkRequest: HTTPClientProtocol {
    func fetchPlaceDetail(place: Place) async throws -> PlaceDetail {
        let result = await sendRequest(endpoint: NetworkRequest.placeDetail(id: place.id),
                                       responseModel: PlaceDetail.self)
        return try result.get()
    }
}
