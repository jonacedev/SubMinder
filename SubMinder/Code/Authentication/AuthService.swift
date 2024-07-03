//
//  AuthService.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 3/7/24.
//

import Firebase
import FirebaseAuth
import Combine

class AuthService {
    
    @Published var userSession: FirebaseAuth.User?
    
    func updateUserSession() {
        self.userSession = Auth.auth().currentUser
    }
    
    func login(email: String, password: String) async throws {

    }
    
    func registerUser(email: String, password: String, username: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
        } catch {
            print("Register error: \(error.localizedDescription)")
            throw error
        }
    }
    
    func signOut() {
        
    }
}
