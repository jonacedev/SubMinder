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
    
}
