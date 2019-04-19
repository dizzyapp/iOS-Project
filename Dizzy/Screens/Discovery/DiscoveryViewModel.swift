//
//  DiscoveryViewModel.swift
//  Dizzy
//
//  Created by Or Menashe on 01/04/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

protocol DiscoveryViewModelType {
    func numberOfSections() -> Int
    func numberOfItemsForSection(_ section: Int) -> Int
    func itemForIndexPath(_ indexPath: IndexPath) -> PlaceInfo
    var delegate: DiscoveryViewModelDelegate? { get set }
    
    func mapButtonPressed()
}

protocol DiscoveryViewModelDelegate: class {
    func mapButtonPressed()
    func menuButtonPressed()
}

class DiscoveryViewModel: DiscoveryViewModelType {
    private var allPlaces = [PlaceInfo]()
    private var placesInteractor: PlacesInteractorType
    weak var delegate: DiscoveryViewModelDelegate?
    
    init(placesInteractor: PlacesInteractorType) {
        self.placesInteractor = placesInteractor
        self.placesInteractor.delegate = self
        self.placesInteractor.getAllPlaces()
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfItemsForSection(_ section: Int) -> Int {
        return allPlaces.count
    }
    
    func itemForIndexPath(_ indexPath: IndexPath) -> PlaceInfo {
        return allPlaces[indexPath.row]
        return PlaceInfo(name: "name", address: "address", position: "position", location: Location(  latitude: 0, longitude: 0))
    }
    
    func mapButtonPressed() {
        delegate?.mapButtonPressed()
    }
}

extension DiscoveryViewModel: PlacesInteractorDelegate {
    func allPlacesArrived(places: [PlaceInfo]) {
        allPlaces = places
        
    }
}
