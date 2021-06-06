//
//  RepositoryContent.swift
//  GitSearch
//
//  Created by Peter Bloxidge on 04/06/2021.
//

import Foundation

struct RepositoryContent: Decodable {
    let content: String
/*
    let name: String
    let path: String
    let sha: String
    let size: Int
    let url, htmlUrl, gitUrl, downloadUrl: String
    let submoduleGitUrl, target: String?
    let type: String
    let encoding: String
    let links: Links
    
    struct Links: Decodable {
        let _self, git, html: String
        
        enum CodingKeys: String, CodingKey {
            case _self = "self"
            case git
            case html
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case name, path, sha, size,
             url, htmlUrl, gitUrl, downloadUrl,
             submoduleGitUrl, target,
             type, content, encoding
        case links = "_links"
    }
 */
}
