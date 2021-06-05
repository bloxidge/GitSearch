//
//  RepoListModule.swift
//  GitSearch
//
//  Created by Peter Bloxidge on 31/05/2021.
//

import UIKit

class RepoListModule {
    
    static func build() -> UIViewController {
        let view = RepoListViewController()
        let presenter = RepoListPresenterImpl()
        let interactor = RepoListInteractorImpl(api: ApiServiceImpl.shared)
        let router = RepoListRouterImpl()
        
        view.presenter = presenter
        
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        
        router.viewController = view
        
        return view
    }
}
