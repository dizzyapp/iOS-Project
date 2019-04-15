//
//  DiscoveryViewModel.swift
//  Dizzy
//
//  Created by Or Menashe on 01/04/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import UIKit

protocol DiscoveryViewModelType {
    func numberOfSections() -> Int
    func numberOfItemsForSection(_ section: Int) -> Int
    func itemForIndexPath(_ indexPath: IndexPath) -> PlaceInfo
}

class DiscoveryViewModel: DiscoveryViewModelType {
    
    init() {
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfItemsForSection(_ section: Int) -> Int {
        return 10
    }
    
    func itemForIndexPath(_ indexPath: IndexPath) -> PlaceInfo {
        return PlaceInfo(name: "name", address: "address", position: "position", location: Location(  latitude: 0, longitude: 0))
    }
}
