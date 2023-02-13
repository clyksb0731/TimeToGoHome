//
//  LocationManager.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2021/11/26.
//

import UIKit
import CoreLocation

@objc
protocol LocationManagerDelegate: NSObjectProtocol {
    @objc optional func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    @objc optional func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion)
    @objc optional func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion)
}

class LocationManager: NSObject {
    static let shared: LocationManager = LocationManager()
    
    let locationManager: CLLocationManager = CLLocationManager()
    
    private var delegates: [LocationManagerDelegate] = []
    
    var companyRegion: CLCircularRegion?
    
    private override init() {
        super.init()
    }
}

// MARK: - Methods added
extension LocationManager {
    func requestAuthorization() {
        if self.locationManager.authorizationStatus != .authorizedAlways &&
            self.locationManager.authorizationStatus != .authorizedWhenInUse {
            
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func addDelegate(_ delegate: LocationManagerDelegate) {
        self.locationManager.delegate = self
        
        self.delegates.append(delegate)
    }
    
    func removeDelegate(_ delegate: LocationManagerDelegate) {
        for i in 0 ..< self.delegates.count {
            if self.delegates[i].isEqual(delegate) {
                self.delegates.remove(at: i)
                break
            }
        }
    }
    
    func startUpdateLocation() {
        self.locationManager.allowsBackgroundLocationUpdates = true
        self.locationManager.pausesLocationUpdatesAutomatically = false
    }
    
    func startMonitorRegion(_ center: CLLocationCoordinate2D) {
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            let region = CLCircularRegion(center: center, radius: CLLocationDistance(5), identifier: "clyksb0731.TimeToGoHome.company")
            region.notifyOnEntry = true
            region.notifyOnExit = true
            
            self.locationManager.startMonitoring(for: region)
            
            print("Start Monitoring region: \(region.identifier)")
        }
        
        self.startUpdateLocation()
    }
    
    func stopMonitorRegion(_ center: CLLocationCoordinate2D) {
        let region = CLCircularRegion(center: center, radius: CLLocationDistance(5), identifier: "clyksb0731.TimeToGoHome.company")
        self.locationManager.stopMonitoring(for: region)
        
        self.locationManager.allowsBackgroundLocationUpdates = false
        self.locationManager.pausesLocationUpdatesAutomatically = true
        
        print("Stop Monitoring region: \(region.identifier)")
    }
}

// MARK: - Extension for CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways:
            print("authorizedAlways")
            
        case .authorizedWhenInUse:
            print("authorizedWhenInUse")
            
        case .denied:
            print("denied")
            
        case .notDetermined:
            print("notDetermined")
            
        case .restricted:
            print("restricted")
            
        @unknown default:
            fatalError()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways:
            print("authorizedAlways")
            
        case .authorizedWhenInUse:
            print("authorizedWhenInUse")
            
        case .denied:
            print("denied")
            
        case .notDetermined:
            print("notDetermined")
            
        case .restricted:
            print("restricted")
            
        @unknown default:
            fatalError()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for delegate in self.delegates {
            delegate.locationManager?(manager, didUpdateLocations: locations)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        /*
         error:
         The error object containing the reason the location or heading could not be retrieved.
         
         Discussion:
         If you do not implement this method, Core Location throws an exception when attempting to use location services.
         The location manager calls this method when it encounters an error trying to get the location or heading data. If the location service is unable to retrieve a location right away, it reports a CLError.Code.locationUnknown error and keeps trying. In such a situation, you can simply ignore the error and wait for a new event. If a heading could not be determined because of strong interference from nearby magnetic fields, this method returns CLError.Code.headingFailure.
         If the user denies your app's use of the location service, this method reports a CLError.Code.denied error. Upon receiving such an error, you should stop the location service.
         */
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Failed to monitor region: \(region?.identifier ?? "no id")")
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        for delegate in self.delegates {
            delegate.locationManager?(manager, didEnterRegion: region)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        for delegate in self.delegates {
            delegate.locationManager?(manager, didExitRegion: region)
        }
    }
}
