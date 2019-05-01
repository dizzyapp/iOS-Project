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
    
    enum FilterType {
        case contains, startsWith
        
        func predicate(filterString: String) -> NSPredicate {
            switch self {
            case .contains:
                return NSPredicate(format: "SELF CONTAINS[cd] %@", filterString)
                
            case .startsWith:
                 return NSPredicate(format: "SELF BEGINSWITH[cd] %@", filterString)
            }
        }
    }
    
    var fullEntryList: [DataType]
    private(set) var filteredEntryList: [DataType] = []
    
    init(fullEntryList: [DataType]) {
        self.fullEntryList = fullEntryList
    }
    
    func filter(by type: FilterType, filterString: String?) {
        guard !fullEntryList.isEmpty else { return }
        
        if let filterString = filterString {
            filteredEntryList = fullEntryList.filter { type.predicate(filterString: filterString).evaluate(with: $0.filterString) }
        } else {
           filteredEntryList = fullEntryList
        }
    }
}
