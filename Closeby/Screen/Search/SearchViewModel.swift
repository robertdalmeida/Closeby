import Foundation
import Combine

@MainActor
final class SearchViewModel: ObservableObject {
    enum State {
        case processing(Task<Void, Never>)
        case dataLoaded
        case error
    }

    var placeStore: PlaceStore
    
    @Published var places: [Place] = []
    @Published var radiusInMeters: Double = 1000
    @Published var state: State = .dataLoaded
    @Published var query: String = "Venues"

    var radiusInKms: Double {
        radiusInMeters/1000
    }
    
    private var cancellables = Set<AnyCancellable>()

    // MARK: - init
    
    init(placeStore: PlaceStore) {
        self.placeStore = placeStore
        
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
