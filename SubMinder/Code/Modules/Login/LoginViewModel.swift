//
//  LoginViewModel.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 3/7/24.
//

import SwiftUI

final class LoginViewModel: ObservableObject {
    
    private let authService: AuthService
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    @MainActor
    func login(email: String, password: String) async {
        do {
            try await authService.login(email: email, password: password)
        } catch {
            print("error: \(error.localizedDescription)")
        }
    }
}
