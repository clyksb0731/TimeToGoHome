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

    // Instead of navigation bar line
//    var topLineView: UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor.useRGB(red: 151, green: 151, blue: 151, alpha: 0.3)
//        view.translatesAutoresizingMaskIntoConstraints = false
//
//        return view
//    }()
    
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
    
    var address: CompanyAddressResponse.Document!
    
    var apiRequest: DataRequest!
    
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
        
        self.setPointAnnotation(center: self.initializeCenter().0, title: self.initializeCenter().1)
        self.setRegion(center: self.initializeCenter().0)
    }
    
    deinit {
            print("----------------------------------- CompanyMapViewController disposed -----------------------------------")
    }
}

// MARK: - Extension for override methods
extension CompanyMapViewController {
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
}

// MARK: - Extension for essential methods
extension CompanyMapViewController {
    // Set view foundation
    func setViewFoundation() {
        self.view.backgroundColor = .white
        
        //self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.setNavigationBarHidden(false, animated: true);
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.useRGB(red: 0, green: 0, blue: 0),
                                                                        .font:UIFont.systemFont(ofSize: 18, weight: .medium)]
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
            //self.topLineView,
            self.mapView,
            self.currentLocationButton
        ], to: self.view)
    }
    
    // Set layouts
    func setLayouts() {
        let safeArea: UILayoutGuide = self.view.safeAreaLayoutGuide
        
//        // Top line view layout
//        NSLayoutConstraint.activate([
//            self.topLineView.topAnchor.constraint(equalTo: safeArea.topAnchor),
//            self.topLineView.heightAnchor.constraint(equalToConstant: 0.5),
//            self.topLineView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
//            self.topLineView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
//        ])
        
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
    func initializeCenter() -> (CLLocationCoordinate2D, String) {
        let center = CLLocationCoordinate2D(latitude: Double(self.address.latitude)!, longitude: Double(self.address.longitude)!)
        
        return (center, self.address.addressName)
    }
    
    func setPointAnnotation(center: CLLocationCoordinate2D, title: String) {
        let pin = MKPointAnnotation()
        pin.coordinate = center
        pin.title = title
        self.mapView.addAnnotation(pin)
    }
    
    func setRegion(center: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 300, longitudinalMeters: 300)
        self.mapView.setRegion(region, animated: true)
    }
    
    func findAddressWitdhCenter(_ center: CLLocationCoordinate2D) {
        let parameters: Parameters = ["x":String(center.longitude), "y":String(center.latitude)]
        
        self.apiRequest = AF.request("https://dapi.kakao.com/v2/local/geo/coord2address.json", method: .get, parameters: parameters, encoding: URLEncoding.default, headers: ["Authorization":ReferenceValues.kakaoAuthKey])
        
        self.apiRequest.responseData { (response) in
            switch response.result {
            case .success(let data):
                if let companyMapResponse = try? JSONDecoder().decode(CompanyMapResponse.self, from:data) {
                    print("Map Address: \(companyMapResponse)")
                    if let jibeonAddress = companyMapResponse.documents.first?.address?.addressName,
                       let roadAddress = companyMapResponse.documents.first?.roadAddress?.addressName {
                        let alertVC = CompanyLocationAlertViewController(.companyLocationMap(jibeon: jibeonAddress, road: roadAddress)) {
                            self.mapView.removeAnnotations(self.mapView.annotations)
                            
                            self.setPointAnnotation(center: center, title: jibeonAddress)
                        }

                        self.present(alertVC, animated: false, completion: nil)
                        
                    } else if let jibeonAddress = companyMapResponse.documents.first?.address?.addressName {
                        let alertVC = CompanyLocationAlertViewController(.companyLocationMap(jibeon: jibeonAddress, road: "")) {
                            self.mapView.removeAnnotations(self.mapView.annotations)
                            
                            self.setPointAnnotation(center: center, title: jibeonAddress)
                        }
                        
                        self.present(alertVC, animated: false, completion: nil)
                        
                    } else if let roadAddress = companyMapResponse.documents.first?.roadAddress?.addressName {
                        let alertVC = CompanyLocationAlertViewController(.companyLocationMap(jibeon: "", road: roadAddress)) {
                            self.mapView.removeAnnotations(self.mapView.annotations)
                            
                            self.setPointAnnotation(center: center, title: roadAddress)
                        }
                        
                        self.present(alertVC, animated: false, completion: nil)
                    }
                }
                
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - Extension for Selector methods
extension CompanyMapViewController {
    @objc func leftBarButtonItem(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func rightBarButtonItem(_ sender: UIBarButtonItem) {
        // right bar button
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
            
            self.findAddressWitdhCenter(newCenter)
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
