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
    
    func placeCellDetailsPressed(atIndexPath indexPath: IndexPath)
    func placeCellIconPressed(atIndexPath indexPath: IndexPath)
    
    func userApprovedHeIsIn(place activePlace: PlaceInfo)
    func userDeclinedHeIsInPlace()
    
    var navigationDelegate: DiscoveryViewModelNavigationDelegate? { get set }
    var delegate: DiscoveryVMDelegate? { get set }
    var currentLocation: Observable<Location?> { get }
    var currentCity: Observable<String> { get }
    var activePlace: PlaceInfo? { get }
    
    func mapButtonPressed()
    func menuButtonPressed()
    func locationLablePressed()
}

protocol DiscoveryVMDelegate: class {
    func reloadData()
    func allPlacesArrived()
    func askIfUserIsInThisPlace(_ place: PlaceInfo)
}

protocol DiscoveryViewModelNavigationDelegate: class {
    func mapButtonPressed(places: [PlaceInfo])
    func menuButtonPressed()
    func placeCellDetailsPressed(_ place: PlaceInfo)
    func placeCellIconPressed(_ place: PlaceInfo)
    func activePlaceWasSet(_ activePlace: PlaceInfo?)
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
    private let maxMetersFromPlaceToVisit: Double = 50
    var activePlace: PlaceInfo?
    
    init(placesInteractor: PlacesInteractorType, locationProvider: LocationProviderType) {
        self.locationProvider = locationProvider
        self.placesInteractor = placesInteractor
        self.placesInteractor.delegate = self
        self.placesInteractor.getAllPlaces()

        bindLocationProvider()
    }
    
    private func bindLocationProvider() {
        locationProvider.dizzyLocation.bind { [weak self] location in
            self?.askForCurrentAddress()
            self?.currentLocation.value = location
            self?.sortAllPlacesByDistance()
            self?.checkClosestPlace()
            self?.delegate?.reloadData()
        }
    }
    
    private func askForCurrentAddress() {
        self.locationProvider.getCurrentAddress(completion: { [weak self] address in
            guard let city = address?.city,
                !city.isEmpty else {
                    self?.currentCity.value = "No GPS".localized
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
    
    func menuButtonPressed() {
        self.navigationDelegate?.menuButtonPressed()
    }
    
    func placeCellDetailsPressed(atIndexPath indexPath: IndexPath) {
        navigationDelegate?.placeCellDetailsPressed(allPlaces[indexPath.row])
    }
    
    func placeCellIconPressed(atIndexPath indexPath: IndexPath) {
        navigationDelegate?.placeCellIconPressed(allPlaces[indexPath.row])
    }

    func locationLablePressed() {
        locationProvider.requestUserLocation()
    }
    
    private func checkClosestPlace() {
        guard let currentLocation = currentLocation.value,
            !allPlaces.isEmpty else {
            return
        }
        
        let closestPlace = allPlaces[0]
        let distanceToPlaceInMeters = currentLocation.getDistanceTo(closestPlace.location, inScaleOf: .meters)
        
        if distanceToPlaceInMeters < maxMetersFromPlaceToVisit {
            self.delegate?.askIfUserIsInThisPlace(closestPlace)
        } else {
            self.navigationDelegate?.activePlaceWasSet(nil)
        }
    }
    
    func userApprovedHeIsIn(place activePlace: PlaceInfo) {
        self.activePlace = activePlace
        self.navigationDelegate?.activePlaceWasSet(activePlace)
    }
    
    func userDeclinedHeIsInPlace() {
        navigationDelegate?.activePlaceWasSet(nil)
    }
}

extension DiscoveryVM: PlacesInteractorDelegate {
    func allPlacesArrived(places: [PlaceInfo]) {
        allPlaces = places
        sortAllPlacesByDistance()
        checkClosestPlace()
        delegate?.allPlacesArrived()
    }
}
