//
//  ClosebyApp.swift
//  Closeby
//
//  Created by robert on 14/12/2022.
//

import SwiftUI

@main
struct ClosebyApp: App {
    @StateObject var placeStore = PlaceStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(placeStore)
        }
    }
}
