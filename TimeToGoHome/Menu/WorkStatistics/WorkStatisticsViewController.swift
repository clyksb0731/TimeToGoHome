//
//  WorkStatisticsViewController.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2022/12/04.
//

import UIKit

class WorkStatisticsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setViewFoundation()
        self.initializeObjects()
        self.setDelegates()
        self.setGestures()
        self.setNotificationCenters()
        self.setSubviews()
        self.setLayouts()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    deinit {
            print("----------------------------------- WorkStatisticsViewController disposed -----------------------------------")
    }
}

// MARK: - Extension for essential methods
extension WorkStatisticsViewController: EssentialViewMethods {
    func setViewFoundation() {
        
    }
    
    func initializeObjects() {
        
    }
    
    func setDelegates() {
        
    }
    
    func setGestures() {
        
    }
    
    func setNotificationCenters() {
        
    }
    
    func setSubviews() {
        
    }
    
    func setLayouts() {
        
    }
    
    
}
