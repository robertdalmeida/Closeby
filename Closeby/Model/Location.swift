import Foundation

struct Location: Codable {
    let formattedAddress: String
    enum CodingKeys: String, CodingKey {
        case formattedAddress = "formatted_address"
    }
}

#if DEBUG
extension Location {
    static let mock = Location.init(formattedAddress: "616 E Pine St, Seattle, WA 98122")
}

#endif
