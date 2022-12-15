import SwiftUI
import Combine

struct ContentView: View {
    @StateObject var viewModel: ContentViewModel
    
    var body: some View {
        let _ = Self._printChanges()

        NavigationStack {
            VStack {
                detailsView
                Slider(value: $viewModel.radius, in: 10...100000)
                Text("\(viewModel.radius, specifier: "%0.0f") kms")
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
        ContentView(viewModel: .init(placeStore: .init()))
    }
}

@MainActor
final class ContentViewModel: ObservableObject {
    enum State {
        case processing(Task<Void, Never>)
        case dataLoaded
        case error
    }

    var placeStore: PlaceStore
    
    @Published var places: [Place] = []
    @Published var radius: Double = 1000
    @Published var state: State = .dataLoaded
    @Published var query: String = "Venues"

    private var cancellables = Set<AnyCancellable>()

    init(placeStore: PlaceStore) {
        self.placeStore = placeStore
        
        $query
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { value in
                self.fetch()
            }.store(in: &cancellables)
        
        
        $radius
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { value in
                self.fetch()
            }.store(in: &cancellables)

    }
    
    func fetch() {
        switch state {
        case .error, .dataLoaded:
            state = .processing(makeFetchTask())
        case .processing(let task):
            task.cancel()
            state = .processing(makeFetchTask())
        }
    }
    
    func makeFetchTask() -> Task<Void, Never> {
        Task<Void, Never> {
            do {
                places = try await placeStore.fetch(radius: radius, query: query)
                guard !Task.isCancelled else { return }
                state = .dataLoaded
            } catch {
                guard !Task.isCancelled else { return }
                state = .error
            }
            state = .dataLoaded
        }
    }
}
