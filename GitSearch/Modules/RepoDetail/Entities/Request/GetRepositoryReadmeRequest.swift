//
//  GetRepositoryReadmeRequest.swift
//  GitSearch
//
//  Created by Peter Bloxidge on 04/06/2021.
//

import Foundation

class GetRepositoryReadmeRequest: Request<RepositoryContent> {
    
    private let repository: Repository
    
    override var path: String {
        "repos/\(repository.fullName)/readme"
    }
    
    init(for repository: Repository) {
        self.repository = repository
    }
}
