//
//  RegisterViewModel.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 3/7/24.
//

import Foundation

final class RegisterViewModel: ObservableObject {
    
    private let firebaseManager: FirebaseManager
    
    init(firebaseManager: FirebaseManager) {
        self.firebaseManager = firebaseManager
    }
    
    @MainActor
    func register(email: String, password: String, username: String) async {
        do {
            try await firebaseManager.registerUser(email: email, password: password, username: username)
        } catch {
            print("error: \(error.localizedDescription)")
        }
    }
}
