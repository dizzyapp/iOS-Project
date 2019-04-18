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
    
    func getCurrentAddress(completion: @escaping (Address?) -> Void)
    func notifyCompletion(with error: Error?)
    func requestUserLocation()
}

struct Location {
    var latitude: Double
    var longitude: Double
}

struct Address {
    var country: String
    var city: String
    var street: String
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
    
    var authorizationStatusFail: Bool {
        return CLLocationManager.authorizationStatus() == .denied ||
                CLLocationManager.authorizationStatus() == .notDetermined ||
                CLLocationManager.authorizationStatus() == .restricted

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
        guard locationServicesEnabled else { return }
        if authorizationStatus == .authorizedWhenInUse {
            locationManager.requestLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func getCurrentAddress(completion: @escaping (Address?) -> Void) {
        
        guard let currentLocation = currentLocation else {
            print("currentLocation no exists")
            completion(nil)
            return
        }
        
        let currentLocale = Locale.current
        CLGeocoder().reverseGeocodeLocation(currentLocation, preferredLocale: currentLocale) { (placeMarks, error) in
            if error == nil {
                if let place = placeMarks?.first {
                    let address = Address(country: place.country ?? "", city: place.subLocality ?? "", street: place.thoroughfare ?? "")
                    completion(address)
                }
            } else {
                return
            }
        }
    }
    
    func notifyCompletion(with error: Error?) {
        locationServiceDidGetLocation?(error)
    }
}

extension LocationProvider: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedAlways
            || status == CLAuthorizationStatus.authorizedWhenInUse {
            requestUserLocation()
        } else {
            notifyCompletion(with: nil)
        }
    }
    
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
