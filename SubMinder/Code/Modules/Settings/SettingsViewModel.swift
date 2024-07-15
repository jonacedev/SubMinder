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
    
    @MainActor
    func signOut() {
        firebaseManager.signOut()
    }
    
    @MainActor
    func deleteAccount() async {
        observeStateManager()
        do {
            try await firebaseManager.deleteUserAccount()
            
        } catch {
            manageError(alert: BaseAlert.Model(title: "Error",
                                               description: error.localizedDescription,
                                               buttonText1: "Aceptar",
                                               action1: { self.hideAlert() }))
        }
    }
    
    func observeStateManager() {
        firebaseManager.$isLoadingOperation.sink { isLoading in
            if isLoading {
                self.showLoading()
            } else {
                self.hideLoading()
            }
        }.store(in: &cancellables)
    }
    
    func isAppleSession() -> Bool {
        firebaseManager.isAppleSession()
    }
}
