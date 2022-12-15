import Foundation
import Combine

protocol PlaceStoreProtocol {
    func fetch(radiusInMeters: Double, query: String) async throws -> [Place]
}

@MainActor
final class SearchViewModel: ObservableObject {
    
    /// The search view could be either in a processing state, a loaded state or error state.
    enum State {
        case processing(Task<Void, Never>)
        case dataLoaded
        case error
    }

    var placeStore: PlaceStoreProtocol
    
    @Published var places: [Place] = []
    @Published var radiusInMeters: Double = 1000
    @Published var state: State = .dataLoaded
    @Published var query: String = ""

    var radiusInKms: Double {
        radiusInMeters/1000
    }
    
    private var cancellables = Set<AnyCancellable>()

    // MARK: - init
    
    init(placeStore: PlaceStoreProtocol) {
        self.placeStore = placeStore
        
        // Here we configure debouncing for the 2 configurable parameters (the query & the radius)
        // We debounce to avoid sending multiple api requests.
        $query
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { value in
                self.fetch()
            }.store(in: &cancellables)
        
        
        $radiusInMeters
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { value in
                self.fetch()
            }.store(in: &cancellables)

    }
    
    // MARK: - fetch
    func fetch() {
        switch state {
        case .error, .dataLoaded:
            state = .processing(makeFetchTask())
        case .processing(let task):
            task.cancel()
            state = .processing(makeFetchTask())
        }
    }
    
    private func makeFetchTask() -> Task<Void, Never> {
        .init {
            do {
                places = try await placeStore.fetch(radiusInMeters: radiusInMeters, query: query)
                // There is a possibility that there might be an existing task running when a new one is created, in such a acase we can simply check for cancellation and bail out to be thread safe.
                guard !Task.isCancelled else { return }
                state = .dataLoaded
            } catch {
                guard !Task.isCancelled else { return }
                state = .error
            }
            state = .dataLoaded
        }
    }
    
    // MARK: - UI Display
    var rangeOfRadius: ClosedRange<Double> = 100...100000
}
