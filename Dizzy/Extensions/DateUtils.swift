//
//  DateUtils.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 23/05/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import Foundation

extension Date {
    
    var dayName: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayInWeek = dateFormatter.string(from: self)
        return dayInWeek
    }
}
