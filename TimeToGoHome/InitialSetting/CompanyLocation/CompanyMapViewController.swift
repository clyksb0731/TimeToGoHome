//
//  CompanyMapViewController.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2021/11/26.
//

import UIKit
import MapKit
import Alamofire

class CompanyMapViewController: UIViewController {
    
    var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        return mapView
    }()
    
    var currentLocationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "currentLocationButtonImage"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var currentLocation: CLLocationCoordinate2D!
    
    var address: CompanyAddress.Document!
    var selectedCenter: CLLocationCoordinate2D?
    var selectedAddress: String?
    
    var companyLocationModel: CompanyLocationModel = CompanyLocationModel()
    
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
        
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.setPointAnnotation(center: self.initializeCenter().center, title: self.initializeCenter().address)
        self.setRegion(center: self.initializeCenter().center)
        
        SupportingMethods.shared.makeInstantViewWithText("지도를 길게 눌러서 변경하세요.", duration: 3.5, on: self, withPosition: .top(constant: 30))
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
            print("----------------------------------- CompanyMapViewController disposed -----------------------------------")
    }
}

// MARK: - Extension for essential methods
extension CompanyMapViewController {
    // Set view foundation
    func setViewFoundation() {
        self.view.backgroundColor = .white
        
        self.navigationController?.setNavigationBarHidden(false, animated: true);
        
        self.navigationItem.title = "지도에서 지정"
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
        self.currentLocationButton.addTarget(self, action: #selector(currentLocationButton(_:)), for: .touchUpInside)
    }
    
    // Set gestures
    func setGestures() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture(_:)))
        longPressGesture.minimumPressDuration = 0.5 // default
        self.mapView.addGestureRecognizer(longPressGesture)
    }
    
    // Set delegates
    func setDelegates() {
        self.mapView.delegate = self
    }
    
    // Set notificationCenters
    func setNotificationCenters() {
        
    }
    
    // Set subviews
    func setSubviews() {
        SupportingMethods.shared.addSubviews([
            self.mapView,
            self.currentLocationButton
        ], to: self.view)
    }
    
    // Set layouts
    func setLayouts() {
        let safeArea: UILayoutGuide = self.view.safeAreaLayoutGuide
        
        // Map view layout
        NSLayoutConstraint.activate([
            self.mapView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.mapView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.mapView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
        
        // Current location button layout
        NSLayoutConstraint.activate([
            self.currentLocationButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            self.currentLocationButton.heightAnchor.constraint(equalToConstant: 46),
            self.currentLocationButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            self.currentLocationButton.widthAnchor.constraint(equalToConstant: 46)
        ])
    }
}

// MARK: - Extension for methods added
extension CompanyMapViewController {
    func initializeCenter() -> (center: CLLocationCoordinate2D, address: String) {
        if let selectedCenter = self.selectedCenter, let selectedAddress = self.selectedAddress {
            let center = CLLocationCoordinate2D(latitude: selectedCenter.latitude, longitude: selectedCenter.longitude)
            
            return (center, selectedAddress)
            
        } else {
            let center = CLLocationCoordinate2D(latitude: Double(self.address.latitude)!, longitude: Double(self.address.longitude)!)
            
            return (center, self.address.addressName)
        }
    }
    
    func setPointAnnotation(center: CLLocationCoordinate2D, title: String) {
        let pin = MKPointAnnotation()
        pin.coordinate = center
        pin.title = title
        self.mapView.addAnnotation(pin)
        
        self.selectedCenter = center
        self.selectedAddress = title
    }
    
    func setRegion(center: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 300, longitudinalMeters: 300)
        self.mapView.setRegion(region, animated: true)
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
extension CompanyMapViewController {
    @objc func leftBarButtonItem(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func rightBarButtonItem(_ sender: UIBarButtonItem) {
        guard let selectedCenter = self.selectedCenter, let selectedAddress = self.selectedAddress else {
            return
        }
        
        let detailCompanyAddressVC = CompanyDetailedAddressViewController(selectedCenter: selectedCenter, selectedAddress: selectedAddress)
        
        self.navigationController?.pushViewController(detailCompanyAddressVC, animated: true)
    }
    
    @objc func currentLocationButton(_ sender: UIButton) {
        guard let currentLocation = self.currentLocation else {
            return
        }
        
        let region = MKCoordinateRegion(center: currentLocation, latitudinalMeters: 300, longitudinalMeters: 300)
        
        self.mapView.setRegion(region, animated: true)
    }
    
    @objc func longPressGesture(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let gesturedPoint = gesture.location(in: self.mapView)
            let newCenter = self.mapView.convert(gesturedPoint, toCoordinateFrom: self.mapView)
            
            self.findAddressWithCenter(newCenter)
            
            UIDevice.lightHaptic()
        }
    }
}

// MARK: - Extension for MKMapViewDelegate
extension CompanyMapViewController: MKMapViewDelegate {
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
