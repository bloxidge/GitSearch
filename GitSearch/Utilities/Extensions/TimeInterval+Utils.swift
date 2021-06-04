//
//  TimeInterval+Utils.swift
//  GitSearch
//
//  Created by Peter Bloxidge on 03/06/2021.
//

import Foundation

extension TimeInterval {
    
    private static var hoursPerDay: Double { 24 }
    private static var minutesPerHour: Double { 60 }
    private static var secondsPerMinute: Double { 60 }
    private static var millisecondsPerSecond: Double { 1000 }

    /// - Returns: The time in days using the `TimeInterval` type.
    static func days(_ value: TimeInterval) -> TimeInterval {
        return hours(value) * hoursPerDay
    }

    /// - Returns: The time in hours using the `TimeInterval` type.
    static func hours(_ value: TimeInterval) -> TimeInterval {
        return minutes(value) * minutesPerHour
    }

    /// - Returns: The time in minutes using the `TimeInterval` type.
    static func minutes(_ value: TimeInterval) -> TimeInterval {
        return seconds(value) * secondsPerMinute
    }

    /// - Returns: The time in seconds using the `TimeInterval` type.
    static func seconds(_ value: TimeInterval) -> TimeInterval {
        return value
    }

    /// - Returns: The time in milliseconds using the `TimeInterval` type.
    static func milliseconds(_ value: TimeInterval) -> TimeInterval {
        return seconds(value) / millisecondsPerSecond
    }
}
