//
//  LoginViewModel.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 3/7/24.
//

import SwiftUI

final class LoginViewModel: ObservableObject {
    
    private let firebaseManager: FirebaseManager
    
    init(firebaseManager: FirebaseManager) {
        self.firebaseManager = firebaseManager
    }
    
    @MainActor
    func login(email: String, password: String) async {
        do {
            try await firebaseManager.login(email: email, password: password)
        } catch {
            print("error: \(error.localizedDescription)")
        }
    }
}
