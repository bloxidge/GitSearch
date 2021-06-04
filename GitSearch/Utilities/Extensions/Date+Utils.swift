//
//  Date+Utils.swift
//  GitSearch
//
//  Created by Peter Bloxidge on 03/06/2021.
//

import Foundation

extension Date {
    
    var timeAgo: String {
        let now = Date()
        let interval = DateInterval(start: self, end: now)

        switch interval.duration {
        case 0 ..< .minutes(1):
            return "just now"
        case .minutes(1) ..< .days(30):
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.minute, .hour, .day]
            formatter.maximumUnitCount = 1
            formatter.unitsStyle = .full
            return "\(formatter.string(from: self, to: now)!) ago"
        default:
            let year = Calendar.current.component(.year, from: self)
            let nowYear = Calendar.current.component(.year, from: now)
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMMM"
            if year < nowYear {
                formatter.dateFormat += " yyyy"
            }
            return formatter.string(from: self)
        }
    }
}
