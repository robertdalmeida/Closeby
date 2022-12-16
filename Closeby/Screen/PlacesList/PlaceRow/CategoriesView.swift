import SwiftUI

struct CategoriesView: View {
    let categories: [PlaceCategory]
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false)  {
            HStack {
                ForEach(categories, id: \.self){ category in
                    Text(category.name)
                        .font(.caption2)
                        .padding(EdgeInsets(top: 2, leading: 3, bottom: 2, trailing: 3))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color(.systemGray), lineWidth: 1)
                        )

                }
                Spacer()
            }
        }
    }
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView(categories: [.mockNailSalon, .mockNailSalon, .mockNailSalon])
    }
}
