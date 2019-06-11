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
struct PlaceInfo: Codable, FilterEntry {
    var filterString: String {
        return name
    }

    let id: String
    let name: String
    let description: String
    let location: Location
    let imageURLString: String?
    let profileVideoURL: String?
    let authorizedAge: String?
    let publicistPhoneNumber: String?
    let placeSchedule: PlaceSchedule?
    let placesStories: [String?]?
}

struct PlaceSchedule: Codable {
    var sunday: String?
    var monday: String?
    var tuesday: String?
    var wednesday: String?
    var thursday: String?
    var friday: String?
    var saturday: String?
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

    func getCurrentAddress(completion: @escaping (Address?) -> Void) {
        let currentLocation = CLLocation(latitude: latitude, longitude: longitude)
        let currentLocale = Locale.current

        CLGeocoder().reverseGeocodeLocation(currentLocation, preferredLocale: currentLocale) { (placeMarks, error) in
            guard error == nil else { return }
            if let place = placeMarks?.first {
                let address = Address(country: place.country, city: place.subLocality, street: place.thoroughfare)
                completion(address)
            }
        }
    }
}

struct Address {
    var country: String?
    var city: String?
    var street: String?
}
