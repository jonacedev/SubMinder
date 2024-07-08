//
//  AddSubscriptionView.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 5/7/24.
//

import SwiftUI

struct SubscriptionSelectionView: View {
    
    @EnvironmentObject var modalState: ModalState
    @StateObject var viewModel: SubscriptionSelectionViewModel
    
    private let subscriptionsList: [SubscriptionSelectorModel] = SubscriptionsFactory.shared.getSubscriptions()
    private let firebaseManager: FirebaseManager
    
    init(firebaseManager: FirebaseManager) {
        self.firebaseManager = firebaseManager
        self._viewModel = StateObject(wrappedValue: SubscriptionSelectionViewModel(firebaseManager: firebaseManager))
    }
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color.additionalPurple,
                                    Color.additionalBlue],
                           startPoint: .topLeading,
                           endPoint: .topTrailing)
            .ignoresSafeArea(edges: .top)
            
            VStack {
                vwHeader()
                    .padding(.bottom, 14)
                
                VStack {
                    vwList()
                }
                .background(Color.white)
                .overlay(alignment: .bottom, content: {
                    vwBottom()
                })
            }
            .sheet(isPresented: $modalState.showSecondModal, content: {
                if let selectedSubscription = viewModel.selectedSubscription {
                    NewSubscriptionFormView(selectedSubscription: selectedSubscription, firebaseManager: firebaseManager)
                        .environmentObject(modalState)
                }
            })
            .padding(.top, 10)
        }
    }
    
    @ViewBuilder private func vwHeader() -> some View {
        VStack {
            SMText(text: "Añadir gastos", fontType: .medium, size: .mediumLarge)
        }
        .frame(maxWidth: .infinity)
        .overlay(alignment: .leading, content: {
            Button(action: {
                modalState.showFirstModal = false
            }, label: {
                Image(systemName: "xmark")
                    .resizable()
                    .frame(width: 18, height: 18)
                    .foregroundStyle(.white)
                    .padding(.leading, 20)
            })
            
        })
        .foregroundStyle(Color.white)
    }
    
    @ViewBuilder private func vwList() -> some View {
        List(subscriptionsList) { subscription in
            SubscriptionSelectionRow(subscription: subscription)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 7, leading: 15, bottom: 7, trailing: 15))
                .onTapGesture {
                    viewModel.tapSubscription(subscription: subscription, success: {
                        modalState.showSecondModal = true
                    })
                }
        }
        .listStyle(.plain)
    }
    
    @ViewBuilder private func vwBottom() -> some View {
        VStack {
            SMMainButton(title: "Otra suscripción", action: {
                viewModel.tapOtherSubscription {
                    modalState.showSecondModal = true
                }
            })
            .padding(.top, 10)
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 10)
        .background(.white)
    }
}

#Preview {
    SubscriptionSelectionView(firebaseManager: FirebaseManager())
        .environmentObject(ModalState())
}
