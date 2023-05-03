//
//  LogInView.swift
//  MoodPals
//
//  Created by Никита Тихонюк on 13.04.2023.
//

import SwiftUI
import Firebase

struct LogInView: View {
    
    let defaults = UserDefaults.standard
    
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject private var viewModel = RegisterWithEmailViewModel()
    
    @State private var showRegisterView = false
    
    @State var isButtonEnabled = false
    @State var isAnimated = false
    @State var isPasswordHidden = true
    @State var symbolsCounter = 0
    @State var opacity = 1.0
    
    let db = Firestore.firestore()
    
    var textFieldColor: Color {
        colorScheme == .light ? Color(.init(white: 0, alpha: 0.06)) : Color(.init(white: 1, alpha: 0.1))
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                
                if isAnimated {
                    Text("Привет, \n\(viewModel.username)")
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
                    TextField("Электронная почта", text: $viewModel.userEmail)
                        .textInputAutocapitalization(.never)
                        .submitLabel(.next)
                        .keyboardType(.emailAddress)
                        .onSubmit {
                            getUsername(viewModel.userEmail) { username in
                                viewModel.username = username
                            }
                        }
                        .onChange(of: viewModel.userEmail, perform: { _ in
                            shouldWeEnableButton()
                        })
                    HStack {
                        if isPasswordHidden {
                            SecureField("Пароль", text: $viewModel.password)
                                .textInputAutocapitalization(.never)
                                .submitLabel(.go)
                                .onChange(of: viewModel.password) { _ in
                                    withAnimation(.easeIn(duration: 0.4)) {
                                        if viewModel.username == "" {
                                            isAnimated = false
                                        } else {
                                            isAnimated = true
                                        }
                                    }
                                    withAnimation(.linear(duration: 0.3).delay(0.2)) {
                                        if viewModel.username == "" {
                                            opacity = 1.0
                                        } else {
                                            opacity = 0.0
                                        }
                                    }
                                    shouldWeEnableButton()
                                }
                        } else {
                            TextField("Пароль", text: $viewModel.password)
                                .textInputAutocapitalization(.never)
                                .submitLabel(.go)
                                .onChange(of: viewModel.password) { _ in
                                    withAnimation(.easeIn(duration: 0.4)) {
                                        if viewModel.username == "" {
                                            isAnimated = false
                                        } else {
                                            isAnimated = true
                                        }
                                    }
                                    withAnimation(.linear(duration: 0.3).delay(0.2)) {
                                        if viewModel.username == "" {
                                            opacity = 1.0
                                        } else {
                                            opacity = 0.0
                                        }
                                    }
                                    shouldWeEnableButton()
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
                    Button {
                        showRegisterView = true
                    } label: {
                        Text("Создать")
                    }
                }
                
                SecuredButton(title: "Войти", isEnabled: isButtonEnabled) {
                    defaults.set(getUsername(viewModel.userEmail) { username in viewModel.username = username }, forKey: "username")
                    //loginUser(email: userEmail, password: password)
                }
            }
            .padding(.horizontal, 28)
            .padding(.vertical)
        }
        .navigationBarBackButtonHidden()
        .sheet(isPresented: $showRegisterView) {
            RegisterView(showRegisteriew: $showRegisterView)
        }
        
    }
    
    private func shouldWeEnableButton() {
        if viewModel.isEmailValidate() && viewModel.isPasswordValidate() {
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
                completion("")
            }
        }
    }
    
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
