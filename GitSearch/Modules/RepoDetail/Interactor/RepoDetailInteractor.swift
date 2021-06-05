//
//  RepoDetailInteractor.swift
//  GitSearch
//
//  Created by Peter Bloxidge on 31/05/2021.
//

import Foundation
import PromiseKit

protocol RepoDetailInteractor {
    var readmeFileContents: RepositoryContent? { get }
    
    func fetchReadmeContentFile(for repository: Repository) -> Promise<RepositoryContent>
}

class RepoDetailInteractorImpl: RepoDetailInteractor {
    
    var readmeFileContents: RepositoryContent?
        
    let api: ApiService
    
    init(api: ApiService) {
        self.api = api
    }
    
    func fetchReadmeContentFile(for repository: Repository) -> Promise<RepositoryContent> {
        let request = GetRepositoryReadmeRequest(for: repository)
        return api.send(request: request)
            .map {
                self.readmeFileContents = $0
                return $0
            }
    }
}
