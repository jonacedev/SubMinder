//
//  FirebaseManager.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 3/7/24.
//

import Combine
import FirebaseAuth
import FirebaseFirestore
import AuthenticationServices
import CryptoKit

class FirebaseManager: NSObject, ObservableObject {
    
    @Published var userSession: FirebaseAuth.User?
    @Published var isLoadingOperation = false
    
    // MARK: Apple variables
    var isReauthentication = false
    var currentNonce: String?
    var nonce: String? {
        currentNonce ?? nil
    }
    
    // MARK: - Update Session
    
    func updateUserSession() {
        verifySignInWithAppleID {
            DispatchQueue.main.async {
                self.userSession = Auth.auth().currentUser
            }
        }
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
    
    @MainActor
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
    
    @MainActor
    func addNewSubscription(model: NewSubscriptionModel) async throws {
        do {
            let userId = userSession?.uid ?? ""
            let subscriptionData = try Firestore.Encoder().encode(model)
            try await Firestore.firestore().collection("users").document(userId).collection("subscriptions").document(model.id).setData(subscriptionData)
        } catch {
            print("Upload user data error: \(error.localizedDescription)")
            throw error
        }
    }
    
    // MARK: - Get subscriptions
    
    @MainActor
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
            let defaultModel = NewSubscriptionModel(name: "default", image: "netflix", price: 5.99, paymentDate: "25-11-2024", type: "Anual", divisa: "EUR")
            
            let thisWeekModel0 = NewSubscriptionModel(name: "default", image: "spotify", price: 5.99, paymentDate: "26-07-2024", type: "Semanal", divisa: "EUR")
            let thisWeekModel = NewSubscriptionModel(name: "default", image: "crunchyroll", price: 5.99, paymentDate: "28-07-2024", type: "Mensual", divisa: "EUR")
            let thisWeekModel2 = NewSubscriptionModel(name: "default", image: "behance", price: 5.99, paymentDate: "27-07-2024", type: "Trimestral", divisa: "EUR")
            let thisWeekModel3 = NewSubscriptionModel(name: "default", image: "youtube", price: 5.99, paymentDate: "24-07-2024", type: "Prueba", divisa: "EUR")
            
            let freeTrialModel = NewSubscriptionModel(name: "default", image: "linkedin", price: 5.99, paymentDate: "26-08-2025", type: "Prueba", divisa: "EUR")
            
            return [SubscriptionModelDto(model: defaultModel),
                    SubscriptionModelDto(model: thisWeekModel0),
                    SubscriptionModelDto(model: thisWeekModel),
                    SubscriptionModelDto(model: thisWeekModel2),
                    SubscriptionModelDto(model: thisWeekModel3),
                    SubscriptionModelDto(model: freeTrialModel)]
        }
    }
    
    // MARK: - Update methods
    
    func updateExpiratedSubscriptions(subscriptionId: String, newExpirationDate: String) async throws {
        let userId = userSession?.uid ?? ""
        do {
            let docRef = Firestore.firestore()
                .collection("users")
                .document(userId)
                .collection("subscriptions")
                .document(subscriptionId)
            
            try await docRef.updateData([
                "paymentDate": newExpirationDate
            ])
            
        } catch {
            print("Register error: \(error.localizedDescription)")
            throw error
        }
    }
    
    func updateSubscriptionWithData(updatedModel: SubscriptionModelDto) async throws {
        let userId = userSession?.uid ?? ""
        let subscriptionId = updatedModel.id
        do {
            let docRef = Firestore.firestore()
                .collection("users")
                .document(userId)
                .collection("subscriptions")
                .document(subscriptionId)
            
            try await docRef.updateData([
                "id": updatedModel.id,
                "name": updatedModel.name,
                "image": updatedModel.image,
                "price": updatedModel.price,
                "paymentDate": updatedModel.paymentDate,
                "type": updatedModel.type.rawValue,
                "divisa": updatedModel.divisa
            ])
        } catch {
            print("Register error: \(error.localizedDescription)")
            throw error
        }
    }
    
    // MARK: - Remove subscription
    
    @MainActor
    func removeSubscription(subscriptionId: String) async throws {
        let userId = userSession?.uid ?? ""
        do {
            let docRef = Firestore.firestore()
                .collection("users")
                .document(userId)
                .collection("subscriptions")
                .document(subscriptionId)
            
            try await docRef.delete()
            
        } catch {
            print("Register error: \(error.localizedDescription)")
            throw error
        }
    }
    
    @MainActor
    func removeUserData(userId: String) async throws {
        do {
            
            let subscriptions = try await getUserSubscriptions()
            for subscription in subscriptions {
                try await removeSubscription(subscriptionId: subscription.id)
           }
            
            let userRef = Firestore.firestore()
                .collection("users")
                .document(userId)
            
            try await userRef.delete()
            
        } catch {
            print("Register error: \(error.localizedDescription)")
            throw error
        }
    }
    
    
    // MARK: - Sign out
    
    @MainActor
    func signOut() {
        try? Auth.auth().signOut()
        self.userSession = nil
    }
}

