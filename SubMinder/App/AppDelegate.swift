//
//  AppDelegate.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 3/7/24.
//

import UIKit
import Firebase
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        if !BaseActions.isPreview() {
            FirebaseApp.configure()
        }
        
        UNUserNotificationCenter.current().delegate = self
        return true
    }
}

extension AppDelegate : UNUserNotificationCenterDelegate {
    // To receive notification in foreground state, you have to implement the completion hanlder properly, otherwise the notification will not be presented.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        print("willPresent:")

        completionHandler([.banner, .list, .badge, .sound])
    }

    // Handle user interactions to the notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        print("didReceive:")

        completionHandler()
    }
}
