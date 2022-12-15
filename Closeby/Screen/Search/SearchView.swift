import SwiftUI

struct SearchView: View {
    @StateObject var viewModel: SearchViewModel
    @State var radiusBeingChanged = false
    
    var body: some View {
        let _ = Self._printChanges()
        ZStack {
            NavigationStack {
                VStack {
                    PlacesList(places: viewModel.places, state: viewModel.state)
                        .if(radiusBeingChanged) { view in
                            view.blur(radius: 2.5)
                        }
                    if radiusBeingChanged {
                        Text("\(viewModel.radiusInKms, specifier: "%0.2f") Kms")
                            .font(.title)
                            .bold()
                    }
                    Slider(value: $viewModel.radiusInMeters, in: viewModel.rangeOfRadius){ editing in
                        radiusBeingChanged = editing
                    }
                    .padding([.top, .leading, .trailing])
                    Text("Radius of search is \(viewModel.radiusInKms, specifier: "%0.2f") kms")
                        .bold()
                }
                .onAppear {
                    viewModel.fetch()
                }
            }
            .searchable(text: $viewModel.query, prompt: "Search")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(viewModel: .init(placeStore:
                                        PlaceStore.init(userLocationService: UserLocationService.shared)))
    }
}

