//
//  LoginView.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 2/7/24.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject var viewModel: LoginViewModel
    private let firebaseManager: FirebaseManager
    
    @State var pushRegisterView: Bool = false
    @State var email: String = ""
    @State var password: String = ""
    
    init(firebaseManager: FirebaseManager) {
        self.firebaseManager = firebaseManager
        self._viewModel = StateObject(wrappedValue: LoginViewModel(firebaseManager: firebaseManager))
    }
    
    var body: some View {
        BaseView(content: content, viewModel: viewModel)
    }
    
    @ViewBuilder private func content() -> some View {
        NavigationStack {
            VStack(spacing: 40) {
                SMText(text: "login_header".localized,
                       fontType: .bold,
                       size: .header)
                .foregroundStyle(Color.secondary2)
                .padding(.bottom, 30)
                
                vwFields()
                
                SMMainButton(title: "login_btn".localized, action: {
                    makeLogin()
                })
                .frame(height: 44)
                
                vwBottom()
                    .highPriorityGesture(TapGesture(), including: .subviews)
            }
            .padding(.horizontal, 20)
            .navigationDestination(isPresented: $pushRegisterView, destination: {
                RegisterView(firebaseManager: firebaseManager)
            })
        }
        .tint(Color.secondary2)
    }
    
    @ViewBuilder private func vwFields() -> some View {
        
        VStack(alignment: .leading) {
           
            SMText(text: "login_email".localized)
                .foregroundStyle(Color.secondary2)
            SMTextField(placeholder: "login_email_placeholder".localized, text: $email)
                .frame(height: 44)
                .padding(.bottom, 20)
       
            SMText(text: "login_password".localized)
                .foregroundStyle(Color.secondary2)
            SMSecureTextField(placeholder: "login_password_placeholder".localized, text: $password)
                .frame(height: 44)
        }
    }
    
    @ViewBuilder private func vwBottom() -> some View {
        
        HStack {
            Rectangle()
                .frame(height: 0.9)
                .foregroundStyle(Color.secondary4)
            
            SMText(text: "o")
                .foregroundStyle(Color.secondary3)
                .padding(.horizontal, 10)
            
            Rectangle()
                .frame(height: 0.9)
                .foregroundStyle(Color.secondary4)
        }
        
        SMAppleCustomButton(action: {
            firebaseManager.performAppleSignIn()
        })
        
        HStack {
            SMText(text: "login_no_account".localized)
            Button(action: {
                pushRegisterView = true
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
            await viewModel.login(email: email, password: password)
        }
    }
}

#Preview {
    LoginView(firebaseManager: FirebaseManager())
}
