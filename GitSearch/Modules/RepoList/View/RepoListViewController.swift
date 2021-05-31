//
//  RepoListViewController.swift
//  GitSearch
//
//  Created by Peter Bloxidge on 31/05/2021.
//

import UIKit

class RepoListViewController: UICollectionViewController {
    
    var presenter: RepoListPresenter!
    
    convenience init() {
        self.init(collectionViewLayout: Self.createCompositionalLayout())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Repositories"
        
        setUpCollectionView()
        
        presenter.attachToView()
    }
    
    private func setUpCollectionView() {
        collectionView.backgroundColor = .systemBackground
    }
}

// MARK: - RepoListView

extension RepoListViewController: RepoListView {
    
    func updateView(state: RepoListViewState) {
        switch state {
        case .initial:
            // Set up initial view state
            break
        }
    }
}

// MARK: - UICollectionViewCompositionalLayout

extension RepoListViewController {
    
    static func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(80)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 1
        )
        let spacing: CGFloat = 8
        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
