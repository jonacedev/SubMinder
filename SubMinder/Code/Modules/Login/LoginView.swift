//
//  LoginView.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 2/7/24.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var rootManager: RootManager
    @StateObject var viewModel = LoginViewModel(authService: AuthService())
    
    @State var navigateToRegister: Bool = false
    
    @State var email: String = ""
    @State var password: String = ""
    
    var body: some View {
        
        NavigationStack {
            VStack(spacing: 40) {
                CustomText(text: "login_header".localized,
                           fontType: .bold,
                           size: .header)
                .padding(.bottom, 30)
                
                vwFields()
                
                MainButton(title: "login_btn".localized, action: {
                    Task {
                        await viewModel.login(email: email, password: password)
                    }
                })
                
                Divider()
                
                vwBottom()
            }
            .padding(.horizontal, 20)
            .navigationDestination(isPresented: $navigateToRegister, destination: {
                RegisterView()
            })
        }
        .tint(Color("secondaryPurple"))
    }
    
    @ViewBuilder private func vwFields() -> some View {
        
        VStack(alignment: .leading) {
           
            CustomText(text: "login_email".localized)
            MainTextField(placeholder: "login_email_placeholder".localized, text: $email)
                .padding(.bottom, 20)
       
            CustomText(text: "login_password".localized)
            SecureTextField(placeholder: "login_password_placeholder".localized, text: $password)
        }
    }
    
    @ViewBuilder private func vwBottom() -> some View {
        HStack {
            CustomText(text: "login_no_account".localized)
            Button(action: {
                navigateToRegister = true
            }, label: {
                CustomText(text: "register_link".localized)
                    .underline()
                    .foregroundStyle(LinearGradient(colors: [Color("secondaryPurple"), Color("secondaryBlue")], startPoint: .topLeading, endPoint: .trailing))
            })
        }
    }
}

#Preview {
    LoginView()
}
