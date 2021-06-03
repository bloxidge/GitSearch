//
//  GetSearchRepositoriesRequest.swift
//  GitSearch
//
//  Created by Peter Bloxidge on 01/06/2021.
//

import Foundation

class GetSearchRepositoriesRequest: Request<RepositorySearchResults> {
    
    private let searchQuery: String
    private let sort: SortMethod?
    private let order: Order?
    private let perPage: Int?
    private let page: Int?
    
    override var path: String {
        return "search/repositories"
    }
    
    override var queryParameters: [String : String]? {
        return [
            "q" : searchQuery,
            "sort" : sort?.queryValue,
            "order" : order?.rawValue,
            "per_page" : String(perPage),
            "page" : String(page),
        ].compactMapValues { $0 }
    }
    
    init(searchQuery: String,
         sort: SortMethod? = nil,
         order: Order? = nil,
         perPage: Int? = nil,
         page: Int? = nil) {
        self.searchQuery = searchQuery
        self.sort = sort
        self.order = order
        self.perPage = perPage
        self.page = page
    }
}
