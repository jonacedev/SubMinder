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
    @StateObject private var firebaseManager = FirebaseManager()
    @State var splashLoaded = false
   
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
    
    @ViewBuilder
    private func RootView() -> some View {
        if !splashLoaded {
            SplashView(firebaseManager: firebaseManager, splashLoaded: $splashLoaded)
        } else {
            if firebaseManager.userSession != nil {
                HomeView(firebaseManager: firebaseManager)
            } else {
                LoginView(firebaseManager: firebaseManager)
            }
        }
    }
}
