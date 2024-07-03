//
//  HomeView.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 2/7/24.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var baseManager: BaseManager
    @StateObject var viewModel: HomeViewModel
    
    init(authService: AuthService) {
        self._viewModel = StateObject(wrappedValue: HomeViewModel(authService: authService))
    }
    
    var body: some View {
        VStack {
            Text("Home")
            Button("Logout", action: {
                viewModel.signOut()
            })
        }
    }
}

#Preview {
    HomeView(authService: AuthService())
        .environmentObject(BaseManager())
}
