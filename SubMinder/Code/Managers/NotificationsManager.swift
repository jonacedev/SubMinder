//
//  NotificationsManager.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 16/7/24.
//

import Foundation
import UserNotifications

class NotificationsManager {
    
    static let shared = NotificationsManager()
    
    private init() { }
    
    func requestAuthorization(granted: @escaping () -> Void, denied: @escaping() -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized: granted()
            case .notDetermined: UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { authorized, error in
                if authorized {
                    DispatchQueue.main.async {
                        granted()
                    }
                }
            }
            case .denied: denied()
            default: denied()
            }
        }
    }
    
    func configNotification(at date: Date?, withTitle title: String, andBody body: String, identifier: String) {
       
        guard let date = date, let triggerDate = Calendar.current.date(byAdding: .day, value: -3, to: date) else {
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        
        let triggerDateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: triggerDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
    
    func removeNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    func removeNotification(withIdentifier identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [identifier])
    }
    
    func updateNotification(forSubscription subscription: SubscriptionModelDto) {
        removeNotification(withIdentifier: subscription.id)
        
        let newIdentifier = subscription.id
        configNotification(at: subscription.paymentDate.toDate(), withTitle: "Recordatorio", andBody: "Tu suscripción a \(subscription.name) va a renovarse en 3 días!", identifier: newIdentifier)
    }
}
