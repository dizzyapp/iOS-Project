//
//  AdminPlaceAnalyticsVM.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 11/11/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import Foundation

protocol AdminPlaceAnalyticsVMType {
    var analyticsData: [AdminAnalyticsViewContainer.AdminAnalyticsViewContainerData] { get }
    var placeName: String { get }
    var delegate: AdminPlaceAnalyticsVMDelegate? { get set }
    var reservationsData: Observable<[ReservationData]> { get }
    var numberOfItems: Int { get }
    
    func getReservation(at indexPath: IndexPath) -> ReservationData
}

protocol AdminPlaceAnalyticsVMDelegate: class {
    func adminPlaceAnalyticsBackPressed(_ viewModel: AdminPlaceAnalyticsVMType)
}

final class AdminPlaceAnalyticsVM: AdminPlaceAnalyticsVMType {
        
    weak var delegate: AdminPlaceAnalyticsVMDelegate?
    let place: PlaceInfo
    let placesInteractor: PlacesInteractorType
    
    var reservationsData = Observable<[ReservationData]>([ReservationData]())
    
    var analyticsData = [AdminAnalyticsViewContainer.AdminAnalyticsViewContainerData]()
    
    var placeName: String {
        return place.name
    }
    
    var numberOfItems: Int {
        return reservationsData.value.count
    }
    
    init(place: PlaceInfo, placesInteractor: PlacesInteractorType) {
        self.place = place
        self.placesInteractor = placesInteractor
        createAnalyticsData()
        fetchReservationsData()
    }
    
    private func createAnalyticsData() {
        var analyticsData = [AdminAnalyticsViewContainer.AdminAnalyticsViewContainerData]()
        
        if let profileViews = place.adminAnalytics?.profileViews {
            analyticsData.append(AdminAnalyticsViewContainer.AdminAnalyticsViewContainerData(title: "Profile views".localized, count: "\(profileViews)"))
        }
        
        if let reserveClicks = place.adminAnalytics?.reserveClicks {
            analyticsData.append(AdminAnalyticsViewContainer.AdminAnalyticsViewContainerData(title: "Reserve clicks".localized, count: "\(reserveClicks)"))
        }
        
        if let attendenceCount = place.adminAnalytics?.attendenceCount {
            analyticsData.append(AdminAnalyticsViewContainer.AdminAnalyticsViewContainerData(title: "Attendence".localized, count: "\(attendenceCount)"))
        }
        
        self.analyticsData = analyticsData
    }
    
    private func fetchReservationsData() {
        placesInteractor.getReservations(per: place.id) { [weak self] reservationsData in
            guard let self = self else { return }
            let sortedReservation = self.sortByDate(reservations: reservationsData)
            self.reservationsData.value = sortedReservation
        }
    }
    
    private func sortByDate(reservations: [ReservationData]) -> [ReservationData] {
        let sortedReservations = reservations.sorted { (reservation1, reservation2) -> Bool in
            return reservation1.timeStamp > reservation2.timeStamp
        }
        return sortedReservations
    }
    
    func getReservation(at indexPath: IndexPath) -> ReservationData {
        return reservationsData.value[indexPath.row]
    }
}
