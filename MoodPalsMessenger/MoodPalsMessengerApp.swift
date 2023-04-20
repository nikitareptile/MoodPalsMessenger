//
//  MoodPalsMessengerApp.swift
//  MoodPalsMessenger
//
//  Created by Никита Тихонюк on 19.04.2023.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseFirestore

@main
struct MoodPalsMessengerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    let defaults = UserDefaults.standard
    
    var body: some Scene {
        WindowGroup {
            if defaults.bool(forKey: "isNotFirstLaunch") == false {
                WelcomeView()
            } else if defaults.bool(forKey: "isUserRegistered") == false {
                RegisterView()
            } else {
                LoginView()
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
