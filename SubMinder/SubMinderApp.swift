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
    @StateObject private var baseManager = BaseManager()
    @StateObject private var firebaseManager = FirebaseManager()
    @State var splashLoaded = false
   
    var body: some Scene {
        WindowGroup {
            ZStack {
                RootView()
                    .environmentObject(baseManager)
                loader()
            }
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
