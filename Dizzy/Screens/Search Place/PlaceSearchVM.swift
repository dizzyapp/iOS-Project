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
    func itemAt(_ indexPath: IndexPath) -> NearByDataType
    func didSelectPlace(withId placeId: String)
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

    func itemAt(_ indexPath: IndexPath) -> NearByDataType {
        let discoveryPlaceCellViewModel = DiscoveryPlaceCellViewModel(location: nil, place: autoCompleteFilter.filteredEntryList[indexPath.row])
        let type = NearByDataType.place(discoveryPlaceCellViewModel)
        return type
    }

    func didSelectPlace(withId placeId: String) {
        guard let placeInfo = findPlaceById(placeId) else { return }
        delegate?.didSelect(place: placeInfo)
    }

    func filter(filterString: String) {
        autoCompleteFilter.filter(by: .startsWith, filterString: filterString)
    }
    
    func findPlaceById(_ placeId: String) -> PlaceInfo? {
        return autoCompleteFilter.filteredEntryList.filter {  placeInfo in
            return placeInfo.id == placeId
        }.first
    }
}
