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
    var navigationDelegate: DiscoveryViewModelNavigationDelegate? { get set }
    var delegate: DiscoveryViewModelDelegate? { get set }
    
    func mapButtonPressed()
}

protocol DiscoveryViewModelDelegate: class {
    func reloadData()
}

protocol DiscoveryViewModelNavigationDelegate: class {
    func mapButtonPressed(places: [PlaceInfo])
    func menuButtonPressed()
}

class DiscoveryViewModel: DiscoveryViewModelType {
    weak var delegate: DiscoveryViewModelDelegate?
    var placesToDisplay = Observable<[PlaceInfo]>()
    private var allPlaces = [PlaceInfo]()
    private var placesInteractor: PlacesInteractorType
    weak var navigationDelegate: DiscoveryViewModelNavigationDelegate?
    
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
    }
    
    func mapButtonPressed() {
        navigationDelegate?.mapButtonPressed(places: allPlaces)
    }
}

extension DiscoveryViewModel: PlacesInteractorDelegate {
    func allPlacesArrived(places: [PlaceInfo]) {
        allPlaces = places
        delegate?.reloadData()
    }
}
