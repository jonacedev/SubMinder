//
//  SMScrollableTabView.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 4/7/24.
//

import SwiftUI

struct ScrollableInfo: Hashable {
    var text: String
    var description: String
}

struct SMScrollableTabView: View {
    
    var info: [ScrollableInfo]
    var height: CGFloat = 140
    
    var body: some View {
        TabView {
            ForEach(info, id: \.self) { item in
                VStack() {
                    SMText(text: item.text, fontType: .bold, size: .headerLarge)
                        .foregroundStyle(Color.secondary2)
                    SMText(text: item.description, fontType: .regular, size: .medium)
                        .foregroundStyle(Color.secondary2)
                }
                .padding(.bottom, 30)
            }
        }
        .frame(height: height)
        .tabViewStyle(.page)
        .indexViewStyle(.page)
        .onAppear {
            UIPageControl.appearance().currentPageIndicatorTintColor =
            UIColor(Color.additionalBlue)
            UIPageControl.appearance().pageIndicatorTintColor = UIColor(Color.primary3)
        }
    }
}

#Preview {
    SMScrollableTabView(info: [ScrollableInfo(text: "10", description: "example text"), ScrollableInfo(text: "15", description: "example text"), ScrollableInfo(text: "20", description: "example text")])
}
