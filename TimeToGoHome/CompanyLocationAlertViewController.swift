//
//  CompanyLocationAlertViewController.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2021/11/26.
//

import UIKit

import UIKit

enum CompanyLocationAlertType {
    case companyLocationMap(jibeon: String, road: String)
    case companyAddressDetail
}

class CompanyLocationAlertViewController: UIViewController {
    
    var groundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 0, green: 0, blue: 0, alpha: 0.7)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var alertView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var alertTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 21, weight: .bold)
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var messageView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    // for Company location map
    var jibeonAddressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.3
        label.text = "주소:"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var roadAddressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.3
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
//    var addressLineView: UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor.useRGB(red: 151, green: 151, blue: 151)
//        view.translatesAutoresizingMaskIntoConstraints = false
//
//        return view
//    }()
    
    // for Company address detail
    var invalidAddressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .red
        label.text = "유효하지 않은 주소입니다. 다시 검색해 주세요."
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var buttonView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    // for Company location map
    var leftButtonView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var rightButtonView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.setTitle("취소", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.backgroundColor = UIColor.useRGB(red: 25, green: 161, blue: 244)
        button.layer.cornerRadius = 2
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var okButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.setTitle("확인", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.backgroundColor = UIColor.useRGB(red: 25, green: 161, blue: 244)
        button.layer.cornerRadius = 2
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var alertType: CompanyLocationAlertType
    var okClosure: () -> ()
    
    init(_ alertType: CompanyLocationAlertType, okClosure: @escaping () -> ()) {
        self.alertType = alertType
        self.okClosure = okClosure
        
        switch alertType {
        case .companyLocationMap(let jibeon, let road):
            self.alertTitleLabel.text = "이 위치로 지정"
            self.jibeonAddressLabel.text = jibeon != "" ? "주소: \(jibeon)" : "주소: \(road)"
            self.roadAddressLabel.text = road != "" ? "(도로명) \(road)" : ""
            
        case .companyAddressDetail:
            self.alertTitleLabel.text = "유효하지 않은 주소"
        }
        
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overCurrentContext
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setViewFoundation()
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
            print("----------------------------------- CompanyLocationAlertViewController disposed -----------------------------------")
    }
}

// MARK: - Extension for essential methods
extension CompanyLocationAlertViewController {
    // Set view foundation
    func setViewFoundation() {
        self.view.backgroundColor = .clear
        self.view.isOpaque = false
    }
    
    // Initialize views
    func initializeViews() {
        
    }
    
    // Set targets
    func setTargets() {
        self.cancelButton.addTarget(self, action: #selector(cancelButton(_:)), for: .touchUpInside)
        self.okButton.addTarget(self, action: #selector(okButton(_:)), for: .touchUpInside)
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
        SupportingMethods.shared.addSubviews([
            self.groundView
        ], to: self.view)
        
        SupportingMethods.shared.addSubviews([
            self.alertView,
        ], to: self.groundView)
        
        SupportingMethods.shared.addSubviews([
            self.alertTitleLabel,
            self.buttonView
        ], to: self.alertView)
        
        switch self.alertType {
        case .companyLocationMap:
            SupportingMethods.shared.addSubviews([
                self.messageView
            ], to: self.alertView)
            
            SupportingMethods.shared.addSubviews([
                self.jibeonAddressLabel,
                self.roadAddressLabel
            ], to: self.messageView)
            
            SupportingMethods.shared.addSubviews([
                self.leftButtonView,
                self.rightButtonView
            ], to: self.buttonView)
            
            SupportingMethods.shared.addSubviews([
                self.cancelButton
            ], to: self.leftButtonView)
            
            SupportingMethods.shared.addSubviews([
                self.okButton
            ], to: self.rightButtonView)
            
        case .companyAddressDetail:
            SupportingMethods.shared.addSubviews([
                self.invalidAddressLabel
            ], to: self.alertView)
            
            SupportingMethods.shared.addSubviews([
                self.okButton
            ], to: self.buttonView)
        }
    }
    
    // Set layouts
    func setLayouts() {
        let safeArea = self.view.safeAreaLayoutGuide
        
        // Ground view layout
        NSLayoutConstraint.activate([
            self.groundView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.groundView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.groundView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.groundView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
        
        switch self.alertType {
        case .companyLocationMap:
            // Alert view layout
            NSLayoutConstraint.activate([
                self.alertView.centerYAnchor.constraint(equalTo: self.groundView.centerYAnchor),
                self.alertView.heightAnchor.constraint(equalToConstant: 200),
                self.alertView.centerXAnchor.constraint(equalTo: self.groundView.centerXAnchor),
                self.alertView.widthAnchor.constraint(equalTo: self.groundView.widthAnchor, multiplier: 0.888)
            ])
            
        case .companyAddressDetail:
            // Alert view layout
            NSLayoutConstraint.activate([
                self.alertView.centerYAnchor.constraint(equalTo: self.groundView.centerYAnchor),
                self.alertView.heightAnchor.constraint(equalToConstant: 187),
                self.alertView.centerXAnchor.constraint(equalTo: self.groundView.centerXAnchor),
                self.alertView.widthAnchor.constraint(equalTo: self.groundView.widthAnchor, multiplier: 0.888)
            ])
        }
        
        // Alert title label layout
        NSLayoutConstraint.activate([
            self.alertTitleLabel.topAnchor.constraint(equalTo: self.alertView.topAnchor, constant: 22),
            self.alertTitleLabel.heightAnchor.constraint(equalToConstant: 25),
            self.alertTitleLabel.leadingAnchor.constraint(equalTo: self.alertView.leadingAnchor),
            self.alertTitleLabel.trailingAnchor.constraint(equalTo: self.alertView.trailingAnchor)
        ])
        
        // Button view layout
        NSLayoutConstraint.activate([
            self.buttonView.bottomAnchor.constraint(equalTo: self.alertView.bottomAnchor),
            self.buttonView.heightAnchor.constraint(equalToConstant: 67),
            self.buttonView.leadingAnchor.constraint(equalTo: self.alertView.leadingAnchor),
            self.buttonView.trailingAnchor.constraint(equalTo: self.alertView.trailingAnchor)
        ])
        
        switch self.alertType {
        case .companyLocationMap:
            // Message view layout
            NSLayoutConstraint.activate([
                self.messageView.topAnchor.constraint(equalTo: self.alertTitleLabel.bottomAnchor, constant: 21),
                self.messageView.heightAnchor.constraint(equalToConstant: 46),
                self.messageView.leadingAnchor.constraint(equalTo: self.alertView.leadingAnchor, constant: 26),
                self.messageView.trailingAnchor.constraint(equalTo: self.alertView.trailingAnchor, constant: -26)
            ])
            
            // Address mark label layout
            NSLayoutConstraint.activate([
                self.jibeonAddressLabel.topAnchor.constraint(equalTo: self.messageView.topAnchor),
                self.jibeonAddressLabel.heightAnchor.constraint(equalToConstant: 19),
                self.jibeonAddressLabel.leadingAnchor.constraint(equalTo: self.messageView.leadingAnchor),
                self.jibeonAddressLabel.trailingAnchor.constraint(equalTo: self.messageView.trailingAnchor)
            ])
            
            // Address label layout
            NSLayoutConstraint.activate([
                self.roadAddressLabel.topAnchor.constraint(equalTo: self.jibeonAddressLabel.bottomAnchor, constant: 10),
                self.roadAddressLabel.heightAnchor.constraint(equalToConstant: 17),
                self.roadAddressLabel.leadingAnchor.constraint(equalTo: self.messageView.leadingAnchor),
                self.roadAddressLabel.trailingAnchor.constraint(equalTo: self.messageView.trailingAnchor)
            ])
            
            // Left button view layout
            NSLayoutConstraint.activate([
                self.leftButtonView.topAnchor.constraint(equalTo: self.buttonView.topAnchor),
                self.leftButtonView.bottomAnchor.constraint(equalTo: self.buttonView.bottomAnchor),
                self.leftButtonView.leadingAnchor.constraint(equalTo: self.buttonView.leadingAnchor),
                self.leftButtonView.trailingAnchor.constraint(equalTo: self.buttonView.centerXAnchor)
            ])
            
            // Right button view layout
            NSLayoutConstraint.activate([
                self.rightButtonView.topAnchor.constraint(equalTo: self.buttonView.topAnchor),
                self.rightButtonView.bottomAnchor.constraint(equalTo: self.buttonView.bottomAnchor),
                self.rightButtonView.leadingAnchor.constraint(equalTo: self.buttonView.centerXAnchor),
                self.rightButtonView.trailingAnchor.constraint(equalTo: self.buttonView.trailingAnchor)
            ])
            
            // Cancel button layout
            NSLayoutConstraint.activate([
                self.cancelButton.topAnchor.constraint(equalTo: self.leftButtonView.topAnchor),
                self.cancelButton.heightAnchor.constraint(equalToConstant: 35),
                self.cancelButton.centerXAnchor.constraint(equalTo: self.leftButtonView.centerXAnchor),
                self.cancelButton.widthAnchor.constraint(equalTo: self.leftButtonView.widthAnchor, multiplier: 0.7)
            ])
            
            // OK button layout
            NSLayoutConstraint.activate([
                self.okButton.topAnchor.constraint(equalTo: self.rightButtonView.topAnchor),
                self.okButton.heightAnchor.constraint(equalToConstant: 35),
                self.okButton.centerXAnchor.constraint(equalTo: self.rightButtonView.centerXAnchor),
                self.okButton.widthAnchor.constraint(equalTo: self.rightButtonView.widthAnchor, multiplier: 0.7)
            ])
            
        case .companyAddressDetail:
            // Invalid address label layout
            NSLayoutConstraint.activate([
                self.invalidAddressLabel.topAnchor.constraint(equalTo: self.alertTitleLabel.bottomAnchor, constant: 27),
                self.invalidAddressLabel.heightAnchor.constraint(equalToConstant: 19),
                self.invalidAddressLabel.leadingAnchor.constraint(equalTo: self.alertView.leadingAnchor),
                self.invalidAddressLabel.trailingAnchor.constraint(equalTo: self.alertView.trailingAnchor)
            ])
            
            // OK button layout
            NSLayoutConstraint.activate([
                self.okButton.topAnchor.constraint(equalTo: self.buttonView.topAnchor),
                self.okButton.heightAnchor.constraint(equalToConstant: 35),
                self.okButton.centerXAnchor.constraint(equalTo: self.buttonView.centerXAnchor),
                self.okButton.widthAnchor.constraint(equalTo: self.buttonView.widthAnchor, multiplier: 0.3)
            ])
        }
    }
}

// MARK: - Extension for methods added
extension CompanyLocationAlertViewController {
    
}

// MARK: - Extension for Selector methods
extension CompanyLocationAlertViewController {
    @objc func cancelButton(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func okButton(_ sender: UIButton) {
        self.dismiss(animated: false) {
            self.okClosure()
        }
    }
}
