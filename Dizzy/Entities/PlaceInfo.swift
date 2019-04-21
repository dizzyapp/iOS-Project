//
//  PlaceInfo.swift
//  Dizzy
//
//  Created by Or Menashe on 02/04/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import Foundation
import CoreLocation

enum DistanceScale {
    case kilometers
    case meters
}
struct PlaceInfo: Codable {
    let name: String
    let description: String
    let position: String
    let location: Location
}

struct Location: Codable {
    var latitude: Double
    var longitude: Double
    
    func getDistanceTo(_ destination: Location, inScaleOf scale: DistanceScale = .kilometers) -> Double {
        let startLocation = CLLocation(latitude: latitude, longitude: longitude)
        let destinationLocation = CLLocation(latitude: destination.latitude, longitude: destination.longitude)
        let distanceInMeters = startLocation.distance(from: destinationLocation)
        let distanceInKilometers = distanceInMeters/1000
        return scale == .meters ? distanceInMeters : distanceInKilometers
    }
}

struct Address {
    var country: String
    var city: String
    var street: String
}
