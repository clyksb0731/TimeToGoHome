//
//  MainCoverViewController.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2022/03/15.
//

import UIKit

protocol MainCoverDelegate {
    func mainCoverDidSelectNormalSchedule(_ scheduleType: ScheduleType)
}

// Extension for Optional function effect
extension MainCoverDelegate {
    func mainCoverDidSelectNormalSchedule(_ scheduleType: ScheduleType) { }
}

enum MainCoverType {
    case normalSchedule
    case overtimeSchedule
    case startingWorkTime
}

class MainCoverViewController: UIViewController {
    
    var delegate: MainCoverDelegate?
    
    init(mainCoverTypeFor: ScheduleType) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initializeViews()
        self.setTargets()
        self.setGestures()
        self.setNotificationCenters()
        self.setSubviews()
        self.setLayouts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setViewFoundation()
    }
    
    deinit {
            print("----------------------------------- MainCoverViewController disposed -----------------------------------")
    }
}

// MARK: - Extension for override methods
extension MainCoverViewController {
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
}

// MARK: - Extension for essential methods
extension MainCoverViewController {
    // Set view foundation
    func setViewFoundation() {
        
    }
    
    // Initialize views
    func initializeViews() {
        
    }
    
    // Set targets
    func setTargets() {
        
    }
    
    // Set gestures
    func setGestures() {
        
    }
    
    // Set notificationCenters
    func setNotificationCenters() {
        
    }
    
    // Set subviews
    func setSubviews() {
        
    }
    
    // Set layouts
    func setLayouts() {
        
    }
}

// MARK: - Extension for methods added
extension MainCoverViewController {
    
}

// MARK: - Extension for Selector methods
extension MainCoverViewController {
    
}

