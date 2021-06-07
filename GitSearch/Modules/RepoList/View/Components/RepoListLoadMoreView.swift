//
//  RepoListLoadMoreView.swift
//  GitSearch
//
//  Created by Peter Bloxidge on 06/06/2021.
//

import UIKit

class RepoListLoadMoreView: UICollectionReusableView {

    static let reuseIdentifier = "load-more-view"

    private var spinner: UIActivityIndicatorView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        construct()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        construct()
    }

    private func construct() {
        spinner = UIActivityIndicatorView(style: .medium)
        spinner.hidesWhenStopped = true

        addSubview(spinner)

        spinner.autoCenterInSuperview()
    }

    func startAnimating() {
        spinner.startAnimating()
    }

    func stopAnimating() {
        spinner.stopAnimating()
    }
}
