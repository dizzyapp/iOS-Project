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
}

protocol PlaceProfileVMDelegate: class {
    func placeProfileVMClosePressed(_ viewModel: PlaceProfileVMType)
}

final class PlaceProfileVM: PlaceProfileVMType {
   
    var placeInfo: PlaceInfo
    weak var delegate: PlaceProfileVMDelegate?
    
    init(placeInfo: PlaceInfo) {
        self.placeInfo = placeInfo
    }
    
    func addressButtonPressed(view: PlaceProfileView) {
        guard let location = view.placeInfo?.location else {
            return
        }
        
        self.openWaze(location: location)
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
    
    func openWaze(location : Location) {
        if let url = URL(string: "waze://"), UIApplication.shared.canOpenURL(url) {
            let urlStr: String = "waze://?ll=\(location.latitude),\(location.longitude)&navigate=yes"
            if let url = URL(string: urlStr) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        } else {
            // Waze is not installed. Launch AppStore to install Waze app
            if let url = URL(string: "http://itunes.apple.com/us/app/id323229106") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    func closePressed() {
        delegate?.placeProfileVMClosePressed(self)
    }
}
