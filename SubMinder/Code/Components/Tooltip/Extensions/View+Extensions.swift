//
//  View+Extensions.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 10/7/24.
//

import SwiftUI

public extension View {
    
    func smToolTip<F: View>(isPresented: Binding<Bool>,
                     alignment: Alignment = .center,
                     constant: SMConstant = .init(),
                     @ViewBuilder foreground: @escaping () -> F) -> some View {
        self.modifier(SMTooltip(isPresented: isPresented,
                                          alignment: alignment,
                                          constant: constant,
                                          foreground: foreground))
    }
    
    func smToolTip<B: View, F: View>(isPresented: Binding<Bool>,
                     alignment: Alignment = .center,
                     constant: SMConstant = .init(),
                     @ViewBuilder background: @escaping () -> B,
                     @ViewBuilder foreground: @escaping () -> F) -> some View {
        self.modifier(SMTooltip(isPresented: isPresented,
                                          alignment: alignment,
                                          constant: constant,
                                          background: background,
                                          foreground: foreground))
    }
}
