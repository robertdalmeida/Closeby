
import Foundation
import struct SwiftUI.NavigationPath

/// USAGE: calling the `navigateDetail` with the dataType of the detail type will navigate to detail view.
final class PlaceDetailNavigationCoordinator: ObservableObject {
    @Published var navigationPath = NavigationPath()
    
    func navigate(place: Place) {
        navigationPath.append(place)
    }
}
