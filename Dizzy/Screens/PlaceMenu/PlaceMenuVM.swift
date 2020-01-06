//
//  PlaceMenuVM.swift
//  Dizzy
//
//  Created by Tal Ben Asuli MAC  on 06/01/2020.
//  Copyright © 2020 Dizzy. All rights reserved.
//

import Foundation

protocol PlaceMenuVMType {
    var place: PlaceInfo { get }
    var placeInteractor: PlacesInteractorType { get }
    var menuImagesURLs: Observable<[MenuURL]> { get }
    var loading: Observable<Bool> { get }
}

final class PlaceMenuVM: PlaceMenuVMType {
    
    var place: PlaceInfo
    var placeInteractor: PlacesInteractorType
    var menuImagesURLs = Observable<[MenuURL]>([MenuURL]())
    var loading = Observable<Bool>(false)
    
    init(place: PlaceInfo, placeInteractor: PlacesInteractorType) {
        self.place = place
        self.placeInteractor = placeInteractor
        getMenu()
    }
    
    private func getMenu() {
        loading.value = true
        placeInteractor.getMenuImagesUrls(per: place.id) { [weak self] menuURLs in
            self?.menuImagesURLs.value = menuURLs
            self?.loading.value = false
        }
    }
}
