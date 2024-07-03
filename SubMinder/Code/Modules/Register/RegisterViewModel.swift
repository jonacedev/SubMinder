//
//  RegisterViewModel.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 3/7/24.
//

import Foundation

final class RegisterViewModel: ObservableObject {
    
    private let authService: AuthService
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    @MainActor
    func register(email: String, password: String, username: String) async {
        do {
            try await authService.registerUser(email: email, password: password, username: username)
        } catch {
            print("error: \(error.localizedDescription)")
        }
    }
}
