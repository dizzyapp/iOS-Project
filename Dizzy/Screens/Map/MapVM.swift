//
//  MapVM.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 10/04/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import Foundation

protocol MapVMType {
    var currentLocation: Observable<Location?> { get set }
    var currentAddress: Observable<Address?> { get set }
    var delegate: MapVMDelegate? { get set }
    
    func getAllMarks() -> [Marks]
    func close()
}

protocol MapVMDelegate: class {
    func closeButtonPressed()
}

final class MapVM: MapVMType {
    
    private var locationProvider: LocationProviderType
    private var places: [PlaceInfo]
    
    var currentLocation = Observable<Location?>(Location(latitude: -33.86, longitude: 151.20))
    var currentAddress = Observable<Address?>(nil)
    
    weak var delegate: MapVMDelegate?
    
    init(places: [PlaceInfo], locationProvider: LocationProviderType) {
        self.locationProvider = locationProvider
        self.places = places
        getCurrentLocation()
    }
    
    private func getCurrentLocation() {
        locationProvider.requestUserLocation()
        locationProvider.onLocationArrived = { [weak self] location in
            guard let self = self else { return }
            if self.locationProvider.isAuthorized {
                self.currentLocation.value = location
                self.getAddress()
            } else {
                self.currentLocation.value = Location(latitude: -33.86, longitude: 151.20)
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
    
    func getAllMarks() -> [Marks] {
        return places.map { return Marks(title: $0.name, snippet: $0.address, location: $0.location) }
    }
    
    func close() {
        delegate?.closeButtonPressed()
    }
}
