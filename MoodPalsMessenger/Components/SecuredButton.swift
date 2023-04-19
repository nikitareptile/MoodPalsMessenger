//
//  SecuredButton.swift
//  MoodPals
//
//  Created by Никита Тихонюк on 12.04.2023.
//

import SwiftUI

struct SecuredButton: View {
    let title: String
    var isEnabled: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(.white)
                .font(.title2)
                .padding(22)
                .frame(maxWidth: .infinity, maxHeight: 68)
                .background(isEnabled ? Color.blue : Color.gray)
                .cornerRadius(20)
        }
        .disabled(!isEnabled)
    }
}
