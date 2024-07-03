//
//  CustomText.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 3/7/24.
//

import SwiftUI

enum FontType: String {
    case regular = "Roboto-Regular"
    case medium = "Roboto-Medium"
    case bold = "Roboto-Bold"
}

enum TextSize: CGFloat {
    case small = 12
    case medium = 16
    case large = 20
    case extraLarge = 24
    case header = 35
}

struct CustomText: View {
    
    let text: String
    let fontType: FontType
    let size: TextSize
    
    init(text: String, fontType: FontType = .medium, size: TextSize = .medium) {
        self.text = text
        self.fontType = fontType
        self.size = size
    }
    
    var body: some View {
        Text(text)
            .font(.custom(fontType.rawValue, size: size.rawValue))
    }
}

#Preview {
    CustomText(text: "Example")
}
