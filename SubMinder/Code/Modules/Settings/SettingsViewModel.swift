//
//  SettingsViewModel.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 12/7/24.
//

import Foundation

class SettingsViewModel: BaseViewModel {
    
    private let firebaseManager: FirebaseManager
    
    init(firebaseManager: FirebaseManager) {
        self.firebaseManager = firebaseManager
        super.init()
    }
    
    @MainActor func signOut() {
        firebaseManager.signOut()
    }
}
