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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        LocationManager.shared.addDelegate(self)
        
        if let _ = launchOptions?[.location] {
            LocationManager.shared.startUpdateLocation()
        }
        
        self.initiateUserNotification()
        
        self.registerBGTasks()
        
        // FIXME: to test
        self.checkData()
        //self.makeTempAppSetting()
        
        // determine root view controller
        self.determineRootVC()
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        self.scheduleBGTasks()
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
            self.window?.rootViewController = CustomizedNavigationController(rootViewController: mainVC)
            
        } else {
            let initialVC = InitialViewController()
            self.window?.rootViewController = initialVC
            
//            let companyLocationVC = CompanyLocationViewController()
//            self.window?.rootViewController = CustomizedNavigationController(rootViewController: companyLocationVC)
            
//            let staggeredWorkTypeVC = StaggeredWorkTypeViewController()
//            let normalWorkTypeVC = NormalWorkTypeViewController()
//            let tabBarVC = CustomizedTabBarController()
//            tabBarVC.viewControllers = [staggeredWorkTypeVC, normalWorkTypeVC]
//            self.window?.rootViewController = tabBarVC
            
//            let mainVC = MainViewController()
//            let mainNaviVC = CustomizedNavigationController(rootViewController: mainVC)
//            self.window?.rootViewController = mainNaviVC
            
//            let dayOffVC = DayOffViewController()
//            self.window?.rootViewController = dayOffVC
        }
        
        self.window?.makeKeyAndVisible()
    }
    
    // MARK: Initiate UserNotification
    func initiateUserNotification() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if !granted {
                print("Something wrong for using Notification")
            }
        }
    }
    
    // FIXME: To check data saved temporarily
    func checkData() {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let enterData = UserDefaults.standard.value(forKey: "enter_data") as? [String:Any] {
            for (key, value) in enterData {
                if let doubleValue = value as? Double {
                    print(key + ": \(doubleValue)")
                }
                
                if let dateValue = value as? Date {
                    print(key + ": \(dateFormatter.string(from: dateValue))")
                }
            }
            
        } else {
            print("There is no enter data yet.")
        }
        
        if let enterData = UserDefaults.standard.value(forKey: "exit_data") as? [String:Any] {
            for (key, value) in enterData {
                if let doubleValue = value as? Double {
                    print(key + ": \(doubleValue)")
                }
                
                if let dateValue = value as? Date {
                    print(key + ": \(dateFormatter.string(from: dateValue))")
                }
            }
            
        } else {
            print("There is no exit data yet.")
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

// MARK: - Extension for Background Task
extension AppDelegate {
    func registerBGTasks() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "updateCompanyRegion", using: nil) { (task) in
            self.handleAppRefresh(task: task as! BGAppRefreshTask)
        }
        
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "cleanUpData", using: nil) { (task) in
            self.handleAppProcessing(task: task as! BGProcessingTask)
        }
    }
    
    func scheduleBGTasks() {
        self.scheduleAppRefresh()
        self.scheduleAppProcessing()
    }
    
    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "updateCompanyRegion")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 1 * 60)
        
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule app refresh")
        }
    }
    
    func scheduleAppProcessing() {
        let request = BGProcessingTaskRequest(identifier: "cleanUpData")
        request.requiresExternalPower = true
        request.requiresNetworkConnectivity = false
        
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule app processing")
        }
    }
    
    func handleAppRefresh(task: BGAppRefreshTask) {
        self.scheduleAppRefresh()
        
        task.setTaskCompleted(success: true)
    }
    
    func handleAppProcessing(task: BGProcessingTask) {
        task.setTaskCompleted(success: true)
    }
}

// MARK: - Extension for LocationManagerDelegate
extension AppDelegate: LocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if let circularRegion = region as? CLCircularRegion {
            let regionCenter = circularRegion.center
            var enterData: [String:Any] = [:]
            enterData.updateValue(regionCenter.latitude, forKey: "enter_latitude")
            enterData.updateValue(regionCenter.longitude, forKey: "enter_longitude")
            enterData.updateValue(Date(), forKey: "enter_date")
            
