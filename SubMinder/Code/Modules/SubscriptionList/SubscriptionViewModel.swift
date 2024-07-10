//
//  SubscriptionViewModel.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 9/7/24.
//

import Foundation

enum ListType {
    case all
    case weekly
    case freeTrial
}

class SubscriptionListViewModel: BaseViewModel {
    
    @Published var subscriptions: [SubscriptionModelDto] = []
    private let firebaseManager: FirebaseManager
    let listType: ListType
    
    init(firebaseManager: FirebaseManager, subscriptions: [SubscriptionModelDto]? = [], listType: ListType) {
        self.firebaseManager = firebaseManager
        self.listType = listType
        super.init()
        manageSubscriptions(subscriptions: subscriptions)
    }
    
    func manageSubscriptions(subscriptions: [SubscriptionModelDto]? = []) {
        switch listType {
        case .all:
            self.subscriptions = subscriptions ?? []
        case .weekly:
            self.subscriptions = subscriptions?.filter { $0.paymentDate.toDate()?.isDateInCurrentWeek() == true } ?? []
        case .freeTrial:
            self.subscriptions = subscriptions?.filter { $0.type == .freeTrial } ?? []
        }
    }
    
    @MainActor 
    func refreshSubscriptions() async {
        showLoading()
        do {
            let subscriptions = try await firebaseManager.getUserSubscriptions()
            manageSubscriptions(subscriptions: subscriptions)
            hideLoading()
        } catch {
            manageError(alert: BaseAlert.Model(title: "Error",
                                               description: error.localizedDescription,
                                               buttonText1: "Aceptar",
                                               action1: { self.hideAlert() }))
        }
    }
    
    func getTitle() -> String {
        return switch listType {
        case .all: "Mis suscripciones"
        case .weekly: "Esta semana"
        case .freeTrial: "Pruebas gratuitas"
        }
    }
    
}
