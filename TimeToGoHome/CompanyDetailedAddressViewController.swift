//
//  CompanyDetailedAddressViewController.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2021/11/26.
//

import UIKit

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
        textField.placeholder = "상세주소를 입력하세요."
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.textColor = .black
        textField.textAlignment = .left
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    var secondLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 151, green: 151, blue: 151)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
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
    
    init(selectedAddress: String) {
        super.init(nibName: nil, bundle: nil)
        
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
        
        //self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.useRGB(red: 0, green: 0, blue: 0),
                                                                        .font:UIFont.systemFont(ofSize: 18, weight: .medium)]
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
            self.selectedAddressLabel.heightAnchor.constraint(equalToConstant: 24),
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
            self.detailAddressTextField.topAnchor.constraint(equalTo: self.firstLineView.bottomAnchor, constant: 27),
            self.detailAddressTextField.heightAnchor.constraint(equalToConstant: 20),
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
    
}

// MARK: - Extension for Selector methods
extension CompanyDetailedAddressViewController {
    @objc func leftBarButtonItem(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func rightBarButtonItem(_ sender: UIBarButtonItem) {
        SupportingMethods.shared.temporaryInitialData.updateValue(String(format: "%@ %@", self.selectedAddress, self.detailAddressTextField.text!), forKey: PListVariable.companyAddress.rawValue)
        
        let workTypeVC = WorkTypeViewController()
        workTypeVC.modalPresentationStyle = .fullScreen
        
        self.present(workTypeVC, animated: true, completion: nil)
    }
}
