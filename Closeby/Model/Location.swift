import Foundation

struct Location: Codable {
    let formattedAddress: String
    enum CodingKeys: String, CodingKey {
        case formattedAddress = "formatted_address"
    }
}
