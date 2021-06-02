//
//  RepoListPresenter.swift
//  GitSearch
//
//  Created by Peter Bloxidge on 31/05/2021.
//

import Foundation
import PromiseKit

protocol RepoListPresenter {
    func attachToView()
    
    @discardableResult
    func performSearch(_ searchQuery: String) -> Promise<Void>
    func getVisibleResults() -> [Repository]
    func getVisibleCount() -> Int
    func getRepository(at index: Int) -> Repository
    
    var selectedSortMethod: SortMethod { get }
    var selectedOrder: Order { get }
    
    func selectSortMethod(_ sortMethod: SortMethod)
    func selectOrder(_ order: Order)
}

class RepoListPresenterImpl: RepoListPresenter {
    
    weak var view: RepoListView!
    var interactor: RepoListInteractor!
    var router: RepoListRouter!
    
    private(set) var selectedSortMethod: SortMethod = .bestMatch
    private(set) var selectedOrder: Order = .descending
    private var lastSearchQuery: String?
    
    func attachToView() {
        view.updateView(state: .initial)
    }
    
    func selectSortMethod(_ sortMethod: SortMethod) {
        selectedSortMethod = sortMethod
        repeatLastSearch()
    }
    
    func selectOrder(_ order: Order) {
        selectedOrder = order
        repeatLastSearch()
    }
    
    private func repeatLastSearch() {
        if let searchQuery = lastSearchQuery {
            performSearch(searchQuery)
        }
    }
    
    @discardableResult
    func performSearch(_ searchQuery: String) -> Promise<Void> {
        view.updateView(state: .loading)
        
        lastSearchQuery = searchQuery
        
        let promise = interactor.fetchRepoSearchResults(searchQuery,
                                                        sort: selectedSortMethod,
                                                        order: selectedOrder)
        promise
            .done { results in
                if results.items.isEmpty {
                    self.view.updateView(state: .doneEmpty)
                } else {
                    self.view.updateView(state: .doneResults)
                }
            }
            .catch { error in
                print(error)
                self.view.updateView(state: .error)
            }
        return promise.asVoid()
    }
    
    func getVisibleResults() -> [Repository] {
        interactor.results?.items ?? []
    }
    
    func getVisibleCount() -> Int {
        getVisibleResults().count
    }
    
    func getRepository(at index: Int) -> Repository {
        getVisibleResults()[index]
    }
}
