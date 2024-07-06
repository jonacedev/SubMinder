//
//  AddSubscriptionView.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 5/7/24.
//

import SwiftUI

struct SubscriptionSelectionView: View {
    
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: SubscriptionSelectionViewModel
    @State var showSubForm: Bool = false
    
    private let subscriptionsList: [SubscriptionModel] = SubscriptionsFactory.shared.getSubscriptions()
    init(firebaseManager: FirebaseManager) {
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
            .sheet(isPresented: $showSubForm, content: {
                if let selectedSubscription = viewModel.selectedSubscription {
                    NewSubscriptionFormView(selectedSubscription: selectedSubscription)
                   
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
                dismiss()
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
                        showSubForm = true
                    })
                }
        }
        .listStyle(.plain)
    }
    
    @ViewBuilder private func vwBottom() -> some View {
        VStack {
            SMMainButton(title: "Otra suscripción", action: {
                viewModel.tapOtherSubscription {
                    showSubForm = true
                }
            })
            .padding(.top, 10)
            .padding(.horizontal, 20)
        }
        .background(.white)
    }
}

#Preview {
    SubscriptionSelectionView(firebaseManager: FirebaseManager())
}
