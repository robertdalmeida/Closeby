
import SwiftUI

struct PlacesList: View {
    let places: [Place]
    let state: SearchViewModel.State
    
    var body: some View {
        switch state {
        case .dataLoaded:
            List(places) { place in
                PlaceRow(place: place)
                    .listRowSeparator(.hidden)
            }
            .listStyle(InsetListStyle())

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
    static var previews: some View {
        PlacesList(places: [.init(name: "Robert", distance: 1245, id: "1234", location: .init(formattedAddress: "616 E Pine St, Seattle, WA 98122"))], state: .dataLoaded)
    }
}
