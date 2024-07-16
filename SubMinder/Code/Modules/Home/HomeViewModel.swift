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
    @Published var selectedSubscription: SubscriptionModelDto?
    
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
    
    @MainActor
    func checkExpiratedSubscriptions(subscriptions: [SubscriptionModelDto]) async {
        
        let currentDate = Date()
        for subscription in subscriptions {
            if let expirationDate = subscription.paymentDate.toDate(), expirationDate <= currentDate {
                
                if subscription.type != .freeTrial, let newExpirationDate = expirationDate.nextExpirationDate(type: subscription.type)?.toString() {
                    do {
                        try await firebaseManager.updateExpiratedSubscriptions(subscriptionId: subscription.id, newExpirationDate: newExpirationDate)
                        NotificationsManager.shared.requestAuthorization(granted: {
                            NotificationsManager.shared.updateNotification(forSubscription: subscription)
                        }, denied: { })
                        
                    } catch {
                        manageError(alert: BaseAlert.Model(title: "Error",
                                                           description: error.localizedDescription,
                                                           buttonText1: "Aceptar",
                                                           action1: { self.hideAlert() }))
                    }
                }
                else {
                    do {
                        try await firebaseManager.removeSubscription(subscriptionId: subscription.id)
                        NotificationsManager.shared.requestAuthorization(granted: {
                            NotificationsManager.shared.removeNotification(withIdentifier: subscription.id)
                        }, denied: { })
                        
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
        
        let usdToEurRate = 0.85
        let conversionFactor: (SubscriptionModelDto) -> Double
        switch period {
        case .weekly:
            conversionFactor = { subscription in
                let priceInEur = subscription.divisa == "USD" ? subscription.price * usdToEurRate : subscription.price
                switch subscription.type {
                case .weekly:
                    return priceInEur
                case .monthly:
                    return priceInEur / 4 // Average number of weeks in a month
                case .yearly:
                    return priceInEur / 48 // Number of weeks in a year
                case .quarterly:
                    return priceInEur / 12 // Number of weeks in a quarter
                case .freeTrial:
                    return 0 // Ignore free trials
                }
            }
        case .monthly:
            conversionFactor = { subscription in
                let priceInEur = subscription.divisa == "USD" ? subscription.price * usdToEurRate : subscription.price
                switch subscription.type {
                case .weekly:
                    return priceInEur * 4 // Convert to monthly costs
                case .monthly:
                    return priceInEur
                case .yearly:
                    return priceInEur / 12 // Number of months in a year
                case .quarterly:
                    return priceInEur / 3 // Number of months in a quarter
                case .freeTrial:
                    return 0 // Ignore free trials
                }
            }
        case .yearly:
            conversionFactor = { subscription in
                let priceInEur = subscription.divisa == "USD" ? subscription.price * usdToEurRate : subscription.price
                switch subscription.type {
                case .weekly:
                    return priceInEur * 48 // Convert to yearly costs
                case .monthly:
                    return priceInEur * 12 // Convert to yearly costs
                case .yearly:
                    return priceInEur
                case .quarterly:
                    return priceInEur * 4 // Convert to yearly costs
                case .freeTrial:
                    return 0 // Ignore free trials
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
    
    func tapSubscription(subscription: SubscriptionModelDto, success: @escaping () -> Void) {
        self.selectedSubscription = subscription
        success()
    }
}
