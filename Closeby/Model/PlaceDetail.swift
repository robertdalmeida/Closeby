import Foundation

struct PlaceDetail: Decodable {
    let name: String
    let id: String
    let location: Location
    let categories: [PlaceCategory]

    enum CodingKeys: String, CodingKey {
        case id = "fsq_id"
        case name
        case location
        case categories
    }
}
