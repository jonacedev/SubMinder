//
//  SuscriptionModel.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 5/7/24.
//

import Foundation

//enum SuscriptionType: String {
//    case monthly = "Mensual"
//    case quarterly = "Trimestral"
//    case annual = "Anual"
//}
//
//enum Divisa: String {
//    case usd = "USD"
//    case eur = "EUR"
//}

struct NewSubscriptionModel: Codable {
    let id: String
    let name: String
    let image: String
    let price: Double
    let paymentDate: String
    let type: String
    let divisa: String
    
    init(name: String, image: String, price: Double, paymentDate: String, type: String, divisa: String) {
        self.id = UUID().uuidString
        self.name = name
        self.image = image
        self.price = price
        self.paymentDate = paymentDate
        self.type = type
        self.divisa = divisa
    }
}
