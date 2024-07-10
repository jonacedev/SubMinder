//
//  SubscriptionListView.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 9/7/24.
//

import SwiftUI

struct SubscriptionListView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: SubscriptionListViewModel
    
    init(firebaseManager: FirebaseManager, subscriptions: [SubscriptionModelDto]? = [], listType: ListType) {
        self._viewModel = StateObject(wrappedValue: SubscriptionListViewModel(firebaseManager: firebaseManager, subscriptions: subscriptions, listType: listType))
        setNavigationBarColor()
    }
    
    var body: some View {
        BaseView(content: content, viewModel: viewModel)
            .navigationTitle(viewModel.getTitle())
            .navigationBarTitleDisplayMode(.large)
            .toolbarRole(.editor)
    }
    
    @ViewBuilder private func content() -> some View {
        ScrollView {
            if !viewModel.subscriptions.isEmpty {
                vwList()
            } else {
                SMEmptyView(title: "No se han encontrado resultados")
                    .padding(.horizontal, 20)
                Spacer()
            }
        }
        .refreshable {
            refreshSubscriptions()
        }
    }
    
    @ViewBuilder private func vwList() -> some View {
        ForEach(viewModel.subscriptions) { subscription in
            if #available(iOS 17.0, *) {
                SubscriptionListRow(subscription: subscription)
                    .scrollTransition(.animated.threshold(.visible(0.9))) { content, phase in
                        content
                            .opacity(phase.isIdentity ? 1 : 0.8)
                            .scaleEffect(phase.isIdentity ? 1 : 0.8)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 3)
            } else {
                SubscriptionListRow(subscription: subscription)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 3)
            }
        }
    }
    
    func refreshSubscriptions() {
        Task {
            await viewModel.refreshSubscriptions()
        }
    }
    
    func setNavigationBarColor() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.secondary2)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.secondary2)]
    }
}

#Preview {
    SubscriptionListView(firebaseManager: FirebaseManager(), subscriptions: [SubscriptionModelDto(name: "default", image: "netflix", price: 9.99, paymentDate: "15-07-2024", type: .monthly, divisa: "EUR"), SubscriptionModelDto(name: "default", image: "netflix", price: 9.99, paymentDate: "15-07-2024", type: .monthly, divisa: "EUR"), SubscriptionModelDto(name: "default", image: "netflix", price: 9.99, paymentDate: "15-07-2024", type: .monthly, divisa: "EUR"), SubscriptionModelDto(name: "default", image: "netflix", price: 9.99, paymentDate: "15-07-2024", type: .monthly, divisa: "EUR")], listType: .all)
}
