//
//  HomeViewModel.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 3/7/24.
//

import SwiftUI

final class HomeViewModel: ObservableObject {
    
    
    @Published var userData: UserModel?
    @Published var subscriptions: [SubscriptionModelDto]?
    
    private let firebaseManager: FirebaseManager
    
    init(firebaseManager: FirebaseManager) {
        self.firebaseManager = firebaseManager
        fetchHomeData()
    }
    
    func fetchHomeData() {
        Task {
            await withTaskGroup(of: Void.self) { group in
                group.addTask { await self.getUserData() }
                group.addTask { await self.getUserSubscriptions() }
            }
        }
    }
    
    @MainActor func getUserData() async {
        do {
            self.userData = try await firebaseManager.getUserData()
        } catch {
            print("error: \(error.localizedDescription)")
        }
    }
    
    @MainActor func getUserSubscriptions() async {
        do {
            self.subscriptions = try await firebaseManager.getUserSubscriptions()
        } catch {
            print("error: \(error.localizedDescription)")
        }
    }
    
    @MainActor func signOut() {
        firebaseManager.signOut()
    }
    
    func getTotalSubscriptions() -> String {
        "\(subscriptions?.count ?? 0)"
    }
    
    func getWeeklyPayments() -> String {
        "5"
    }
    
    func getFreeTrials() -> String {
        "1"
    }
    
    
    // Function to calculate the progress
    func calculateProgress(startDate: Date, endDate: Date) -> Double {
        
        //let startDate = Calendar.current.date(byAdding: .day, value: -15, to: Date()) ?? Date()
        let totalDuration = endDate.timeIntervalSince(startDate)
        let elapsed = Date().timeIntervalSince(startDate)
        return min(max(elapsed / totalDuration, 0.0), 1.0)
    }
}
