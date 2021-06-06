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
    
    static let encodedString = "VGhpcyBpcyBhIGJhc2U2NC1lbmNvZGVkIHN0cmluZy4gSXQgY29udGFpbnMgbGluZSBicmVha3Mg\naW4gdGhlIGVuY29kZWQgc3RyaW5nIHRvIHNpbXVsYXRlIE1JTUUgY2h1bmtzLg=="
    
    static let decodedString = "This is a base64-encoded string. It contains line breaks in the encoded string to simulate MIME chunks."
}
