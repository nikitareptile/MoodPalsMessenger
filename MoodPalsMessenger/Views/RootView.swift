//
//  RootView.swift
//  MoodPalsMessenger
//
//  Created by Никита Тихонюк on 20.04.2023.
//

import SwiftUI

struct RootView: View {
    
    @State private var showWelcomeView = false
    @State private var showLogInView = false
    @State private var showMessengerView = false
    
    var body: some View {
        NavigationView {
            ZStack {
                if UserDefaults.standard.bool(forKey: "isUserLoggedIn") {
                    MessengerRootView()
                } else {
                    LogInView()
                }
            }
            .onAppear {
                let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
                self.showLogInView = authUser == nil
                self.showMessengerView = authUser == nil
                
                showWelcomeView = !UserDefaults.standard.bool(forKey: "isNotFirstLaunch")
            }
            .fullScreenCover(isPresented: $showWelcomeView, content: {
                WelcomeView(showWelcomeView: $showWelcomeView)
            })
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
