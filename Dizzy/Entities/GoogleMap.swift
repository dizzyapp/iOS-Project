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

protocol GoogleMapType: class {
    var mapView: GMSMapView { get }
    func changeMapCenter(_ center: Location, zoom: Float)
    func addMarks(_ marks: [GoogleMap.Marks])
}

final class GoogleMap: GoogleMapType {
    
    struct Marks {
        var title: String
        var snippet: String
        var location: Location
    }
    
    var mapView: GMSMapView
    
    init() {
        let googleMapAPIKey = "AIzaSyCBhvRQXfqyNUQ_y9vm9Ikxi_t_U51ZaYI"
        GMSServices.provideAPIKey(googleMapAPIKey)
        GMSPlacesClient.provideAPIKey(googleMapAPIKey)
        mapView = GMSMapView()
    }

    func changeMapCenter(_ center: Location, zoom: Float) {
        let camera = GMSCameraPosition.camera(withLatitude: center.latitude, longitude: center.longitude, zoom: zoom)
        mapView.animate(to: camera)
    }
    
    func addMarks(_ marks: [Marks]) {
        for mark in marks {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: mark.location.latitude, longitude: mark.location.longitude)
            marker.title = mark.title
            marker.snippet = mark.snippet
            marker.map = mapView
        }
    }
}