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
}
