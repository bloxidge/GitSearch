//
//  RepoDetailRouter.swift
//  GitSearch
//
//  Created by Peter Bloxidge on 31/05/2021.
//

import UIKit

protocol RepoDetailRouter {
    func dismissDetail()
}

class RepoDetailRouterImpl: RepoDetailRouter {
    
    weak var viewController: UIViewController?
    
    func dismissDetail() {
        viewController?.dismiss(animated: true, completion: nil)
    }
}
