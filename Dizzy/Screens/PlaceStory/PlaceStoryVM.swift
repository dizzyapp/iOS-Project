//
//  PlaceStoryVM.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 25/04/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import Foundation

protocol PlaceStoryVMType {
    
}

final class PlaceStoryVM: PlaceStoryVMType {
    
    let place: PlaceInfo
    
    init(place: PlaceInfo) {
        self.place = place
    }
}
