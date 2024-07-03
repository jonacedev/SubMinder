//
//  SubMinderApp.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 2/7/24.
//

import SwiftUI
import FirebaseCore

@main
struct SubMinderApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var baseManager = BaseManager()
    @StateObject private var authService = AuthService()
    @State var splashLoaded = false
   
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(baseManager)
        }
    }
    
    @ViewBuilder
    private func RootView() -> some View {
        if !splashLoaded {
            SplashView(authService: authService, splashLoaded: $splashLoaded)
        } else {
            if authService.userSession != nil {
                HomeView(authService: authService)
            } else {
                LoginView(authService: authService)
            }
        }
    }
    
//    @ViewBuilder func alert() -> some View {
//        if let alert = rootManager.alert {
//            BaseAlert(model: alert)
//        }
//    }

    @ViewBuilder func loader() -> some View {
        if baseManager.isLoading() == true {
            BaseLoader()
        }
    }
}
