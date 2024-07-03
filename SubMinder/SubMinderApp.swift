//
//  SubMinderApp.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 2/7/24.
//

import SwiftUI

@main
struct SubMinderApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var rootManager = RootManager()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(rootManager)
        }
    }
    
    
    @ViewBuilder
    private func RootView() -> some View {
        switch rootManager.getCurrentRoot() {
        case .splash:
            SplashView()
        case .login:
            LoginView()
        case .home:
            HomeView()
        }
    }
    
//    @ViewBuilder func alert() -> some View {
//        if let alert = rootManager.alert {
//            BaseAlert(model: alert)
//        }
//    }

    @ViewBuilder func loader() -> some View {
        if rootManager.isLoading() == true {
            BaseLoader()
        }
    }
}
