//
//  CompanyLocationViewController.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2021/11/26.
//

import UIKit
import CoreLocation
import Contacts
import Alamofire

class CompanyLocationViewController: UIViewController {

    var dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "dismissButtonImage"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.useRGB(red: 109, green: 114, blue: 120, alpha: 0.4)
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 50, weight: .bold)
        label.text = "직장 위치"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var searchTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .left
        textField.textColor = UIColor.useRGB(red: 0, green: 0, blue: 0)
        textField.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        textField.placeholder = "주소를 검색하세요."
        textField.returnKeyType = .search
        //textField.textContentType = .fullStreetAddress
        textField.enablesReturnKeyAutomatically = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    var deleteSearchTextButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "deleteSearchText"), for: .normal)
        button.isHidden = true
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
    
    var searchLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 151, green: 151, blue: 151)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var addressTableView: UITableView!
    
    var noResultTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textAlignment = .center
        label.textColor = UIColor.useRGB(red: 238, green: 238, blue: 238, alpha: 0.8)
        label.isHidden = true
        label.text = "검색 결과 없음"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var nextButtonView: UIView = {
        let view = UIView()
        view.backgroundColor = .buttons.initialBottom
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var nextButtonImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "nextNormalImage"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    var nextButton: UIButton = {
        let button = UIButton()
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var addresses: [CompanyAddress.Document] = []
    
    var companyLocationModel: CompanyLocationModel = CompanyLocationModel()
    
    var selectedLocationIndex: Int?
    
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
        // Address table view
        self.addressTableView = {
            let tableView = UITableView()
            tableView.separatorStyle = .none
            tableView.bounces = false
            tableView.register(CompanyAddressCell.self, forCellReuseIdentifier: "CompanyAddressCell")
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 60
            tableView.keyboardDismissMode = .onDrag
            tableView.translatesAutoresizingMaskIntoConstraints = false
            
            return tableView
        }()
    }
    
    // Set targets
    func setTargets() {
        self.dismissButton.addTarget(self, action: #selector(dismissButton(_:)), for: .touchUpInside)
        self.deleteSearchTextButton.addTarget(self, action: #selector(deleteSearchTextButton(_:)), for: .touchUpInside)
        self.searchTextField.addTarget(self, action: #selector(searchTextField(_:)), for: .editingChanged)
        self.nextButton.addTarget(self, action: #selector(nextButton(_:)), for: .touchUpInside)
    }
    
    // Set gestures
    func setGestures() {
        
    }
    
    // Set delegates
    func setDelegates() {
        LocationManager.shared.addDelegate(self)
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        self.searchTextField.delegate = self
        self.addressTableView.delegate = self
        self.addressTableView.dataSource = self
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
            self.addressTableView,
            self.noResultTextLabel,
            self.nextButtonView
        ], to: self.view)
        
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
        
        // Next button view layout
        NSLayoutConstraint.activate([
            self.nextButtonView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.nextButtonView.heightAnchor.constraint(equalToConstant: UIWindow().safeAreaInsets.bottom + 60),
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
        SupportingMethods.shared.turnCoverView(.on, on: self.view)
        self.companyLocationModel.searchAddressWithTextReqeust(text) { companyAddress in
            print("Company Address Count: \(companyAddress.documents.count)")
            
            self.addresses = companyAddress.documents
            
            self.addressTableView.reloadData()
            
            DispatchQueue.main.async {
                if self.addresses.isEmpty {
                    self.noResultTextLabel.isHidden = false
                    
                } else {
                    self.noResultTextLabel.isHidden = true
                }
                
                SupportingMethods.shared.turnCoverView(.off, on: self.view)
            }
            
        } failure: {
            self.noResultTextLabel.isHidden = false
            
            self.addresses = []
            self.addressTableView.reloadData()
            
            SupportingMethods.shared.turnCoverView(.off, on: self.view)
        }
    }
}

// MARK: - Extension for Selector methods
extension CompanyLocationViewController {
    @objc func dismissButton(_ sender: UIButton) {
        LocationManager.shared.removeDelegate(self)
        
        self.dismiss(animated: true, completion: nil)
        
        // FIXME: to test
        /*
        if let monitoredRegion = LocationManager.shared.locationManager.monitoredRegions.first,
           let circularRegion = monitoredRegion as? CLCircularRegion {
            LocationManager.shared.stopMonitorRegion(circularRegion.center)
            
            let alertVC = UIAlertController(title: "Stop Monitoring", message: "latitude: \(circularRegion.center.latitude), longitude: \(circularRegion.center.longitude)", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
                self.dismiss(animated: true, completion: nil)
            }
            alertVC.addAction(okAction)
            self.present(alertVC, animated: true, completion: nil)
            
        } else {
            self.dismiss(animated: true, completion: nil)
        }
        UIApplication.shared.applicationIconBadgeNumber = 0
         */
    }
    
    @objc func deleteSearchTextButton(_ sender: UIButton) {
        self.searchTextField.becomeFirstResponder()
        
        sender.isHidden = true
        self.searchTextField.text = ""
        
        self.nextButton.isEnabled = false
        self.nextButtonView.backgroundColor = UIColor.useRGB(red: 238, green: 238, blue: 238)
        self.nextButtonImageView.image = UIImage(named: "nextNormalImage")
        
        self.noResultTextLabel.isHidden = true
        
        self.selectedLocationIndex = nil
        
        self.addresses = []
        self.addressTableView.reloadData()
    }
    
//    @objc func searchButton(_ sender: UIButton) {
//        self.controlActivityIndicatorView(true)
//
//        self.resignAllTexts()
//
//        self.searchAddress(self.searchTextField.text!)
//    }
    
    @objc func searchTextField(_ textField: UITextField) {
        //self.searchButton.isEnabled = textField.text != "" && textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != ""
        self.deleteSearchTextButton.isHidden =  textField.text == "" && textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        //self.searchToolbar.isUserInteractionEnabled = textField.text != "" && textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != ""
    }
    
    @objc func openLocationOnMap(_ sender: UIButton) {
        self.searchTextField.resignFirstResponder()
        
        if let _ = Double(self.addresses[sender.tag].latitude),
           let _ = Double(self.addresses[sender.tag].longitude) {
            let companyMapVC = CompanyMapViewController()
            companyMapVC.address = self.addresses[sender.tag]
            
            self.navigationController?.pushViewController(companyMapVC, animated: true)
            
        } else {
            // If latitude & longitude are not valid
        }
    }
    
    @objc func nextButton(_ sender: UIButton) {
        self.searchTextField.resignFirstResponder()
        
        let center = CLLocationCoordinate2D(latitude: Double(self.addresses[self.selectedLocationIndex!].latitude)!, longitude: Double(self.addresses[self.selectedLocationIndex!].longitude)!)
        
        let detailCompanyAddressVC = CompanyDetailedAddressViewController(selectedCenter: center, selectedAddress: self.addresses[self.selectedLocationIndex!].addressName)
        
        self.navigationController?.pushViewController(detailCompanyAddressVC, animated: true)
        
        // FIXME: Temp code
        /*
        guard LocationManager.shared.locationManager.monitoredRegions.isEmpty else {
            print("Specified region is being monitored.")

            return
        }

        
        if let companyCenter = LocationManager.shared.companyRegion?.center {
            LocationManager.shared.startMonitorRegion(companyCenter)

            let alertVC = UIAlertController(title: "Start Monitoring", message: "latitude: \(companyCenter.latitude), longitude: \(companyCenter.longitude)", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alertVC.addAction(okAction)
            self.present(alertVC, animated: true, completion: nil)
        }
        */
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

// MARK: - Extension for LocationManagerDelegate
extension CompanyLocationViewController: LocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
//    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
//
//    }
//
//    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
//
//    }
}

// MARK: - Extension for UITextFieldDelegate
extension CompanyLocationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        self.selectedLocationIndex = nil
        
        self.nextButton.isEnabled = false
        self.nextButtonView.backgroundColor = UIColor.useRGB(red: 238, green: 238, blue: 238)
        self.nextButtonImageView.image = UIImage(named: "nextNormalImage")
        
        if textField.text != "" &&
            textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            self.searchAddress(self.searchTextField.text!)
            
        } else {
            self.noResultTextLabel.isHidden = false
            
            self.addresses = []
            self.addressTableView.reloadData()
        }
        
        return true
    }
}

// MARK: - Extension for UITableViewDelegate, UITableViewDataSource
extension CompanyLocationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.addresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyAddressCell", for: indexPath) as! CompanyAddressCell
        
        cell.setCell(
            self.addresses[indexPath.row].addressName,
            isSelected: self.selectedLocationIndex == indexPath.row,
            tag: indexPath.row
        )
        
        cell.addressMapButton.addTarget(self, action: #selector(openLocationOnMap(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchTextField.resignFirstResponder()
        
        if let latitude = Double(self.addresses[indexPath.row].latitude),
           let longitude = Double(self.addresses[indexPath.row].longitude) {
            self.selectedLocationIndex = indexPath.row
            
            let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            LocationManager.shared.companyRegion = CLCircularRegion(center: center, radius: 5, identifier: "companyLocation")
            
            self.nextButton.isEnabled = true
            self.nextButtonView.backgroundColor = UIColor.useRGB(red: 146, green: 243, blue: 205)
            self.nextButtonImageView.image = UIImage(named: "nextSelectedImage")
            
            tableView.reloadData()
        }
    }
}
