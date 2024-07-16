//
//  NewSubscriptionFormViewModel.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 6/7/24.
//

import Foundation
import FirebaseFirestore

class NewSubscriptionFormViewModel: BaseViewModel {
    
    private let firebaseManager: FirebaseManager
    
    init(firebaseManager: FirebaseManager) {
        self.firebaseManager = firebaseManager
        super.init()
    }
    
    func addNewSubscription(model: NewSubscriptionModel) async {
        showLoading()
        do {
            try await firebaseManager.addNewSubscription(model: model)
            hideLoading()
        } catch {
            manageError(alert: BaseAlert.Model(title: "Error",
                                               description: error.localizedDescription,
                                               buttonText1: "Aceptar",
                                               action1: { self.hideAlert() }))
        }
    }
    
    func configReminderNotification(model: NewSubscriptionModel, success: @escaping () -> Void) {
        NotificationsManager.shared.configNotification(at: model.paymentDate.toDate(), withTitle: "Recordatorio", andBody: "Tu suscripción a \(model.name) va a renovarse en 3 días!", identifier: model.id)
        success()
    }
}
