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
        print("menash logs - returning sections")
        return 1
    }
    
    func numberOfItemsForSection(_ section: Int) -> Int {
        print("menash logs - returning itmes for section")
        return 10
    }
    
    func itemForIndexPath(_ indexPath: IndexPath) -> PlaceInfo {
        print("menash logs - returning placeinfo")
        return PlaceInfo(name: "name", address: "address", position: "position")
    }
}
