//
//  Int+Utils.swift
//  GitSearch
//
//  Created by Peter Bloxidge on 03/06/2021.
//

import Foundation

extension Int {
    
    var metricString: String {
        let sign = self < 0 ? "-" : ""
        var value = abs(Double(self))
        var suffix = ""
        var dp = 0

        switch value {
        case 1_000_000_000...:
            value /= 1_000_000_000
            suffix = "B"
            dp = 2
        case 1_000_000...:
            value /= 1_000_000
            suffix = "M"
            dp = 2
        case 1_000...:
            value /= 1_000
            suffix = "k"
            dp = 1
        default:
            break
        }
        
        return sign + String(format: "%0.\(dp)f", value) + suffix
    }
}
