//
//  LocationProvider.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 10/04/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationProviderType {
    var locationManager: CLLocationManager { get }
    var locationServicesEnabled: Bool { get }
    var authorizationStatus: CLAuthorizationStatus { get }
    var isAuthorized: Bool { get }
    var locationServiceDidGetLocation: ((Error?) -> Void)? { get set }
    var currentLocation: CLLocation? { get }
    
    func notifyCompletion(with error: Error?)
    func requestUserLocation()
}

struct Location {
    var latitude: Double
    var longitude: Double
}

final class LocationProvider: NSObject, LocationProviderType {
    
    var currentLocation: CLLocation?
    
    var dizzyLocation: Location? {
        guard let coordinate = currentLocation?.coordinate else { return nil }
        let location = Location(latitude: coordinate.latitude, longitude: coordinate.longitude)
        return location
    }
    
    var locationManager: CLLocationManager
    
    var locationServicesEnabled: Bool {
        return CLLocationManager.locationServicesEnabled()
    }
    
    var authorizationStatus: CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
    
    var isAuthorized: Bool {
        return CLLocationManager.authorizationStatus() == .authorizedWhenInUse
    }
    
    override init() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        super.init()
        locationManager.delegate = self
    }
    
    var locationServiceDidGetLocation: ((Error?) -> Void)?
    
    func requestUserLocation() {
        if !locationServicesEnabled { return }
        if authorizationStatus == .authorizedWhenInUse {
            locationManager.requestLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func notifyCompletion(with error: Error?) {
        locationServiceDidGetLocation?(error)
        locationServiceDidGetLocation = nil
    }
}

extension LocationProvider: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) { }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.first else {
            return
        }
        currentLocation = location
        notifyCompletion(with: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        notifyCompletion(with: error)
    }
}
