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
}
