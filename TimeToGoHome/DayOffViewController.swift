//
//  DayOffViewController.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2022/04/04.
//

import UIKit

class DayOffViewController: UIViewController {
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 582)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "dismissButtonImage"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "근무 형태"
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textColor = UIColor.useRGB(red: 109, green: 114, blue: 120, alpha: 0.4)
        label.font = UIFont.systemFont(ofSize: 50, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var holidaysLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor.useRGB(red: 60, green: 60, blue: 67, alpha: 0.6)
        label.font = UIFont.systemFont(ofSize: 21, weight: .semibold)
        label.text = "정기 휴일 설정"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var dayButtonsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var sundayButtonView: DayButtonView = {
        let buttonView = DayButtonView(day: .sunday)
        buttonView.tag = 1
        buttonView.isSelected = true
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        
        return buttonView
    }()
    
    lazy var mondayButtonView: DayButtonView = {
        let buttonView = DayButtonView(day: .monday)
        buttonView.tag = 2
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        
        return buttonView
    }()
    
    lazy var tuesdayButtonView: DayButtonView = {
        let buttonView = DayButtonView(day: .tuesday)
        buttonView.tag = 3
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        
        return buttonView
    }()
    
    lazy var wednesdayButtonView: DayButtonView = {
        let buttonView = DayButtonView(day: .wednesday)
        buttonView.tag = 4
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        
        return buttonView
    }()
    
    lazy var thursdayButtonView: DayButtonView = {
        let buttonView = DayButtonView(day: .thursday)
        buttonView.tag = 5
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        
        return buttonView
    }()
    
    lazy var fridayButtonView: DayButtonView = {
        let buttonView = DayButtonView(day: .friday)
        buttonView.tag = 6
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        
        return buttonView
    }()
    
    lazy var saturdayButtonView: DayButtonView = {
        let buttonView = DayButtonView(day: .saturday)
        buttonView.tag = 7
        buttonView.isSelected = true
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        
        return buttonView
    }()
    
    lazy var startButtonView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 146, green: 243, blue: 205)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var startButtonLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.useRGB(red: 255, green: 255, blue: 255)
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.text = "시작"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var startButton: UIButton = {
        let button = UIButton()
        button.isEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()

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
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    deinit {
            print("----------------------------------- DayOffViewController disposed -----------------------------------")
    }
}

// MARK: - Extension for essential methods
extension DayOffViewController {
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
extension DayOffViewController {
    
}

// MARK: - Extension for Selector methods
extension DayOffViewController {
    
}
