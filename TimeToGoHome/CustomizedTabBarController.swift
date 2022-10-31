//
//  CustomizedTabBarController.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2022/11/01.
//

import UIKit

class CustomizedTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.selectedViewController?.preferredStatusBarStyle ?? .default
    }
    
    deinit {
            print("----------------------------------- CustomizedTabBarController disposed -----------------------------------")
    }
}
