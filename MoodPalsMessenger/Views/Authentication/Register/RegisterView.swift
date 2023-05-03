//
//  RegisterView.swift
//  MoodPals
//
//  Created by Никита Тихонюк on 13.04.2023.
//

import SwiftUI
import Firebase

struct RegisterView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject private var viewModel = RegisterWithEmailViewModel()
    
    @Binding var showRegisteriew: Bool
    
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
                    .padding(.top, 28)
                Text("Создай аккаунт, чтобы начать общение")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 260)
                    .foregroundColor(.gray)
                    .padding(.bottom)
                
                Group {
                    TextField("Имя пользователя", text: $viewModel.username)
                        .textInputAutocapitalization(.never)
                        .submitLabel(.next)
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
                        .submitLabel(.next)
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
                                .submitLabel(.join)
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
                                .submitLabel(.join)
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
                
                SecuredButton(title: "Зарегистрироваться", isEnabled: isButtonEnabled) {
                    UserDefaults.standard.set(true, forKey: "isUserRegistered")
                    viewModel.registerUser()
                }
            }
            .padding(.horizontal, 28)
            .padding(.vertical)
        }
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
        RegisterView(showRegisteriew: .constant(true))
    }
}
