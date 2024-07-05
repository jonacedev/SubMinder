//
//  SuscriptionModel.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 5/7/24.
//

import Foundation

enum SuscriptionType: String {
    case monthly = "Mensual"
    case quarterly = "Trimestral"
    case annual = "Anual"
}

struct SuscriptionModel {
    let id: Int
    let name: String
    let image: String
    let price: Double
    let type: SuscriptionType
}
