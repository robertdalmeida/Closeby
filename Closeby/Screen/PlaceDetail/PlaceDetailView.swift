import SwiftUI

struct PlaceDetailView: View {
    @StateObject var viewModel: PlaceDetailViewModel
    
    var body: some View {
        ZStack {
            switch viewModel.state {
            case .loaded:
                VStack {
                    CategoriesView(categories: viewModel.place.categories)
                    HStack {
                        viewModel.place.location.map{ Text($0.formattedAddress) }
                            .font(.footnote)
                        Spacer()
                    }
                    Spacer()
                }
                .padding()
                .navigationTitle(viewModel.title)

            case .inProgress:
                Spacer()
                ProgressView()
                    .progressViewStyle(.circular)
                Spacer()
            case .error:
                ErrorView()
            }
        }
        .task {
            await viewModel.fetchDetail()
        }
    }
}

@MainActor
final class PlaceDetailViewModel: ObservableObject {
    var placeDetail: PlaceDetail?
    let place: Place

    let request: PlaceDetailNetworkRequest = .init()
    
    enum State {
        case inProgress
        case loaded
        case error
    }
    
    @Published var state: State = .loaded
    
    init(place: Place) {
        self.place = place
    }
    
    func fetchDetail() async {
        do {
            self.state = .inProgress
            let placeDetail = try await request.fetchPlaceDetail(place: place)
            self.placeDetail = placeDetail
            self.state = .loaded
        }catch {
            print(error)
            self.state = .error
        }
    }
    
    var title: String {
        placeDetail?.name ?? place.name
    }

}

struct PlaceDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceDetailView(viewModel: .init(place: .mockPlace))
    }
}
