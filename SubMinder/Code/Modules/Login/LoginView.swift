//
//  LoginView.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 2/7/24.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var baseManager: BaseManager
    @StateObject var viewModel: LoginViewModel
    private let authService: AuthService
    
    @State var navigateToRegister: Bool = false
    @State var email: String = ""
    @State var password: String = ""
    
    init(authService: AuthService) {
        self.authService = authService
        self._viewModel = StateObject(wrappedValue: LoginViewModel(authService: authService))
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                SMText(text: "login_header".localized,
                           fontType: .bold,
                           size: .header)
                .padding(.bottom, 30)
                
                vwFields()
                
                SMMainButton(title: "login_btn".localized, action: {
                    makeLogin()
                })
                
                Divider()
                    .frame(height: 0.9)
                    .background(Color.secondary4)
                
                vwBottom()
            }
            .padding(.horizontal, 20)
            .navigationDestination(isPresented: $navigateToRegister, destination: {
                RegisterView(authService: authService)
                    .environmentObject(baseManager)
            })
        }
        .tint(.additionalPurple)
    }
    
    @ViewBuilder private func vwFields() -> some View {
        
        VStack(alignment: .leading) {
           
            SMText(text: "login_email".localized)
            SMTextField(placeholder: "login_email_placeholder".localized, text: $email)
                .padding(.bottom, 20)
       
            SMText(text: "login_password".localized)
            SMSecureTextField(placeholder: "login_password_placeholder".localized, text: $password)
        }
    }
    
    @ViewBuilder private func vwBottom() -> some View {
        HStack {
            SMText(text: "login_no_account".localized)
            Button(action: {
                navigateToRegister = true
            }, label: {
                SMText(text: "register_link".localized)
                    .underline()
                    .foregroundStyle(LinearGradient(colors: [Color.additionalPurple, Color.additionalBlue], startPoint: .topLeading, endPoint: .trailing))
            })
        }
    }
}

extension LoginView {
    func makeLogin() {
        Task {
            baseManager.showLoading()
            await viewModel.login(email: email, password: password)
            baseManager.hideLoading()
        }
    }
}

#Preview {
    LoginView(authService: AuthService())
        .environmentObject(BaseManager())
}
