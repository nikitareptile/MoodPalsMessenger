//
//  AuthenticationManager.swift
//  MoodPalsMessenger
//
//  Created by Никита Тихонюк on 20.04.2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct AuthDataResultModel {
    
    let uid: String
    let username: String
    let email: String
    let photoUrl: String?
    
    init(user: User) {
        self.uid = user.uid
        self.username = user.displayName ?? ""
        self.email = user.email!
        self.photoUrl = user.photoURL?.absoluteString
    }
    
}

final class AuthenticationManager {
    
    static let shared = AuthenticationManager()
    private init() {  }
    
    let db = Firestore.firestore()
    
    func createUser(username: String, userEmail: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: userEmail, password: password)
        Auth.auth().currentUser?.createProfileChangeRequest().displayName = username
        
        let userUid = authDataResult.user.uid
        let userData = ["uid": userUid, "username": username, "email": userEmail]
        db.collection("users").document(userEmail).setData(userData) { error in
            if let saveDataError = error {
                print("Ошибка сохранения данных: \(saveDataError)")
            }
        }
        
        return AuthDataResultModel(user: authDataResult.user)
    }
}
