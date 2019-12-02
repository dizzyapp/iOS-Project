//
//  PlacesInteractor.swift
//  Dizzy
//
//  Created by Menashe, Or on 10 Nisan 5779.
//  Copyright © 5779 Dizzy. All rights reserved.
//

import UIKit

protocol PlacesInteractorType {
    var allPlaces: Observable<[PlaceInfo]> { get set }
    func getAllPlaces()
    func getProfileMedia(forPlaceId placeId: String, completion: @escaping  ([PlaceMedia]) -> Void)
    func getPlaces(ownedBy userId: String, completion: @escaping ([PlaceId]) -> Void)
    func increment(analyticsType: PlacesInteractor.AdminAnalyticsType, by count: Int, to place: PlaceInfo)
    func getReservations(per placeId: String, completion: @escaping ([ReservationData]) -> Void)
}

class PlacesInteractor: PlacesInteractorType {
    
    var allPlaces = Observable<[PlaceInfo]>([PlaceInfo]())
    
    enum AdminAnalyticsType: String {
        case attendence = "attendenceCount"
        case profileViews = "profileViews"
        case reserveClicks = "reserveClicks"
        
        func getCount(from place: PlaceInfo) -> Int {
            switch self {
            case .attendence: return place.adminAnalytics?.attendenceCount ?? 0
            case .profileViews: return  place.adminAnalytics?.profileViews ?? 0
            case .reserveClicks: return place.adminAnalytics?.reserveClicks ?? 0
            }
        }
    }
    
    private let webResourcesDispatcher: WebServiceDispatcherType
    
    init(webResourcesDispatcher: WebServiceDispatcherType) {
        self.webResourcesDispatcher = webResourcesDispatcher
    }
    
    public func getAllPlaces() {
        let placesResource = Resource<[PlaceInfo], String>(path: "places").withGet()
        webResourcesDispatcher.load(placesResource) {[weak self] result in
            switch result {
            case .success( let places):
                self?.allPlaces.value = places
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
    
    public func getProfileMedia(forPlaceId placeId: String, completion: @escaping ([PlaceMedia]) -> Void) {
         let placeMediaResource = Resource<[PlaceMedia], Bool>(path: "profileMediaPerPlaceId/\(placeId)").withGet()
        webResourcesDispatcher.load(placeMediaResource) { result in
            switch result {
            case .success( let profileAllMedia):
                completion(profileAllMedia)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getPlaces(ownedBy userId: String, completion: @escaping ([PlaceId]) -> Void) {
        let resource = Resource<[PlaceId], String>(path: "PlaceIdPerUserId/\(userId)").withGet()
        webResourcesDispatcher.load(resource) { result in
            switch result {
            case .success(let placesIds):
                completion(placesIds)
        
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getReservations(per placeId: String, completion: @escaping ([ReservationData]) -> Void) {
        let resource = Resource<[ReservationData], String>(path: "ReservationPerPlaceId/\(placeId)").withGet()
        webResourcesDispatcher.load(resource) { result in
            
            switch result {
            case .success(let reservationsData):
                completion(reservationsData)
                
            case .failure(let error):
                print(error)
            }
        }
    }

    func increment(analyticsType: AdminAnalyticsType, by count: Int = 1, to place: PlaceInfo) {
        let currentCount: Int = analyticsType.getCount(from: place)
        let newCount = currentCount + count
        let resource = Resource<Bool, Int>(path: "places/\(place.id)/adminAnalytics/\(analyticsType.rawValue)").withPost(newCount)
        self.webResourcesDispatcher.load(resource) { _ in }
    }
}
