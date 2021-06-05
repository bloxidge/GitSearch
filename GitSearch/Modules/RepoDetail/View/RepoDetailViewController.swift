//
//  RepoDetailViewController.swift
//  GitSearch
//
//  Created by Peter Bloxidge on 31/05/2021.
//

import UIKit
import MarkdownView

class RepoDetailViewController: UIViewController {
    
    var titleLabel: UILabel!
    var descriptionLabel: UILabel!
    var iconImageView: UIImageView!
    var starsLabel: IconLabel!
    var forksLabel: IconLabel!
    var lastUpdatedLabel: UILabel!
    var mainView: UIView!
    var markdownView: MarkdownView!

    var presenter: RepoDetailPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        
        presenter.attachToView()
        presenter.loadReadme()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func configureViews() {
        view.backgroundColor = .systemBackground
        
        let headerView = createHeaderView()
        let infoLabelStack = createInfoLabelStack()
        let readmeView = createReadmeView()
        mainView = UIView()
        
        view.addSubview(headerView)
        view.addSubview(mainView)
        mainView.addSubview(infoLabelStack)
        mainView.addSubview(readmeView)
        
        headerView.autoPinToSuperview(excludingEdges: [.bottom])
        
        infoLabelStack.autoCenterXInSafeArea()
        infoLabelStack.autoPin(toSafeAreaEdge: .leading, insetBy: 16)
        infoLabelStack.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 8).isActive = true
        
        readmeView.autoPinToSafeArea(excludingEdges: [.top, .bottom])
        readmeView.autoPin(toSuperviewEdge: .bottom)
        readmeView.topAnchor.constraint(equalTo: infoLabelStack.bottomAnchor, constant: 16).isActive = true
        
        mainView.autoPinToSuperview(excludingEdges: [.top])
        mainView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
    }
    
    private func createHeaderView() -> UIView {
        titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 24, weight: .heavy)
        titleLabel.numberOfLines = 0
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        
        descriptionLabel = UILabel()
        descriptionLabel.font = .systemFont(ofSize: 16, weight: .bold)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 0
        descriptionLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        
        iconImageView = UIImageView()
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.clipsToBounds = true
        iconImageView.autoSetAspectRatio(1)
        iconImageView.autoSetWidth(36)
        iconImageView.kf.indicatorType = .activity
        
        let imageContainer = UIView()
        imageContainer.backgroundColor = .white
        imageContainer.cornerRadius = 4
        imageContainer.shadowRadius = 4
        imageContainer.shadowColor = .black
        imageContainer.shadowOpacity = 0.6
        imageContainer.shadowOffset = .init(x: -2, y: 2)
        imageContainer.addSubview(iconImageView)
        
        iconImageView.autoPinToSuperview(insetBy: UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4))
        
        let closeButton = UIButton(type: .close, primaryAction: UIAction(handler: closeButtonActionHandler))
        
        let closeButtonImageStack = UIStackView(arrangedSubviews: [closeButton, imageContainer])
        closeButtonImageStack.distribution = .equalSpacing
        closeButtonImageStack.alignment = .top
        
        closeButtonImageStack.autoPin(toView: closeButton, edge: .bottom).priority = .defaultLow
        closeButtonImageStack.autoPin(toView: imageContainer, edge: .bottom)
        
        let headerStack = UIStackView(arrangedSubviews: [closeButtonImageStack, titleLabel, descriptionLabel])
        headerStack.axis = .vertical
        headerStack.spacing = 8
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "AccentColor")?.withAlphaComponent(0.6)
        headerView.addSubview(headerStack)
        
        headerStack.autoPin(toSafeAreaEdge: .top, insetBy: 16)
        headerStack.autoPin(toSafeAreaEdge: .leading, insetBy: 16)
        headerStack.autoPinToSafeArea(insetBy: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
        
        return headerView
    }
    
    private func createInfoLabelStack() -> UIView {
        starsLabel = IconLabel()
        starsLabel.font = .systemFont(ofSize: 16)
        starsLabel.icon = UIImage(named: "star-24")
        
        forksLabel = IconLabel()
        forksLabel.font = .systemFont(ofSize: 16)
        forksLabel.icon = UIImage(named: "repo-forked-24")
        
        lastUpdatedLabel = UILabel()
        lastUpdatedLabel.font = .italicSystemFont(ofSize: 16)
        lastUpdatedLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        
        let starsForksStack = UIStackView(arrangedSubviews: [starsLabel, forksLabel])
        starsForksStack.spacing = 24
        
        let infoLabelStack = UIStackView(arrangedSubviews: [starsForksStack, lastUpdatedLabel])
        infoLabelStack.spacing = 8
        infoLabelStack.axis = .vertical
        infoLabelStack.alignment = .leading
        
        return infoLabelStack
    }
    
    private func createReadmeView() -> UIView {
        markdownView = MarkdownView()
        markdownView.isScrollEnabled = true

        markdownView.onTouchLink = { urlRequest in
            if let url = urlRequest.url, UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
            return false
        }
        
        return markdownView
    }
    
    private func closeButtonActionHandler(_ action: UIAction) {
        presenter.didPressClose()
    }
}

extension RepoDetailViewController: RepoDetailView {
    
    func updateView(state: RepoDetailViewState) {
        mainView.hideLoadingSpinner()
        
        switch state {
        case .initial:
            let repo = presenter.repository
            
            titleLabel.text = repo.fullName
            
            if let description = repo.description, !description.isEmpty {
                descriptionLabel.text = description
            } else {
                descriptionLabel.isHidden = true
            }
            
            if let imageUrl = URL(string: repo.owner?.avatarUrl) {
                iconImageView.kf.setImage(with: imageUrl)
            } else {
                iconImageView.isHidden = true
            }
            
            starsLabel.text = "\(repo.stargazersCount.metricString) stars"
            forksLabel.text = "\(repo.forksCount.metricString) forks"
            lastUpdatedLabel.text = "Updated \(repo.updatedAt.timeAgo)"
            
        case .loading:
            mainView.showLoadingSpinner()
            
        case .readmeSuccess:
            markdownView.load(markdown: presenter.getRawReadme())
            
        case .readmeNotFound:
            break
            
        case .error:
            break
        }
    }
}
