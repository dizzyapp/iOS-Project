//
//  BigImageHorizontalViewModel.swift
//  Dizzy
//
//  Created by Tal Ben Asuli MAC  on 30/06/2020.
//  Copyright © 2020 Dizzy. All rights reserved.
//

import Foundation

protocol BigImageHorizontalViewModelType {
    func numberOfSections() -> Int
    func item(at indexPath: IndexPath) -> BigImageHorizontalViewModel.Data
}

final class BigImageHorizontalViewModel: BigImageHorizontalViewModelType {
    
    var items = Observable<[Data]>([Data]())
    
    init(places: [PlaceInfo], currentLocation: Location?) {
        
        items.value = places.map({ place -> Data in
            return Data(imageURL: place.imageURLString ?? "", title: place.name, subtitle: String(format: "%.2f km", currentLocation?.getDistanceTo(place.location) ?? 0))
        })
    }
        
    func numberOfSections() -> Int {
        return items.value.count
    }
    
    func item(at indexPath: IndexPath) -> Data {
        return items.value[indexPath.row]
    }
    
}

extension BigImageHorizontalViewModel {
    struct Data {
        let imageURL: String
        let title: String
        let subtitle: String
    }
}
