//
//  Date+Utils.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 7/7/24.
//

import Foundation

extension Date {
   
   // MARK: - Public methods
   
   /// Tranforms a `Date` to a `String` with a given date format.
   /// - Returns: A `String` representing the same date with a given format.
   
   func toString(format: String = "dd-MM-yyyy", localeIdentifier: String = "es_ES") -> String {
       let dateFormatter = DateFormatter()
       dateFormatter.locale = Locale(identifier: localeIdentifier)
       dateFormatter.dateFormat = format
       return dateFormatter.string(from: self)
   }
}
