//
//  HomeViewModel.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 3/7/24.
//

import SwiftUI

final class HomeViewModel: BaseViewModel {
    
    
    @Published var userData: UserModel?
    @Published var subscriptions: [SubscriptionModelDto]?
    @Published var upcomingSubscriptions: [SubscriptionModelDto]?
    var needToUpdate = false
    
    private let firebaseManager: FirebaseManager
    
    init(firebaseManager: FirebaseManager) {
        self.firebaseManager = firebaseManager
        super.init()
        fetchHomeData()
    }
    
    func fetchHomeData() {
        Task {
            showLoading()
            await withTaskGroup(of: Void.self) { group in
                group.addTask { await self.getUserData() }
                group.addTask { await self.getUserSubscriptions() }
            }
            hideLoading()
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
    func getUserSubscriptions() async {
        do {
            if !BaseActions.isPreview() {
                let subscriptionsDto = try await firebaseManager.getUserSubscriptions()
                await checkExpiratedSubscriptions(subscriptions: subscriptionsDto)
            }
            
            self.subscriptions = try await firebaseManager.getUserSubscriptions()
            self.upcomingSubscriptions = subscriptions?.filter { $0.paymentDate.toDate()?.isWithinNext15Days() == true }
        } catch {
            manageError(alert: BaseAlert.Model(title: "Error",
                                               description: error.localizedDescription,
                                               buttonText1: "Aceptar",
                                               action1: { self.hideAlert() }))
        }
    }
    
    @MainActor func signOut() {
        firebaseManager.signOut()
    }
    
    @MainActor
    func checkExpiratedSubscriptions(subscriptions: [SubscriptionModelDto]) async {
        
        let currentDate = Date()
        for subscription in subscriptions {
            if let expirationDate = subscription.paymentDate.toDate(), expirationDate <= currentDate {
                
                if subscription.type != .freeTrial, let newExpirationDate = expirationDate.nextExpirationDate(type: subscription.type)?.toString() {
                    do {
                        try await firebaseManager.updateExpiratedSubscriptions(subscriptionId: subscription.id, newExpirationDate: newExpirationDate)
                    } catch {
                        manageError(alert: BaseAlert.Model(title: "Error",
                                                           description: error.localizedDescription,
                                                           buttonText1: "Aceptar",
                                                           action1: { self.hideAlert() }))
                    }
                } else {
                    do {
                        try await firebaseManager.removeSubscription(subscriptionId: subscription.id)
                    } catch {
                        manageError(alert: BaseAlert.Model(title: "Error",
                                                           description: error.localizedDescription,
                                                           buttonText1: "Aceptar",
                                                           action1: { self.hideAlert() }))
                    }
                }
                
            }
        }
    }
    
    func averageCost(period: SubscriptionType) -> String {
        
        let conversionFactor: (SubscriptionModelDto) -> Double
        switch period {
        case .weekly:
            conversionFactor = { subscription in
                switch subscription.type {
                case .weekly:
                    return subscription.price
                case .monthly:
                    return subscription.price / 4 // Dividir por el número promedio de semanas en un mes
                case .yearly:
                    return subscription.price / 48 // Dividir por el número de semanas en un año
                case .quarterly:
                    return subscription.price / 12 // Dividir por el número de semanas en un trimestre
                case .freeTrial:
                    return 0 // O ignorar si no se quieren considerar los free trials
                }
            }
        case .monthly:
            conversionFactor = { subscription in
                switch subscription.type {
                case .weekly:
                    return subscription.price * 4 // Convertir a costos mensuales
                case .monthly:
                    return subscription.price
                case .yearly:
                    return subscription.price / 12 // Dividir por el número de meses en un año
                case .quarterly:
                    return subscription.price / 3 // Dividir por el número de meses en un trimestre
                case .freeTrial:
                    return 0 // O ignorar si no se quieren considerar los free trials
                }
            }
        case .yearly:
            conversionFactor = { subscription in
                switch subscription.type {
                case .weekly:
                    return subscription.price * 48 // Convertir a costos anuales
                case .monthly:
                    return subscription.price * 12 // Convertir a costos anuales
                case .yearly:
                    return subscription.price
                case .quarterly:
                    return subscription.price * 4 // Convertir a costos anuales
                case .freeTrial:
                    return 0 // O ignorar si no se quieren considerar los free trials
                }
            }
            
        default:
            return ""
        }
        
        // Aplicar el factor de conversión y calcular la media
        let costs = subscriptions?.map(conversionFactor)
        let totalCosts = costs?.reduce(0, +) ?? 0
        let average = costs?.isEmpty == true ? 0.0 : totalCosts
        return String.convertDoubleToString(average)
    }
    
    func getTotalSubscriptions() -> String {
        "\(subscriptions?.count ?? 0)"
    }
    
    func getWeeklyPayments() -> String {
        "\(subscriptions?.filter{ $0.paymentDate.toDate()?.isDateInCurrentWeek() == true }.count ?? 0)"
    }
    
    func getFreeTrials() -> String {
        "\(subscriptions?.filter{ $0.type == .freeTrial }.count ?? 0)"
    }
    
    func calculateProgress(type: SubscriptionType ,endDate: Date) -> Double {
        let startDate = Calendar.current.date(byAdding: .day, value: -14, to: endDate) ?? Date()
        let totalDuration = endDate.timeIntervalSince(startDate)
        let elapsed = Date().timeIntervalSince(startDate)
        return min(max(elapsed / totalDuration, 0.0), 1.0)
    }
}
