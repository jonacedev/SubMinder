//
//  RegisterViewModel.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 3/7/24.
//

import Foundation

final class RegisterViewModel: BaseViewModel {
    
    private let firebaseManager: FirebaseManager
    
    init(firebaseManager: FirebaseManager) {
        self.firebaseManager = firebaseManager
        super.init()
    }
    
    @MainActor
    func register(email: String, password: String, username: String) async {
        showLoading()
        do {
            try await firebaseManager.registerUser(email: email, password: password, username: username)
            hideLoading()
        } catch {
            manageError(alert: BaseAlert.Model(title: "Error",
                                             description: error.localizedDescription,
                                             buttonText1: "Aceptar",
                                             action1: { self.hideAlert() }))
        }
    }
}
