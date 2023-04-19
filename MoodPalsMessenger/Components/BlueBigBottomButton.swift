//
//  BlueBigBottomButton.swift
//  MoodPals
//
//  Created by Никита Тихонюк on 13.04.2023.
//

import SwiftUI

struct BlueBigBottomButton: View {
    
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(.white)
                .font(.title2)
                .padding(22)
                .frame(maxWidth: .infinity, maxHeight: 68)
                .background(Color.blue)
                .cornerRadius(20)
        }
    }
}
