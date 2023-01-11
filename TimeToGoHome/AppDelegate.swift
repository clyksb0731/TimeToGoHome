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
    var bgTaskId: UIBackgroundTaskIdentifier = .invalid

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.initiateUserNotification()
        
        // determine root view controller
        self.determineRootVC()
        
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("applicationWillEnterForeground")
        
        if self.bgTaskId != .invalid {
            application.endBackgroundTask(self.bgTaskId)
            self.bgTaskId = .invalid
        }
        
        UNUserNotificationCenter.current().getNotificationSettings { setting in
            if setting.authorizationStatus != .authorized {
                DispatchQueue.main.async {
                    SupportingMethods.shared.turnOffAndRemoveLocalPush()
                }
            }
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("applicationDidEnterBackground")
        
        self.bgTaskId = application.beginBackgroundTask(expirationHandler: {
            print("This app is going to be suspended soon")
            
            if self.bgTaskId != .invalid {
                application.endBackgroundTask(self.bgTaskId)
                self.bgTaskId = .invalid
            }
        })
    }
}

// MARK: - Extension for Methods added
extension AppDelegate {
    // MARK: Determine root view controller
    func determineRootVC() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        if !ReferenceValues.initialSetting.isEmpty {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainVC = storyboard.instantiateInitialViewController() as! MainViewController
            self.window?.rootViewController = mainVC
            
        } else {
            let initialVC = InitialViewController()
            self.window?.rootViewController = initialVC
        }
        
        self.window?.makeKeyAndVisible()
    }
    
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
