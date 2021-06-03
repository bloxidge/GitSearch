//
//  RepoDetailViewController.swift
//  GitSearch
//
//  Created by Peter Bloxidge on 31/05/2021.
//

import UIKit

class RepoDetailViewController: UIViewController {

    var presenter: RepoDetailPresenter!
}

extension RepoDetailViewController: RepoDetailView {
    
    func updateView(state: RepoDetailViewState) {
        switch state {
        case .initial:
            // Set up initial view state
            break
        }
    }
}
