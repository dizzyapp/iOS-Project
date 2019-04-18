//
//  MapVM.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 10/04/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import Foundation

protocol MapVMType {
    var locationProvider: LocationProvider { get }
    var currentLocation: Observable<Location?> { get set }
    var places: [PlaceInfo] { get }
    var currentAddress: Observable<Address?> { get set }
    var delegate: MapVMDelegate? { get set }
    
    func close()
}

protocol MapVMDelegate: class {
    func closeButtonPressed()
}

final class MapVM: MapVMType {
    let locationProvider = LocationProvider()
    var currentLocation = Observable<Location?>(Location(latitude: -33.86, longitude: 151.20))
    var currentAddress = Observable<Address?>(nil)
    var places: [PlaceInfo]
    
    weak var delegate: MapVMDelegate?
    
    init(places: [PlaceInfo]) {
        self.places = places
        getCurrentLocation()
    }
    
    private func getCurrentLocation() {
        locationProvider.requestUserLocation()
        locationProvider.locationServiceDidGetLocation = { [weak self] maybeError in
            guard let self = self else { return }
            if self.locationProvider.authorizationStatusFail {
                self.currentLocation.value = Location(latitude: -33.86, longitude: 151.20)
            } else {
                self.currentLocation.value = self.locationProvider.dizzyLocation
                self.getAddress()
            }
        }
    }
    
    private func getAddress() {
        locationProvider.getCurrentAddress { (address) in
            guard let address = address else {
                print("Fail to get address")
                return
            }
            
            self.currentAddress.value = address
        }
    }
    
    func close() {
        delegate?.closeButtonPressed()
    }
}
