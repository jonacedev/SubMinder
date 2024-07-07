//
//  View+Utils.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 7/7/24.
//

import SwiftUI

extension View {
    
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}
