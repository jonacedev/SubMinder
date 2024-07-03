//
//  BaseLoader.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 2/7/24.
//

import SwiftUI

struct BaseLoader: View {
    @State var backOpacity: CGFloat = 0.6

    var body: some View {
        ZStack {
            Color.black.opacity(backOpacity)
                .edgesIgnoringSafeArea(.all)
                .blur(radius: 0)
            
            VStack {
                progressBar()
            }

        }
        .onAppear {
            withAnimation {
                backOpacity = 0.3
            }
        }
    }

    @ViewBuilder private func progressBar() -> some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
            .scaleEffect(2)
    }
}

#Preview {
    BaseLoader()
}

