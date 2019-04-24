//
//  MapSearchVM.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 22/04/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import Foundation

protocol MapSearchVMType {
    var delegate: MapSearchVMDelegate? { get set }
    
    func numberOfRowsInSection() -> Int
    func itemAt(_ indexPath: IndexPath) -> PlaceInfo?
    func didSelectRowAt(_ indexPath: IndexPath) 
    func filter(filterString: String)
    func closeButtonPressed()
}

protocol MapSearchVMDelegate: class {
    func didSelect(place: PlaceInfo)
    func cancelButtonPressed()
}

final class MapSearchVM: MapSearchVMType {
    
    weak var delegate: MapSearchVMDelegate?
    let autoCompleteFilter = AutoCompleteFilter<PlaceInfo>()
    
    init(places: [PlaceInfo]) {
        autoCompleteFilter.fullEntryList = places
    }
    
    func closeButtonPressed() {
       delegate?.cancelButtonPressed()
    }
    
    func numberOfRowsInSection() -> Int {
        return autoCompleteFilter.filteredEntryList?.count ?? 0
    }
    
    func itemAt(_ indexPath: IndexPath) -> PlaceInfo? {
        return autoCompleteFilter.filteredEntryList?[indexPath.row]
    }
    
    func didSelectRowAt(_ indexPath: IndexPath) {
        guard let selecedPlace = autoCompleteFilter.filteredEntryList?[indexPath.row] else { return }
        delegate?.didSelect(place: selecedPlace)
    }
    
    func filter(filterString: String) {
        autoCompleteFilter.filter(by: .startingWith, filterString: filterString)
    }
}
