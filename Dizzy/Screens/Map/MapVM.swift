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
}

final class MapVM: MapVMType {
    
    let locationProvider = LocationProvider()
    var currentLocation = Observable<Location?>(Location(latitude: -33.86, longitude: 151.20))
    var places: [PlaceInfo]
    
    init(places: [PlaceInfo]) {
        self.places = places
        getCurrentLocation()
    }
    
    private func getCurrentLocation() {
        locationProvider.requestUserLocation()
        locationProvider.locationServiceDidGetLocation = { [weak self] maybeError in
            guard let self = self else { return }
            self.currentLocation.value = self.locationProvider.dizzyLocation
        }
    }
}
