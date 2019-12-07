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
    func checkClosestPlace()
    
    func searchPlacesByName(_ name: String)
    
    var navigationDelegate: DiscoveryViewModelNavigationDelegate? { get set }
    var delegate: DiscoveryVMDelegate? { get set }
    var currentLocation: Observable<Location?> { get }
    var currentCity: Observable<String> { get }
    var activePlace: PlaceInfo? { get }
    var isSearching: Bool { get }
    var isSpalshEnded: Bool { get }
    
    func mapButtonPressed()
    func menuButtonPressed()
    func locationLablePressed()
    func searchPlacePressed()
    func searchEnded()
    func splashEnded()
}

protocol DiscoveryVMDelegate: class {
    func reloadData()
    func allPlacesArrived()
    func askIfUserIsInThisPlace(_ place: PlaceInfo)
    func showContentWithAnimation()
}

protocol DiscoveryViewModelNavigationDelegate: class {
    func mapButtonPressed(places: [PlaceInfo])
    func menuButtonPressed(with places: [PlaceInfo])
    func placeCellDetailsPressed(_ place: PlaceInfo)
    func placeCellIconPressed(_ place: PlaceInfo)
    func activePlaceWasSet(_ activePlace: PlaceInfo?)
    func register(_ allPlaces: [PlaceInfo])
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
    var isSearching = false
    var isSpalshEnded = false
    
    init(placesInteractor: PlacesInteractorType, locationProvider: LocationProviderType) {
        self.locationProvider = locationProvider
        self.placesInteractor = placesInteractor
        self.placesInteractor.getAllPlaces()
        bindPlaces()
        bindLocationProvider()
    }
    
    private func bindPlaces() {
        placesInteractor.allPlaces.bind {[weak self] places in
            guard let self = self else { return }
            let isFirstTimePlacesArrived = self.placesArrivedForTheFirstTime()
            self.allPlaces = places
            self.sortAllPlacesByDistance()
            self.delegate?.allPlacesArrived()
            if isFirstTimePlacesArrived {
                self.delegate?.showContentWithAnimation()
            }
            self.navigationDelegate?.register(places)
        }
    }
    
    private func placesArrivedForTheFirstTime() -> Bool {
        return allPlaces.isEmpty
    }
    
    private func bindLocationProvider() {
        locationProvider.dizzyLocation.bind { [weak self] location in
            self?.currentLocation.value = location
            guard location != nil else { return }
            self?.askForCurrentAddress()
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
        
        placesToDisplay.value = allPlaces
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfItemsForSection(_ section: Int) -> Int {
        return placesToDisplay.value.count
    }
    
    func itemForIndexPath(_ indexPath: IndexPath) -> PlaceInfo {
        return placesToDisplay.value[indexPath.row]
    }
    
    func mapButtonPressed() {
        navigationDelegate?.mapButtonPressed(places: allPlaces)
    }
    
    func menuButtonPressed() {
        self.navigationDelegate?.menuButtonPressed(with: allPlaces)
    }
    
    func placeCellDetailsPressed(atIndexPath indexPath: IndexPath) {
        navigationDelegate?.placeCellDetailsPressed(placesToDisplay.value[indexPath.row])
    }
    
    func placeCellIconPressed(atIndexPath indexPath: IndexPath) {
        navigationDelegate?.placeCellIconPressed(placesToDisplay.value[indexPath.row])
    }

    func locationLablePressed() {
        locationProvider.requestUserLocation()
    }
    
    func checkClosestPlace() {
        guard let currentLocation = currentLocation.value,
            !placesToDisplay.value.isEmpty else {
            return
        }
        
        let closestPlace = placesToDisplay.value[0]
        let distanceToPlaceInMeters = currentLocation.getDistanceTo(closestPlace.location, inScaleOf: .meters)
        
        if distanceToPlaceInMeters < maxMetersFromPlaceToVisit {
            self.delegate?.askIfUserIsInThisPlace(closestPlace)
        } else {
            self.navigationDelegate?.activePlaceWasSet(nil)
        }
    }
    
    func userApprovedHeIsIn(place activePlace: PlaceInfo) {
        self.activePlace = activePlace
        placesInteractor.increment(analyticsType: .attendence, by: 1, to: activePlace)
        self.navigationDelegate?.activePlaceWasSet(activePlace)
    }
    
    func userDeclinedHeIsInPlace() {
        navigationDelegate?.activePlaceWasSet(nil)
    }
    
    func searchPlacesByName(_ name: String) {
        if name.isEmpty {
            placesToDisplay.value = allPlaces
            self.delegate?.reloadData()
            return
        }
        
        self.placesToDisplay.value = allPlaces.filter({ place in
            return place.name.uppercased().contains(name.uppercased())
        })
        self.delegate?.reloadData()
    }
    
    func searchPlacePressed() {
        isSearching = true
    }
    
    func searchEnded() {
        isSearching = false
    }
    
    func splashEnded() {
        isSpalshEnded = true
    }
}
