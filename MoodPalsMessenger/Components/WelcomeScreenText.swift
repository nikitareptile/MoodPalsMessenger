//
//  WelcomeScreenText.swift
//  MoodPals
//
//  Created by Никита Тихонюк on 12.04.2023.
//

import SwiftUI

struct WelcomeScreenText: View {
    @State var screenWidth: CGFloat = UIScreen.main.bounds.width
    @State var screenHeight: CGFloat = UIScreen.main.bounds.height
    
    let icon: String
    let title: String
    let subTitle: String
    
    var body: some View {
        HStack(spacing: 20) {
            Text(icon)
                .font(.system(size: 44))
                .padding(.leading, screenWidth * 0.08)
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                Text(subTitle)
                    .font(.subheadline)
            }
            Spacer()
        }
        .padding(.vertical, 8)
        .frame(maxWidth: screenWidth * 0.86)
    }
}
