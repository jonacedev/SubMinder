//
//  SMCircularProgressBar.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 5/7/24.
//

import SwiftUI

struct SMCircularProgressBar: View {
    
    var text: String
    var progress: Double
    var lineWidth: CGFloat = 4

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: lineWidth)
                .opacity(0.2)
                .foregroundColor(Color.secondary2.opacity(0.9))
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(
                    LinearGradient(
                        colors: [Color.additionalBlue, Color.additionalPurple],
                        startPoint: .topTrailing,
                        endPoint: .leading),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .foregroundColor(Color.clear)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear, value: progress)
            
            SMText(text: text, fontType: .medium, size: text.count > 2 ? .small : .smallLarge)
        }
    }
}

#Preview {
    SMCircularProgressBar(text: "3", progress: 0.5)
}
