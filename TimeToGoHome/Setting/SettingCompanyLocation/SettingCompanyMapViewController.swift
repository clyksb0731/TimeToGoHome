//
//  SettingCompanyMapViewController.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2023/01/08.
//

import UIKit
import MapKit
import Alamofire

class SettingCompanyMapViewController: UIViewController {
    
    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.delegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        return mapView
    }()
    
    lazy var searchBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .useRGB(red: 251, green: 251, blue: 251, alpha: 0.75)
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var searchBarTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 17, weight: .regular)
        textField.delegate = self
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .search
        textField.placeholder = "검색하세요."
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    lazy var currentLocationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "currentLocationButtonImage"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.isEnabled = false
        button.addTarget(self, action: #selector(currentLocationButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var tableCoverView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var tableBaseView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.useSketchShadow(color: .black, alpha: 0.5, x: 0, y: 2, blur: 4, spread: 0)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var tableViewTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 21, weight: .bold)
        label.textColor = .black
        label.text = "검색 결과"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var closeTableViewButton: UIButton = {
        let button = UIButton()
        button.setTitle("닫기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(closeTableViewButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var noResultTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textAlignment = .center
        label.textColor = UIColor.useRGB(red: 238, green: 238, blue: 238, alpha: 0.8)
        label.text = "검색 결과 없음"
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var addressTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.bounces = false
        tableView.register(SettingCompanyAddressCell.self, forCellReuseIdentifier: "SettingCompanyAddressCell")
        tableView.keyboardDismissMode = .onDrag
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset.bottom = 20
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    var searchedAddress: [CompanyAddress.Document] = []
    
    var currentLocation: CLLocationCoordinate2D!
    var address: (addressName: String, latitude: Double, longitude: Double)?
    var selectedCenter: CLLocationCoordinate2D?
    var selectedAddress: String?
    
    var companyLocationModel: CompanyLocationModel = CompanyLocationModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setViewFoundation()
        self.initializeObjects()
        self.setTargets()
        self.setGestures()
        self.setDelegates()
        self.setNotificationCenters()
        self.setSubviews()
        self.setLayouts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let initializeCenter = self.initializeCenter() {
            self.initializePointAnnotation(center: initializeCenter.center, title: initializeCenter.address)
            self.setRegion(center: initializeCenter.center)
        }
        
        SupportingMethods.shared.makeInstantViewWithText("지도를 길게 누르거나 검색해서 근무지를 설정하세요.", duration: 3.5, on: self, withPosition: .bottom(constant: -30))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("MapView Height: \(self.mapView.frame.height)")
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
            print("----------------------------------- SettingCompanyMapViewController disposed -----------------------------------")
    }
}

// MARK: - Extension for essential methods
extension SettingCompanyMapViewController: EssentialViewMethods {
    func setViewFoundation() {
        self.view.backgroundColor = .white
        
        self.navigationController?.setNavigationBarHidden(false, animated: true);
        
        self.navigationItem.title = "근무지 설정"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "backButtonItemImage"), style: .plain, target: self, action: #selector(leftBarButtonItem(_:)))
        self.navigationItem.leftBarButtonItem?.tintColor = .black
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(rightBarButtonItem(_:)))
        self.navigationItem.rightBarButtonItem?.tintColor = .black
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    func initializeObjects() {
        
    }
    
    func setTargets() {
        
    }
    
    func setGestures() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture(_:)))
        longPressGesture.minimumPressDuration = 0.5 // default
        self.mapView.addGestureRecognizer(longPressGesture)
    }
    
    func setDelegates() {
        
    }
    
    func setNotificationCenters() {
        
    }
    
    func setSubviews() {
        SupportingMethods.shared.addSubviews([
            self.mapView,
            self.searchBarView,
            self.currentLocationButton,
            self.tableCoverView
        ], to: self.view)
        
        SupportingMethods.shared.addSubviews([
            self.searchBarTextField
        ], to: self.searchBarView)
        
        SupportingMethods.shared.addSubviews([
            self.tableBaseView
        ], to: self.tableCoverView)
        
        SupportingMethods.shared.addSubviews([
            self.tableViewTitleLabel,
            self.closeTableViewButton,
            self.noResultTextLabel,
            self.addressTableView
        ], to: self.tableBaseView)
    }
    
    func setLayouts() {
        let safeArea: UILayoutGuide = self.view.safeAreaLayoutGuide
        
        // mapView
        NSLayoutConstraint.activate([
            self.mapView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.mapView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.mapView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
        
        // searchBarView
        NSLayoutConstraint.activate([
            self.searchBarView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 28),
            self.searchBarView.heightAnchor.constraint(equalToConstant: 44),
            self.searchBarView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            self.searchBarView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20)
        ])
        
        // searchBarTextField
        NSLayoutConstraint.activate([
            self.searchBarTextField.topAnchor.constraint(equalTo: self.searchBarView.topAnchor),
            self.searchBarTextField.bottomAnchor.constraint(equalTo: self.searchBarView.bottomAnchor),
            self.searchBarTextField.leadingAnchor.constraint(equalTo: self.searchBarView.leadingAnchor, constant: 8),
            self.searchBarTextField.trailingAnchor.constraint(equalTo: self.searchBarView.trailingAnchor, constant: -8)
        ])
        
        // currentLocationButton
        NSLayoutConstraint.activate([
            self.currentLocationButton.topAnchor.constraint(equalTo: self.searchBarView.bottomAnchor, constant: 11),
            self.currentLocationButton.heightAnchor.constraint(equalToConstant: 46),
            self.currentLocationButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            self.currentLocationButton.widthAnchor.constraint(equalToConstant: 46)
        ])
        
        // tableCoverView
        NSLayoutConstraint.activate([
            self.tableCoverView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.tableCoverView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            self.tableCoverView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.tableCoverView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
        
        // tableBaseView
        NSLayoutConstraint.activate([
            self.tableBaseView.centerYAnchor.constraint(equalTo: self.tableCoverView.centerYAnchor),
            self.tableBaseView.heightAnchor.constraint(equalToConstant: 270),
            self.tableBaseView.leadingAnchor.constraint(equalTo: self.tableCoverView.leadingAnchor, constant: 16),
            self.tableBaseView.trailingAnchor.constraint(equalTo: self.tableCoverView.trailingAnchor, constant: -16)
        ])
        
        // tableViewTitleLabel
        NSLayoutConstraint.activate([
            self.tableViewTitleLabel.topAnchor.constraint(equalTo: self.tableBaseView.topAnchor, constant: 24),
            self.tableViewTitleLabel.heightAnchor.constraint(equalToConstant: 22),
            self.tableViewTitleLabel.centerXAnchor.constraint(equalTo: self.tableBaseView.centerXAnchor)
            
        ])
        
        // closeTableViewButton
        NSLayoutConstraint.activate([
            self.closeTableViewButton.topAnchor.constraint(equalTo: self.tableBaseView.topAnchor, constant: 16),
            self.closeTableViewButton.trailingAnchor.constraint(equalTo: self.tableBaseView.trailingAnchor, constant: -24)
            
        ])
        
        // noResultTextLabel
        NSLayoutConstraint.activate([
            self.noResultTextLabel.centerYAnchor.constraint(equalTo: self.tableBaseView.centerYAnchor),
            self.noResultTextLabel.centerXAnchor.constraint(equalTo: self.tableBaseView.centerXAnchor)
        ])
        
        //
        NSLayoutConstraint.activate([
            self.addressTableView.topAnchor.constraint(equalTo: self.tableViewTitleLabel.bottomAnchor, constant: 8),
            self.addressTableView.bottomAnchor.constraint(equalTo: self.tableBaseView.bottomAnchor),
            self.addressTableView.leadingAnchor.constraint(equalTo: self.tableBaseView.leadingAnchor, constant: 20),
            self.addressTableView.trailingAnchor.constraint(equalTo: self.tableBaseView.trailingAnchor, constant: -20)
        ])
    }
}

// MARK: - Extension for methods added
extension SettingCompanyMapViewController {
    func initializeCenter() -> (center: CLLocationCoordinate2D, address: String)? {
        if let address = self.address {
            let center = CLLocationCoordinate2D(latitude: address.latitude, longitude: address.longitude)
            
            return (center, address.addressName)
            
        } else {
            return nil
        }
    }
    
    func initializePointAnnotation(center: CLLocationCoordinate2D, title: String) {
        let pin = MKPointAnnotation()
        pin.coordinate = center
        pin.title = title
        self.mapView.addAnnotation(pin)
    }
    
    func setPointAnnotation(center: CLLocationCoordinate2D, title: String) {
        let pin = MKPointAnnotation()
        pin.coordinate = center
        pin.title = title
        self.mapView.addAnnotation(pin)
        
        self.selectedCenter = center
        self.selectedAddress = title
        
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    func setRegion(center: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 300, longitudinalMeters: 300)
        self.mapView.setRegion(region, animated: true)
    }
    
    func searchAddress(_ text: String) {
        SupportingMethods.shared.turnCoverView(.on, on: self.view)
        self.companyLocationModel.searchAddressWithTextReqeust(text) { companyAddress in
            print("Company Address Count: \(companyAddress.documents.count)")
            
            self.searchedAddress = companyAddress.documents
            
            self.addressTableView.reloadData()
            
            DispatchQueue.main.async {
                if self.searchedAddress.isEmpty {
                    self.noResultTextLabel.isHidden = false
                    
                } else {
                    self.noResultTextLabel.isHidden = true
                }
                
                SupportingMethods.shared.turnCoverView(.off, on: self.view)
            }
            
        } failure: {
            self.noResultTextLabel.isHidden = true
            
            self.searchedAddress = []
            self.addressTableView.reloadData()
            
            SupportingMethods.shared.makeAlert(on: self, withTitle: "오류", andMessage: "검색에 실패했습니다.")
            
            SupportingMethods.shared.turnCoverView(.off, on: self.view)
        }
    }
    
    func findAddressWithCenter(_ center: CLLocationCoordinate2D) {
        SupportingMethods.shared.turnCoverView(.on, on: self.view)
        self.companyLocationModel.findAddressWithCenterRequest(latitude: String(center.latitude), longitude: String(center.longitude)) { companyMap in
            if let jibeonAddress = companyMap.documents.first?.address?.addressName,
               let roadAddress = companyMap.documents.first?.roadAddress?.addressName {
                let alertVC = CompanyLocationAlertViewController(.companyLocationMap(jibeon: jibeonAddress, road: roadAddress)) {
                    self.mapView.removeAnnotations(self.mapView.annotations)
                    
                    self.setPointAnnotation(center: center, title: jibeonAddress)
                }

                self.present(alertVC, animated: false) {
                    SupportingMethods.shared.turnCoverView(.off, on: self.view)
                }
                
            } else if let jibeonAddress = companyMap.documents.first?.address?.addressName {
                let alertVC = CompanyLocationAlertViewController(.companyLocationMap(jibeon: jibeonAddress, road: "")) {
                    self.mapView.removeAnnotations(self.mapView.annotations)
                    
                    self.setPointAnnotation(center: center, title: jibeonAddress)
                }
                
                self.present(alertVC, animated: false) {
                    SupportingMethods.shared.turnCoverView(.off, on: self.view)
                }
                
            } else if let roadAddress = companyMap.documents.first?.roadAddress?.addressName {
                let alertVC = CompanyLocationAlertViewController(.companyLocationMap(jibeon: "", road: roadAddress)) {
                    self.mapView.removeAnnotations(self.mapView.annotations)
                    
                    self.setPointAnnotation(center: center, title: roadAddress)
                }
                
                self.present(alertVC, animated: false) {
                    SupportingMethods.shared.turnCoverView(.off, on: self.view)
                }
                
            } else {
                let alertVC = UIAlertController(title: "주소 찾기 실패", message: "선택한 위치의 주소를 알 수 없습니다.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                alertVC.addAction(okAction)
                
                self.present(alertVC, animated: true) {
                    SupportingMethods.shared.turnCoverView(.off, on: self.view)
                }
            }
            
        } failure: {
            SupportingMethods.shared.makeAlert(on: self, withTitle: "오류", andMessage: "주소 찾기에 실패했습니다.")
            
            SupportingMethods.shared.turnCoverView(.off, on: self.view)
        }
    }
}

// MARK: - Extension for Selector methods
extension SettingCompanyMapViewController {
    @objc func leftBarButtonItem(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func rightBarButtonItem(_ sender: UIBarButtonItem) {
        guard let selectedCenter = self.selectedCenter, let selectedAddress = self.selectedAddress else {
            return
        }
        
        let companyModel = CompanyModel(joiningDate: ReferenceValues.initialSetting[InitialSetting.joiningDate.rawValue] as! Date)
        companyModel.company?.address = selectedAddress
        companyModel.company?.latitude = selectedCenter.latitude
        companyModel.company?.longitude = selectedCenter.longitude
        
        ReferenceValues.initialSetting.updateValue(selectedAddress, forKey: InitialSetting.companyAddress.rawValue)
        ReferenceValues.initialSetting.updateValue(selectedCenter.latitude, forKey: InitialSetting.companyLatitude.rawValue)
        ReferenceValues.initialSetting.updateValue(selectedCenter.longitude, forKey: InitialSetting.companyLongitude.rawValue)
        
        SupportingMethods.shared.setAppSetting(with: ReferenceValues.initialSetting, for: .initialSetting)
        
        SupportingMethods.shared.determineCurrentCompanyLocationPush()
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func currentLocationButton(_ sender: UIButton) {
        guard let currentLocation = self.currentLocation else {
            return
        }
        
        let region = MKCoordinateRegion(center: currentLocation, latitudinalMeters: 300, longitudinalMeters: 300)
        
        self.mapView.setRegion(region, animated: true)
    }
    
    @objc func closeTableViewButton(_ sender: UIButton) {
        self.tableCoverView.isHidden = true
        
        self.noResultTextLabel.isHidden = true
        self.searchedAddress = []
        self.addressTableView.reloadData()
    }
    
    @objc func longPressGesture(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let gesturedPoint = gesture.location(in: self.mapView)
            let newCenter = self.mapView.convert(gesturedPoint, toCoordinateFrom: self.mapView)
            self.searchBarTextField.resignFirstResponder()
            
            self.findAddressWithCenter(newCenter)
            
            UIDevice.lightHaptic()
        }
    }
}

// MARK: - Extension for MKMapViewDelegate
extension SettingCompanyMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        print("Current Latitude: \(userLocation.coordinate.latitude)")
        print("Current Longitude: \(userLocation.coordinate.longitude)")
        
        self.currentLocation = userLocation.coordinate
        self.currentLocationButton.isEnabled = true
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.annotation is MKUserLocation {
            print("didSelected: user location latitude: \(view.annotation?.coordinate.latitude ?? 0), longitude: \(view.annotation?.coordinate.longitude ?? 0)")
            
        } else {
            print("didSelected annotation: \(view.reuseIdentifier ?? "no id")")
            print("latitude: \(view.annotation?.coordinate.latitude ?? 0), longitude: \(view.annotation?.coordinate.longitude ?? 0)")
        }
    }
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        return nil
//    }
}

// MARK: - Extension for UITextFieldDelegate
extension SettingCompanyMapViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.tableCoverView.isHidden = false
        
        if textField.text != "" &&
            textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            self.searchAddress(textField.text!)
            
        } else {
            self.noResultTextLabel.isHidden = false
            
            self.searchedAddress = []
            self.addressTableView.reloadData()
        }
        
        return true
    }
}

// MARK: - Extension for UITableViewDelegate, UITableViewDataSource
extension SettingCompanyMapViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchedAddress.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCompanyAddressCell", for: indexPath) as! SettingCompanyAddressCell
        cell.setCell(self.searchedAddress[indexPath.row].addressName)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let latitude = Double(self.searchedAddress[indexPath.row].latitude),
           let longitude = Double(self.searchedAddress[indexPath.row].longitude) {
            
            let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            //LocationManager.shared.companyRegion = CLCircularRegion(center: center, radius: 5, identifier: "companyLocation")
            
            self.setPointAnnotation(center: center, title: self.searchedAddress[indexPath.row].addressName)
            self.setRegion(center: center)
        }
    }
}
