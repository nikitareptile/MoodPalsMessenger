//
//  MoodChooseButton.swift
//  MoodPals
//
//  Created by Никита Тихонюк on 12.04.2023.
//

import SwiftUI

struct MoodChooseButton: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    var selectedButtonIndex: Int? = nil
    
    let index: Int
    let title: String
    let subTitle: String
    let action: () -> Void
    
    var isSelected: Bool {
        selectedButtonIndex == index
    }
    
    var selectedBackgroundColor: Color {
        isSelected ? .blue : (colorScheme == .light ? .white : .black)
    }
    
    var selectedForegroundColor: Color {
        isSelected ? .white : (colorScheme == .light ? .black : .white)
    }
    
    var body: some View {
        Button(action: action) {
            VStack {
                Text(title)
                    .font(.system(size: 60))
                Text(subTitle)
                    .font(.footnote)
                    .padding(.bottom, 4)
            }
            .frame(width: 90, height: 90)
            .padding(6)
            .background(selectedBackgroundColor)
            .foregroundColor(selectedForegroundColor)
            .cornerRadius(20)
        }
    }
}
