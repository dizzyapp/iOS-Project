//
//  AdminPlaceAnalyticsVM.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 11/11/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import Foundation

protocol AdminPlaceAnalyticsVMType {
    var analyticsData: [AnalyticsViewContainer.AnalyticsViewContainerData] { get }
    var placeName: String { get }
    var delegate: AdminPlaceAnalyticsVMDelegate? { get set }
    
//    func numberOfItems() -> Int
//    func item(at indexPath: IndexPath) -> AnalyticsViewContainer.AnalyticsViewContainerData
}

protocol AdminPlaceAnalyticsVMDelegate: class {
    func adminPlaceAnalyticsBackPressed(_ viewModel: AdminPlaceAnalyticsVMType)
}

final class AdminPlaceAnalyticsVM: AdminPlaceAnalyticsVMType {
        
    weak var delegate: AdminPlaceAnalyticsVMDelegate?
    let place: PlaceInfo
    
    var analyticsData = [AnalyticsViewContainer.AnalyticsViewContainerData]()
    
    var placeName: String {
        return place.name
    }
    
    init(place: PlaceInfo) {
        self.place = place
        createAnalyticsData()
    }
    
    private func createAnalyticsData() {
        var analyticsData = [AnalyticsViewContainer.AnalyticsViewContainerData]()
        
        if let profileViews = place.adminAnalytics?.profileViews {
            analyticsData.append(AnalyticsViewContainer.AnalyticsViewContainerData(title: "Profile views".localized, count: "\(profileViews)"))
        }
        
        if let reserveClicks = place.adminAnalytics?.reserveClicks {
            analyticsData.append(AnalyticsViewContainer.AnalyticsViewContainerData(title: "Reserve clicks".localized, count: "\(reserveClicks)"))
        }
        
        if let attendenceCount = place.adminAnalytics?.attendenceCount {
            analyticsData.append(AnalyticsViewContainer.AnalyticsViewContainerData(title: "Attendence".localized, count: "\(attendenceCount)"))
        }
        
        self.analyticsData = analyticsData
    }
    
//    func numberOfItems() -> Int {
//        return analyticsData.count
//    }
//    
//    func item(at indexPath: IndexPath) -> AnalyticsViewContainer.AnalyticsViewContainerData {
//        return analyticsData[indexPath.row]
//    }
}
