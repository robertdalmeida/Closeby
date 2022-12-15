import SwiftUI

struct SearchView: View {
    @StateObject var viewModel: SearchViewModel
    
    var body: some View {
        let _ = Self._printChanges()

        NavigationStack {
            VStack {
                PlacesList(places: viewModel.places, state: viewModel.state)
                Slider(value: $viewModel.radiusInMeters, in: viewModel.rangeOfRadius)
                    .padding()
                Text("Radius of search is \(viewModel.radiusInKms, specifier: "%0.2f") kms")
            }
            .onAppear {
                viewModel.fetch()
            }
        }
        .searchable(text: $viewModel.query, prompt: "Search")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(viewModel: .init(placeStore: .init()))
    }
}

