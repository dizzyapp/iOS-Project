//
//  ExternalPlaceData.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 23/05/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import Foundation
import GooglePlaces

struct GooglePlaceRequestData: Codable {
    var placeName: String
}

struct GooglePlaceData: Codable {
    
    var name: String
    var id: String
    var openingText: String

    init(gmsPlace: GMSPlace) {
        name = gmsPlace.name ?? ""
        id = gmsPlace.placeID ?? ""
        openingText = ""
        updateOpeningText(gmsPlace: gmsPlace)
    }
    
    private mutating func updateOpeningText(gmsPlace: GMSPlace) {
        guard let openingHours = gmsPlace.openingHours?.weekdayText else { return }
        for string in openingHours {
            if string.contains(Date().dayName) {
                openingText = string
                return
            }
        }
    }
}
