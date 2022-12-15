import SwiftUI

@main
struct ClosebyApp: App {
    @StateObject var placeStore = PlaceStore()
    
    var body: some Scene {
        WindowGroup {
            SearchView(viewModel: .init(placeStore: placeStore))
        }
    }
}
