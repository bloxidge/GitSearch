//
//  RepoListViewController.swift
//  GitSearch
//
//  Created by Peter Bloxidge on 31/05/2021.
//

import UIKit

class RepoListViewController: UIViewController {
    
    var presenter: RepoListPresenter!
}

extension RepoListViewController: RepoListView {
    
    func updateView(state: RepoListViewState) {
        switch state {
        case .initial:
            // Set up initial view state
            break
        }
    }
}
