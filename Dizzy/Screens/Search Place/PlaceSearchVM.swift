//
//  PlaceSearchVM.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 22/04/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import Foundation

protocol PlaceSearchVMType {
    var delegate: PlaceSearchVMDelegate? { get set }
    var currentLocation: Observable<Location?> { get }

    
    func numberOfRowsInSection() -> Int
    func itemAt(_ indexPath: IndexPath) -> PlaceInfo
    func didSelectRowAt(_ indexPath: IndexPath) 
    func filter(filterString: String)
    func closeButtonPressed()
}

protocol PlaceSearchVMDelegate: class {
    func didSelect(place: PlaceInfo)
    func cancelButtonPressed()
}

final class PlaceSearchVM: PlaceSearchVMType {
    
    weak var delegate: PlaceSearchVMDelegate?
    var currentLocation = Observable<Location?>(nil)
    private let locationProvider: LocationProviderType
    let autoCompleteFilter = AutoCompleteFilter<PlaceInfo>(fullEntryList: [PlaceInfo]())
    
    init(places: [PlaceInfo], locationProvider: LocationProviderType) {
        autoCompleteFilter.fullEntryList = places
        self.locationProvider = locationProvider
        locationProvider.requestUserLocation()
        bindLocationProvider()
    }
    
    private func bindLocationProvider() {
        locationProvider.dizzyLocation.bind { [weak self] location in
            self?.currentLocation.value = location
        }
    }
    
    func closeButtonPressed() {
       delegate?.cancelButtonPressed()
    }
    
    func numberOfRowsInSection() -> Int {
        return autoCompleteFilter.filteredEntryList.count
    }

    func itemAt(_ indexPath: IndexPath) -> PlaceInfo {
        return autoCompleteFilter.filteredEntryList[indexPath.row]
    }

    func didSelectRowAt(_ indexPath: IndexPath) {
        delegate?.didSelect(place: autoCompleteFilter.filteredEntryList[indexPath.row])
    }

    func filter(filterString: String) {
        autoCompleteFilter.filter(by: .startsWith, filterString: filterString)
    }
}
