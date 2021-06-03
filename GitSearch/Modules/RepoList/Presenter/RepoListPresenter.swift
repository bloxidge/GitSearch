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
    
    var selectedSortMethod: SortMethod { get }
    var selectedOrder: Order { get }
    var isReloadEnabled: Bool { get }
    
    func performSearch(_ searchQuery: String)
    func repeatLastSearch()
    func getVisibleResults() -> [Repository]
    func getVisibleCount() -> Int
    func getRepository(at index: Int) -> Repository
    func selectSortMethod(_ sortMethod: SortMethod)
    func selectOrder(_ order: Order)
}

class RepoListPresenterImpl: RepoListPresenter {
    
    weak var view: RepoListView!
    var interactor: RepoListInteractor!
    var router: RepoListRouter!
    
    private(set) var selectedSortMethod: SortMethod = .bestMatch
    private(set) var selectedOrder: Order = .descending
    var isReloadEnabled: Bool { lastSearchQuery != nil }
    private var lastSearchQuery: String?
    
    func attachToView() {
        view.updateView(state: .initial)
    }
    
    func performSearch(_ searchQuery: String) {
        view.updateView(state: .loading)
        
        lastSearchQuery = searchQuery
        
        firstly {
            interactor.fetchRepoSearchResults(searchQuery,
                                              sort: selectedSortMethod,
                                              order: selectedOrder)
        }.done { results in
            if results.items.isEmpty {
                self.view.updateView(state: .doneEmpty)
            } else {
                self.view.updateView(state: .doneResults)
            }
        }.catch { error in
            print(error)
            self.view.updateView(state: .error)
        }
    }
    
    func repeatLastSearch() {
        if let searchQuery = lastSearchQuery {
            performSearch(searchQuery)
        }
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
    
    func selectSortMethod(_ sortMethod: SortMethod) {
        if sortMethod != selectedSortMethod {
            selectedSortMethod = sortMethod
            repeatLastSearch()
        }
    }
    
    func selectOrder(_ order: Order) {
        if order != selectedOrder {
            selectedOrder = order
            repeatLastSearch()
        }
    }
}
