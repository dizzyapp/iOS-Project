//
//  PlaceReservationRequestor.swift
//  Dizzy
//
//  Created by Menashe, Or on 11/11/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import Foundation
import UIKit
protocol PlaceReservationRequestor {
    func requestATable(_ placeInfo: PlaceInfo)
}

extension PlaceReservationRequestor {
    func requestATable(_ placeInfo: PlaceInfo) {
        let whatsappText = "Hi I want to order a table".localized.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        guard let phoneNumber = placeInfo.publicistPhoneNumber, !phoneNumber.isEmpty,
            let url = URL(string: "https://wa.me/\(placeInfo.publicistPhoneNumber ?? "")/?text=\(whatsappText ??    "")") else { return }
        UIApplication.shared.open(url, options: [:])
    }
}
