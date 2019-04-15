//
//  PlacesInteractor.swift
//  Dizzy
//
//  Created by Menashe, Or on 10 Nisan 5779.
//  Copyright © 5779 Dizzy. All rights reserved.
//

import UIKit

protocol PlacesInteractorDelegate: class {
    func allPlacesArrived(places: [PlaceInfo])
}

protocol PlacesInteractorType {
    var delegate: PlacesInteractorDelegate? { get set }
    func getAllPlaces()
}

class PlacesInteractor: PlacesInteractorType {
    weak var delegate: PlacesInteractorDelegate?
    private let webResourcesDispatcher: WebServiceDispatcherType
    
    init(webResourcesDispatcher: WebServiceDispatcherType) {
        self.webResourcesDispatcher = webResourcesDispatcher
    }
    
    public func getAllPlaces() {
        let placesResource = Resource<[PlaceInfo], String>(path: "")
    }
    
}
