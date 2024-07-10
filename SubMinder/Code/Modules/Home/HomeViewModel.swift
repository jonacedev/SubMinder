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
    
    func getWeeklyAmount() -> String {
        let weeklySubscriptions = subscriptions?.filter { $0.paymentDate.toDate()?.isDateInCurrentWeek() == true }
        let weeklyAmount = weeklySubscriptions?.reduce(0.0) { $0 + $1.price }
        return String.convertDoubleToString(weeklyAmount)
    }
    
    func getMonthlyAmount() -> String {
        let monthlySubscriptions = subscriptions?.filter { $0.paymentDate.toDate()?.isDateInCurrentMonth() == true }
        let monthlyAmount = monthlySubscriptions?.reduce(0.0) { $0 + $1.price }
        return String.convertDoubleToString(monthlyAmount)
    }
    
    func getAnualAmount() -> String {
        let anualSubscriptions = subscriptions?.filter { $0.paymentDate.toDate()?.isDateInCurrentYear() == true }
        let anualAmount = anualSubscriptions?.reduce(0.0) { $0 + $1.price }
        return String.convertDoubleToString(anualAmount)
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
