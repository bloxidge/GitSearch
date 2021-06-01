//
//  RepositorySearchResults.swift
//  GitSearch
//
//  Created by Peter Bloxidge on 31/05/2021.
//

import Foundation

struct RepositorySearchResults: Decodable {
    let totalCount: Int
    let incompleteResults: Bool
    let items: [Repository]
}
