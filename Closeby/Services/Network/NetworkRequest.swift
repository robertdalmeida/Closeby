import Foundation
import struct CoreLocation.CLLocationCoordinate2D

enum RequestMethod: String {
    case get = "GET"
}

protocol NetworkRequestProtocol {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: RequestMethod { get }
    var header: [String: String]? { get }
    var body: [String: String]? { get }
    var queryParameters: [String: String]? { get }
}

extension NetworkRequestProtocol {
    var scheme: String {
        return "https"
    }

    var host: String {
        return "api.foursquare.com"
    }
}

// MARK: - NetworkRequest
enum NetworkRequest: NetworkRequestProtocol {
    case places(query: String,
                sort: String,
                open: Bool,
                location: CLLocationCoordinate2D,
                radius: Int32,
                limit: Int)
    
    case placeDetail(id: String)


    var path: String {
        switch self {
        case .places: return "/v3/places/search"
        case .placeDetail(let id):
            return "/v3/places/\(id)"
        }
    }
    
    var method: RequestMethod {
        switch self {
        case .places, .placeDetail: return .get
        }
    }
    
    var header: [String : String]? {
        switch self {
            // Note: the best place to keep an API secret is not to have one, and if we really wanted to recieve this - we should get this from a secure service. This isn't a good place to keep this key. Keeping it here only for the purpose of this demostration.
        case .places, .placeDetail: return ["accept": "application/json",
                                            "Authorization": "fsq3z0+K5lzOgx4AI0pgcGTgh9XclYawbnx6N8t8934+Hfw="]
        }
    }
    
    var body: [String : String]? {
        switch self {
        case .places: return nil
        case .placeDetail: return nil
        }
    }
    
    var queryParameters: [String : String]? {
        switch self {
        case .places(let query, let sort, let open, let location, let radius, let limit):
            return ["query": query,
                    "ll": "\(location.latitude),\(location.longitude)",
                    "radius": "\(radius)",
                    "open_now": open ? "true": "false",
                    "sort": sort,
                    "limit": "\(limit)", // Get the maximum results from a query for the purposes of this sample.
                    "fields": "name,distance,fsq_id,location,categories"] // Only get what you need
        case .placeDetail: return nil
        }
    }
}
