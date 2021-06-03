//
//  RepoDetailPresenter.swift
//  GitSearch
//
//  Created by Peter Bloxidge on 31/05/2021.
//

import Foundation

protocol RepoDetailPresenter {
    func attachToView()
}

class RepoDetailPresenterImpl: RepoDetailPresenter {
    
    weak var view: RepoDetailView!
    var interactor: RepoDetailInteractor!
    var router: RepoDetailRouter!
    
    func attachToView() {
        view.updateView(state: .initial)
    }
}
