//
//  SubMinderApp.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 2/7/24.
//

import SwiftUI

@main
struct SubMinderApp: App {
    
    @StateObject private var rootManager = RootManager()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(rootManager)
        }
    }
    
    
    @ViewBuilder
    private func RootView() -> some View {
        switch rootManager.currentRoot {
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
        if rootManager.loading == true {
            BaseLoader()
        }
    }
}
