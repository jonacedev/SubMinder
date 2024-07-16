//
//  SettingsViewModel.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 12/7/24.
//

import Foundation

class SettingsViewModel: BaseViewModel {
    
    @Published var userData: UserModel?
    private let firebaseManager: FirebaseManager
    
    init(firebaseManager: FirebaseManager) {
        self.firebaseManager = firebaseManager
        super.init()
        fetchSettingsData()
    }
    
    func fetchSettingsData() {
        Task {
            await getUserData()
        }
    }
        
    @MainActor
    func deleteAccount() async {
        observeStateManager()
        do {
            try await firebaseManager.deleteUserAccount()
            
        } catch {
            manageError(alert: BaseAlert.Model(title: "Error",
                                               description: error.localizedDescription,
                                               buttonText1: "Aceptar",
                                               action1: { self.hideAlert() }))
        }
    }
    
    @MainActor
    func getUserData() async {
        do {
            self.userData = try await firebaseManager.getUserData()
        } catch {
            manageError(alert: BaseAlert.Model(title: "Error",
                                               description: error.localizedDescription,
                                               buttonText1: "Aceptar",
                                               action1: { self.hideAlert() }))
        }
    }
    
    @MainActor
    func signOut() {
        firebaseManager.signOut()
    }
    
    @MainActor
    func getUserSubscriptions() async -> [SubscriptionModelDto]? {
        do {
            return try await firebaseManager.getUserSubscriptions()
        } catch {
            return nil
        }
    }
    
    func enableNotifications() {
        showLoading()
        Task {
            let subscriptions = await getUserSubscriptions()
            if let subscriptions = subscriptions {
                subscriptions.forEach {
                    NotificationsManager.shared.configNotification(at: $0.paymentDate.toDate(), withTitle: "Recordatorio", andBody: "Tu suscripción a \($0.name) va a renovarse en 3 días!", identifier: $0.id)
                }
                
                hideLoading()
            } else {
                hideLoading()
            }
        }
    }
    
    func disableNotifications() {
        NotificationsManager.shared.removeNotifications()
    }
    
    func observeStateManager() {
        firebaseManager.$isLoadingOperation.sink { isLoading in
            if isLoading {
                self.showLoading()
            } else {
                self.hideLoading()
            }
        }.store(in: &cancellables)
    }
    
    func isAppleSession() -> Bool {
        firebaseManager.isAppleSession()
    }
    
    func notificationsDeniedAlert() {
        showAlert(alert: BaseAlert.Model(image: "ic_alert",
                                         title: "Permiso de notificaciones denegado",
                                         description: "Concede permiso de notificaciones para poder recibir recordatorios de tus suscripciones",
                                         buttonText1: "Aceptar",
                                         buttonText2: "Ir a ajustes",
                                         action1: { [weak self] in
            self?.hideAlert()
        }, action2: { [weak self] in
            self?.hideAlert()
            BaseActions.openAppSettings()
        }))
    }
    
    func deleteAppleAccountAlert(onAccept: @escaping () -> Void) {
        showAlert(alert: BaseAlert.Model(image: "ic_alert",
                                         title: "Importante",
                                         description: "Tienes que volver a iniciar sesión para eliminar tu cuenta vinculada a Apple",
                                         buttonText1: "Aceptar",
                                         action1: { [weak self] in
            self?.hideAlert()
            onAccept()
        }))
    }
}
