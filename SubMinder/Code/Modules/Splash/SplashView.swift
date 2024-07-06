//
//  SplashView.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 2/7/24.
//

import SwiftUI

struct SplashView: View {
    
    @EnvironmentObject var baseManager: BaseManager
    @StateObject var viewModel: SplashViewModel
    @Binding var splashLoaded: Bool
    
    init(firebaseManager: FirebaseManager, splashLoaded: Binding<Bool>) {
        self._splashLoaded = splashLoaded
        self._viewModel = StateObject(wrappedValue: SplashViewModel(firebaseManager: firebaseManager))
    }
    
    var body: some View {
        VStack {
            Text("Splash")
        }
        .onAppear {
            viewModel.onAppear()
        }
        .onChange(of: viewModel.successCheck) { success in
            if success {
                splashLoaded = true
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
}

#Preview {
    SplashView(firebaseManager: FirebaseManager(), splashLoaded: .constant(false))
        .environmentObject(BaseManager())
}
