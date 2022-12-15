import SwiftUI

struct NoResults: View {
    var body: some View {
        VStack {
            Text("No results returned")
                .font(.title)
                .padding()
            Image(systemName: "exclamationmark.circle")
                .renderingMode(.template)
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(Color(.systemYellow))
                .shadow(radius: 2)
            Text("You can either change the search parameter or expand the radius of search")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding()
        }
    }
}

struct NoResults_Previews: PreviewProvider {
    static var previews: some View {
        NoResults()
    }
}
