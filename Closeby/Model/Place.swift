import Foundation

struct Place: Codable , Identifiable {
    let name: String
    let distance: Double
    let id: String
    let location: Location?
    let categories: [PlaceCategory]
    
    enum CodingKeys: String, CodingKey {
        case id = "fsq_id"
        case name
        case distance
        case location
        case categories
    }
}

extension Place: Hashable, Equatable {
    static func == (lhs: Place, rhs: Place) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }
}

struct PlaceResponse: Codable {
    let results: [Place]
}


extension Place {
    static let mockPlace = Place.init(name: "Realfine Coffee",
                                      distance: 148,
                                      id: "5b2c3681724750002c3e6899",
                                      location: .mock,
                                      categories: [.mockNailSalon])
}
