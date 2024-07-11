//
//  NewSubscriptionRow.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 6/7/24.
//

import SwiftUI

struct NewSubscriptionRow: View {
    
    let subscription: SubscriptionSelectorModel
    
    var body: some View {
        VStack {
            HStack {
                Image(subscription.image)
                    .resizable()
                    .frame(width: 35, height: 35)
                    .padding(.trailing, 5)
                SMText(text: subscription.name, fontType: .medium, size: .medium)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 18, height: 18)
                    .padding(.horizontal, 10)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.additionalPurple, Color.additionalBlue],
                            startPoint: .topLeading,
                            endPoint: .trailing)
                    )
            }
            .padding(15)
        }
        .background(Color.primary6)
        .clipShape(.rect(cornerRadius: 20))
    }
}

#Preview {
    NewSubscriptionRow(subscription: SubscriptionsFactory.shared.getSubscriptions().first!)
}
