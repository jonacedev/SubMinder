//
//  MainButton.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 3/7/24.
//

import SwiftUI

struct MainButton: View {
    
    let title: String
    let action: () -> Void
    let height: CGFloat = 44
    let cornerRadius: CGFloat = 14
    
    var body: some View {
        VStack {
            Button(action: {
                action()
            }, label: {
                
                CustomText(text: title)
                    .frame(maxWidth: .infinity, maxHeight: height)
                    .foregroundStyle(.white)
                    .background(
                        LinearGradient(
                            colors: [Color("secondaryPurple"), Color("secondaryBlue")],
                            startPoint: .topLeading,
                            endPoint: .trailing)
                    )
                    .clipShape(.rect(cornerRadius: cornerRadius))
                    .shadow(radius: 5)
            })
        }
    }
}

#Preview {
    MainButton(title: "example", action: { })
}
