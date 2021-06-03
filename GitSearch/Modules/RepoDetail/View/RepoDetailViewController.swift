//
//  RepoDetailViewController.swift
//  GitSearch
//
//  Created by Peter Bloxidge on 31/05/2021.
//

import UIKit

class RepoDetailViewController: UIViewController {
    
    var titleLabel: UILabel!

    var presenter: RepoDetailPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        
        presenter.attachToView()
    }
    
    private func configureViews() {
        view.backgroundColor = .systemBackground
        
        titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 32, weight: .heavy)
        view.addSubview(titleLabel)
        
        titleLabel.autoCenterXInSuperview()
        titleLabel.autoPin(toSuperviewEdge: .top, insetBy: 16)
        titleLabel.autoPin(toSuperviewEdge: .leading, insetBy: 16)
    }
}

extension RepoDetailViewController: RepoDetailView {
    
    func updateView(state: RepoDetailViewState) {
        switch state {
        case .initial(let repository):
            titleLabel.text = repository.fullName
        }
    }
}
