//
//  PlaceSearchVM.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 22/04/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import Foundation

protocol PlaceSearchVMType {
    var delegate: PlaceSearchVMDelegate? { get set }
    
    func numberOfRowsInSection() -> Int
    func itemAt(_ indexPath: IndexPath) -> PlaceInfo
    func didSelectRowAt(_ indexPath: IndexPath) 
    func filter(filterString: String)
    func closeButtonPressed()
}

protocol PlaceSearchVMDelegate: class {
    func didSelect(place: PlaceInfo)
    func cancelButtonPressed()
}

final class PlaceSearchVM: PlaceSearchVMType {
    
    weak var delegate: PlaceSearchVMDelegate?
    let autoCompleteFilter = AutoCompleteFilter<PlaceInfo>(fullEntryList: [PlaceInfo]())
    
    init(places: [PlaceInfo]) {
        autoCompleteFilter.fullEntryList = places
    }
    
    func closeButtonPressed() {
       delegate?.cancelButtonPressed()
    }
    
    func numberOfRowsInSection() -> Int {
        return autoCompleteFilter.filteredEntryList.count
    }

    func itemAt(_ indexPath: IndexPath) -> PlaceInfo {
        return autoCompleteFilter.filteredEntryList[indexPath.row]
    }

    func didSelectRowAt(_ indexPath: IndexPath) {
        delegate?.didSelect(place: autoCompleteFilter.filteredEntryList[indexPath.row])
    }

    func filter(filterString: String) {
        autoCompleteFilter.filter(by: .startsWith, filterString: filterString)
    }
}
