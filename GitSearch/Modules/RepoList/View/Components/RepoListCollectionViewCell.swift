//
//  RepoListCollectionViewCell.swift
//  GitSearch
//
//  Created by Peter Bloxidge on 01/06/2021.
//

import UIKit
import Kingfisher

class RepoListCollectionViewCell: UICollectionViewCell {
    
    private var titleLabel: UILabel!
    private var authorLabel: UILabel!
    private var authorAvatarView: UIImageView!
    
    var title: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }
    var author: String? {
        get { authorLabel.text }
        set { authorLabel.text = newValue }
    }
    var avatarUrl: URL? {
        didSet {
            authorAvatarView.kf.setImage(with: avatarUrl,
                                         options: [.transition(.fade(0.2))])
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            let color: UIColor = isHighlighted ? .tertiarySystemFill : .systemBackground
            UIView.animate(withDuration: 0.1) {
                self.backgroundColor = color
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        construct()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        construct()
    }
    
    private func construct() {
        clipsToBounds = false
        
        backgroundColor = .systemBackground
        
        cornerRadius = 16
        shadowRadius = 8
        shadowColor = .secondarySystemFill
        shadowOpacity = 1
        shadowOffset = .init(x: 0, y: 0)
        
        titleLabel = UILabel()
        titleLabel.font = .boldSystemFont(ofSize: 18)
        
        authorLabel = UILabel()
        authorLabel.font = .italicSystemFont(ofSize: 18)
        authorLabel.textColor = .secondaryLabel
        
        authorAvatarView = UIImageView()
        authorAvatarView.contentMode = .scaleAspectFit
        authorAvatarView.clipsToBounds = true
        authorAvatarView.autoSetAspectRatio(1)
        authorAvatarView.autoSetWidth(48)
        authorAvatarView.cornerRadius = 8
        authorAvatarView.kf.indicatorType = .activity
        
        let labelStack = UIStackView(arrangedSubviews: [authorLabel, titleLabel])
        labelStack.axis = .vertical
        labelStack.spacing = 8
        
        let mainStack = UIStackView(arrangedSubviews: [authorAvatarView, labelStack])
        mainStack.spacing = 16
        mainStack.alignment = .center
        
        contentView.addSubview(mainStack)
        
        mainStack.autoCenterYInSuperview()
        mainStack.autoPin(toSuperviewEdge: .leading, insetBy: 20)
        mainStack.autoPin(toSuperviewEdge: .trailing, insetBy: 8)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        title = nil
        author = nil
        avatarUrl = nil
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            shadowColor = .secondarySystemFill
        }
    }
}
