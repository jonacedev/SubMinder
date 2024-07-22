//
//  AddSubscriptionView.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 5/7/24.
//

import SwiftUI

struct NewSubscriptionView: View {
    
    @EnvironmentObject var modalState: AddModalState
    @StateObject var viewModel: NewSubscriptionViewModel
    @State var searchText = ""
  
    private let subscriptionsList: [SubscriptionSelectorModel] = SubscriptionsFactory.shared.getSubscriptions()
    private let firebaseManager: FirebaseManager
    
    init(firebaseManager: FirebaseManager) {
        self.firebaseManager = firebaseManager
        self._viewModel = StateObject(wrappedValue: NewSubscriptionViewModel(firebaseManager: firebaseManager))
        setNavigationBarStyle()
    }
    
    var body: some View {
        BaseView(content: content, viewModel: viewModel)
            .ignoresSafeArea(.keyboard)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Añadir gastos")
            .toolbar{
                ToolbarItem(placement: .topBarLeading, content: {
                    Button(action: {
                        modalState.showFirstModal = false
                    }, label: {
                        Image(systemName: "xmark")
                            .tint(Color.secondary2)
                            
                    })
                })
            }
    }
    
    @ViewBuilder private func content() -> some View {
        VStack {
            SMSearchBar(text: $searchText, placeholder: "Buscar")
                .keyboardType(.alphabet)
                .autocorrectionDisabled()
                .padding(.horizontal, 15)
                .padding(.vertical, 5)
            vwList()
            vwBottom()
        }
        .sheet(isPresented: $modalState.showSecondModal, content: {
            if let selectedSubscription = viewModel.selectedSubscription {
                NavigationStack {
                    NewSubscriptionFormView(selectedSubscription: selectedSubscription, firebaseManager: firebaseManager)
                        .environmentObject(modalState)
                }
            }
        })
    }
    
    @ViewBuilder private func vwList() -> some View {
        List(filteredProducts()) { subscription in
            NewSubscriptionRow(subscription: subscription)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 7, leading: 15, bottom: 7, trailing: 15))
                .onTapGesture {
                    viewModel.tapSubscription(subscription: subscription, success: {
                        modalState.showSecondModal = true
                    })
                }
        }
        .listStyle(.plain)
        .scrollDismissesKeyboard(.interactively)
    }
    
    @ViewBuilder private func vwBottom() -> some View {
        VStack {
            SMMainButton(title: "Otra suscripción", action: {
                viewModel.tapOtherSubscription {
                    modalState.showSecondModal = true
                }
            })
            .padding(.top, 10)
            .padding(.horizontal, 15)
        }
        .padding(.bottom, 10)
        .background(.white)
    }
    
    func setNavigationBarStyle() {
        UINavigationBar.appearance().largeTitleTextAttributes = [ .font: UIFont(name: "Roboto-Bold", size: 28) ?? .systemFont(ofSize: 26),.foregroundColor: UIColor(Color.secondary2)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.secondary2)]
    }
    
    func filteredProducts() -> [SubscriptionSelectorModel] {
        searchText.isEmpty ? subscriptionsList : subscriptionsList.filter { ($0.name).localizedCaseInsensitiveContains(searchText) }
        
    }
}

#Preview {
    NewSubscriptionView(firebaseManager: FirebaseManager())
        .environmentObject(AddModalState())
}
