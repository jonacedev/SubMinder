//
//  SMEmptyView.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 9/7/24.
//

import SwiftUI

struct SMEmptyView: View {
    
    let title: String
    let height: CGFloat = 100
    
    var body: some View {
        VStack {
            SMText(text: title)
                .foregroundStyle(Color.secondary2)
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .foregroundStyle(Color.primary6)
                )
        }
        .frame(height: height)
    }
}

#Preview {
    SMEmptyView(title: "default")
}
