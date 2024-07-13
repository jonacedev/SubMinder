//
//  SettingsView.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 12/7/24.
//

import SwiftUI

struct SettingsView: View {
    
    @StateObject var viewModel: SettingsViewModel
    
    init(firebaseManager: FirebaseManager) {
        self._viewModel = StateObject(wrappedValue: SettingsViewModel(firebaseManager: firebaseManager))
    }
    
    var body: some View {
        BaseView(content: content, viewModel: viewModel)
            .toolbarRole(.editor)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Ajustes")
    }
    
    @ViewBuilder private func content() -> some View {
        VStack {
            
            
            
            Spacer()
            
            SMMainButton(title: "Cerrar sesión", action: {
                viewModel.signOut()
            })
            .foregroundStyle(Color.white)
            .padding(.horizontal, 20)
            .padding(.bottom, 50)
        }
    }
    
    
}

#Preview {
    SettingsView(firebaseManager: FirebaseManager())
}
