//
//  NewSubscriptionFormvIEW.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 6/7/24.
//

import SwiftUI

struct NewSubscriptionFormView: View {
    
    @StateObject var viewModel: NewSubscriptionFormViewModel
    var selectedSubscription: SubscriptionModel
    
    init(selectedSubscription: SubscriptionModel) {
        self.selectedSubscription = selectedSubscription
        self._viewModel = StateObject(wrappedValue: NewSubscriptionFormViewModel())
    }
    
    var body: some View {
        VStack {
            Text(selectedSubscription.name)
        }
    }
}

#Preview {
    NewSubscriptionFormView(selectedSubscription: SubscriptionModel(name: "default", image: "netflix"))
}
