//
//  GooglePlaceService.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 23/05/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import Foundation
import GooglePlaces

enum GooglePlaceServiceError: Error {
    case wrongQuery
    case autocompleteQueryError(error: Error?)
    case fetchPlaceError(error: Error?)
}

final class GooglePlaceService: WebServiceType {
    
    init() {
        let googleMapAPIKey = "AIzaSyCBhvRQXfqyNUQ_y9vm9Ikxi_t_U51ZaYI"
        GMSPlacesClient.provideAPIKey(googleMapAPIKey)
    }
    
    func load<Response, Body>(_ resource: Resource<Response, Body>, completion: @escaping (Result<Response>) -> Void) where Response : Decodable, Response : Encodable, Body : Encodable {
        
        guard let query = resource.makeJson()?["placeName"] as? String else {
            completion(Result.failure(GooglePlaceServiceError.wrongQuery))
            return
        }
        
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment
        GMSPlacesClient.shared().autocompleteQuery(query, bounds: nil, boundsMode: .bias, filter: filter) { (predctions, error) in
            
            guard error == nil else {
                completion(Result.failure(GooglePlaceServiceError.autocompleteQueryError(error: error)))
                return
            }
            
            if let firstPredictionId = predctions?.first?.placeID {
                let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
                    UInt(GMSPlaceField.placeID.rawValue |
                    UInt(GMSPlaceField.openingHours.rawValue)))!
                
                GMSPlacesClient.shared().fetchPlace(fromPlaceID: firstPredictionId, placeFields: fields, sessionToken: nil, callback: { (place, error) in
                    
                    guard let place = place, error == nil else {
                        completion(Result.failure(GooglePlaceServiceError.fetchPlaceError(error: error)))
                        return
                    }
                    
                    let googlePlaceData = GooglePlaceData(gmsPlace: place)
                    completion(Result.success(googlePlaceData as! Response))
                })
            }
            
        }
    }
    
    func shouldHandle<Response, Body>(_ resource: Resource<Response, Body>) -> Bool where Response : Decodable, Response : Encodable, Body : Encodable {
        return resource.path == "getGMSPlace"
    }
}
