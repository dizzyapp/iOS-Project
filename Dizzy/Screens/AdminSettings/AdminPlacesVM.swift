//
//  AdminPlacesVM.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 10/11/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import Foundation

protocol AdminPlacesVMType {
    var userPlaces: Observable<[PlaceInfo]> { get }
    var loading: Observable<Bool> { get }
    
    func numberOfRows() -> Int
    func data(at indexPath: IndexPath) -> PlaceInfo
}

final class AdminPlacesVM: AdminPlacesVMType {
   
    var placesIdsPerUserIdInteractor: PlacesIdPerUserIdInteractorType
    let user: DizzyUser
    let allPlaces: [PlaceInfo]
    var userPlaces = Observable<[PlaceInfo]>([PlaceInfo]())
    var loading = Observable<Bool>(false)
    
    init(placesIdsPerUserIdInteractor: PlacesIdPerUserIdInteractorType,
         user: DizzyUser,
         allPlaces: [PlaceInfo]) {
        self.placesIdsPerUserIdInteractor = placesIdsPerUserIdInteractor
        self.user = user
        self.allPlaces = allPlaces
        getPlaces()
    }
    
    private func getPlaces() {
        loading.value = true
        placesIdsPerUserIdInteractor.fetchPlaceIds(per: user.id)
        placesIdsPerUserIdInteractor.delegate = self
    }
    
    func numberOfRows() -> Int {
        return userPlaces.value.count
    }
    
    func data(at indexPath: IndexPath) -> PlaceInfo {
        return userPlaces.value[indexPath.row]
    }
}

extension AdminPlacesVM: PlacesIdPerUserIdInteractorDelegate {
    func placesIdPerUserIdFinished(_ interactor: PlacesIdPerUserIdInteractorType, with placesIds: [PlaceId]) {
        var userPlaces = [PlaceInfo]()
        for id in placesIds {
            for place in allPlaces where place.id == id.id {
                userPlaces.append(place)
            }
        }
        loading.value = false
        self.userPlaces.value = userPlaces
    }
}
