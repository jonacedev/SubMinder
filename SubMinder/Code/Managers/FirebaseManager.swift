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
    
    // MARK: - Auth methods
    
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
    
    
    // MARK: - User data
    
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
    
    // MARK: - Add New subscription
    
    func addNewSubscription(model: NewSubscriptionModel) async throws {
        do {
            let userId = userSession?.uid ?? ""
            let subscriptionData = try Firestore.Encoder().encode(model)
            try await Firestore.firestore().collection("users").document(userId).collection("subscriptions").document().setData(subscriptionData)
        } catch {
            print("Upload user data error: \(error.localizedDescription)")
            throw error
        }
    }
    
    // MARK: - Get subscriptions
    
    func getUserSubscriptions() async throws -> [SubscriptionModelDto] {
        if !BaseActions.isPreview() {
            let userId = userSession?.uid ?? ""
            
            do {
                let querySnapshot = try await Firestore.firestore().collection("users").document(userId).collection("subscriptions").getDocuments()
                let subscriptions = try querySnapshot.documents.compactMap { document in
                    try document.data(as: NewSubscriptionModel.self)
                }
                return subscriptions.compactMap { SubscriptionModelDto(model: $0)}
            } catch {
                print("Fetch subscription data error: \(error.localizedDescription)")
                throw error
            }
        } else {
            let defaultModel = NewSubscriptionModel(name: "default", image: "netflix", price: 5.99, paymentDate: "17-06-2025", type: "Trimestral", divisa: "EUR")
            return [SubscriptionModelDto(model: defaultModel),
                    SubscriptionModelDto(model: defaultModel),
                    SubscriptionModelDto(model: defaultModel),
                    SubscriptionModelDto(model: defaultModel),
                    SubscriptionModelDto(model: defaultModel),
                    SubscriptionModelDto(model: defaultModel)]
        }
        
    }
    
    
    // MARK: - Sign out
    
    func signOut() {
        try? Auth.auth().signOut()
        self.userSession = nil
    }
}
