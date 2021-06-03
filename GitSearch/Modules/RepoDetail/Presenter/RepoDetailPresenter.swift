//
//  RepoDetailPresenter.swift
//  GitSearch
//
//  Created by Peter Bloxidge on 31/05/2021.
//

import Foundation

protocol RepoDetailPresenter {
    func attachToView()
    func didPressClose()
}

class RepoDetailPresenterImpl: RepoDetailPresenter {
    
    weak var view: RepoDetailView!
    var interactor: RepoDetailInteractor!
    var router: RepoDetailRouter!
    
    let repository: Repository
    
    init(repository: Repository) {
        self.repository = repository
    }
    
    func attachToView() {
        view.updateView(state: .initial(repository))
    }
    
    func didPressClose() {
        router.dismissDetail()
    }
}
