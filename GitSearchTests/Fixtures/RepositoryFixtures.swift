//
//  RepositoryFixtures.swift
//  GitSearchTests
//
//  Created by Peter Bloxidge on 05/06/2021.
//

import Foundation
@testable import GitSearch

struct RepositoryFixtures {
    
    static let searchResults = RepositorySearchResults(totalCount: 1234,
                                                       incompleteResults: false,
                                                       items: repos)
    
    static let searchResultsEmpty = RepositorySearchResults(totalCount: 0,
                                                            incompleteResults: false,
                                                            items: [])
    
    static let repo = repos.first!
    
    static let repos = [
        Repository(id: 0,
                   fullName: "Owner1/Thing",
                   name: "Thing",
                   description: "A decription for the thing",
                   htmlUrl: URL(string: "https://fake.github.com/Owner1/Thing")!,
                   owner: User(id: 28,
                               login: "Owner1",
                               avatarUrl: "https://avatars.com/u/0"),
                   forksCount: 394,
                   stargazersCount: 2314,
                   updatedAt: Date(timeIntervalSinceReferenceDate: 2304831)),
        Repository(id: 1,
                   fullName: "Owner2/Repo1",
                   name: "MyApp",
                   description: "My App is great!",
                   htmlUrl: URL(string: "https://fake.github.com/Owner2/MyApp")!,
                   owner: user,
                   forksCount: 9134,
                   stargazersCount: 80230,
                   updatedAt: Date(timeIntervalSinceReferenceDate: 3498534)),
        Repository(id: 2,
                   fullName: "Owner2/MyOtherApp",
                   name: "MyOtherApp",
                   description: nil,
                   htmlUrl: URL(string: "https://fake.github.com/Owner2/MyOtherApp")!,
                   owner: user,
                   forksCount: 89,
                   stargazersCount: 307,
                   updatedAt: Date(timeIntervalSinceReferenceDate: 8343102))
    ]
    
    static let user = User(id: 45,
                           login: "Owner2",
                           avatarUrl: "https://avatars.com/u/1")
}
