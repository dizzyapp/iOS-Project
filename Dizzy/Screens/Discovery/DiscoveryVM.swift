//
//  DiscoveryViewModel.swift
//  Dizzy
//
//  Created by Or Menashe on 01/04/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

protocol DiscoveryVMType {
    func numberOfSections() -> Int
    func numberOfItemsForSection(_ section: Int) -> Int
    func itemForIndexPath(_ indexPath: IndexPath) -> PlaceInfo
    var navigationDelegate: DiscoveryViewModelNavigationDelegate? { get set }
    var delegate: DiscoveryVMDelegate? { get set }
    var currentLocation: Observable<Location?> { get }
    var currentCity: Observable<String> { get }
    
    func mapButtonPressed()
}

protocol DiscoveryVMDelegate: class {
    func reloadData()
}

protocol DiscoveryViewModelNavigationDelegate: class {
    func mapButtonPressed(places: [PlaceInfo])
    func menuButtonPressed()
}

class DiscoveryVM: DiscoveryVMType {
    
    weak var delegate: DiscoveryVMDelegate?
    var placesToDisplay = Observable<[PlaceInfo]>([])
    var currentLocation = Observable<Location?>(nil)
    private var allPlaces = [PlaceInfo]()
    private var placesInteractor: PlacesInteractorType
    private let locationProvider: LocationProviderType
    var currentCity = Observable<String>("")
    weak var navigationDelegate: DiscoveryViewModelNavigationDelegate?
    
    init(placesInteractor: PlacesInteractorType, locationProvider: LocationProviderType) {
        self.locationProvider = locationProvider
        self.placesInteractor = placesInteractor
        self.placesInteractor.delegate = self
        self.placesInteractor.getAllPlaces()
        locationProvider.requestUserLocation()
        bindLocationProvider()
    }
    
    private func bindLocationProvider() {
        locationProvider.dizzyLocation.bind { [weak self] location in
            self?.askForCurrentAddress()
            self?.currentLocation.value = location
            self?.sortAllPlacesByDistance()
            self?.delegate?.reloadData()
        }
    }
    
    private func askForCurrentAddress() {
        self.locationProvider.getCurrentAddress(completion: { [weak self] address in
            guard let city = address?.city,
                !city.isEmpty else {
                    self?.currentCity.value = "No Gps"
                    return
            }
            
            self?.currentCity.value = city
        })
    }
    
    func sortAllPlacesByDistance() {
        guard let currentLocation = currentLocation.value else {
            print("cant sort without current location")
            return
        }
        allPlaces = allPlaces.sorted(by: { place1, place2 in
            let distanceToPlace1 = currentLocation.getDistanceTo(place1.location)
            let distanceToPlace2 = currentLocation.getDistanceTo(place2.location)
            return distanceToPlace1 < distanceToPlace2
        })
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfItemsForSection(_ section: Int) -> Int {
        return allPlaces.count
    }
    
    func itemForIndexPath(_ indexPath: IndexPath) -> PlaceInfo {
        return allPlaces[indexPath.row]
    }
    
    func mapButtonPressed() {
        navigationDelegate?.mapButtonPressed(places: allPlaces)
    }
}

extension DiscoveryVM: PlacesInteractorDelegate {
    func allPlacesArrived(places: [PlaceInfo]) {
        allPlaces = places
        sortAllPlacesByDistance()
        delegate?.reloadData()
    }
}
