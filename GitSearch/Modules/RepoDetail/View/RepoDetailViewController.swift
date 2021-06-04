//
//  RepoDetailViewController.swift
//  GitSearch
//
//  Created by Peter Bloxidge on 31/05/2021.
//

import UIKit

class RepoDetailViewController: UIViewController {
    
    var headerView: UIView!
    var titleLabel: UILabel!
    var descriptionLabel: UILabel!
    var iconImageView: UIImageView!
    var starsLabel: IconLabel!
    var forksLabel: IconLabel!
    var lastUpdatedLabel: UILabel!

    var presenter: RepoDetailPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHeaderView()
        configureMainView()
        
        presenter.attachToView()
    }
    
    private func configureHeaderView() {
        view.backgroundColor = .systemBackground
        
        titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 24, weight: .heavy)
        titleLabel.numberOfLines = 0
        
        descriptionLabel = UILabel()
        descriptionLabel.font = .systemFont(ofSize: 16, weight: .bold)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 0
        
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
        
        let headerStack = UIStackView(arrangedSubviews: [closeButtonImageStack, titleLabel, descriptionLabel])
        headerStack.axis = .vertical
        headerStack.spacing = 8
        
        headerView = UIView()
        headerView.backgroundColor = UIColor(named: "AccentColor")?.withAlphaComponent(0.6)
        headerView.addSubview(headerStack)
        
        view.addSubview(headerView)
        
        headerStack.autoPin(toSafeAreaEdge: .top, insetBy: 16)
        headerStack.autoPin(toSafeAreaEdge: .leading, insetBy: 16)
        headerStack.autoPinToSafeArea(insetBy: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
        headerView.autoPinToSuperview(excludingEdges: [.bottom])
    }
    
    private func configureMainView() {
        starsLabel = IconLabel()
        starsLabel.font = .systemFont(ofSize: 16)
        starsLabel.icon = UIImage(named: "star-24")
        
        forksLabel = IconLabel()
        forksLabel.font = .systemFont(ofSize: 16)
        forksLabel.icon = UIImage(named: "repo-forked-24")
        
        lastUpdatedLabel = UILabel()
        lastUpdatedLabel.font = .italicSystemFont(ofSize: 16)
        
        let starsForksStack = UIStackView(arrangedSubviews: [starsLabel, forksLabel])
        starsForksStack.spacing = 24
        
        let infoLabelsStack = UIStackView(arrangedSubviews: [starsForksStack, lastUpdatedLabel])
        infoLabelsStack.spacing = 8
        infoLabelsStack.axis = .vertical
        infoLabelsStack.alignment = .leading
        
        view.addSubview(infoLabelsStack)
        
        infoLabelsStack.autoCenterXInSafeArea()
        infoLabelsStack.autoPin(toSafeAreaEdge: .leading, insetBy: 16)
        infoLabelsStack.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 8).isActive = true//(equalTo: viewOrLayoutGuide.topAnchor, constant: inset)
    }
    
    private func closeButtonActionHandler(_ action: UIAction) {
        presenter.didPressClose()
    }
}

extension RepoDetailViewController: RepoDetailView {
    
    func updateView(state: RepoDetailViewState) {
        switch state {
        case .initial(let repository):
            
            titleLabel.text = repository.fullName
            
            if let description = repository.description, !description.isEmpty {
                descriptionLabel.text = description
            } else {
                descriptionLabel.isHidden = true
            }
            
            if let imageUrl = URL(string: repository.owner?.avatarUrl) {
                iconImageView.kf.setImage(with: imageUrl)
            } else {
                iconImageView.isHidden = true
            }
            
            starsLabel.text = "\(repository.stargazersCount.metricString) stars"
            forksLabel.text = "\(repository.forksCount.metricString) forks"
            lastUpdatedLabel.text = "Updated \(repository.updatedAt.timeAgo)"
        }
    }
}
