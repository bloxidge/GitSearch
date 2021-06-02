//
//  SortMethod.swift
//  GitSearch
//
//  Created by Peter Bloxidge on 01/06/2021.
//

import Foundation

enum SortMethod: CaseIterable {
    case bestMatch
    case stars
    case forks
    case helpWantedIssues
    case updated
    
    var title: String {
        switch self {
        case .bestMatch: return "Best Match"
        case .stars: return "Stars"
        case .forks: return "Forks"
        case .helpWantedIssues: return "\"Help wanted\" Issues"
        case .updated: return "Last Updated"
        }
    }
    
    var queryValue: String? {
        switch self {
        case .bestMatch: return nil
        case .stars: return "stars"
        case .forks: return "forks"
        case .helpWantedIssues: return "help-wanted-issues"
        case .updated: return "updated"
        }
    }
}
