//
//  AddSubscriptionViewModel.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 5/7/24.
//

import Foundation

class NewSubscriptionViewModel: ObservableObject {
    
    @Published var selectedSubscription: SubscriptionModel?
    private let authService: AuthService
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    func tapSubscription(subscription: SubscriptionModel, success: @escaping () -> Void) {
        self.selectedSubscription = subscription
        success()
    }
    
    func tapOtherSubscription(success: @escaping () -> Void) {
        self.selectedSubscription = SubscriptionsFactory.shared.getDefaultSubscription()
        success()
    }
    
    
}
