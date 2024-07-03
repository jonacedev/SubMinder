//
//  RegisterView.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 3/7/24.
//

import SwiftUI

struct RegisterView: View {
    
    @StateObject var viewModel = RegisterViewModel(authService: AuthService())
    @Environment(\.dismiss) var dismiss
    
    @State var username: String = ""
    @State var email: String = ""
    @State var password: String = ""
  
    var body: some View {
       
        VStack(spacing: 40) {
            
            CustomText(text: "register_header".localized,
                       fontType: .bold,
                       size: .header)
            .padding(.bottom, 30)
                
            vwFields()
            
            MainButton(title: "register_btn".localized, action: {
                Task {
                    await viewModel.register(email: email, 
                                             password: password,
                                             username: username)
                }
            })
            
            Divider()
            
            vwBottom()
            
        }
        .toolbarRole(.editor)
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder private func vwFields() -> some View {
        
        VStack(alignment: .leading) {
            
            CustomText(text: "register_username".localized)
            MainTextField(placeholder: "register_username_placeholder".localized, text: $username)
                .padding(.bottom, 20)
            
            CustomText(text: "register_email".localized)
            MainTextField(placeholder: "register_email_placeholder".localized, text: $email)
                .padding(.bottom, 20)
       
            CustomText(text: "register_password".localized)
            SecureTextField(placeholder: "register_password_placeholder".localized, text: $password)
        }
    }
    
    @ViewBuilder private func vwBottom() -> some View {
        HStack {
            CustomText(text: "register_have_account".localized)
            
            Button(action: {
                dismiss()
            }, label: {
                CustomText(text: "login_link".localized)
                    .underline()
                    .foregroundStyle(LinearGradient(colors: [Color.additionalPurple, Color.additionalBlue], startPoint: .topLeading, endPoint: .trailing))
            })
        }
    }
}

#Preview {
    RegisterView()
}