// MARK: Apple login
extension FirebaseManager: ASAuthorizationControllerDelegate {
    
    func performAppleSignIn(isReauthentication: Bool = false) {
        self.isReauthentication = isReauthentication
        currentNonce = randomNonceString()
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(currentNonce!)
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.performRequests()
    }
    
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredentials = authorization.credential as? ASAuthorizationAppleIDCredential else {
            operationIsLoading(isLoading: false)
            return
        }
        
        Task {
            do {
                if isReauthentication {
                    if let user = self.userSession {
                        try await reauthenticateAppleID(appleIDCredentials, for: user, nonce: nonce)
                        operationIsLoading(isLoading: false)
                    }
                  
                } else {
                    let result = try await appleAuth(appleIDCredentials, nonce: nonce)
                    operationIsLoading(isLoading: false)
                    
                    if let result = result {
                        if let username = appleIDCredentials.fullName?.givenName {
                            let user = UserModel(id: result.user.uid, username: username, email: appleIDCredentials.email ?? "")
                            try await uploadUserData(user: user)
                        }
                       
                        DispatchQueue.main.async {
                            self.userSession = result.user
                        }
                    }
                }

            } catch {
                print("AppleAuthorization failed: \(error)")
                operationIsLoading(isLoading: false)
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        operationIsLoading(isLoading: false)
    }
    
    private func appleAuth(
        _ appleIDCredential: ASAuthorizationAppleIDCredential,
        nonce: String?
    ) async throws -> AuthDataResult? {
        guard let nonce = nonce else { return nil }
        guard let appleIDToken = appleIDCredential.identityToken else { return nil }
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else { return nil }
        
        let credentials = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                        rawNonce: nonce,
                                                        fullName: appleIDCredential.fullName)
        
        do {
            return try await Auth.auth().signIn(with: credentials)
        }
        catch {
            print("FirebaseAuthError: appleAuth(appleIDCredential:nonce:) failed. \(error)")
            throw error
        }
    }
    
    private func reauthenticateAppleID(
        _ appleIDCredential: ASAuthorizationAppleIDCredential,
        for user: User,
        nonce: String?
    ) async throws {
        do {
            guard let nonce = nonce else { return }
            guard let appleIDToken = appleIDCredential.identityToken else { return }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else { return }
   
            let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                           rawNonce: nonce,
                                                           fullName: appleIDCredential.fullName)
            try await user.reauthenticate(with: credential)
            try await revokeAppleIDToken(appleIDCredential)
            try await removeAndCloseSession(user: user)
        }
        catch {
            print("Reauthenticate apple failed. \(error)")
            throw error
        }
    }
    
    private func revokeAppleIDToken(_ appleIDCredential: ASAuthorizationAppleIDCredential) async throws {
        guard let authorizationCode = appleIDCredential.authorizationCode else { return }
        guard let authCodeString = String(data: authorizationCode, encoding: .utf8) else { return }

        do {
            try await Auth.auth().revokeToken(withAuthorizationCode: authCodeString)
        }
        catch {
            print("Revoke apple token failed. \(error)")
            throw error
        }
    }
    
    
    // MARK: - Helpers
    
    func verifySignInWithAppleID(success: @escaping () -> Void) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let providerData = Auth.auth().currentUser?.providerData
        if isAppleSession(), let appleProviderData = providerData?.first(where: { $0.providerID == "apple.com" }) {
            Task {
                let credentialState = try await appleIDProvider.credentialState(forUserID: appleProviderData.uid)
                switch credentialState {
                case .authorized:
                    success()
                    break
                case .revoked, .notFound:
                    DispatchQueue.main.async {
                        self.userSession = nil
                    }
                default:
                    break
                }
            }
        } else {
            success()
        }
    }
    
    func isAppleSession() -> Bool {
        let providerData = Auth.auth().currentUser?.providerData
        if let _ = providerData?.first(where: { $0.providerID == "apple.com" }) {
            return true
        } else {
            return false
        }
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }
        
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}

extension FirebaseManager {
    
    func deleteUserAccount() async throws {
        guard let user = Auth.auth().currentUser else { return }
        let providers = user.providerData.map { $0.providerID }
        operationIsLoading(isLoading: true)
        
        do {
            if providers.contains("apple.com")  {
                performAppleSignIn(isReauthentication: true)
            } else {
                try await removeAndCloseSession(user: user)
                operationIsLoading(isLoading: false)
                
            }
        }
        catch {
            print("FirebaseAuthError: Failed to delete auth user. \(error)")
            operationIsLoading(isLoading: false)
            throw error
        }
    }
    
    func removeAndCloseSession(user: FirebaseAuth.User) async throws {
        try await removeUserData(userId: user.uid)
        try await user.delete()
        
        DispatchQueue.main.async {
            self.userSession = nil
        }
    }
    
    func operationIsLoading(isLoading: Bool) {
        DispatchQueue.main.async {
            self.isLoadingOperation = isLoading
        }
    }
}

