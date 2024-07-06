//
//  FirebaseManager.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 3/7/24.
//

import Combine
import FirebaseAuth
import FirebaseFirestore

class FirebaseManager: ObservableObject {
    
    @Published var userSession: FirebaseAuth.User?
    
    func updateUserSession() {
        self.userSession = Auth.auth().currentUser
    }
    
    @MainActor
    func login(email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
        } catch {
            print("Register error: \(error.localizedDescription)")
            throw error
        }
    }
    
    @MainActor
    func registerUser(email: String, password: String, username: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            
            let user = UserModel(id: result.user.uid, username: username, email: email)
            try await uploadUserData(user: user)
        } catch {
            print("Register error: \(error.localizedDescription)")
            throw error
        }
    }
    
    @MainActor
    func uploadUserData(user: UserModel) async throws {
        do {
            let userData = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(userData)
        } catch {
            print("Upload user data error: \(error.localizedDescription)")
            throw error
        }
    }
    
    func getUserData() async throws -> UserModel? {
        
        if !BaseActions.isPreview() {
            let userId = userSession?.uid ?? ""
            let userData = Firestore.firestore().collection("users").document(userId)
            
            do {
                let document = try await userData.getDocument()
                return try document.data(as: UserModel.self)
            } catch {
                print("Error getting user data")
                throw error
            }
        } else {
            return UserModel(id: "0", username: "User test", email: "example@gmail.com")
        }
        
    }
    
    func signOut() {
        try? Auth.auth().signOut()
        self.userSession = nil
    }
}
