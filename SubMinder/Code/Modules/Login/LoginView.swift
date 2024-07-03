//
//  LoginView.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 2/7/24.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var rootManager: RootManager
    @StateObject var viewModel = LoginViewModel()
    
    var body: some View {
        VStack {
            Text("Login")
        }
    }
}

#Preview {
    LoginView()
}
