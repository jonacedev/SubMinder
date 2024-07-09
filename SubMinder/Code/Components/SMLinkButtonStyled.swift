//
//  SMLinkButtonStyled.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 9/7/24.
//

import SwiftUI

struct SMLinkButtonStyled: View {
    
    let title: String
    let action: () -> Void
    let isUnderline: Bool = true
    
    var body: some View {
        HStack {
            Spacer()
            
            Button(action: {
                action()
            }, label: {
                SMText(text: title, fontType: .medium, size: .smallLarge)
                    .foregroundStyle(
                        LinearGradient(
                        colors: [Color.additionalBlue,
                                 Color.additionalPurple],
                        startPoint: .topLeading,
                        endPoint: .trailing)
                    )
                    .underline(isUnderline)
            })
            
            Spacer()
        }
    }
}

#Preview {
    SMLinkButtonStyled(title: "default", action: { })
}
