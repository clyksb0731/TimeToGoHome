//
//  SettingCompanyMapViewController.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2023/01/08.
//

import UIKit
import MapKit

class SettingCompanyMapViewController: UIViewController {
    
    enum TableBaseViewMovingType {
        case top
        case bottom
    }
    
    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        return mapView
    }()
    
    lazy var mapCoverView: UIView = {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(mapCoverViewTapGesture(_:)))
        
        let view = UIView()
        view.addGestureRecognizer(tapGesture)
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var searchBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .useRGB(red: 255, green: 255, blue: 255, alpha: 0.75)
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = 0.5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var searchBarTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 17, weight: .regular)
        textField.delegate = self
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .search
        textField.placeholder = "장소를 검색하세요."
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
    
    lazy var tableBaseView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var tableBaseUpperRoundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.useSketchShadow(color: .black, alpha: 0.5, x: 0, y: 2, blur: 4, spread: 0)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var topMovingIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .useRGB(red: 202, green: 202, blue: 202)
        view.layer.cornerRadius = 2.5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var tableBaseLowerView: UIView = {
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(tableBaseViewSwipeGesture(_:)))
        swipeGesture.direction = .down
        
        let view = UIView()
        view.backgroundColor = .white
        view.addGestureRecognizer(swipeGesture)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var tableViewTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        label.text = "검색 결과"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var noResultTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textAlignment = .center
        label.textColor = UIColor.useRGB(red: 191, green: 191, blue: 191)
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
        //tableView.contentInset.bottom = 20
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    var tableBaseViewTopAnchor: NSLayoutConstraint!
    var tableBaseViewHeight: CGFloat = ReferenceValues.keyWindow.screen.bounds.height / 2 + 74
    var isTableBaseViewMoving = false
    
    //var searchedAddress: [KeywordResult.Document] = []
    
    var currentLocation: CLLocationCoordinate2D!
    var address: (companyName: String, addressName: String, latitude: Double, longitude: Double)?
    var selectedCenter: CLLocationCoordinate2D?
    var selectedAddressTitle: String?
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
        
        self.mapView.delegate = self
        self.mapView.removeAnnotations(self.mapView.annotations)
        
        if let initializeCenter = self.initializeCenter() {
            self.initializePointAnnotation(center: initializeCenter.center,
                                           title: initializeCenter.title)
            self.setRegion(center: initializeCenter.center)
        }
        
        SupportingMethods.shared.makeInstantViewWithText("지도를 길게 누르거나 검색해서 근무지를 설정하세요.", duration: 3.5, on: self.mapView, withPosition: .bottom(constant: -30))
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
            self.mapCoverView,
            self.searchBarView,
            self.currentLocationButton,
            self.tableBaseView
        ], to: self.view)
        
        SupportingMethods.shared.addSubviews([
            self.searchBarTextField
        ], to: self.searchBarView)
        
        SupportingMethods.shared.addSubviews([
            self.tableBaseUpperRoundView,
            self.tableBaseLowerView
        ], to: self.tableBaseView)
        
        SupportingMethods.shared.addSubviews([
            self.topMovingIndicatorView
        ], to: self.tableBaseUpperRoundView)
        
        SupportingMethods.shared.addSubviews([
            self.tableViewTitleLabel,
            self.noResultTextLabel,
            self.addressTableView
        ], to: self.tableBaseLowerView)
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
        
        // mapCoverView
        NSLayoutConstraint.activate([
            self.mapCoverView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.mapCoverView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.mapCoverView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.mapCoverView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
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
        
        // tableBaseView
        self.tableBaseViewTopAnchor = self.tableBaseView.topAnchor.constraint(equalTo: self.view.bottomAnchor)
        let tableBaseViewHeightAnchor = self.tableBaseView.heightAnchor.constraint(equalToConstant: self.tableBaseViewHeight)
        NSLayoutConstraint.activate([
            self.tableBaseViewTopAnchor,
            tableBaseViewHeightAnchor,
            self.tableBaseView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.tableBaseView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
        
        // tableBaseUpperRoundView
        NSLayoutConstraint.activate([
            self.tableBaseUpperRoundView.topAnchor.constraint(equalTo: self.tableBaseView.topAnchor),
            self.tableBaseUpperRoundView.heightAnchor.constraint(equalToConstant: 100),
            self.tableBaseUpperRoundView.leadingAnchor.constraint(equalTo: self.tableBaseView.leadingAnchor),
            self.tableBaseUpperRoundView.trailingAnchor.constraint(equalTo: self.tableBaseView.trailingAnchor)
        ])
        
        // topMovingIndicatorView
        NSLayoutConstraint.activate([
            self.topMovingIndicatorView.topAnchor.constraint(equalTo: self.tableBaseUpperRoundView.topAnchor, constant: 14),
            self.topMovingIndicatorView.heightAnchor.constraint(equalToConstant: 5),
            self.topMovingIndicatorView.centerXAnchor.constraint(equalTo: self.tableBaseUpperRoundView.centerXAnchor),
            self.topMovingIndicatorView.widthAnchor.constraint(equalToConstant: 80)
        ])
        
        // tableBaseLowerView
        NSLayoutConstraint.activate([
            self.tableBaseLowerView.topAnchor.constraint(equalTo: self.tableBaseUpperRoundView.topAnchor, constant: 20),
            self.tableBaseLowerView.bottomAnchor.constraint(equalTo: self.tableBaseView.bottomAnchor),
            self.tableBaseLowerView.leadingAnchor.constraint(equalTo: self.tableBaseView.leadingAnchor),
            self.tableBaseLowerView.trailingAnchor.constraint(equalTo: self.tableBaseView.trailingAnchor)
        ])
        
        // tableViewTitleLabel
        NSLayoutConstraint.activate([
            self.tableViewTitleLabel.topAnchor.constraint(equalTo: self.tableBaseLowerView.topAnchor, constant: 29),
            self.tableViewTitleLabel.heightAnchor.constraint(equalToConstant: 25),
            self.tableViewTitleLabel.leadingAnchor.constraint(equalTo: self.tableBaseLowerView.leadingAnchor, constant: 32)
            
        ])
        
        // noResultTextLabel
        NSLayoutConstraint.activate([
            self.noResultTextLabel.centerYAnchor.constraint(equalTo: self.tableBaseLowerView.centerYAnchor),
            self.noResultTextLabel.centerXAnchor.constraint(equalTo: self.tableBaseLowerView.centerXAnchor)
        ])
        
        // addressTableView
        NSLayoutConstraint.activate([
            self.addressTableView.topAnchor.constraint(equalTo: self.tableViewTitleLabel.bottomAnchor, constant: 24),
            self.addressTableView.bottomAnchor.constraint(equalTo: self.tableBaseLowerView.bottomAnchor),
            self.addressTableView.leadingAnchor.constraint(equalTo: self.tableBaseLowerView.leadingAnchor, constant: 20),
            self.addressTableView.trailingAnchor.constraint(equalTo: self.tableBaseLowerView.trailingAnchor, constant: -20)
        ])
    }
}

// MARK: - Extension for methods added
extension SettingCompanyMapViewController {
    func initializeCenter() -> (center: CLLocationCoordinate2D, title: String, address: String)? {
        if let selectedCenter = self.selectedCenter, let selectedAddressTitle = self.selectedAddressTitle, let selectedAddress = self.selectedAddress {
            return (selectedCenter, selectedAddressTitle, selectedAddress)
            
        } else if let address = self.address {
            let center = CLLocationCoordinate2D(latitude: address.latitude, longitude: address.longitude)
            
            return (center, address.companyName, address.addressName)
            
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
    
    func setPointAnnotation(center: CLLocationCoordinate2D, title: String, address: String) {
        let pin = MKPointAnnotation()
        pin.coordinate = center
        pin.title = title
        self.mapView.addAnnotation(pin)
        
        self.selectedCenter = center
        self.selectedAddressTitle = title
        self.selectedAddress = address
        
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    func setRegion(center: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 300, longitudinalMeters: 300)
        self.mapView.setRegion(region, animated: true)
    }
    
    func searchAddress(_ text: String) {
        self.moveTableBaseViewToTop(movingType: .top)
        
        SupportingMethods.shared.turnCoverView(.on, on: self.view)
        
        self.companyLocationModel.searchAddressWithText(text) {
            self.addressTableView.reloadData()
            
            DispatchQueue.main.async {
                if self.companyLocationModel.searchedAddress.address.isEmpty {
                    self.noResultTextLabel.isHidden = false
                    self.addressTableView.isHidden = true
                    
                } else {
                    self.noResultTextLabel.isHidden = true
                    self.addressTableView.isHidden = false
                }
                
                SupportingMethods.shared.turnCoverView(.off, on: self.view)
            }
            
        } failure: {
            self.noResultTextLabel.isHidden = true
            self.addressTableView.isHidden = true
            
            self.companyLocationModel.initializeModel()
            self.addressTableView.reloadData()
            
            SupportingMethods.shared.makeAlert(on: self, withTitle: "오류", andMessage: "검색에 실패했습니다.")
            
            SupportingMethods.shared.turnCoverView(.off, on: self.view)
        }
    }
    
    func findAddressWithCenter(_ center: CLLocationCoordinate2D) {
        SupportingMethods.shared.turnCoverView(.on, on: self.view)
        
        self.moveTableBaseViewToTop(movingType: .top)
        
        self.companyLocationModel.findAddressWithCenterRequest(latitude: String(center.latitude), longitude: String(center.longitude)) { companyMap in
            if let jibeonAddress = companyMap.documents.first?.address?.addressName,
               let roadAddress = companyMap.documents.first?.roadAddress?.addressName {
                let alertVC = CompanyLocationAlertViewController(.companyLocationMap(jibeon: jibeonAddress, road: roadAddress)) {
                    self.mapView.removeAnnotations(self.mapView.annotations)
                    
                    self.setPointAnnotation(center: center, title: roadAddress, address: roadAddress)
                }

                self.present(alertVC, animated: false) {
                    SupportingMethods.shared.turnCoverView(.off, on: self.view)
                }
                
            } else if let jibeonAddress = companyMap.documents.first?.address?.addressName {
                let alertVC = CompanyLocationAlertViewController(.companyLocationMap(jibeon: jibeonAddress, road: "")) {
                    self.mapView.removeAnnotations(self.mapView.annotations)
                    
                    self.setPointAnnotation(center: center, title: jibeonAddress, address: jibeonAddress)
                }
                
                self.present(alertVC, animated: false) {
                    SupportingMethods.shared.turnCoverView(.off, on: self.view)
                }
                
            } else if let roadAddress = companyMap.documents.first?.roadAddress?.addressName {
                let alertVC = CompanyLocationAlertViewController(.companyLocationMap(jibeon: "", road: roadAddress)) {
                    self.mapView.removeAnnotations(self.mapView.annotations)
                    
                    self.setPointAnnotation(center: center, title: roadAddress, address: roadAddress)
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
    
    func moveTableBaseViewToTop(movingType: TableBaseViewMovingType) {
        guard !self.isTableBaseViewMoving else {
            return
        }
        
        self.isTableBaseViewMoving = true
        
        switch movingType {
        case .top:
            self.tableBaseViewTopAnchor.constant = -self.tableBaseViewHeight
            self.mapCoverView.isHidden = false
            
        case .bottom:
            self.tableBaseViewTopAnchor.constant = 0
            self.mapCoverView.isHidden = true
        }
        
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
            
        } completion: { isFinished in
            self.isTableBaseViewMoving = !isFinished
            
            if case .bottom = movingType {
                self.tableBaseView.isHidden = true
                
                self.noResultTextLabel.isHidden = true
                self.addressTableView.isHidden = false
                
                self.companyLocationModel.initializeModel()
                self.addressTableView.reloadData()
            }
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
        
        let detailCompanyAddressVC = SettingCompanyDetailedAddressViewController(selectedCenter: selectedCenter, selectedAddress: selectedAddress)
        
        self.mapView.delegate = nil
        
        self.navigationController?.pushViewController(detailCompanyAddressVC, animated: true)
    }
    
    @objc func currentLocationButton(_ sender: UIButton) {
        guard let currentLocation = self.currentLocation else {
            return
        }
        
        self.moveTableBaseViewToTop(movingType: .bottom)
        
        let region = MKCoordinateRegion(center: currentLocation, latitudinalMeters: 300, longitudinalMeters: 300)
        
        self.mapView.setRegion(region, animated: true)
    }
    
    @objc func longPressGesture(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            self.moveTableBaseViewToTop(movingType: .bottom)
            
            let gesturedPoint = gesture.location(in: self.mapView)
            let newCenter = self.mapView.convert(gesturedPoint, toCoordinateFrom: self.mapView)
            self.searchBarTextField.resignFirstResponder()
            
            self.findAddressWithCenter(newCenter)
            
            UIDevice.lightHaptic()
        }
    }
    
    @objc func mapCoverViewTapGesture(_ gesture: UITapGestureRecognizer) {
        self.moveTableBaseViewToTop(movingType: .bottom)
    }
    
    @objc func tableBaseViewSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        self.moveTableBaseViewToTop(movingType: .bottom)
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
        
        self.companyLocationModel.initializeModel()
        
        self.tableBaseView.isHidden = false
        
        if textField.text != "" &&
            textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            self.searchAddress(textField.text!)
            
        } else {
            self.moveTableBaseViewToTop(movingType: .top)
            
            self.noResultTextLabel.isHidden = false
            self.addressTableView.isHidden = true
            
            self.addressTableView.reloadData()
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.moveTableBaseViewToTop(movingType: .bottom)
    }
}

// MARK: - Extension for UITableViewDelegate, UITableViewDataSource
extension SettingCompanyMapViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.companyLocationModel.searchedAddress.address.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCompanyAddressCell", for: indexPath) as! SettingCompanyAddressCell
        cell.setCell(
            self.companyLocationModel.searchedAddress.address[indexPath.row].placeName == nil ?
            self.companyLocationModel.searchedAddress.address[indexPath.row].roadAddress == nil ?
            self.companyLocationModel.searchedAddress.address[indexPath.row].jibeonAddress :
                self.companyLocationModel.searchedAddress.address[indexPath.row].roadAddress :
                self.companyLocationModel.searchedAddress.address[indexPath.row].placeName,
             
             address: self.companyLocationModel.searchedAddress.address[indexPath.row].placeName == nil ?
             self.companyLocationModel.searchedAddress.address[indexPath.row].roadAddress == nil ? "(도로명 주소 없음)" :
             self.companyLocationModel.searchedAddress.address[indexPath.row].jibeonAddress :
             self.companyLocationModel.searchedAddress.address[indexPath.row].roadAddress == nil ? self.companyLocationModel.searchedAddress.address[indexPath.row].jibeonAddress :
             self.companyLocationModel.searchedAddress.address[indexPath.row].roadAddress
        )
        
        if indexPath.row == self.companyLocationModel.searchedAddress.address.count - 1,
           !self.companyLocationModel.searchedAddress.isEnd {
            SupportingMethods.shared.turnCoverView(.on, on: self.view)
            
            self.companyLocationModel.searchingPage += 1
            self.companyLocationModel.searchAddressWithText(self.searchBarTextField.text!) {
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
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.moveTableBaseViewToTop(movingType: .bottom)
        
        if let latitude = Double(self.companyLocationModel.searchedAddress.address[indexPath.row].latitude),
           let longitude = Double(self.companyLocationModel.searchedAddress.address[indexPath.row].longitude) {
            
            let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.setPointAnnotation(center: center, title:
                self.companyLocationModel.searchedAddress.address[indexPath.row].placeName ??
                self.companyLocationModel.searchedAddress.address[indexPath.row].roadAddress ??
                self.companyLocationModel.searchedAddress.address[indexPath.row].jibeonAddress!,
            address:
                self.companyLocationModel.searchedAddress.address[indexPath.row].roadAddress ??
                self.companyLocationModel.searchedAddress.address[indexPath.row].jibeonAddress!)
            self.setRegion(center: center)
        }
    }
}
