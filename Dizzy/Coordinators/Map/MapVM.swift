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
    var selectedLocation: Observable<Location?> { get set }
    var marks: Observable<[Mark?]> { get set }
    var showLocationBadge: Observable<Bool> { get set }

    var delegate: MapVMDelegate? { get set }
    
    func searchButtonPressed()
    func didSelect(place: PlaceInfo)
    func resetMapToInitialState()
    func close()
}

protocol MapVMDelegate: class {
    func searchButtonPressed()
    func closeButtonPressed()
}

final class MapVM: MapVMType {
    
    private var locationProvider: LocationProviderType
    private var places: [PlaceInfo]
    
    var currentLocation = Observable<Location?>(Location(latitude: -33.86, longitude: 151.20))
    var currentAddress = Observable<Address?>(nil)
    var selectedLocation = Observable<Location?>(nil)
    var marks = Observable<[Mark?]>([])
    var showLocationBadge = Observable<Bool>(false)

    weak var delegate: MapVMDelegate?
    
    init(places: [PlaceInfo], locationProvider: LocationProviderType) {
        self.locationProvider = locationProvider
        self.places = places
        self.setMarks(from: self.places)
        observeLocation()
    }
    
    private func observeLocation() {
        locationProvider.dizzyLocation.bind(shouldObserveIntial: true) { [weak self] location in
            guard let self = self else { return }
            if location != nil {
                self.currentLocation.value = location
            } else {
                self.currentLocation.value = Location(latitude: -33.86, longitude: 151.20)
            }

            self.selectedLocation.value = self.currentLocation.value
            self.getCurrentAddress()
        }
    }
    
    private func getCurrentAddress() {
        selectedLocation.value?.getCurrentAddress(completion: { (address) in
            guard let address = address else {
                print("Fail to get address")
                return
            }
            self.currentAddress.value = address
        })
    }
    
    private func setMarks(from places: [PlaceInfo]) {
        marks.value = places.map { return Mark(title: $0.name, snippet: $0.description, location: $0.location, displayView: PlaceMarkerView(imageURL: $0.imageURLString ?? "")) }
    }
    
    func close() {
        delegate?.closeButtonPressed()
    }

    func searchButtonPressed() {
        delegate?.searchButtonPressed()
    }

    func didSelect(place: PlaceInfo) {
        selectedLocation.value = place.location
        getCurrentAddress()
        showLocationBadge.value = true
    }

    func resetMapToInitialState() {
        selectedLocation.value = currentLocation.value
        getCurrentAddress()
        showLocationBadge.value = false
    }
}