            UserDefaults.standard.setValue(enterData, forKey: "enter_data")
            
            // FIXME: Temp code
            /*
            let content = UNMutableNotificationContent()
            content.title = "Enter!!"
            content.badge = 1
            content.body = "latitud: \(regionCenter.latitude), longitude: \(regionCenter.longitude)"
            content.sound = UNNotificationSound.default
            
            let center = UNUserNotificationCenter.current()
            let request = UNNotificationRequest(identifier: "enter_notification", content: content, trigger: nil)
            center.add(request) { (error) in
                if let error = error {
                    print("Something wrong(\(error.localizedDescription)) happens for requesting local push")
                }
            }
            */
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if let circularRegion = region as? CLCircularRegion {
            let regionCenter = circularRegion.center
            var exitData: [String:Any] = [:]
            exitData.updateValue(regionCenter.latitude, forKey: "exit_latitude")
            exitData.updateValue(regionCenter.longitude, forKey: "exit_longitude")
            exitData.updateValue(Date(), forKey: "exit_date")
            
            UserDefaults.standard.setValue(exitData, forKey: "exit_data")
            
            // FIXME: Temp code
            /*
            let content = UNMutableNotificationContent()
            content.title = "Exit!!"
            content.badge = 7
            content.body = "latitud: \(regionCenter.latitude), longitude: \(regionCenter.longitude)"
            content.sound = UNNotificationSound.default
            
            let center = UNUserNotificationCenter.current()
            let request = UNNotificationRequest(identifier: "exit_notification", content: content, trigger: nil)
            center.add(request) { (error) in
                if let error = error {
                    print("Something wrong(\(error.localizedDescription)) happens for requesting local push")
                }
            }
             */
        }
    }
}

// FIXME: - Temp Extension
extension AppDelegate {
    func makeTempAppSetting() {
        // FIXME: Temp, WorkType - Staggered
//        SupportingMethods.shared.setAppSetting(with: WorkType.staggered.rawValue, for: .workType)
//        SupportingMethods.shared.setAppSetting(with: 12.5, for: .lunchTimeValue)
//        SupportingMethods.shared.setAppSetting(with: ["earliestTime":8.0, "latestTime":11.0], for: .morningStartingworkTimeValueRange)
//        SupportingMethods.shared.setAppSetting(with: ["earliestTime":11.0, "latestTime":15.0], for: .afternoonStartingworkTimeValueRange)
        
        // FIXME: Temp, WorkType - Noraml
//        SupportingMethods.shared.setAppSetting(with: WorkType.normal.rawValue, for: .workType)
//        SupportingMethods.shared.setAppSetting(with: 9.5, for: .morningStartingWorkTimeValue)
//        SupportingMethods.shared.setAppSetting(with: 12.5, for: .lunchTimeValue)
        
        // FIXME: Temp, common
//        SupportingMethods.shared.setAppSetting(with: {
//            let dateComonents = DateComponents(year: 2019, month: 10, day: 1)
//            var calendar = Calendar.current
//            calendar.timeZone = .current
//            
//            return calendar.date(from: dateComonents)!
//        }(), for: .joiningDate)
//        SupportingMethods.shared.setAppSetting(with: true, for: .isIgnoredLunchTimeForHalfVacation)
//        //SupportingMethods.shared.setAppSetting(with: "fiscalYear", for: .vacationType)
//        SupportingMethods.shared.setAppSetting(with: "joiningDay", for: .annualVacationType)
//        SupportingMethods.shared.setAppSetting(with: [1,7], for: .holidays)
//        SupportingMethods.shared.setAppSetting(with: 15, for: .numberOfTotalVacations)
    }
}
