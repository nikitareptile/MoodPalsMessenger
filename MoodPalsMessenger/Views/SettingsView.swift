//
//  SettingsView.swift
//  MoodPalsMessenger
//
//  Created by Никита Тихонюк on 20.04.2023.
//

import SwiftUI

final class SettingsViewModel: ObservableObject {
    
    @MainActor func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
}

struct SettingsView: View {
    
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showLogInView: Bool
    
    var body: some View {
        List {
            Button {
                Task {
                    do {
                        try viewModel.signOut()
                        showLogInView = true
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("Выйти из аккаунта")
                    .foregroundColor(.red)
            }

        }
        .navigationBarTitle("Настройки")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsView(showLogInView: .constant(false))
        }
    }
}
