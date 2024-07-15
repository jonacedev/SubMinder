//
//  RegisterView.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 3/7/24.
//

import SwiftUI

struct RegisterView: View {
    
    @StateObject var viewModel: RegisterViewModel
    @Environment(\.dismiss) var dismiss
    
    @State var username: String = ""
    @State var email: String = ""
    @State var password: String = ""
    
    init(firebaseManager: FirebaseManager) {
        self._viewModel = StateObject(wrappedValue: RegisterViewModel(firebaseManager: firebaseManager))
    }
  
    var body: some View {
        BaseView(content: content, viewModel: viewModel)
    }
    
    @ViewBuilder private func content() -> some View {
        VStack(spacing: 40) {
            
            SMText(text: "register_header".localized,
                       fontType: .bold,
                       size: .header)
            .foregroundStyle(Color.secondary2)
            .padding(.bottom, 30)
                
            vwFields()
            
            SMMainButton(title: "register_btn".localized, action: {
                registerUser()
            })
            
            Rectangle()
                .frame(height: 0.9)
                .foregroundStyle(Color.secondary4)
            
            vwBottom()
            
        }
        .toolbarRole(.editor)
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder private func vwFields() -> some View {
        
        VStack(alignment: .leading) {
            
            SMText(text: "register_username".localized)
            SMTextField(placeholder: "register_username_placeholder".localized, text: $username)
                .padding(.bottom, 20)
            
            SMText(text: "register_email".localized)
            SMTextField(placeholder: "register_email_placeholder".localized, text: $email)
                .padding(.bottom, 20)
       
            SMText(text: "register_password".localized)
            SMSecureTextField(placeholder: "register_password_placeholder".localized, text: $password)
        }
    }
    
    @ViewBuilder private func vwBottom() -> some View {
        HStack {
            SMText(text: "register_have_account".localized)
            
            Button(action: {
                dismiss()
            }, label: {
                SMText(text: "login_link".localized)
                    .underline()
                    .foregroundStyle(LinearGradient(colors: [Color.additionalPurple, Color.additionalBlue], startPoint: .topLeading, endPoint: .trailing))
            })
        }
    }
}

extension RegisterView {
    func registerUser() {
        Task {
            await viewModel.register(email: email,
                                     password: password,
                                     username: username)
        }
    }
}

#Preview {
    RegisterView(firebaseManager: FirebaseManager())
}
