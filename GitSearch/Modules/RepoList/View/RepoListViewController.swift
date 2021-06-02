//
//  RepoListViewController.swift
//  GitSearch
//
//  Created by Peter Bloxidge on 31/05/2021.
//

import UIKit

class RepoListViewController: UIViewController {
    
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
    
    var collectionView: UICollectionView!
    var noResultsLabel: UILabel!
    var searchController: UISearchController!
    
    var presenter: RepoListPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Repositories"
        
        configureViews()
        configureSearchController()
        
        presenter.attachToView()
    }
    
    private func configureViews() {
        view.backgroundColor = .systemBackground
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
        collectionView.dataSource = dataSource
        collectionView.register(RepoListCollectionViewCell.self, forCellWithReuseIdentifier: "RepoListCell")
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.autoPinToSuperview()
        
        noResultsLabel = UILabel()
        noResultsLabel.text = "No results found"
        noResultsLabel.textColor = .secondaryLabel
        noResultsLabel.font = .boldSystemFont(ofSize: 16.0)
        view.addSubview(noResultsLabel)
        noResultsLabel.autoCenterInSuperview()
    }
    
    private func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
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
            noResultsLabel.isHidden = true
        case .loading:
            LoadingSpinner.start()
        case .doneResults:
            noResultsLabel.isHidden = true
            applySnapshot()
        case .doneEmpty:
            noResultsLabel.isHidden = false
            applySnapshot(animatingDifferences: false)
        case .error:
            break
        }
    }
}

// MARK: - Layout

extension RepoListViewController {
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
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
