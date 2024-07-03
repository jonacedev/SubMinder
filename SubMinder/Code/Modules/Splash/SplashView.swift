//
//  SplashView.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 2/7/24.
//

import SwiftUI

struct SplashView: View {
    
    @EnvironmentObject var rootManager: RootManager
    @StateObject var viewModel = SplashViewModel()
    
    var body: some View {
        VStack {
            Text("Splash")
        }
        .onAppear {
            viewModel.checkDevice()
        }
        .onChange(of: viewModel.successCheck) { success in
            if success { 
                goLogin()
            }
        }
        .alert(isPresented: $viewModel.showJailbreakAlert) {
            Alert(
                title: Text("jailbreak_title"),
                message: Text("jailbreak_description"),
                dismissButton: .default(Text("button_ok"), action: { exit(0)})
            )
        }
        
    }
    
    func goLogin() {
        rootManager.changeRootTo(.login)
    }
}

#Preview {
    SplashView()
        .environmentObject(RootManager())
}
