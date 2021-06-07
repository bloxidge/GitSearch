//
//  RepoListInteractor.swift
//  GitSearch
//
//  Created by Peter Bloxidge on 31/05/2021.
//

import Foundation
import PromiseKit

protocol RepoListInteractor: AutoMockable {
    var fullResults: RepositorySearchResults? { get }
    
    func fetchRepoSearchResults(_ searchQuery: String,
                                sort: SortMethod?,
                                order: Order?) -> Promise<RepositorySearchResults>
    func fetchNextPageResults() -> Promise<Void>
}

extension RepoListInteractor {

    func fetchRepoSearchResults(_ searchQuery: String,
                                sort: SortMethod? = nil,
                                order: Order? = nil) -> Promise<RepositorySearchResults> {
        fetchRepoSearchResults(searchQuery,
                               sort: sort,
                               order: order)
    }
}

class RepoListInteractorImpl: RepoListInteractor {

    typealias LastSearch = (query: String, sort: SortMethod?, order: Order?)
    
    var fullResults: RepositorySearchResults?
    private var lastSearch: LastSearch?
    private var currentPage: Int = 1
    
    let api: ApiService
    
    init(api: ApiService) {
        self.api = api
    }
    
    func fetchRepoSearchResults(_ searchQuery: String,
                                sort: SortMethod?,
                                order: Order?) -> Promise<RepositorySearchResults> {
        currentPage = 1

        lastSearch = (searchQuery, sort, order)

        return requestSearchResults(searchQuery,
                                    sort: sort,
                                    order: order,
                                    page: currentPage)
            .map { initialResults in
                self.fullResults = initialResults
                return initialResults
            }
    }

    func fetchNextPageResults() -> Promise<Void> {
        guard let search = lastSearch else {
            return Promise(error: RepoSearchError.missingInitialSearch)
        }

        let nextPage = currentPage + 1

        return requestSearchResults(search.query,
                                    sort: search.sort,
                                    order: search.order,
                                    page: nextPage)
            .done { newResults in
                self.fullResults?.items += newResults.items
                self.currentPage = nextPage
            }
    }

    private func requestSearchResults(_ searchQuery: String,
                                      sort: SortMethod?,
                                      order: Order?,
                                      page: Int?) -> Promise<RepositorySearchResults> {
        let request = GetSearchRepositoriesRequest(searchQuery: searchQuery,
                                                   sort: sort,
                                                   order: order,
                                                   perPage: nil, // 30 (default)
                                                   page: page)
        return api.send(request: request)
    }
}

enum RepoSearchError: Error {
    case missingInitialSearch
}
