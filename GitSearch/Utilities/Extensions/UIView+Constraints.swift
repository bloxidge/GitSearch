//
//  UIView+Constraints.swift
//  GitSearch
//
//  Created by Peter Bloxidge on 01/06/2021.
//

import UIKit

extension UIView {
    
    enum ConstraintEdge {
        case top
        case bottom
        case leading
        case trailing
    }

    @discardableResult
    func autoPinToSuperview(insetBy insets: UIEdgeInsets = .zero, excludingEdges: [ConstraintEdge] = []) -> [NSLayoutConstraint] {
        return autoPin(toView: superview!, insetBy: insets, excludingEdges: excludingEdges)
    }

    @discardableResult
    func autoPin(toView view: UIView, insetBy insets: UIEdgeInsets = .zero, excludingEdges: [ConstraintEdge] = []) -> [NSLayoutConstraint] {
        self.translatesAutoresizingMaskIntoConstraints = false

        var constraints = [NSLayoutConstraint]()
        
        if !excludingEdges.contains(.top) {
            constraints.append(topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top))
        }
        if !excludingEdges.contains(.bottom) {
            constraints.append(bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -insets.bottom))
        }
        if !excludingEdges.contains(.leading) {
            constraints.append(leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left))
        }
        if !excludingEdges.contains(.trailing) {
            constraints.append(trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -insets.right))
        }
        constraints.forEach { $0.isActive = true }
        
        return constraints
    }
    
    @discardableResult
    func autoPin(toSuperviewEdge edge: ConstraintEdge, insetBy inset: CGFloat = 0.0) -> NSLayoutConstraint {
        return autoPin(toView: superview!, edge: edge, insetBy: inset)
    }

    @discardableResult
    func autoPin(toView view: UIView, edge: ConstraintEdge, insetBy inset: CGFloat = 0.0) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let constraint: NSLayoutConstraint
        
        switch edge {
        case .top:
            constraint = topAnchor.constraint(equalTo: view.topAnchor, constant: inset)
        case .bottom:
            constraint = bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -inset)
        case .leading:
            constraint = leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset)
        case .trailing:
            constraint = trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset)
        }
        constraint.isActive = true
        
        return constraint
    }

    @discardableResult
    func autoSpace(toView view: UIView, edge: ConstraintEdge, offsetBy offset: CGFloat = 0.0) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false

        let constraint: NSLayoutConstraint
        
        switch edge {
        case .top:
            constraint = bottomAnchor.constraint(equalTo: view.topAnchor, constant: -offset)
        case .bottom:
            constraint = topAnchor.constraint(equalTo: view.bottomAnchor, constant: offset)
        case .leading:
            constraint = trailingAnchor.constraint(equalTo: view.leadingAnchor, constant: -offset)
        case .trailing:
            constraint = leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: offset)
        }
        constraint.isActive = true
        
        return constraint
    }

    @discardableResult
    func autoCenterInSuperview() -> [NSLayoutConstraint] {
        return [autoCenterXInSuperview(), autoCenterYInSuperview()]
    }

    @discardableResult
    func autoCenterXInSuperview() -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false

        let centerXConstraint = centerXAnchor.constraint(equalTo: superview!.centerXAnchor)
        centerXConstraint.isActive = true
        
        return centerXConstraint
    }

    @discardableResult
    func autoCenterYInSuperview() -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false

        let centerYConstraint = centerYAnchor.constraint(equalTo: superview!.centerYAnchor)
        centerYConstraint.isActive = true
        
        return centerYConstraint
    }

    @discardableResult
    func autoSetSize(_ size: CGSize) -> [NSLayoutConstraint] {
        return [autoSetWidth(size.width), autoSetHeight(size.height)]
    }
    
    @discardableResult
    func autoSetWidth(_ width: CGFloat) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false

        let widthConstraint = widthAnchor.constraint(equalToConstant: width)
        widthConstraint.isActive = true

        return widthConstraint
    }

    @discardableResult
    func autoSetHeight(_ height: CGFloat) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false

        let heightConstraint = heightAnchor.constraint(equalToConstant: height)
        heightConstraint.isActive = true

        return heightConstraint
    }
    
    @discardableResult
    func autoSetWidth(relativeTo view: UIView, multiplier: CGFloat) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false

        let widthConstraint = widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: multiplier)
        widthConstraint.isActive = true

        return widthConstraint
    }

    @discardableResult
    func autoSetHeight(relativeTo view: UIView, multiplier: CGFloat) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false

        let heightConstraint = heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: multiplier)
        heightConstraint.isActive = true

        return heightConstraint
    }

    @discardableResult
    func autoSetAspectRatio(matching size: CGSize) -> NSLayoutConstraint {
        guard size.width > 0 && size.height > 0 else {
            fatalError("setAspectRatio requires non-zero width and height: \(size)")
        }
        return autoSetAspectRatio(size.width / size.height)
    }

    @discardableResult
    func autoSetAspectRatio(_ aspectRatio: CGFloat) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false

        let aspectRatioConstraint = widthAnchor.constraint(equalTo: heightAnchor, multiplier: aspectRatio)
        aspectRatioConstraint.isActive = true

        return aspectRatioConstraint
    }
}
