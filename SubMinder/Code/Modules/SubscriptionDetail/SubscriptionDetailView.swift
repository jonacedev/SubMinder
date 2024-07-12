//
//  SubscriptionDetailView.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 11/7/24.
//

import SwiftUI

struct SubscriptionDetailView: View {
    
    @StateObject var viewModel: SubscriptionDetailViewModel
    
    @Binding var needToUpdate: Bool
    @Environment(\.dismiss) var dismiss
    
    // MARK: - Gradient
    @State var start = UnitPoint(x: 0, y: 0)
    @State var end = UnitPoint(x: 0, y: 2)
    let colors = [Color.additionalBlue, Color.additionalPurple, Color.additionalPink]
    
    // MARK: - Logo animation
    @State var logoAnimation = true
    
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
    
    init(firebaseManager: FirebaseManager, subscription: SubscriptionModelDto, needToUpdate: Binding<Bool>) {
        self._needToUpdate = needToUpdate
        self._viewModel = StateObject(wrappedValue: SubscriptionDetailViewModel(firebaseManager: firebaseManager, subscription: subscription))
    }
    
    var body: some View {
        BaseView(content: content, viewModel: viewModel)
    }
    
    @ViewBuilder private func content() -> some View {
        GeometryReader { _ in
            ZStack {
                LinearGradient(gradient: Gradient(colors: colors), startPoint: start, endPoint: end)
                    .animation(Animation.easeInOut(duration: 3).repeatForever(), value: start)
                    .onAppear {
                        start = UnitPoint(x: 1, y: -1)
                        end = UnitPoint(x: 0, y: 1)
                    }
                    .ignoresSafeArea()
                
                VStack {
                    vwHeader()
                        .padding(.top, 60)
                        .padding(.bottom, 10)
                    vwForm()
                        .background(Color.white)
                        .clipShape(.rect(topLeadingRadius: 24,
                                         bottomLeadingRadius: 0,
                                         bottomTrailingRadius: 0,
                                         topTrailingRadius: 24)
                        )
                }
                .ignoresSafeArea(edges: .bottom)
            }
            .overlay(alignment: .topTrailing, content: {
                vwTrashOverlay()
            })
        }
        .onAppear {
            configSubscription()
        }
    }
    
    @ViewBuilder private func vwHeader() -> some View {
        VStack {
            
            Image(viewModel.subscription?.image ?? "")
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .padding(.bottom, 10)
                .rotation3DEffect(logoAnimation ? Angle(degrees: 45) : .zero,
                              axis: (x: 1, y: 0, z: 0)
                )
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation {
                            logoAnimation.toggle()
                        }
                    }
                }
        
            SMText(text: viewModel.subscription?.name ?? "", fontType: .medium, size: .extraLarge)
                .foregroundStyle(.white)
                .lineLimit(1)
                .padding(.horizontal, 50)
                .padding(.bottom, 10)
            
