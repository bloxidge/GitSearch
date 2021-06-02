//
//  RepoListViewController.swift
//  GitSearch
//
//  Created by Peter Bloxidge on 31/05/2021.
//

import UIKit

class RepoListViewController: UICollectionViewController {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Int, Repository>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Repository>
    
    lazy var dataSource: DataSource = {
        DataSource(collectionView: collectionView) { collectionView, indexPath, repository in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RepoListCell",
                                                          for: indexPath) as? RepoListCollectionViewCell
            cell?.title = repository.fullName
            return cell
        }
    }()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var presenter: RepoListPresenter!
    
    convenience init() {
        self.init(collectionViewLayout: Self.createCompositionalLayout())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Repositories"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        configureViews()
        configureSearchController()
        
        presenter.attachToView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.performSearch("Alamofire")
    }
    
    private func configureViews() {
        collectionView.backgroundColor = .systemBackground
        collectionView.register(RepoListCollectionViewCell.self, forCellWithReuseIdentifier: "RepoListCell")
    }
    
    private func configureSearchController() {
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search Repositories"
        navigationItem.searchController = searchController
    }
    
    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(presenter.getVisibleResults())
        
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

// MARK: - RepoListView

extension RepoListViewController: RepoListView {
    
    func updateView(state: RepoListViewState) {
        LoadingSpinner.stop()
        
        switch state {
        case .initial:
            break
        case .loading:
            LoadingSpinner.start()
        case .doneResults:
            applySnapshot()
        case .doneEmpty:
            break
        case .error:
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

extension RepoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text, !searchText.isEmpty {
            presenter.performSearch(searchText)
            searchController.dismiss(animated: true)
        }
    }
}
