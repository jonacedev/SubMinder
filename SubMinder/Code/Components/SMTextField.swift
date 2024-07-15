//
//  MainTextField.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 3/7/24.
//

import SwiftUI

struct SMTextField: View {
    
    var placeholder: String
    @Binding var text: String
    let height: CGFloat = 44
    let cornerRadius: CGFloat = 14
    let lineWidth: CGFloat = 1
    
    var body: some View {
        HStack {
            TextField(placeholder, text: $text)
                .font(.custom("Roboto-Regular", size: 15))
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: 44)
        .background(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(Color.primary3, lineWidth: lineWidth)
        )
    }
}

#Preview {
    SMTextField(placeholder: "", text: .constant("example"))
}
