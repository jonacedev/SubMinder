//
//  NewSubscriptionFormViewModel.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 6/7/24.
//

import Foundation
import FirebaseFirestore

class NewSubscriptionFormViewModel: ObservableObject {
    
    private let firebaseManager: FirebaseManager
    
    init(firebaseManager: FirebaseManager) {
        self.firebaseManager = firebaseManager
    }
    
    func addNewSubscription(model: NewSubscriptionModel) async {
        do {
            try await firebaseManager.addNewSubscription(model: model)
        } catch {
            print("error: \(error.localizedDescription)")
        }
    }
}
