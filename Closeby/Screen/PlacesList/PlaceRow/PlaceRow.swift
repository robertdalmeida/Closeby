import SwiftUI

struct PlaceRow: View {
    let place: Place
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color(.systemBackground))
                .shadow(color: Color(.systemGray), radius: 2)

            HStack {
                VStack {
                    HStack {
                        Text(place.name)
                            .font(.title3.bold())
                        Spacer()
                    }
                    HStack {
                        place.location.map{ Text($0.formattedAddress) }
                            .font(.footnote)
                        Spacer()
                    }
                    CategoriesView(categories: place.categories)
                }
                Text("\(place.distance/1000 , specifier: "%0.2f") kms")
                    .font(.subheadline)
            }
            .foregroundColor(.primary)
            .padding()
        }
    }
}

struct PlaceRow_Previews: PreviewProvider {
    static var previews: some View {
        PlaceRow(place: .mockPlace)
        .previewLayout(.fixed(width: 400, height: 60))

    }
}