            HStack {
                Spacer()
                TextField("", 
                          text: $price,
                          prompt:
                            Text(pricePlaceholder).foregroundStyle(Color.white.opacity(0.3))
                )
                .fixedSize(horizontal: true, vertical: false)
                .font(.custom(FontType.regular.rawValue, size: TextSize.title.rawValue))
                .multilineTextAlignment(.center)
                .keyboardType(.decimalPad)
                .tint(Color.white)
                .foregroundStyle(Color.white)
                .onChange(of: price) { newValue in
                      if newValue.count > 8 {
                          price = String(newValue.prefix(8))
                      }
                 }
                
                SMText(text: divisaOptions[divisaDropdownIndex].getCurrency(), fontType: .medium, size: .title2)
                    .foregroundStyle(Color.white)
                Spacer()
            }
           
        }
    }
    
    @ViewBuilder private func vwForm() -> some View {
        VStack(spacing: 15) {
            HStack {
                SMText(text: "Nombre", fontType: .regular, size: .medium)
                    .foregroundStyle(Color.secondary2)
                TextField("Añade un nombre", text: $name)
                    .keyboardType(.alphabet)
                    .autocorrectionDisabled()
                    .tint(Color.additionalBlue)
                    .onChange(of: name) { newValue in
                          if newValue.count > 8 {
                              name = String(newValue.prefix(13))
                          }
                     }
                   
            }
            .padding(.top, 40)
            
            Divider()
            
            HStack {
                SMText(text: "Fecha de pago", fontType: .regular, size: .medium)
                    .foregroundStyle(Color.secondary2)
                Spacer()
                Text("\(paymentDate.formatted(date: .abbreviated, time: .omitted))")
                    .foregroundStyle(Color.secondary2)
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
                    .foregroundStyle(Color.secondary2)
                Spacer()
                SMDropDownMenu(options: typeOptions, selectedOptionIndex: $typeDropdownIndex, selectedAction: {
                    let subscriptionType = SubscriptionType(type: typeOptions[typeDropdownIndex])
                    if subscriptionType == .freeTrial {
                        self.price = "0,00"
                    } else if price.toDouble() == 0 {
                        self.price = ""
                    }
                })
            }
            .zIndex(2)
            
            Divider()
            
            HStack {
                SMText(text: "Divisa", fontType: .regular, size: .medium)
                    .foregroundStyle(Color.secondary2)
                Spacer()
                SMDropDownMenu(options: divisaOptions, selectedOptionIndex: $divisaDropdownIndex, selectedAction: { }, menuWidth: 120)
            }
            .zIndex(1)
            
            SMMainButton(title: "Continuar", action: {
                updateSubscription()
            })
            .opacity(isValidForm() ? 1 : 0.4)
            .disabled(!isValidForm())
            .padding(.top, 20)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .multilineTextAlignment(.trailing)
    }
    
    @ViewBuilder private func vwTrashOverlay() -> some View {
        Button(action: {
            if let subscriptionId = viewModel.subscription?.id {
                Task {
                    await viewModel.removeSubscription(subscriptionId: subscriptionId)
                    dismiss()
                }
            }
        }, label: {
            Image(systemName: "trash")
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundColor(.white)
                .padding(.top, 30)
                .padding(.horizontal, 20)
        })
    }
    
    func configSubscription() {
        price = String.convertDoubleToString(viewModel.subscription?.price)
        name = viewModel.subscription?.name ?? ""
        paymentDate = viewModel.subscription?.paymentDate.toDate() ?? Date()
        typeDropdownIndex = typeOptions.firstIndex(where: { $0.lowercased().contains(viewModel.subscription?.type.rawValue.lowercased() ?? "")}) ?? 0
        divisaDropdownIndex = divisaOptions.firstIndex(where: { $0.lowercased().contains(viewModel.subscription?.divisa.lowercased() ?? "")}) ?? 0
    }
    
    func updateSubscription() {
        if let subscriptionId = viewModel.subscription?.id, let image = viewModel.subscription?.image, let price = price.toDouble() {
            let updatedSubscription = SubscriptionModelDto(id: subscriptionId, name: name, image: image, price: price, paymentDate: paymentDate.toString(), type: SubscriptionType(type: typeOptions[typeDropdownIndex]), divisa: divisaOptions[divisaDropdownIndex])
            
            Task {
                await viewModel.updateSubscriptionWithData(updatedModel: updatedSubscription)
                needToUpdate = true
                dismiss()
            }
        }
    }
    
    func isValidForm() -> Bool {
        !name.isEmpty && price.toDouble() != nil
    }
}

#Preview {
    SubscriptionDetailView(firebaseManager: FirebaseManager(), subscription: SubscriptionModelDto(name: "Netflix", image: "youtube", price: 9.99, paymentDate: "15-07-2024", type: .monthly, divisa: "EUR"), needToUpdate: .constant(false))
}
