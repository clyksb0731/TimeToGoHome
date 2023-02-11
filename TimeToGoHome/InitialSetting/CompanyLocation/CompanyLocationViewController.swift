//
//  CompanyLocationViewController.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2021/11/26.
//

import UIKit
import CoreLocation

class CompanyLocationViewController: UIViewController {

    lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "dismissButtonImage"), for: .normal)
        button.addTarget(self, action: #selector(dismissButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.useRGB(red: 109, green: 114, blue: 120, alpha: 0.4)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 50, weight: .bold)
        label.text = "직장 위치"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .left
        textField.textColor = UIColor.useRGB(red: 0, green: 0, blue: 0)
        textField.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        textField.placeholder = "장소를 검색하세요."
        textField.returnKeyType = .search
        //textField.textContentType = .fullStreetAddress
        textField.enablesReturnKeyAutomatically = true
        textField.delegate = self
        textField.addTarget(self, action: #selector(searchTextField(_:)), for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    lazy var deleteSearchTextButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "deleteSearchText"), for: .normal)
        button.isHidden = true
        button.addTarget(self, action: #selector(deleteSearchTextButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
//    var searchButton: UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(named: "searchButtonImage"), for: .normal)
//        button.isEnabled = false
//        button.translatesAutoresizingMaskIntoConstraints = false
//
//        return button
//    }()
    
    lazy var searchLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 151, green: 151, blue: 151)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var tapGestureBaseView: UIView = {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewBaseGesture(_:)))
        
        let view = UIView()
        view.addGestureRecognizer(tapGesture)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var addressTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.bounces = false
        tableView.register(CompanyAddressCell.self, forCellReuseIdentifier: "CompanyAddressCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.keyboardDismissMode = .onDrag
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    lazy var noResultTextLabel: UILabel = {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewBaseGesture(_:)))
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textAlignment = .center
        label.textColor = UIColor.useRGB(red: 191, green: 191, blue: 191)
        label.isHidden = true
        label.text = "검색 결과 없음"
        label.addGestureRecognizer(tapGesture)
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var jumpButtonView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.backgroundColor = .Buttons.initialActiveBottom
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var jumpButtonLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.textColor = .white
        label.text = "다음에 설정 〉"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var jumpButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(jumpButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var nextButtonView: UIView = {
        let view = UIView()
        view.backgroundColor = .Buttons.initialInactiveBottom
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var nextButtonImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "nextNormalImage"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.isEnabled = false
        button.addTarget(self, action: #selector(nextButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    //var addresses: [KeywordResult.Document] = []
    //var searchedAddress: SearchedAddress = SearchedAddress()
    
    var companyLocationModel: CompanyLocationModel = CompanyLocationModel()
    
    var currentPage: Int = 1
    var selectedLocationIndex: Int?
    
    var jumpButtonBottomViewAnchor: NSLayoutConstraint!
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.companyLocationModel.searchedAddress.address.isEmpty {
            self.showJumpButton()
        }
        
        // Location Manager authorization
        LocationManager.shared.requestAuthorization()
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
            print("----------------------------------- CompanyLocationViewController disposed -----------------------------------")
    }
}

// MARK: - Extension for essential methods
extension CompanyLocationViewController {
    // Set view foundation
    func setViewFoundation() {
        self.view.backgroundColor = .white
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithDefaultBackground()
        navigationBarAppearance.backgroundColor = .white
        navigationBarAppearance.titleTextAttributes = [
            .foregroundColor : UIColor.black,
            .font : UIFont.systemFont(ofSize: 17, weight: .semibold)
        ]
        
        self.navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        self.navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        self.navigationController?.navigationBar.compactAppearance = navigationBarAppearance
        
        self.navigationController?.setNavigationBarHidden(true, animated: true);
        
        // To hide navigation bar border line.
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
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
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    // Set notificationCenters
    func setNotificationCenters() {
        
    }
    
    // Set subviews
    func setSubviews() {
        SupportingMethods.shared.addSubviews([
            self.dismissButton,
            self.titleLabel,
            self.searchLineView,
            self.searchTextField,
            self.deleteSearchTextButton,
            self.tapGestureBaseView,
            self.addressTableView,
            self.noResultTextLabel,
            self.jumpButtonView,
            self.nextButtonView
        ], to: self.view)
        
        SupportingMethods.shared.addSubviews([
            self.jumpButtonLabel,
            self.jumpButton
        ], to: self.jumpButtonView)
        
        SupportingMethods.shared.addSubviews([
            self.nextButtonImageView,
            self.nextButton
        ], to: self.nextButtonView)
    }
    
    // Set layouts
    func setLayouts() {
        let safeArea = self.view.safeAreaLayoutGuide
        
        // Dismiss button layout
        NSLayoutConstraint.activate([
            self.dismissButton.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.dismissButton.heightAnchor.constraint(equalToConstant: 44),
            self.dismissButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -5),
            self.dismissButton.widthAnchor.constraint(equalToConstant: 44)
        ])
        
        // Title label layout
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 44),
            self.titleLabel.heightAnchor.constraint(equalToConstant: 45),
            self.titleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            self.titleLabel.widthAnchor.constraint(equalToConstant: 191)
        ])
        
        // Search textField layout
        NSLayoutConstraint.activate([
            self.searchTextField.bottomAnchor.constraint(equalTo: self.searchLineView.topAnchor),
            self.searchTextField.heightAnchor.constraint(equalToConstant: 35), // + 11
            self.searchTextField.leadingAnchor.constraint(equalTo: self.searchLineView.leadingAnchor, constant: 4),
            self.searchTextField.trailingAnchor.constraint(equalTo: self.deleteSearchTextButton.leadingAnchor, constant: -10)
        ])
        
        // Delete search text button layout
        NSLayoutConstraint.activate([
            self.deleteSearchTextButton.centerYAnchor.constraint(equalTo: self.searchTextField.centerYAnchor),
            self.deleteSearchTextButton.heightAnchor.constraint(equalToConstant: 18),
            self.deleteSearchTextButton.trailingAnchor.constraint(equalTo: self.searchLineView.trailingAnchor, constant: -2),
            self.deleteSearchTextButton.widthAnchor.constraint(equalToConstant: 18)
        ])
        
        // Search button layout
//        NSLayoutConstraint.activate([
//            self.searchButton.centerYAnchor.constraint(equalTo: self.searchTextField.centerYAnchor),
//            self.searchButton.heightAnchor.constraint(equalToConstant: 22),
//            self.searchButton.trailingAnchor.constraint(equalTo: self.searchLineView.trailingAnchor, constant: -10),
//            self.searchButton.widthAnchor.constraint(equalToConstant: 22)
//        ])
        
        // Search line view layout
        NSLayoutConstraint.activate([
            self.searchLineView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 64.5), // + 11
            self.searchLineView.heightAnchor.constraint(equalToConstant: 1),
            self.searchLineView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            self.searchLineView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16)
        ])
        
        // tapGestureBaseView
        NSLayoutConstraint.activate([
            self.tapGestureBaseView.topAnchor.constraint(equalTo: self.searchLineView.bottomAnchor),
            self.tapGestureBaseView.bottomAnchor.constraint(equalTo: self.nextButtonView.topAnchor),
            self.tapGestureBaseView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.tapGestureBaseView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
        
        // Address table view layout
        NSLayoutConstraint.activate([
            self.addressTableView.topAnchor.constraint(equalTo: self.searchLineView.bottomAnchor, constant: 20),
            self.addressTableView.bottomAnchor.constraint(equalTo: self.nextButtonView.topAnchor),
            self.addressTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.addressTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
        
        // No result text label layout
        NSLayoutConstraint.activate([
            self.noResultTextLabel.topAnchor.constraint(equalTo: self.addressTableView.topAnchor),
            self.noResultTextLabel.bottomAnchor.constraint(equalTo: self.addressTableView.bottomAnchor),
            self.noResultTextLabel.leadingAnchor.constraint(equalTo: self.addressTableView.leadingAnchor),
            self.noResultTextLabel.trailingAnchor.constraint(equalTo: self.addressTableView.trailingAnchor)
        ])
        
        // jumpButtonView
        self.jumpButtonBottomViewAnchor = self.jumpButtonView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        NSLayoutConstraint.activate([
            self.jumpButtonBottomViewAnchor,
            self.jumpButtonView.heightAnchor.constraint(equalToConstant: 40),
            self.jumpButtonView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            self.jumpButtonView.widthAnchor.constraint(equalToConstant: 140)
        ])
        
        // jumpButtonLabel
        SupportingMethods.shared.makeConstraintsOf(self.jumpButtonLabel, sameAs: self.jumpButtonView)
        
        // jumpButton
        SupportingMethods.shared.makeConstraintsOf(self.jumpButton, sameAs: self.jumpButtonView)
        
        // Next button view layout
        NSLayoutConstraint.activate([
            self.nextButtonView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.nextButtonView.heightAnchor.constraint(equalToConstant: ReferenceValues.keyWindow.safeAreaInsets.bottom + 60),
            self.nextButtonView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.nextButtonView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
        
        // Next button image view layout
        NSLayoutConstraint.activate([
            self.nextButtonImageView.topAnchor.constraint(equalTo: self.nextButtonView.topAnchor, constant: 20.5),
            self.nextButtonImageView.heightAnchor.constraint(equalToConstant: 19),
            self.nextButtonImageView.centerXAnchor.constraint(equalTo: self.nextButtonView.centerXAnchor),
            self.nextButtonImageView.widthAnchor.constraint(equalToConstant: 27)
        ])
        
        // Next button layout
        NSLayoutConstraint.activate([
            self.nextButton.topAnchor.constraint(equalTo: self.nextButtonView.topAnchor),
            self.nextButton.bottomAnchor.constraint(equalTo: self.nextButtonView.bottomAnchor),
            self.nextButton.leadingAnchor.constraint(equalTo: self.nextButtonView.leadingAnchor),
            self.nextButton.trailingAnchor.constraint(equalTo: self.nextButtonView.trailingAnchor)
        ])
    }
}

// MARK: - Extension for methods added
extension CompanyLocationViewController {
    func searchAddress(_ text: String) {
        self.addressTableView.isHidden = false
        
        SupportingMethods.shared.turnCoverView(.on, on: self.view)
        self.companyLocationModel.searchAddressWithText(text) {
            self.addressTableView.reloadData()
            
            DispatchQueue.main.async {
                if self.companyLocationModel.searchedAddress.address.isEmpty {
                    self.noResultTextLabel.isHidden = false
                    
                    self.showJumpButton()
                    
                } else {
                    self.noResultTextLabel.isHidden = true
                    
                    self.hideJumpButton()
                }
                
                SupportingMethods.shared.turnCoverView(.off, on: self.view)
            }
            
        } failure: {
            self.noResultTextLabel.isHidden = true
            
            self.companyLocationModel.initializeModel()
            self.addressTableView.reloadData()
            
            DispatchQueue.main.async {
                self.showJumpButton()
            }
            
            SupportingMethods.shared.makeAlert(on: self, withTitle: "오류", andMessage: "검색에 실패했습니다.")
            
            SupportingMethods.shared.turnCoverView(.off, on: self.view)
        }
    }
    
    func showJumpButton() {
        self.jumpButtonView.isHidden = false
        self.jumpButtonBottomViewAnchor.constant = -(60+8)
        
        UIView.animate(withDuration: 0.15) {
            self.view.layoutIfNeeded()
            
        } completion: { isFinished in
            
        }
    }
    
    func hideJumpButton() {
        self.jumpButtonView.isHidden = true
        self.jumpButtonBottomViewAnchor.constant = 0
    }
}

// MARK: - Extension for Selector methods
extension CompanyLocationViewController {
    @objc func dismissButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func deleteSearchTextButton(_ sender: UIButton) {
        sender.isHidden = true
        self.searchTextField.text = ""
        
        self.nextButton.isEnabled = false
        self.nextButtonView.backgroundColor = .Buttons.initialInactiveBottom
        self.nextButtonImageView.image = UIImage(named: "nextNormalImage")
        
        self.noResultTextLabel.isHidden = true
        self.addressTableView.isHidden = true
        
        self.selectedLocationIndex = nil
        
        self.companyLocationModel.initializeModel()
        self.addressTableView.reloadData()
        
        DispatchQueue.main.async {
            self.showJumpButton()
        }
    }
    
//    @objc func searchButton(_ sender: UIButton) {
//        self.controlActivityIndicatorView(true)
//
//        self.resignAllTexts()
//
//        self.searchAddress(self.searchTextField.text!)
//    }
    
    @objc func tableViewBaseGesture(_ gesture: UITapGestureRecognizer) {
        self.searchTextField.resignFirstResponder()
    }
    
    @objc func searchTextField(_ textField: UITextField) {
        //self.searchButton.isEnabled = textField.text != "" && textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != ""
        self.deleteSearchTextButton.isHidden =  textField.text == "" && textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        //self.searchToolbar.isUserInteractionEnabled = textField.text != "" && textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != ""
    }
    
    @objc func openLocationOnMap(_ sender: UIButton) {
        self.searchTextField.resignFirstResponder()
        
        if let _ = Double(self.companyLocationModel.searchedAddress.address[sender.tag].latitude),
           let _ = Double(self.companyLocationModel.searchedAddress.address[sender.tag].longitude) {
            let companyMapVC = CompanyMapViewController()
            companyMapVC.address = self.companyLocationModel.searchedAddress.address[sender.tag]
            
            self.navigationController?.pushViewController(companyMapVC, animated: true)
            
        } else {
            // If latitude & longitude are not valid
        }
    }
    
    @objc func jumpButton(_ sender: UIButton) {
        let staggeredWorkTypeVC = StaggeredWorkTypeViewController()
        let normalWorkTypeVC = NormalWorkTypeViewController()
        let tabBarVC = CustomizedTabBarController()
        tabBarVC.viewControllers = [staggeredWorkTypeVC, normalWorkTypeVC]
        tabBarVC.modalPresentationStyle = .fullScreen
        
        self.present(tabBarVC, animated: true, completion: nil)
        
        self.hideJumpButton()
    }
    
    @objc func nextButton(_ sender: UIButton) {
        self.searchTextField.resignFirstResponder()
        
        let center = CLLocationCoordinate2D(latitude: Double(self.companyLocationModel.searchedAddress.address[self.selectedLocationIndex!].latitude)!, longitude: Double(self.companyLocationModel.searchedAddress.address[self.selectedLocationIndex!].longitude)!)
        
        let detailCompanyAddressVC = CompanyDetailedAddressViewController(selectedCenter: center, selectedAddress: self.companyLocationModel.searchedAddress.address[self.selectedLocationIndex!].roadAddress ?? self.companyLocationModel.searchedAddress.address[self.selectedLocationIndex!].jibeonAddress!)
        
        self.navigationController?.pushViewController(detailCompanyAddressVC, animated: true)
    }
}

// MARK: - Extension for UIGestureRecognizerDelegate
extension CompanyLocationViewController: UIGestureRecognizerDelegate {
    // For swipe gesture
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // For swipe gesture, prevent working on the root view of navigation controller
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return self.navigationController!.viewControllers.count > 1 ? true : false
    }
}

// MARK: - Extension for UITextFieldDelegate
extension CompanyLocationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        self.companyLocationModel.initializeModel()
        
        self.selectedLocationIndex = nil
        
        self.nextButton.isEnabled = false
        self.nextButtonView.backgroundColor = .Buttons.initialInactiveBottom
        self.nextButtonImageView.image = UIImage(named: "nextNormalImage")
        
        if textField.text != "" &&
            textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            self.searchAddress(textField.text!)
            
        } else {
            self.noResultTextLabel.isHidden = false
            
            self.addressTableView.reloadData()
            
            DispatchQueue.main.async {
                self.showJumpButton()
            }
        }
        
        return true
    }
}

