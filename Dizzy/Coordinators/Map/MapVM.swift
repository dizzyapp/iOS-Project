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
    var zoom: Float { get }

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

    weak var delegate: MapVMDelegate?

    var zoom: Float {
        if currentLocation.value?.latitude == selectedLocation.value?.latitude &&
            currentLocation.value?.longitude == selectedLocation.value?.longitude {
            return 13
        } else {
            return 16
        }
    }
    
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
                self.setMyPlaceMark()
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
        marks.value = places.map({ place -> Mark in
            let placeImageView = PlaceImageView()
            
            if let url = URL(string: place.imageURLString ?? "") {
                placeImageView.setImage(from: url)
            }
            
            let mark = Mark(title: place.name, snippet: place.description, location: place.location, displayView: placeImageView)
            return mark
        })
    }
    
    private func setMyPlaceMark() {
        if let currentLocation = currentLocation.value {
           let mark = Mark(title: "Me".localized, snippet: "", location: currentLocation, displayView: nil)
            marks.value = [mark]
        }
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
    }

    func resetMapToInitialState() {
        selectedLocation.value = currentLocation.value
        getCurrentAddress()
    }
}
