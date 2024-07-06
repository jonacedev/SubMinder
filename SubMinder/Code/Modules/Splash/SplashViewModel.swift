//
//  SplashViewModel.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 3/7/24.
//

import SwiftUI
import Combine

final class SplashViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var showJailbreakAlert = false
    @Published var successCheck = false
    
    private let firebaseManager: FirebaseManager
    
    init(firebaseManager: FirebaseManager) {
        self.firebaseManager = firebaseManager
    }
    
    func onAppear() {
        if !BaseActions.isPreview() {
            firebaseManager.updateUserSession()
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
