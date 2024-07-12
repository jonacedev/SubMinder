//
//  String+Utils.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 3/7/24.
//

import Foundation

extension String {
    
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    var removeWhitespaces: String {
        return replacingOccurrences(of: " ", with: "")
    }
    
    func toDouble() -> Double? {
        return Double(replacingOccurrences(of: "€", with: "")
            .replacingOccurrences(of: "$", with: "")
            .replacingOccurrences(of: "£", with: "")
            .replacingOccurrences(of: ".", with: "")
            .removeWhitespaces
            .replacingOccurrences(of: ",", with: "."))
    }
    
    static func convertDoubleToString(_ value: Double?, minFractionDigits: Int = 2, maxFractionDigits: Int = 2, stringIfNil: String? = nil) -> String {
        if let num = value {
            return NSNumber(value: num).toString(minFractionDigits: minFractionDigits, maxFractionDigits: maxFractionDigits)
        }
        return stringIfNil ?? ""
    }
    
    func toDate(with format: String = "dd-MM-yyyy", localeIdentifier: String = "es_ES") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: localeIdentifier)
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
    
    func getCurrency() -> String {
        switch self {
            case "EUR": // Euro
                return "€"
            case "USD": // Dolar
                return "$"
            case "SEK": // Corona sueca
                return "kr"
            case "CHF": // Franco suizo
                return "Fr"
            case "GBP": // Libra
                return "£"
            case "JPY": // Yen Japonés
                return "¥"
            case "PEN": // Sol Peruano
                return "S/"
            case "CLP": // Peso chileno
                return "$"
        default:
            return "€"
        }
    }
}
