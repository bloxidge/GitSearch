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
    func getVisibleCount() -> Int?
    func getRepository(at index: Int) -> Repository?
}

class RepoListPresenterImpl: RepoListPresenter {
    
    weak var view: RepoListView!
    var interactor: RepoListInteractor!
    var router: RepoListRouter!
    
    func attachToView() {
        view.updateView(state: .initial)
    }
    
    @discardableResult
    func performSearch(_ searchQuery: String) -> Promise<Void> {
        view.updateView(state: .loading)
        
        let promise = interactor.fetchRepoSearchResults(searchQuery)
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
    
    func getVisibleCount() -> Int? {
        interactor.results?.items.count
    }
    
    func getRepository(at index: Int) -> Repository? {
        interactor.results?.items[index]
    }
}
