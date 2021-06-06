//
//  RepositoryContentFixtures.swift
//  GitSearchTests
//
//  Created by Peter Bloxidge on 06/06/2021.
//

import Foundation
@testable import GitSearch

struct RepositoryContentFixtures {
    
    static let repoContent = RepositoryContent(content: encodedString)
    
    static let invalidContent = RepositoryContent(content: "ThIsIsNoTaVaLiDBaSe64EnCoDeDsTrInG")
    
    static let encodedString = "VGhpcyBpcyBhIGJhc2U2NC1lbmNvZGVkIHN0cmluZy4KCkl0IGNvbnRhaW5zIGxpbmUgYnJlYWtz\nIGluIHRoZSBlbmNvZGVkIHN0cmluZyB0byBzaW11bGF0ZSBNSU1FIGNodW5rcy4"
    
    static let decodedString = """
        This is a base64-encoded string.

        It contains line breaks in the encoded string to simulate MIME chunk breaks.
    """
}
