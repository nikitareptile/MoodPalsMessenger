//
//  MessengerRootView.swift
//  MoodPalsMessenger
//
//  Created by Никита Тихонюк on 19.04.2023.
//

import SwiftUI

struct MessengerRootView: View {
    var body: some View {
        ScrollView {
            VStack {
                ForEach(0..<10, id: \.self) { num in
                    VStack {
                        HStack(spacing: 20) {
                            Image(systemName: "person.fill")
                                .font(.largeTitle)
                            VStack {
                                HStack {
                                    Text("Username")
                                    Spacer()
                                    Text("time")
                                }
                                HStack {
                                    Text("Message")
                                    Spacer()
                                    Text("1")
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    Divider()
                }
            }
        }
        .navigationTitle("Чаты")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button {
                
            } label: {
                Label("Search", systemImage: "magnifyingglass")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MessengerRootView()
        }
    }
}
