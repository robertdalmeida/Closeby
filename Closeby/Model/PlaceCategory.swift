import Foundation

struct PlaceCategory: Codable, Identifiable {
    let id: Int
    let name: String
    let icon: PlaceCategoryIcon
}

struct PlaceCategoryIcon: Codable {
    let prefix: String
    let suffix: String
}

#if DEBUG
extension PlaceCategory {
    static let mockNailSalon = PlaceCategory(id: 11071, name: "Nail Salon", icon: .mockNailSalon)
}

extension PlaceCategoryIcon {
    static let mockNailSalon = PlaceCategoryIcon(prefix: "https://ss3.4sqi.net/img/categories_v2/shops/nailsalon_", suffix: ".png")
}
#endif

extension PlaceCategory: Hashable, Equatable {
    static func == (lhs: PlaceCategory, rhs: PlaceCategory) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }
}
