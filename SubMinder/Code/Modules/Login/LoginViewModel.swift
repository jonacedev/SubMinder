//
//  LoginViewModel.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 3/7/24.
//

import SwiftUI
import Firebase
import GoogleSignIn
import AuthenticationServices

enum LoginOption {
    case emailAndPassword(email: String, password: String)
}

enum SignInState {
    case signedIn
    case signedOut
}

final class LoginViewModel: NSObject, ObservableObject {
    
    
    @Published var state: SignInState = .signedOut
    @Published var errorMessage: String = ""
    fileprivate var currentNonce: String?
    
    /// Master login function that will handle multiple login types depending on what the user chooses
    func login(with loginOption: LoginOption) async {
        switch loginOption {
        case let .emailAndPassword(email, password):
            await signInWithEmail(email: email, password: password)
        }
    }
    
    @MainActor
    func signInWithEmail(email: String, password: String) async {
        do {
            try await Auth.auth().signIn(withEmail: email, password: password)
            self.state = .signedIn
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
        }
        catch {
            print(error.localizedDescription)
            self.errorMessage = error.localizedDescription
        }
    }
}
