//
//  ContentView.swift
//  State-SwiftUI
//
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            SeatsView()
                .navigationTitle("Seat Booking")
        }
    }
}

#Preview {
    ContentView()
}
