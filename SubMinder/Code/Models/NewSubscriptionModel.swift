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

struct NewSubscriptionModel {
    let id = UUID()
    let name: String
    let image: String
    let price: Double
    let paymentDate: String
    let type: String
    let divisa: String
}
