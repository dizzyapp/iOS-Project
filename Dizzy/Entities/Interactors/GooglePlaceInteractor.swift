//
//  GooglePlaceIndicator.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 23/05/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import Foundation

protocol GooglePlaceInteractorType {
    func getGooglePlaceData(placeName: String)
    var delegate: GooglePlaceInteractorDelegate? { get set }
}

protocol GooglePlaceInteractorDelegate: class {
    func googlePlaceInteractorPlaceDataArrived(_ interactor: GooglePlaceInteractor, data: GooglePlaceData?)
}

final class GooglePlaceInteractor: GooglePlaceInteractorType {
    
    var webResourcesDispatcher: WebServiceDispatcherType
    
    init(webResourcesDispatcher: WebServiceDispatcherType) {
        self.webResourcesDispatcher = webResourcesDispatcher
    }
  
    weak var delegate: GooglePlaceInteractorDelegate?
    
    func getGooglePlaceData(placeName: String) {
        let resource = Resource<GooglePlaceData, GooglePlaceRequestData>(path:"getGMSPlace").withPost(GooglePlaceRequestData(placeName: placeName))
        
        webResourcesDispatcher.load(resource) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.delegate?.googlePlaceInteractorPlaceDataArrived(self, data: data)
                
            case .failure: break
            }
        }
    }
}
