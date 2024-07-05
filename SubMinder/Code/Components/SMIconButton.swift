//
//  SMIconButoon.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 4/7/24.
//

import SwiftUI

struct SMIconButton: View {
    
    let image: String
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            Image(systemName: image)
                .frame(width: 45, height: 45)
                .foregroundStyle(Color.white)
                .background(
                    LinearGradient(
                    colors: [Color.additionalPurple, Color.additionalBlue],
                    startPoint: .topLeading,
                    endPoint: .trailing)
                )
                .clipShape(
                    Circle()
                )
                .shadow(radius: 5)
        })
    }
}

#Preview {
    SMIconButton(image: "bell", action: { })
}
