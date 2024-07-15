//
//  SMAppleCustomButton.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 15/7/24.
//

import SwiftUI

struct SMAppleCustomButton: View {
    let action: () -> Void
    var body: some View {
        Button(action: {
            action()
        }, label: {
            HStack {
                Image(systemName: "apple.logo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 7, height: 13, alignment: .center)
                Text("Iniciar sesion con Apple")
                    .font(.system(size: 16))
                    .fontWeight(.medium)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .foregroundStyle(Color.white)
            .background(Color.black)
            .clipShape(.rect(cornerRadius: 14))
        })
    }
}

#Preview {
    SMAppleCustomButton(action: { })
}
