import Foundation

struct Place: Codable {
    let name: String
    let distance: Double
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case id = "fsq_id"
        case name
        case distance
    }
}


struct PlaceResponse: Codable {
    let results: [Place]
}
