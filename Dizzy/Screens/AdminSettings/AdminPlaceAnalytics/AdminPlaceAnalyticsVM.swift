//
//  AdminPlaceAnalyticsVM.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 11/11/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import Foundation

protocol AdminPlaceAnalyticsVMType {
    var tableViewData: Observable<[AdminPlaceAnalyticCell.CellData]> { get }
    var placeName: String { get }
    var delegate: AdminPlaceAnalyticsVMDelegate? { get set }
    
    func numberOfItems() -> Int
    func item(at indexPath: IndexPath) -> AdminPlaceAnalyticCell.CellData
}

protocol AdminPlaceAnalyticsVMDelegate: class {
    func adminPlaceAnalyticsBackPressed(_ viewModel: AdminPlaceAnalyticsVMType)
}

final class AdminPlaceAnalyticsVM: AdminPlaceAnalyticsVMType {
    
    weak var delegate: AdminPlaceAnalyticsVMDelegate?
    var tableViewData = Observable<[AdminPlaceAnalyticCell.CellData]>([AdminPlaceAnalyticCell.CellData]())
    let place: PlaceInfo
    
    var placeName: String {
        return place.name
    }
    
    init(place: PlaceInfo) {
        self.place = place
        createTableViewData()
    }
    
    private func createTableViewData() {
        var tableViewData = [AdminPlaceAnalyticCell.CellData]()
        
        if let profileViews = place.adminAnalytics?.profileViews {
            tableViewData.append(AdminPlaceAnalyticCell.CellData(title: "Profile views".localized, message: "\(profileViews)"))
        }
        
        if let reserveClicks = place.adminAnalytics?.reserveClicks {
            tableViewData.append(AdminPlaceAnalyticCell.CellData(title: "Reserve clicks".localized, message: "\(reserveClicks)"))
        }
        
        if let attendenceCount = place.adminAnalytics?.attendenceCount {
            tableViewData.append(AdminPlaceAnalyticCell.CellData(title: "Attendence".localized, message: "\(attendenceCount)"))
        }
        
        self.tableViewData.value = tableViewData
    }
    
    func numberOfItems() -> Int {
        return tableViewData.value.count
    }
    
    func item(at indexPath: IndexPath) -> AdminPlaceAnalyticCell.CellData {
        return tableViewData.value[indexPath.row]
    }
}