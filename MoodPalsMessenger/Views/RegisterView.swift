//
//  RegisterView.swift
//  MoodPals
//
//  Created by Никита Тихонюк on 13.04.2023.
//

import SwiftUI
import Firebase

//class FirebaseManager: NSObject {
//    let auth: Auth
//    let storage: Storage
//    let firestore: Firestore
//
//    static let shared = FirebaseManager()
//
//    override init() {
//        FirebaseApp.configure()
//
//        self.auth = Auth.auth()
//        self.storage = Storage.storage()
//        self.firestore = Firestore.firestore()
//
//        super.init()
//    }
//}

struct RegisterView: View {
    
    let defaults = UserDefaults.standard
    
    @Environment(\.colorScheme) var colorScheme
    
    @State var screenWidth: CGFloat = UIScreen.main.bounds.width
    @State var screenHeight: CGFloat = UIScreen.main.bounds.height
    @State var isButtonEnabled = false
    @State var isPasswordHidden = true
    @State var username = ""
    @State var userEmail = ""
    @State var password = ""
    @State var errorText = ""
    
    let db = Firestore.firestore()
    
    var textFieldColor: Color {
        colorScheme == .light ? .gray.opacity(0.2) : .white.opacity(0.2)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                
                Text("Регистрация")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 260)
                Text("Создай аккаунт, чтобы начать общение")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 260)
                    .foregroundColor(.gray)
                    .padding(.bottom)
                
//                Button {
//
//                } label: {
//                    ZStack {
//                        Circle()
//                            .fill(textFieldColor)
//                            .frame(width: screenWidth / 2.4)
//                        Image(systemName: "photo")
//                            .font(.system(size: 54))
//                            .foregroundColor(colorScheme == .light ? .black : .white)
//                    }
//                }
//                .padding(.bottom, 20)
                
                Group {
                    TextField("Имя пользователя", text: $username)
                        .textInputAutocapitalization(.never)
                        .onChange(of: username) { _ in
                            if username.count == 0 || username.count >= 4 {
                                errorText = ""
                            } else {
                                errorText = "Логин не может быть короче 4 символов"
                            }
                        }
                    TextField("Электронная почта", text: $userEmail)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .onChange(of: userEmail) { _ in
                            if isEmailOK(email: userEmail) {
                                errorText = ""
                            } else {
                                errorText = "Введите верный адрес электронной почты"
                            }
                            shouldWeEnableButton(username: username, userEmail: userEmail, password: password, text: errorText)
                        }
                    HStack {
                        if isPasswordHidden {
                            SecureField("Пароль", text: $password)
                                .textInputAutocapitalization(.never)
                                .onChange(of: password) { _ in
                                    isPasswordOK(password: password)
                                    shouldWeEnableButton(username: username, userEmail: userEmail, password: password, text: errorText)
                            }
                        } else {
                            TextField("Пароль", text: $password)
                                .textInputAutocapitalization(.never)
                                .onChange(of: password) { _ in
                                    isPasswordOK(password: password)
                                    shouldWeEnableButton(username: username, userEmail: userEmail, password: password, text: errorText)
                            }
                        }
                        Button {
                            isPasswordHidden.toggle()
                        } label: {
                            Image(systemName: isPasswordHidden ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(isPasswordHidden ? .gray : .green)
                                .font(.system(size: 20))
                        }
                    }
                }
                .padding(24)
                .background(textFieldColor)
                .cornerRadius(16)
                .padding(.bottom, -8)
                
                Text(errorText)
                    .foregroundColor(.red)
                    .frame(width: screenWidth - 20)
                
                Spacer()
                
                HStack {
                    Text("Уже есть аккаунт?")
                    NavigationLink {
                        LoginView()
                    } label: {
                        Text("Войти")
                    }

                }
                
                SecuredButton(title: "Зарегистрироваться", isEnabled: isButtonEnabled) {
                    defaults.set(true, forKey: "isUserRegistered")
                    createNewAccount(username: username, email: userEmail, password: password)
                }
            }
            .padding(.horizontal, 28)
            .padding(.vertical)
        }
        .navigationBarBackButtonHidden()
    }
    
    private func isEmailOK(email: String) -> Bool {
        let name = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?"
        let domain = "([A-Z0-9a-z]([A-Z0-9a-z-]{0,30}[A-Z0-9a-z])?\\.){1,5}"
        let emailRegEx = name + "@" + domain + "[A-Za-z]{2,8}"
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    private func isPasswordOK(password: String) {
        let allowedCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()_+=.,/\\~"
        let filtered = password.filter { allowedCharacters.contains($0) }
        
        if filtered != password {
            self.password = filtered
        }
        
        if password.count == 0 || password.count >= 6 {
            errorText = ""
        } else {
            errorText = "Пароль должен быть 6 символов минимум"
        }
    }
    
    private func shouldWeEnableButton(username: String, userEmail: String, password: String, text: String) {
        if username.count >= 4 && isEmailOK(email: userEmail) == true && password != "" && text == "" {
            isButtonEnabled = true
        } else {
            isButtonEnabled = false
        }
    }
    
    private func createNewAccount(username: String, email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let createError = error {
                print("Произошла ошибка: \(createError)")
                return
            }
        }
        guard let userUid = Auth.auth().currentUser?.uid else { return }
        let userData = ["uid": userUid, "username": username, "email": userEmail]
        db.collection("users").document(userEmail).setData(userData) { error in
            if let saveDataError = error {
                print("Ошибка сохранения данных: \(saveDataError)")
            }
        }
    }
    
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
