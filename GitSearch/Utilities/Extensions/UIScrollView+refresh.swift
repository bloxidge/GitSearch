//
//  UIScrollView+refresh.swift
//  GitSearch
//
//  Created by Peter Bloxidge on 31/05/2021.
//

import UIKit

extension UIScrollView {
    
    func addRefreshControl(onRefresh: @escaping () -> Void) {
        let refreshControl = UIRefreshControl()
        let generator = UIImpactFeedbackGenerator(style: .light)
        let action = UIAction { _ in
            generator.impactOccurred()
            onRefresh()
        }
        refreshControl.addAction(action, for: .valueChanged)
        self.refreshControl = refreshControl
    }
    
    func removeRefreshControl() {
        self.refreshControl = nil
    }

    func beginRefreshing(animated: Bool = true) {
        guard let refreshControl = refreshControl, !refreshControl.isRefreshing else {
            return
        }
        refreshControl.beginRefreshing()
        refreshControl.sendActions(for: .valueChanged)
        let contentOffset = CGPoint(x: 0, y: -refreshControl.frame.height)
        setContentOffset(contentOffset, animated: animated)
    }

    func endRefreshing(after seconds: TimeInterval = 0) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.refreshControl?.endRefreshing()
        }
    }
    
    var isRefreshing: Bool {
        refreshControl?.isRefreshing ?? false
    }
}
