//
//  RegisterWithEmailViewModel.swift
//  MoodPalsMessenger
//
//  Created by Никита Тихонюк on 25.04.2023.
//

import Foundation
import Firebase

final class RegisterWithEmailViewModel: ObservableObject {
    
    @Published var username = ""
    @Published var userEmail = ""
    @Published var password = ""
    
    func isUsernameValidate() -> Bool {
        let allowedCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_."
        let filteredUsername = username.filter { allowedCharacters.contains($0) }
        
        if filteredUsername == username && username.count >= 4 && username.count <= 12 {
            return true
        } else {
            return false
        }
    }
    
    func isEmailValidate() -> Bool {
        let name = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?"
        let domain = "([A-Z0-9a-z]([A-Z0-9a-z-]{0,30}[A-Z0-9a-z])?\\.){1,5}"
        let emailRegEx = name + "@" + domain + "[A-Za-z]{2,8}"
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        
        return emailTest.evaluate(with: userEmail)
    }
    
    func isPasswordValidate() -> Bool {
        let allowedCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()_+=.,/\\~"
        let filteredPassword = password.filter { allowedCharacters.contains($0) }
        
        if filteredPassword == password && password.count >= 6 {
            return true
        } else {
            return false
        }
    }
    
    func registerUser() {
        guard isUsernameValidate(), isEmailValidate(), isPasswordValidate() else {
            print("Что-то не так с логином или почтой, или паролем")
            return
        }
        
        Task {
            do {
                let returnetUserData = try await AuthenticationManager.shared.createUser(username: username, userEmail: userEmail, password: password)
                print("Пользователь зарегистрирован")
                print(returnetUserData)
            } catch {
                print("Ошибка регистрации: \(error)")
            }
        }
    }
    
}
