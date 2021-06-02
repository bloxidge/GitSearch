//
//  RepoListCollectionViewCell.swift
//  GitSearch
//
//  Created by Peter Bloxidge on 01/06/2021.
//

import UIKit

class RepoListCollectionViewCell: UICollectionViewCell {
    
    private let titleLabel = UILabel()
    
    var title: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(titleLabel)
        
        titleLabel.autoCenterYInSuperview()
        titleLabel.autoPin(toSuperviewEdge: .leading, insetBy: 16.0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
