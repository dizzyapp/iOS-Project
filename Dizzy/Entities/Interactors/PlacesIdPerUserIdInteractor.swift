//
//  PlacesIdPerUserIdInteractor.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 10/11/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import Foundation

protocol PlacesIdPerUserIdInteractorDelegate: class {
    func placesIdPerUserIdFinished(_ interactor: PlacesIdPerUserIdInteractorType,with places: [PlaceId])
}

protocol PlacesIdPerUserIdInteractorType {
    func fetchPlaceIds(per userId: String)
    var delegate: PlacesIdPerUserIdInteractorDelegate? { get set }
}

final class PlacesIdPerUserIdInteractor: PlacesIdPerUserIdInteractorType {
    
    weak var delegate: PlacesIdPerUserIdInteractorDelegate?
    private var webServiceDispacher: WebServiceDispatcherType
    
    init(webServiceDispacher: WebServiceDispatcherType) {
        self.webServiceDispacher = webServiceDispacher
    }
    
    func fetchPlaceIds(per userId: String) {
        let resource = Resource<[PlaceId], String>(path: "PlaceIdPerUserId/\(userId)").withGet()
        webServiceDispacher.load(resource) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let placesIds):
                self.delegate?.placesIdPerUserIdFinished(self, with: placesIds)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
