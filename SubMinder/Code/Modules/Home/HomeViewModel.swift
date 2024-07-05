//
//  HomeViewModel.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 3/7/24.
//

import SwiftUI

final class HomeViewModel: ObservableObject {
    
    private let authService: AuthService
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    @MainActor func signOut() {
        authService.signOut()
    }
    
    
    // Function to calculate the progress
    func calculateProgress(startDate: Date, endDate: Date) -> Double {
        
        //let startDate = Calendar.current.date(byAdding: .day, value: -15, to: Date()) ?? Date()
        let totalDuration = endDate.timeIntervalSince(startDate)
        let elapsed = Date().timeIntervalSince(startDate)
        return min(max(elapsed / totalDuration, 0.0), 1.0)
    }
}
