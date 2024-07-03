//
//  LoginView.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 2/7/24.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var rootManager: RootManager
    @StateObject var viewModel = LoginViewModel()
    
    @State var navigateToRegister: Bool = false
    
    @State var email: String = ""
    @State var password: String = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                
                Text("Login")
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("Email")
                    
                    MainTextField(placeholder: "", text: $email)
                    
                    Text("Contraseña")
                    
                    SecureTextField(placeholder: "", text: $password)
                }
                
               
                MainButton(title: "Login", action: {
                    
                })
                
                HStack {
                    Text("¿Ya tienes cuenta?")
                    Button(action: {
                        navigateToRegister = true
                    }, label: {
                        Text("Registrate")
                            .underline()
                            .foregroundStyle(LinearGradient(colors: [Color("secondaryPurple"), Color("secondaryBlue")], startPoint: .topLeading, endPoint: .trailing))
                    })
                }
                .padding(.top, 10)
            }
            .padding(.horizontal, 14)
            .navigationDestination(isPresented: $navigateToRegister, destination: {
                RegisterView()
            })
        }
    }
}

#Preview {
    LoginView()
}
