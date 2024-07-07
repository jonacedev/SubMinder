//
//  NewSubscriptionFormvIEW.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 6/7/24.
//

import SwiftUI

struct NewSubscriptionFormView: View {
    
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: NewSubscriptionFormViewModel
    
    
    // MARK: - Subscription name
    @State var name: String = ""
    
    // MARK: - Subscription price
    @State var pricePlaceholder: String = "0,00"
    @State var price: String = ""
    
    // MARK: - Subscription payment date
    @State var showDatePicker = false
    @State var paymentDate: Date = Date()
    
    // MARK: - Subscription type
    let typeOptions = ["Mensual", "Trimestral", "Semanal", "Prueba"]
    @State var typeDropdownIndex = 0
    
    // MARK: - Subscription divisa
    let divisaOptions = ["EUR", "USD"]
    @State var divisaDropdownIndex = 0
    
    var selectedSubscription: SubscriptionModel
    
    init(selectedSubscription: SubscriptionModel, firebaseManager: FirebaseManager) {
        self.selectedSubscription = selectedSubscription
        self._viewModel = StateObject(wrappedValue: NewSubscriptionFormViewModel(firebaseManager: firebaseManager))
    }
    
    var body: some View {
        ZStack {
            
            Color.primary6
                .ignoresSafeArea(edges: .top)
            
            VStack {
                
                vwHeader()
                
                VStack(spacing: 0) {
                    vwSubHeader()
                    vwForm()
                        .frame(maxHeight: .infinity)
                        .background(Color.white)
                        .clipShape(.rect(topLeadingRadius: 24, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 24))
                }
                .ignoresSafeArea(.keyboard)
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
        .onAppear {
            let isOtherType = selectedSubscription.name.contains("Other")
            self.name = isOtherType ? "" : selectedSubscription.name
        }
    }
    
    @ViewBuilder private func vwHeader() -> some View {
        VStack {
            SMText(text: selectedSubscription.name, fontType: .medium, size: .mediumLarge)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .overlay(alignment: .leading, content: {
            Button(action: {
                dismiss()
            }, label: {
                Image(systemName: "xmark")
                    .resizable()
                    .frame(width: 18, height: 18)
                    .foregroundStyle(.white)
                    .padding(.leading, 20)
            })
            
        })
        .background(
            LinearGradient(colors: [Color.additionalPurple,
                                    Color.additionalBlue],
                           startPoint: .topLeading,
                           endPoint: .topTrailing)
            .ignoresSafeArea(edges: .top)
        )
        .foregroundStyle(Color.white)
    }
    
    @ViewBuilder private func vwSubHeader() -> some View {
        VStack {
            Image(selectedSubscription.image)
                .resizable()
                .frame(width: 50, height: 50)
                .padding(.bottom, 15)
            
            TextField(pricePlaceholder, text: $price)
                .font(.title)
                .multilineTextAlignment(.center)
                .keyboardType(.decimalPad)
                .frame(width: 150)
        }
        .padding(.top, 50)
        .padding(.bottom, 40)
        .frame(maxWidth: .infinity)
        .background(Color.primary6)
    }
    
    @ViewBuilder private func vwForm() -> some View {
        VStack(spacing: 15) {
            HStack {
                SMText(text: "Nombre", fontType: .regular, size: .medium)
                TextField("Añade un nombre", text: $name)
            }
            
            Divider()
            
            HStack {
                SMText(text: "Fecha de pago", fontType: .regular, size: .medium)
                Spacer()
                Text("\(paymentDate.formatted(date: .abbreviated, time: .omitted))")
                    .onTapGesture {
                        showDatePicker = true
                    }
                    .sheet(isPresented: $showDatePicker, content: {
                        WheelDatePickerView(title: "Fecha de pago", paymentDate: $paymentDate, action: {
                            showDatePicker = false
                        })
                        .presentationDetents([.height(330)])
                    })
                  
            }
            
            Divider()
            
            HStack {
                SMText(text: "Tipo", fontType: .regular, size: .medium)
                Spacer()
                SMDropDownMenu(options: typeOptions, selectedOptionIndex: $typeDropdownIndex)
            }
            .zIndex(2)
            
            Divider()
            
            HStack {
                SMText(text: "Divisa", fontType: .regular, size: .medium)
                Spacer()
                SMDropDownMenu(options: divisaOptions, selectedOptionIndex: $divisaDropdownIndex, menuWidth: 120)
            }
            .zIndex(1)
            
            SMMainButton(title: "Añadir", action: {
                let newSubscription = NewSubscriptionModel(name: self.name, image: self.selectedSubscription.image, price: price.toDouble() ?? 0, paymentDate: paymentDate.toString(), type: typeOptions[typeDropdownIndex], divisa: divisaOptions[divisaDropdownIndex])
            })
            .opacity(isValidForm() ? 1 : 0.4)
            .disabled(!isValidForm())
            .padding(.top, 20)
        }
        .padding(.bottom, 120)
        .padding(.horizontal, 20)
        .multilineTextAlignment(.trailing)
    }
    
    func isValidForm() -> Bool {
        !name.isEmpty && price.toDouble() != nil
    }
}

#Preview {
    NewSubscriptionFormView(selectedSubscription: SubscriptionsFactory.shared.getDefaultSubscription(), firebaseManager: FirebaseManager())
}
