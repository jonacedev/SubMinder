//
//  NewSubscriptionFormvIEW.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 6/7/24.
//

import SwiftUI

struct NewSubscriptionFormView: View {
    
    @EnvironmentObject var modalState: ModalState
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
    let typeOptions = ["Mensual", "Trimestral", "Anual", "Semanal", "Prueba"]
    @State var typeDropdownIndex = 0
    
    // MARK: - Subscription divisa
    let divisaOptions = ["EUR", "USD"]
    @State var divisaDropdownIndex = 0
    
    var selectedSubscription: SubscriptionSelectorModel
    
    init(selectedSubscription: SubscriptionSelectorModel, firebaseManager: FirebaseManager) {
        self.selectedSubscription = selectedSubscription
        self._viewModel = StateObject(wrappedValue: NewSubscriptionFormViewModel(firebaseManager: firebaseManager))
    }
    
    var body: some View {
        BaseView(content: content, viewModel: viewModel)
    }
    
    @ViewBuilder private func content() -> some View {
        GeometryReader { _ in
            VStack(spacing: 0) {
                
                vwHeader()
                
                VStack(spacing: 0) {
                    vwSubHeader()
                    vwForm()
                        .frame(maxHeight: .infinity)
                        .background(Color.white)
                        .clipShape(.rect(topLeadingRadius: 24, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 24))
                }
                .ignoresSafeArea(edges: .bottom)
                .background(Color.primary6)
            }
            .onAppear {
                let isOtherType = selectedSubscription.name.contains("Other")
                self.name = isOtherType ? "" : selectedSubscription.name
            }
        }
    }
    
    @ViewBuilder private func vwHeader() -> some View {
        VStack {
            ZStack(alignment: .center) {
                HStack {
                    Button(action: {
                        modalState.showSecondModal = false
                    }, label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 18, height: 18)
                            .padding(.leading, 10)
                    })
                   
                    Spacer()
                }
                .padding()

                SMText(text: selectedSubscription.name, fontType: .medium, size: .mediumLarge)
            }
            .foregroundStyle(Color.white)
        }
        .background(
            LinearGradient(colors: [Color.additionalPurple,
                                    Color.additionalBlue],
                           startPoint: .topLeading,
                           endPoint: .topTrailing)
        )
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
    }
    
    @ViewBuilder private func vwForm() -> some View {
        VStack(spacing: 15) {
            HStack {
                SMText(text: "Nombre", fontType: .regular, size: .medium)
                TextField("Añade un nombre", text: $name)
                    .keyboardType(.alphabet)
                    .autocorrectionDisabled()
            }
            .padding(.top, 40)
            
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
                SMDropDownMenu(options: typeOptions, selectedOptionIndex: $typeDropdownIndex, selectedAction: {
                    let subscriptionType = SubscriptionType(type: typeOptions[typeDropdownIndex])
                    if subscriptionType == .freeTrial {
                        self.price = "0,00"
                    }
                })
            }
            .zIndex(2)
            
            Divider()
            
            HStack {
                SMText(text: "Divisa", fontType: .regular, size: .medium)
                Spacer()
                SMDropDownMenu(options: divisaOptions, selectedOptionIndex: $divisaDropdownIndex, selectedAction: { }, menuWidth: 120)
            }
            .zIndex(1)
            
            SMMainButton(title: "Añadir", action: {
                addNewSubscription()
            })
            .opacity(isValidForm() ? 1 : 0.4)
            .disabled(!isValidForm())
            .padding(.top, 20)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .multilineTextAlignment(.trailing)
    }
    
    func addNewSubscription() {
        let newSubscription = NewSubscriptionModel(name: self.name, image: self.selectedSubscription.image, price: price.toDouble() ?? 0, paymentDate: paymentDate.toString(), type: typeOptions[typeDropdownIndex], divisa: divisaOptions[divisaDropdownIndex])
        
        Task {
            await viewModel.addNewSubscription(model: newSubscription)
            modalState.showSecondModal = false
            modalState.showFirstModal = false
        }
    }
    
    func isValidForm() -> Bool {
        !name.isEmpty && price.toDouble() != nil
    }
}

#Preview {
    NewSubscriptionFormView(selectedSubscription: SubscriptionsFactory.shared.getDefaultSubscription(), firebaseManager: FirebaseManager())
        .environmentObject(ModalState())
}
