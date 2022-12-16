import SwiftUI

struct PlaceDetailView: View {
    let place: Place
    let request: PlaceDetailNetworkRequest = .init()
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .task {
                await fetchDetail()
            }
    }
    
    func fetchDetail() async {
        do {
            let placeDetail = try await request.fetchPlaceDetail(place: place)
            print(placeDetail)
        }catch {
            print(error)
        }
    }
    
}

struct PlaceDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceDetailView(place: .init(name: "", distance: 123, id: "", location: .init(formattedAddress: ""),
                                     categories: [.mockNailSalon]))
    }
}
