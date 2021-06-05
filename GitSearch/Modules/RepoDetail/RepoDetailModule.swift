//
//  RepoDetailModule.swift
//  GitSearch
//
//  Created by Peter Bloxidge on 31/05/2021.
//

import UIKit

class RepoDetailModule {
    
    static func build(repository: Repository) -> UIViewController {
        let view = RepoDetailViewController()
        let interactor = RepoDetailInteractorImpl(api: ApiServiceImpl.shared)
        let presenter = RepoDetailPresenterImpl(repository: repository)
        let router = RepoDetailRouterImpl()
        
        view.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        router.viewController = view
        
        return view
    }
}
