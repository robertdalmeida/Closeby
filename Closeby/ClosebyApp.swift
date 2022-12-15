import SwiftUI

@main
struct ClosebyApp: App {
    var body: some Scene {
        WindowGroup {
            SearchView(viewModel: .init(placeStore: PlaceStore(userLocationService: UserLocationService.shared)))
        }
    }
}
