
import SwiftUI

struct PlacesList: View {
    let places: [Place]
    var body: some View {
        List(places) { place in
            PlaceRow(place: place)
                .listRowSeparator(.hidden)
        }
        .listStyle(InsetListStyle())

    }
}

struct PlacesList_Previews: PreviewProvider {
    static var previews: some View {
        PlacesList(places: [.init(name: "Robert", distance: 1245, id: "1234", location: .init(formattedAddress: "616 E Pine St, Seattle, WA 98122"))])
    }
}
