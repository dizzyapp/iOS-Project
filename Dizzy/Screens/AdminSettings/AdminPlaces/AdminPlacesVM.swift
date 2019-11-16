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
    var delegate: AdminPlacesVMDelegate? { get set }
    
    func numberOfRows() -> Int
    func place(at indexPath: IndexPath) -> PlaceInfo
    func didSelectItem(at indexPath: IndexPath)
}

protocol AdminPlacesVMDelegate: class {
    func adminPlaceVMBackPressed(_ viewModel: AdminPlacesVMType)
    func adminPlaceVM(_ viewModel: AdminPlacesVMType, didSelectPlace place: PlaceInfo)
}

final class AdminPlacesVM: AdminPlacesVMType {
    
    weak var delegate: AdminPlacesVMDelegate?
    
    var placesInteractor: PlacesInteractorType
    let user: DizzyUser
    let allPlaces: [PlaceInfo]
    var userPlaces = Observable<[PlaceInfo]>([PlaceInfo]())
    var loading = Observable<Bool>(false)
    
    init(placesInteractor: PlacesInteractorType,
         user: DizzyUser,
         allPlaces: [PlaceInfo]) {
        self.placesInteractor = placesInteractor
        self.user = user
        self.allPlaces = allPlaces
        getPlaces()
    }
    
    private func getPlaces() {
        loading.value = true
        placesInteractor.getPlaces(ownedBy: user.id)
        placesInteractor.delegate = self
    }
    
    func numberOfRows() -> Int {
        return userPlaces.value.count
    }
    
    func place(at indexPath: IndexPath) -> PlaceInfo {
        return userPlaces.value[indexPath.row]
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        let place = userPlaces.value[indexPath.row]
        if place.adminAnalytics != nil {
            delegate?.adminPlaceVM(self, didSelectPlace: place)
        }
    }
}

extension AdminPlacesVM: PlacesInteractorDelegate {
    
    func allPlacesArrived(places: [PlaceInfo]) { }
    
    func placesIdsPerUserArrived(placesIds: [PlaceId]) {
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