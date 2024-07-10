//
//  SubscriptionModelDto.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 8/7/24.
//

import Foundation

enum SubscriptionType: String {
    case weekly = "Semanal"
    case monthly = "Mensual"
    case quarterly = "Trimestral"
    case yearly = "Anual"
    case freeTrial = "Prueba"
    
    init(type: String) {
        switch type.lowercased() {
        case "semanal":
            self = .weekly
        case "mensual":
            self = .monthly
        case "trimestral":
            self = .quarterly
        case "anual":
            self = .yearly
        case "prueba":
            self = .freeTrial
        default:
            self = .monthly
        }
    }
}

struct SubscriptionModelDto: Identifiable {
    let id = UUID()
    let name: String
    let image: String
    let price: Double
    let paymentDate: String
    let type: SubscriptionType
    let divisa: String
    var daysUntilPayment: Int? = nil
    
    init(name: String, image: String, price: Double, paymentDate: String, type: SubscriptionType, divisa: String) {
        self.name = name
        self.image = image
        self.price = price
        self.paymentDate = paymentDate
        self.type = type
        self.divisa = divisa
    }
    
    init(model: NewSubscriptionModel) {
        self.name = model.name
        self.image = model.image
        self.price = model.price
        self.paymentDate = model.paymentDate
        self.type = SubscriptionType(type: model.type)
        self.divisa = model.divisa
    }
    
    mutating func setDaysUntilPayment(_ days: Int) {
        self.daysUntilPayment = days
    }
}
