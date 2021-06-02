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
    var reloadButton: UIBarButtonItem!
    var sortButton: UIBarButtonItem!
    
    var presenter: RepoListPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Repositories"
        
        configureViews()
        configureSearchController()
        configureBarButtons()
        
        presenter.attachToView()
    }
    
    private func configureViews() {
        view.backgroundColor = .systemBackground
        
        collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: createCompositionalLayout(for: view.bounds.size))
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
    
    private func configureBarButtons() {
        let reloadAction = UIAction { [weak self] _ in
            self?.presenter.repeatLastSearch()
        }
        let reloadButton = UIBarButtonItem(image: UIImage(systemName: "arrow.triangle.2.circlepath"),
                                           primaryAction: reloadAction)
        let sortButton = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down"),
                                         menu: getSortMenu())
        
        self.reloadButton = reloadButton
        self.sortButton = sortButton
        
        navigationItem.rightBarButtonItems = [reloadButton, sortButton]
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
        reloadButton.isEnabled = presenter.isReloadEnabled
        
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
    
    private func createCompositionalLayout(for size: CGSize) -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(160)
        )
        let isPortrait = size.width < size.height
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: isPortrait ? 1 : 2
        )
        let spacing: CGFloat = 8
        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { [weak self] context in
            guard let self = self else { return }
            self.collectionView.collectionViewLayout = self.createCompositionalLayout(for: size)
        })
    }
}

// MARK: - Search

extension RepoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text, !searchText.isEmpty {
            presenter.performSearch(searchText)
            searchController.dismiss(animated: true)
        }
    }
}

// MARK: - Sort

extension RepoListViewController {
    
    private func updateSortMenu() {
        sortButton.menu = getSortMenu()
    }
    
    private func getSortMenu() -> UIMenu {
        let sortActions = SortMethod.allCases.map { method -> UIMenuElement in
            let isSelected = presenter.selectedSortMethod == method
            return UIAction(title: method.title,
                            state: isSelected ? .on : .off) { [weak self] _ in
                self?.presenter.selectSortMethod(method)
                self?.updateSortMenu()
            }
        }
        let isSortBestMatch = presenter.selectedSortMethod == .bestMatch
        let orderActions = Order.allCases.map { order -> UIMenuElement in
            let isSelected = presenter.selectedOrder == order
            return UIAction(title: order.title,
                            attributes: isSortBestMatch ? .hidden : [],
                            state: isSelected ? .on : .off) { [weak self] _ in
                self?.presenter.selectOrder(order)
                self?.updateSortMenu()
            }
        }
        
        return UIMenu(title: "Sort", children: [
            UIMenu(options: .displayInline, children: sortActions),
            UIMenu(options: .displayInline, children: orderActions)
        ])
    }
}
