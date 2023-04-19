//
//  LoginView.swift
//  MoodPals
//
//  Created by Никита Тихонюк on 13.04.2023.
//

import SwiftUI
import Firebase

struct LoginView: View {
    
    let defaults = UserDefaults.standard
    
    @Environment(\.colorScheme) var colorScheme
    
    @State var isButtonEnabled = false
    @State var isAnimated = false
    @State var isPasswordHidden = true
    @State var symbolsCounter = 0
    @State var opacity = 1.0
    @State var username = ""
    @State var userEmail = ""
    @State var password = ""
    
    let db = Firestore.firestore()
    
    var textFieldColor: Color {
        colorScheme == .light ? Color(.init(white: 0, alpha: 0.06)) : Color(.init(white: 1, alpha: 0.1))
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                
                if isAnimated {
                    Text("Привет, \n\(username)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 260)
                        .lineLimit(2)
                } else {
                    Text("Вход")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .opacity(opacity)
                }
                Text("Войди в свой аккаунт, чтобы продолжить общение")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 260)
                    .foregroundColor(.gray)
                    .padding(.bottom)
                Group {
                    TextField("Электронная почта", text: $userEmail)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .onChange(of: userEmail, perform: { _ in
                            buttonActive()
                        })
                    HStack {
                        if isPasswordHidden {
                            SecureField("Пароль", text: $password)
                                .textInputAutocapitalization(.never)
                                .onTapGesture(perform: {
                                    getUsername(userEmail) { username in
                                        self.username = username
                                    }
                                })
                                .onChange(of: password) { _ in
                                    withAnimation(.easeIn(duration: 0.4)) {
                                        if username == "" {
                                            isAnimated = false
                                        } else {
                                            isAnimated = true
                                        }
                                    }
                                    withAnimation(.linear(duration: 0.3).delay(0.2)) {
                                        if username == "" {
                                            opacity = 1.0
                                        } else {
                                            opacity = 0.0
                                        }
                                    }
                                    buttonActive()
                                }
                        } else {
                            TextField("Пароль", text: $password)
                                .textInputAutocapitalization(.never)
                                .onChange(of: password) { _ in
                                    withAnimation(.easeIn(duration: 0.4)) {
                                        if username == "" {
                                            isAnimated = false
                                        } else {
                                            isAnimated = true
                                        }
                                    }
                                    withAnimation(.linear(duration: 0.3).delay(0.2)) {
                                        if username == "" {
                                            opacity = 1.0
                                        } else {
                                            opacity = 0.0
                                        }
                                    }
                                    buttonActive()
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
                
                Button {
                    
                } label: {
                    Text("Восстановить пароль")
                }
                .padding(.top, 4)
                
                Spacer()
                
                HStack {
                    Text("Нет аккаунта?")
                    NavigationLink {
                        RegisterView()
                    } label: {
                        Text("Создать")
                    }
                }
                
                SecuredButton(title: "Войти", isEnabled: isButtonEnabled) {
                    defaults.set(getUsername(userEmail) { username in self.username = username }, forKey: "username")
                    loginUser(email: userEmail, password: password)
                }
            }
            .padding(.horizontal, 28)
            .padding(.vertical)
        }
        .navigationBarBackButtonHidden()
    }
    
    private func loginUser(email: String, password: String) {
        
    }
    
    private func isEmailOK(email: String) -> Bool {
        let name = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?"
        let domain = "([A-Z0-9a-z]([A-Z0-9a-z-]{0,30}[A-Z0-9a-z])?\\.){1,5}"
        let emailRegEx = name + "@" + domain + "[A-Za-z]{2,8}"
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    private func isPasswordOK(password: String) -> Bool {
        if password.count >= 6 {
            return true
        }
        return false
    }
    
    private func buttonActive() {
        if isEmailOK(email: userEmail) && isPasswordOK(password: password) {
            isButtonEnabled = true
        } else {
            isButtonEnabled = false
        }
    }
    
    func getUsername(_ email: String, _ completion: @escaping (String) -> Void) {
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(email)
        docRef.getDocument { document, error in
            if let document = document, document.exists {
                let dbUsername = document.data()?["username"] as! String
                print("Get login: \(dbUsername)")
                completion(dbUsername)
            } else {
                completion("Unknown")
            }
        }
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
