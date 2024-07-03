//
//  SplashViewModel.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 3/7/24.
//

import SwiftUI

final class SplashViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var showJailbreakAlert = false
    @Published var successCheck = false
        
    // MARK: - Private Functions
    
    func checkDevice() {
        if isSimulator() || !DeviceInfo.isJailbreak() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                guard let self = self else { return }
                self.successCheck = true
            }
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
