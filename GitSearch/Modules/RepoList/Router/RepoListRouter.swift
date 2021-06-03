//
//  RepoListRouter.swift
//  GitSearch
//
//  Created by Peter Bloxidge on 31/05/2021.
//

import UIKit

protocol RepoListRouter {
    func showDetail(for repository: Repository)
}

class RepoListRouterImpl: RepoListRouter {
    
    weak var viewController: UIViewController?
    
    func showDetail(for repository: Repository) {
        let detailViewController = RepoDetailModule.build(repository: repository)
        detailViewController.modalPresentationStyle = .formSheet
        viewController?.present(detailViewController, animated: true)
    }
}
