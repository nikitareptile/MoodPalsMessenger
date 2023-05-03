//
//  RootView.swift
//  MoodPalsMessenger
//
//  Created by Никита Тихонюк on 20.04.2023.
//

import SwiftUI

struct RootView: View {
    
    let defaults = UserDefaults.standard
    
    @State private var showWelcomeView = false
    @State private var showLogInView = false
    
    var body: some View {
        ZStack {
            NavigationStack {
                MessengerRootView()
            }
        }
        .onAppear {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showLogInView = authUser == nil
            
            showWelcomeView = !defaults.bool(forKey: "isNotFirstLaunch")
        }
        .fullScreenCover(isPresented: $showWelcomeView, content: {
            WelcomeView(showWelcomeView: $showWelcomeView)
        })
        .fullScreenCover(isPresented: $showLogInView, content: {
            LogInView()
        })
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
