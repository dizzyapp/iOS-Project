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
    
    var minutesFromNow: Int? {
        return timeForm(component: .minute, endDate: Date(), currentDate: self).minute
    }
    
    var hoursFromNow: Int? {
        return timeForm(component: .hour, endDate: Date(), currentDate: self).hour
    }
    
    var daysFromNow: Int? {
        return timeForm(component: .day, endDate: Date(), currentDate: self).day
    }
    
    var monthFromNow: Int? {
        return timeForm(component: .month, endDate: Date(), currentDate: self).month
    }

    func timeForm(component: NSCalendar.Unit, endDate: Date, currentDate: Date) -> DateComponents {
        return (Calendar.current as NSCalendar).components(component, from: currentDate, to: endDate, options: [])
    }
    
    var timeDescriptionFromNow: String {
        if let minutes = minutesFromNow, minutes < 60 {
            if minutes == 1 {
                return "1 minute ago"
            } else {
                return "\(minutes) minutes ago"
            }
        } else if let hoursFromNow = hoursFromNow, hoursFromNow < 24 {
            if hoursFromNow == 1 {
                return "1 hour ago"
            } else {
                return "\(hoursFromNow) hours ago"
            }
        } else if let hoursFromNow = hoursFromNow, hoursFromNow > 24, hoursFromNow < 48 {
            return "Yesterday"
        } else if let days = daysFromNow, days < 30 {
            if days == 1 {
                return "1 day ago"
            } else {
                return "\(days) days ago"
            }
        } else if let monthsFromNow = monthFromNow {
            return "\(monthsFromNow) months ago"
        } else {
            return "Just Now"
        }
    }
}
