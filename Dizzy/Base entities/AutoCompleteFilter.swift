//
//  MapSearchVM.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 23/04/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import Foundation
import UIKit

protocol FilterEntry {
    var filterString: String { get }
}

class AutoCompleteFilter<DataType: FilterEntry> {
    
    enum AutoCompleteMethod {
        case containing, startingWith
    }
    
    var fullEntryList: [DataType]?
    private(set) var filteredEntryList: [DataType]?
    
    func filter(by method: AutoCompleteMethod, filterString: String?) {
        guard let fullEntryList = fullEntryList,
            !fullEntryList.isEmpty,
            let filterString = filterString,
            !filterString.isEmpty else {
                return
        }

        var filterPredicate: NSPredicate
        switch method {
        case .containing:
            filterPredicate = NSPredicate(format: "SELF CONTAINS[cd] %@", filterString)
            filteredEntryList = fullEntryList.filter { filterPredicate.evaluate(with: $0.filterString) }
            
        case .startingWith:
            filterPredicate = NSPredicate(format: "SELF BEGINSWITH[cd] %@", filterString)
            filteredEntryList = fullEntryList.filter { filterPredicate.evaluate(with: $0.filterString) }
        }
    }
}
