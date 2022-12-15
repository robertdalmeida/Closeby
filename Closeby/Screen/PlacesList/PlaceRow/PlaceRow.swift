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
                        Text(place.location.formattedAddress)
                            .font(.footnote)
                        Spacer()
                    }
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
        PlaceRow(place: .init(name: "Realfine Coffee",
                              distance: 148,
                              id: "5b2c3681724750002c3e6899",
                              location: .init(formattedAddress: "616 E Pine St, Seattle, WA 98122")))
        .previewLayout(.fixed(width: 400, height: 60))

    }
}
