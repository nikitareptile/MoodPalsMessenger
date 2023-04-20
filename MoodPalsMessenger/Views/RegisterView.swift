//
//  RegisterView.swift
//  MoodPals
//
//  Created by Никита Тихонюк on 13.04.2023.
//

import SwiftUI
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

struct RegisterView: View {
    
    let defaults = UserDefaults.standard
    
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject private var viewModel = RegisterWithEmailViewModel()
    
    @State var screenWidth: CGFloat = UIScreen.main.bounds.width
    @State var screenHeight: CGFloat = UIScreen.main.bounds.height
    @State var isButtonEnabled = false
    @State var isPasswordHidden = true
    @State var errorText = ""
    
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
                    TextField("Имя пользователя", text: $viewModel.username)
                        .textInputAutocapitalization(.never)
                        .onChange(of: viewModel.username) { _ in
                            if viewModel.isUsernameValidate() || viewModel.username.count == 0 {
                                errorText = ""
                            } else {
                                errorText = "Логин может содержать только латинские буквы и должен быть в пределах 4-12 символов"
                            }
                            shouldWeEnableButton()
                        }
                    TextField("Электронная почта", text: $viewModel.userEmail)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .onChange(of: viewModel.userEmail) { _ in
                            if viewModel.isEmailValidate() {
                                errorText = ""
                            } else {
                                errorText = "Введите верный адрес электронной почты"
                            }
                            shouldWeEnableButton()
                        }
                    HStack {
                        if isPasswordHidden {
                            SecureField("Пароль", text: $viewModel.password)
                                .textInputAutocapitalization(.never)
                                .onChange(of: viewModel.password) { _ in
                                    if viewModel.isPasswordValidate() {
                                        errorText = ""
                                    } else {
                                        errorText = "Пароль может содержать только латинские буквы, цифры и спецсимволы, а также должен быть не короче 6 символов"
                                    }
                                    shouldWeEnableButton()
                            }
                        } else {
                            TextField("Пароль", text: $viewModel.password)
                                .textInputAutocapitalization(.never)
                                .onChange(of: viewModel.password) { _ in
                                    if viewModel.isPasswordValidate() {
                                        errorText = ""
                                    } else {
                                        errorText = "Пароль может содержать только латинские буквы, цифры и спецсимволы, а также должен быть не короче 6 символов"
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
                    viewModel.registerUser()
                }
            }
            .padding(.horizontal, 28)
            .padding(.vertical)
        }
        .navigationBarBackButtonHidden()
    }
    
    private func shouldWeEnableButton() {
        if viewModel.isUsernameValidate() && viewModel.isEmailValidate() && viewModel.isPasswordValidate() {
            isButtonEnabled = true
        } else {
            isButtonEnabled = false
        }
    }
    
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
