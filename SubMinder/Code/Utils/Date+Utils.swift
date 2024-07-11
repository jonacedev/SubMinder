//
//  Date+Utils.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 7/7/24.
//

import Foundation

extension Date {
    
    func toString(format: String = "dd-MM-yyyy", localeIdentifier: String = "es_ES") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: localeIdentifier)
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func getDaysIntervalFromNow() -> Int {
        let startOfToday = Calendar.current.startOfDay(for: Date())
        let startOfTargetDay = Calendar.current.startOfDay(for: self)
        return Calendar.current.dateComponents([.day], from: startOfToday, to: startOfTargetDay).day!
    }
    
    var startOfWeek: Date {
        Calendar.current.dateInterval(of: .weekOfYear, for: .now)!.start
    }
    
    var endOfWeek: Date {
        Calendar.current.dateInterval(of: .weekOfYear, for: .now)!.end
    }
    
    var startOfMonth: Date {
        let components = Calendar.current.dateComponents([.year, .month], from: Date())
        return Calendar.current.date(from: components)!
    }
    
    var endOfMonth: Date {
        Calendar.current.date(byAdding: DateComponents(month: 1), to: startOfMonth)!
    }
    
    var startOfYear: Date {
        let components = Calendar.current.dateComponents([.year], from: Date())
        return Calendar.current.date(from: components)!
    }
    
    var endOfYear: Date {
        Calendar.current.date(byAdding: DateComponents(year: 1), to: startOfYear)!
    }
    
    func isDateInCurrentWeek() -> Bool {
        self >= startOfWeek && self < endOfWeek
    }
    
    func isDateInCurrentMonth() -> Bool {
        self >= startOfMonth && self < endOfMonth
    }
    
    func isDateInCurrentYear() -> Bool {
        self >= startOfYear && self < endOfYear
    }
    
    func isWithinNext15Days() -> Bool {
        let now = Calendar.current.startOfDay(for: Date())
        let endDate = Calendar.current.date(byAdding: .day, value: 15, to: now)!
        return self >= now && self <= endDate
    }
    
    func nextExpirationDate(type: SubscriptionType) -> Date? {
        let calendar = Calendar.current
        let expiredDay = calendar.component(.day, from: self)
        var dateComponents = DateComponents()

        switch type {
        case .monthly:
            dateComponents.month = 1
        case .yearly:
            dateComponents.year = 1
        case .weekly:
            return calendar.date(byAdding: .day, value: 7, to: self)
        case .quarterly:
            return calendar.date(byAdding: .month, value: 3, to: self)
        default:
            return nil
        }

        guard let nextDate = calendar.date(byAdding: dateComponents, to: self) else {
            return nil
        }

        let nextDay = calendar.component(.day, from: nextDate)
        if nextDay != expiredDay {
            var correctedComponents = calendar.dateComponents([.year, .month], from: nextDate)
            correctedComponents.day = expiredDay
            return calendar.date(from: correctedComponents)
        }
        return nextDate
    }
}
