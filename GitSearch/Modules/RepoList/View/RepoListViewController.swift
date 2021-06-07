//
//  RepoListViewController.swift
//  GitSearch
//
//  Created by Peter Bloxidge on 31/05/2021.
//

import UIKit

class RepoListViewController: UIViewController {
    
    struct Constants {
        static let spacing: CGFloat = 16
        static let cellHeight: CGFloat = 80
        static let loadMoreViewHeight: CGFloat = 60
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Int, Repository>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Repository>
    
    lazy var dataSource: DataSource = {
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, repository in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RepoListCollectionViewCell.reuseIdentifier,
                                                          for: indexPath) as? RepoListCollectionViewCell
            cell?.title = repository.name
            cell?.author = repository.owner?.login
            cell?.avatarUrl = URL(string: repository.owner?.avatarUrl)
            return cell
        }
        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            let view =  collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                        withReuseIdentifier: RepoListLoadMoreView.reuseIdentifier,
                                                                        for: indexPath) as? RepoListLoadMoreView
            self?.loadMoreView = view
            return view
        }
        return dataSource
    }()
    
    var collectionView: UICollectionView!
    var noResultsLabel: UILabel!
    var searchController: UISearchController!
    var reloadButton: UIBarButtonItem!
    var sortButton: UIBarButtonItem!
    var loadMoreView: RepoListLoadMoreView?
    
    var presenter: RepoListPresenter!

    private var isScrollLoading: Bool = false
    
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
        collectionView.delegate = self
        collectionView.register(RepoListCollectionViewCell.self,
                                forCellWithReuseIdentifier: RepoListCollectionViewCell.reuseIdentifier)
        collectionView.register(RepoListLoadMoreView.self,
                                forSupplementaryViewOfKind: RepoListLoadMoreView.reuseIdentifier,
                                withReuseIdentifier: RepoListLoadMoreView.reuseIdentifier)
        collectionView.backgroundColor = .systemBackground
        collectionView.clipsToBounds = false
        
        noResultsLabel = UILabel()
        noResultsLabel.text = "No results found"
        noResultsLabel.textColor = .secondaryLabel
        noResultsLabel.font = .boldSystemFont(ofSize: 16.0)
        
        view.addSubview(collectionView)
        view.addSubview(noResultsLabel)
        
        collectionView.autoPinToSuperview(insetBy: .init(top: 0,
                                                         leading: Constants.spacing,
                                                         bottom: 0,
                                                         trailing: Constants.spacing))
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
    
    private func presentErrorAlert(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let retryAction = UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
            self?.presenter.repeatLastSearch()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(retryAction)
        present(alertController, animated: true)
    }
}

// MARK: - RepoListView

extension RepoListViewController: RepoListView {
    
    func updateView(state: RepoListViewState) {
        hideLoadingSpinner()
        loadMoreView?.stopAnimating()
        reloadButton.isEnabled = presenter.isReloadEnabled
        collectionView.isUserInteractionEnabled = true
        
        switch state {
        case .initial:
            noResultsLabel.isHidden = true
            
        case .loading:
            collectionView.isUserInteractionEnabled = false
            showLoadingSpinner()
            
        case .scrollLoading:
            collectionView.isUserInteractionEnabled = false
            loadMoreView?.startAnimating()

        case .doneResults:
            noResultsLabel.isHidden = true
            applySnapshot()
            
        case .doneEmpty:
            noResultsLabel.isHidden = false
            applySnapshot(animatingDifferences: false)
            
        case .error:
            noResultsLabel.isHidden = true
            presentErrorAlert(message: "Oops, something went wrong. Please try again.")
        }
    }
}

// MARK: - Layout

extension RepoListViewController {
    
    private func createCompositionalLayout(for size: CGSize) -> UICollectionViewCompositionalLayout {
        func getCountPerRow(portrait: Bool, isPad: Bool) -> Int {
            switch (portrait, isPad) {
            case (true, false): return 1
            case (false, false), (true, true): return 2
            case (false, true): return 3
            }
        }
        let loadMoreSupplementaryItem = createLoadMoreItem()
        
        return UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(Constants.cellHeight)
            )
            let itemCount = getCountPerRow(portrait: size.width < size.height,
                                           isPad: layoutEnvironment.traitCollection.userInterfaceIdiom == .pad)
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitem: item,
                count: itemCount
            )
            group.interItemSpacing = .fixed(Constants.spacing)
            
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = [loadMoreSupplementaryItem]
            section.interGroupSpacing = Constants.spacing
        
            return section
        }
    }

    private func createLoadMoreItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(Constants.loadMoreViewHeight)
        )
        return NSCollectionLayoutBoundarySupplementaryItem(layoutSize: itemSize,
                                                           elementKind: RepoListLoadMoreView.reuseIdentifier,
                                                           alignment: .bottom,
                                                           absoluteOffset: .init(x: 0, y: 8))
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

// MARK: - Selection

extension RepoListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedRepository = presenter.getRepository(at: indexPath.item)
        presenter.didSelect(repository: selectedRepository)
    }
}

// MARK: - Load More

extension RepoListViewController {

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let contentSize = scrollView.contentSize.height
        let viewSize = scrollView.frame.size.height - scrollView.contentInset.top - scrollView.contentInset.bottom
        let scrollLoadingEnabled = contentSize > viewSize

        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height

        if scrollLoadingEnabled, currentOffset > maximumOffset {
            presenter.showMoreResults()
        }
    }
}
