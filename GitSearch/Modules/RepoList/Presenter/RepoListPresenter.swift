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
    
    @discardableResult
    func performSearch(_ searchQuery: String) -> Promise<Void>
    @discardableResult
    func repeatLastSearch() -> Promise<Void>
    @discardableResult
    func showMoreResults() -> Promise<Void>

    func getVisibleResults() -> [Repository]
    func getVisibleCount() -> Int
    func getRepository(at index: Int) -> Repository
    func selectSortMethod(_ sortMethod: SortMethod)
    func selectOrder(_ order: Order)
    func didSelect(repository: Repository)
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
    
    @discardableResult
    func performSearch(_ searchQuery: String) -> Promise<Void> {
        view.updateView(state: .loading)
        
        lastSearchQuery = searchQuery
        
        let promise = interactor.fetchRepoSearchResults(searchQuery,
                                                        sort: selectedSortMethod,
                                                        order: selectedOrder)
            .done { initialResults in
                if initialResults.items.isEmpty {
                    self.view.updateView(state: .doneEmpty)
                } else {
                    self.view.updateView(state: .doneResults)
                }
            }
        
        promise
            .catch { error in
                print(error)
                self.view.updateView(state: .error)
            }
        
        return promise
    }
    
    @discardableResult
    func repeatLastSearch() -> Promise<Void> {
        guard let searchQuery = lastSearchQuery else {
            return .value(())
        }
        return performSearch(searchQuery)
    }

    @discardableResult
    func showMoreResults() -> Promise<Void> {
        view?.updateView(state: .scrollLoading)
        
        let promise = interactor.fetchNextPageResults()
            .done { _ in
                self.view.updateView(state: .doneResults)
            }

        promise
            .catch { error in
                print(error)
                self.view.updateView(state: .error)
            }

        return promise
    }
    
    func getVisibleResults() -> [Repository] {
        interactor.fullResults?.items ?? []
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
    
    func didSelect(repository: Repository) {
        router.presentDetail(for: repository)
    }
}
