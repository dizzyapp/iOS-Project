//
//  PushNotificationsInteractor.swift
//  Dizzy
//
//  Created by Menashe, Or on 11/07/2020.
//  Copyright © 2020 Dizzy. All rights reserved.
//

import Foundation
import Firebase
import FirebaseMessaging
import FirebaseInstanceID

protocol PushNotificationsInteractorType {}

class PushNotificationsInteractor: NSObject, PushNotificationsInteractorType {
    
    override init() {
        super.init()
        FirebaseApp.configure()
        registerForPushNotifications()
    }
    
    func registerForPushNotifications() {
        let application = UIApplication.shared
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        } else {
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        
        Messaging.messaging().delegate = self
    }
}

extension PushNotificationsInteractor: MessagingDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print(String(data: deviceToken, encoding: .utf8) ?? "")
        
        InstanceID.instanceID().instanceID { (result, error) in
          if let error = error {
            print("Error fetching remote instance ID: \(error)")
          } else if let result = result {
            print("Remote instance ID token: \(result.token)")
            
          }
        }
    }
}

extension PushNotificationsInteractor: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.sound)
    }
}
