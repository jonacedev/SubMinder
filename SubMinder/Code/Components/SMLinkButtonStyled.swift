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
    let isUnderline: Bool
    let withGradient: Bool
    
    init(title: String, action: @escaping () -> Void, isUnderline: Bool = true, withGradient: Bool = true) {
        self.title = title
        self.action = action
        self.isUnderline = isUnderline
        self.withGradient = withGradient
    }
    
    var body: some View {
        HStack {
            Spacer()
            
            Button(action: {
                action()
            }, label: {
                SMText(text: title, fontType: .medium, size: .smallLarge)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [withGradient ? Color.additionalBlue : Color.secondary4,
                                     withGradient ? Color.additionalPurple : Color.secondary4],
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
