//
//  MoodView.swift
//  MoodPals
//
//  Created by Никита Тихонюк on 09.04.2023.
//

import SwiftUI

struct MoodView: View {
    
    let defaults = UserDefaults.standard
    
    enum Mood {
        case none, happy, neutral, sad, angry, sleepy, thoughtful
        var id: Self { self }
    }
    
    @State private var selection: Int? = nil
    @State private var currentMood: Mood = .none
    @State private var isButtonEnabled = false
    
    var body: some View {
        
        VStack(spacing: 20) {
            Text("Настроение")
                .font(.largeTitle)
                .fontWeight(.bold)
            Text("От настроения зависит то, как мы общаемся с другими людьми")
                .font(.body)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 260)
                .foregroundColor(.gray)
                .padding(.bottom)
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    MoodChooseButton(selectedButtonIndex: selection, index: 1, title: "😃", subTitle: "Радостное") {
                        selection = 1
                        currentMood = .happy
                        isButtonEnabled = true
                    }
                    MoodChooseButton(selectedButtonIndex: selection, index: 2, title: "😐", subTitle: "Нейтральное") {
                        selection = 2
                        currentMood = .neutral
                        isButtonEnabled = true
                    }
                    MoodChooseButton(selectedButtonIndex: selection, index: 3, title: "🙁", subTitle: "Грустное") {
                        selection = 3
                        currentMood = .sad
                        isButtonEnabled = true
                    }
                }
                HStack(spacing: 12) {
                    MoodChooseButton(selectedButtonIndex: selection, index: 4, title: "😠", subTitle: "Злое") {
                        selection = 4
                        currentMood = .angry
                        isButtonEnabled = true
                    }
                    MoodChooseButton(selectedButtonIndex: selection, index: 5, title: "😪", subTitle: "Сонное") {
                        selection = 5
                        currentMood = .sleepy
                        isButtonEnabled = true
                    }
                    MoodChooseButton(selectedButtonIndex: selection, index: 6, title: "🤔", subTitle: "Задумчивое") {
                        selection = 6
                        currentMood = .thoughtful
                        isButtonEnabled = true
                    }
                }
            }
            .padding(.bottom, 38)
            
            Spacer()
            
            SecuredButton(title: "Продолжить", isEnabled: isButtonEnabled) {
                switch selection {
                case 0:
                    // Обработка нажатия на кнопку 1
                    break
                case 1:
                    // Обработка нажатия на кнопку 2
                    break
                case 2:
                    // Обработка нажатия на кнопку 3
                    break
                default:
                    break
                }
            }
            .disabled(selection == nil)
        }
        .padding(.horizontal, 28)
        .padding(.vertical)
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        MoodView()
    }
}
