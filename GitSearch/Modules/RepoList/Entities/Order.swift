//
//  Order.swift
//  GitSearch
//
//  Created by Peter Bloxidge on 01/06/2021.
//

import Foundation

enum Order: String, CaseIterable {
    case descending = "desc"
    case ascending = "asc"
    
    var title: String {
        switch self {
        case .descending: return "Descending"
        case .ascending: return "Ascending"
        }
    }
}
