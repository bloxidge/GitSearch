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
}

class RepoListPresenterImpl: RepoListPresenter {
    
    weak var view: RepoListView!
    var interactor: RepoListInteractor!
    var router: RepoListRouter!
    
    func attachToView() {
        view.updateView(state: .initial)
    }
}
