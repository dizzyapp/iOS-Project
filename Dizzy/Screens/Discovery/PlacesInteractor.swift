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
    func placesIdsPerUserArrived(placesIds: [PlaceId])
}

protocol PlacesInteractorType {
    var delegate: PlacesInteractorDelegate? { get set }
    func getAllPlaces()
    func getProfileMedia(forPlaceId placeId: String, completion: @escaping  ([PlaceMedia]) -> Void)
    func getPlaces(ownedBy userId: String)
}

class PlacesInteractor: PlacesInteractorType {
    weak var delegate: PlacesInteractorDelegate?
    private let webResourcesDispatcher: WebServiceDispatcherType
    
    init(webResourcesDispatcher: WebServiceDispatcherType) {
        self.webResourcesDispatcher = webResourcesDispatcher
    }
    
    public func getAllPlaces() {
        let placesResource = Resource<[PlaceInfo], String>(path: "places").withGet()
        webResourcesDispatcher.load(placesResource) {[weak self] result in
            switch result {
            case .success( let places):
                self?.delegate?.allPlacesArrived(places: places)
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
    
    public func getProfileMedia(forPlaceId placeId: String, completion: @escaping ([PlaceMedia]) -> Void) {
         let placeMediaResource = Resource<[PlaceMedia], Bool>(path: "profileMediaPerPlaceId/\(placeId)").withGet()
        webResourcesDispatcher.load(placeMediaResource) { result in
            switch result {
            case .success( let profileAllMedia):
                completion(profileAllMedia)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getPlaces(ownedBy userId: String) {
        let resource = Resource<[PlaceId], String>(path: "PlaceIdPerUserId/\(userId)").withGet()
        webResourcesDispatcher.load(resource) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let placesIds):
                self.delegate?.placesIdsPerUserArrived(placesIds: placesIds)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
