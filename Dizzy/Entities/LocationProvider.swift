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
    var locationServicesEnabled: Bool { get }
    var isAuthorized: Bool { get }
    var dizzyLocation: Observable<Location?> { get }

    func requestUserLocation()
}

final class LocationProvider: NSObject, LocationProviderType {
    
    private var currentLocation: CLLocation?
    
    var dizzyLocation = Observable<Location?>(nil)
    
    private var locationManager: CLLocationManager
    
    var locationServicesEnabled: Bool {
        return CLLocationManager.locationServicesEnabled()
    }
    
    private var authorizationStatus: CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
    
    var isAuthorized: Bool {
        return CLLocationManager.authorizationStatus() == .authorizedWhenInUse
    }
    
    var onLocationArrived: ((Location?) -> Void)?
    
    override init() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        super.init()
        locationManager.delegate = self
    }
    
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
            guard error == nil else {
                print("could not get current address")
                completion(nil)
                return
            }

            if let place = placeMarks?.first {
                let address = Address(country: place.country ?? "", city: place.subLocality ?? "", street: place.thoroughfare ?? "")
                completion(address)
            }
        }
    }

    private func setupDizzyLocation() {
        guard let coordinate = currentLocation?.coordinate else { return }
        let location = Location(latitude: coordinate.latitude, longitude: coordinate.longitude)

        dizzyLocation.value = location
    }
}

extension LocationProvider: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedAlways
            || status == CLAuthorizationStatus.authorizedWhenInUse {
            requestUserLocation()
        } else {
            dizzyLocation.value = nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.first else {
            return
        }
        currentLocation = location
        setupDizzyLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        dizzyLocation.value = nil
    }
}
