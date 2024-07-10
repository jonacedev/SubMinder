//
//  SMSearchBar.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 10/7/24.
//

import SwiftUI

struct SMSearchBar: View {
    
    @Binding var text: String
    var placeholder: String
    var height: CGFloat = 44
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(LinearGradient(
                    colors: isFocused ? [Color.additionalPurple, Color.additionalBlue] : [Color.secondary3],
                    startPoint: .topLeading,
                    endPoint: .trailing))
                .foregroundColor(.secondary)
            
            TextField(placeholder, text: $text)
                .frame(height: height)
                .font(.custom(FontType.regular.rawValue, size: TextSize.searchBar.rawValue))
                .tint(Color.additionalPurple)
                .focused($isFocused)
               
            if text != "" {
                Image(systemName: "xmark.circle.fill")
                    .imageScale(.medium)
                    .foregroundStyle(LinearGradient(
                        colors: isFocused ? [Color.additionalPurple, Color.additionalBlue] : [Color.secondary3],
                        startPoint: .topLeading,
                        endPoint: .trailing))
                    .onTapGesture {
                        withAnimation {
                            self.text = ""
                          }
                    }
            }
        }
        .padding(.horizontal, 20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(LinearGradient(
                    colors: isFocused ? [Color.additionalPurple, Color.additionalBlue] : [Color.secondary4],
                    startPoint: .topLeading,
                    endPoint: .trailing), lineWidth: 0.5)
        )
    }
}

#Preview {
    SMSearchBar(text: .constant(""), placeholder: "Buscar")
}
