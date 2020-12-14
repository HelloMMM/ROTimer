//
//  AppDelegate.swift
//  ROTimer
//
//  Created by Miles on 2020/12/2.
//

import UIKit
import IQKeyboardManagerSwift
import UserNotifications

var isNotification: Bool = true

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let notificationHandler = NotificationHandler()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared.enable = true
        
        
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge], completionHandler: { (granted, error) in
            if granted {
                print("允許")
            } else {
                print("不允許")
                isNotification = false
                
                if UserDefaults.standard.object(forKey: "isFirst") == nil {
                    
                    NotificationCenter.default.post(name: Notification.Name("ShowAlert"), object: nil)
                }
                
                UserDefaults.standard.setValue("true", forKey: "isFirst")
            }
        })
        
        UNUserNotificationCenter.current().delegate = notificationHandler
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in

            for request in requests {
        
                print("request: \(request)")
            }
        }
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        NotificationCenter.default.post(name: Notification.Name("UpdateUI"), object: nil)
    }
}

class NotificationHandler: NSObject, UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .sound])

    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let categoryIdentifier = response.actionIdentifier
        
        print(categoryIdentifier)
        
        completionHandler()
    }
}
