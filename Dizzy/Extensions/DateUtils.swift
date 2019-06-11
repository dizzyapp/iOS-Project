//
//  DateUtils.swift
//  Dizzy
//
//  Created by Tal Ben Asuli on 23/05/2019.
//  Copyright © 2019 Dizzy. All rights reserved.
//

import Foundation

enum DayType: String {
    case sunday = "Sunday"
    case monday = "Monday"
    case tuesday = "Tuesday"
    case wednesday = "Wednesday"
    case thursday = "Thursday"
    case friday = "Friday"
    case saturday = "Saturday"
    
    func getTime(from placeSchedule: PlaceSchedule?) -> String? {
        switch self {
        case .sunday: return placeSchedule?.sunday
        case .monday: return placeSchedule?.monday
        case .tuesday: return placeSchedule?.tuesday
        case .wednesday: return placeSchedule?.wednesday
        case .thursday: return placeSchedule?.thursday
        case .friday: return placeSchedule?.friday
        case .saturday: return placeSchedule?.saturday
        }
    }
}

extension Date {
    
    var dayName: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayInWeek = dateFormatter.string(from: self)
        return dayInWeek
    }
    
    var dayType: DayType? {
        let dayName = self.dayName
        return DayType(rawValue: dayName)
    }
}
