//
//  SettingsView.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 12/7/24.
//

import SwiftUI

struct SettingsView: View {
    
    @StateObject var viewModel: SettingsViewModel
    @State private var userDefaults = UserDefaultsCache()
    
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
            
            vwUserInfo()
                .padding(.bottom, 50)
            
            vwUserOptions()
                .padding(.horizontal, 20)
            
        
            Spacer()
            
            vwBottom()
                .padding(.bottom, 20)
        }
    }
    
    @ViewBuilder private func vwUserInfo() -> some View {
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
    }
    
    @ViewBuilder private func vwUserOptions() -> some View {
        VStack {
            HStack {
                SMText(text: "Notificaciones", fontType: .regular, size: .medium)
                
                Toggle("", isOn: $userDefaults.notificationsEnabled)
                    .tint(Color.secondary2)
                    .onChange(of: userDefaults.notificationsEnabled) { oldValue, newValue in
                        NotificationsManager.shared.requestAuthorization(granted: {
                            if newValue {
                                userDefaults.notificationsEnabled = true
                                viewModel.enableNotifications()
                            } else {
                                userDefaults.notificationsEnabled = false
                                viewModel.disableNotifications()
                            }
                           
                        }, denied: {
                            userDefaults.notificationsEnabled = false
                            viewModel.notificationsDeniedAlert()
                        })
                    }
            }
            .padding(.vertical, 10)
            
            Divider()
                .foregroundStyle(Color.secondary4)

        }
    }
    
    @ViewBuilder private func vwBottom() -> some View {
        
        SMMainButton(title: "Cerrar sesión", action: {
            viewModel.signOut()
        })
        .foregroundStyle(Color.white)
        .padding(.horizontal, 20)
        .padding(.bottom, 30)
        
        
        SMLinkButtonStyled(title: "Eliminar cuenta", action: {
            if viewModel.isAppleSession() {
                viewModel.deleteAppleAccountAlert(onAccept: {
                    deleteAccount()
                })
            } else {
                deleteAccount()
            }
            
        }, withGradient: false)
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
