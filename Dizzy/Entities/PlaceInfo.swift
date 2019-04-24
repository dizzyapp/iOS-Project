//
//  PlaceInfo.swift
//  Dizzy
//
//  Created by Or Menashe on 02/04/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import Foundation

struct PlaceInfo: Codable, FilterEntry {
    
    var filterString: String {
        return name
    }
    
    let name: String
    let address: String
    let position: String
    let location: Location
    let imageURLString: String
}
