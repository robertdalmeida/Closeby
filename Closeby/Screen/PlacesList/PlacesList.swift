
import SwiftUI

struct PlacesList: View {
    let places: [Place]
    let state: SearchViewModel.State
    
    var body: some View {
        switch state {
        case .dataLoaded:
            if places.count > 0 {
                List(places) { place in
                    PlaceRow(place: place)
                        .listRowSeparator(.hidden)
                }
                .listStyle(InsetListStyle())
            } else {
                Spacer()
                NoResults()
                Spacer()
            }

        case .error:
            Text("Error ⚠️")
        case .processing:
            Spacer()
            ProgressView()
                .progressViewStyle(.circular)
            Spacer()
        }
    }
}

struct PlacesList_Previews: PreviewProvider {
    static let places: [Place] = [.init(name: "Robert",
                                        distance: 1245,
                                        id: "1234",
                                        location: .init(formattedAddress: "616 E Pine St, Seattle, WA 98122")),
                         .init(name: "Robert",
                               distance: 1245,
                               id: "1234",
                               location: .init(formattedAddress: "616 E Pine St, Seattle, WA 98122"))]

    static var previews: some View {
        PlacesList(places: [],
                   state: .dataLoaded)
    }
}
