//
//  SplashView.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 2/7/24.
//

import SwiftUI

struct SplashView: View {
    
    @EnvironmentObject var rootManager: RootManager
    @StateObject var viewModel = SplashViewModel(authService: AuthService())
    
    var body: some View {
        VStack {
            Text("Splash")
        }
        .onAppear {
            viewModel.onAppear()
        }
        .onChange(of: viewModel.successCheck) { success in
            if success {
                goFirstScreen()
            }
        }
        .alert(isPresented: $viewModel.showJailbreakAlert) {
            Alert(
                title: Text("jailbreak_title".localized),
                message: Text("jailbreak_description".localized),
                dismissButton: .default(Text("button_ok".localized), action: { exit(0)})
            )
        }
        
    }
    
    func goFirstScreen() {
        if viewModel.userSessionActive {
            rootManager.changeRootTo(.home)
        } else {
            rootManager.changeRootTo(.login)
        }
    }
}

#Preview {
    SplashView()
        .environmentObject(RootManager())
}
