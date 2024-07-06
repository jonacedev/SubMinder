//
//  HomeViewModel.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 3/7/24.
//

import SwiftUI

final class HomeViewModel: ObservableObject {
    
    
    @Published var userData: UserModel?
    private let firebaseManager: FirebaseManager
    
    init(firebaseManager: FirebaseManager) {
        self.firebaseManager = firebaseManager
        homeRequests()
    }
    
    func homeRequests() {
        Task {
            await getUserData()
        }
    }
    
    @MainActor func getUserData() async {
        do {
            self.userData = try await firebaseManager.getUserData()
        } catch {
            print("error: \(error.localizedDescription)")
        }
    }
    
    @MainActor func signOut() {
        firebaseManager.signOut()
    }
    
    
    // Function to calculate the progress
    func calculateProgress(startDate: Date, endDate: Date) -> Double {
        
        //let startDate = Calendar.current.date(byAdding: .day, value: -15, to: Date()) ?? Date()
        let totalDuration = endDate.timeIntervalSince(startDate)
        let elapsed = Date().timeIntervalSince(startDate)
        return min(max(elapsed / totalDuration, 0.0), 1.0)
    }
}
