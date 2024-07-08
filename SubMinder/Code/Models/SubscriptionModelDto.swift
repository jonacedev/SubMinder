//
//  SubscriptionModelDto.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 8/7/24.
//

import Foundation

struct SubscriptionModelDto: Identifiable {
    let id = UUID()
    let name: String
    let image: String
    let price: Double
    let paymentDate: String
    let type: String
    let divisa: String
    var daysUntilPayment: Int? = nil
    
    init(model: NewSubscriptionModel) {
        self.name = model.name
        self.image = model.image
        self.price = model.price
        self.paymentDate = model.paymentDate
        self.type = model.type
        self.divisa = model.divisa
    }
    
    mutating func setDaysUntilPayment(_ days: Int) {
        self.daysUntilPayment = days
    }
}
