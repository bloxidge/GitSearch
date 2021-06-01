//
//  RepoListCollectionViewCell.swift
//  GitSearch
//
//  Created by Peter Bloxidge on 01/06/2021.
//

import UIKit

class RepoListCollectionViewCell: UICollectionViewCell {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var title: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(titleLabel)
        
        titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
