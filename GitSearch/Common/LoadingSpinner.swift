//
//  LoadingSpinner.swift
//  GitSearch
//
//  Created by Peter Bloxidge on 01/06/2021.
//

import UIKit

class LoadingSpinner: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        construct()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        construct()
    }
    
    private func construct() {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let backgroundView = UIVisualEffectView(effect: blurEffect)
        addSubview(backgroundView)
        addSubview(activityIndicator)
        
        backgroundView.autoPinToSuperview()
        activityIndicator.autoCenterInSuperview()
        activityIndicator.startAnimating()
    }
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.color = .white
        indicator.style = .large
        indicator.hidesWhenStopped = false
        return indicator
    }()
    private var animator: UIViewPropertyAnimator?

    fileprivate func fadeIn(completion: ((Bool) -> Void)? = nil) {
        animateToAlpha(1.0, completion: completion)
    }
     
    fileprivate func fadeOut(completion: ((Bool) -> Void)? = nil) {
        animateToAlpha(0.0, completion: completion)
    }
    
    private func animateToAlpha(_ alpha: CGFloat, completion: ((Bool) -> Void)? = nil) {
        animator?.stopAnimation(true)
        animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) {
            self.alpha = alpha
        }
        animator?.addCompletion { position in
            completion?(position == .end)
            self.animator = nil
        }
        animator?.startAnimation()
    }
}

extension UIViewController {
    
    private var parentView: UIView {
        return (isBeingPresented ? view : navigationController?.view) ?? view
    }

    func showLoadingSpinner() {
        let loadingSpinner: LoadingSpinner
        
        if let existingSpinner = existingSpinner {
            loadingSpinner = existingSpinner
        } else {
            loadingSpinner = LoadingSpinner()
            loadingSpinner.alpha = 0
            
            parentView.addSubview(loadingSpinner)
            parentView.bringSubviewToFront(loadingSpinner)
            loadingSpinner.autoPinToSuperview()
        }
        
        loadingSpinner.fadeIn()
    }

    func hideLoadingSpinner() {
        if let loadingSpinner = existingSpinner {
            loadingSpinner.fadeOut() { complete in
                if complete {
                    loadingSpinner.removeFromSuperview()
                }
            }
        }
    }
    
    private var existingSpinner: LoadingSpinner? {
        return parentView.subviews.first(where: { $0 is LoadingSpinner }) as? LoadingSpinner
    }
}
