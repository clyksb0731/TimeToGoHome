//
//  CompanyDetailedAddressViewController.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2021/11/26.
//

import UIKit
import CoreLocation

class CompanyDetailedAddressViewController: UIViewController {

    // Instead of navigation bar line
    var topLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 151, green: 151, blue: 151, alpha: 0.3)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var selectedAddressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var firstLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 151, green: 151, blue: 151)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var detailAddressTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "상세주소 입력 (생략 가능)"
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.textColor = .black
        textField.textAlignment = .left
        textField.returnKeyType = .done
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    var secondLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 151, green: 151, blue: 151)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var selectedCenter: CLLocationCoordinate2D!
    var selectedAddress: String!
    
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
    
    init(selectedCenter: CLLocationCoordinate2D, selectedAddress: String) {
        super.init(nibName: nil, bundle: nil)
        
        self.selectedCenter = selectedCenter
        self.selectedAddress = selectedAddress
        self.selectedAddressLabel.text = selectedAddress
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            print("----------------------------------- CompanyDetailedAddressViewController disposed -----------------------------------")
    }
}

// MARK: - Extension for essential methods
extension CompanyDetailedAddressViewController {
    // Set view foundation
    func setViewFoundation() {
        self.view.backgroundColor = .white
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.navigationItem.title = "상세 위치"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "backButtonItemImage"), style: .plain, target: self, action: #selector(leftBarButtonItem(_:)))
        self.navigationItem.leftBarButtonItem?.tintColor = .black
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(rightBarButtonItem(_:)))
        self.navigationItem.rightBarButtonItem?.tintColor = .black
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
        self.detailAddressTextField.delegate = self
    }
    
    // Set notificationCenters
    func setNotificationCenters() {
        
    }
    
    // Set subviews
    func setSubviews() {
        SupportingMethods.shared.addSubviews([
            self.topLineView,
            self.selectedAddressLabel,
            self.firstLineView,
            self.detailAddressTextField,
            self.secondLineView
        ], to: self.view)
    }
    
    // Set layouts
    func setLayouts() {
        let safeArea = self.view.safeAreaLayoutGuide
        
        // Top line view layout
        NSLayoutConstraint.activate([
            self.topLineView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.topLineView.heightAnchor.constraint(equalToConstant: 0.5),
            self.topLineView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.topLineView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
        
        // Selected address label layout
        NSLayoutConstraint.activate([
            self.selectedAddressLabel.topAnchor.constraint(equalTo: self.topLineView.bottomAnchor, constant: 71),
            self.selectedAddressLabel.heightAnchor.constraint(equalToConstant: 39), // + 15
            self.selectedAddressLabel.leadingAnchor.constraint(equalTo: self.firstLineView.leadingAnchor, constant: 5),
            self.selectedAddressLabel.trailingAnchor.constraint(equalTo: self.firstLineView.trailingAnchor, constant: -5)
        ])
        
        // First line view layout
        NSLayoutConstraint.activate([
            self.firstLineView.topAnchor.constraint(equalTo: self.selectedAddressLabel.bottomAnchor),
            self.firstLineView.heightAnchor.constraint(equalToConstant: 1),
            self.firstLineView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            self.firstLineView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16)
        ])
        
        // Detail address textField layout
        NSLayoutConstraint.activate([
            self.detailAddressTextField.topAnchor.constraint(equalTo: self.firstLineView.bottomAnchor, constant: 17), // - 10
            self.detailAddressTextField.heightAnchor.constraint(equalToConstant: 35), // + 15
            self.detailAddressTextField.leadingAnchor.constraint(equalTo: self.secondLineView.leadingAnchor, constant: 5),
            self.detailAddressTextField.trailingAnchor.constraint(equalTo: self.secondLineView.trailingAnchor, constant: -5)
        ])
        
        // Second line view layout
        NSLayoutConstraint.activate([
            self.secondLineView.topAnchor.constraint(equalTo: self.detailAddressTextField.bottomAnchor),
            self.secondLineView.heightAnchor.constraint(equalToConstant: 1),
            self.secondLineView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            self.secondLineView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16)
        ])
    }
}

// MARK: - Extension for methods added
extension CompanyDetailedAddressViewController {
    func completeInitialLocationSetting() {
        ReferenceValues.initialSetting.updateValue(self.selectedCenter.latitude, forKey: InitialSetting.companyLatitude.rawValue)
        ReferenceValues.initialSetting.updateValue(self.selectedCenter.longitude, forKey: InitialSetting.companyLongitude.rawValue)
        
        ReferenceValues.initialSetting.updateValue(String(format: "%@ %@", self.selectedAddress, self.detailAddressTextField.text!), forKey: InitialSetting.companyAddress.rawValue)
        
        let staggeredWorkTypeVC = StaggeredWorkTypeViewController()
        let normalWorkTypeVC = NormalWorkTypeViewController()
        let tabBarVC = CustomizedTabBarController()
        tabBarVC.viewControllers = [staggeredWorkTypeVC, normalWorkTypeVC]
        tabBarVC.modalPresentationStyle = .fullScreen
        
        self.present(tabBarVC, animated: true, completion: nil)
    }
}

// MARK: - Extension for UITextFieldDelegate
extension CompanyDetailedAddressViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        self.completeInitialLocationSetting()
        
        return true
    }
}

// MARK: - Extension for Selector methods
extension CompanyDetailedAddressViewController {
    @objc func leftBarButtonItem(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func rightBarButtonItem(_ sender: UIBarButtonItem) {
        self.completeInitialLocationSetting()
    }
}
