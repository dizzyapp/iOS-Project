//
//  MapVM.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 10/04/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import Foundation

protocol MapVMType {

    var currentAddress: Observable<Address?> { get set }
    var selectedLocation: Observable<Location?> { get set }
    var marks: Observable<[Marks?]> { get set }
    var showCancelLocationSelection: Observable<Bool> { get set }

    var delegate: MapVMDelegate? { get set }
    
    func searchButtonPressed()
    func didSelect(place: PlaceInfo)
    func returnMapToInitialState()
    func close()
}

protocol MapVMDelegate: class {
    func searchButtonPressed()
    func closeButtonPressed()
}

final class MapVM: MapVMType {
    
    private var locationProvider: LocationProviderType
    private var places: [PlaceInfo]
    private var currentLocation: Location?
    
    var currentAddress = Observable<Address?>(nil)
    var selectedLocation = Observable<Location?>(nil)
    var marks = Observable<[Marks?]>(nil)
    var showCancelLocationSelection = Observable<Bool>(false)
    
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
                self.currentLocation = location
            } else {
                self.currentLocation = Location(latitude: -33.86, longitude: 151.20)
            }
            
            self.selectedLocation.value = self.currentLocation
            self.getAddress()
            self.setMarks(from: self.places)
        }
    }
    
    private func getAddress() {
        selectedLocation.value??.getCurrentAddress(completion: { (address) in
            guard let address = address else {
                print("Fail to get address")
                return
            }
            self.currentAddress.value = address
        })
    }
    
    private func setMarks(from places: [PlaceInfo]) {
        marks.value = places.map { return Marks(title: $0.name, snippet: $0.address, location: $0.location, displayView: PlaceMarkerView(imageURL: $0.imageURLString)) }
    }
    
    func close() {
        delegate?.closeButtonPressed()
    }
    
    func searchButtonPressed() {
        delegate?.searchButtonPressed()
    }
    
    func didSelect(place: PlaceInfo) {
        selectedLocation.value = place.location
        getAddress()
        showCancelLocationSelection.value = true
    }
    
    func returnMapToInitialState() {
        selectedLocation.value = currentLocation
        getAddress()
        showCancelLocationSelection.value = false
    }
}
