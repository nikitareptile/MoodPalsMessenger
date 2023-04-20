//
//  MessengerRootView.swift
//  MoodPalsMessenger
//
//  Created by Никита Тихонюк on 19.04.2023.
//

import SwiftUI

struct MessengerRootView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MessengerRootView()
        }
    }
}
