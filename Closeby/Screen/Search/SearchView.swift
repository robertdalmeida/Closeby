import SwiftUI

struct SearchView: View {
    @StateObject var viewModel: SearchViewModel
    
    var body: some View {
        let _ = Self._printChanges()

        NavigationStack {
            VStack {
                detailsView
                Slider(value: $viewModel.radiusInMeters, in: viewModel.rangeOfRadius)
                Text("\(viewModel.radiusInKms, specifier: "%0.2f") kms")
            }
            .padding()
            .onAppear {
                viewModel.fetch()
            }
        }
        .searchable(text: $viewModel.query, prompt: "Search")
    }
        
    @ViewBuilder
    var detailsView: some View {
        switch viewModel.state {
        case .dataLoaded:
            List(viewModel.places, id: \.id) { item in
                VStack(alignment: .leading) {
                    Text(item.name)
                }
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(viewModel: .init(placeStore: .init()))
    }
}

