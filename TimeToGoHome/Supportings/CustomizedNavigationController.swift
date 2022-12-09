//
//  CustomizedNavigationController.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2022/10/25.
//

import UIKit

class CustomizedNavigationController: UINavigationController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.modalPresentationStyle = .fullScreen
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        
        self.modalPresentationStyle = .fullScreen
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.topViewController?.preferredStatusBarStyle ?? .default
    }
    
    deinit {
            print("----------------------------------- CustomizedNavigationController disposed -----------------------------------")
    }
}
