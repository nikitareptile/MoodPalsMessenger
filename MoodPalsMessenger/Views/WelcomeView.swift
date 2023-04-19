//
//  WelcomeView.swift
//  MoodPals
//
//  Created by Никита Тихонюк on 12.04.2023.
//

import SwiftUI

struct WelcomeView: View {
    
    let defaults = UserDefaults.standard
    
    @State var isNotFirstLaunch = false
    
    @State var screenWidth: CGFloat = UIScreen.main.bounds.width
    @State var screenHeight: CGFloat = UIScreen.main.bounds.height
    
    var body: some View {
        VStack {
            Text("Добро пожаловать в")
                .font(.title)
                .padding(.top, screenHeight * 0.05)
            
            Text("MoodPals")
                .font(.system(size: 58))
                .fontWeight(.black)
                .padding(.bottom, 20)
            
            WelcomeScreenText(icon: "🤔", title: "Выбирайте настроение", subTitle: "Будьте собой – сейчас.")
            
            WelcomeScreenText(icon: "📟", title: "Общайтесь с друзьями", subTitle: "Они сразу поймут ваше настроение.")
            
            WelcomeScreenText(icon: "🔥", title: "Откройте новый опыт", subTitle: "Испытайте другие эмоции от общения.")
            
            Spacer()
            
            BlueBigBottomButton(title: "Продолжить") {
                isNotFirstLaunch = true
                defaults.set(true, forKey: "isNotFirstLaunch")
            }
        }
        .padding(.horizontal, 28)
        .padding(.vertical)
        .fullScreenCover(isPresented: $isNotFirstLaunch) {
            LoginView()
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