// MARK: - Extension for UITableViewDelegate, UITableViewDataSource
extension CompanyLocationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.companyLocationModel.searchedAddress.address.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyAddressCell", for: indexPath) as! CompanyAddressCell
        
        cell.setCell(self.companyLocationModel.searchedAddress.address[indexPath.row].placeName == nil ?
                     self.companyLocationModel.searchedAddress.address[indexPath.row].roadAddress == nil ? self.companyLocationModel.searchedAddress.address[indexPath.row].jibeonAddress :
                        self.companyLocationModel.searchedAddress.address[indexPath.row].roadAddress : self.companyLocationModel.searchedAddress.address[indexPath.row].placeName,
                     
                     address: self.companyLocationModel.searchedAddress.address[indexPath.row].placeName == nil ?
                     self.companyLocationModel.searchedAddress.address[indexPath.row].roadAddress == nil ? "(도로명 주소 없음)" :
                     self.companyLocationModel.searchedAddress.address[indexPath.row].jibeonAddress :
                     self.companyLocationModel.searchedAddress.address[indexPath.row].roadAddress == nil ? self.companyLocationModel.searchedAddress.address[indexPath.row].jibeonAddress :
                     self.companyLocationModel.searchedAddress.address[indexPath.row].roadAddress,
                     
                     isSelected: self.selectedLocationIndex == indexPath.row,
                     tag: indexPath.row)
        
        cell.addressMapButton.addTarget(self, action: #selector(openLocationOnMap(_:)), for: .touchUpInside)
        
        if indexPath.row == self.companyLocationModel.searchedAddress.address.count - 1,
           !self.companyLocationModel.searchedAddress.isEnd {
            SupportingMethods.shared.turnCoverView(.on, on: self.view)
            
            self.companyLocationModel.searchingPage += 1
            self.companyLocationModel.searchAddressWithText(self.searchTextField.text!) {
                tableView.reloadData()
                
                DispatchQueue.main.async {
                    SupportingMethods.shared.turnCoverView(.off, on: self.view)
                }
                
            } failure: {
                SupportingMethods.shared.turnCoverView(.off, on: self.view)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchTextField.resignFirstResponder()
        
        if let _ = Double(self.companyLocationModel.searchedAddress.address[indexPath.row].latitude),
           let _ = Double(self.companyLocationModel.searchedAddress.address[indexPath.row].longitude) {
            self.selectedLocationIndex = indexPath.row
            
            self.nextButton.isEnabled = true
            self.nextButtonView.backgroundColor = .Buttons.initialActiveBottom
            self.nextButtonImageView.image = UIImage(named: "nextSelectedImage")
            
            tableView.reloadData()
        }
    }
}
