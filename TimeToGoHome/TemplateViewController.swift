//
//  TemplateViewController.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2021/11/26.
//

import UIKit

class TemplateViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initializeViews()
        self.setTargets()
        self.setGestures()
        self.setDelegates()
        self.setNotificationCenters()
        self.setSubviews()
        self.setLayouts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setViewFoundation()
    }
    
    deinit {
            print("----------------------------------- TemplateViewController disposed -----------------------------------")
    }
}

// MARK: - Extension for override methods
extension TemplateViewController {
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
extension TemplateViewController {
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
    
    // Set delegates
    func setDelegates() {
        
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
extension TemplateViewController {
    
}

// MARK: - Extension for Selector methods
extension TemplateViewController {
    
}
