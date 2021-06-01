//
//  RepoListViewController.swift
//  GitSearch
//
//  Created by Peter Bloxidge on 31/05/2021.
//

import UIKit

class RepoListViewController: UICollectionViewController {
    
    var presenter: RepoListPresenter!
//    lazy var dataSource: DataSource = buildDataSource()
//
//    typealias DataSource = UICollectionViewDiffableDataSource<Int, Repository>
    
    convenience init() {
        self.init(collectionViewLayout: Self.createCompositionalLayout())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Repositories"
        
        setUpCollectionView()
        
        presenter.attachToView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.performSearch("Alamofire")
    }
    
    private func setUpCollectionView() {
        collectionView.backgroundColor = .systemBackground
        collectionView.register(RepoListCollectionViewCell.self, forCellWithReuseIdentifier: "RepoListCell")
    }
}

// MARK: - RepoListView

extension RepoListViewController: RepoListView {
    
    func updateView(state: RepoListViewState) {
        switch state {
        case .initial:
            break
        case .loading:
            break
        case .doneResults:
            collectionView.reloadData()
            break
        case .doneEmpty:
            break
        case .error:
            break
        }
    }
}

// MARK: - UICollectionViewDataSource

extension RepoListViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.getVisibleCount() ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let repository = presenter.getRepository(at: indexPath.item)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RepoListCell", for: indexPath) as! RepoListCollectionViewCell
        cell.title = repository?.fullName
        return cell
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
