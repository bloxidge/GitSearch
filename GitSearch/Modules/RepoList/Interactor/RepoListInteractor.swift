//
//  RepoListInteractor.swift
//  GitSearch
//
//  Created by Peter Bloxidge on 31/05/2021.
//

import Foundation
import PromiseKit

protocol RepoListInteractor: AutoMockable {
    var results: RepositorySearchResults? { get }
    
    func fetchRepoSearchResults(_ searchQuery: String,
                                sort: SortMethod?,
                                order: Order?,
                                resultsPerPage: Int?,
                                page: Int?) -> Promise<RepositorySearchResults>
}

extension RepoListInteractor {
    func fetchRepoSearchResults(_ searchQuery: String,
                                sort: SortMethod? = nil,
                                order: Order? = nil,
                                resultsPerPage: Int? = nil,
                                page: Int? = nil) -> Promise<RepositorySearchResults> {
        fetchRepoSearchResults(searchQuery,
                               sort: sort,
                               order: order,
                               resultsPerPage: resultsPerPage,
                               page: page)
    }
}

class RepoListInteractorImpl: RepoListInteractor {
    
    var results: RepositorySearchResults?
    
    let api: ApiService
    
    init(api: ApiService) {
        self.api = api
    }
    
    func fetchRepoSearchResults(_ searchQuery: String,
                                sort: SortMethod?,
                                order: Order?,
                                resultsPerPage: Int?,
                                page: Int?) -> Promise<RepositorySearchResults> {
        let request = GetSearchRepositoriesRequest(searchQuery: searchQuery,
                                                   sort: sort,
                                                   order: order,
                                                   perPage: resultsPerPage,
                                                   page: page)
        return api.send(request: request)
            .map {
                self.results = $0
                return $0
            }
    }
    
}
