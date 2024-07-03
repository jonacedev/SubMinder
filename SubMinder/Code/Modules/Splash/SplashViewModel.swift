//
//  SplashViewModel.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 3/7/24.
//

import SwiftUI
import Combine
import FirebaseAuth

final class SplashViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var showJailbreakAlert = false
    @Published var successCheck = false
    
    private let authService: AuthService
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    func onAppear() {
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != "1" {
            authService.updateUserSession()
        }
        checkDevice()
    }
    
    private func checkDevice() {
        if isSimulator() || !DeviceInfo.isJailbreak() {
            successCheck = true
        } else {
            showJailbreakAlert = true
        }
    }
    
    // MARK: -  Check if is a simulator
    
    private func isSimulator() -> Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }
}
