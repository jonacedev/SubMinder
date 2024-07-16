//
//  SubscriptionViewModel.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 11/7/24.
//

import Foundation

class SubscriptionDetailViewModel: BaseViewModel {
    
    @Published var subscription: SubscriptionModelDto?
    private let firebaseManager: FirebaseManager
    
    init(firebaseManager: FirebaseManager, subscription: SubscriptionModelDto) {
        self.firebaseManager = firebaseManager
        self.subscription = subscription
        super.init()
    }
    
    @MainActor
    func updateSubscriptionWithData(updatedModel: SubscriptionModelDto) async {
        showLoading()
        do {
            try await firebaseManager.updateSubscriptionWithData(updatedModel: updatedModel)
            hideLoading()
        } catch {
            manageError(alert: BaseAlert.Model(title: "Error",
                                               description: error.localizedDescription,
                                               buttonText1: "Aceptar",
                                               action1: { self.hideAlert() }))
        }
    }
    
    @MainActor
    func removeSubscription(subscriptionId: String) async {
        showLoading()
        do {
            try await firebaseManager.removeSubscription(subscriptionId: subscriptionId)
            hideLoading()
        } catch {
            manageError(alert: BaseAlert.Model(title: "Error",
                                               description: error.localizedDescription,
                                               buttonText1: "Aceptar",
                                               action1: { self.hideAlert() }))
        }
    }
    
    func removeNotification(subscriptionId: String, success: @escaping () -> Void) {
        NotificationsManager.shared.removeNotification(withIdentifier: subscriptionId)
        success()
    }
    
    func updateNotification(model: SubscriptionModelDto, success: @escaping () -> Void) {
        NotificationsManager.shared.updateNotification(forSubscription: model)
        success()
    }
    
}
