//
//  CustomizedNavigationController.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2022/10/25.
//

import UIKit

class CustomizedNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.topViewController?.preferredStatusBarStyle ?? .default
    }
}
