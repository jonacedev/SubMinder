//
//  MainButton.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 3/7/24.
//

import SwiftUI

struct SMMainButton: View {
    
    let title: String
    let action: () -> Void
    let height: CGFloat = 44
    let cornerRadius: CGFloat = 14
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            
            SMText(text: title)
                .frame(maxWidth: .infinity, maxHeight: height)
                .foregroundStyle(.white)
                .background(
                    LinearGradient(
                        colors: [Color.additionalPurple, Color.additionalBlue],
                        startPoint: .topLeading,
                        endPoint: .trailing)
                )
                .clipShape(.rect(cornerRadius: cornerRadius))
                .shadow(radius: 5)
            })
    }
}

#Preview {
    SMMainButton(title: "example", action: { })
}
