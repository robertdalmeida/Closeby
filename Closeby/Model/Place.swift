import Foundation

struct Place: Codable, Identifiable {
    let name: String
    let distance: Double
    let id: String
    let location: Location
    
    enum CodingKeys: String, CodingKey {
        case id = "fsq_id"
        case name
        case distance
        case location
    }
}


struct PlaceResponse: Codable {
    let results: [Place]
}
