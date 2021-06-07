//
//  RepositorySearchResults.swift
//  GitSearch
//
//  Created by Peter Bloxidge on 31/05/2021.
//

import Foundation

struct RepositorySearchResults: Decodable, Equatable {
    let totalCount: Int
    let incompleteResults: Bool
    var items: [Repository]
}
