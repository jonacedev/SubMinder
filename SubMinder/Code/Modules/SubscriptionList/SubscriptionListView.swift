//
//  SubscriptionListView.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 9/7/24.
//

import SwiftUI

struct SubscriptionListView: View {
    
    @StateObject var viewModel: SubscriptionListViewModel
    
    init(firebaseManager: FirebaseManager) {
        self._viewModel = StateObject(wrappedValue: SubscriptionListViewModel(firebaseManager: firebaseManager))
    }
    
    var body: some View {
        BaseView(content: content, viewModel: viewModel)
    }
    
    @ViewBuilder private func content() -> some View {
        Text("")
    }
    
    
}

#Preview {
    SubscriptionListView(firebaseManager: FirebaseManager())
}
