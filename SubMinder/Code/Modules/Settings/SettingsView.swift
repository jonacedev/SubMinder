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
    
    @State var notificationsEnabled = false
    
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
            
            VStack {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundStyle(
                        LinearGradient(
                        colors: [Color.additionalPurple, Color.additionalBlue],
                        startPoint: .topLeading,
                        endPoint: .trailing)
                    )
                    .padding(.top, 50)
                    .padding(.bottom, 10)
                
                SMText(text: viewModel.userData?.username ?? "", fontType: .medium, size: .large)
                
                SMText(text: viewModel.userData?.email ?? "", fontType: .regular, size: .medium)
                    .foregroundStyle(Color.secondary3)
            }
            .padding(.bottom, 50)
            
            VStack {
                HStack {
                    SMText(text: "Notificaciones", fontType: .regular, size: .medium)
                    
                    Toggle("", isOn: $notificationsEnabled)
                        .onChange(of: notificationsEnabled) { newValue, oldValue in
                            NotificationsManager.shared.requestAuthorization(granted: {
                                print("granted")
                            }, denied: {
                                notificationsEnabled = false
                                viewModel.notificationsDeniedAlert()
                            })
                        }
                }
                .padding(.vertical, 10)
                
                Divider()
                    .foregroundStyle(Color.secondary4)
 
            }
            .padding(.horizontal, 20)
            
        
            Spacer()
            
            SMMainButton(title: "Cerrar sesión", action: {
                viewModel.signOut()
            })
            .foregroundStyle(Color.white)
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
            
            
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
