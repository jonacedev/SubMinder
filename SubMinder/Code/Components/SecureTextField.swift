//
//  SecureTextField.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 3/7/24.
//

import SwiftUI

struct SecureTextField: View {
    
    var placeholder: String
    @Binding var text: String
    
    @State var isSecure: Bool = true
    let height: CGFloat = 44
    let cornerRadius: CGFloat = 14
    let lineWidth: CGFloat = 1
    
    var body: some View {
        HStack {
            Group {
                if isSecure{
                    SecureField(placeholder, text: $text)
                    
                } else {
                    TextField(placeholder, text: $text)
                }
            }
            .padding(.horizontal)
            
           
            Button(action: {
                isSecure = !isSecure
            }, label: {
                Image(systemName: !isSecure ? "eye.slash" : "eye")
                    .foregroundColor(.gray)
                    .padding()
            })
            
        }
        .frame(maxWidth: .infinity, maxHeight: 44)
        .background(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(Color("primary3"), lineWidth: lineWidth)
        )
        .animation(.easeInOut(duration: 0.3), value: isSecure)
    }
}

#Preview {
    SecureTextField(placeholder: "", text: .constant("example"))
}
