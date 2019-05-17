//
//  GoogleMap.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 14/04/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import Foundation
import GoogleMaps
import GooglePlaces

protocol MapType: class {
    var mapView: UIView { get }
    func changeMapFocus(_ center: Location, zoom: Float)
    func addMarks(_ marks: [Mark?])
}

struct Mark {
    var title: String
    var snippet: String
    var location: Location
    var displayView: UIView?
}

final class GoogleMap: MapType {
    
    var mapView: UIView {
        return googleMapView
    }
    
    var googleMapView: GMSMapView
    
    init() {
        let googleMapAPIKey = "AIzaSyCBhvRQXfqyNUQ_y9vm9Ikxi_t_U51ZaYI"
        GMSServices.provideAPIKey(googleMapAPIKey)
        GMSPlacesClient.provideAPIKey(googleMapAPIKey)
        googleMapView = GMSMapView()
    }

    func changeMapFocus(_ center: Location, zoom: Float) {
        let camera = GMSCameraPosition.camera(withLatitude: center.latitude, longitude: center.longitude, zoom: zoom)
        googleMapView.animate(to: camera)
    }
    
    func addMarks(_ marks: [Mark?]) {
        for mark in marks {
            if let mark = mark {
                setupGoogleMarker(mark)
            }
        }
    }
    
    private func setupGoogleMarker(_ mark: Mark) {
        let googleMarker = GMSMarker()
        googleMarker.position = CLLocationCoordinate2D(latitude: mark.location.latitude, longitude: mark.location.longitude)
        googleMarker.title = mark.title
        googleMarker.snippet = mark.snippet
        if let displayView = mark.displayView {
            googleMarker.iconView = displayView
        }
        googleMarker.map = googleMapView
    }
}