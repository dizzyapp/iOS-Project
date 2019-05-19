//
//  PlaceProfileVM.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 19/05/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import Foundation

protocol PlaceProfileVMType {
    var placeInfo: PlaceInfo { get }
}

final class PlaceProfileVM: PlaceProfileVMType {
    
    var placeInfo: PlaceInfo
    
    init(placeInfo: PlaceInfo) {
        self.placeInfo = placeInfo
    }
}
