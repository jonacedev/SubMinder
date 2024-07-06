//
//  SMAddIconButton.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 5/7/24.
//

import SwiftUI

struct SMAddIconButton: View {
    
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                action()
            }
        }, label: {
            Image(systemName: "plus")
                .frame(width: 55, height: 55)
                .font(.title3)
                .foregroundStyle(.white)
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
    SMAddIconButton(action: { })
}
