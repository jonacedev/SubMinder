//
//  NewSubscriptionFormViewModel.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 6/7/24.
//

import Foundation

class NewSubscriptionFormViewModel: ObservableObject {
    
    private let firebaseManager: FirebaseManager
    
    init(firebaseManager: FirebaseManager) {
        self.firebaseManager = firebaseManager
    }
}
