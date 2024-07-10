//
//  SubscriptionListRow.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 9/7/24.
//

import SwiftUI

struct SubscriptionListRow: View {
    
    let subscription: SubscriptionModelDto
    
    var body: some View {
        VStack {
            HStack {
                Image(subscription.image)
                    .resizable()
                    .frame(width: 35, height: 35)
                    .padding(.trailing, 5)
                
                VStack(alignment: .leading) {
                    HStack {
                        SMText(text: subscription.name, fontType: .medium, size: .medium)
                            .foregroundStyle(Color.secondary2)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                        SMText(text: subscription.type.rawValue, fontType: .medium, size: .small)
                            .foregroundStyle(Color.primary3)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                    }
                   
                    SMText(text: subscription.paymentDate.toDate()?.formatted(date: .abbreviated, time: .omitted) ?? "", fontType: .medium, size: .smallLarge)
                        .foregroundStyle(Color.secondary3)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                SMText(text: "\(subscription.price) €", fontType: .medium, size: .mediumLarge)
                    .foregroundStyle(Color.secondary2)
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 18)
        }
        .background(Color.primary6)
        .clipShape(.rect(cornerRadius: 20))
    }
}

#Preview {
    SubscriptionListRow(subscription: SubscriptionModelDto(name: "Netflix", image: "netflix", price: 9.99, paymentDate: "15-07-2024", type: .monthly, divisa: "EUR"))
}
