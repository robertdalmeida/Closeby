//
//  ContentView.swift
//  Closeby
//
//  Created by robert on 14/12/2022.
//

import SwiftUI
 
struct ContentView: View {
    @EnvironmentObject var placeStore: PlaceStore
    
    var body: some View {
        let _ = Self._printChanges()

        NavigationView {
            VStack {
                List(placeStore.places, id: \.id) { item in
                    VStack(alignment: .leading) {
                        Text(item.name)
                    }
                }

                Slider(value: $placeStore.radius, in: 10...100000) {_ in
                    refreshResults()
                }
                Text("\(placeStore.radius, specifier: "%1.1f") kms")
            }

            .padding()
            .task {
                refreshResults()
            }
        }
        .searchable(text: $placeStore.query, prompt: "Search")
        .onChange(of: placeStore.query) { newValue in
            refreshResults()
        }
    }
    
    func refreshResults() {
        Task.detached {
            await placeStore.fetch()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
