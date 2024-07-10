//
//  SMFrameModifier.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 10/7/24.
//

import SwiftUI

struct SMFrameModifier: ViewModifier {
    
    @Binding var rect: CGRect
    
    init(_ rect: Binding<CGRect>) {
        _rect = rect
    }
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy in
                    Color.clear.preference(key: FramePreferenceKey.self, value: proxy.frame(in: .global))
                }
            )
            .onPreferenceChange(FramePreferenceKey.self) { preference in
                self.rect = preference
            }
    }
}

extension View {
    func takeFrame(_ rect: Binding<CGRect>) -> some View {
        self.modifier(SMFrameModifier(rect))
    }
}

struct FramePreferenceKey: PreferenceKey {
    typealias V = CGRect
    static var defaultValue: V = .zero
    static func reduce(value: inout V, nextValue: () -> V) {
        value = nextValue()
    }
}
