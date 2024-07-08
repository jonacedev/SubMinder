//
//  AddSubscriptionViewModel.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 5/7/24.
//

import Foundation

class SubscriptionSelectionViewModel: ObservableObject {
    
    @Published var selectedSubscription: SubscriptionSelectorModel?
    private let firebaseManager: FirebaseManager
    
    init(firebaseManager: FirebaseManager) {
        self.firebaseManager = firebaseManager
    }
    
    func tapSubscription(subscription: SubscriptionSelectorModel, success: @escaping () -> Void) {
        self.selectedSubscription = subscription
        success()
    }
    
    func tapOtherSubscription(success: @escaping () -> Void) {
        self.selectedSubscription = SubscriptionsFactory.shared.getDefaultSubscription()
        success()
    }
    
    
}
