//
//  PlaceProfileVM.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 19/05/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

protocol PlaceProfileVMType {
    var placeInfo: PlaceInfo { get }
    var googlePlaceData: Observable<GooglePlaceData?> { get }
    
    func callToPublicistPressed()
}

final class PlaceProfileVM: PlaceProfileVMType {
    
    var placeInfo: PlaceInfo
    var googlePlaceInteractor: GooglePlaceInteractorType
    var googlePlaceData = Observable<GooglePlaceData?>(nil)
    
    init(placeInfo: PlaceInfo, googlePlaceInteractor: GooglePlaceInteractorType) {
        self.placeInfo = placeInfo
        self.googlePlaceInteractor = googlePlaceInteractor
        self.googlePlaceInteractor.delegate = self
        googlePlaceInteractor.getGooglePlaceData(placeName: placeInfo.name)
    }
    
    func callToPublicistPressed() {
        guard let phoneNumber = placeInfo.publicistPhoneNumber, !phoneNumber.isEmpty,
            let url = URL(string:  "tel://" + phoneNumber) else { return }
        UIApplication.shared.open(url, options: [:])
    }
}

extension PlaceProfileVM: GooglePlaceInteractorDelegate {
    func googlePlaceInteractorPlaceDataArrived(_ interactor: GooglePlaceInteractor, data: GooglePlaceData) {
        googlePlaceData.value = data
    }
}
