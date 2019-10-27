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
    var delegate: PlaceProfileVMDelegate? { get set }
    
    func closePressed()
    func addressButtonPressed(view: PlaceProfileView)
    func callButtonPressed()
    func requestTableButtonPressed()
    func storyButtonPressed()
    func sholdShowStoryButton() -> Bool
}

protocol PlaceProfileVMDelegate: class {
    func placeProfileVMClosePressed(_ viewModel: PlaceProfileVMType)
    func placeProfileVMStoryButtonPressed(_ viewModel: PlaceProfileVMType)
}

final class PlaceProfileVM: PlaceProfileVMType {
   
    var placeInfo: PlaceInfo
    let activePlace: PlaceInfo?
    weak var delegate: PlaceProfileVMDelegate?
    
    var externalNavigationProvider = ExternalNavigationProvider()

    init(placeInfo: PlaceInfo, activePlace: ActivePlace) {
        self.placeInfo = placeInfo
        self.activePlace = activePlace.activePlaceInfo
    }
    
    func addressButtonPressed(view: PlaceProfileView) {
        guard let location = view.placeInfo?.location else {
            return
        }

        self.externalNavigationProvider.openWaze(location: location)
    }

    func callButtonPressed() {
        guard let phoneNumber = placeInfo.publicistPhoneNumber, !phoneNumber.isEmpty,
            let url = URL(string: "tel://" + phoneNumber) else { return }
        UIApplication.shared.open(url, options: [:])
    }
    
    func requestTableButtonPressed() {
        let whatsappText = "Hi I want to order a table".localized.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        guard let phoneNumber = placeInfo.publicistPhoneNumber, !phoneNumber.isEmpty,
            let url = URL(string: "https://wa.me/\(placeInfo.publicistPhoneNumber ?? "")/?text=\(whatsappText ??    "")") else { return }
        UIApplication.shared.open(url, options: [:])
    }
    
    func closePressed() {
        delegate?.placeProfileVMClosePressed(self)
    }

    func storyButtonPressed() {
        delegate?.placeProfileVMStoryButtonPressed(self)
    }
    
    func sholdShowStoryButton() -> Bool {
        return placeInfo.id == activePlace?.id
    }
}
