//
//  SettingsView.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 12/7/24.
//

import SwiftUI

struct SettingsView: View {
    
    @StateObject var viewModel: SettingsViewModel
    @State var showDeleteAlert = false
    
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
            
            
            SMLinkButtonStyled(title: "Eliminar cuenta", action: {
                if viewModel.isAppleSession() {
                    showDeleteAlert = true
                } else {
                    deleteAccount()
                }
                
            }, withGradient: false)
            .alert(isPresented: $showDeleteAlert, content: {
                Alert(title: Text("Importante"), message: Text("Inicia sesión para eliminar tu cuenta vinculada a Apple."), dismissButton: .default(Text("Ok"), action: {
                    deleteAccount()
                }))
            })
            .padding(.bottom, 20)
        }
    }
    
    func deleteAccount() {
        Task {
            await viewModel.deleteAccount()
        }
    }
    
    
}

#Preview {
    SettingsView(firebaseManager: FirebaseManager())
}
