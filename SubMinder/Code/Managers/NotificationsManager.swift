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
    
    var notifications : [UNNotificationRequest] = []
    var authorizationStatus : UNAuthorizationStatus?
    
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
}
