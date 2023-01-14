//
//  AppDelegate.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2021/11/17.
//

import UIKit
import BackgroundTasks
import CoreLocation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    //var bgTaskId: UIBackgroundTaskIdentifier = .invalid

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.initiateUserNotification()
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
//    func applicationWillEnterForeground(_ application: UIApplication) {
//        print("applicationWillEnterForeground")
//
//        if self.bgTaskId != .invalid {
//            application.endBackgroundTask(self.bgTaskId)
//            self.bgTaskId = .invalid
//        }
//
//        UNUserNotificationCenter.current().getNotificationSettings { setting in
//            if setting.authorizationStatus != .authorized {
//                DispatchQueue.main.async {
//                    SupportingMethods.shared.turnOffAndRemoveLocalPush()
//                }
//            }
//        }
//    }
//
//    func applicationDidEnterBackground(_ application: UIApplication) {
//        print("applicationDidEnterBackground")
//
//        self.bgTaskId = application.beginBackgroundTask(expirationHandler: {
//            print("This app is going to be suspended soon")
//
//            if self.bgTaskId != .invalid {
//                application.endBackgroundTask(self.bgTaskId)
//                self.bgTaskId = .invalid
//            }
//        })
//    }
}

// MARK: - Extension for Methods added
extension AppDelegate {
    // MARK: Initiate UserNotification
    func initiateUserNotification() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                print("Push authorization is granted")
                
            } else {
                print("Push authorization is denied")
                
                SupportingMethods.shared.turnOffAndRemoveLocalPush()
                
                if let error = error {
                    print("Error for push notification: \(error.localizedDescription)")
                }
            }
        }
    }
}

// MARK: - Extension for Remote Notification
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.list, .banner, .badge, .sound])
    }
}
